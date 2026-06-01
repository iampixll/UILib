local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local vide = require(ReplicatedStorage.Packages.vide)
local Colors = require(ReplicatedStorage.PixlLib.Colors)
local Notification = require(ReplicatedStorage.PixlLib.Notification)
local Tab = require(ReplicatedStorage.PixlLib.Tab)

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
	return create("Frame")({
		Size = UDim2.fromScale(1, 0.1),
		BackgroundColor3 = Colors.surfaceHigh,

		create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

		create("Frame")({ -- covers bottom corners, keeps them square
			Size = UDim2.new(1, 0, 0, 12), -- height = corner radius
			AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.fromScale(0.5, 1),
			BackgroundColor3 = Colors.surfaceHigh,
			BorderSizePixel = 0,
		}),

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

		create("ImageButton")({
			Size = UDim2.fromOffset(35, 35),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.fromScale(0.98, 0.5),
			BackgroundColor3 = Colors.buttonIdle,

			Image = "rbxassetid://71627683074088",
			ImageColor3 = Colors.textPrimary,

			create("UICorner")({ CornerRadius = UDim.new(0, 8) }),

			MouseButton1Click = props.onMinimize,
		}),

		InputBegan = props.onDragBegan,
		InputEnded = props.onDragEnded,
	})
end

local function createFooter(props)
	return create("Frame")({
		Size = UDim2.fromScale(1, 0.1),
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromScale(0, 1),
		BackgroundColor3 = Colors.surfaceHigh,

		create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

		create("Frame")({ -- covers bottom corners, keeps them square
			Size = UDim2.new(1, 0, 0, 12), -- height = corner radius
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0),
			BackgroundColor3 = Colors.surfaceHigh,
			BorderSizePixel = 0,
		}),

		create("Frame")({
			Size = UDim2.fromOffset(35, 35),
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0.02, 0.5),
			BackgroundColor3 = Colors.surface,

			create("UICorner")({ CornerRadius = UDim.new(1, 0) }),

			create("ImageLabel")({
				Size = UDim2.fromScale(1, 1),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = 1,

				Image = "rbxthumb://type=AvatarHeadShot&id=" .. props.userId .. "&w=420&h=420",

				create("UICorner")({ CornerRadius = UDim.new(1, 0) }),
			}),
		}),

		create("TextLabel")({
			Size = UDim2.fromScale(0.5, 0.7),
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0.07, 0.5),
			BackgroundTransparency = 1,

			Text = "Welcome " .. props.playerName .. "!",
			TextSize = 28,
			TextColor3 = Colors.textMuted,
			TextXAlignment = "Left",
			FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
		}),
	})
end

local function createTopButton(props)
	local iconTransparency = spring(function()
		return if props.locked() then 0 else 1 -- 0 = visible, 1 = hidden
	end, 0.3)

	return create("Frame")({
		Size = UDim2.fromScale(0.075, 0.0375),
		AnchorPoint = Vector2.new(0.5, 0),
		Position = props.position,
		BackgroundColor3 = Colors.surfaceHigh,

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
	return create("Frame")({ -- tablist
		Size = UDim2.fromScale(0.225, 0.75),
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.fromScale(0.015, 0.5),
		BackgroundColor3 = Colors.background,

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
						return Colors.surfaceHigh
					elseif hovered() then
						return Colors.surfaceHigh
					else
						return Colors.background
					end
				end
				local bgColor = spring(targetBgColor, 0.3)

				local function targetTextColor()
					if props.activeTab() == tab() then
						return Colors.textPrimary
					else
						return Colors.tabInactive
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
	return create("Frame")({
		Size = UDim2.fromScale(0.73, 0.75),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.fromScale(0.985, 0.5),
		BackgroundColor3 = Colors.background,

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
						return child().node
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

function Window.new(config, notifications)
	config = config or {}

	local self = setmetatable({}, Window)

	local toggleKey = Enum.KeyCode[config.ToggleKey or "K"]

	self.tabs = source({})
	self.activeTab = source(nil)

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

		create("Frame")({ -- mainframe
			Size = UDim2.fromOffset(960, 600),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = displayPos,
			BackgroundColor3 = Colors.surface,

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
			}),
			createFooter({
				userId = userId,
				playerName = playerName,
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
	local tab = Tab.new(name, image)

	local new = table.clone(self.tabs())
	table.insert(new, tab)
	self.tabs(new)

	if self.activeTab() == nil then
		self.activeTab(tab)
	end

	return tab
end

return Window
