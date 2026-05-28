local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local Window = require(ReplicatedStorage.UILib.Window)

local playerGui = Players.LocalPlayer.PlayerGui

local UILib = {}

function UILib:CreateWindow(config)
	local api
	vide.mount(function()
		local node, returnedApi = Window(config)
		api = returnedApi
		return node
	end, playerGui)

	return {
		CreateTab = function(_, name, image)
			return api.createTab(name, image)
		end,
	}
end

return UILib
