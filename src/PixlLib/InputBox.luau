local vide = require("@vide")
local Colors = require("./Colors")
local Element = require("./Element")

local create = vide.create
local source = vide.source
local spring = vide.spring

local InputBox = {}

function InputBox.new(config, onChanged)
	local isNumber = config.IsNumber
	local callback = config.Callback

	local value = source(config.CurrentValue or "") -- committed value, single source of truth

	local function setValue(newValue, fire)
		if isNumber then
			newValue = tonumber(newValue)
			if not newValue then
				return -- a number box never holds a non-number, not even from a config file
			end
		end

		if newValue == value() then
			return
		end

		value(newValue)

		if fire then
			if callback then
				callback(newValue)
			end
			if onChanged then
				onChanged()
			end
		end
	end

	local input = Element.new("Input", config, {
		get = value,
		set = setValue,
	})

	local name = input.name

	function input:render()
		local focused = source(false)
		local hovered = source(false)

		local bgColor = spring(function() -- the row itself
			return if hovered() then Colors.surfaceHover else Colors.surface
		end, 0.3)

		local boxColor = spring(function() -- inset field: darkest at rest, lifts on focus
			return if focused() then Colors.surfaceActive else Colors.bg
		end, 0.3)

		local strokeColor = spring(function() -- accent border only while focused
			return if focused() then Colors.accent else Colors.stroke
		end, 0.3)

		local textColor = spring(function() -- brightens on focus
			return if focused() then Colors.textPrimary else Colors.textSecondary
		end, 0.3)

		local box
		box = create("TextBox")({
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ClearTextOnFocus = true,

			-- Text follows the committed value; vide only rewrites it on commit/:Set,
			-- never mid-typing -> no cursor jumps
			Text = function()
				return tostring(value())
			end,
			PlaceholderText = config.Placeholder or "",
			PlaceholderColor3 = Colors.textMuted,

			TextColor3 = textColor,
			TextSize = 22,
			TextXAlignment = "Left",
			FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),

			Focused = function()
				focused(true)
			end,

			FocusLost = function() -- (enterPressed, inputObject)
				focused(false)

				if isNumber and not tonumber(box.Text) then
					box.Text = tostring(value()) -- reject: snap box back to last good value
					return
				end

				setValue(box.Text, true)
			end,
		})

		return create("Frame")({
			Size = UDim2.new(0.98, 0, 0, 60),
			BackgroundColor3 = bgColor,
			Visible = input.visible,

			MouseEnter = function()
				hovered(true)
			end,
			MouseLeave = function()
				hovered(false)
			end,

			create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

			create("TextLabel")({ -- name
				Size = UDim2.new(0.45, -16, 0.6, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 16, 0.5, 0),
				BackgroundTransparency = 1,

				Text = name,
				TextColor3 = Colors.textPrimary,
				TextSize = 22,
				TextXAlignment = "Left",
				FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
			}),

			create("Frame")({ -- input field background
				Size = UDim2.new(0.5, 0, 0.6, 0),
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -16, 0.5, 0),
				BackgroundColor3 = boxColor,

				create("UICorner")({ CornerRadius = UDim.new(0, 8) }),

				create("UIStroke")({
					Color = strokeColor,
					Thickness = 1.5,
				}),

				create("UIPadding")({
					PaddingLeft = UDim.new(0, 10),
					PaddingRight = UDim.new(0, 10),
				}),

				box,
			}),
		})
	end

	return input
end

return InputBox
