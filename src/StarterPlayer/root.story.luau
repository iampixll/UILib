local ReplicatedStorage = game:GetService("ReplicatedStorage")

local uilabs = require(ReplicatedStorage.Packages.uilabs)
local vide = require(ReplicatedStorage.Packages.vide)

local create = vide.create
local source = vide.source
local effect = vide.effect

local size = source(UDim2.fromScale(0.3, 0.5))

return uilabs.CreateVideStory({
	vide = vide,
	controls = {
		Transparency = 0.1,
	},
}, function(props)
	effect(function()
		print("Transparency: ", props.controls.Transparency())
	end)

	return create("Frame")({
		Size = size,

		BackgroundTransparency = props.controls.Transparency,
	})
end)
