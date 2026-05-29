local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)

local create = vide.create
local source = vide.source
local spring = vide.spring

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

local Button = {}

function Button.new(name, callback)
	local button = {}

	name = source(name)

	local hovered = source(false)
	local bgColor = spring(function()
		return if hovered() then colors.buttonHover else colors.surfaceHigh
	end, 0.3)

	button.node = create("Frame")({
		Size = UDim2.new(0.98, 0, 0, 44),
		BackgroundColor3 = bgColor,

		create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

		create("TextLabel")({ -- name on the left
			Size = UDim2.new(1, -64, 0.6, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 16, 0.5, 0),
			BackgroundTransparency = 1,

			Text = name,
			TextColor3 = colors.textPrimary,
			TextSize = 22,
			TextXAlignment = "Left",
			FontFace = Font.fromName("Montserrat"),
		}),

		create("ImageLabel")({ -- icon on the right
			Size = UDim2.fromScale(0.6, 0.6),
			SizeConstraint = "RelativeYY",
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -20, 0.5, 0),
			BackgroundTransparency = 1,

			Image = "rbxassetid://16089599792",
			ImageColor3 = colors.textMuted,
		}),

		create("TextButton")({
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,

			MouseEnter = function()
				hovered(true)
			end,
			MouseLeave = function()
				hovered(false)
			end,

			Activated = callback,
		}),
	})

	function button:Set(newName)
		name(newName)
	end

	return button
end

return Button
