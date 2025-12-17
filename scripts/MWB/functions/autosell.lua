-- functions/autosell.lua
-- Autosell v1: sell all Backpack items safely

local Autosell = {}
local running = false

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

local sellRemote = ReplicatedStorage
	:WaitForChild("Remotes")
	:WaitForChild("Sell")
	:WaitForChild("Brainrots")

local CHECK_INTERVAL = 1.5
local SELL_COOLDOWN = 1.0

-- Count tools ONLY in Backpack
local function getBackpackCount()
	local backpack = player:FindFirstChild("Backpack")
	if not backpack then return 0 end

	local count = 0
	for _, item in ipairs(backpack:GetChildren()) do
		if item:IsA("Tool") then
			count += 1
		end
	end
	return count
end

-- Detect equipped tool (safety net)
local function hasEquippedTool()
	local character = player.Character
	if not character then return false end

	for _, item in ipairs(character:GetChildren()) do
		if item:IsA("Tool") then
			return true
		end
	end
	return false
end

local function autosellLoop()
	while running do
		-- Safety: stop if player equips something
		if hasEquippedTool() then
			warn("[Autosell] Equipped item detected, stopping")
			running = false
			return
		end

		local count = getBackpackCount()

		-- Nothing to sell → stop
		if count == 0 then
			warn("[Autosell] Backpack empty, stopping")
			running = false
			return
		end

		-- Sell once
		sellRemote:FireServer()
		warn("[Autosell] Sold items, count:", count)

		-- Cooldown after sell
		task.wait(SELL_COOLDOWN)

		-- Re-check at a calm pace
		task.wait(CHECK_INTERVAL)
	end
end

function Autosell.start()
	if running then return end
	running = true
	task.spawn(autosellLoop)
end

function Autosell.stop()
	running = false
end

return Autosell
