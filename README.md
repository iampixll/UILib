# PixlLib (UILib)

Vide-based UI library — the source for the bundled `source.luau` shipped from the public
`iampixll/PixlLib` repo.

## Build

Bundling is done by **darklua** (local `darklua.exe`, path require mode). Entry point is
`src/PixlLib/init.luau`, which returns the library table.

`darklua.exe` is git-ignored — keep a copy in the repo root (grab it from the pet sim script
folder or download darklua). vide is **vendored** under `Packages/vide/` (no wally, no rokit);
update it by replacing that folder by hand.

Repo bundle (what gets pushed to the public PixlLib repo):

```bash
./darklua.exe process src/PixlLib/init.luau source.luau
```

Local test bundle for the executor (Volt workspace), with watch so it rebuilds on every save:

```bash
./darklua.exe process src/PixlLib/init.luau "C:\Users\milan\AppData\Local\Volt\workspace\vs-scripts\pixllib.luau" --watch
```

Load it in the executor with:

```lua
loadstring(readfile("vs-scripts/pixllib.luau"))()   -- local test
loadstring(game:HttpGet("https://raw.githubusercontent.com/iampixll/PixlLib/refs/heads/main/source.luau"))()  -- production
```

### vide + darklua notes

Two things make the vendored vide source bundle-able with darklua; both are already set up:

- **`@vide` alias** (`.luaurc`) points straight at `Packages/vide/src/lib.luau`. vide's own
  `init.luau` uses a Roblox-instance require (`require(script...)`) that darklua's path mode
  can't follow — `lib.luau` uses plain relative string requires, so we require it directly.
- **`Packages/vide/test/mock.luau`** is a stub. vide's source has dead fallbacks like
  `game and typeof or require "../test/mock"` that never run inside Roblox, but darklua resolves
  *every* require statically, so the target file has to exist. If you ever replace the vendored
  vide folder, recreate this stub (a table exporting `typeof`, `Instance`, `Enum`, `Color3`).

## Usage

```lua
local PixlLib = loadstring(readfile("vs-scripts/pixllib.luau"))()

local window = PixlLib:CreateWindow({
    Title = "PixlLib",
    ToggleKey = "RightControl",

    Configuration = {
        Saving = true,
        Loading = true,
        FolderName = "PixlLib",
        FileName = "PixlHub",
        -- Restoring a saved toggle also runs its callback. Set false if a restored config
        -- must not act on its own at launch.
        FireCallbacksOnLoad = true,
    },
})

local tab = window:CreateTab("Farming", "farming")

tab:CreateToggle({
    Name = "Auto collect orbs",
    Flag = "AutoCollectOrbs",
    Keybind = { CurrentKeybind = "L", HoldToInteract = false, Flag = "AutoCollectOrbsKey" },
    Callback = function(value)
        -- ...
    end,
})
```

The topbar has an internal settings view (gear icon) with a live rebind of the toggle key and an
Unload button; `PixlLib:Destroy()` tears the whole interface down and stops every active toggle.
