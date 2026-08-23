
-- ===== XT牛逼，操你妈 =====
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
if not WindUI then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "错误",
        Text = "加载失败",
        Duration = 5
    })
    return
end

WindUI:SetTheme("Dark")
WindUI.TransparencyValue = 1

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ===== 射击变量 =====
local isRunning = false
local loopConnection = nil
local shoot = game:GetService("ReplicatedStorage"):WaitForChild("remotes"):WaitForChild("shoot")
local fireRate = 40
local redButtonGUI = nil

-- ===== ESP变量 =====
local sirenESP = false
local catESP = false
local MAX_VISIBLE = 5

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
    if redButtonGUI and redButtonGUI.Parent then
        redButtonGUI.Enabled = true
        redButtonGUI.Visible = true
        return
    end

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
            btn.Text = "关"
            btn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        else
            btn.Text = "开"
            btn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        end
    end)
end

-- ============================================================
-- ESP 功能
-- ============================================================

local function getModelsByPartialName(partialName)
    local results = {}
    partialName = partialName:lower()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local name = obj.Name:lower()
            if name:find(partialName) then
                table.insert(results, obj)
            end
        end
    end
    return results
end

local function addHighlight(model, color)
    if model:FindFirstChild("ESP_Highlight") then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.FillColor = color
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = color
    highlight.OutlineTransparency = 0
    highlight.Parent = model
end

local function removeHighlight(model)
    local highlight = model:FindFirstChild("ESP_Highlight")
    if highlight then highlight:Destroy() end
end

local function clearAllHighlights(type)
    local keyword = type == "siren" and "siren" or "cat"
    local models = getModelsByPartialName(keyword)
    for _, model in ipairs(models) do
        removeHighlight(model)
    end
end

-- ===== 刷新透视 =====
local function refreshAllESP()
    clearAllHighlights("siren")
    clearAllHighlights("cat")

    if sirenESP then
        local models = getModelsByPartialName("siren")
        local count = 0
        for _, model in ipairs(models) do
            if count >= MAX_VISIBLE then break end
            addHighlight(model, Color3.fromRGB(255, 100, 0))
            count = count + 1
        end
    end

    if catESP then
        local models = getModelsByPartialName("cat")
        local count = 0
        for _, model in ipairs(models) do
            if count >= MAX_VISIBLE then break end
            addHighlight(model, Color3.fromRGB(255, 0, 255))
            count = count + 1
        end
    end
end

-- ===== 定时刷新（每1秒刷新一次，减少CPU占用） =====
task.spawn(function()
    while true do
        if sirenESP or catESP then
            refreshAllESP()
        end
        task.wait(1.1)  -- 每1.1秒刷新一次
    end
end)

-- ===== 监控新生成的模型 =====
workspace.DescendantAdded:Connect(function(child)
    if child:IsA("Model") and (sirenESP or catESP) then
        refreshAllESP()
    end
end)

-- ===== 清理日志 =====
task.spawn(function()
    while true do
        pcall(function()
            if syn and syn.clearOutput then
                syn.clearOutput()
            end
            if syn and syn.clearLog then
                syn.clearLog()
            end
            if clearsettings then
                clearsettings()
            end
        end)
        task.wait(0.05)
    end
end)

-- ============================================================
-- Wind UI 窗口
-- ============================================================

local Window = WindUI:CreateWindow({
    Title = "XT-Script",
    Author = "User",
    Icon = "",
    Theme = "Dark",
    Size = UDim2.fromOffset(400, 350),
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
    Title = "点击创建按钮😡",
    Callback = function()
        createOrShowRedButton()
    end
})

local ESPTab = Window:Tab({ Title = "ESP", Icon = "" })

local ESPGroup = ESPTab:Section({ Title = "怪物透视" })

ESPGroup:Toggle({
    Title = "汽笛人透视 (real_siren)",
    Default = false,
    Callback = function(v)
        sirenESP = v
        refreshAllESP()
    end
})

ESPGroup:Toggle({
    Title = "卡通猫透视 (cartoon_cat)",
    Default = false,
    Callback = function(v)
        catESP = v
        refreshAllESP()
    end
})

print("Wind UI 脚本已加载")