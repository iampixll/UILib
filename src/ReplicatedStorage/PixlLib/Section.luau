local vide = require("./Packages/vide")
local Colors = require("./Colors")
local Element = require("./Element")

local create = vide.create

local Section = {}

-- A heading that groups the elements under it. Where a Label is body text at full contrast,
-- a Section is a quiet, small-caps-ish marker that the eye skims past until it needs it -
-- muted colour, letter spacing, a rule to its right.
function Section.new(config)
	local section = Element.new("Section", config)
	local name = section.name

	function section:render()
		return create("Frame")({
			Size = UDim2.new(0.98, 0, 0, 30),
			BackgroundTransparency = 1,
			Visible = section.visible,

			create("UIListLayout")({
				FillDirection = "Horizontal",
				VerticalAlignment = "Center",
				Padding = UDim.new(0, 10),
				SortOrder = "LayoutOrder",
			}),

			create("TextLabel")({
				Size = UDim2.fromOffset(0, 20), -- X grows with the text
				AutomaticSize = "X",
				LayoutOrder = 1,
				BackgroundTransparency = 1,

				Text = name,
				TextColor3 = Colors.textMuted,
				TextSize = 18,
				TextXAlignment = "Left",
				FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold),
			}),

			create("Frame")({ -- rule filling the rest of the row
				Size = UDim2.new(1, 0, 0, 1),
				LayoutOrder = 2,
				BackgroundColor3 = Colors.stroke,
				BorderSizePixel = 0,

				create("UIFlexItem")({ FlexMode = "Fill" }),
			}),
		})
	end

	return section
end

return Section
