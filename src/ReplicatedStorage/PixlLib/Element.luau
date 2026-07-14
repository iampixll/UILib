local vide = require("./Packages/vide")

local source = vide.source

-- The shell every element shares. It owns the parts that are the same everywhere - the
-- handle you get back from Tab:CreateX, its name, whether it is visible, how it is removed
-- again - so the element files below only describe what makes them different: their value
-- and how they look.
--
-- Value semantics (Toggle, Slider, Input, Dropdown, Keybind):
--   :Set(value)        applies it AND fires the callback, like a user interaction would
--   :SetSilent(value)  applies it without firing - used when restoring a saved config
--   :Get()             reads it back
--
-- Display elements (Button, Label, Section, Paragraph, Divider) hold no value, so :Set falls
-- back to their text - the only thing they *have*. Button:Set("Go") therefore keeps working,
-- and :Set never silently does nothing.
local Element = {}
Element.__index = Element

export type Handle = {
	Type: string,
	Flag: string?,

	Get: (Handle) -> any,
	Set: (Handle, any) -> (),
	SetSilent: (Handle, any) -> (),
	SetName: (Handle, string) -> (),
	SetVisible: (Handle, boolean) -> (),
	Destroy: (Handle) -> (),
}

-- kind:   "Toggle", "Slider", ... - what the element is, mirrored on the handle as .Type
-- config: the table the user passed to Tab:CreateX
-- impl:   { get = function() -> value, set = function(value, fire: boolean) }
--         `set` is what actually applies a value; `fire` tells it whether to run the
--         user's callback. Omit both for a display-only element.
function Element.new(kind: string, config, impl)
	local self = setmetatable({}, Element)

	self.Type = kind
	self.Flag = config.Flag

	-- Tab and the config store index elements by `.flag`; keep the lowercase field as the
	-- one they read so there is a single spelling in the internals.
	self.flag = config.Flag

	self.name = source(config.Name or "")
	self.visible = source(true)

	-- No value of its own -> its text stands in for one, so Button:Set("Go") relabels it
	self._get = impl and impl.get or self.name
	self._set = impl and impl.set or function(text)
		self.name(tostring(text))
	end

	-- Filled in by Tab:addChild, which is the only thing that can take us out of the tree
	self._remove = nil

	return self
end

function Element:Get(): any
	return self._get()
end

-- Applies the value and fires the callback, the same way clicking the element would. This is
-- what you want for "turn this feature on from code".
function Element:Set(value)
	self._set(value, true)
end

-- Applies the value without firing the callback. Restoring a saved config uses this when
-- Configuration.FireCallbacksOnLoad is off, so loading a file cannot start features behind
-- the user's back.
function Element:SetSilent(value)
	self._set(value, false)
end

function Element:SetName(name: string)
	self.name(name)
end

function Element:SetVisible(visible: boolean)
	self.visible(visible)
end

function Element:IsVisible(): boolean
	return self.visible()
end

-- Removes the element from its tab. Vide tears the rendered instances down with the scope,
-- and any connection the element registered via vide.cleanup goes with it.
function Element:Destroy()
	if self._remove then
		self._remove()
		self._remove = nil
	end
end

return Element
