local vide = require("./Packages/vide")
local Colors = require("./Colors")
local Element = require("./Element")

local create = vide.create
local source = vide.source

local Paragraph = {}

function Paragraph.new(config)
	-- The paragraph's heading is the element name, so :SetName() retitles it like every
	-- other element; the body gets its own source.
	local paragraph = Element.new("Paragraph", { Name = config.Title })
	local title = paragraph.name
	local content = source(config.Content or "")

	function paragraph:render()
		return create("Frame")({
			Size = UDim2.new(0.98, 0, 0, 0),
			BackgroundColor3 = Colors.surface,
			AutomaticSize = "Y",
			Visible = paragraph.visible,

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
	end

	function paragraph:SetContent(newContent: string)
		content(newContent)
	end

	return paragraph
end

return Paragraph
