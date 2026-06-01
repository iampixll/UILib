local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local Colors = require(ReplicatedStorage.PixlLib.Colors)

local create = vide.create
local source = vide.source
local indexes = vide.indexes
local spring = vide.spring
local changed = vide.changed

local Dropdown = {}

function Dropdown.new(name, options, multiple, flag, callback)
	multiple = if multiple == nil then true else multiple

	local dropdown = {}

	dropdown.flag = flag

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
	end

	name = source(name)
	local optionList = source(options or {})
	local open = source(false) -- panel expanded?

	local searchText = source("")

	local searchFocused = source(false)

	local searchBoxColor = spring(function() -- subtle lighten on focus
		return if searchFocused() then Colors.surfaceHigh else Colors.background
	end, 0.3)

	local searchStrokeColor = spring(function() -- accent border while focused
		return if searchFocused() then Colors.accent else Colors.tabInactive
	end, 0.3)

	local hovered = source(false)
	local bgColor = spring(function()
		return if hovered() then Colors.buttonHover else Colors.surfaceHigh
	end, 0.3)

	local chevronRotation = spring(function()
		return if open() then 180 else 0
	end, 0.3)

	local panelHeight = spring(function() -- single height source for the whole expand/collapse
		return if open() then 278 else 0
	end, 0.3)

	local function allSelected()
		local count = 0
		for _ in selected() do
			count += 1
		end
		return count > 0 and count == #optionList() -- count > 0 guards the empty list
	end

	local allHovered = source(false)
	local allBgColor = spring(function() -- mirrors the option rows' hover
		return if allHovered() then Colors.buttonIdle else Colors.surface
	end, 0.3)

	local allBoxColor = spring(function() -- fills with accent when everything is selected
		return if allSelected() then Colors.accent else Colors.background
	end, 0.2)

	local searchHovered = source(false)
	local searchBgColor = spring(function() -- mirrors the option rows' / All button's hover
		return if searchHovered() then Colors.buttonIdle else Colors.surface
	end, 0.3)

	dropdown.node = create("Frame")({
		-- one frame, one animated height: header (60) + panel; clips the scroll frame as it grows/shrinks
		Size = function()
			return UDim2.new(0.98, 0, 0, 60 + panelHeight())
		end,
		BackgroundColor3 = bgColor,
		ClipsDescendants = true,

		create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

		create("Frame")({ -- header row, pinned to the top
			Size = UDim2.new(1, 0, 0, 60),
			Position = UDim2.fromScale(0, 0),
			BackgroundTransparency = 1,

			create("TextLabel")({ -- name on the left
				Size = UDim2.new(0.5, -16, 1, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 16, 0.5, 0),
				BackgroundTransparency = 1,

				Text = name,
				TextColor3 = Colors.textPrimary,
				TextSize = 22,
				TextXAlignment = "Left",
				FontFace = Font.fromName("Montserrat"),
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
				FontFace = Font.fromName("Montserrat"),
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
				return UDim2.new(0.975, 0, 0, panelHeight())
			end,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, 54), -- header bottom (60) minus the 6px pull-up
			BackgroundTransparency = 1,
			ScrollBarThickness = 4,
			ScrollBarImageColor3 = Colors.textMuted,
			AutomaticCanvasSize = "Y",
			CanvasSize = UDim2.new(),

			create("UIListLayout")({ Padding = UDim.new(0, 8), HorizontalAlignment = "Left", SortOrder = "LayoutOrder" }),
			create("UIPadding")({ -- keeps row strokes off the clip edge on all sides
				PaddingTop = UDim.new(0, 6),
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

					create("UIStroke")({ -- matches the All button's outer stroke
						Color = Colors.tabInactive,
						Thickness = 1.5,
					}),

					MouseEnter = function()
						searchHovered(true)
					end,
					MouseLeave = function()
						searchHovered(false)
					end,

					create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

					create("TextLabel")({ -- name, like the InputBox label
						Size = UDim2.new(0.45, -16, 0.6, 0),
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0, 16, 0.5, 0),
						BackgroundTransparency = 1,

						Text = "Browse Options",
						TextColor3 = Colors.textPrimary,
						TextSize = 22,
						TextXAlignment = "Left",
						FontFace = Font.fromName("Montserrat"),
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
							ClearTextOnFocus = true,

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
					create("UIStroke")({
						Color = Colors.tabInactive,
						Thickness = 1.5,
					}),

					create("TextLabel")({ -- "All" label
						Size = UDim2.new(1, -56, 1, 0),
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0, 16, 0.5, 0),
						BackgroundTransparency = 1,

						Text = "All",
						TextColor3 = Colors.textPrimary,
						TextSize = 22,
						TextXAlignment = "Left",
						FontFace = Font.fromName("Montserrat"),
					}),

					create("Frame")({ -- checkbox
						Size = UDim2.fromOffset(24, 24),
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -16, 0.5, 0),
						BackgroundColor3 = allBoxColor,

						create("UICorner")({ CornerRadius = UDim.new(0, 8) }),
						create("UIStroke")({ Color = Colors.tabInactive, Thickness = 1.5 }),
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
				local bgColor = spring(function()
					return if hovered() then Colors.buttonIdle else Colors.surface
				end, 0.3)

				local boxColor = spring(function() -- fills with accent when checked
					return if selected()[option()] then Colors.accent else Colors.background
				end, 0.2)

				local markColor = spring(function()
					return if selected()[option()] then Colors.accent else Colors.textMuted
				end, 0.2)

				return create("Frame")({
					Size = UDim2.new(0.98, 0, 0, 60),
					LayoutOrder = i + 1,
					BackgroundColor3 = bgColor,

					create("UICorner")({ CornerRadius = UDim.new(0, 12) }),
					create("UIStroke")({
						Color = Colors.tabInactive,
						Thickness = 1.5,
					}),

					create("TextLabel")({ -- option name, leaves room for the box on the right
						Size = UDim2.new(1, -80, 1, 0),
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0, 16, 0.5, 0),
						BackgroundTransparency = 1,

						Text = option,
						TextColor3 = Colors.textPrimary,
						TextSize = 22,
						TextXAlignment = "Left",
						FontFace = Font.fromName("Montserrat"),
					}),

					create("Frame")({ -- checkbox
						Size = UDim2.fromOffset(26, 26),
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -16, 0.5, 0),
						Visible = multiple,
						BackgroundColor3 = boxColor,

						create("UICorner")({ CornerRadius = UDim.new(0, 8) }),
						create("UIStroke")({ Color = Colors.tabInactive, Thickness = 1.5 }),
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

			MouseEnter = function()
				hovered(true)
			end,
			MouseLeave = function()
				hovered(false)
			end,
		}),
	})

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
