local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local vide = require("@vide")
local Window = require("./Window")

local source = vide.source

local PixlLib = {}

-- Every element that carries a Flag, keyed by it. This is what the config reads and writes,
-- and what you index to reach an element from anywhere: PixlLib.Flags.AutoFarm:Set(true)
PixlLib.Flags = {}

-- Written to the config file so a future format change can migrate instead of guessing
local CONFIG_VERSION = 1

-- Executors expose these as globals; Studio does not, in which case they read as nil.
-- Everything file-related goes through this table, so exactly one place knows whether saving
-- is possible at all - the rest of the library never has to ask.
local fs = {
	read = readfile,
	write = writefile,
	isFile = isfile,
	isFolder = isfolder,
	makeFolder = makefolder,
}

local function canWrite(): boolean
	return fs.write ~= nil and fs.isFolder ~= nil and fs.makeFolder ~= nil
end

local function canRead(): boolean
	return fs.read ~= nil and fs.isFile ~= nil
end

local function getGuiParent()
	if gethui then
		return gethui()
	end
	-- studio / kein executor -> fallback
	return Players.LocalPlayer:WaitForChild("PlayerGui")
end

local function configPath(config): string
	return `{config.FolderName}/{config.FileName}.json`
end

-------------------------------------------------------------------------------
-- Configuration
-------------------------------------------------------------------------------

function PixlLib:Save()
	local config = self.config
	if not (config and config.Saving) then
		return
	end

	local values = {}
	for flag, element in self.Flags do
		values[flag] = element:Get()
	end

	local payload = {
		version = CONFIG_VERSION,
		values = values,
		-- The window toggle key lives outside the Flags map, so it rides along separately.
		toggleKey = self._window and self._window.getToggleKey and self._window.getToggleKey() or nil,
	}

	if not canWrite() then
		return -- Studio, or an executor without file access: nothing to do, and nothing broken
	end

	local ok, err = pcall(function()
		if not fs.isFolder(config.FolderName) then
			fs.makeFolder(config.FolderName)
		end
		fs.write(configPath(config), HttpService:JSONEncode(payload))
	end)

	if not ok then
		warn(`[PixlLib] could not save config: {err}`)
	end
end

-- Saving on every keystroke of a text box (or every step of a slider drag) would hammer the
-- disk. Collapse the writes: the last change within the window wins.
local SAVE_DEBOUNCE = 0.5
local savePending = false

local function requestSave()
	if savePending then
		return
	end
	savePending = true

	task.delay(SAVE_DEBOUNCE, function()
		savePending = false
		PixlLib:Save()
	end)
end

function PixlLib:Load()
	local config = self.config
	if not (config and config.Loading) then
		return
	end

	if not canRead() then
		return -- Studio: no file API, so there is nothing saved to restore
	end

	local path = configPath(config)

	local ok, decoded = pcall(function()
		if not fs.isFile(path) then
			return nil
		end
		return HttpService:JSONDecode(fs.read(path))
	end)

	if not ok then
		warn(`[PixlLib] config at {path} is unreadable, ignoring it: {decoded}`)
		return
	end

	if not decoded then
		return -- nothing saved yet
	end

	-- v1 wraps the values; anything older was a flat map of flag -> value
	local values = decoded.values or decoded

	-- Restore the window toggle key before the flags: it is independent of them, and doing it
	-- up front keeps the reservation correct while the elements below load.
	if decoded.toggleKey and self._window and self._window.setToggleKey then
		self._window.setToggleKey(decoded.toggleKey)
	end

	-- Whether restoring a value should run the element's callback. On by default, so a saved
	-- toggle actually turns its feature back on - a config that restores the switch but not
	-- the thing behind it is a lie. Set FireCallbacksOnLoad = false when the callbacks do
	-- something you would not want to happen unattended at launch.
	local fire = config.FireCallbacksOnLoad ~= false

	for flag, value in values do
		local element = self.Flags[flag]

		if element then
			if fire then
				element:Set(value)
			else
				element:SetSilent(value)
			end
		end
		-- A flag in the file with no element is not an error: the script may simply have
		-- dropped that feature since. It is kept in `values` and rewritten on the next save.
	end
end

-------------------------------------------------------------------------------
-- Notifications
-------------------------------------------------------------------------------

local notifications = source({})
local nextId = 0

local function removeById(id)
	local new = table.clone(notifications())
	new[id] = nil -- key disappears -> indexes destroys exactly this scope
	notifications(new)
end

function PixlLib:Notify(config)
	nextId += 1
	local id = nextId

	local new = table.clone(notifications())
	new[id] = {
		Title = config.Title,
		Content = config.Content,
		Icon = config.Icon,
	}
	notifications(new) -- triggers the renderer

	local duration = config.Duration or 6
	task.delay(duration, removeById, id)

	return function()
		removeById(id) -- dismiss it early
	end
end

-------------------------------------------------------------------------------
-- Window
-------------------------------------------------------------------------------

function PixlLib:CreateWindow(config)
	-- Running the script twice would otherwise leave the old interface behind, still
	-- listening to input and still holding its feature loops.
	local env = getgenv and getgenv() or {}
	if env.PixlLibUnmount then
		env.PixlLibUnmount()
	end

	self.Flags = {}
	self.config = config.Configuration

	local window
	local destroyScope = vide.mount(function()
		-- onUnload lets the settings panel's "Unload UI" button trigger the same full teardown
		-- (flush pending config, stop features, destroy the tree) as calling PixlLib:Destroy().
		window = Window.new(config, notifications, self.Flags, requestSave, function()
			self:Destroy()
		end)
		return window.node
	end, getGuiParent())

	self._window = window
	self._unmount = function()
		-- Stop the running features FIRST, while the elements and their callbacks still
		-- exist. This is the manual "turn everything off before unloading" that a caller used
		-- to have to write by hand - now it is unavoidable, so a reload can never leave an
		-- orphaned loop firing remotes with no switch left to stop it.
		window:TeardownAll()

		destroyScope()
		if window.node then
			window.node:Destroy()
		end

		self._window = nil
		self.Flags = {}
		env.PixlLibUnmount = nil
	end

	env.PixlLibUnmount = self._unmount

	if self.config and self.config.Loading then
		-- Deferred so the caller can finish building its tabs first: elements that do not
		-- exist yet cannot be restored.
		task.defer(function()
			self:Load()
		end)
	end

	return window
end

-- Tears the interface down for good, after writing any pending config change. Everything
-- vide created goes with the scope, so no connections are left running.
function PixlLib:Destroy()
	if savePending then
		savePending = false
		self:Save()
	end

	if self._unmount then
		self._unmount()
		self._unmount = nil
	end
end

function PixlLib:SetVisibility(visible: boolean)
	if self._window then
		self._window:SetVisibility(visible)
	end
end

function PixlLib:IsVisible(): boolean
	return self._window ~= nil and self._window:IsVisible()
end

return PixlLib
