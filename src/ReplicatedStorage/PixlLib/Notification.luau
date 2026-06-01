local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local Colors = require(ReplicatedStorage.PixlLib.Colors)

local create = vide.create

local Notification = {}

function Notification.new(config)
	local notification = {}

	notification.node = create("Frame")({
		Size = UDim2.new(0, 300, 0, 0),
		BackgroundColor3 = Colors.surfaceHigh,
		AutomaticSize = "Y",

		create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

		create("UIStroke")({ -- subtle outer border
			Color = Colors.surface,
			Thickness = 4,
			Transparency = 0.7,
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

		create("Frame")({
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
				Image = "rbxassetid://15642579187",
				ImageColor3 = Colors.textPrimary,
			}),

			create("TextLabel")({ -- title
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = "Y",
				BackgroundTransparency = 1,

				Text = config.Title,
				TextWrapped = true,
				TextColor3 = Colors.textPrimary,
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
			TextColor3 = Colors.textPrimary,
			TextSize = 22,
			TextXAlignment = "Left",
			FontFace = Font.fromName("Montserrat"),
		}),
	})

	return notification
end

return Notification
