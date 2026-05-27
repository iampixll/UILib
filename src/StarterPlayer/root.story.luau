local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local uilabs = require(ReplicatedStorage.Packages.uilabs)
local vide = require(ReplicatedStorage.Packages.vide)

local create = vide.create
local source = vide.source
local effect = vide.effect

local primaryColor = Color3.fromRGB(43, 45, 49)
local secondaryColor = Color3.fromRGB(60, 63, 68)
local textColor = Color3.fromRGB(220, 223, 228)

local toggle = true

if toggle then
	return uilabs.CreateVideStory({
		vide = vide,
		controls = {},
	}, function(props)
		local position = source(UDim2.new(0.5, 0, 0.5, 0))

		local dragging = false
		local dragStart = nil
		local startOffset = nil

		local conn = UserInputService.InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				local delta = input.Position - dragStart

				local newX = startOffset.X + delta.X
				local newY = startOffset.Y + delta.Y

				local newPosition = UDim2.new(0.5, newX, 0.5, newY)

				position(newPosition)
			end
		end)
		vide.cleanup(conn)

		return create("ScreenGui")({
			create("Frame")({
				Size = UDim2.fromScale(0.4, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = position,
				BackgroundColor3 = primaryColor,

				create("UICorner")({
					CornerRadius = UDim.new(0, 8),
				}),

				create("Frame")({
					Size = UDim2.fromScale(1, 0.1),
					BackgroundColor3 = secondaryColor,

					create("UICorner")({
						CornerRadius = UDim.new(0, 8),
					}),

					create("TextLabel")({
						Size = UDim2.fromScale(0.3, 0.8),
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.fromScale(0.02, 0.5),
						BackgroundTransparency = 1,

						Text = props.Title or "UILib",
						TextScaled = true,
						FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold),

						TextColor3 = textColor,
						TextXAlignment = "Left",
					}),

					InputBegan = function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							dragging = true

							dragStart = input.Position
							startOffset = Vector2.new(position().X.Offset, position().Y.Offset)
						end
					end,

					InputEnded = function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							dragging = false
						end
					end,
				}),
			}),
		})
	end)
end
