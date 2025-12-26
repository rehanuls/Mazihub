-- SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local ClickSlot = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("ClickSlot")
local PlotsFolder = workspace:WaitForChild("Plots")

-- FIND YOUR PLOT
local function getMyPlot()
    for _, plot in ipairs(PlotsFolder:GetChildren()) do
        if plot:GetAttribute("OwnerUserId") == player.UserId then
            return plot
        end
    end
end

local myPlot
repeat
    myPlot = getMyPlot()
    task.wait(0.2)
until myPlot

local Binder = myPlot:WaitForChild("Binder")
local SlotsPage1 = Binder:WaitForChild("Page1"):WaitForChild("Page"):WaitForChild("Slots")
local SlotsPage2 = Binder:WaitForChild("Page2"):WaitForChild("Page"):WaitForChild("Slots")

-- AUTO COLLECT LOGIC
local enabled = false

local function collectAll()
    for i = 1, 9 do
        local s1 = SlotsPage1:FindFirstChild(tostring(i))
        if s1 then ClickSlot:FireServer(s1) end

        local s2 = SlotsPage2:FindFirstChild(tostring(i))
        if s2 then ClickSlot:FireServer(s2) end
    end
end

task.spawn(function()
    while true do
        if enabled then
            collectAll()
        end
        task.wait(0.2)
    end
end)

-- UI
if player.PlayerGui:FindFirstChild("MCCAutoGUI") then
    player.PlayerGui.MCCAutoGUI:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "MCCAutoGUI"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

-- MAIN FRAME
local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(280, 160)
frame.Position = UDim2.fromScale(0.5, 0.5) - UDim2.fromOffset(140, 80)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -100, 0, 28)
title.Position = UDim2.new(0, 10, 0, 8)
title.BackgroundTransparency = 1
title.Text = "MCC Auto"
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- MINIMIZE BUTTON
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.fromOffset(24, 24)
minimizeBtn.Position = UDim2.new(1, -90, 0, 8)
minimizeBtn.Text = "-"
minimizeBtn.TextSize = 18
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.Parent = frame
Instance.new("UICorner", minimizeBtn)

-- CLOSE BUTTON
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(24, 24)
closeBtn.Position = UDim2.new(1, -60, 0, 8)
closeBtn.Text = "×"
closeBtn.TextSize = 18
closeBtn.BackgroundColor3 = Color3.fromRGB(130, 50, 50)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Parent = frame
Instance.new("UICorner", closeBtn)

-- ON/OFF TOGGLE
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.fromOffset(100, 40)
toggleBtn.Position = UDim2.new(0.5, -50, 0.5, -10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 20
toggleBtn.Text = "OFF"
toggleBtn.Parent = frame
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)

toggleBtn.MouseButton1Click:Connect(function()
    enabled = not enabled
    if enabled then
        toggleBtn.Text = "ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(65, 125, 65)
    else
        toggleBtn.Text = "OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

-- MINIMIZED ICON
local miniIcon = Instance.new("TextButton")
miniIcon.Size = UDim2.fromOffset(48, 48)
miniIcon.Position = UDim2.fromScale(0.1, 0.5)
miniIcon.Text = "MCC"
miniIcon.Font = Enum.Font.GothamBold
miniIcon.TextSize = 18
miniIcon.TextColor3 = Color3.new(1,1,1)
miniIcon.BackgroundColor3 = Color3.fromRGB(30,30,30)
miniIcon.BorderSizePixel = 2
miniIcon.BorderColor3 = Color3.fromRGB(200, 50, 50)
miniIcon.Visible = false
miniIcon.Active = true
miniIcon.Draggable = true
miniIcon.Parent = gui
Instance.new("UICorner", miniIcon).CornerRadius = UDim.new(0, 10)

-- MINIMIZE & RESTORE
minimizeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    miniIcon.Position = frame.Position
    miniIcon.Visible = true
end)

miniIcon.MouseButton1Click:Connect(function()
    miniIcon.Visible = false
    frame.Position = miniIcon.Position
    frame.Visible = true
end)

-- CLOSE SCRIPT
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
