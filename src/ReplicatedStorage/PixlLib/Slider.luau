local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local vide = require(ReplicatedStorage.Packages.vide)
local Colors = require(ReplicatedStorage.PixlLib.Colors)

local create = vide.create
local source = vide.source
local spring = vide.spring

local Slider = {}

function Slider.new(name, suffix, range, increment, currentValue, flag, callback)
	local slider = {}
	slider.flag = flag

	local min, max = range[1], range[2]

	name = source(name)
	local value = source(currentValue)

	local function fraction()
		return (value() - min) / (max - min)
	end

	local function setValue(newValue, fireCallback)
		local snapped = math.clamp(math.round(newValue / increment) * increment, min, max)
		if snapped ~= value() then
			value(snapped)
			if fireCallback and callback then
				callback(snapped)
			end
		end
	end

	local dragging = source(false)
	local hovered = source(false)

	local bgColor = spring(function()
		return if hovered() then Colors.surfaceHover else Colors.surface
	end, 0.3)

	local track

	local function updateFromX(mouseX)
		local f = (mouseX - track.AbsolutePosition.X) / track.AbsoluteSize.X
		setValue(min + f * (max - min), true)
	end

	local thumbScale = spring(function()
		return if dragging() then 1.2 else 1
	end, 0.2)

	local fillFraction = spring(fraction, 0.15)

	track = create("Frame")({ -- track
		Size = UDim2.new(0.95, 0, 0, 10),
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0.5, 0, 1, -10),
		BackgroundColor3 = Colors.bg,

		create("UICorner")({ CornerRadius = UDim.new(1, 0) }),

		create("Frame")({ -- fill
			Size = function()
				return UDim2.fromScale(fillFraction(), 1) -- springed, lags slightly behind
			end,
			BackgroundColor3 = Colors.accent,

			create("UICorner")({ CornerRadius = UDim.new(1, 0) }),
		}),

		create("Frame")({ -- thumb
			Size = function()
				local s = thumbScale()
				return UDim2.fromOffset(18 * s, 18 * s)
			end,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = function()
				return UDim2.fromScale(fillFraction(), 0.5) -- same springed fraction as the fill
			end,
			BackgroundColor3 = Colors.textPrimary,

			create("UICorner")({ CornerRadius = UDim.new(1, 0) }),
		}),
	})

	local moveConn = UserInputService.InputChanged:Connect(function(input)
		if dragging() and input.UserInputType == Enum.UserInputType.MouseMovement then
			updateFromX(input.Position.X)
		end
	end)
	vide.cleanup(moveConn)

	local endConn = UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging(false)
		end
	end)
	vide.cleanup(endConn)

	slider.node = create("Frame")({
		Size = UDim2.new(0.98, 0, 0, 60),
		BackgroundColor3 = bgColor,

		create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

		create("TextLabel")({ -- name
			Size = UDim2.new(0.5, 0, 0.4, 0),
			Position = UDim2.new(0, 16, 0.1, 0),
			BackgroundTransparency = 1,

			Text = name,
			TextColor3 = Colors.textPrimary,
			TextSize = 22,
			TextXAlignment = "Left",
			FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
		}),

		create("TextLabel")({ -- value, reacts to the state
			Size = UDim2.new(0.35, 0, 0.4, 0),
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -16, 0.1, 0),
			BackgroundTransparency = 1,

			Text = function()
				return if suffix then value() .. " " .. suffix else tostring(value())
			end,
			TextColor3 = Colors.textSecondary,
			TextSize = 22,
			TextXAlignment = "Right",
			FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
		}),

		track,

		create("TextButton")({ -- full-element overlay: hover + drag start anywhere
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = "",

			MouseEnter = function()
				hovered(true)
			end,
			MouseLeave = function()
				hovered(false)
			end,

			InputBegan = function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging(true)
					updateFromX(input.Position.X)
				end
			end,
		}),
	})

	function slider:Get()
		return value()
	end

	function slider:Set(newValue)
		setValue(newValue, false)
	end

	return slider
end

return Slider
