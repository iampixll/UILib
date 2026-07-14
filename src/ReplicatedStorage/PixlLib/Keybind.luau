local UserInputService = game:GetService("UserInputService")

local vide = require("./Packages/vide")
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

-- Binds a key to a callback, and lets the user rebind it by clicking the element and pressing
-- the new key. The stored value is the KeyCode's *name* ("F", "LeftAlt"), because that is what
-- survives a round trip through the JSON config - an EnumItem does not.
--
-- Two behaviours, like Rayfield:
--   HoldToInteract = false (default) -> callback fires once on press
--   HoldToInteract = true            -> callback fires with true on press and false on release
function Keybind.new(config, onChanged)
	local callback = config.Callback
	local holdToInteract = config.HoldToInteract or false

	local key = source(config.CurrentKeybind or "K")
	local listening = source(false) -- waiting for the user to press the new key
	local held = source(false)

	local function setListening(value: boolean)
		if value == listening() then
			return
		end

		listening(value)
		capturing += if value then 1 else -1
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

	local keybind = Element.new("Keybind", config, {
		get = key,
		set = setValue,
	})

	local name = keybind.name

	function keybind:render()
		local hovered = source(false)

		local bgColor = spring(function()
			return if hovered() then Colors.surfaceHover else Colors.surface
		end, 0.3)

		local boxColor = spring(function() -- the key pill lights up while it waits for input
			return if listening() then Colors.accent else Colors.bg
		end, 0.2)

		local beganConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if input.UserInputType ~= Enum.UserInputType.Keyboard then
				return
			end

			-- Rebinding takes priority, and deliberately ignores gameProcessed: the user is
			-- typing INTO our element, not into the game.
			if listening() then
				setListening(false)
				setValue(input.KeyCode.Name, true)
				return
			end

			if gameProcessed or input.KeyCode.Name ~= key() then
				return
			end

			if holdToInteract then
				held(true)
				if callback then
					callback(true)
				end
			elseif callback then
				callback()
			end
		end)
		vide.cleanup(beganConn)

		local endedConn = UserInputService.InputEnded:Connect(function(input)
			if not holdToInteract or input.UserInputType ~= Enum.UserInputType.Keyboard then
				return
			end

			if input.KeyCode.Name == key() and held() then
				held(false)
				if callback then
					callback(false)
				end
			end
		end)
		vide.cleanup(endedConn)

		-- Destroying the element mid-rebind must not leave the capture lock stuck on
		vide.cleanup(function()
			setListening(false)
		end)

		return create("Frame")({
			Size = UDim2.new(0.98, 0, 0, 60),
			BackgroundColor3 = bgColor,
			Visible = keybind.visible,

			create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

			create("TextLabel")({ -- name on the left
				Size = UDim2.new(1, -140, 0.6, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 16, 0.5, 0),
				BackgroundTransparency = 1,

				Text = name,
				TextColor3 = Colors.textPrimary,
				TextSize = 22,
				TextXAlignment = "Left",
				FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
			}),

			create("Frame")({ -- the key pill
				Size = UDim2.fromOffset(96, 34),
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -16, 0.5, 0),
				BackgroundColor3 = boxColor,

				create("UICorner")({ CornerRadius = UDim.new(0, 8) }),
				create("UIStroke")({ Color = Colors.stroke, Thickness = 1.5 }),

				create("TextLabel")({
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,

					Text = function()
						return if listening() then "..." else key()
					end,
					TextColor3 = Colors.textPrimary,
					TextSize = 20,
					TextTruncate = "AtEnd",
					FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
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
					setListening(not listening()) -- click again to cancel
				end,
			}),
		})
	end

	return keybind
end

return Keybind
