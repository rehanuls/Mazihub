-- Auto collect cash
local running = false

local function collect(delay)
	while running do
		for i = 1, 8 do
			if not running then break end
			remote:FireServer("Space" .. i)
			task.wait(delay)
		end
	end
end
