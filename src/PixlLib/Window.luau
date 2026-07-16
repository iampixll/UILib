local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local vide = require("@vide")
local Colors = require("./Colors")
local Icons = require("./Icons")
local Keybind = require("./Keybind")
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
local UI_SCALE = 0.85

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

	local settingsHovered = source(false)
	local settingsColor = spring(function()
		if props.settingsOpen() then
			return Colors.accent -- clearly "on" while the settings view is showing
		end
		return if settingsHovered() then Colors.surfaceHigh2 else Colors.surfaceHover
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
			Position = UDim2.new(0.98, -96, 0.5, 0), -- left of both settings + minimize buttons
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

		create("ImageButton")({ -- settings button
			Size = UDim2.fromOffset(40, 40),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(0.98, -48, 0.5, 0), -- left of the minimize button (40px + 8px gap)
			BackgroundColor3 = settingsColor,
			Image = "", -- glyph lives on the inner label so it can be scaled down

			create("UICorner")({ CornerRadius = UDim.new(0, 8) }),

			create("ImageLabel")({ -- gear glyph, inset so it doesn't fill the whole button
				Size = UDim2.fromScale(0.78, 0.78),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = 1,

				Image = Icons.resolve("settings"),
				ImageColor3 = Colors.textPrimary,
			}),

			MouseButton1Click = props.onSettings,

			MouseEnter = function()
				settingsHovered(true)
			end,
			MouseLeave = function()
				settingsHovered(false)
			end,
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
		Size = UDim2.fromOffset(140, 40),
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
							return tab().icon or Icons.resolve("misc")
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
					return props.activeTab() == tab() and not props.settingsOpen()
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

local function createSettingsPanel(props)
	return create("Frame")({ -- shares the content area, shown instead of the active tab
		Size = UDim2.new(1, -(PAD + TABLIST_W + PAD + PAD), 1, -(ROW_Y + PAD)),
		Position = UDim2.fromOffset(PAD + TABLIST_W + PAD, ROW_Y),
		BackgroundColor3 = Colors.bg,
		Visible = props.settingsOpen,

		create("UICorner")({
			CornerRadius = UDim.new(0, 12),
		}),

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

			create("TextLabel")({ -- panel heading
				Size = UDim2.new(1, 0, 0, 44),
				LayoutOrder = 1,
				BackgroundTransparency = 1,

				Text = "Settings",
				TextColor3 = Colors.textPrimary,
				TextXAlignment = "Left",
				TextSize = 30,
				FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold),
			}),

			create("Frame")({ -- change UI keybind: label left, rebind pill right
				Size = UDim2.new(0.98, 0, 0, 60),
				LayoutOrder = 2,
				BackgroundColor3 = Colors.surface,

				create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

				create("TextLabel")({
					Size = UDim2.new(1, -110, 0.6, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 16, 0.5, 0),
					BackgroundTransparency = 1,

					Text = "Change UI keybind",
					TextColor3 = Colors.textPrimary,
					TextSize = 22,
					TextXAlignment = "Left",
					FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
				}),

				create("Frame")({ -- anchors the pill to the right edge
					Size = UDim2.fromOffset(70, 34),
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -16, 0.5, 0),
					BackgroundTransparency = 1,
					ZIndex = 2,

					props.keyBadge.render(),
				}),
			}),

			(function() -- unload UI: destructive, so it reads red and needs a confirming second click
				local hovered = source(false)
				local armed = source(false) -- first click arms; a second click within the timeout unloads
				local armToken = 0

				local bgColor = spring(function()
					if armed() then
						return Color3.fromRGB(150, 40, 48) -- brighter alarm once armed
					end
					return if hovered() then Color3.fromRGB(122, 48, 56) else Color3.fromRGB(46, 28, 32)
				end, 0.3)

				return create("Frame")({
					Size = UDim2.new(0.98, 0, 0, 48),
					LayoutOrder = 3,
					BackgroundColor3 = bgColor,

					create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

					create("TextLabel")({
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 1,

						Text = function()
							return if armed() then "Click again to confirm" else "Unload UI"
						end,
						TextColor3 = Color3.fromRGB(255, 180, 186),
						TextSize = 22,
						FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold),
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
							if armed() then
								armed(false)
								if props.onUnload then
									props.onUnload()
								end
								return
							end

							-- Arm, then disarm on a timeout unless it was pressed again first.
							armed(true)
							armToken += 1
							local myToken = armToken
							task.delay(3, function()
								if armToken == myToken then
									armed(false)
								end
							end)
						end,
					}),
				})
			end)(),
		}),
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

function Window.new(config, notifications, flags, onChanged, onUnload)
	config = config or {}

	local self = setmetatable({}, Window)

	self.flags = flags
	self.onChanged = onChanged

	self.tabs = source({})
	self.activeTab = source(nil)

	-- Held as a source so the settings panel can rebind the open/close key at runtime.
	local initialKey = config.ToggleKey or "K"
	if not Enum.KeyCode[initialKey] then
		initialKey = "K"
	end
	local toggleKeyName = source(initialKey)

	-- Off-limits for keybind elements: a rebind pressing this key cancels instead of stealing
	-- the shortcut that opens and closes the whole window. The reservation follows a live rebind.
	Keybind.Reserve(toggleKeyName())
	vide.cleanup(function()
		Keybind.Unreserve(toggleKeyName())
	end)

	-- Swaps the reserved key and the live toggle in one step. Fed by the settings keybind pill.
	local function setToggleKey(newName)
		if newName == toggleKeyName() or not Enum.KeyCode[newName] then
			return
		end
		Keybind.Unreserve(toggleKeyName())
		toggleKeyName(newName)
		Keybind.Reserve(newName)
	end

	local scale = source(1)
	local minimized = source(false)
	local settingsOpen = source(false)

	local topButtonPos = source(UDim2.new(0.5, 0, 0, 10))
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
		local raw = math.min(vp.X / 1920, vp.Y / 1080)
		scale(math.min(raw, 1) * UI_SCALE)
	end

	local conn = camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
	vide.cleanup(conn)
	updateScale()

	local keyConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end

		-- A keybind element is waiting for its new key: that press is being typed into the
		-- element, so it must not also fold the window away.
		if Keybind.IsCapturing() then
			return
		end

		if input.KeyCode.Name == toggleKeyName() then
			toggleMinimized()
		end
	end)
	vide.cleanup(keyConn)

	-- Hard on/off for the whole interface, separate from `minimized` (which is the animated
	-- slide-away that leaves the Open pill behind). SetVisibility(false) leaves nothing.
	local enabled = source(true)
	self.enabled = enabled
	self.minimized = minimized
	self.toggleMinimized = toggleMinimized

	-- The rebind pill shown in the settings panel. onFire is a no-op: the window's own global
	-- handler already reacts to the key, so the badge is purely the rebind UI. onChanged fires
	-- once the pill has captured a new key, pushes it into the live toggle, and requests a save
	-- so the choice survives a reload (only actually written when config.Saving is on).
	local toggleKeyBadge
	toggleKeyBadge = Keybind.newBadge({ CurrentKeybind = toggleKeyName() }, function() end, function()
		setToggleKey(toggleKeyBadge.get())
		if self.onChanged then
			self.onChanged()
		end
	end)

	-- Read/write the toggle key from outside (config load). The setter also updates the visible
	-- pill and does NOT request a save, so restoring from disk cannot loop back into a write.
	self.getToggleKey = function()
		return toggleKeyName()
	end
	self.setToggleKey = function(name)
		if not Enum.KeyCode[name] then
			return
		end
		setToggleKey(name) -- live key + reservation
		toggleKeyBadge.set(name) -- pill display (no fire, so no onChanged)
	end

	self.node = create("ScreenGui")({
		Name = "PixlLib",
		IgnoreGuiInset = true,
		Enabled = enabled,

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
				onSettings = function()
					settingsOpen(not settingsOpen())
				end,
				settingsOpen = settingsOpen,
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
					settingsOpen(false) -- picking a tab returns from the settings view
				end,
			}),
			createCurrentTab({
				tabs = self.tabs,
				activeTab = self.activeTab,
				settingsOpen = settingsOpen,
			}),
			createSettingsPanel({
				settingsOpen = settingsOpen,
				keyBadge = toggleKeyBadge,
				onUnload = onUnload,
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

-- icon takes a name from Icons.Named ("farming"), a raw asset id, or an rbxassetid:// string
function Window:CreateTab(name: string, icon: (string | number)?)
	local tab = Tab.new(name, Icons.resolve(icon), self.flags, self.onChanged)

	local new = table.clone(self.tabs())
	table.insert(new, tab)
	self.tabs(new)

	if self.activeTab() == nil then
		self.activeTab(tab)
	end

	return tab
end

-- Stops everything the elements started, across every tab. Called once as the UI is torn
-- down, so a toggled-on feature does not keep its loop running after its switch is gone.
function Window:TeardownAll()
	for _, tab in self.tabs() do
		for _, child in tab.children() do
			if child.Teardown then
				child:Teardown()
			end
		end
	end
end

function Window:SelectTab(tab)
	self.activeTab(tab)
end

function Window:GetTabs()
	return table.clone(self.tabs())
end

-- Shows/hides the entire interface, the Open pill included. This is the one to bind to a
-- panic key; :Minimize() is the softer "get out of the way" the topbar button uses.
function Window:SetVisibility(visible: boolean)
	self.enabled(visible and true or false)
end

function Window:IsVisible(): boolean
	return self.enabled()
end

function Window:Minimize(minimized: boolean?)
	if minimized == nil then
		self.toggleMinimized() -- no argument: flip it
	elseif minimized ~= self.minimized() then
		self.toggleMinimized()
	end
end

function Window:IsMinimized(): boolean
	return self.minimized()
end

return Window
