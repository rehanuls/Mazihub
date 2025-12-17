-- MWB Auto v1.5 by Mazihub

-- Log
warn("MWB_v1.5_running")

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local Controller = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/rehanuls/Mazihub/main/scripts/MWB/Connector/init.lua"
))()

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
title.Size = UDim2.new(1, -80, 0, 28)
title.Position = UDim2.new(0, 10, 0, 6)
title.TextSize = 16
title.BackgroundTransparency = 1
title.Text = "MWB Auto"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- Minimize Button
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(26, 26)
minimize.Position = UDim2.new(1, -60, 0, 6)
minimize.Text = "-"
minimize.TextScaled = true
minimize.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minimize.Parent = frame
Instance.new("UICorner", minimize)

-- Close Button (Kill Script)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(26, 26)
closeBtn.Position = UDim2.new(1, -30, 0, 6)
closeBtn.Text = "×"
closeBtn.TextScaled = true
closeBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Parent = frame
Instance.new("UICorner", closeBtn)

-- Delay Label
local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(0, 60, 0, 26)
delayLabel.Position = UDim2.new(0, 10, 0, 50)
delayLabel.BackgroundTransparency = 1
delayLabel.Text = "Delay"
delayLabel.TextScaled = true
delayLabel.TextXAlignment = Enum.TextXAlignment.Left
delayLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
delayLabel.Parent = frame

-- Delay Box
local delayBox = Instance.new("TextBox")
delayBox.Size = UDim2.new(0, 80, 0, 26)
delayBox.Position = UDim2.new(0, 75, 0, 50)
delayBox.Text = "0.2"
delayBox.TextScaled = true
delayBox.ClearTextOnFocus = false
delayBox.Parent = frame

Instance.new("UICorner", delayBox).CornerRadius = UDim.new(0, 8)

-- Auto Collect Checkbox
local checkBox = Instance.new("TextButton")
checkBox.Size = UDim2.fromOffset(24, 24)
checkBox.Position = UDim2.new(1, -34, 0, 85)
checkBox.Text = ""
checkBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
checkBox.Parent = frame
Instance.new("UICorner", checkBox)

-- Auto Collect Label
local checkLabel = Instance.new("TextLabel")
checkLabel.Size = UDim2.new(1, -60, 0, 24)
checkLabel.Position = UDim2.new(0, 10, 0, 85)
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

-- Auto Open Crate Checkbox
local openBox = Instance.new("TextButton")
openBox.Size = UDim2.fromOffset(24, 24)
openBox.Position = UDim2.new(1, -34, 0, 115)
openBox.Text = ""
openBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
openBox.Parent = frame
Instance.new("UICorner", openBox)

local openLabel = Instance.new("TextLabel")
openLabel.Size = UDim2.new(1, -60, 0, 24)
openLabel.Position = UDim2.new(0, 10, 0, 115)
openLabel.BackgroundTransparency = 1
openLabel.Text = "Auto Open Crate"
openLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
openLabel.TextScaled = true
openLabel.TextXAlignment = Enum.TextXAlignment.Left
openLabel.Parent = frame

local openMark = Instance.new("TextLabel")
openMark.Size = UDim2.new(1, 0, 1, 0)
openMark.BackgroundTransparency = 1
openMark.Text = "✓"
openMark.TextScaled = true
openMark.Visible = false
openMark.TextColor3 = Color3.fromRGB(0, 200, 0)
openMark.Parent = openBox

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

-- Auto Collect Toggle
checkBox.MouseButton1Click:Connect(function()
	local enabled = not checkMark.Visible
	checkMark.Visible = enabled

	if enabled then
		local delay = tonumber(delayBox.Text)
		if delay then
			Controller.toggleAutoCollect(true, delay)
		else
			checkMark.Visible = false
		end
	else
		Controller.toggleAutoCollect(false)
	end
end)

-- Auto Open Crate toggle
openBox.MouseButton1Click:Connect(function()
	local enabled = not openMark.Visible
	openMark.Visible = enabled

	if enabled then
		Controller.toggleAutoOpen(true)
	else
		Controller.toggleAutoOpen(false)
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
	Controller.stopAll()

	-- Clean up GUI
	if gui then
		gui:Destroy()
	end
end)
