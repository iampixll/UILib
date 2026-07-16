local vide = require("@vide")
local Colors = require("./Colors")
local Icons = require("./Icons")

local create = vide.create
local spring = vide.spring

local Notification = {}

function Notification.new(config, present)
	local notification = {}

	local offset = spring(function()
		return if present() then 0 else 350 -- slides in from +350px right
	end, 0.3)

	local transparency = spring(function()
		return if present() then 0 else 1
	end, 0.3)

	notification.node = create("Frame")({ -- wrapper: the layout child, stays put
		Size = UDim2.new(0, 300, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,

		create("Frame")({ -- the actual card, slides freely inside the wrapper
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = "Y",
			Position = function()
				return UDim2.fromOffset(offset(), 0)
			end,
			BackgroundColor3 = Colors.surfaceHover,
			BackgroundTransparency = transparency,

			create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

			create("UIStroke")({ -- subtle outer border, fades with the card
				Color = Colors.surface,
				Thickness = 4,
				Transparency = function()
					return 0.7 + transparency() * 0.3 -- 0.7 visible -> 1.0 gone
				end,
			}),

			create("UIPadding")({ -- inner spacing from the frame edges
				PaddingTop = UDim.new(0, 12),
				PaddingBottom = UDim.new(0, 12),
				PaddingLeft = UDim.new(0, 16),
				PaddingRight = UDim.new(0, 16),
			}),

			create("UIListLayout")({
				Padding = UDim.new(0, 8),
				SortOrder = "LayoutOrder",
			}),

			create("Frame")({ -- title row
				Size = UDim2.new(1, 0, 0, 0),
				LayoutOrder = 1,
				AutomaticSize = "Y",
				BackgroundTransparency = 1,

				create("UIListLayout")({
					FillDirection = "Horizontal", -- icon then title, side by side
					VerticalAlignment = "Center",
					Padding = UDim.new(0, 8),
					SortOrder = "LayoutOrder",
				}),

				create("ImageLabel")({
					Size = UDim2.fromOffset(32, 32), -- fixed, square; no scale coupling
					BackgroundTransparency = 1,
					Image = Icons.resolve(config.Icon) or Icons.resolve("bell"),
					ImageColor3 = Colors.textPrimary,
					ImageTransparency = transparency,
				}),

				create("TextLabel")({ -- title
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = "Y",
					BackgroundTransparency = 1,
					Text = config.Title,
					TextWrapped = true,
					TextColor3 = Colors.textPrimary,
					TextTransparency = transparency,
					TextSize = 24,
					TextXAlignment = "Left",
					FontFace = Font.fromName("Montserrat", Enum.FontWeight.ExtraBold),

					create("UIFlexItem")({ FlexMode = "Fill" }),
				}),
			}),

			create("TextLabel")({ -- content
				Size = UDim2.new(1, 0, 0, 0),
				LayoutOrder = 2,
				AutomaticSize = "Y",
				BackgroundTransparency = 1,
				Text = config.Content,
				TextWrapped = true,
				TextColor3 = Colors.textSecondary,
				TextTransparency = transparency,
				TextSize = 22,
				TextXAlignment = "Left",
				FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
			}),
		}),
	})

	return notification
end

return Notification
