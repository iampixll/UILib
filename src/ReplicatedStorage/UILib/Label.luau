local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)

local create = vide.create
local source = vide.source

local colors = {
	background = Color3.fromRGB(43, 45, 49), -- darkest, content areas
	surface = Color3.fromRGB(30, 31, 34), -- main container
	surfaceHigh = Color3.fromRGB(57, 60, 66), -- chrome (topbar, footer, buttons)
	accent = Color3.fromRGB(88, 101, 242), -- highlights (active tab, etc.)
	buttonIdle = Color3.fromRGB(75, 78, 85), -- minimize button, brighter than topbar
	buttonHover = Color3.fromRGB(95, 98, 106), -- even brighter on hover
	textPrimary = Color3.fromRGB(220, 223, 228),
	textMuted = Color3.fromRGB(150, 153, 160),
	tabInactive = Color3.fromRGB(110, 113, 120), -- dimmer than textMuted, for inactive tab text/icons
}

local Label = {}

function Label.new(name)
	local label = {}

	name = source(name)

	label.node = create("TextLabel")({
		Size = UDim2.new(0.98, 0, 0, 28),
		BackgroundTransparency = 1,

		Text = name,
		TextColor3 = colors.textPrimary,
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
