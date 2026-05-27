local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)

local source = vide.source
local create = vide.create

local text1 = source("Test123")
local text2 = source("no test lol")

vide.mount(function()
	return create("ScreenGui")({
		create("Frame")({
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(0.4, 0.7),

			create("TextLabel")({

				Position = UDim2.fromScale(0, 0),
				Size = UDim2.fromScale(1, 0.1),

				Text = "yo brotha",
				TextScaled = true,
			}),

			create("TextButton")({
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.075, 0.2),

				Text = function()
					return text1()
				end,
				TextScaled = true,

				Activated = function()
					text1("hi")
				end,
			}),
		}),
	})
end, Players.LocalPlayer.PlayerGui)
