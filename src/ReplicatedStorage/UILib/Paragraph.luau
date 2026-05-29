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
		Size = UDim2.new(0.98, 0, 0, 0),
		BackgroundColor3 = colors.surfaceHigh,
		AutomaticSize = "Y",

		create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

		create("UIPadding")({ -- inner spacing from the frame edges
			PaddingTop = UDim.new(0, 12),
			PaddingBottom = UDim.new(0, 12),
			PaddingLeft = UDim.new(0, 16),
			PaddingRight = UDim.new(0, 16),
		}),

		create("UIListLayout")({ -- stacks children, frame sums their height
			Padding = UDim.new(0, 8),
			SortOrder = "LayoutOrder",
		}),

		create("TextLabel")({ -- title
			Size = UDim2.new(1, 0, 0, 28),
			LayoutOrder = 1,
			BackgroundTransparency = 1,

			Text = title,
			TextColor3 = colors.textPrimary,
			TextSize = 24,
			TextXAlignment = "Left",
			FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold),
		}),

		create("TextLabel")({ -- content
			Size = UDim2.new(1, 0, 0, 0), -- X fixed, Y grows with text
			LayoutOrder = 2,
			AutomaticSize = "Y",
			BackgroundTransparency = 1,

			Text = content,
			TextWrapped = true,
			TextColor3 = colors.textPrimary,
			TextSize = 22,
			TextXAlignment = "Left",
			FontFace = Font.fromName("Montserrat"),
		}),
	})

	return paragrapgh
end

return Paragraph
