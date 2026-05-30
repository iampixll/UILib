local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local Colors = require(ReplicatedStorage.UILib.Colors)

local create = vide.create
local source = vide.source
local indexes = vide.indexes
local spring = vide.spring

local Dropdown = {}

function Dropdown.new(name, options)
	local dropdown = {}

	name = source(name)
	local optionList = source(options or {})
	local open = source(false) -- panel expanded?

	dropdown.node = create("Frame")({
		Size = UDim2.new(0.98, 0, 0, 0),
		BackgroundColor3 = Colors.surfaceHigh,
		AutomaticSize = "Y",

		create("UICorner")({ CornerRadius = UDim.new(0, 12) }),
		create("UIListLayout")({ SortOrder = "LayoutOrder" }),

		create("Frame")({ -- header row
			Size = UDim2.new(1, 0, 0, 60),
			LayoutOrder = 1,
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

			create("TextLabel")({ -- summary on the right (later derived from selection)
				Size = UDim2.new(0.4, -48, 1, 0),
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -55, 0.5, 0),
				BackgroundTransparency = 1,

				Text = "Select options",
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
				Rotation = function()
					return if open() then 180 else 0
				end,
			}),

			create("TextButton")({ -- click overlay toggles open
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Text = "",

				Activated = function()
					open(not open())
				end,
			}),
		}),

		create("Frame")({ -- option panel container
			Size = function()
				return if open() then UDim2.new(1, 0, 0, 200) else UDim2.new(1, 0, 0, 0)
			end,
			LayoutOrder = 2,
			BackgroundColor3 = Colors.surfaceHigh,
			ClipsDescendants = true, -- hide rows while collapsing

			create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

			create("ScrollingFrame")({
				Size = UDim2.fromScale(0.975, 0.95),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = 1,
				ScrollBarThickness = 4,
				ScrollBarImageColor3 = Colors.textMuted,
				AutomaticCanvasSize = "Y",
				CanvasSize = UDim2.new(),

				create("UIListLayout")({ Padding = UDim.new(0, 8), HorizontalAlignment = "Left", SortOrder = "LayoutOrder" }),

				indexes(function()
					return if open() then optionList() else {}
				end, function(option, i)
					local checked = source(false) -- visual for now; real selection moves up next step

					local hovered = source(false)
					local bgColor = spring(function()
						return if hovered() then Colors.buttonHover else Colors.surface
					end, 0.3)

					local boxColor = spring(function() -- fills with accent when checked
						return if checked() then Colors.accent else Colors.background
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
							FontFace = Font.fromName("Montserrat"),
						}),

						create("Frame")({ -- checkbox
							Size = UDim2.fromOffset(28, 28),
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(1, -16, 0.5, 0),
							BackgroundColor3 = boxColor,

							create("UICorner")({ CornerRadius = UDim.new(0, 8) }),
							create("UIStroke")({ Color = Colors.tabInactive, Thickness = 1.5 }),
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
								checked(not checked())
							end,
						}),
					})
				end),
			}),
		}),
	})

	return dropdown
end

return Dropdown
