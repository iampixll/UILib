local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local Colors = require(ReplicatedStorage.PixlLib.Colors)

local create = vide.create

local Paragraph = {}

function Paragraph.new(title, content)
	local paragraph = {}

	paragraph.node = create("Frame")({
		Size = UDim2.new(0.98, 0, 0, 0),
		BackgroundColor3 = Colors.surface,
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
			TextColor3 = Colors.textPrimary,
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
			TextColor3 = Colors.textSecondary,
			TextSize = 22,
			TextXAlignment = "Left",
			FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
		}),
	})

	return paragraph
end

return Paragraph
