-- functions/autoopen_crate.lua
-- Handles auto opening crates logic ONLY

local AutoOpen = {}
local running = false

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remote = ReplicatedStorage
	:WaitForChild("Remotes")
	:WaitForChild("Crate")
	:WaitForChild("CrateOpenRequest")

local START_PLACE = 1
local END_PLACE = 10
local OPEN_DELAY = 0.2

local function openLoop()
	while running do
		for i = START_PLACE, END_PLACE do
			if not running then return end
			remote:FireServer("Place" .. i)
			task.wait(OPEN_DELAY)
		end

		-- Optional: wait before next full cycle
		task.wait(0.5)
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

return AutoOpen
