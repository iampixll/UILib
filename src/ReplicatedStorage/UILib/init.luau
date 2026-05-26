local UILib = {}

function UILib:CreateWindow(name)
	local window = {}

	local function CreateTab() end

	window.CreateTab = CreateTab

	return window
end

return UILib
