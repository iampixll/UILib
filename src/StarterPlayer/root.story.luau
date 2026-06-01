local ReplicatedStorage = game:GetService("ReplicatedStorage")

local uilabs = require(ReplicatedStorage.Packages.uilabs)
local vide = require(ReplicatedStorage.Packages.vide)
local Window = require(ReplicatedStorage.UILib.Window)

local toggle = true

if toggle then
	return uilabs.CreateVideStory({
		vide = vide,
		controls = {},
	}, function(props)
		local window = Window.new({ Title = "PixlLib" })

		local webhookTab = window:CreateTab("Webhook", 122219359034661)

		webhookTab:CreateParagraph({
			Title = "New Pets Tracker",
			Content = "Sends a webhook notification whenever you hatch a new pet.\n\n- Paste your Discord webhook URL in the input.\n- Select which pet types you want to track.\n- Enable the toggle to activate.",
		})

		local input = webhookTab:CreateInput({
			Name = "Put your Webhook URL",
			InputType = "text",
			CurrentValue = "",
			Placeholder = "https://discord.com/api/webhooks...",
			Flag = "Input1",
			Callback = function(value) end,
		})

		local dropdown = webhookTab:CreateDropdown({
			Name = "Select Pet Types",
			Options = { "Epic", "Legendary", "Mythical", "Secret" },
			MultipleOptions = true,
			Flag = "Dropdown1",
			Callback = function(option)
				print("callback: " .. table.concat(option, ", "))
			end,
		})

		task.delay(2, function()
			dropdown:Set({ "Legendary", "Mythical" })
		end)

		webhookTab:CreateToggle({
			Name = "New Pets Tracker",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(value)
				print("TOGGLE: ", dropdown:Get())
			end,
		})

		return window.node
	end)
end
