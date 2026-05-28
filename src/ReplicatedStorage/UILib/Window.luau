local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local vide = require(ReplicatedStorage.Packages.vide)
local Tab = require(ReplicatedStorage.UILib.Tab)

local create = vide.create
local source = vide.source
local indexes = vide.indexes
local effect = vide.effect
local spring = vide.spring

local CENTER = UDim2.new(0.5, 0, 0.5, 0)
local CLOSED_POSITION = UDim2.new(0.5, 0, 1.5, 0) -- center horizontally, off-screen below

local colors = {
	background = Color3.fromRGB(43, 45, 49), -- darkest, content areas
	surface = Color3.fromRGB(30, 31, 34), -- main container
	surfaceHigh = Color3.fromRGB(57, 60, 66), -- chrome (topbar, footer, buttons)
	accent = Color3.fromRGB(88, 101, 242), -- highlights (active tab, etc.)
	buttonIdle = Color3.fromRGB(75, 78, 85), -- minimize button, brighter than topbar
	buttonHover = Color3.fromRGB(95, 98, 106), -- even brighter on hover
	textPrimary = Color3.fromRGB(220, 223, 228),
	textMuted = Color3.fromRGB(150, 153, 160),
	tabInactive = Color3.fromRGB(110, 113, 120), -- dimmer than textMuted, for inactive tab text/icons
}

type WindowProps = {
	Title: string,
}

local function makeDraggable(positionSource)
	local dragging = false
	local dragStart = nil
	local startOffset = nil
	local wasDragged = false

	local conn = UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart

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

local function Window(props: WindowProps)
	local mainFramePosition = source(UDim2.new(0.5, 0, 0.5, 0))
	local topButtonPosition = source(UDim2.new(0.5, 0, 0.01, 0))
	local mainDrag = makeDraggable(mainFramePosition)
	local topDrag = makeDraggable(topButtonPosition)

	local topDisplayPos = spring(topButtonPosition, 0.15)

	local minimizeHovered = source(false)
	local minimizeBg = spring(function()
		return if minimizeHovered() then colors.buttonHover else colors.buttonIdle
	end, 0.3)

	local topHovered = source(false)
	local topBg = spring(function()
		return if topHovered() then colors.surfaceHigh else colors.background
	end, 0.3)

	local minimized = source(false)

	local tabs = source({})
	local activeTab = source(nil)

	local function toggleMinimized()
		local nowMinimized = not minimized()
		if not nowMinimized then
			mainFramePosition(CENTER)
		end
		minimized(nowMinimized)
	end

	local displayPos = spring(function()
		return if minimized() then CLOSED_POSITION else mainFramePosition()
	end, 0.3)

	local function createTab(name, image)
		local tab = Tab.new(name, image)

		local new = table.clone(tabs())
		table.insert(new, tab)
		tabs(new)

		if activeTab() == nil then
			activeTab(tab)
		end

		return tab
	end

	local node = create("ScreenGui")({

		create("Frame")({ --topScreen button
			Size = UDim2.fromScale(0.1, 0.045),
			AnchorPoint = Vector2.new(0.5, 0),
			Position = topDisplayPos,
			BackgroundColor3 = topBg,

			create("UICorner")({
				CornerRadius = UDim.new(0, 12),
			}),

			create("TextLabel")({
				Size = UDim2.fromScale(0.9, 0.8),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				BackgroundTransparency = 1,

				Text = function()
					return if minimized() then "Open" else "Close"
				end,

				TextColor3 = colors.textPrimary,
				TextScaled = true,
				FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold),
			}),

			create("TextButton")({
				Size = UDim2.fromScale(1, 1),
				Transparency = 1,

				Activated = function()
					if topDrag.wasDragged() then
						return
					end
					toggleMinimized()
				end,

				MouseEnter = function()
					topHovered(true)
				end,
				MouseLeave = function()
					topHovered(false)
				end,

				InputBegan = topDrag.began,
				InputEnded = topDrag.ended,
			}),
		}),

		create("Frame")({ --mainframe
			Size = UDim2.fromScale(0.5, 0.55),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = displayPos,
			BackgroundColor3 = colors.surface,

			-- ui elements
			create("UICorner")({
				CornerRadius = UDim.new(0, 15),
			}),

			create("Frame")({ --topbar
				Size = UDim2.fromScale(1, 0.1),
				BackgroundColor3 = colors.surfaceHigh,

				create("UICorner")({
					CornerRadius = UDim.new(0, 12),
				}),

				create("TextLabel")({
					Size = UDim2.fromScale(0.5, 0.7),
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.fromScale(0.02, 0.5),
					BackgroundTransparency = 1,

					Text = props.Title,
					TextScaled = true,
					FontFace = Font.fromName("Montserrat", Enum.FontWeight.ExtraBold),

					TextColor3 = colors.textPrimary,
					TextXAlignment = "Left",
				}),

				create("ImageButton")({ -- minimize button
					Size = UDim2.fromScale(0.045, 0.7),
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.fromScale(0.98, 0.5),
					BackgroundColor3 = minimizeBg,

					Image = "rbxassetid://71627683074088",
					ImageColor3 = colors.textPrimary,

					create("UICorner")({
						CornerRadius = UDim.new(0, 10),
					}),

					Activated = function()
						toggleMinimized()
					end,

					MouseEnter = function()
						minimizeHovered(true)
					end,
					MouseLeave = function()
						minimizeHovered(false)
					end,
				}),

				InputBegan = mainDrag.began,
				InputEnded = mainDrag.ended,
			}),

			create("Frame")({ --footer
				Size = UDim2.fromScale(1, 0.1),
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.fromScale(0, 1),
				BackgroundColor3 = colors.surfaceHigh,

				create("UICorner")({
					CornerRadius = UDim.new(0, 12),
				}),

				create("TextLabel")({
					Size = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.fromScale(0.02, 0.5),
					BackgroundTransparency = 1,

					Text = "Welcome 'PlayerName'", -- TODO
					TextScaled = true,
					FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),

					TextColor3 = colors.textMuted,
					TextXAlignment = "Left",
				}),

				InputBegan = mainDrag.began,
				InputEnded = mainDrag.ended,
			}),

			create("Frame")({ -- tablist
				Size = UDim2.fromScale(0.225, 0.75),
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.fromScale(0.015, 0.5),
				BackgroundColor3 = colors.background,

				create("ScrollingFrame")({
					Size = UDim2.fromScale(0.925, 0.95),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),

					ScrollBarThickness = 4,
					VerticalScrollBarPosition = "Left",

					ScrollBarImageColor3 = colors.textMuted,
					AutomaticCanvasSize = "Y",
					CanvasSize = UDim2.new(),

					Transparency = 1,

					create("UIListLayout")({
						Padding = UDim.new(0, 4),
						HorizontalAlignment = "Center",
						SortOrder = "LayoutOrder",
					}),

					indexes(tabs, function(tab, i)
						local hovered = source(false)

						local function targetBgColor()
							if activeTab() == tab() then
								return colors.surfaceHigh
							elseif hovered() then
								return colors.surfaceHigh
							else
								return colors.background
							end
						end
						local bgColor = spring(targetBgColor, 0.3)

						local function targetTextColor()
							if activeTab() == tab() then
								return colors.textPrimary
							else
								return colors.tabInactive
							end
						end
						local textColor = spring(targetTextColor, 0.3)

						return create("Frame")({
							Size = UDim2.new(0.925, 0, 0, 37.5),
							BackgroundColor3 = bgColor,

							create("UICorner")({
								CornerRadius = UDim.new(0, 8),
							}),

							create("TextButton")({
								Size = UDim2.fromScale(1, 1),

								BackgroundTransparency = 1,
								Text = "",

								Activated = function()
									activeTab(tab())
								end,

								MouseEnter = function()
									hovered(true)
								end,

								MouseLeave = function()
									hovered(false)
								end,
							}),

							create("ImageLabel")({
								Size = UDim2.fromScale(0.7, 0.7),
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
								TextScaled = true,
								FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold),
							}),
						})
					end),
				}),

				create("UICorner")({
					CornerRadius = UDim.new(0, 12),
				}),
			}),

			create("Frame")({ -- current tab
				Size = UDim2.fromScale(0.73, 0.75),
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.fromScale(0.985, 0.5),
				BackgroundColor3 = colors.background,

				create("UICorner")({
					CornerRadius = UDim.new(0, 12),
				}),

				indexes(tabs, function(tab, i)
					create("UIListLayout")({
						Padding = UDim.new(0, 6),
						SortOrder = "LayoutOrder",
					})

					return create("ScrollingFrame")({
						Size = UDim2.fromScale(0.975, 0.95),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						Transparency = 1,

						ScrollBarThickness = 4,
						ScrollBarImageColor3 = colors.textMuted,

						Visible = function()
							return activeTab() == tab()
						end,

						function()
							return tab().children()
						end,
					})
				end),
			}),
		}),
	})

	return node, { createTab = createTab }
end

return Window
