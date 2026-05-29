local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local Colors = require(ReplicatedStorage.UILib.Colors)

local create = vide.create
local source = vide.source

local Label = {}

function Label.new(name)
	local label = {}

	name = source(name)

	label.node = create("TextLabel")({
		Size = UDim2.new(0.98, 0, 0, 28),
		BackgroundTransparency = 1,

		Text = name,
		TextColor3 = Colors.textPrimary,
		TextSize = 24,
		TextXAlignment = "Left",
		TextYAlignment = "Bottom",

		FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold),
	})

	function label:Set(newName)
		name(newName)
	end

	return label
end

return Label
