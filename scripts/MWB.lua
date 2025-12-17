-- MWB Auto v1.5 by Mazihub

-- Log
warn("MWB_v1.5_running")

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- Remote
local remote = ReplicatedStorage.Remotes.Brainrot.CashCollectRequest

-- Cleanup old GUI
if player.PlayerGui:FindFirstChild("MWBAutoGUI") then
	player.PlayerGui.MWBAutoGUI:Destroy()
end

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "MWBAutoGUI"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(260, 200)
frame.Position = UDim2.fromScale(0.5, 0.5) - UDim2.fromOffset(130, 100)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.Text = "MWB Auto"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- Minimize Button
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(30, 30)
minimize.Position = UDim2.new(1, -70, 0, 8)
minimize.Text = "-"
minimize.TextScaled = true
minimize.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minimize.Parent = frame
Instance.new("UICorner", minimize)

-- Close Button (Kill Script)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(30, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 8)
closeBtn.Text = "×"
closeBtn.TextScaled = true
closeBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Parent = frame
Instance.new("UICorner", closeBtn)

-- Delay Label
local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(1, -20, 0, 20)
delayLabel.Position = UDim2.new(0, 10, 0, 50)
delayLabel.BackgroundTransparency = 1
delayLabel.Text = "Delay /s"
delayLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
delayLabel.TextScaled = true
delayLabel.Parent = frame

-- Delay Box
local delayBox = Instance.new("TextBox")
delayBox.Size = UDim2.new(0.5, -15, 0, 36)
delayBox.Position = UDim2.new(0, 10, 0, 70)
delayBox.Text = "0.2"
delayBox.ClearTextOnFocus = false
delayBox.TextScaled = true
delayBox.Parent = frame

-- Auto Collect Checkbox
local checkBox = Instance.new("TextButton")
checkBox.Size = UDim2.fromOffset(24, 24)
checkBox.Position = UDim2.new(1, -34, 0, 125)
checkBox.Text = ""
checkBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
checkBox.Parent = frame
Instance.new("UICorner", checkBox)

local checkLabel = Instance.new("TextLabel")
checkLabel.Size = UDim2.new(1, -60, 0, 24)
checkLabel.Position = UDim2.new(0, 10, 0, 125)
checkLabel.BackgroundTransparency = 1
checkLabel.Text = "Auto Collect"
checkLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
checkLabel.TextScaled = true
checkLabel.TextXAlignment = Enum.TextXAlignment.Left
checkLabel.Parent = frame

local checkMark = Instance.new("TextLabel")
checkMark.Size = UDim2.new(1, 0, 1, 0)
checkMark.BackgroundTransparency = 1
checkMark.Text = "✓"
checkMark.TextScaled = true
checkMark.Visible = false
checkMark.TextColor3 = Color3.fromRGB(0, 200, 0)
checkMark.Parent = checkBox

-- Minimized Icon
local mini = Instance.new("TextButton")
mini.Size = UDim2.fromOffset(42, 42)
mini.Position = UDim2.fromScale(0.1, 0.5)
mini.Text = "MWB"
mini.Font = Enum.Font.GothamBold
mini.TextSize = 16
mini.TextScaled = true
mini.Visible = false
mini.Active = true
mini.Draggable = true
mini.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mini.TextColor3 = Color3.fromRGB(180, 180, 180)
mini.Parent = gui
Instance.new("UICorner", mini).CornerRadius = UDim.new(0, 10)

-- Logic
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

-- Checkbox toggle = START / STOP
checkBox.MouseButton1Click:Connect(function()
	running = not running
	checkMark.Visible = running

	if running then
		local delay = tonumber(delayBox.Text)
		if delay then
			task.spawn(collect, delay)
		else
			running = false
			checkMark.Visible = false
		end
	end
end)

-- Minimize / Restore
minimize.MouseButton1Click:Connect(function()
	frame.Visible = false
	mini.Visible = true
end)

mini.MouseButton1Click:Connect(function()
	mini.Visible = false
	frame.Visible = true
end)

-- Close / Kill Script
closeBtn.MouseButton1Click:Connect(function()
	running = false

	-- Clean up GUI
	if gui then
		gui:Destroy()
	end
end)
