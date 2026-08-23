-- ===== 加载UI=====
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
if not WindUI then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "错误",
        Text = "WindUI 失败",
        Duration = 5
    })
    return
end

WindUI:SetTheme("Dark")
WindUI.TransparencyValue = 1

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local isRunning = false
local loopConnection = nil
local shoot = game:GetService("ReplicatedStorage"):WaitForChild("remotes"):WaitForChild("shoot")
local fireRate = 40
local redButtonGUI = nil

-- ===== 射击函数 =====
local function getShootArgs()
    local camera = workspace.CurrentCamera
    if not camera then return nil end

    local viewportSize = camera.ViewportSize
    local centerPos = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)

    local ray = camera:ScreenPointToRay(centerPos.X, centerPos.Y, 0)
    local origin = ray.Origin
    local direction = ray.Direction.Unit

    local endPos = origin + direction * 1000

    return {
        CFrame.new(origin, origin + direction),
        CFrame.new(endPos, endPos + direction)
    }
end

local function toggleShoot()
    isRunning = not isRunning

    if isRunning then
        loopConnection = RunService.RenderStepped:Connect(function()
            if not isRunning then
                if loopConnection then
                    loopConnection:Disconnect()
                    loopConnection = nil
                end
                return
            end

            local args = getShootArgs()
            if not args then return end

            for i = 1, fireRate do
                if not isRunning then break end
                pcall(function()
                    shoot:FireServer(unpack(args))
                end)
            end
        end)
    else
        if loopConnection then
            loopConnection:Disconnect()
            loopConnection = nil
        end
    end
end

-- ===== 创建按钮 =====
local function createOrShowRedButton()
    -- 如果已存在，返回
    if redButtonGUI and redButtonGUI.Parent then
        redButtonGUI.Enabled = true
        redButtonGUI.Visible = true
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "连射按钮",
            Text = "按钮已重新显示",
            Duration = 2
        })
        return
    end

    -- 如果存在但被销毁，重新创建
    if redButtonGUI then
        redButtonGUI = nil
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "RedButtonUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game:GetService("CoreGui")
    redButtonGUI = screenGui

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 200, 0, 60)
    btn.Position = UDim2.new(0.5, -100, 0.5, -30)
    btn.Text = "连射"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    btn.BackgroundTransparency = 0
    btn.BorderSizePixel = 0
    btn.Active = true
    btn.Draggable = true
    btn.Parent = screenGui

    btn.MouseButton1Click:Connect(function()
        toggleShoot()
        if isRunning then
            btn.Text = "你是给"
            btn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        else
            btn.Text = "我是给"
            btn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        end
    end)

    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "连射按钮",
        Text = "oh my god😍",
        Duration = 2
    })
end

-- ===== Wind UI 窗口 =====
local Window = WindUI:CreateWindow({
    Title = "射击控制",
    Author = "User",
    Icon = "",
    Theme = "Dark",
    Size = UDim2.fromOffset(400, 250),
    SideBarWidth = 150,
    Resizable = true,
    AutoScale = true
})

local MainTab = Window:Tab({ Title = "控制", Icon = "" })

local SettingsGroup = MainTab:Section({ Title = "射速设置" })

SettingsGroup:Input({
    Title = "射速",
    Default = "40",
    Callback = function(v)
        local val = tonumber(v)
        if val and val > 0 then
            fireRate = val
        end
    end
})

SettingsGroup:Button({
    Title = "创建红色按钮",
    Callback = function()
        createOrShowRedButton()
    end
})

print("Wind UI 连射脚本已加载")
print("输入射速后点击创建红色按钮")