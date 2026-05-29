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
		local window = Window.new({ Title = "PixlLib" })

		local home = window:CreateTab("Home", 15637376279)
		local farm = window:CreateTab("Farming", 15637359494)
		local shop = window:CreateTab("Shop", 15637380284)

		home:CreateButton({
			Name = "Auto Farm",
			Callback = function() end,
		})

		home:CreateButton({
			Name = "Claim Rewards",
			Callback = function() end,
		})

		home:CreateButton({
			Name = "Teleport Hub",
			Callback = function() end,
		})

		home:CreateButton({
			Name = "Sell Inventory",
			Callback = function() end,
		})

		home:CreateButton({
			Name = "Open Crates",
			Callback = function() end,
		})

		home:CreateButton({
			Name = "Upgrade Pets",
			Callback = function() end,
		})

		home:CreateButton({
			Name = "Collect Coins",
			Callback = function() end,
		})

		home:CreateButton({
			Name = "Server Hop",
			Callback = function() end,
		})

		home:CreateButton({
			Name = "Redeem Codes",
			Callback = function() end,
		})

		home:CreateButton({
			Name = "Anti AFK",
			Callback = function() end,
		})

		return window.node
	end)
end
