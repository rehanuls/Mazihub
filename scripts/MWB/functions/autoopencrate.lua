-- functions/autoopen_crate.lua
-- Opens ready crates sequentially (UI-safe)

local AutoOpen = {}
local running = false

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remote = ReplicatedStorage
	:WaitForChild("Remotes")
	:WaitForChild("Crate")
	:WaitForChild("CrateOpenRequest")

local START_PLACE = 1
local END_PLACE = 10
local OPEN_DELAY = 3 -- seconds (IMPORTANT for UI safety)

local function openLoop()
	while running do
		for i = START_PLACE, END_PLACE do
			if not running then return end

			-- Try opening this place
			remote:FireServer("Place" .. i)

			-- Always wait to avoid stacked animations
			task.wait(OPEN_DELAY)
		end

		-- Optional pause before scanning again
		task.wait(1)
	end
end

function AutoOpen.start()
	if running then return end
	running = true
	task.spawn(openLoop)
end

function AutoOpen.stop()
	running = false
end

return AutoOpenfunction AutoOpen.stop()
	running = false
end

return AutoOpen

-- === TEST HARNESS (remove after testing) ===
_G.MWB_AutoOpen = _G.MWB_AutoOpen or {}

_G.MWB_AutoOpen.start = function()
	AutoOpen.start()
	warn("[TEST] AutoOpen started")
end

_G.MWB_AutoOpen.stop = function()
	AutoOpen.stop()
	warn("[TEST] AutoOpen stopped")
end
