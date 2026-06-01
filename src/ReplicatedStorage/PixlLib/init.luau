local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local Window = require(ReplicatedStorage.PixlLib.Window)

local source = vide.source

local PixlLib = {}

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
	return Window.new(config, notifications)
end

return PixlLib
