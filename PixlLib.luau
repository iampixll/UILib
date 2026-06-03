-- ++++++++ WAX BUNDLED DATA BELOW ++++++++ --

-- Will be used later for getting flattened globals
local ImportGlobals

-- Holds direct closure data (defining this before the DOM tree for line debugging etc)
local ClosureBindings = {
    function()local wax,script,require=ImportGlobals(1)local ImportGlobals return (function(...)return require(script.PixlLib)

end)() end,
    function()local wax,script,require=ImportGlobals(2)local ImportGlobals return (function(...)local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local vide = require("./Packages/vide")
local Window = require("./Window")

local source = vide.source

local PixlLib = {}

PixlLib.Flags = {}

function PixlLib:Save()
	if not self.config or not self.config.Saving then
		return
	end

	local data = {}
	for flag, element in self.Flags do
		data[flag] = element:Get()
	end

	local json = HttpService:JSONEncode(data)

	if writefile then
		local folder = self.config.FolderName
		if not isfolder(folder) then
			makefolder(folder)
		end
		writefile(folder .. "/" .. self.config.FileName .. ".json", json)
	else
		print("PixlLib save (no writefile):", json)
	end
end

function PixlLib:Load()
	if not self.config or not self.config.Loading then
		return
	end

	if not readfile then
		print("PixlLib: readfile unavailable, skipping load") -- Studio: no file API
		return
	end

	local path = self.config.FolderName .. "/" .. self.config.FileName .. ".json"
	if not isfile(path) then
		return -- nothing saved yet, nothing to load
	end

	local data = HttpService:JSONDecode(readfile(path)) -- string -> table

	for flag, value in data do
		local element = self.Flags[flag]
		if element then
			element:Set(value) -- silent: no callback, no onChanged
		end
	end
end

local function onChanged()
	PixlLib:Save()
end

local notifications = source({})
local nextId = 0

local function removeById(id)
	local new = table.clone(notifications())
	new[id] = nil -- key disappears -> indexes destroys exactly this scope
	notifications(new)
end

function PixlLib:Notify(config)
	nextId += 1
	local id = nextId

	local new = table.clone(notifications())
	new[id] = {
		Title = config.Title,
		Content = config.Content,
		Image = config.Image,
	}
	notifications(new) -- triggers the renderer

	local duration = config.Duration or 6
	task.delay(duration, removeById, id)
end

function PixlLib:CreateWindow(config)
	if self._unmount then
		self._unmount()
	end

	self.Flags = {}
	self.config = config.Configuration

	local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

	local window
	local destroyScope = vide.mount(function()
		window = Window.new(config, notifications, self.Flags, onChanged)
		return window.node
	end, playerGui)

	self._unmount = function()
		destroyScope()
		if window.node then
			window.node:Destroy()
		end
	end

	if self.config and self.config.Loading then
		task.defer(function()
			self:Load()
		end)
	end

	return window
end

return PixlLib

end)() end,
    function()local wax,script,require=ImportGlobals(3)local ImportGlobals return (function(...)local vide = require("./Packages/vide")
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

end)() end,
    function()local wax,script,require=ImportGlobals(4)local ImportGlobals return (function(...)return {
	-- surfaces (dark -> light)
	bg = Color3.fromRGB(14, 17, 22), -- window + panel base
	surface = Color3.fromRGB(24, 28, 36), -- rows, controls
	surfaceHover = Color3.fromRGB(32, 37, 47),
	surfaceActive = Color3.fromRGB(38, 44, 56), -- active tab
	stroke = Color3.fromRGB(42, 48, 60), -- 1px row borders
	surfaceHigh2 = Color3.fromRGB(64, 72, 88), -- topmost interactive step (e.g. button hover)

	-- accent
	accent = Color3.fromRGB(123, 97, 255),
	accentSoft = Color3.fromRGB(157, 139, 255),
	cyan = Color3.fromRGB(56, 224, 255), -- slider thumb only

	-- text
	textPrimary = Color3.fromRGB(236, 238, 245),
	textSecondary = Color3.fromRGB(162, 168, 184),
	textMuted = Color3.fromRGB(110, 117, 133),
}

end)() end,
    function()local wax,script,require=ImportGlobals(5)local ImportGlobals return (function(...)local vide = require("./Packages/vide")

local create = vide.create

local Divider = {}

function Divider.new()
	local divider = {}

	function divider:render()
		return create("Frame")({
			Size = UDim2.new(0.98, 0, 0, 5),
			BackgroundTransparency = 1,
		})
	end

	return divider
end

return Divider

end)() end,
    function()local wax,script,require=ImportGlobals(6)local ImportGlobals return (function(...)local vide = require("./Packages/vide")
local Colors = require("./Colors")

local create = vide.create
local source = vide.source
local indexes = vide.indexes
local spring = vide.spring
local changed = vide.changed

local Dropdown = {}

function Dropdown.new(name, options, multiple, flag, callback, onChanged)
	multiple = if multiple == nil then true else multiple

	local dropdown = {}

	dropdown.flag = flag

	name = source(name)

	local optionList = source(options or {})

	local selected = source({})

	local function toArray(set)
		local arr = {}
		for name in set do
			table.insert(arr, name)
		end
		return arr
	end

	local function setSelected(newSet, fireCallback)
		selected(newSet)
		if fireCallback and callback then
			callback(toArray(newSet))
		end
		if fireCallback and onChanged then
			onChanged()
		end
	end

	function dropdown:render()
		local open = source(false) -- panel expanded?

		local searchText = source("")

		local searchFocused = source(false)

		local searchBoxColor = spring(function() -- inset field: darkest at rest, lifts on focus
			return if searchFocused() then Colors.surfaceActive else Colors.bg
		end, 0.3)

		local searchStrokeColor = spring(function() -- accent border while focused
			return if searchFocused() then Colors.accent else Colors.stroke
		end, 0.3)

		local hovered = source(false)
		local bgColor = spring(function() -- drives the HEADER only (the visible hull when closed)
			return if hovered() then Colors.surfaceHover else Colors.surface
		end, 0.3)

		local chevronRotation = spring(function()
			return if open() then 180 else 0
		end, 0.3)

		local panelHeight = spring(function() -- single height source for the whole expand/collapse
			return if open() then 294 else 0
		end, 0.3)

		local function allSelected()
			local count = 0
			for _ in selected() do
				count += 1
			end
			return count > 0 and count == #optionList() -- count > 0 guards the empty list
		end

		local allHovered = source(false)
		local allBgColor = spring(function() -- one step up the ladder on hover, like every row
			return if allHovered() then Colors.surfaceHover else Colors.surface
		end, 0.3)

		local allBoxColor = spring(function() -- fills with accent when everything is selected
			return if allSelected() then Colors.accent else Colors.bg
		end, 0.2)

		local searchHovered = source(false)
		local searchBgColor = spring(function() -- mirrors the option rows' / All button's hover
			return if searchHovered() then Colors.surfaceHover else Colors.surface
		end, 0.3)
		return create("Frame")({
			-- one frame, one animated height: header (60) + panel; clips the scroll frame as it grows/shrinks
			Size = function()
				return UDim2.new(0.98, 0, 0, 60 + panelHeight())
			end,
			BackgroundColor3 = Colors.bg, -- fixed dark backdrop the options rest on
			ClipsDescendants = true,

			create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

			create("Frame")({ -- header row, pinned to the top; this is the hoverable hull
				Size = UDim2.new(1, 0, 0, 60),
				Position = UDim2.fromScale(0, 0),
				BackgroundColor3 = bgColor,

				create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

				create("TextLabel")({ -- name on the left
					Size = UDim2.new(0.5, -16, 1, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 16, 0.5, 0),
					BackgroundTransparency = 1,

					Text = name,
					TextColor3 = Colors.textPrimary,
					TextSize = 22,
					TextXAlignment = "Left",
					FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
				}),

				create("TextLabel")({ -- summary on the right, derived from selection
					Size = UDim2.new(0.4, -48, 1, 0),
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -55, 0.5, 0),
					BackgroundTransparency = 1,

					Text = function()
						if not multiple then
							return next(selected()) or "Select Option"
						end
						local count = 0

						for _ in selected() do
							count += 1
						end

						if count == #optionList() then
							return "All selected"
						elseif count > 0 then
							return count .. " selected"
						else
							return "Select options"
						end
					end,
					TextColor3 = Colors.textMuted,
					TextSize = 20,
					TextXAlignment = "Right",
					FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
				}),

				create("ImageLabel")({ -- chevron, flips when open
					Size = UDim2.fromOffset(30, 30),
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -16, 0.5, 0),
					BackgroundTransparency = 1,

					Image = "rbxassetid://16093555964",
					ImageColor3 = Colors.textMuted,
					Rotation = chevronRotation,
				}),

				create("TextButton")({ -- click overlay toggles open
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					Text = "",

					Activated = function()
						open(not open())
					end,
				}),

				MouseEnter = function()
					hovered(true)
				end,
				MouseLeave = function()
					hovered(false)
				end,
			}),

			create("ScrollingFrame")({ -- pinned below the header; height is the animated panel height
				Size = function()
					return UDim2.new(0.975, 0, 0, panelHeight() - 10) -- gap subtracted so the bottom stays flush
				end,
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0, 70), -- 10px below the header instead of pulling up
				BackgroundTransparency = 1,
				ScrollBarThickness = 4,
				ScrollBarImageColor3 = Colors.textMuted,
				AutomaticCanvasSize = "Y",
				CanvasSize = UDim2.new(),

				create("UIListLayout")({ Padding = UDim.new(0, 12), HorizontalAlignment = "Left", SortOrder = "LayoutOrder" }),
				create("UIPadding")({
					PaddingTop = UDim.new(0, 2),
					PaddingBottom = UDim.new(0, 6),
					PaddingLeft = UDim.new(0, 4),
					PaddingRight = UDim.new(0, 4),
				}),

				create("Frame")({ -- fixed top row: search (full InputBox element) + select-all
					Size = UDim2.new(0.98, 0, 0, 60),
					LayoutOrder = 0,
					BackgroundTransparency = 1,

					create("Frame")({ -- search
						Size = if multiple then UDim2.new(0.8325, 0, 1, 0) else UDim2.new(1, 0, 1, 0),
						BackgroundColor3 = searchBgColor,

						MouseEnter = function()
							searchHovered(true)
						end,
						MouseLeave = function()
							searchHovered(false)
						end,

						create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

						create("TextLabel")({ -- name
							Size = UDim2.new(0.45, -16, 0.6, 0),
							AnchorPoint = Vector2.new(0, 0.5),
							Position = UDim2.new(0, 16, 0.5, 0),
							BackgroundTransparency = 1,

							Text = "Browse Options",
							TextColor3 = Colors.textPrimary,
							TextSize = 22,
							TextXAlignment = "Left",
							FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
						}),

						create("Frame")({ -- input field background
							Size = if multiple then UDim2.new(0, 250, 0.6, 0) else UDim2.new(0, 300, 0.6, 0),
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(1, -16, 0.5, 0),
							BackgroundColor3 = searchBoxColor,

							create("UICorner")({ CornerRadius = UDim.new(0, 8) }),
							create("UIStroke")({
								Color = searchStrokeColor,
								Thickness = 1.5,
							}),
							create("UIPadding")({
								PaddingLeft = UDim.new(0, 10),
								PaddingRight = UDim.new(0, 10),
							}),

							create("TextBox")({
								Size = UDim2.fromScale(1, 1),
								BackgroundTransparency = 1,
								ClearTextOnFocus = false,

								Text = "",
								PlaceholderText = "Option Name Here",
								PlaceholderColor3 = Colors.textMuted,
								TextColor3 = Colors.textPrimary,
								TextSize = 22,
								TextXAlignment = "Left",
								FontFace = Font.fromName("Montserrat"),

								Focused = function()
									searchFocused(true)
								end,
								FocusLost = function()
									searchFocused(false)
								end,

								changed("Text", function(text)
									searchText(text)
								end),
							}),
						}),
					}),

					create("Frame")({ -- select-all button
						Size = UDim2.new(0.15, 0, 1, 0),
						AnchorPoint = Vector2.new(1, 0),
						Position = UDim2.new(1, 0, 0, 0),
						Visible = multiple,
						BackgroundColor3 = allBgColor,

						create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

						create("TextLabel")({ -- "All" label
							Size = UDim2.new(1, -56, 1, 0),
							AnchorPoint = Vector2.new(0, 0.5),
							Position = UDim2.new(0, 16, 0.5, 0),
							BackgroundTransparency = 1,

							Text = "All",
							TextColor3 = Colors.textPrimary,
							TextSize = 22,
							TextXAlignment = "Left",
							FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
						}),

						create("Frame")({ -- checkbox
							Size = UDim2.fromOffset(24, 24),
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(1, -16, 0.5, 0),
							BackgroundColor3 = allBoxColor,

							create("UICorner")({ CornerRadius = UDim.new(0, 8) }),
							create("UIStroke")({ Color = Colors.stroke, Thickness = 1.5 }),
						}),

						create("TextButton")({ -- click overlay: hover + toggle all on/off
							Size = UDim2.fromScale(1, 1),
							BackgroundTransparency = 1,
							Text = "",

							MouseEnter = function()
								allHovered(true)
							end,
							MouseLeave = function()
								allHovered(false)
							end,
							Activated = function()
								if allSelected() then
									setSelected({}, true)
								else
									local new = {}
									for _, optionName in optionList() do
										new[optionName] = true -- otherwise fill the whole list
									end
									setSelected(new, true)
								end
							end,
						}),
					}),
				}),

				indexes(function()
					local query = searchText():lower()
					local matches = {}
					for _, name in optionList() do
						if string.find(name:lower(), query, 1, true) then
							table.insert(matches, name)
						end
					end

					return matches
				end, function(option, i)
					local hovered = source(false)
					local bgColor = spring(function() -- rests on surface over the dark backdrop, hovers one step up
						return if hovered() then Colors.surfaceHover else Colors.surface
					end, 0.3)

					local boxColor = spring(function() -- inset checkbox, fills with accent when checked
						return if selected()[option()] then Colors.accent else Colors.bg
					end, 0.2)

					local markColor = spring(function()
						return if selected()[option()] then Colors.accent else Colors.textMuted
					end, 0.2)

					return create("Frame")({
						Size = UDim2.new(0.98, 0, 0, 60),
						LayoutOrder = i + 1,
						BackgroundColor3 = bgColor,

						create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

						create("TextLabel")({ -- option name, leaves room for the box on the right
							Size = UDim2.new(1, -80, 1, 0),
							AnchorPoint = Vector2.new(0, 0.5),
							Position = UDim2.new(0, 16, 0.5, 0),
							BackgroundTransparency = 1,

							Text = option,
							TextColor3 = Colors.textPrimary,
							TextSize = 22,
							TextXAlignment = "Left",
							FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
						}),

						create("Frame")({ -- checkbox
							Size = UDim2.fromOffset(26, 26),
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(1, -16, 0.5, 0),
							Visible = multiple,
							BackgroundColor3 = boxColor,

							create("UICorner")({ CornerRadius = UDim.new(0, 8) }),
							create("UIStroke")({ Color = Colors.stroke, Thickness = 1.5 }),
						}),

						create("ImageLabel")({ -- fingerprint marker (single-select)
							Size = UDim2.fromOffset(24, 24),
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(1, -16, 0.5, 0),
							BackgroundTransparency = 1,
							Visible = not multiple,

							Image = "rbxassetid://16089599792",
							ImageColor3 = markColor,
						}),

						create("TextButton")({ -- click overlay: hover + toggle the box
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
								if multiple then
									local new = table.clone(selected())
									new[option()] = if new[option()] then nil else true
									setSelected(new, true)
								else
									if selected()[option()] then
										setSelected({}, true)
									else
										setSelected({ [option()] = true }, true)
									end
								end
							end,
						}),
					})
				end),
			}),
		})
	end

	function dropdown:Get()
		return toArray(selected())
	end

	function dropdown:Set(options)
		local new = {}
		for _, name in options do
			new[name] = true
		end
		setSelected(new, false)
	end

	return dropdown
end

return Dropdown

end)() end,
    function()local wax,script,require=ImportGlobals(7)local ImportGlobals return (function(...)local vide = require("./Packages/vide")
local Colors = require("./Colors")

local create = vide.create
local source = vide.source
local spring = vide.spring

local InputBox = {}

function InputBox.new(name, isNumber, currentValue, placeholder, flag, callback, onChanged)
	local input = {}

	input.flag = flag

	name = source(name)

	local value = source(currentValue or "") -- committed value, single source of truth

	local function setValue(newValue, fireCallback)
		if newValue ~= value() then
			value(newValue)
			if fireCallback and callback then
				callback(newValue)
			end
			if fireCallback and onChanged then
				onChanged()
			end
		end
	end

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
			Text = value,
			PlaceholderText = placeholder or "",
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
				if isNumber then
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
		return create("Frame")({
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

	function input:Get()
		return value()
	end

	function input:Set(newValue)
		setValue(newValue, false) -- silent, consistent with Toggle/Slider
	end

	return input
end

return InputBox

end)() end,
    function()local wax,script,require=ImportGlobals(8)local ImportGlobals return (function(...)local vide = require("./Packages/vide")
local Colors = require("./Colors")

local create = vide.create
local source = vide.source

local Label = {}

function Label.new(name)
	local label = {}

	name = source(name)

	function label:render()
		return create("TextLabel")({
			Size = UDim2.new(0.98, 0, 0, 28),
			BackgroundTransparency = 1,

			Text = name,
			TextColor3 = Colors.textPrimary,
			TextSize = 24,
			TextXAlignment = "Left",
			TextYAlignment = "Bottom",

			FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold),
		})
	end

	function label:Set(newName)
		name(newName)
	end

	return label
end

return Label

end)() end,
    function()local wax,script,require=ImportGlobals(9)local ImportGlobals return (function(...)local vide = require("./Packages/vide")
local Colors = require("./Colors")

local create = vide.create
local spring = vide.spring

local Notification = {}

function Notification.new(config, present)
	local notification = {}

	local offset = spring(function()
		return if present() then 0 else 350 -- slides in from +350px right
	end, 0.3)

	local transparency = spring(function()
		return if present() then 0 else 1
	end, 0.3)

	notification.node = create("Frame")({ -- wrapper: the layout child, stays put
		Size = UDim2.new(0, 300, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,

		create("Frame")({ -- the actual card, slides freely inside the wrapper
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = "Y",
			Position = function()
				return UDim2.fromOffset(offset(), 0)
			end,
			BackgroundColor3 = Colors.surfaceHover,
			BackgroundTransparency = transparency,

			create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

			create("UIStroke")({ -- subtle outer border, fades with the card
				Color = Colors.surface,
				Thickness = 4,
				Transparency = function()
					return 0.7 + transparency() * 0.3 -- 0.7 visible -> 1.0 gone
				end,
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

			create("Frame")({ -- title row
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
					ImageTransparency = transparency,
				}),

				create("TextLabel")({ -- title
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = "Y",
					BackgroundTransparency = 1,
					Text = config.Title,
					TextWrapped = true,
					TextColor3 = Colors.textPrimary,
					TextTransparency = transparency,
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
				TextColor3 = Colors.textSecondary,
				TextTransparency = transparency,
				TextSize = 22,
				TextXAlignment = "Left",
				FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
			}),
		}),
	})

	return notification
end

return Notification

end)() end,
    function()local wax,script,require=ImportGlobals(10)local ImportGlobals return (function(...)local vide = require("./Packages/vide")
local Colors = require("./Colors")

local create = vide.create

local Paragraph = {}

function Paragraph.new(title, content)
	local paragraph = {}

	function paragraph:render()
		return create("Frame")({
			Size = UDim2.new(0.98, 0, 0, 0),
			BackgroundColor3 = Colors.surface,
			AutomaticSize = "Y",

			create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

			create("UIPadding")({ -- inner spacing from the frame edges
				PaddingTop = UDim.new(0, 12),
				PaddingBottom = UDim.new(0, 12),
				PaddingLeft = UDim.new(0, 16),
				PaddingRight = UDim.new(0, 16),
			}),

			create("UIListLayout")({ -- stacks children, frame sums their height
				Padding = UDim.new(0, 8),
				SortOrder = "LayoutOrder",
			}),

			create("TextLabel")({ -- title
				Size = UDim2.new(1, 0, 0, 28),
				LayoutOrder = 1,
				BackgroundTransparency = 1,

				Text = title,
				TextColor3 = Colors.textPrimary,
				TextSize = 24,
				TextXAlignment = "Left",
				FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold),
			}),

			create("TextLabel")({ -- content
				Size = UDim2.new(1, 0, 0, 0), -- X fixed, Y grows with text
				LayoutOrder = 2,
				AutomaticSize = "Y",
				BackgroundTransparency = 1,

				Text = content,
				TextWrapped = true,
				TextColor3 = Colors.textSecondary,
				TextSize = 22,
				TextXAlignment = "Left",
				FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
			}),
		})
	end

	return paragraph
end

return Paragraph

end)() end,
    function()local wax,script,require=ImportGlobals(11)local ImportGlobals return (function(...)local UserInputService = game:GetService("UserInputService")

local vide = require("./Packages/vide")
local Colors = require("./Colors")

local create = vide.create
local source = vide.source
local spring = vide.spring

local Slider = {}

function Slider.new(name, suffix, range, increment, currentValue, flag, callback, onChanged)
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

	function slider:render()
		local dragging = source(false)
		local hovered = source(false)

		local bgColor = spring(function()
			return if hovered() then Colors.surfaceHover else Colors.surface
		end, 0.3)
		local thumbScale = spring(function()
			return if dragging() then 1.2 else 1
		end, 0.2)
		local fillFraction = spring(fraction, 0.15)

		local track
		local function updateFromX(mouseX)
			local f = (mouseX - track.AbsolutePosition.X) / track.AbsoluteSize.X
			setValue(min + f * (max - min), true)
		end

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
				if dragging() and onChanged then
					onChanged()
				end
				dragging(false)
			end
		end)
		vide.cleanup(endConn)

		return create("Frame")({
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
	end

	function slider:Get()
		return value()
	end

	function slider:Set(newValue)
		setValue(newValue, false)
	end

	return slider
end

return Slider

end)() end,
    function()local wax,script,require=ImportGlobals(12)local ImportGlobals return (function(...)local vide = require("./Packages/vide")
local Button = require("./Button")
local Divider = require("./Divider")
local Dropdown = require("./Dropdown")
local InputBox = require("./InputBox")
local Label = require("./Label")
local Paragraph = require("./Paragraph")
local Slider = require("./Slider")
local Toggle = require("./Toggle")

local source = vide.source

local Tab = {}

local function addChild(self, handle)
	local new = table.clone(self.children())
	table.insert(new, handle)
	self.children(new)

	if handle.flag then
		self.flags[handle.flag] = handle
	end

	return handle
end

function Tab.new(name, image, flags, onChanged)
	local tab = {
		name = name,
		image = image,
		flags = flags,
		onChanged = onChanged,
		children = source({}),
	}

	function tab:CreateButton(config)
		return addChild(self, Button.new(config.Name, config.Callback))
	end

	function tab:CreateLabel(name)
		return addChild(self, Label.new(name))
	end

	function tab:CreateDivider()
		return addChild(self, Divider.new())
	end

	function tab:CreateParagraph(config)
		return addChild(self, Paragraph.new(config.Title, config.Content))
	end

	function tab:CreateToggle(config)
		return addChild(self, Toggle.new(config.Name, config.CurrentValue, config.Flag, config.Callback, self.onChanged))
	end

	function tab:CreateSlider(config)
		return addChild(self, Slider.new(config.Name, config.Suffix, config.Range, config.Increment, config.CurrentValue, config.Flag, config.Callback, self.onChanged))
	end

	function tab:CreateInput(config)
		return addChild(self, InputBox.new(config.Name, config.IsNumber, config.CurrentValue, config.Placeholder, config.Flag, config.Callback, self.onChanged))
	end

	function tab:CreateDropdown(config)
		return addChild(self, Dropdown.new(config.Name, config.Options, config.MultipleOptions, config.Flag, config.Callback, self.onChanged))
	end

	return tab
end

return Tab

end)() end,
    function()local wax,script,require=ImportGlobals(13)local ImportGlobals return (function(...)local vide = require("./Packages/vide")
local Colors = require("./Colors")

local create = vide.create
local source = vide.source
local spring = vide.spring

-- thumb positions inside the track (scale, so it scales with the track)
local THUMB_OFF = UDim2.fromScale(0.28, 0.5)
local THUMB_ON = UDim2.fromScale(0.72, 0.5)

local Toggle = {}

function Toggle.new(name, currentValue, flag, callback, onChanged)
	local toggle = {}

	toggle.flag = flag

	name = source(name)
	local on = source(currentValue or false) -- the actual bool state

	local function setValue(value, fireCallback)
		on(value)
		if fireCallback and callback then
			callback(on())
		end
		if fireCallback and onChanged then
			onChanged()
		end
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

		return create("Frame")({
			Size = UDim2.new(0.98, 0, 0, 60),
			BackgroundColor3 = bgColor,

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

	function toggle:Get()
		return on()
	end

	function toggle:Set(value)
		setValue(value, false)
	end

	return toggle
end

return Toggle

end)() end,
    function()local wax,script,require=ImportGlobals(14)local ImportGlobals return (function(...)local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local vide = require("./Packages/vide")
local Colors = require("./Colors")
local Notification = require("./Notification")
local Tab = require("./Tab")

local camera = workspace.CurrentCamera
local localPlayer = Players.LocalPlayer
local playerName = localPlayer and localPlayer.Name or "Player"
local userId = localPlayer and localPlayer.UserId or 1

local source = vide.source
local create = vide.create
local spring = vide.spring
local indexes = vide.indexes

local OPENED_POSITION = UDim2.new(0.5, 0, 0.5, 0)
local CLOSED_POSITION = UDim2.new(0.5, 0, 1.5, 0)

-- layout raster (px, inside the mainframe) -- change PAD to tighten/loosen everywhere
local PAD = 8
local TOPBAR_H = 66
local TABLIST_W = 220
local ROW_Y = PAD + TOPBAR_H + PAD -- top of the tablist/content row

local Window = {}
Window.__index = Window

local function makeDraggable(positionSource, scale, locked)
	local dragging = false
	local dragStart = nil
	local startOffset = nil
	local wasDragged = false

	local conn = UserInputService.InputChanged:Connect(function(input)
		if dragging and not (locked and locked()) and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = (input.Position - dragStart) / scale()

			if delta.Magnitude > 5 then
				wasDragged = true
			end

			local newX = startOffset.X + delta.X
			local newY = startOffset.Y + delta.Y

			local current = positionSource()
			local newPosition = UDim2.new(current.X.Scale, newX, current.Y.Scale, newY)

			positionSource(newPosition)
		end
	end)
	vide.cleanup(conn)

	local function began(input)
		if locked and locked() then
			wasDragged = false
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			wasDragged = false
			dragging = true

			dragStart = input.Position
			startOffset = Vector2.new(positionSource().X.Offset, positionSource().Y.Offset)
		end
	end

	local function ended(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end

	return {
		began = began,
		ended = ended,

		wasDragged = function()
			return wasDragged
		end,
	}
end

local function createTopbar(props)
	local minimizeHovered = source(false)
	local minimizeColor = spring(function()
		return if minimizeHovered() then Colors.surfaceHigh2 else Colors.surfaceHover
	end, 0.3)

	return create("Frame")({ -- floating panel: PAD inset on top/left/right, fixed height
		Size = UDim2.new(1, -PAD * 2, 0, TOPBAR_H),
		Position = UDim2.fromOffset(PAD, PAD),
		BackgroundColor3 = Colors.bg, -- panel, same family as tablist/content

		create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

		create("TextLabel")({
			Size = UDim2.fromScale(0.5, 0.7),
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0.02, 0.5),
			BackgroundTransparency = 1,

			Text = props.title,
			TextSize = 38,
			TextColor3 = Colors.textPrimary,
			TextXAlignment = "Left",
			FontFace = Font.fromName("Montserrat", Enum.FontWeight.ExtraBold),
		}),

		create("Frame")({ -- player display
			Size = UDim2.fromOffset(0, 40), -- X grows with content, Y fixed
			AutomaticSize = "X",
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(0.98, -55, 0.5, 0),
			BackgroundColor3 = Colors.surfaceHover, -- control resting on the bg panel

			create("UICorner")({ CornerRadius = UDim.new(0, 8) }),

			create("UIListLayout")({ -- icon then name, side by side
				FillDirection = "Horizontal",
				VerticalAlignment = "Center",
				Padding = UDim.new(0, 8),
				SortOrder = "LayoutOrder",
			}),

			create("UIPadding")({ -- inner spacing so content isn't flush to the edges
				PaddingLeft = UDim.new(0, 6),
				PaddingRight = UDim.new(0, 10),
			}),

			create("Frame")({ -- avatar, fixed square, no manual position (layout places it)
				Size = UDim2.fromOffset(32, 32),
				LayoutOrder = 1,
				BackgroundColor3 = Colors.surface,

				create("UICorner")({ CornerRadius = UDim.new(1, 0) }),

				create("ImageLabel")({
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					Image = "rbxthumb://type=AvatarHeadShot&id=" .. props.userId .. "&w=420&h=420",

					create("UICorner")({ CornerRadius = UDim.new(1, 0) }),
				}),
			}),

			create("TextLabel")({ -- name, width grows with text
				Size = UDim2.fromOffset(0, 35),
				AutomaticSize = "X",
				LayoutOrder = 2,
				BackgroundTransparency = 1,

				Text = props.playerName,
				TextSize = 28,
				TextColor3 = Colors.textSecondary,
				TextXAlignment = "Left",
				FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
			}),
		}),

		create("ImageButton")({ -- minimize button
			Size = UDim2.fromOffset(40, 40),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.fromScale(0.98, 0.5),
			BackgroundColor3 = minimizeColor,

			Image = "rbxassetid://71627683074088",
			ImageColor3 = Colors.textPrimary,

			create("UICorner")({ CornerRadius = UDim.new(0, 8) }),

			MouseButton1Click = props.onMinimize,

			MouseEnter = function()
				minimizeHovered(true)
			end,
			MouseLeave = function()
				minimizeHovered(false)
			end,
		}),

		InputBegan = props.onDragBegan,
		InputEnded = props.onDragEnded,
	})
end

local function createTopButton(props)
	local iconTransparency = spring(function()
		return if props.locked() then 0 else 1
	end, 0.3)

	return create("Frame")({
		Size = UDim2.fromScale(0.075, 0.0375),
		AnchorPoint = Vector2.new(0.5, 0),
		Position = props.position,
		BackgroundColor3 = Colors.surfaceHover, -- floating pill, lifted off the mainframe
		ZIndex = 9999,

		create("UICorner")({
			CornerRadius = UDim.new(0, 12),
		}),

		create("UIStroke")({ -- subtle outer border
			Color = Colors.surface,
			Thickness = 4,
			Transparency = 0.7,
		}),

		create("TextLabel")({
			Size = UDim2.fromScale(0.9, 0.8),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			BackgroundTransparency = 1,

			Text = function()
				return if props.minimized() then "Open" else "Close"
			end,

			TextColor3 = Colors.textPrimary,
			TextSize = 34,
			FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold),
		}),

		create("TextButton")({
			Size = UDim2.fromScale(1, 1),
			Transparency = 1,

			MouseButton1Click = props.onToggle,

			InputBegan = function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton2 then
					props.onToggleLock()
				else
					props.onDragBegan(input)
				end
			end,
			InputEnded = props.onDragEnded,
		}),

		create("ImageLabel")({
			Size = UDim2.fromScale(0.6, 0.6),
			SizeConstraint = "RelativeYY",
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(0.95, 0, 0.5, 0),
			BackgroundTransparency = 1,

			Image = "rbxassetid://126141499544212",
			ImageColor3 = Colors.textMuted,
			ImageTransparency = iconTransparency,

			Visible = function()
				return props.locked()
			end,
		}),
	})
end

local function createTabList(props)
	return create("Frame")({ -- tablist: left column, below the topbar row
		Size = UDim2.new(0, TABLIST_W, 1, -(ROW_Y + PAD)),
		Position = UDim2.fromOffset(PAD, ROW_Y),
		BackgroundColor3 = Colors.bg,

		create("ScrollingFrame")({
			Size = UDim2.fromScale(0.925, 0.95),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),

			ScrollBarThickness = 4,
			VerticalScrollBarPosition = "Left",

			ScrollBarImageColor3 = Colors.textMuted,
			AutomaticCanvasSize = "Y",
			CanvasSize = UDim2.new(),

			Transparency = 1,

			create("UIListLayout")({
				Padding = UDim.new(0, 4),
				HorizontalAlignment = "Center",
				SortOrder = "LayoutOrder",
			}),

			indexes(props.tabs, function(tab, i)
				local hovered = source(false)

				local function targetBgColor()
					if props.activeTab() == tab() then
						return Colors.surfaceActive -- active: brightest static step
					elseif hovered() then
						return Colors.surfaceHover -- real hover
					else
						return Colors.bg -- idle: blends into the tablist panel
					end
				end
				local bgColor = spring(targetBgColor, 0.3)

				local function targetTextColor()
					if props.activeTab() == tab() then
						return Colors.textPrimary
					else
						return Colors.textMuted
					end
				end
				local textColor = spring(targetTextColor, 0.3)

				return create("Frame")({
					Size = UDim2.new(0.925, 0, 0.1, 0),
					BackgroundColor3 = bgColor,

					create("UICorner")({
						CornerRadius = UDim.new(0, 12),
					}),

					create("TextButton")({
						Size = UDim2.fromScale(1, 1),

						BackgroundTransparency = 1,
						Text = "",

						Activated = function()
							props.onSelect(tab())
						end,

						MouseEnter = function()
							hovered(true)
						end,

						MouseLeave = function()
							hovered(false)
						end,
					}),

					create("ImageLabel")({
						Size = UDim2.fromScale(0.6, 0.6),
						SizeConstraint = "RelativeYY",
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0, 8, 0.5, 0),
						BackgroundTransparency = 1,

						Image = function()
							local img = tab().image
							return if img then "rbxassetid://" .. img else "rbxassetid://15637356511"
						end,

						ImageColor3 = textColor,
					}),

					create("TextLabel")({
						Size = UDim2.new(1, -48, 0.6, 0),
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -8, 0.5, 0),
						BackgroundTransparency = 1,

						Text = function()
							return tab().name
						end,

						TextColor3 = textColor,

						TextXAlignment = "Left",
						TextSize = 24,
						FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold),
					}),
				})
			end),
		}),

		create("UICorner")({
			CornerRadius = UDim.new(0, 12),
		}),
	})
end

local function createCurrentTab(props)
	return create("Frame")({ -- content: fills the rest of the row, right of the tablist
		Size = UDim2.new(1, -(PAD + TABLIST_W + PAD + PAD), 1, -(ROW_Y + PAD)),
		Position = UDim2.fromOffset(PAD + TABLIST_W + PAD, ROW_Y),
		BackgroundColor3 = Colors.bg,

		create("UICorner")({
			CornerRadius = UDim.new(0, 12),
		}),

		indexes(props.tabs, function(tab, i)
			return create("Frame")({
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Visible = function()
					return props.activeTab() == tab()
				end,

				create("ScrollingFrame")({
					Size = UDim2.fromScale(0.975, 0.95),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					BackgroundTransparency = 1,
					ScrollBarThickness = 4,
					ScrollBarImageColor3 = Colors.textMuted,
					AutomaticCanvasSize = "Y",
					CanvasSize = UDim2.new(),

					create("UIListLayout")({
						Padding = UDim.new(0, 12),
						HorizontalAlignment = "Left",
						SortOrder = "LayoutOrder",
					}),

					indexes(function()
						return tab().children()
					end, function(child)
						return child():render()
					end),
				}),
			})
		end),
	})
end

local function createNotificationStack(props)
	return create("Frame")({
		Size = UDim2.new(0, 350, 1, 0),
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,

		create("UIListLayout")({
			HorizontalAlignment = "Right",
			VerticalAlignment = "Bottom",
			Padding = UDim.new(0, 16),
			SortOrder = "LayoutOrder",
		}),

		create("UIPadding")({
			PaddingBottom = UDim.new(0, 16),
			PaddingRight = UDim.new(0, 16),
		}),

		indexes(props.notifications, function(entry, id, present)
			return Notification.new(entry(), present).node, 0.4
		end),
	})
end

function Window.new(config, notifications, flags, onChanged)
	config = config or {}

	local self = setmetatable({}, Window)

	self.flags = flags
	self.onChanged = onChanged

	self.tabs = source({})
	self.activeTab = source(nil)

	local toggleKey = Enum.KeyCode[config.ToggleKey or "K"]

	local scale = source(1)
	local minimized = source(false)

	local topButtonPos = source(UDim2.new(0.5, 0, 0.01, 0))
	local topDisplayPos = spring(topButtonPos, 0.1)
	local locked = source(false)

	local windowPos = source(OPENED_POSITION)
	local displayPos = spring(function()
		return if minimized() then CLOSED_POSITION else windowPos()
	end, 0.3)

	local function toggleMinimized()
		local nowMinimized = not minimized()
		if not nowMinimized then
			windowPos(OPENED_POSITION)
		end
		minimized(nowMinimized)
	end

	local mainDrag = makeDraggable(windowPos, scale, nil)
	local topDrag = makeDraggable(topButtonPos, scale, locked)

	local function updateScale()
		local vp = camera.ViewportSize
		scale(math.min(vp.X / 1920, vp.Y / 1080))
	end

	local conn = camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
	vide.cleanup(conn)
	updateScale()

	local keyConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end

		if input.KeyCode == toggleKey then
			toggleMinimized()
		end
	end)
	vide.cleanup(keyConn)

	self.node = create("ScreenGui")({
		create("UIScale")({ Scale = scale }),

		create("Frame")({ -- mainframe (footer removed -> shorter)
			Size = UDim2.fromOffset(960, 540),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = displayPos,
			BackgroundColor3 = Colors.surfaceActive,

			create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

			create("UIStroke")({ -- subtle outer border
				Color = Colors.surface,
				Thickness = 4,
				Transparency = 0.7,
			}),

			createTopbar({
				title = config.Title,
				onMinimize = toggleMinimized,
				onDragBegan = mainDrag.began,
				onDragEnded = mainDrag.ended,

				playerName = playerName,
				userId = userId,
			}),

			createTabList({
				tabs = self.tabs,
				activeTab = self.activeTab,
				onSelect = function(tab)
					self.activeTab(tab)
				end,
			}),
			createCurrentTab({
				tabs = self.tabs,
				activeTab = self.activeTab,
			}),
		}),

		createTopButton({
			minimized = minimized,
			position = topDisplayPos,
			onDragBegan = topDrag.began,
			onDragEnded = topDrag.ended,
			locked = locked,

			onToggle = function()
				if topDrag.wasDragged() then
					return
				end
				toggleMinimized()
			end,
			onToggleLock = function()
				locked(not locked())
			end,
		}),

		createNotificationStack({
			notifications = notifications, -- the source, see below
		}),
	})

	return self
end

function Window:CreateTab(name, image)
	local tab = Tab.new(name, image, self.flags, self.onChanged)

	local new = table.clone(self.tabs())
	table.insert(new, tab)
	self.tabs(new)

	if self.activeTab() == nil then
		self.activeTab(tab)
	end

	return tab
end

return Window

end)() end,
    [18] = function()local wax,script,require=ImportGlobals(18)local ImportGlobals return (function(...)assert(game, "when using vide outside of Roblox, require lib.luau instead")

local vide = require(script.lib)

export type source<T> = vide.source<T>
export type Source<T> = vide.Source<T>
export type context<T> = vide.context<T>
export type Context<T> = vide.Context<T>

return vide

end)() end,
    [19] = function()local wax,script,require=ImportGlobals(19)local ImportGlobals return (function(...)type Action = {
    priority: number,
    callback: (Instance) -> ()
}

local ActionMT = table.freeze {}

local function is_action(v: any)
    return getmetatable(v) == ActionMT
end

local function action(callback: (Instance) -> (), priority: number?): Action
    local a = {
        priority = priority or 1,
        callback = callback
    }

    setmetatable(a :: any, ActionMT)

    return table.freeze(a)
end

return function()
    return action, is_action
end

end)() end,
    [20] = function()local wax,script,require=ImportGlobals(20)local ImportGlobals return (function(...)local typeof = game and typeof or require "../test/mock".typeof :: never

local flags = require "./flags"
local implicit_effect = require "./implicit_effect"
local _, is_action = require "./action"()
local graph = require "./graph"
type Node<T> = graph.Node<T>

type Array<V> = { V }
type ArrayOrV<V> = {ArrayOrV<V>} | V
type Map<K, V> = { [K]: V }

type Cache = {
    -- event listeners to connect after properties are set
    events: Array<
        | string -- 1. event name
        | () -> () -- 2. listener
    >,

    -- actions to run after events are connected
    actions: Map<
        number, -- priority
        Array<(Instance) -> ()> -- action callbacks
    >,

    -- what to parent the instance to after running actions
    parent: unknown,

    -- cache to detect duplicate property setting at same nesting depth
    nested_debug: Map<
        number, -- depth
        Map<string, true> -- set of property names
    >,

    -- each nested layer occupies two indexes: 1. table ref 2. nested depth
    -- e.g. { t1 = { t3 = {} }, t2 = {} } -> { t1, 1, t2, 1, t3, 2 }
    nested_stack: { {} | number }
}

local free_cache: Cache?

local function borrow_cache(): Cache
    if free_cache then
        local cache = free_cache
        free_cache = nil
        return cache
    else
        return {
            events = {},
            actions = setmetatable({} :: any, { -- lazy init
                __index = function(self, i) self[i] = {}; return self[i] end
            }),
            parent = nil,
            nested_debug = setmetatable({} :: any, {
                __index = function(self, i: number) self[i] = {}; return self[i] end
            }),
            nested_stack = {}
        }
    end
end

local function return_cache(cache: Cache )
    free_cache = cache
end

local function process_properties(properties: Map<unknown, unknown>, instance: Instance, cache: Cache, depth: number)
    for property, value in properties do
        if type(property) == "string" then
            if flags.strict then -- check for duplicate property assignment at nesting depth
                if cache.nested_debug[depth][property] then
                    error(`duplicate property {property} at depth {depth}`, 0)
                end
                cache.nested_debug[depth][property] = true
            end

            if property == "Parent" then
                cache.parent = value
                continue
            end

            if type(value) == "function" then 
                if typeof((instance :: any)[property]) == "RBXScriptSignal" then
                    table.insert(cache.events, property) -- add event name to buffer
                    table.insert(cache.events, value :: () -> ()) -- add event listener to buffer
                else
                    implicit_effect.property(instance, property, value :: () -> ()) -- create implicit effect for property
                end
            else
                (instance :: any)[property] = value -- set property
            end    
        elseif type(property) == "number" then
            if type(value) == "function" then
                implicit_effect.children(instance, value :: () -> ArrayOrV<Instance>) -- bind children
            elseif type(value) == "table" then
                if is_action(value) then
                    table.insert(cache.actions[(value :: any).priority], (value :: any).callback :: () -> ()) -- add action to buffer
                elseif flags.defer_nested_properties then
                    table.insert(cache.nested_stack, value :: {})
                    table.insert(cache.nested_stack, depth + 1) -- push table to stack for later processing
                else
                    process_properties(value :: Map<unknown, unknown>, instance, cache, depth + 1)
                end
            elseif type(value) == "userdata" then
                (value :: Instance).Parent = instance -- parent child
            end
        end
    end
end

-- applies table of nested properties to an instance using full vide semantics
local function apply<T>(instance: T & Instance, properties: { [unknown]: unknown }): T
    if not properties then
        error "attempt to call a constructor returned by create() with no properties"
    end

    local caches = borrow_cache()
    local events = caches.events
    local actions = caches.actions
    local nested_debug = caches.nested_debug
    local nested_stack = caches.nested_stack

    -- process all properties
    local depth = 1
    repeat
        process_properties(properties, instance, caches, depth)
        depth = table.remove(nested_stack) :: number
        properties = table.remove(nested_stack) :: {}
    until not properties

    for i = 1, #events, 2 do
        local event_name = events[i]
        local event_listener = events[i + 1]
        ;(instance :: any)[event_name]:Connect(event_listener)
    end

    for _, queued in actions do
        for _, callback in queued do
            callback(instance)
        end
    end

    local parent = caches.parent
    if parent then
        if type(parent) == "function" then
            implicit_effect.parent(instance, parent :: () -> Instance)
        else
            instance.Parent = parent :: Instance
        end
    end

    table.clear(events)
    for _, queued in actions do table.clear(queued) end
    caches.parent = nil
    if flags.strict then table.clear(nested_debug) end
    table.clear(nested_stack)

    return_cache(caches)

    return instance
end

return apply

end)() end,
    [21] = function()local wax,script,require=ImportGlobals(21)local ImportGlobals return (function(...)local flags = require "./flags"
local graph = require "./graph"

local function batch(setter: () -> ())
    local already_batching = flags.batch
    local from

    if not already_batching then
        flags.batch = true
        from = graph.get_update_queue_length()
    end

    local ok, err: string? = xpcall(setter, debug.traceback)

    if not already_batching then
        flags.batch = false
        graph.flush_update_queue(from)
    end

    if not ok then error(`error occured while batching updates: {err}`, 0) end
end

return batch

end)() end,
    [22] = function()local wax,script,require=ImportGlobals(22)local ImportGlobals return (function(...)local graph = require "./graph"
type Node<T> = graph.Node<T>
local create_node = graph.create_node
local push_scope = graph.push_scope
local pop_scope = graph.pop_scope
local destroy = graph.destroy
local get_scope = graph.get_scope

local function branch<T>(fn: () -> T): (() -> (), T)
    local current = get_scope()
    if not current then
        error(`cannot use branch() outside a stable or reactive scope`, 0)
    end

    local parent = current.owner
    if not parent or parent.effect then
        error(`current scope is not owned by a stable scope`, 0)
    end

    local node = create_node(parent, false, false)

    local destroy = function()
        destroy(node)
    end

    push_scope(node)

    local ok, result = xpcall(fn, debug.traceback)

    pop_scope()

    if not ok then
        destroy()
        error(`error while running branch():\n\n{result}`, 0)
    end

    return destroy, result
end

return branch

end)() end,
    [23] = function()local wax,script,require=ImportGlobals(23)local ImportGlobals return (function(...)local action = require "./action"()
local cleanup = require "./cleanup"

local function changed<T>(property: string, callback: (T) -> ())
    return action(function(instance)
        local con = instance:GetPropertyChangedSignal(property):Connect(function()
            callback((instance :: any)[property])
        end)

        cleanup(function()
            con:Disconnect()
        end)

        callback((instance :: any)[property])
    end)
end

return changed

end)() end,
    [24] = function()local wax,script,require=ImportGlobals(24)local ImportGlobals return (function(...)local typeof = game and typeof or require "../test/mock".typeof :: never

local graph = require "./graph"
local get_scope = graph.get_scope
local push_cleanup = graph.push_cleanup

local function helper(obj: any)
    return
        if typeof(obj) == "RBXScriptConnection" then function() obj:Disconnect() end
        elseif type(obj) == "thread" then function() task.cancel(obj) end
        elseif typeof(obj) == "Instance" then function() obj:Destroy() end
        elseif obj.destroy then function() obj:destroy() end
        elseif obj.disconnect then function() obj:disconnect() end
        elseif obj.Destroy then function() obj:Destroy() end
        elseif obj.Disconnect then function() obj:Disconnect() end
        else error "cannot cleanup given object"
end

local function cleanup(value: unknown)
    local scope = get_scope()

    if not scope then
        error "cannot cleanup outside a stable or reactive scope"
    end; assert(scope)

    if type(value) == "function" then
        push_cleanup(scope, value :: () -> ())
    else
        push_cleanup(scope, helper(value))
    end
end

type Destroyable = { destroy: (any) -> () } | { Destroy: (any) -> () }
type Disconnectable = { disconnect: (any) -> () } | { Disconnect: (any) -> () }

return cleanup ::
    ( (callback: () -> ()) -> () ) &
    ( (thread: thread) -> () ) &
    ( (instance: Destroyable) -> () ) &
    ( (connection: Disconnectable) -> () ) &
    ( (instance: Instance) -> () ) &
    ( (connection: RBXScriptConnection) -> () )


end)() end,
    [25] = function()local wax,script,require=ImportGlobals(25)local ImportGlobals return (function(...)local graph = require "./graph"
type Node<T> = graph.Node<T>
local create_node = graph.create_node
local get_scope = graph.get_scope
local push_scope = graph.push_scope
local pop_scope = graph.pop_scope
local set_context = graph.set_context

export type Context<T> = (() -> T) & (<U>(T, () -> U) -> U)

local nil_symbol = newproxy()
local count = 0

local function context<T>(...: T): Context<T>
    count += 1
    local id = count

    local has_default = select("#", ...) > 0
    local default_value = ...

    return function<T>(...): any -- todo: fix type error
        local scope: Node<unknown>? | false = get_scope()

        if select("#", ...) == 0 then -- get
            while scope do
                local ctx = scope.context
    
                if not ctx then
                    scope = scope.owner
                    continue
                end

                local value = (ctx :: { unknown })[id]

                if value == nil then
                    scope = scope.owner
                    continue
                end
                
                return (if value ~= nil_symbol then value else nil) :: T
            end

            if has_default ~= nil then
                return default_value
            else
                error("attempt to get context when no context is set and no default context is set", 0)
            end
        else -- set
            if not scope then return error("attempt to set context outside of a vide scope", 0) end

            local value, component = ...
            
            local new_scope = create_node(scope, false, false)
            set_context(new_scope, id, if value == nil then nil_symbol else value)

            push_scope(new_scope)

            local function efn(err: string) return debug.traceback(err, 3) end
            local ok, result = xpcall(component, efn)

            pop_scope()

            if not ok then
                error(`error while running context:\n\n{result}`, 0)
            end

            return result
        end

        return nil :: any
    end
end

return context

end)() end,
    [26] = function()local wax,script,require=ImportGlobals(26)local ImportGlobals return (function(...)local typeof = game and typeof or require "../test/mock".typeof :: never
local Instance = game and Instance or require "../test/mock".Instance :: never

local defaults = require "./defaults"
local apply = require "./apply"
local flags = require "./flags"

local ctor_cache = {} :: { [string]: (AnyProps) -> Instance }
local function lazy_init(_, class: string)
    local function ctor(properties: AnyProps): Instance
        local ok, instance: Instance = pcall(Instance.new, class :: any)
        if not ok then error(`invalid class name { class }`, 0) end

        if flags.defaults then
            local default: { [string]: unknown }? = defaults[class]
            if default then
                for i, v in default do
                    (instance :: any)[i] = v
                end
            end
        end

        return apply(instance, properties)
    end

    ctor_cache[class] = ctor
    return ctor
end
setmetatable(ctor_cache, { __index = lazy_init })

-- todo: remove support for different overloads
local function create(class_or_instance: string|Instance, properties: AnyProps?): ((AnyProps) -> Instance) | Instance
    if type(class_or_instance) ~= "string" and typeof(class_or_instance) ~= "Instance" then
        error("bad argument #1, expected string or instance, got " .. typeof(class_or_instance), 0)
    end

    local ctor = if type(class_or_instance) == "string"
        then ctor_cache[class_or_instance]
        else function(properties)
            local clone = class_or_instance:Clone()
            if not clone then error "attempt to clone a non-archivable instance" end
            return apply(clone, properties)
        end

    return if properties
        then ctor(properties)
        else ctor
end

type Instances = {
    Folder: Folder,
    BillboardGui: BillboardGui,
    CanvasGroup: CanvasGroup,
    Frame: Frame,
    ImageButton: ImageButton,
    ImageLabel: ImageLabel,
    ScreenGui: ScreenGui,
    ScrollingFrame: ScrollingFrame,
    SurfaceGui: SurfaceGui,
    TextBox: TextBox,
    TextButton: TextButton,
    TextLabel: TextLabel,
    UIAspectRatioConstraint: UIAspectRatioConstraint,
    UICorner: UICorner,
    UIGradient: UIGradient,
    UIGridLayout: UIGridLayout,
    UIListLayout: UIListLayout,
    Camera: Camera,
    WorldModel: WorldModel,
}

type function Properties(instance: type?)
    local properties = types.newtable()

    while instance do
        for i, v in instance:properties() do
            local connector = v.read and v.read.tag == "table" and v.read:readproperty(types.singleton("Connect"))
            if connector then
                if not connector then continue end
                local params = connector:parameters().head
                if not params then continue end
                local listener = params[2]
                if not listener then continue end
                properties:setproperty(i, types.optional(listener))
            elseif v.write then
                properties:setproperty(i, types.optional(types.unionof(
                    v.write,
                    types.newfunction({}, { head = { v.write } })
                )))
            end
        end

        instance = instance:readparent()
    end

    properties:setindexer(types.number, types.any)

    return properties
end

type AnyProps = { [any]: any }
type Create = (
    (Instance) -> (AnyProps) -> Instance
) & (
    (string, AnyProps) -> Instance
) & (
    <Name>(Name|keyof<Instances>) -> (Properties<index<Instances, Name>>) -> index<Instances, Name>
)

return (create :: any) :: Create

end)() end,
    [27] = function()local wax,script,require=ImportGlobals(27)local ImportGlobals return (function(...)local Enum = game and Enum or require "../test/mock".Enum :: never
local Color3 = game and Color3 or require "../test/mock".Color3 :: never

return {
    Part = {
        Material = Enum.Material.SmoothPlastic,
        Size = vector.create(1, 1, 1),
        Anchored = true
    },

    BillboardGui = {
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    },

    CanvasGroup = nil,

    Frame = {
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0
    },

    ImageButton = {
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
        AutoButtonColor = false
    },

    ImageLabel = {
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
    },

    ScreenGui = {
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    },

    ScrollingFrame = {
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
        ScrollBarImageColor3 = Color3.new(0, 0, 0)
    },
    
    SurfaceGui = {
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,

        PixelsPerStud = 50,
        SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    },
    
    TextBox = {
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        Font = Enum.Font.SourceSans,
        Text = "",
        TextColor3 = Color3.new(0, 0, 0)
    },

    TextButton = {
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Font = Enum.Font.SourceSans,
        Text = "",
        TextColor3 = Color3.new(0, 0, 0)
    },
    
    TextLabel = {
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
        Font = Enum.Font.SourceSans,
        Text = "",
        TextColor3 = Color3.new(0, 0, 0)
    },
    
    UIListLayout = {
        SortOrder = Enum.SortOrder.LayoutOrder
    },
   
    UIGridLayout = {
        SortOrder = Enum.SortOrder.LayoutOrder
    },

    UITableLayout = {
        SortOrder = Enum.SortOrder.LayoutOrder
    },

    UIPageLayout = {
        SortOrder = Enum.SortOrder.LayoutOrder
    },
    
    VideoFrame = {
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0
    },
    
    ViewportFrame = {
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0
    }
}

end)() end,
    [28] = function()local wax,script,require=ImportGlobals(28)local ImportGlobals return (function(...)local graph = require "./graph"
local create_node = graph.create_node
local push_scope_as_child_of = graph.push_scope_as_child_of
local assert_stable_scope = graph.assert_stable_scope
local evaluate_node = graph.evaluate_node

local function derive<T>(source: () -> T): () -> T
    local node = create_node(assert_stable_scope(), source, false :: any)

    evaluate_node(node)

    return function()
        push_scope_as_child_of(node)
        return node.cache
    end
end

return derive

end)() end,
    [29] = function()local wax,script,require=ImportGlobals(29)local ImportGlobals return (function(...)local graph = require "./graph"
local create_node = graph.create_node
local assert_stable_scope = graph.assert_stable_scope
local evaluate_node = graph.evaluate_node

local function effect<T>(callback: (T) -> T, initial_value: T)
    local node = create_node(assert_stable_scope(), callback, initial_value)

    evaluate_node(node)
end

return effect :: (<T>(callback: (T) -> T, initial_value: T) -> ()) & ((callback: () -> ()) -> ())

end)() end,
    [30] = function()local wax,script,require=ImportGlobals(30)local ImportGlobals return (function(...)local function inline_test(): string
    return debug.info(1, "n")
end

local is_O2 = inline_test() ~= "inline_test"

return {
    strict = not is_O2,
    defaults = true,
    defer_nested_properties = true,
    batch = false,
}

end)() end,
    [31] = function()local wax,script,require=ImportGlobals(31)local ImportGlobals return (function(...)local flags = require "./flags"

export type SourceNode<T> = {
    cache: T,
    [number]: Node<T>
}

export type Node<T> =  {
    cache: T,
    effect:  ((T) -> T) | false,
    cleanups: { () -> () } | false,

    context: { [number]: unknown } | false,

    owned: { Node<T> } | false,
    owner: Node<T> | false,

    parents: { SourceNode<T> },
    [number]: Node<T> -- children
}

local scopes = { n = 0 } :: { [number]: Node<any>, n: number } -- scopes stack

local function efn(err: string)
    local trace = debug.traceback(err, 2)

    if string.find(err, "^effect error stacktrace") then -- if effect error is nested
        trace = string.gsub("    " .. trace, "\n", function() -- indent entire error
            return "\n    "
        end)
    end

    trace ..= "\nsource update stacktrace:"
return trace
end

local function ycall<T, U>(fn: (T) -> U, arg: T): (boolean, string|U)

    local thread = coroutine.create(xpcall)
    --local function efn(err: string) return debug.traceback(err, 3) end
    local resume_ok, run_ok, result = coroutine.resume(thread, fn, efn, arg)

    assert(resume_ok)
        
    if coroutine.status(thread) ~= "dead" then
        return false, debug.traceback(thread, "attempt to yield in reactive scope")
    end

    return run_ok, result
end

local function get_scope(): Node<unknown>?
    return scopes[scopes.n]
end

local function assert_stable_scope(): Node<unknown>
    local scope = get_scope()

    if not scope then
        local caller_name = debug.info(2, "n")
        return error(`cannot use {caller_name}() outside a stable or reactive scope`, 0)
    elseif scope.effect then
        error("cannot create a new reactive scope inside another reactive scope", 0)
    end

    return scope
end

local function push_child<T>(parent: SourceNode<any>, child: Node<any>)
    table.insert(parent, child)
    table.insert(child.parents, parent)
end

local function push_scope<T>(node: Node<T>)
    local n = scopes.n + 1
    scopes.n = n
    scopes[n] = node
end

local function pop_scope()
    local n = scopes.n
    scopes.n = n - 1
    scopes[n] = nil
end

local function push_cleanup<T>(node: Node<T>, cleanup: () -> ())
    if node.cleanups then
        table.insert(node.cleanups, cleanup)
    else
        node.cleanups = { cleanup }
    end
end

local function flush_cleanups<T>(node: Node<T>)
    if node.cleanups then
        for _, fn in node.cleanups do
            local ok, err: string? = xpcall(fn, debug.traceback)
            if not ok then error(`cleanup error: {err}`, 0) end
        end

        table.clear(node.cleanups)
    end
end

local function find_and_swap_pop<T>(t: { T }, v: T)
    local i = table.find(t, v) :: number
    local n = #t
    t[i] = t[n]
    t[n] = nil
end

local function unparent<T>(node: Node<T>)
    local parents = node.parents

    for i, parent in parents do
        find_and_swap_pop(parent, node)
        parents[i] = nil
    end
end

local function destroy<T>(node: Node<T>)
    if flags.strict and table.find(scopes, node) then
        error("attempt to destroy an active scope", 0)
    end

    flush_cleanups(node)
    unparent(node)
    
    if node.owner then
        find_and_swap_pop(node.owner.owned :: { Node<T> }, node)
        node.owner = false
    end

    if node.owned then
        local owned = node.owned
        while owned[1] do destroy(owned[1]) end
    end
end

local function destroy_owned<T>(node: Node<T>)
    if node.owned then
        local owned = node.owned
        while owned[1] do destroy(owned[1]) end
    end
end

local update_queue = { n = 0 } :: { n: number, [number]: Node<any> }

local function evaluate_node<T>(node: Node<T>)
    if flags.strict then
        if table.find(scopes, node) then
            error("a scope, that should rerun due to the update of a source, is already active", 0)
        end

        local initial_value = node.cache

        for i = 1, 2 do
            local cur_value = node.cache

            flush_cleanups(node)
            destroy_owned(node)
    
            push_scope(node)
            local ok, new_value = ycall(node.effect :: (T) -> T, cur_value)
            pop_scope()
            
            if not ok then
                table.clear(update_queue)
                update_queue.n = 0
                error(`effect error stacktrace\n{new_value :: string}`, 0)
            end

            node.cache = new_value :: T
        end

        return initial_value ~= node.cache
    else
        local cur_value = node.cache

        flush_cleanups(node)
        destroy_owned(node)

        push_scope(node)
        local ok, new_value = pcall(node.effect :: (T) -> T, node.cache)
        pop_scope()

        if not ok then
            table.clear(update_queue)
            update_queue.n = 0
            error(`effect error:\n{new_value}\n`, 0)
        end
    
        node.cache = new_value
        return cur_value ~= new_value
    end
end

local function queue_children_for_update<T>(node: SourceNode<T>)
    local i = update_queue.n
    while node[1] do
        i += 1
        update_queue[i] = node[1]
        unparent(node[1])
    end
    update_queue.n = i
end

local function get_update_queue_length()
    return update_queue.n
end

local function flush_update_queue(from: number)
    local i = from + 1
    while i <= update_queue.n do
        local node = update_queue[i]
        --assert(node.effect)

        if node.owner and evaluate_node(node) then
            queue_children_for_update(node)
        end

        update_queue[i] = false :: any
        i += 1
    end
    
    update_queue.n = from
end

local function update_descendants<T>(root: SourceNode<T>)
    local n0 = update_queue.n
    queue_children_for_update(root)

    if flags.batch then return end

    local i = n0 + 1
    while i <= update_queue.n do
        local node = update_queue[i]
        --assert(node.effect)

        -- check if node is still owned in case destroyed after queued
        if node.owner and evaluate_node(node) then
            queue_children_for_update(node)
        end

        update_queue[i] = false :: any -- false instead of nil to avoid sparse
        i += 1
    end

    update_queue.n = n0
end

local function push_scope_as_child_of<T>(node: SourceNode<T>)
    local scope = get_scope()
    if scope and scope.effect then -- do not track nodes with no effect
        push_child(node, scope)
    end
end

local function create_node<T>(owner: false | Node<any>, effect: false | (T) -> T, value: T): Node<T>
    local node: Node<T> = {
        cache = value,
        effect = effect,
        cleanups = false,

        context = false,

        owner = owner,
        owned = false,

        parents = {},
    }

    if owner then
        if owner.owned then
            table.insert(owner.owned, node)
        else
            owner.owned = { node }
        end
    end

    return node
end

local function create_source_node<T>(value: T): SourceNode<T>
    return { cache = value }
end

local function get_children<T>(node: Node<T>): { Node<unknown> }
    return { unpack(node) } :: { Node<any> }
end

local function set_context<T>(node: Node<T>, key: number, value: unknown)
    if node.context then
        node.context[key] = value
    else
        node.context = { [key] = value }
    end
end

return table.freeze {
    push_scope = push_scope,
    pop_scope = pop_scope,
    evaluate_node = evaluate_node,
    get_scope = get_scope,
    assert_stable_scope = assert_stable_scope,
    push_cleanup = push_cleanup,
    destroy = destroy,
    flush_cleanups = flush_cleanups,
    push_scope_as_child_of = push_scope_as_child_of,
    update_descendants = update_descendants,
    push_child = push_child,
    create_node = create_node,
    create_source_node = create_source_node,
    get_children = get_children,
    flush_update_queue = flush_update_queue,
    get_update_queue_length = get_update_queue_length,
    set_context = set_context,
    scopes = scopes,

    q = update_queue
}

end)() end,
    [32] = function()local wax,script,require=ImportGlobals(32)local ImportGlobals return (function(...)local graph = require "./graph"
type Node<T> = graph.Node<T>
local create_node = graph.create_node
local assert_stable_scope = graph.assert_stable_scope
local get_scope = graph.get_scope
local evaluate_node = graph.evaluate_node
local push_cleanup = graph.push_cleanup

local function update_property_effect(p: {
    instance: Instance,
    property: string,
    source: () -> unknown  
})
    (p.instance :: any)[p.property] = p.source()
    return p
end

local function update_parent_effect(p: {
    instance: Instance,
    source: () -> Instance
})
    p.instance.Parent = p.source()
    return p
end

-- todo: investigate if "count" method used in indexes() and values() can improve performance here
local function update_children_effect(p: {
    instance: Instance,
    cur_children_set: { [Instance]: true },
    new_children_set: { [Instance]: true },
    source: () -> Instance | { Instance }
})
    local cur_children_set: { [Instance]: true } = p.cur_children_set -- cache of all children parented before update
    local new_children_set: { [Instance]: true } = p.new_children_set -- cache of all children parented after update

    local new_children = p.source() -- all (and only) children that should be parented after this update
    
    local function process_child(child: Instance | { Instance })
        if type(child) == "userdata" then
            if new_children_set[child] then return end -- stops redundant reparenting

            new_children_set[child] = true -- record child set from this update
            
            if not cur_children_set[child] then
                child.Parent = p.instance -- if child wasn't already parented then parent it
            else 
                cur_children_set[child] = nil -- remove child from cache if it was already in cache
            end  
        elseif type(child) == "table" then
            for _, child in child do
                process_child(child)
            end
        elseif type(child) == "function" then
            local node = create_node(assert(get_scope()), update_children_effect, {
                instance = p.instance,
                cur_children_set = {},
                new_children_set = {},
                source = child   
            })
    
            evaluate_node(node)

            push_cleanup(assert(get_scope()), function()
                for child in node.cache.cur_children_set do
                    child.Parent = nil
                end
            end)
        end
    end

    process_child(new_children)

    for child in cur_children_set do
        child.Parent = nil -- unparent all children that weren't in the new children set
    end

    table.clear(cur_children_set) -- clear cache, preserve capacity
    p.cur_children_set, p.new_children_set = new_children_set, cur_children_set

    return p
end

return {
    property = function(instance, property, source)
        local node = create_node(assert_stable_scope(), update_property_effect, {
            instance = instance,
            property = property,
            source = source
        })

        evaluate_node(node)

        return node
    end,

    parent = function(instance, parent)
        local node = create_node(assert_stable_scope(), update_parent_effect, {
            instance = instance,
            source = parent
        })

        evaluate_node(node)
        
        return node
    end,

    children = function(instance, children)
        local node = create_node(assert_stable_scope(), update_children_effect, {
            instance = instance,
            cur_children_set = {},
            new_children_set = {},
            source = children
        })

        evaluate_node(node)

        push_cleanup(assert_stable_scope(), function()
            for child in node.cache.cur_children_set do
                child.Parent = nil
            end
        end)

        return node
    end
}

end)() end,
    [33] = function()local wax,script,require=ImportGlobals(33)local ImportGlobals return (function(...)local flags = require "./flags"
local branch = require "./branch"
local source = require "./source"
local effect = require "./effect"
local timeout = require "./timeout" ()

type Array<T> = { T }
type Map<K, V> = { [K]: V }
type Source<T> = () -> T

local function indexes<K, V, Obj>(
    input: Source<Map<K, V>>,
    component: (Source<V>, K, Source<boolean>) -> (Obj, ...number)
): Source<Array<Obj>>
    local update_count = 0
    local scopes = {} :: Map<K, {
        destroy: () -> (),
        object: Obj,
        value: V?,
        value_source: (V?) -> V,
        count: number,
        delay: number,
        present: (boolean?) -> boolean,
        timeout: { cancel: boolean }?,
    }>

    local output = source({} :: Array<Obj>)
    local function update_output()
        local objects = table.create(4)

        for _, scope in scopes do
            table.insert(objects, scope.object)
        end

        output(objects)
    end

    effect(function()
        local data = input()

        local count = update_count
        update_count += 1

        local children_need_update = false -- set to true if a scope is created or destroyed

        -- create or update scopes
        for i, v in data do
            local scope = scopes[i]

            if scope == nil then -- create new scope and create component
                local value_source = source(v)
                local present = source(false)

                local delay = nil :: number?
                local destroy, object = branch(function()
                    local object, t = component(value_source, i, present)
                    delay = t
                    return object
                end)

                present(true)
                
                children_need_update = true

                scopes[i] = {
                    destroy = destroy,
                    object = object,
                    value = v,
                    value_source = value_source,
                    count = count,
                    delay = delay or 0,
                    present = present,
                    timeout = nil,
                }
            else -- update scope
                scope.count = count

                if scope.value ~= v then
                    if scope.timeout then -- index is in input table again; cancel destruction
                        scope.timeout.cancel = true
                        scope.timeout = nil
                        scope.present(true)
                    end
                    
                    scope.value = v
                    scope.value_source(v)
                end
            end
        end

        -- destroy scopes
        for i, scope in scopes do
            if scope.count < count then -- if count is not latest then index is no longer in the input table
                scope.present(false)

                if scope.delay == 0 then
                    scope.destroy()
                    scopes[i] = nil
                    children_need_update = true
                else
                    scope.value = nil -- set to nil for the `scope.value ~= v` check
                    if scope.timeout == nil then
                        scope.timeout = timeout(scope.delay, function() -- todo: possible redundant updates
                            scope.destroy()
                            scopes[i] = nil
                            update_output()
                        end)
                    end
                end
            end
        end

        if children_need_update then
            update_output()
        end
    end)

    return output
end

return indexes

end)() end,
    [34] = function()local wax,script,require=ImportGlobals(34)local ImportGlobals return (function(...)local version = { major = 0, minor = 4, patch = 0 }

local root = require "./root"
local branch = require "./branch"
local mount = require "./mount"
local create = require "./create"
local apply = require "./apply"
local source = require "./source"
local effect = require "./effect"
local derive = require "./derive"
local cleanup = require "./cleanup"
local untrack = require "./untrack"
local read = require "./read"
local batch = require "./batch"
local context = require "./context"
local switch = require "./switch"
local show = require "./show"
local indexes = require "./indexes"
local values = require "./values"
local spring, update_springs = require "./spring"()
local action = require "./action"()
local changed = require "./changed"
local timeout, update_timeouts = require "./timeout"()
local flags = require "./flags"

export type Source<T> = source.Source<T>
export type source<T> = Source<T>
export type Context<T> = context.Context<T>
export type context<T> = Context<T>

local function step(dt: number)
    if game then debug.profilebegin("VIDE STEP") end

    if game then debug.profilebegin("VIDE SPRING") end
    update_springs(dt)
    if game then debug.profileend() end

    if game then debug.profilebegin("VIDE SCHEDULER") end
    update_timeouts(dt)
    if game then debug.profileend() end

    if game then debug.profileend() end
end

local stepped = game and game:GetService("RunService").Heartbeat:Connect(function(dt: number)
    task.defer(step, dt)
end)

local vide = {
    version = version,

    -- core
    root = root,
    --branch = branch,
    mount = mount,
    create = create,
    source = source,
    effect = effect,
    derive = derive,
    switch = switch,
    show = show,
    indexes = indexes,
    values = values,

    -- util
    cleanup = cleanup,
    untrack = untrack,
    read = read,
    batch = batch,
    context = context,

    -- animations
    spring = spring,

    -- actions
    action = action,
    changed = changed,

    -- flags
    strict = (nil :: any) :: boolean,
    defaults = (nil :: any) :: boolean,
    defer_nested_properties = (nil :: any) :: boolean,

    -- temporary
    apply = function(instance: Instance)
        return function(props: { [any]: any })
            apply(instance, props)
            return instance
        end
    end,

    -- runtime
    step = function(dt: number)
        if stepped then
            stepped:Disconnect()
            stepped = nil
        end
        step(dt)
    end
}

setmetatable(vide :: any, {
    __index = function(_, index: unknown): ()
        if flags[index] == nil then
            error(`{tostring(index)} is not a valid member of vide`, 0)
        else
            return flags[index]
        end
    end,

    __newindex = function(_, index: unknown, value: unknown)
        if flags[index] == nil then
            error(`{tostring(index)} is not a valid member of vide, 0`)
        else
            flags[index] = value
        end
    end
})

return vide

end)() end,
    [35] = function()local wax,script,require=ImportGlobals(35)local ImportGlobals return (function(...)local root = require "./root"
local apply = require "./apply"

local function mount<T>(component: () -> T, target: Instance?): () -> ()
    return root(function()
        local result = component()
        if target then apply(target, { result }) end
    end)
end

return mount :: (<T>(component: () -> T, target: Instance) -> () -> ()) & ((component: () -> ()) -> () -> ())

end)() end,
    [36] = function()local wax,script,require=ImportGlobals(36)local ImportGlobals return (function(...)local function read<T>(value: T | () -> T): T
    return if type(value) == "function" then value() else value
end

return read

end)() end,
    [37] = function()local wax,script,require=ImportGlobals(37)local ImportGlobals return (function(...)local graph = require "./graph"
type Node<T> = graph.Node<T>
local create_node = graph.create_node
local push_scope = graph.push_scope
local pop_scope = graph.pop_scope
local destroy = graph.destroy

local refs = {}

local function root<T...>(fn: (destroy: () -> ()) -> T...): (() -> (), T...)
    local node = create_node(false, false, false)

    refs[node] = true -- prevent gc of root node

    local destroy = function()
        if not refs[node] then error "root already destroyed" end
        refs[node] = nil
        destroy(node)
    end

    push_scope(node)

    local result = { xpcall(fn, debug.traceback, destroy) }

    pop_scope()

    if not result[1] then
        destroy()
        error(`error while running root():\n\n{result[2]}`, 0)
    end

    return destroy, unpack(result :: any, 2)
end

return root :: <T...>(fn: (destroy: () -> ()) -> T...) -> (() -> (), T...)

end)() end,
    [38] = function()local wax,script,require=ImportGlobals(38)local ImportGlobals return (function(...)local source = require "./source"
local derive = require "./derive"
local effect = require "./effect"
local untrack = require "./untrack"
local switch = require "./switch"

type Array<T> = { T }
type Source<T> = () -> T

local function show<T, Obj>(
    input: Source<T?>,
    component: (Source<T>, Source<boolean>) -> (Obj, ...number),
    fallback: ((Source<boolean>) -> (Obj, ...number))?
): Source<nil | Obj | Array<Obj>>
    local filtered_input = source()

    effect(function()
        local v = input() 
        if v then
            filtered_input(v)
        end
    end)

    local input_is_truthy = derive(function()
        return not not input()
    end)

    return switch(input_is_truthy) {
        [true] = function(present)
            return component(filtered_input, present)
        end,
        [false] = fallback
    }
end

return show

end)() end,
    [39] = function()local wax,script,require=ImportGlobals(39)local ImportGlobals return (function(...)local graph = require "./graph"
type Node<T> = graph.Node<T>
local create_source_node = graph.create_source_node
local push_scope_as_child_of = graph.push_scope_as_child_of
local update_descendants = graph.update_descendants

export type Source<T> = (() -> T) & ((value: T) -> T)

local function source<T>(initial_value: T): Source<T>
    local node = create_source_node(initial_value)

    local function update_source(...): T
        if select("#", ...) == 0 then -- no args were given
            push_scope_as_child_of(node)
            return node.cache
        end

        local v = ... :: T
        if node.cache == v and (type(v) ~= "table" or table.isfrozen(v)) then 
            return v
        end

        node.cache = v
        update_descendants(node)
        return v
    end

    return update_source
end

return source :: (<T>(initial_value: T) -> Source<T>) & (<T>() -> Source<T>)

end)() end,
    [40] = function()local wax,script,require=ImportGlobals(40)local ImportGlobals return (function(...)local graph = require "./graph"
type Node<T> = graph.Node<T>
type SourceNode<T> = graph.SourceNode<T>
local create_node = graph.create_node
local create_source_node = graph.create_source_node
local assert_stable_scope = graph.assert_stable_scope
local evaluate_node = graph.evaluate_node
local update_descendants = graph.update_descendants
local push_scope_as_child_of = graph.push_scope_as_child_of

local UPDATE_RATE = 120
local TOLERANCE_FACTOR = 10_000

type Animatable = number | CFrame | Color3 | UDim | UDim2 | Vector2 | Vector3

--[[
Unsupported datatypes:
- bool
- Vector2int16
- Vector3int16
- EnumItem
]]

type SpringState<T> = {
    k: number, -- spring constant
    c: number, -- damping coeff

    x0_123: vector, x0_456: vector, -- initial position
    x_123: vector, x_456: vector, -- current position
    x1_123: vector, x1_456: vector, -- target position
    v_123: vector, v_456: vector, -- current velocity

    source_value: T -- current value of spring input source
}

type SpringSettings<T> = ({
    position: T?,
    velocity: T?,
    impulse: T?
}) -> ()

type TypeToVec6<T> = (T) -> (vector, vector)
type Vec6ToType<T> = (vector, vector) -> T

local type_to_vec6 = {
    number = function(v)
        return vector.create(v, 0, 0), vector.zero
    end :: TypeToVec6<number>,

    CFrame = function(v)
        return v.Position, vector.create(v:ToEulerAnglesXYZ())
    end :: TypeToVec6<CFrame>,

    Color3 = function(v)
        -- todo: hsv, oklab?
        return vector.create(v.R, v.G, v.B), vector.zero
    end :: TypeToVec6<Color3>,

    UDim = function(v)
        return vector.create(v.Scale, v.Offset, 0), vector.zero
    end :: TypeToVec6<UDim>,
    
    UDim2 = function(v)
        return vector.create(v.X.Scale, v.X.Offset, v.Y.Scale), vector.create(v.Y.Offset, 0, 0)
    end :: TypeToVec6<UDim2>,

    Vector2 = function(v)
        return vector.create(v.X, v.Y, 0), vector.zero
    end :: TypeToVec6<Vector2>,

    Vector3 = function(v)
        return v, vector.zero
    end :: TypeToVec6<Vector3>,

    Rect = function(v)
        return vector.create(v.Min.X, v.Min.Y, v.Max.X), vector.create(v.Max.Y, 0, 0)
    end :: TypeToVec6<Rect>,

    table = function(v)
        return vector.create(v[1] or 0, v[2] or 0, v[3] or 0), vector.create(v[4] or 0, 0, 0)
    end :: TypeToVec6<{ number }>
}

local vec6_to_type = {
    number = function(a, b)
        return a.X
    end :: Vec6ToType<number>,

    CFrame = function(a, b)
        return CFrame.new(a) * CFrame.fromEulerAnglesXYZ(b.X, b.Y, b.Z)
    end :: Vec6ToType<CFrame>,

    Color3 = function(v)
        return Color3.new(math.clamp(v.X, 0, 1), math.clamp(v.Y, 0, 1), math.clamp(v.Z, 0, 1))
    end :: Vec6ToType<Color3>,

    UDim = function(v)
        return UDim.new(v.X, math.round(v.Y))
    end :: Vec6ToType<UDim>,
    
    UDim2 = function(a, b)
        return UDim2.new(a.X, math.round(a.Y), a.Z, math.round(b.X))
    end :: Vec6ToType<UDim2>,

    Vector2 = function(v)
        return Vector2.new(v.X, v.Y)
    end :: Vec6ToType<Vector2>,

    Vector3 = function(v)
        return v
    end :: Vec6ToType<Vector3>,

    Rect = function(a, b)
        return Rect.new(a.X, a.Y, a.Z, b.X)
    end :: Vec6ToType<Rect>,

    table = function(a, b)
        return { a.X, a.Y, a.Z, b.X }
    end :: Vec6ToType<{ number }>
}

local invalid_type = {
    __index = function(_, t: string)
        error(`cannot spring type {t}`, 0)
    end
}

setmetatable(type_to_vec6, invalid_type)
setmetatable(vec6_to_type, invalid_type)

-- maps spring data to its corresponding output node
-- lifetime of spring data is tied to output node
local springs: { [SpringState<unknown>]: SourceNode<unknown> } = {}
setmetatable(springs :: any, { __mode = "v" })

local function spring<T>(source: () -> T, period: number?, damping_ratio: number?): (() -> T, SpringSettings<T>)
    local owner = assert_stable_scope()

    -- https://en.wikipedia.org/wiki/Damping
    local w_n = 2*math.pi / (period or 1)
    local z = damping_ratio or 1
    local k = w_n^2
    local c_c = 2*w_n
    local c = z * c_c

    -- todo: is there a solution other than reducing step size?
    -- todo: this does not catch all solver exploding cases
    if c > UPDATE_RATE*2 then -- solver will explode if this is true
        error("spring damping too high, consider reducing damping or increasing period", 0)
    end

    local data: SpringState<T> = {
        k = k,
        c = c,

        x0_123 = vector.zero,
        x_123 = vector.zero,
        x1_123 = vector.zero,
        v_123 = vector.zero,

        x0_456 = vector.zero,
        x_456 = vector.zero,
        x1_456 = vector.zero,
        v_456 = vector.zero,

        source_value = false :: any,
    }
    
    local output = create_source_node(false :: any)

    local function updater_effect()
        local value = source()
        data.x1_123, data.x1_456 = type_to_vec6[typeof(value)](value)
        data.source_value = value
        springs[data] = output
        return value
    end

    local updater = create_node(owner, updater_effect, false :: any)
    evaluate_node(updater)

    -- set initial position to goal
    data.x_123, data.x_456 = data.x1_123, data.x1_456

    -- set output to goal
    output.cache = data.source_value

    local config = function(p)
        local x = p.position
        local v = p.velocity
        local dv = p.impulse

        if x then
            local x_123, x_456 = type_to_vec6[typeof(x)](x)
            data.x_123, data.x_456 = x_123, x_456
            data.x0_123, data.x0_456 = x_123, x_456
        end

        if v then
            data.v_123, data.v_456 = type_to_vec6[typeof(v)](v)
        end

        if dv then
            local dv_123, dv_456 = type_to_vec6[typeof(dv)](dv)
            data.v_123 += dv_123
            data.v_456 += dv_456
        end

        -- schedule spring
        springs[data] = output
    end :: SpringSettings<T>

    return function(...)
        if select("#", ...) == 0 then -- no args were given
            push_scope_as_child_of(output)
            return output.cache
        end

        -- set current position to value
        local v = ... :: T
        data.x_123, data.x_456 = type_to_vec6[typeof(v)](v)

        -- reset velocity
        data.v_123 = vector.zero
        data.v_456 = vector.zero

        -- schedule spring
        springs[data] = output

        -- set output to value
        output.cache = v

        return v
    end, config
end

-- calculates a float tolerance, based on the magnitude of the float
local function get_min_step(x: number): number
    return x/TOLERANCE_FACTOR
end
local function get_min_vector_step(direction: vector): vector
    return vector.create(
        get_min_step(direction.x),
        get_min_step(direction.y),
        get_min_step(direction.z)
    )
end

local function step_springs(dt: number)
    for s in springs do
        local k = s.k
        local c = s.c
        local x_123, x_456 = s.x_123, s.x_456
        local x1_123, x1_456 = s.x1_123, s.x1_456
        local u_123, u_456 = s.v_123, s.v_456

        -- calculate displacement from target
        local dx_123 = x_123 - x1_123
        local dx_456 = x_456 - x1_456

        -- calculate spring force
        local fs_123 = dx_123*-k
        local fs_456 = dx_456*-k

        -- calculate friction force
        local ff_123 = u_123*-c
        local ff_456 = u_456*-c

        -- calculate acceleration
        local a_123 = (fs_123 + ff_123)
        local a_456 = (fs_456 + ff_456)

        -- step acceleration
        local v_123 = u_123 + a_123*dt
        local v_456 = u_456 + a_456*dt

        -- step velocity
        local y_123 = x_123 + v_123*dt
        local y_456 = x_456 + v_456*dt

        s.x_123, s.x_456 = y_123, y_456
        s.v_123, s.v_456 = v_123, v_456
    end
end

local function update_spring_sources()
    for data, output in springs do
        local x0_123, x0_456 = data.x0_123, data.x0_456
        local x_123, x_456 = data.x_123, data.x_456
        local x1_123, x1_456 = data.x1_123, data.x1_456
        local v_123, v_456 = data.v_123, data.v_456

        local tol_123 = vector.abs(get_min_vector_step(x0_123 - x1_123))
        local tol_456 = vector.abs(get_min_vector_step(x0_456 - x1_456))

        if
            -- position is at goal (within tolerance)
            vector.max(vector.abs(x_123 - x1_123), tol_123) == tol_123
            and vector.max(vector.abs(x_456 - x1_456), tol_456) == tol_456

            -- velocity is at 0 (within tolerance)
            and vector.max(vector.abs(v_123/10), tol_123) == tol_123
            and vector.max(vector.abs(v_456/10), tol_456) == tol_456
        then
            springs[data] = nil
            output.cache = data.source_value
        else
            output.cache = vec6_to_type[typeof(data.source_value)](x_123, x_456)
        end

        update_descendants(output)
    end
end

return function()
    local time_elapsed = 0

    return spring, function(dt: number)
        time_elapsed += dt

        while time_elapsed > 1 / UPDATE_RATE do
            time_elapsed -= 1 / UPDATE_RATE
            step_springs(1 / UPDATE_RATE)
        end

        update_spring_sources()
    end
end

end)() end,
    [41] = function()local wax,script,require=ImportGlobals(41)local ImportGlobals return (function(...)local branch = require "./branch"
local source = require "./source"
local effect = require "./effect"
local timeout = require "./timeout" ()

type Array<T> = { T }
type Map<K, V> = { [K]: V }
type Source<T> = () -> T
type Component<T> = (Source<boolean>) -> (T, ...number)

local function switch_map<K, Obj>(
    input: Source<K>,
    map: Map<K, Component<Obj>>
): Source<nil | Obj | Array<Obj>>
    local scopes = {} :: Map<K, {
        destroy: () -> (),
        object: Obj,
        delay: number,
        present: (boolean?) -> boolean,
        timeout: { cancel: boolean }?
    }>

    local output = source(nil :: nil | Obj | Array<Obj>)
    local function update_output()
        local objects = {}

        for _, scope in scopes do
            table.insert(objects, scope.object)
        end

        output(
            if objects[2] then objects
            elseif objects[1] then objects[1]
            else nil
        )
    end

    effect(function()
        local key: K? = input()

        -- destroy (or queue destroy) all scopes not associated with the input key
        for k, scope in scopes do
            if k == key then continue end

            scope.present(false)

            if scope.delay == 0 then
                scope.destroy()
                scopes[k] = nil
            else
                if scope.timeout == nil then
                    scope.timeout = timeout(scope.delay, function()
                        scope.destroy()
                        scopes[k] = nil
                        update_output()
                    end)
                end
            end
        end

        -- create new scope or abort destruction of existing scope if key exists
        if key ~= nil then
            local scope = scopes[key]

            if scope then
                scope.present(true)

                if scope.timeout then
                    scope.timeout.cancel = true
                    scope.timeout = nil
                end
            else
                local component = map[key]

                if component ~= nil then
                    if type(component) ~= "function" then
                        error("map must map a value to a function", 0)
                    end

                    local present = source(false)

                    local delay = nil :: number?
                    local destroy, object = branch(function()
                        local object, t = component(present)
                        delay = t
                        return object
                    end)

                    present(true)

                    scopes[key] = {
                        destroy = destroy,
                        object = object,
                        delay = delay or 0,
                        present = present,
                        timeout = nil
                    }
                end
            end
        end

        update_output()
    end)

    return output
end

local function switch<K, Obj>(input: Source<K>): (map: Map<K, Component<Obj>>) -> Source<nil | Obj | Array<Obj>>
    return function(map)
        return switch_map(input, map)
    end
end

return switch

end)() end,
    [42] = function()local wax,script,require=ImportGlobals(42)local ImportGlobals return (function(...)local queue = {} :: {
    { t: number, fn: () -> (), cancel: boolean }
}

local function timeout(t: number, fn: () -> ())
    local handle = { t = t, fn = fn, cancel = false }
    table.insert(queue, handle)
    return handle
end

local function update_timeouts(dt: number)
    for i = #queue, 1, -1 do
        local handle = queue[i]
        handle.t -= dt
        
        if handle.cancel or handle.t <= 0 then
            queue[i] = queue[#queue]
            queue[#queue] = nil

            if not handle.cancel then
                handle.fn()
            end
        end
    end
end

return function() return timeout, update_timeouts end

end)() end,
    [43] = function()local wax,script,require=ImportGlobals(43)local ImportGlobals return (function(...)local graph = require "./graph"
type Node<T> = graph.Node<T>
local get_scope = graph.get_scope

local function untrack<T>(source: () -> T): T
    local scope = get_scope()
    
    if scope then
        -- sources are only tracked if the node in scope has an effect
        local effect = scope.effect
        scope.effect = false

        local ok, result = xpcall(source, debug.traceback)

        scope.effect = effect :: () -> ()

        if not ok then error(result, 0) end

        return result :: T
    else
        return source()
    end
end

return untrack :: ( <T>(fn: () -> T) -> T ) & ( (fn: () -> ()) -> () )

end)() end,
    [44] = function()local wax,script,require=ImportGlobals(44)local ImportGlobals return (function(...)local flags = require "./flags"
local branch = require "./branch"
local source = require "./source"
local effect = require "./effect"
local timeout = require "./timeout" ()

type Array<T> = { T }
type Map<K, V> = { [K]: V }
type Source<T> = () -> T

local function values<K, V, Obj>(
    input: Source<Map<K, V>>,
    component: (V, Source<K>, Source<boolean>) -> (Obj, ...number)
): Source<Array<Obj>>
    local update_count = 0
    local scopes = {} :: Map<V, {
        destroy: () -> (),
        object: Obj,
        index: K?,
        index_source: (K?) -> K,
        count: number,
        delay: number,
        present: (boolean?) -> boolean,
        timeout: { cancel: boolean }?,
    }>

    local output = source({} :: Array<Obj>)
    local function update_output()
        local objects = table.create(4)

        for _, scope in scopes do
            table.insert(objects, scope.object)
        end

        output(objects)
    end

    effect(function()
        local data = input()

        local count = update_count
        update_count += 1

        local children_need_update = false -- set to true if a scope is created or destroyed

        if flags.strict then -- check for duplicate values
            local map = {}
            for _, v in data do
                if map[v] then
                    error("table source passed to `values()` contains duplicate values", 0)
                end
                map[v] = true
            end
        end

        -- create or update scopes
        for i, v in data do
            local scope = scopes[v]

            if scope == nil then -- create new scope and create component
                local index_source = source(i)
                local present = source(false)

                local delay = nil :: number?
                local destroy, object = branch(function()
                    local object, t = component(v, index_source, present)
                    delay = t
                    return object
                end)

                present(true)
                
                children_need_update = true

                scopes[v] = {
                    destroy = destroy,
                    object = object,
                    index = i,
                    index_source = index_source,
                    count = count,
                    delay = delay or 0,
                    present = present,
                    timeout = nil,
                }
            else -- update scope
                scope.count = count

                if scope.index ~= i then
                    if scope.timeout then -- value is in input table again; cancel destruction
                        scope.timeout.cancel = true
                        scope.timeout = nil
                        scope.present(true)
                    end
                    
                    scope.index = i
                    scope.index_source(i)
                end
            end
        end

        -- destroy scopes
        for v, scope in scopes do
            if scope.count < count then -- if count is not latest then value is no longer in the input table
                scope.present(false)

                if scope.delay == 0 then
                    scope.destroy()
                    scopes[v] = nil
                    children_need_update = true
                else
                    scope.index = nil -- set to nil for the `scope.index ~= i` check
                    if scope.timeout == nil then
                        scope.timeout = timeout(scope.delay, function() -- todo: possible redundant updates
                            scope.destroy()
                            scopes[v] = nil
                            update_output()
                        end)
                    end
                end
            end
        end

        if children_need_update then
            update_output()
        end
    end)

    return output
end

return values

end)() end,
    [46] = function()local wax,script,require=ImportGlobals(46)local ImportGlobals return (function(...)local PrimitiveControls = require(script.Controls.PrimitiveControls)
local DatatypeControls = require(script.Controls.DatatypeControls)
local AdvancedControls = require(script.Controls.AdvancedControls)
local StoryCreators = require(script.StoryCreators)
local ControlUtils = require(script.Controls.ControlUtils)
local ControlConversion = require(script.Controls.ControlConversion)
local Utils = require(script.Utils)
local Environment = require(script.Environment)
local Types = require(script.Types)
local Version = require(script.Version)

export type Storybook = Types.Storybook
export type FunctionStory = Types.FunctionStory
export type ReactStory = Types.ReactStory
export type RoactStory = Types.RoactStory
export type FusionStory = Types.FusionStory
export type IrisStory = Types.IrisStory
export type VideStory = Types.VideStory
export type GenericStory = Types.GenericStory

export type ReactProps = Types.ReactProps
export type FusionProps = Types.FusionProps
export type IrisProps = Types.IrisProps
export type VideProps = Types.VideProps
export type GenericProps = Types.GenericProps
export type GenericInfo<T> = Types.GenericInfo<T>
export type SubscribeListener = Types.SubscribeListener

local UILabs = {
	_version = Version,
	Boolean = PrimitiveControls.Boolean,
	Number = PrimitiveControls.Number,
	String = PrimitiveControls.String,

	Choose = AdvancedControls.Choose,
	EnumList = AdvancedControls.EnumList,
	Object = AdvancedControls.Object,
	RGBA = AdvancedControls.RGBA,
	Slider = AdvancedControls.Slider,

	Primitive = PrimitiveControls.Primitive,
	Advanced = AdvancedControls,
	Datatype = DatatypeControls,

	ListenControl = Utils.ListenControl,
	CreateControlStates = Utils.CreateControlStates,
	UpdateControlStates = Utils.UpdateControlStates,

	ControlGroup = ControlUtils.ControlGroup,
	Ordered = ControlUtils.Ordered,

	ConvertControl = ControlConversion.ConvertControl,

	CreateGenericStory = StoryCreators.CreateGenericStory,
	CreateReactStory = StoryCreators.CreateReactStory,
	CreateRoactStory = StoryCreators.CreateRoactStory,
	CreateFusionStory = StoryCreators.CreateFusionStory,
	CreateIrisStory = StoryCreators.CreateIrisStory,
	CreateVideStory = StoryCreators.CreateVideStory,

	Environment = Environment,
}

return UILabs

end)() end,
    [49] = function()local wax,script,require=ImportGlobals(49)local ImportGlobals return (function(...)type RecordList<T> = { [string]: T }

local Utils = require(script.Parent.Utils)
local CreateBaseControl = Utils.CreateBaseControl
local Controls = {}

function Controls.Choose<T>(list: { T }, def: number?): Utils.Control<T>
	if #list <= 0 then
		error("UI-Labs: Array given in a Choose control is empty")
	end
	if def and def > #list then
		error(`UI-Labs: Def index ({def}) given for the array is outside of the array size ({#list})`)
	end

	local control = CreateBaseControl("Choose", list[def or 1])
	control.List = list
	control.DefIndex = def or 1

	return control
end

function Controls.EnumList<T>(list: RecordList<T>, def: string): Utils.Control<T>
	if list[def] == nil then
		error(`UI-Labs: Key given for the EnumList list ({def}) does not exist in the list`)
	end

	local control = CreateBaseControl("EnumList", list[def])
	control.List = list
	control.DefIndex = def

	return control
end

function Controls.RGBA(def: Color3, transparency: number?): Utils.Control<{ Color: Color3, Transparency: number }>
	return CreateBaseControl("RGBA", {
		Color = def,
		Transparency = transparency or 0,
	})
end

function Controls.Slider(def: number, min: number, max: number, step: number?): Utils.Control<number>
	if max <= min then
		error(`UI-Labs: Max slider value ({max}) must be greater than the Min value ({min})`)
	end
	local control = CreateBaseControl("Slider", def)

	control.Min = min
	control.Max = max
	control.Step = step

	return control
end

type ObjectPredicator = (instance: Instance) -> boolean

function Controls.Object(className: string?, def: Instance?, predicator: ObjectPredicator?): Utils.Control<Instance?>
	local control = CreateBaseControl("Object", def)
	control.ClassName = className or "Instance"
	control.Predicator = predicator

	return control
end

-- [[ TYPES ]] --

return Controls

end)() end,
    [50] = function()local wax,script,require=ImportGlobals(50)local ImportGlobals return (function(...)local Primitive = require(script.Parent.PrimitiveControls).Primitive
local Datatype = require(script.Parent.DatatypeControls)

local ControlConversion = {}

local function ConvertPrimitive(value: any, primitive: string)
	local converter = Primitive[primitive]

	assert(converter, `UI-Labs: Primitive ({primitive}) can't be converted to a control`)
	return converter(value)
end

local function ConvertDatatype(value: any, datatype: string)
	local converter = Datatype[datatype]

	assert(converter, `UI-Labs: Datatype ({datatype}) can't be converted to a control`)
	return converter(value)
end

function ControlConversion.ConvertControl(control: any)
	local controlType = typeof(control)

	if controlType == "table" then
		return control
	end

	if Primitive[controlType] then
		return ConvertPrimitive(control, controlType)
	elseif Datatype[controlType] then
		return ConvertDatatype(control, controlType)
	else
		error(`UI-Labs: Control ({control}) is not a valid control`)
	end
end

return ControlConversion

end)() end,
    [51] = function()local wax,script,require=ImportGlobals(51)local ImportGlobals return (function(...)local ControlConversion = require(script.Parent.ControlConversion)
local ControlUtils = {}

function ControlUtils.ControlGroup(controls: { [string]: any })
	local group = {
		EntryType = "ControlGroup",
		Controls = controls,
	}
	return group
end

function ControlUtils.Ordered<T>(control: T, order: number): T
	local converted = ControlConversion.ConvertControl(control)
	converted.Order = order
	return converted
end

return ControlUtils

end)() end,
    [52] = function()local wax,script,require=ImportGlobals(52)local ImportGlobals return (function(...)local Utils = require(script.Parent.Utils)
local CreateBaseControl = Utils.CreateBaseControl
local Datatypes = {}

function Datatypes.Color3(def: Color3): Utils.Control<Color3>
	local fixedColor = Color3.new(math.clamp(def.R, 0, 1), math.clamp(def.G, 0, 1), math.clamp(def.B, 0, 1))
	return CreateBaseControl("Color3", fixedColor)
end

--[[
--[User Interface]--
function Datatypes.UDim2(def: UDim2)
	return CreateBaseControl("UDim2", def)
end
function Datatypes.UDim(def: UDim)
	return CreateBaseControl("UDim", def)
end

--[Space 3D]--
function Datatypes.CFrame(def: CFrame)
	return CreateBaseControl("CFrame", def)
end

function Datatypes.Vector2(def: Vector2, normalize: boolean?)
	local control = CreateBaseControl("Vector2", def)
	control.Normalize = if normalize == nil then false else normalize

	return control
end
function Datatypes.Vector3(def: Vector3, normalize: boolean?)
	local control = CreateBaseControl("Vector3", def)
	control.Normalize = if normalize == nil then false else normalize

	return CreateBaseControl("Vector3", def)
end ]]

return Datatypes

end)() end,
    [53] = function()local wax,script,require=ImportGlobals(53)local ImportGlobals return (function(...)type Filter = (input: string, oldInput: string) -> string

local Utils = require(script.Parent.Utils)
local CreateBaseControl = Utils.CreateBaseControl
local Controls = {}

function Controls.String(def: string, filters: { Filter }?): Utils.Control<string>
	local control = CreateBaseControl("String", def)
	control.Filters = filters

	return control
end

function Controls.Number(
	def: number,
	min: number?,
	max: number?,
	step: number?,
	dragger: boolean?,
	sens: number?
): Utils.Control<number>
	local control = CreateBaseControl("Number", def)

	control.Min = min
	control.Max = max
	control.Step = step
	control.Dragger = if dragger == nil then true else dragger
	control.Sensibility = sens or (def * 10)

	return control
end

function Controls.Boolean(def: boolean): Utils.Control<boolean>
	return CreateBaseControl("Boolean", def)
end

Controls.Primitive = {
	string = Controls.String,
	number = Controls.Number,
	boolean = Controls.Boolean,
}

return Controls

end)() end,
    [54] = function()local wax,script,require=ImportGlobals(54)local ImportGlobals return (function(...)local Utils = {}

export type Control<T> = {
	ControlValue: T,
}

function Utils.CreateBaseControl(controlType: string, def)
	local control = {
		EntryType = "Control",
		Type = controlType,
		ControlValue = def,
	}
	return control
end

return Utils

end)() end,
    [55] = function()local wax,script,require=ImportGlobals(55)local ImportGlobals return (function(...)local UserInputService = game:GetService("UserInputService")
local Environment = {}

Environment.EnvGlobalInjectionKey = "__hotreload_env_global_injection__" -- the longer the better

function SearchInEnv(key: string, def: any?)
	local env = Environment.GetEnvGlobalInjection()

	return (env and env[key]) or def
end

function Environment.GetEnvGlobalInjection()
	local env = getfenv()

	return env[Environment.EnvGlobalInjectionKey]
end
function Environment.IsStory()
	local env = Environment.GetEnvGlobalInjection()

	return env ~= nil
end
function UserInputFallback(userInput: any?)
	if not userInput then
		return UserInputService
	end
	if userInput == UserInputService then
		return UserInputService
	end

	local clone = table.clone(userInput)
	return setmetatable(clone, {
		__index = function(_, key)
			local value = UserInputService[key]
			if typeof(value) == "function" then
				-- Wrap the function to replace self
				return function(_, ...)
					return value(UserInputService, ...)
				end
			end
			return value
		end,
	})
end

Environment.Unmount = SearchInEnv("Unmount", function() end) :: () -> ()

Environment.Reload = SearchInEnv("Reload", function() end) :: () -> ()
Environment.CreateSnapshot = SearchInEnv("CreateSnapshot", function() end) :: (name: string?) -> ()
Environment.SetStoryHolder = SearchInEnv("SetStoryHolder", function() end) :: (holder: Instance?) -> ()
Environment.GetJanitor = function()
	local janitor = SearchInEnv("StoryJanitor")
	return janitor
end

type InputSignals = {
	InputBegan: RBXScriptSignal,
	InputEnded: RBXScriptSignal,
	InputChanged: RBXScriptSignal,
	MouseMoved: RBXScriptSignal,
	GetMouseLocation: (self: any) -> Vector2,
}

Environment.InputListener = SearchInEnv("InputListener", nil) :: InputSignals
Environment.UserInput = UserInputFallback(SearchInEnv("InputListener", UserInputService)) :: UserInputService

Environment.EnvironmentUID = SearchInEnv("EnvironmentUID", "") :: string
Environment.PreviewUID = SearchInEnv("PreviewUID", "") :: string
Environment.OriginalG = SearchInEnv("OriginalG", _G) :: any
Environment.PluginWidget = SearchInEnv("PluginWidget", nil) :: DockWidgetPluginGui
Environment.Plugin = SearchInEnv("Plugin", plugin) :: Plugin

return Environment

end)() end,
    [57] = function()local wax,script,require=ImportGlobals(57)local ImportGlobals return (function(...)local Creators = {}
local Types = require(script.Parent.Types)

type InputSignals = {
	InputBegan: RBXScriptConnection,
	InputEnded: RBXScriptConnection,
	InputChanged: RBXScriptConnection,
	MouseMoved: RBXScriptConnection,
}

local function CombineTableInfo(table1, table2)
	for key, val in pairs(table2) do
		table1[key] = val
	end
	return table1
end

function Creators.CreateRoactStory(
	info: Types.StoryBase & Types.WithRoact,
	render: Types.ReactStoryKey
): Types.RoactStory
	local returnStory = {
		use = "roact",
		story = render,
	}

	return CombineTableInfo(returnStory, info)
end

function Creators.CreateReactStory(
	info: Types.StoryBase & Types.WithReact,
	render: Types.ReactStoryKey
): Types.ReactStory
	local returnStory = {
		use = "react",
		story = render,
	}

	return CombineTableInfo(returnStory, info)
end

function Creators.CreateFusionStory(
	info: Types.StoryBase & Types.WithFusion,
	render: Types.FusionStoryKey
): Types.FusionStory
	local returnStory = {
		use = "fusion",
		story = render,
	}

	return CombineTableInfo(returnStory, info)
end

function Creators.CreateIrisStory(info: Types.StoryBase & Types.WithIris, render: Types.IrisStoryKey): Types.IrisStory
	local returnStory = {
		use = "iris",
		story = render,
	}

	return CombineTableInfo(returnStory, info)
end

function Creators.CreateVideStory(info: Types.StoryBase & Types.WithVide, render: Types.VideStoryKey): Types.VideStory
	local returnStory = {
		use = "Vide",
		story = render,
	}

	return CombineTableInfo(returnStory, info)
end

function Creators.CreateGenericStory(info: Types.StoryBase, render: Types.GenericRenderKey): Types.GenericStory
	local returnStory = {
		render = render,
	}

	return CombineTableInfo(returnStory, info)
end

return Creators

end)() end,
    [58] = function()local wax,script,require=ImportGlobals(58)local ImportGlobals return (function(...)export type Storybook = {
	name: string?,
	storyRoots: { Instance },
	groupRoots: boolean?,
}
type Cleanup = () -> ()
export type FunctionStory = (target: Frame) -> Cleanup

export type StoryBase = {
	name: string?,
	summary: string?,
	cleanup: Cleanup?,
	controls: StoryControls?,
}

type StoryControls = { [string]: any }

------------------------------- REACT/ROACT ------------------------------

export type ReactProps = {
	controls: { [string]: any },
}
export type WithReact = {
	use: "react"?,
	react: any,
	reactRoblox: any,
}
export type ReactStoryKey = (props: ReactProps) -> any
export type ReactStory = StoryBase & WithReact & {
	story: ReactStoryKey,
}

export type WithRoact = {
	use: "roact"?,
	roact: any,
}
export type RoactStory = StoryBase & WithRoact & {
	story: ReactStoryKey,
}

--------------------------------- FUSION ---------------------------------

export type FusionProps = {
	controls: { [string]: any },
	scope: any,
	target: GuiObject,
}

export type WithFusion = {
	use: "fusion"?,
	fusion: any,
	scoped: { any }?,
}

export type FusionStoryKey = (props: FusionProps) -> any?
export type FusionStory = StoryBase & WithFusion & {
	story: FusionStoryKey,
}

---------------------------------- IRIS ----------------------------------

export type IrisProps = {
	controls: { [string]: any },
	target: GuiObject,
}

export type WithIris = {
	use: "iris"?,
	iris: any,
}

export type IrisStoryKey = (props: IrisProps) -> Cleanup? | nil
export type IrisStory = StoryBase & WithIris & {
	story: IrisStoryKey,
}

---------------------------------- VIDE ----------------------------------

export type VideProps = {
	controls: { [string]: any },
	target: GuiObject,
}

export type WithVide = {
	use: "vide"?,
	vide: any,
}

export type VideStoryKey = (props: VideProps) -> any?
export type VideStory = StoryBase & WithVide & {
	story: VideStoryKey,
}

---------------------------------- GENERIC --------------------------------
export type GenericInfo<T> = { __old: T, __new: T }

export type SubscribeListener = (values: { [string]: any }, info: { [string]: GenericInfo<any> }) -> ()

export type GenericProps = {
	controls: { [string]: any },
	target: GuiObject,
	converted: { [string]: any },
	subscribe: (listener: SubscribeListener) -> Cleanup,
}

export type GenericRenderKey = (props: GenericProps) -> Cleanup

export type GenericStory = StoryBase & {
	render: GenericRenderKey,
}

return nil

end)() end,
    [60] = function()local wax,script,require=ImportGlobals(60)local ImportGlobals return (function(...)local Utils = {}
local Types = require(script.Parent.Types)

function Utils.ListenControl<T>(info: Types.GenericInfo<T>, callback: (newVal: T) -> ())
	local oldValue = info.__old
	local newValue = info.__new

	if oldValue ~= newValue then
		callback(newValue)
	end
end

function Utils.CreateControlStates(
	converted: { [string]: any },
	controls: { [string]: any },
	creator: (control: any) -> any
)
	local states = {}

	for key, control in pairs(converted) do
		local controlValue = controls[key]

		if control.EntryType == "ControlGroup" then -- control is a control group, we need to recurse
			states[key] = Utils.CreateControlStates(control.Controls, controlValue, creator)
			continue
		end
		states[key] = creator(controlValue)
	end

	return states
end

function Utils.UpdateControlStates(
	states: { [string]: any },
	converted: { [string]: any },
	controls: { [string]: any },
	updater: (state: any, value: any) -> ()
)
	for key, control in pairs(converted) do
		local controlValue = controls[key]

		if control.EntryType == "ControlGroup" then -- control is a control group, we need to recurse
			Utils.UpdateControlStates(states[key], control.Controls, controlValue, updater)
			continue
		end
		updater(states[key], controlValue)
	end
end

return Utils

end)() end,
    [61] = function()local wax,script,require=ImportGlobals(61)local ImportGlobals return (function(...)return "2.4.2"
end)() end,
    [62] = function()local wax,script,require=ImportGlobals(62)local ImportGlobals return (function(...)return require(script.Parent._Index["pepeeltoro41_ui-labs@2.4.2"]["ui-labs"])

end)() end,
    [63] = function()local wax,script,require=ImportGlobals(63)local ImportGlobals return (function(...)return require(script.Parent._Index["centau_vide@0.4.0"]["vide"])

end)() end
} -- [RefId] = Closure

-- Holds the actual DOM data
local ObjectTree = {
    {
        1,
        2,
        {
            "MainModule"
        },
        {
            {
                2,
                2,
                {
                    "PixlLib"
                },
                {
                    {
                        8,
                        2,
                        {
                            "Label"
                        }
                    },
                    {
                        3,
                        2,
                        {
                            "Button"
                        }
                    },
                    {
                        5,
                        2,
                        {
                            "Divider"
                        }
                    },
                    {
                        9,
                        2,
                        {
                            "Notification"
                        }
                    },
                    {
                        6,
                        2,
                        {
                            "Dropdown"
                        }
                    },
                    {
                        12,
                        2,
                        {
                            "Tab"
                        }
                    },
                    {
                        13,
                        2,
                        {
                            "Toggle"
                        }
                    },
                    {
                        14,
                        2,
                        {
                            "Window"
                        }
                    },
                    {
                        10,
                        2,
                        {
                            "Paragraph"
                        }
                    },
                    {
                        15,
                        1,
                        {
                            "Packages"
                        },
                        {
                            {
                                16,
                                1,
                                {
                                    "_Index"
                                },
                                {
                                    {
                                        17,
                                        1,
                                        {
                                            "centau_vide@0.4.0"
                                        },
                                        {
                                            {
                                                18,
                                                2,
                                                {
                                                    "vide"
                                                },
                                                {
                                                    {
                                                        33,
                                                        2,
                                                        {
                                                            "indexes"
                                                        }
                                                    },
                                                    {
                                                        38,
                                                        2,
                                                        {
                                                            "show"
                                                        }
                                                    },
                                                    {
                                                        26,
                                                        2,
                                                        {
                                                            "create"
                                                        }
                                                    },
                                                    {
                                                        27,
                                                        2,
                                                        {
                                                            "defaults"
                                                        }
                                                    },
                                                    {
                                                        41,
                                                        2,
                                                        {
                                                            "switch"
                                                        }
                                                    },
                                                    {
                                                        44,
                                                        2,
                                                        {
                                                            "values"
                                                        }
                                                    },
                                                    {
                                                        22,
                                                        2,
                                                        {
                                                            "branch"
                                                        }
                                                    },
                                                    {
                                                        43,
                                                        2,
                                                        {
                                                            "untrack"
                                                        }
                                                    },
                                                    {
                                                        29,
                                                        2,
                                                        {
                                                            "effect"
                                                        }
                                                    },
                                                    {
                                                        32,
                                                        2,
                                                        {
                                                            "implicit_effect"
                                                        }
                                                    },
                                                    {
                                                        40,
                                                        2,
                                                        {
                                                            "spring"
                                                        }
                                                    },
                                                    {
                                                        21,
                                                        2,
                                                        {
                                                            "batch"
                                                        }
                                                    },
                                                    {
                                                        39,
                                                        2,
                                                        {
                                                            "source"
                                                        }
                                                    },
                                                    {
                                                        42,
                                                        2,
                                                        {
                                                            "timeout"
                                                        }
                                                    },
                                                    {
                                                        25,
                                                        2,
                                                        {
                                                            "context"
                                                        }
                                                    },
                                                    {
                                                        37,
                                                        2,
                                                        {
                                                            "root"
                                                        }
                                                    },
                                                    {
                                                        35,
                                                        2,
                                                        {
                                                            "mount"
                                                        }
                                                    },
                                                    {
                                                        28,
                                                        2,
                                                        {
                                                            "derive"
                                                        }
                                                    },
                                                    {
                                                        31,
                                                        2,
                                                        {
                                                            "graph"
                                                        }
                                                    },
                                                    {
                                                        34,
                                                        2,
                                                        {
                                                            "lib"
                                                        }
                                                    },
                                                    {
                                                        20,
                                                        2,
                                                        {
                                                            "apply"
                                                        }
                                                    },
                                                    {
                                                        30,
                                                        2,
                                                        {
                                                            "flags"
                                                        }
                                                    },
                                                    {
                                                        36,
                                                        2,
                                                        {
                                                            "read"
                                                        }
                                                    },
                                                    {
                                                        24,
                                                        2,
                                                        {
                                                            "cleanup"
                                                        }
                                                    },
                                                    {
                                                        19,
                                                        2,
                                                        {
                                                            "action"
                                                        }
                                                    },
                                                    {
                                                        23,
                                                        2,
                                                        {
                                                            "changed"
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    },
                                    {
                                        45,
                                        1,
                                        {
                                            "pepeeltoro41_ui-labs@2.4.2"
                                        },
                                        {
                                            {
                                                46,
                                                2,
                                                {
                                                    "ui-labs"
                                                },
                                                {
                                                    {
                                                        47,
                                                        1,
                                                        {
                                                            "ControlTypings"
                                                        }
                                                    },
                                                    {
                                                        48,
                                                        1,
                                                        {
                                                            "Controls"
                                                        },
                                                        {
                                                            {
                                                                52,
                                                                2,
                                                                {
                                                                    "DatatypeControls"
                                                                }
                                                            },
                                                            {
                                                                49,
                                                                2,
                                                                {
                                                                    "AdvancedControls"
                                                                }
                                                            },
                                                            {
                                                                54,
                                                                2,
                                                                {
                                                                    "Utils"
                                                                }
                                                            },
                                                            {
                                                                51,
                                                                2,
                                                                {
                                                                    "ControlUtils"
                                                                }
                                                            },
                                                            {
                                                                50,
                                                                2,
                                                                {
                                                                    "ControlConversion"
                                                                }
                                                            },
                                                            {
                                                                53,
                                                                2,
                                                                {
                                                                    "PrimitiveControls"
                                                                }
                                                            }
                                                        }
                                                    },
                                                    {
                                                        56,
                                                        1,
                                                        {
                                                            "Libraries"
                                                        }
                                                    },
                                                    {
                                                        60,
                                                        2,
                                                        {
                                                            "Utils"
                                                        }
                                                    },
                                                    {
                                                        59,
                                                        1,
                                                        {
                                                            "Typing"
                                                        }
                                                    },
                                                    {
                                                        57,
                                                        2,
                                                        {
                                                            "StoryCreators"
                                                        }
                                                    },
                                                    {
                                                        55,
                                                        2,
                                                        {
                                                            "Environment"
                                                        }
                                                    },
                                                    {
                                                        58,
                                                        2,
                                                        {
                                                            "Types"
                                                        }
                                                    },
                                                    {
                                                        61,
                                                        2,
                                                        {
                                                            "Version"
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            },
                            {
                                63,
                                2,
                                {
                                    "vide"
                                }
                            },
                            {
                                62,
                                2,
                                {
                                    "uilabs"
                                }
                            }
                        }
                    },
                    {
                        11,
                        2,
                        {
                            "Slider"
                        }
                    },
                    {
                        7,
                        2,
                        {
                            "InputBox"
                        }
                    },
                    {
                        4,
                        2,
                        {
                            "Colors"
                        }
                    }
                }
            }
        }
    }
}

-- Line offsets for debugging (only included when minifyTables is false)
local LineOffsets = {
    8,
    11,
    135,
    211,
    232,
    254,
    701,
    849,
    887,
    1001,
    1065,
    1237,
    1310,
    1425,
    [18] = 2011,
    [19] = 2023,
    [20] = 2050,
    [21] = 2214,
    [22] = 2239,
    [23] = 2281,
    [24] = 2301,
    [25] = 2346,
    [26] = 2422,
    [27] = 2534,
    [28] = 2649,
    [29] = 2669,
    [30] = 2683,
    [31] = 2697,
    [32] = 3020,
    [33] = 3147,
    [34] = 3270,
    [35] = 3392,
    [36] = 3405,
    [37] = 3412,
    [38] = 3449,
    [39] = 3487,
    [40] = 3520,
    [41] = 3850,
    [42] = 3966,
    [43] = 3995,
    [44] = 4022,
    [46] = 4155,
    [49] = 4221,
    [50] = 4289,
    [51] = 4327,
    [52] = 4347,
    [53] = 4386,
    [54] = 4431,
    [55] = 4449,
    [57] = 4523,
    [58] = 4605,
    [60] = 4719,
    [61] = 4771,
    [62] = 4773,
    [63] = 4776
}

-- Misc AOT variable imports
local WaxVersion = "0.4.2"
local EnvName = "WaxRuntime"

-- ++++++++ RUNTIME IMPL BELOW ++++++++ --

-- Localizing certain libraries and built-ins for runtime efficiency
local string, task, setmetatable, error, next, table, unpack, coroutine, script, type, require, pcall, tostring, tonumber, _VERSION =
      string, task, setmetatable, error, next, table, unpack, coroutine, script, type, require, pcall, tostring, tonumber, _VERSION

local table_insert = table.insert
local table_remove = table.remove
local table_freeze = table.freeze or function(t) return t end -- lol

local coroutine_wrap = coroutine.wrap

local string_sub = string.sub
local string_match = string.match
local string_gmatch = string.gmatch

-- The Lune runtime has its own `task` impl, but it must be imported by its builtin
-- module path, "@lune/task"
if _VERSION and string_sub(_VERSION, 1, 4) == "Lune" then
    local RequireSuccess, LuneTaskLib = pcall(require, "@lune/task")
    if RequireSuccess and LuneTaskLib then
        task = LuneTaskLib
    end
end

local task_defer = task and task.defer

-- If we're not running on the Roblox engine, we won't have a `task` global
local Defer = task_defer or function(f, ...)
    coroutine_wrap(f)(...)
end

-- ClassName "IDs"
local ClassNameIdBindings = {
    [1] = "Folder",
    [2] = "ModuleScript",
    [3] = "Script",
    [4] = "LocalScript",
    [5] = "StringValue",
}

local RefBindings = {} -- [RefId] = RealObject

local ScriptClosures = {}
local ScriptClosureRefIds = {} -- [ScriptClosure] = RefId
local StoredModuleValues = {}
local ScriptsToRun = {}

-- wax.shared __index/__newindex
local SharedEnvironment = {}

-- We're creating 'fake' instance refs soley for traversal of the DOM for require() compatibility
-- It's meant to be as lazy as possible
local RefChildren = {} -- [Ref] = {ChildrenRef, ...}

-- Implemented instance methods
local InstanceMethods = {
    GetFullName = { {}, function(self)
        local Path = self.Name
        local ObjectPointer = self.Parent

        while ObjectPointer do
            Path = ObjectPointer.Name .. "." .. Path

            -- Move up the DOM (parent will be nil at the end, and this while loop will stop)
            ObjectPointer = ObjectPointer.Parent
        end

        return Path
    end},

    GetChildren = { {}, function(self)
        local ReturnArray = {}

        for Child in next, RefChildren[self] do
            table_insert(ReturnArray, Child)
        end

        return ReturnArray
    end},

    GetDescendants = { {}, function(self)
        local ReturnArray = {}

        for Child in next, RefChildren[self] do
            table_insert(ReturnArray, Child)

            for _, Descendant in next, Child:GetDescendants() do
                table_insert(ReturnArray, Descendant)
            end
        end

        return ReturnArray
    end},

    FindFirstChild = { {"string", "boolean?"}, function(self, name, recursive)
        local Children = RefChildren[self]

        for Child in next, Children do
            if Child.Name == name then
                return Child
            end
        end

        if recursive then
            for Child in next, Children do
                -- Yeah, Roblox follows this behavior- instead of searching the entire base of a
                -- ref first, the engine uses a direct recursive call
                return Child:FindFirstChild(name, true)
            end
        end
    end},

    FindFirstAncestor = { {"string"}, function(self, name)
        local RefPointer = self.Parent
        while RefPointer do
            if RefPointer.Name == name then
                return RefPointer
            end

            RefPointer = RefPointer.Parent
        end
    end},

    -- Just to implement for traversal usage
    WaitForChild = { {"string", "number?"}, function(self, name)
        return self:FindFirstChild(name)
    end},
}

-- "Proxies" to instance methods, with err checks etc
local InstanceMethodProxies = {}
for MethodName, MethodObject in next, InstanceMethods do
    local Types = MethodObject[1]
    local Method = MethodObject[2]

    local EvaluatedTypeInfo = {}
    for ArgIndex, TypeInfo in next, Types do
        local ExpectedType, IsOptional = string_match(TypeInfo, "^([^%?]+)(%??)")
        EvaluatedTypeInfo[ArgIndex] = {ExpectedType, IsOptional}
    end

    InstanceMethodProxies[MethodName] = function(self, ...)
        if not RefChildren[self] then
            error("Expected ':' not '.' calling member function " .. MethodName, 2)
        end

        local Args = {...}
        for ArgIndex, TypeInfo in next, EvaluatedTypeInfo do
            local RealArg = Args[ArgIndex]
            local RealArgType = type(RealArg)
            local ExpectedType, IsOptional = TypeInfo[1], TypeInfo[2]

            if RealArg == nil and not IsOptional then
                error("Argument " .. RealArg .. " missing or nil", 3)
            end

            if ExpectedType ~= "any" and RealArgType ~= ExpectedType and not (RealArgType == "nil" and IsOptional) then
                error("Argument " .. ArgIndex .. " expects type \"" .. ExpectedType .. "\", got \"" .. RealArgType .. "\"", 2)
            end
        end

        return Method(self, ...)
    end
end

local function CreateRef(className, name, parent)
    -- `name` and `parent` can also be set later by the init script if they're absent

    -- Extras
    local StringValue_Value

    -- Will be set to RefChildren later aswell
    local Children = setmetatable({}, {__mode = "k"})

    -- Err funcs
    local function InvalidMember(member)
        error(member .. " is not a valid (virtual) member of " .. className .. " \"" .. name .. "\"", 3)
    end
    local function ReadOnlyProperty(property)
        error("Unable to assign (virtual) property " .. property .. ". Property is read only", 3)
    end

    local Ref = {}
    local RefMetatable = {}

    RefMetatable.__metatable = false

    RefMetatable.__index = function(_, index)
        if index == "ClassName" then -- First check "properties"
            return className
        elseif index == "Name" then
            return name
        elseif index == "Parent" then
            return parent
        elseif className == "StringValue" and index == "Value" then
            -- Supporting StringValue.Value for Rojo .txt file conv
            return StringValue_Value
        else -- Lastly, check "methods"
            local InstanceMethod = InstanceMethodProxies[index]

            if InstanceMethod then
                return InstanceMethod
            end
        end

        -- Next we'll look thru child refs
        for Child in next, Children do
            if Child.Name == index then
                return Child
            end
        end

        -- At this point, no member was found; this is the same err format as Roblox
        InvalidMember(index)
    end

    RefMetatable.__newindex = function(_, index, value)
        -- __newindex is only for props fyi
        if index == "ClassName" then
            ReadOnlyProperty(index)
        elseif index == "Name" then
            name = value
        elseif index == "Parent" then
            -- We'll just ignore the process if it's trying to set itself
            if value == Ref then
                return
            end

            if parent ~= nil then
                -- Remove this ref from the CURRENT parent
                RefChildren[parent][Ref] = nil
            end

            parent = value

            if value ~= nil then
                -- And NOW we're setting the new parent
                RefChildren[value][Ref] = true
            end
        elseif className == "StringValue" and index == "Value" then
            -- Supporting StringValue.Value for Rojo .txt file conv
            StringValue_Value = value
        else
            -- Same err as __index when no member is found
            InvalidMember(index)
        end
    end

    RefMetatable.__tostring = function()
        return name
    end

    setmetatable(Ref, RefMetatable)

    RefChildren[Ref] = Children

    if parent ~= nil then
        RefChildren[parent][Ref] = true
    end

    return Ref
end

-- Create real ref DOM from object tree
local function CreateRefFromObject(object, parent)
    local RefId = object[1]
    local ClassNameId = object[2]
    local Properties = object[3] -- Optional
    local Children = object[4] -- Optional

    local ClassName = ClassNameIdBindings[ClassNameId]

    local Name = Properties and table_remove(Properties, 1) or ClassName

    local Ref = CreateRef(ClassName, Name, parent) -- 3rd arg may be nil if this is from root
    RefBindings[RefId] = Ref

    if Properties then
        for PropertyName, PropertyValue in next, Properties do
            Ref[PropertyName] = PropertyValue
        end
    end

    if Children then
        for _, ChildObject in next, Children do
            CreateRefFromObject(ChildObject, Ref)
        end
    end

    return Ref
end

local RealObjectRoot = CreateRef("Folder", "[" .. EnvName .. "]")
for _, Object in next, ObjectTree do
    CreateRefFromObject(Object, RealObjectRoot)
end

-- Now we'll set script closure refs and check if they should be ran as a BaseScript
for RefId, Closure in next, ClosureBindings do
    local Ref = RefBindings[RefId]

    ScriptClosures[Ref] = Closure
    ScriptClosureRefIds[Ref] = RefId

    local ClassName = Ref.ClassName
    if ClassName == "LocalScript" or ClassName == "Script" then
        table_insert(ScriptsToRun, Ref)
    end
end

local function LoadScript(scriptRef)
    local ScriptClassName = scriptRef.ClassName

    -- First we'll check for a cached module value (packed into a tbl)
    local StoredModuleValue = StoredModuleValues[scriptRef]
    if StoredModuleValue and ScriptClassName == "ModuleScript" then
        return unpack(StoredModuleValue)
    end

    local Closure = ScriptClosures[scriptRef]

    local function FormatError(originalErrorMessage)
        originalErrorMessage = tostring(originalErrorMessage)

        local VirtualFullName = scriptRef:GetFullName()

        -- Check for vanilla/Roblox format
        local OriginalErrorLine, BaseErrorMessage = string_match(originalErrorMessage, "[^:]+:(%d+): (.+)")

        if not OriginalErrorLine or not LineOffsets then
            return VirtualFullName .. ":*: " .. (BaseErrorMessage or originalErrorMessage)
        end

        OriginalErrorLine = tonumber(OriginalErrorLine)

        local RefId = ScriptClosureRefIds[scriptRef]
        local LineOffset = LineOffsets[RefId]

        local RealErrorLine = OriginalErrorLine - LineOffset + 1
        if RealErrorLine < 0 then
            RealErrorLine = "?"
        end

        return VirtualFullName .. ":" .. RealErrorLine .. ": " .. BaseErrorMessage
    end

    -- If it's a BaseScript, we'll just run it directly!
    if ScriptClassName == "LocalScript" or ScriptClassName == "Script" then
        local RunSuccess, ErrorMessage = pcall(Closure)
        if not RunSuccess then
            error(FormatError(ErrorMessage), 0)
        end
    else
        local PCallReturn = {pcall(Closure)}

        local RunSuccess = table_remove(PCallReturn, 1)
        if not RunSuccess then
            local ErrorMessage = table_remove(PCallReturn, 1)
            error(FormatError(ErrorMessage), 0)
        end

        StoredModuleValues[scriptRef] = PCallReturn
        return unpack(PCallReturn)
    end
end

-- We'll assign the actual func from the top of this output for flattening user globals at runtime
-- Returns (in a tuple order): wax, script, require
function ImportGlobals(refId)
    local ScriptRef = RefBindings[refId]

    local function RealCall(f, ...)
        local PCallReturn = {pcall(f, ...)}

        local CallSuccess = table_remove(PCallReturn, 1)
        if not CallSuccess then
            error(PCallReturn[1], 3)
        end

        return unpack(PCallReturn)
    end

    -- `wax.shared` index
    local WaxShared = table_freeze(setmetatable({}, {
        __index = SharedEnvironment,
        __newindex = function(_, index, value)
            SharedEnvironment[index] = value
        end,
        __len = function()
            return #SharedEnvironment
        end,
        __iter = function()
            return next, SharedEnvironment
        end,
    }))

    local Global_wax = table_freeze({
        -- From AOT variable imports
        version = WaxVersion,
        envname = EnvName,

        shared = WaxShared,

        -- "Real" globals instead of the env set ones
        script = script,
        require = require,
    })

    local Global_script = ScriptRef

    local function Global_require(module, ...)
        local ModuleArgType = type(module)

        local ErrorNonModuleScript = "Attempted to call require with a non-ModuleScript"
        local ErrorSelfRequire = "Attempted to call require with self"

        if ModuleArgType == "table" and RefChildren[module]  then
            if module.ClassName ~= "ModuleScript" then
                error(ErrorNonModuleScript, 2)
            elseif module == ScriptRef then
                error(ErrorSelfRequire, 2)
            end

            return LoadScript(module)
        elseif ModuleArgType == "string" and string_sub(module, 1, 1) ~= "@" then
            -- The control flow on this SUCKS

            if #module == 0 then
                error("Attempted to call require with empty string", 2)
            end

            local CurrentRefPointer = ScriptRef

            if string_sub(module, 1, 1) == "/" then
                CurrentRefPointer = RealObjectRoot
            elseif string_sub(module, 1, 2) == "./" then
                module = string_sub(module, 3)
            end

            local PreviousPathMatch
            for PathMatch in string_gmatch(module, "([^/]*)/?") do
                local RealIndex = PathMatch
                if PathMatch == ".." then
                    RealIndex = "Parent"
                end

                -- Don't advance dir if it's just another "/" either
                if RealIndex ~= "" then
                    local ResultRef = CurrentRefPointer:FindFirstChild(RealIndex)
                    if not ResultRef then
                        local CurrentRefParent = CurrentRefPointer.Parent
                        if CurrentRefParent then
                            ResultRef = CurrentRefParent:FindFirstChild(RealIndex)
                        end
                    end

                    if ResultRef then
                        CurrentRefPointer = ResultRef
                    elseif PathMatch ~= PreviousPathMatch and PathMatch ~= "init" and PathMatch ~= "init.server" and PathMatch ~= "init.client" then
                        error("Virtual script path \"" .. module .. "\" not found", 2)
                    end
                end

                -- For possible checks next cycle
                PreviousPathMatch = PathMatch
            end

            if CurrentRefPointer.ClassName ~= "ModuleScript" then
                error(ErrorNonModuleScript, 2)
            elseif CurrentRefPointer == ScriptRef then
                error(ErrorSelfRequire, 2)
            end

            return LoadScript(CurrentRefPointer)
        end

        return RealCall(require, module, ...)
    end

    -- Now, return flattened globals ready for direct runtime exec
    return Global_wax, Global_script, Global_require
end

for _, ScriptRef in next, ScriptsToRun do
    Defer(LoadScript, ScriptRef)
end

-- AoT adjustment: Load init module (MainModule behavior)
return LoadScript(RealObjectRoot:GetChildren()[1])