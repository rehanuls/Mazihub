------------------------------------------------
-- SERVICES
------------------------------------------------
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local ClickSlot = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("ClickSlot")
local PlotsFolder = workspace:WaitForChild("Plots")

------------------------------------------------
-- PLOT RESOLUTION
------------------------------------------------
local function resolvePlot()
    for _, plot in ipairs(PlotsFolder:GetChildren()) do
        if plot:GetAttribute("OwnerUserId") == player.UserId then
            return plot
        end
    end
end

local plot
repeat
    plot = resolvePlot()
    task.wait(0.2)
until plot

------------------------------------------------
-- SLOT REFERENCES
------------------------------------------------
local Binder = plot:WaitForChild("Binder")
local SlotsLeft  = Binder.Page1.Page.Slots
local SlotsRight = Binder.Page2.Page.Slots

------------------------------------------------
-- COLLECT LOGIC
------------------------------------------------
local enabled = false
local collectDelay = 0.2
local MIN_DELAY, MAX_DELAY = 0.05, 1.0

local function collectAll()
    for i = 1, 9 do
        local a = SlotsLeft:FindFirstChild(tostring(i))
        local b = SlotsRight:FindFirstChild(tostring(i))
        if a then ClickSlot:FireServer(a) end
        if b then ClickSlot:FireServer(b) end
    end
end

task.spawn(function()
    while true do
        if enabled then
            collectAll()
        end
        task.wait(collectDelay)
    end
end)

------------------------------------------------
-- UI CREATION
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "MCC_UI"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

-- MAIN WINDOW
local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(260, 130)
main.Position = UDim2.fromScale(0.5, 0.45) - UDim2.fromOffset(130, 65)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- TITLE BAR
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1, 0, 0, 32)
top.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", top).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.fromOffset(10, 0)
title.BackgroundTransparency = 1
title.Text = "MCC"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.new(1,1,1)
title.TextXAlignment = Enum.TextXAlignment.Left

local btnMin = Instance.new("TextButton", top)
btnMin.Size = UDim2.fromOffset(26, 22)
btnMin.Position = UDim2.new(1, -58, 0.5, -11)
btnMin.Text = "–"
btnMin.Font = Enum.Font.GothamBold
btnMin.TextSize = 18
btnMin.BackgroundColor3 = Color3.fromRGB(45,45,45)
btnMin.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", btnMin).CornerRadius = UDim.new(0, 6)

local btnClose = Instance.new("TextButton", top)
btnClose.Size = UDim2.fromOffset(26, 22)
btnClose.Position = UDim2.new(1, -30, 0.5, -11)
btnClose.Text = "×"
btnClose.Font = Enum.Font.GothamBold
btnClose.TextSize = 18
btnClose.BackgroundColor3 = Color3.fromRGB(130,40,40)
btnClose.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", btnClose).CornerRadius = UDim.new(0, 6)

------------------------------------------------
-- BODY
------------------------------------------------
local body = Instance.new("Frame", main)
body.Position = UDim2.fromOffset(0, 32)
body.Size = UDim2.new(1, 0, 1, -32)
body.BackgroundTransparency = 1

-- TOGGLE
local toggle = Instance.new("TextButton", body)
toggle.Size = UDim2.fromOffset(120, 34)
toggle.Position = UDim2.new(0.5, -60, 0, 10)
toggle.Text = "OFF"
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 18
toggle.BackgroundColor3 = Color3.fromRGB(45,45,45)
toggle.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 8)

-- DELAY LABEL
local delayLabel = Instance.new("TextLabel", body)
delayLabel.Size = UDim2.new(1, 0, 0, 18)
delayLabel.Position = UDim2.fromOffset(0, 52)
delayLabel.BackgroundTransparency = 1
delayLabel.Text = "Delay: 0.20s"
delayLabel.Font = Enum.Font.Gotham
delayLabel.TextSize = 14
delayLabel.TextColor3 = Color3.new(1,1,1)

-- SLIDER
local slider = Instance.new("Frame", body)
slider.Size = UDim2.fromOffset(200, 6)
slider.Position = UDim2.new(0.5, -100, 0, 78)
slider.BackgroundColor3 = Color3.fromRGB(50,50,50)
Instance.new("UICorner", slider).CornerRadius = UDim.new(1,0)

local knob = Instance.new("Frame", slider)
knob.Size = UDim2.fromOffset(14, 14)
knob.BackgroundColor3 = Color3.fromRGB(220,220,220)
knob.Position = UDim2.fromScale((collectDelay - MIN_DELAY) / (MAX_DELAY - MIN_DELAY), -0.5)
knob.Active = true
Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

------------------------------------------------
-- UI LOGIC
------------------------------------------------
toggle.MouseButton1Click:Connect(function()
    enabled = not enabled
    toggle.Text = enabled and "ON" or "OFF"
    toggle.BackgroundColor3 = enabled
        and Color3.fromRGB(70,130,70)
        or Color3.fromRGB(45,45,45)
end)

do
    local dragging = false

    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    RunService.RenderStepped:Connect(function()
        if not dragging then return end

        local x = math.clamp(
            (UserInputService:GetMouseLocation().X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X,
            0, 1
        )

        knob.Position = UDim2.fromScale(x, -0.5)
        collectDelay = MIN_DELAY + (MAX_DELAY - MIN_DELAY) * x
        delayLabel.Text = string.format("Delay: %.2fs", collectDelay)
    end)
end

------------------------------------------------
-- MINIMIZED BAR
------------------------------------------------
local mini = Instance.new("Frame", gui)
mini.Size = UDim2.fromOffset(90, 34)
mini.BackgroundColor3 = Color3.fromRGB(20,20,20)
mini.Visible = false
mini.Active = true
mini.Draggable = true
Instance.new("UICorner", mini).CornerRadius = UDim.new(0, 10)

local miniBtn = Instance.new("TextButton", mini)
miniBtn.Size = UDim2.fromScale(1,1)
miniBtn.BackgroundTransparency = 1
miniBtn.Text = "MCC"
miniBtn.Font = Enum.Font.GothamBold
miniBtn.TextSize = 16
miniBtn.TextColor3 = Color3.new(1,1,1)

local function snap(frame)
    local vp = workspace.CurrentCamera.ViewportSize
    local x = frame.AbsolutePosition.X + frame.AbsoluteSize.X/2
    local y = math.clamp(frame.AbsolutePosition.Y, 10, vp.Y - frame.AbsoluteSize.Y - 10)

    frame.Position = UDim2.fromOffset(
        x < vp.X/2 and 10 or vp.X - frame.AbsoluteSize.X - 10,
        y
    )
end

btnMin.MouseButton1Click:Connect(function()
    mini.Position = main.Position
    main.Visible = false
    mini.Visible = true
    snap(mini)
end)

miniBtn.MouseButton1Click:Connect(function()
    main.Position = mini.Position
    mini.Visible = false
    main.Visible = true
end)

------------------------------------------------
-- CLOSE
------------------------------------------------
btnClose.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
