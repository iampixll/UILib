local UserInputService = game:GetService("UserInputService")

local vide = require("@vide")
local Colors = require("./Colors")
local Element = require("./Element")

local create = vide.create
local source = vide.source
local spring = vide.spring

local Keybind = {}

-- How many keybinds are currently waiting for their new key. While that is above zero the
-- next keypress belongs to the rebind and to nothing else - without this, rebinding onto the
-- window's own toggle key would minimise the window in the same breath.
local capturing = 0

function Keybind.IsCapturing(): boolean
	return capturing > 0
end

-- Keys a badge refuses to bind, by KeyCode name. The window registers its own toggle key
-- here, so a rebind can never steal it - pressing it during capture cancels instead.
local reservedKeys = {}

function Keybind.Reserve(keyName: string)
	reservedKeys[keyName] = true
end

function Keybind.Unreserve(keyName: string)
	reservedKeys[keyName] = nil
end

-- The reusable half of a keybind: the key it holds, the listeners that watch for it, and the
-- pill you click to rebind. It owns no row, so a Toggle (or anything else) can place it next
-- to its own controls - the standalone Keybind element below is just this badge in a row.
--
-- config:    { CurrentKeybind = "L", HoldToInteract = false }
-- onFire:    runs when the key is pressed. With HoldToInteract it also runs on release, with
--            `false` - the same contract the standalone element's Callback has.
-- onChanged: config persistence hook, fired when the key itself is rebound
function Keybind.newBadge(config, onFire, onChanged)
	local holdToInteract = config.HoldToInteract or false

	local key = source(config.CurrentKeybind or "K")
	local listening = source(false) -- waiting for the user to press the new key
	local held = source(false)

	local function setListening(value: boolean)
		if value == listening() then
			return
		end

		listening(value)

		if value then
			capturing += 1
		else
			-- Release on the NEXT frame, not now. The keypress that ends a rebind is still
			-- being handed to the other InputBegan listeners - the window's toggle-key
			-- handler among them - and they must all still see the lock, whatever order they
			-- run in. Dropping it here would let a handler that runs after us act on the very
			-- key we just consumed.
			task.defer(function()
				capturing -= 1
			end)
		end
	end

	local function setValue(newKey, fire)
		if type(newKey) == "EnumItem" then
			newKey = newKey.Name
		end

		if type(newKey) ~= "string" or not Enum.KeyCode[newKey] then
			warn(`[PixlLib] "{tostring(newKey)}" is not a KeyCode name, keybind unchanged`)
			return
		end

		if newKey == key() then
			return
		end

		key(newKey)

		if fire and onChanged then
			onChanged()
		end
	end

	local badge = {
		key = key,
		get = key,
		set = setValue,
	}

	-- The pill. Whoever embeds it decides where it sits; it brings its own listeners.
	function badge.render()
		local beganConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if input.UserInputType ~= Enum.UserInputType.Keyboard then
				return
			end

			-- Rebinding takes priority, and deliberately ignores gameProcessed: the user is
			-- typing INTO our element, not into the game.
			if listening() then
				setListening(false)

				-- Escape cancels and keeps the old key (nobody means to farm on the pause
				-- key), and so does any reserved key - the window's toggle key can never be
				-- stolen by a rebind.
				if input.KeyCode ~= Enum.KeyCode.Escape and not reservedKeys[input.KeyCode.Name] then
					setValue(input.KeyCode.Name, true)
				end
				return
			end

			if gameProcessed or input.KeyCode.Name ~= key() then
				return
			end

			if holdToInteract then
				held(true)
				onFire(true)
			else
				onFire()
			end
		end)
		vide.cleanup(beganConn)

		local endedConn = UserInputService.InputEnded:Connect(function(input)
			if not holdToInteract or input.UserInputType ~= Enum.UserInputType.Keyboard then
				return
			end

			-- Only release what we actually caught pressing: a key let go over the UI or in a
			-- text box must not fire a ghost `false`.
			if input.KeyCode.Name == key() and held() then
				held(false)
				onFire(false)
			end
		end)
		vide.cleanup(endedConn)

		-- Destroying the element mid-rebind must not leave the capture lock stuck on
		vide.cleanup(function()
			setListening(false)
		end)

		local hovered = source(false)

		local boxColor = spring(function() -- lights up while it waits for the new key
			if listening() then
				return Colors.accent
			end
			return if hovered() then Colors.surfaceHigh2 else Colors.bg
		end, 0.2)

		return create("Frame")({
			Size = UDim2.fromOffset(70, 34),
			BackgroundColor3 = boxColor,
			ZIndex = 2, -- above the row's click overlay, so the pill takes its own clicks

			create("UICorner")({ CornerRadius = UDim.new(0, 8) }),
			create("UIStroke")({ Color = Colors.stroke, Thickness = 1.5 }),

			create("TextLabel")({
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				ZIndex = 2,

				Text = function()
					return if listening() then "..." else key()
				end,
				TextColor3 = Colors.textPrimary,
				TextSize = 20,
				TextTruncate = "AtEnd",
				FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
			}),

			create("TextButton")({
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Text = "",
				ZIndex = 3,

				MouseEnter = function()
					hovered(true)
				end,
				MouseLeave = function()
					hovered(false)
				end,

				Activated = function()
					setListening(not listening()) -- click again to cancel
				end,
			}),
		})
	end

	return badge
end

-- The standalone element: the badge, in a row of its own.
function Keybind.new(config, onChanged)
	local callback = config.Callback

	local badge = Keybind.newBadge(config, function(...)
		if callback then
			callback(...)
		end
	end, onChanged)

	local keybind = Element.new("Keybind", config, {
		get = badge.get,
		set = badge.set,
	})

	local name = keybind.name

	function keybind:render()
		local hovered = source(false)

		local bgColor = spring(function()
			return if hovered() then Colors.surfaceHover else Colors.surface
		end, 0.3)

		return create("Frame")({
			Size = UDim2.new(0.98, 0, 0, 60),
			BackgroundColor3 = bgColor,
			Visible = keybind.visible,

			create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

			create("TextLabel")({ -- name on the left
				Size = UDim2.new(1, -110, 0.6, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 16, 0.5, 0),
				BackgroundTransparency = 1,

				Text = name,
				TextColor3 = Colors.textPrimary,
				TextSize = 22,
				TextXAlignment = "Left",
				FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
			}),

			create("TextButton")({ -- row hover; the badge sits above it and eats its own clicks
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Text = "",

				MouseEnter = function()
					hovered(true)
				end,
				MouseLeave = function()
					hovered(false)
				end,
			}),

			create("Frame")({ -- anchors the badge to the right edge
				Size = UDim2.fromOffset(70, 34),
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -16, 0.5, 0),
				BackgroundTransparency = 1,
				ZIndex = 2,

				badge.render(),
			}),
		})
	end

	return keybind
end

return Keybind
