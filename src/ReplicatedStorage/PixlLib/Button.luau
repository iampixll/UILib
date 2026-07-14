local vide = require("./Packages/vide")
local Colors = require("./Colors")
local Element = require("./Element")
local Icons = require("./Icons")

local create = vide.create
local source = vide.source
local spring = vide.spring

local Button = {}

function Button.new(config)
	local button = Element.new("Button", config)

	local name = button.name
	local icon = source(Icons.resolve(config.Icon) or Icons.resolve("fingerprint"))

	local callback = config.Callback

	function button:render()
		local hovered = source(false)
		local bgColor = spring(function()
			return if hovered() then Colors.surfaceHover else Colors.surface
		end, 0.3)

		return create("Frame")({
			Size = UDim2.new(0.98, 0, 0, 44),
			BackgroundColor3 = bgColor,
			Visible = button.visible,

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

				Image = icon,
				ImageColor3 = Colors.textMuted,
			}),

			create("TextButton")({
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Text = "",

				MouseEnter = function()
					hovered(true)
				end,
				MouseLeave = function()
					hovered(false)
				end,

				Activated = function()
					if callback then
						callback()
					end
				end,
			}),
		})
	end

	function button:SetIcon(newIcon)
		icon(Icons.resolve(newIcon) or "")
	end

	return button
end

return Button
