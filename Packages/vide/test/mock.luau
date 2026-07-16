-- Stub so a bundler can statically resolve the `require "../test/mock"` fallback in vide's
-- source. That fallback only runs OUTSIDE Roblox (guarded by `game and ... or ...`); inside
-- Roblox `game` is truthy, so this file's contents are never executed.
return {
	typeof = typeof,
	Instance = Instance,
	Enum = Enum,
	Color3 = Color3,
}
