local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local vide = require("./Packages/vide")
local Window = require("./Window")

local source = vide.source

local PixlLib = {}

PixlLib.Flags = {}

local function getGuiParent()
	if gethui then
		return gethui()
	end
	-- studio / kein executor -> fallback
	return Players.LocalPlayer:WaitForChild("PlayerGui")
end

function PixlLib:Save()
	if not self.config or not self.config.Saving then
		return
	end

	local data = {}
	for flag, element in self.Flags do
		data[flag] = element:Get()
	end

	local json = HttpService:JSONEncode(data)

	if writefile then
		local folder = self.config.FolderName
		if not isfolder(folder) then
			makefolder(folder)
		end
		writefile(folder .. "/" .. self.config.FileName .. ".json", json)
	else
		print("PixlLib save (no writefile):", json)
	end
end

function PixlLib:Load()
	if not self.config or not self.config.Loading then
		return
	end

	if not readfile then
		print("PixlLib: readfile unavailable, skipping load") -- Studio: no file API
		return
	end

	local path = self.config.FolderName .. "/" .. self.config.FileName .. ".json"
	if not isfile(path) then
		return -- nothing saved yet, nothing to load
	end

	local data = HttpService:JSONDecode(readfile(path)) -- string -> table

	for flag, value in data do
		local element = self.Flags[flag]
		if element then
			element:Set(value) -- silent: no callback, no onChanged
		end
	end
end

local function onChanged()
	PixlLib:Save()
end

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
		Image = config.Image,
	}
	notifications(new) -- triggers the renderer

	local duration = config.Duration or 6
	task.delay(duration, removeById, id)
end

function PixlLib:CreateWindow(config)
	local env = getgenv and getgenv() or {}
	if env.PixlLibUnmount then
		env.PixlLibUnmount()
	end

	self.Flags = {}
	self.config = config.Configuration

	local window
	local destroyScope = vide.mount(function()
		window = Window.new(config, notifications, self.Flags, onChanged)
		return window.node
	end, getGuiParent())

	self._unmount = function()
		destroyScope()
		if window.node then
			window.node:Destroy()
		end
	end

	env.PixlLibUnmount = self._unmount

	if self.config and self.config.Loading then
		task.defer(function()
			self:Load()
		end)
	end

	return window
end

return PixlLib
