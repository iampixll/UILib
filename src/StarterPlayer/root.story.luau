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

		api.createTab("Home", 15637356511)
		api.createTab("Settings", 15637356511)
		api.createTab("About", 15637356511)

		api.CreateTab("Info", 16089599792)
		api.CreateTab("Eggs", 15637367451)
		api.CreateTab("Farming", 16093555964)
		api.CreateTab("Settings", 87867412432006)

		api.CreateTab("Player", 15637355840)
		api.CreateTab("Upgrades", 16089599792)
		api.CreateTab("Fishing", 16093555964)
		api.CreateTab("Mailbox", 15637375511)
		api.CreateTab("Quests", 15637359494)
		api.CreateTab("Automatic", 15637369009)
		api.CreateTab("Webhook", 122219359034661)
		api.CreateTab("Statistics", 94231924171549)
		api.CreateTab("Optimisation", 94231924171549)
		api.CreateTab("Shop", 16093555964)

		return node
	end)
end
