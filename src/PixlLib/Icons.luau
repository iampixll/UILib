-- Icons by name, so callers never have to paste an asset id.
--
-- Rayfield solves this by downloading Lucide's ~200 KB sprite atlas at runtime and slicing it
-- with ImageRectOffset/ImageRectSize. We keep the curated set below instead: they are whole
-- assets, need no slicing, and cost nothing to ship. Anything not in the list can still be
-- passed straight through as an asset id or an rbxassetid:// string, so nothing is locked
-- away behind the table.
local Icons = {}

Icons.Named = {
	-- topbar
	minimize = 71627683074088,
	close = 91413233063028,
	logo = 120561115194230,

	-- tabs
	settings = 87867412432006,
	egg = 15637367451,
	webhook = 122219359034661,
	automatic = 15637369009,
	minigames = 15637376993,
	optimization = 94231924171549,
	bell = 15642579187,
	daycare = 106673690772800,
	mailbox = 15637375511,
	house = 15637376279,
	misc = 15637356511,
	farm = 15637359494,
	farming = 84837573349427,
	player = 15637355840,
	window = 16259403210,
	quest = 15637379637,
	fishing = 91895975011561,
	shop = 15637380284,

	-- misc
	lock = 126141499544212,
	fingerprint = 16089599792,
	chevron = 16093555964,
}

-- Turns whatever a caller passed into an Image string.
--   "farming"                -> a name from the table above
--   15637359494              -> a raw asset id
--   "rbxassetid://123"       -> passed through untouched (also rbxthumb://, rbxasset://)
--   nil / unknown name       -> nil, so the caller can decide on its own fallback
function Icons.resolve(icon: (string | number)?): string?
	if icon == nil then
		return nil
	end

	if type(icon) == "number" then
		return "rbxassetid://" .. icon
	end

	if type(icon) == "string" then
		if string.match(icon, "^rbx%a+://") then
			return icon
		end

		local id = Icons.Named[string.lower(icon)]
		if id then
			return "rbxassetid://" .. id
		end

		warn(`[PixlLib] unknown icon "{icon}" - pass an asset id, or add it to Icons.Named`)
	end

	return nil
end

return Icons
