local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local vide = require(ReplicatedStorage.Packages.vide)
local Tab = require(ReplicatedStorage.UILib.Tab)

local create = vide.create
local source = vide.source
local indexes = vide.indexes
local effect = vide.effect

local colors = {
	background = Color3.fromRGB(43, 45, 49), -- darkest, content areas
	surface = Color3.fromRGB(30, 31, 34), -- main container
	surfaceHigh = Color3.fromRGB(57, 60, 66), -- chrome (topbar, footer, buttons)
	accent = Color3.fromRGB(88, 101, 242), -- highlights (active tab, etc.)
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

	local minimized = source(false)

	local tabs = source({})
	local activeTab = source(nil)

	local function toggleMinimized()
		minimized(not minimized())
	end

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

		create("Frame")({ --topScreen frame
			Size = UDim2.fromScale(0.1, 0.045),
			AnchorPoint = Vector2.new(0.5, 0),
			Position = topButtonPosition,
			BackgroundColor3 = colors.background,

			create("UICorner")({
				CornerRadius = UDim.new(0, 15),
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

				InputBegan = topDrag.began,
				InputEnded = topDrag.ended,
			}),
		}),

		create("Frame")({ --mainframe
			Size = UDim2.fromScale(0.5, 0.55),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = mainFramePosition,
			BackgroundColor3 = colors.surface,

			-- minimize
			Visible = function()
				return not minimized()
			end,

			-- ui elements
			create("UICorner")({
				CornerRadius = UDim.new(0, 8),
			}),

			create("Frame")({ --topbar
				Size = UDim2.fromScale(1, 0.1),
				BackgroundColor3 = colors.surfaceHigh,

				create("UICorner")({
					CornerRadius = UDim.new(0, 8),
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

				create("TextButton")({
					Size = UDim2.fromScale(0.045, 0.7),
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.fromScale(0.98, 0.5),
					BackgroundColor3 = colors.background,

					Text = "—",
					TextScaled = true,
					FontFace = Font.fromName("SourceSansPro", Enum.FontWeight.Bold),
					TextColor3 = colors.textPrimary,

					create("UICorner")({
						CornerRadius = UDim.new(0, 8),
					}),

					Activated = function()
						toggleMinimized()
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
					CornerRadius = UDim.new(0, 8),
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
						return create("Frame")({
							Size = UDim2.new(0.925, 0, 0, 37.5),

							BackgroundColor3 = function()
								return if activeTab() == tab() then colors.surfaceHigh else colors.background
							end,

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

								ImageColor3 = function()
									return if activeTab() == tab() then colors.textPrimary else colors.tabInactive
								end,
							}),

							create("TextLabel")({
								Size = UDim2.new(1, -48, 0.6, 0),
								AnchorPoint = Vector2.new(1, 0.5),
								Position = UDim2.new(1, -8, 0.5, 0),
								BackgroundTransparency = 1,

								Text = function()
									return tab().name
								end,

								TextColor3 = function()
									return if activeTab() == tab() then colors.textPrimary else colors.tabInactive
								end,

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
