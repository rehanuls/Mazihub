-- autoopen_crate.lua
-- Opens Place1 to Place10 sequentially
-- Not yet integrated into MWB

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remote = ReplicatedStorage
	:WaitForChild("Remotes")
	:WaitForChild("Crate")
	:WaitForChild("CrateOpenRequest")

for i = 1, 10 do
	remote:FireServer("Place" .. i)
	task.wait(0.2)
end
