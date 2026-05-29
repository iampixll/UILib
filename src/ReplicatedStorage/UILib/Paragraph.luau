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

local Paragraph = {}

function Paragraph.new(title, content)
	local paragrapgh = {}

	title = source(title)

	paragrapgh.node = create("Frame")({

		--TODO: make content & frame auto resize/format

		Size = UDim2.new(0.98, 0, 0, 150),
		BackgroundColor3 = colors.surfaceHigh,

		create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

		create("TextLabel")({ -- title
			Size = UDim2.new(0.95, 0, 0, 38),
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0),
			BackgroundTransparency = 1,

			Text = title,
			TextColor3 = colors.textPrimary,
			TextSize = 24,
			TextXAlignment = "Left",
			FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold),
		}),

		create("TextLabel")({ -- content
			Size = UDim2.new(0.925, 0, 0, 100),
			AnchorPoint = Vector2.new(0, 0),
			Position = UDim2.fromScale(0.05, 0.25),
			BackgroundTransparency = 0.9,

			Text = content,
			TextColor3 = colors.textPrimary,
			TextSize = 22,
			TextXAlignment = "Left",
			FontFace = Font.fromName("Montserrat"),
		}),
	})

	return paragrapgh
end

return Paragraph
