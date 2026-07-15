local vide = require("./Packages/vide")
local Colors = require("./Colors")
local Element = require("./Element")

local create = vide.create

-- A section belongs to what comes AFTER it, not before. So it carries its breathing room on
-- top: a wide gap that separates it from the previous group, and only the list's normal
-- spacing below, which glues it to the elements it heads.
--
-- The exception is the first element of a tab. There is no previous group to separate from,
-- so the gap would just be a dent at the top of the page - it is dropped in that case.
local ROW_HEIGHT = 30
local TOP_GAP = 16

local Section = {}

function Section.new(config)
	local section = Element.new("Section", config)
	local name = section.name

	function section:render()
		-- isFirst is handed to us by Tab:addChild and reads the tab's child list, so this
		-- follows along if the element order changes later.
		local function topGap()
			return if section.isFirst and section.isFirst() then 0 else TOP_GAP
		end

		return create("Frame")({
			Size = function()
				return UDim2.new(0.98, 0, 0, ROW_HEIGHT + topGap())
			end,
			BackgroundTransparency = 1,
			Visible = section.visible,

			-- The padding below shrinks the content area from the top, so centering inside it
			-- keeps the heading exactly as it looked - the gap simply appears above it.
			create("UIListLayout")({
				FillDirection = "Horizontal",
				VerticalAlignment = "Center",
				Padding = UDim.new(0, 10),
				SortOrder = "LayoutOrder",
			}),

			create("UIPadding")({
				PaddingTop = function()
					return UDim.new(0, topGap())
				end,
				PaddingLeft = UDim.new(0, 6),
				PaddingRight = UDim.new(0, 6),
			}),

			create("TextLabel")({
				Size = UDim2.fromOffset(0, 20), -- X grows with the text
				AutomaticSize = "X",
				LayoutOrder = 1,
				BackgroundTransparency = 1,

				Text = name,
				TextColor3 = Colors.textMuted,
				TextSize = 22,
				TextXAlignment = "Left",
				FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold),
			}),

			create("Frame")({ -- rule filling the rest of the row
				Size = UDim2.new(1, 0, 0, 3),
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
