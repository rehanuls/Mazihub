-- autosell_base.lua
-- Baseline auto-sell logic (Backpack + Equipped tools)

warn("autosell_base_loaded")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local sellRemote = ReplicatedStorage
	:WaitForChild("Remotes")
	:WaitForChild("Sell")
	:WaitForChild("Brainrots")

local AUTO_SELL = false
local CHECK_INTERVAL = 1.5
local SELL_COOLDOWN = 1.0

-- Count tools in Backpack + Character
local function getInventoryCount()
	local count = 0

	local backpack = player:FindFirstChild("Backpack")
	if backpack then
		for _, item in ipairs(backpack:GetChildren()) do
			if item:IsA("Tool") then
				count += 1
			end
		end
	end

	local character = player.Character
	if character then
		for _, item in ipairs(character:GetChildren()) do
			if item:IsA("Tool") then
				count += 1
			end
		end
	end

	return count
end

-- Auto sell loop
task.spawn(function()
	while true do
		if AUTO_SELL then
			local count = getInventoryCount()
			if count > 0 then
				sellRemote:FireServer()
				warn("[autosell_base] Sold items:", count)
				task.wait(SELL_COOLDOWN)
			end
		end
		task.wait(CHECK_INTERVAL)
	end
end)

-- Toggle for testing (temporary)
_G.toggleAutoSell = function(state)
	AUTO_SELL = state
	warn("[autosell_base] Auto Sell:", state and "ON" or "OFF")
end
