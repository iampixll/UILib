local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local Colors = require(ReplicatedStorage.UILib.Colors)

local create = vide.create
local source = vide.source
local spring = vide.spring

local InputBox = {}

function InputBox.new(name, inputType, currentValue, placeholder, flag, callback)
	local input = {}
	input.flag = flag

	name = source(name)
	local value = source(currentValue or "") -- committed value, single source of truth

	local focused = source(false)
	local hovered = source(false)

	local bgColor = spring(function() -- outer frame, hover highlight
		return if hovered() then Colors.buttonHover else Colors.surfaceHigh
	end, 0.3)

	local boxColor = spring(function() -- inner field, subtle lighten on focus
		return if focused() then Colors.surfaceHigh else Colors.background
	end, 0.3)

	local strokeColor = spring(function() -- accent border, only while focused
		return if focused() then Colors.accent else Colors.tabInactive
	end, 0.3)

	local textColor = spring(function() -- bright while focused, fades grey on blur
		return if focused() then Colors.textPrimary else Colors.textMuted
	end, 0.3)

	local function setValue(newValue, fireCallback)
		if newValue ~= value() then
			value(newValue)
			if fireCallback and callback then
				callback(newValue)
			end
		end
	end

	local box
	box = create("TextBox")({
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ClearTextOnFocus = true,

		-- Text follows the committed value; vide only rewrites it on commit/:Set,
		-- never mid-typing -> no cursor jumps
		Text = value,
		PlaceholderText = placeholder or "",
		PlaceholderColor3 = Colors.textMuted,

		TextColor3 = textColor,
		TextSize = 22,
		TextXAlignment = "Left",
		FontFace = Font.fromName("Montserrat"),

		Focused = function()
			focused(true)
		end,

		FocusLost = function() -- (enterPressed, inputObject)
			focused(false)
			if inputType == "number" then
				local num = tonumber(box.Text)
				if num then
					setValue(num, true) -- valid number, commit + fire
				else
					box.Text = tostring(value()) -- reject: snap box back to last good value
				end
			else
				setValue(box.Text, true)
			end
		end,
	})

	input.node = create("Frame")({
		Size = UDim2.new(0.98, 0, 0, 60),
		BackgroundColor3 = bgColor,

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
			FontFace = Font.fromName("Montserrat"),
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

	function input:Get()
		return value()
	end

	function input:Set(newValue)
		setValue(newValue, false) -- silent, consistent with Toggle/Slider
	end

	return input
end

return InputBox
