-- functions/autosell.lua
-- Autosell v2: Sell all inventory via Sell.Inventory

local Autosell = {}
local running = false

-- Optional callback: function(reason)
Autosell.onStopped = nil

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

local sellInventoryRemote = ReplicatedStorage
	:WaitForChild("Remotes")
	:WaitForChild("Sell")
	:WaitForChild("Inventory")

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

-- Safety: detect equipped tool
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

local function stopInternal(reason)
	if not running then return end
	running = false

	if typeof(Autosell.onStopped) == "function" then
		Autosell.onStopped(reason)
	end
end

local function autosellLoop()
	while running do
		-- Stop if player equips something
		if hasEquippedTool() then
			warn("[Autosell] Equipped item detected")
			stopInternal("equipped")
			return
		end

		local count = getBackpackCount()

		-- Nothing to sell → stop
		if count == 0 then
			warn("[Autosell] Backpack empty")
			stopInternal("empty")
			return
		end

		-- Sell everything (NPC logic)
		sellInventoryRemote:FireServer()
		warn("[Autosell] Sell.Inventory fired, item count:", count)

		-- Calm pacing
		task.wait(SELL_COOLDOWN)
		task.wait(CHECK_INTERVAL)
	end
end

function Autosell.start()
	if running then return end
	running = true
	task.spawn(autosellLoop)
end

function Autosell.stop()
	stopInternal("manual")
end

return Autosell
