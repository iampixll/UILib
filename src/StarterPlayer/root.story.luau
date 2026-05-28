local ReplicatedStorage = game:GetService("ReplicatedStorage")

local uilabs = require(ReplicatedStorage.Packages.uilabs)
local vide = require(ReplicatedStorage.Packages.vide)
local Window = require(ReplicatedStorage.UILib.Window)

local toggle = true

if toggle then
	return uilabs.CreateVideStory({
		vide = vide,
		controls = {},
	}, function(props)
		local node, api = Window({
			Title = "PixlLib",
		})

		api.createTab("Home", 15637376279)
		api.createTab("Webhook", 122219359034661)
		api.createTab("Shop", 15637380284)
		api.createTab("Farm", 15637359494)
		api.createTab("Egg", 15637367451)

		return node
	end)
end
