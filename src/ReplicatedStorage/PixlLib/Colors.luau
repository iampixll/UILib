return {
	-- surfaces (dark -> light)
	bg = Color3.fromRGB(14, 17, 22), -- window + panel base
	surface = Color3.fromRGB(24, 28, 36), -- rows, controls
	surfaceHover = Color3.fromRGB(32, 37, 47),
	surfaceActive = Color3.fromRGB(38, 44, 56), -- active tab
	stroke = Color3.fromRGB(42, 48, 60), -- 1px row borders
	surfaceHigh2 = Color3.fromRGB(64, 72, 88), -- topmost interactive step (e.g. button hover)

	-- accent
	accent = Color3.fromRGB(123, 97, 255),
	accentSoft = Color3.fromRGB(157, 139, 255),
	cyan = Color3.fromRGB(56, 224, 255), -- slider thumb only

	-- text
	textPrimary = Color3.fromRGB(236, 238, 245),
	textSecondary = Color3.fromRGB(162, 168, 184),
	textMuted = Color3.fromRGB(110, 117, 133),
}
