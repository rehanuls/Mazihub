-- functions/autocollect.lua
-- Handles auto cash collection logic ONLY

local Autocollect = {}
local running = false

-- Services & Remote
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remote = ReplicatedStorage
	:WaitForChild("Remotes")
	:WaitForChild("Brainrot")
	:WaitForChild("CashCollectRequest")

-- Internal loop
local function collect(delay)
	while running do
		for i = 1, 8 do
			if not running then return end
			remote:FireServer("Space" .. i)
			task.wait(delay)
		end
	end
end

-- Public API
function Autocollect.start(delay)
	if running then return end
	running = true
	task.spawn(collect, delay)
end

function Autocollect.stop()
	running = false
end

return Autocollect
