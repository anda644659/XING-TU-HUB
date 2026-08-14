-- ===== 平滑下移并返回（下降速度加快5，总距离400） =====
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local isRunning = false
local currentTween = nil
local startPosition = nil
local noclipEnabled = false
local noclipConnection = nil

-- ===== 穿墙控制 =====
local function enableNoclip()
    if noclipEnabled then return end
    noclipEnabled = true
    noclipConnection = game:GetService("RunService").Stepped:Connect(function()
        if not noclipEnabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

local function disableNoclip()
    noclipEnabled = false
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    local char = LocalPlayer.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- ===== 创建UI（CoreGui，可拖动，重生不消失） =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SmoothMoveUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 200, 0, 60)
btn.Position = UDim2.new(0.5, -100, 0.85, 0)
btn.Text = "⬇️ 下移"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.TextScaled = true
btn.Font = Enum.Font.GothamBold
btn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
btn.Active = true
btn.Draggable = true
btn.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = btn

-- ===== 停止移动 =====
local function stopMovement()
    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end
    if startPosition and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local returnTween = TweenService:Create(root, TweenInfo.new(1, Enum.EasingStyle.Linear), {CFrame = startPosition})
            returnTween:Play()
            returnTween.Completed:Connect(function()
                disableNoclip()
            end)
        end
    else
        disableNoclip()
    end
    isRunning = false
    btn.Text = "⬇️ 下移"
    btn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
    startPosition = nil
end

-- ===== 开始移动 =====
local function startMove()
    if isRunning then return end
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    isRunning = true
    btn.Text = "⏹️ 移动中..."
    btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)

    enableNoclip()

    startPosition = root.CFrame
    -- 速度 = 20/0.1秒，2秒总距离 = 400
    local downOffset = Vector3.new(0, -400, 0)
    local targetCF = startPosition + downOffset

    local tweenDown = TweenService:Create(root, TweenInfo.new(2, Enum.EasingStyle.Linear), {CFrame = targetCF})
    currentTween = tweenDown

    tweenDown:Play()
    tweenDown.Completed:Connect(function()
        if not isRunning then return end
        -- 返回速度不变（2秒回到原位）
        local tweenUp = TweenService:Create(root, TweenInfo.new(2, Enum.EasingStyle.Linear), {CFrame = startPosition})
        currentTween = tweenUp
        tweenUp:Play()
        tweenUp.Completed:Connect(function()
            if isRunning then
                isRunning = false
                btn.Text = "⬇️ 下移"
                btn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
                currentTween = nil
                startPosition = nil
                disableNoclip()
            end
        end)
    end)
end

-- ===== 按钮点击事件 =====
btn.MouseButton1Click:Connect(function()
    if isRunning then
        stopMovement()
    else
        startMove()
    end
end)

-- ===== 角色重生时重置 =====
LocalPlayer.CharacterAdded:Connect(function()
    if isRunning then
        isRunning = false
        btn.Text = "⬇️ 下移"
        btn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
        currentTween = nil
        startPosition = nil
        disableNoclip()
    end
end)

print("✅ 平滑移动脚本已加载（下降速度 = 20/0.1秒，总距离400）")
print("📌 点击按钮开始下移2秒，然后返回")