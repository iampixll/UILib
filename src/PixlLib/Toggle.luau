local vide = require("./Packages/vide")
local Colors = require("./Colors")
local Element = require("./Element")

local create = vide.create
local source = vide.source
local spring = vide.spring

-- thumb positions inside the track (scale, so it scales with the track)
local THUMB_OFF = UDim2.fromScale(0.28, 0.5)
local THUMB_ON = UDim2.fromScale(0.72, 0.5)

local Toggle = {}

function Toggle.new(config, onChanged)
	local on = source(config.CurrentValue or false) -- the actual bool state
	local callback = config.Callback

	local function setValue(value, fire)
		value = value and true or false -- a saved config can hand us anything

		if value == on() then
			return
		end

		on(value)

		if fire then
			if callback then
				callback(value)
			end
			if onChanged then
				onChanged()
			end
		end
	end

	local toggle = Element.new("Toggle", config, {
		get = on,
		set = setValue,
	})

	local name = toggle.name

	function toggle:render()
		local hovered = source(false)
		local bgColor = spring(function() -- one step up the depth ladder on hover
			return if hovered() then Colors.surfaceHover else Colors.surface
		end, 0.3)

		local trackColor = spring(function() -- off-track sits on surfaceActive so it reads on both row states
			return if on() then Colors.accent else Colors.surfaceActive
		end, 0.3)

		local thumbPos = spring(function()
			return if on() then THUMB_ON else THUMB_OFF
		end, 0.3)

		return create("Frame")({
			Size = UDim2.new(0.98, 0, 0, 60),
			BackgroundColor3 = bgColor,
			Visible = toggle.visible,

			create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

			create("TextLabel")({ -- name on the left
				Size = UDim2.new(1, -84, 0.6, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 16, 0.5, 0),
				BackgroundTransparency = 1,

				Text = name,
				TextColor3 = Colors.textPrimary,
				TextSize = 22,
				TextXAlignment = "Left",
				FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
			}),

			create("Frame")({ -- switch track
				Size = UDim2.fromOffset(52, 28),
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -20, 0.5, 0),
				BackgroundColor3 = trackColor,

				create("UICorner")({ CornerRadius = UDim.new(1, 0) }), -- pill

				create("Frame")({ -- thumb
					Size = UDim2.fromScale(0.78, 0.78),
					SizeConstraint = "RelativeYY", -- square, based on track height
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = thumbPos,
					BackgroundColor3 = Colors.textPrimary,

					create("UICorner")({ CornerRadius = UDim.new(1, 0) }), -- round
				}),
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
					setValue(not on(), true)
				end,
			}),
		})
	end

	return toggle
end

return Toggle
