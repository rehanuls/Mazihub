--// === BASELINE AUTO BUY RELIC (STABLE) === //--

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local buyRemote = ReplicatedStorage.Remotes.Relic.Buy
local updateShop = ReplicatedStorage.Remotes.Relic.UpdateShop

-- Debug indicator
warn("[AUTO RELIC] Baseline script loaded")

-- Reads stock directly from RelicShop UI (server-approved)
local function autoBuyRelics()
	local gui = player.PlayerGui:FindFirstChild("RelicShop")
	if not gui then
		warn("[AUTO RELIC] RelicShop UI not found")
		return
	end

	local container = gui.Frame.Container
	if not container then
		warn("[AUTO RELIC] Relic container not found")
		return
	end

	for _, relicFrame in pairs(container:GetChildren()) do
		local stockLabel = relicFrame:FindFirstChild("Stock")
		if stockLabel and stockLabel:IsA("TextLabel") then
			local stock = tonumber(stockLabel.Text:match("%d+"))
			if stock and stock > 0 then
				warn("[AUTO RELIC] Buying:", relicFrame.Name, "Stock:", stock)
				buyRemote:FireServer(relicFrame.Name)
				task.wait(0.4) -- safety delay
			end
		end
	end
end

-- React ONLY when shop naturally updates
updateShop.OnClientEvent:Connect(function()
	task.wait(0.25) -- allow UI to refresh
	autoBuyRelics()
end)

-- Optional manual trigger for testing
-- autoBuyRelics()
