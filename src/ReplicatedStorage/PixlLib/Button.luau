local vide = require("./Packages/vide")
local Colors = require("./Colors")

local create = vide.create
local source = vide.source
local spring = vide.spring

local Button = {}

function Button.new(name, callback)
	local button = {}

	name = source(name)

	function button:render()
		local hovered = source(false)
		local bgColor = spring(function()
			return if hovered() then Colors.surfaceHover else Colors.surface
		end, 0.3)

		return create("Frame")({
			Size = UDim2.new(0.98, 0, 0, 44),
			BackgroundColor3 = bgColor,

			create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

			create("TextLabel")({ -- name on the left
				Size = UDim2.new(1, -64, 0.6, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 16, 0.5, 0),
				BackgroundTransparency = 1,

				Text = name,
				TextColor3 = Colors.textPrimary,
				TextSize = 22,
				TextXAlignment = "Left",
				FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
			}),

			create("ImageLabel")({ -- icon on the right
				Size = UDim2.fromScale(0.6, 0.6),
				SizeConstraint = "RelativeYY",
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -20, 0.5, 0),
				BackgroundTransparency = 1,

				Image = "rbxassetid://16089599792",
				ImageColor3 = Colors.textMuted,
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
	end

	function button:Set(newName)
		name(newName)
	end

	return button
end

return Button
