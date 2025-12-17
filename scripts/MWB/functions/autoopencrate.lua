-- functions/autoopencrate.lua
-- Opens crates sequentially with UI-safe delay

local AutoOpen = {}
local running = false

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remote = ReplicatedStorage
	:WaitForChild("Remotes")
	:WaitForChild("Crate")
	:WaitForChild("CrateOpenRequest")

local START_PLACE = 1
local END_PLACE = 10
local OPEN_DELAY = 3 -- seconds between open attempts

local function openLoop()
	while running do
		for i = START_PLACE, END_PLACE do
			if not running then return end

			local placeName = "Place" .. i

			-- Fire open request
			remote:FireServer(placeName)

			-- IMPORTANT:
			-- Only wait long if something likely opened
			-- Empty places will be ignored instantly by server
			task.wait(0.15)
		end

		-- Small delay before rescanning all places
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
