local vide = require("./Packages/vide")
local Colors = require("./Colors")
local Element = require("./Element")
local Keybind = require("./Keybind")

local create = vide.create
local source = vide.source
local spring = vide.spring

-- thumb positions inside the track (scale, so it scales with the track)
local THUMB_OFF = UDim2.fromScale(0.28, 0.5)
local THUMB_ON = UDim2.fromScale(0.72, 0.5)

local SWITCH_WIDTH = 52
local BADGE_WIDTH = 70
local GAP = 12 -- between the badge and the switch

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

		-- On teardown, an on-toggle stops its feature. We call the callback directly with
		-- false rather than setValue(false), so the toggle's stored value stays true and a
		-- saved config still reflects what the user had on - the feature stops, the setting
		-- survives.
		teardown = function()
			if on() and callback then
				callback(false)
			end
		end,
	})

	local name = toggle.name

	-- Optional inline keybind. The key drives the TOGGLE, not the feature behind it, so the
	-- switch always shows what is really running - same reason :Set() fires callbacks.
	--   HoldToInteract = false -> the key flips the toggle
	--   HoldToInteract = true  -> the toggle is on only while the key is held
	local badge = nil

	if config.Keybind then
		local keyConfig = config.Keybind

		badge = Keybind.newBadge(keyConfig, function(held)
			if keyConfig.HoldToInteract then
				setValue(held, true)
			else
				setValue(not on(), true)
			end
		end, onChanged)

		-- A handle of its own, so the key is saved and reachable like any other value:
		-- PixlLib.Flags.AutoFarmKey:Get() -> "L"
		toggle.keybind = Element.new("Keybind", keyConfig, {
			get = badge.get,
			set = badge.set,
		})
	end

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

		-- What the name has to give up on the right: the switch always, the badge only if
		-- there is one. No keybind, no gap - the row looks exactly as it did before.
		local rightInset = 20 + SWITCH_WIDTH + (if badge then GAP + BADGE_WIDTH else 0)

		return create("Frame")({
			Size = UDim2.new(0.98, 0, 0, 60),
			BackgroundColor3 = bgColor,
			Visible = toggle.visible,

			create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

			create("TextLabel")({ -- name on the left
				Size = UDim2.new(1, -(rightInset + 32), 0.6, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 16, 0.5, 0),
				BackgroundTransparency = 1,

				Text = name,
				TextColor3 = Colors.textPrimary,
				TextSize = 22,
				TextXAlignment = "Left",
				TextTruncate = "AtEnd",
				FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
			}),

			create("Frame")({ -- switch track
				Size = UDim2.fromOffset(SWITCH_WIDTH, 28),
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

			create("TextButton")({ -- click anywhere on the row flips it
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

			-- Left of the switch, and created AFTER the click overlay on purpose: the badge
			-- must sit on top of it, or the overlay swallows the click meant for rebinding.
			if badge
				then create("Frame")({
					Size = UDim2.fromOffset(BADGE_WIDTH, 34),
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -(20 + SWITCH_WIDTH + GAP), 0.5, 0),
					BackgroundTransparency = 1,
					ZIndex = 2,

					badge.render(),
				})
				else nil,
		})
	end

	return toggle
end

return Toggle
