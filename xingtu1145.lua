-- ===== XT牛逼 =====
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

-- ===== 缓存变量 =====
local cachedSirens = {}
local cachedCats = {}
local lastCacheUpdate = 0
local CACHE_INTERVAL = 2
local highlightedObjects = {}

-- ===== 亮度循环锁定变量 =====
local brightEnabled = false
local brightLoop = nil
local originalBrightness = game:GetService("Lighting").Brightness

-- ===== 人类透视变量 =====
local humanESP = false
local humanHighlights = {}

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

local function updateCache()
    local now = tick()
    if now - lastCacheUpdate < CACHE_INTERVAL then 
        return
    end
    cachedSirens = getModelsByPartialName("siren")
    cachedCats = getModelsByPartialName("cat")
    lastCacheUpdate = now
end

local function addHighlight(model, color)
    if highlightedObjects[model] then return end
    if model:FindFirstChild("ESP_Highlight") then 
        highlightedObjects[model] = true
        return 
    end
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.FillColor = color
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = color
    highlight.OutlineTransparency = 0
    highlight.Parent = model
    highlightedObjects[model] = true
end

local function removeHighlight(model)
    local highlight = model:FindFirstChild("ESP_Highlight")
    if highlight then 
        highlight:Destroy()
        highlightedObjects[model] = nil
    end
end

local function clearAllHighlights(type)
    local keyword = type == "siren" and "siren" or "cat"
    local models = getModelsByPartialName(keyword)
    for _, model in ipairs(models) do
        removeHighlight(model)
    end
end

local function refreshAllESP()
    updateCache()
    
    if not sirenESP then
        for _, model in ipairs(cachedSirens) do
            removeHighlight(model)
        end
    end
    if not catESP then
        for _, model in ipairs(cachedCats) do
            removeHighlight(model)
        end
    end

    if sirenESP then
        local count = 0
        for _, model in ipairs(cachedSirens) do
            if count >= MAX_VISIBLE then break end
            addHighlight(model, Color3.fromRGB(255, 100, 0))
            count = count + 1
        end
    end

    if catESP then
        local count = 0
        for _, model in ipairs(cachedCats) do
            if count >= MAX_VISIBLE then break end
            addHighlight(model, Color3.fromRGB(255, 0, 255))
            count = count + 1
        end
    end
end

task.spawn(function()
    while true do
        if sirenESP or catESP then
            refreshAllESP()
        end
        task.wait(2)
    end
end)

local needRefresh = false
workspace.DescendantAdded:Connect(function(child)
    if child:IsA("Model") and (sirenESP or catESP) then
        needRefresh = true
    end
end)

task.spawn(function()
    while true do
        if needRefresh and (sirenESP or catESP) then
            needRefresh = false
            refreshAllESP()
        end
        task.wait(0.5)
    end
end)

-- ===== 人类透视函数 =====
local function refreshHumanESP()
    for _, hl in pairs(humanHighlights) do
        pcall(function() hl:Destroy() end)
    end
    humanHighlights = {}

    if not humanESP then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char then
                local highlight = Instance.new("Highlight")
                highlight.Name = "HumanESP"
                highlight.FillColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.5
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.OutlineTransparency = 0
                highlight.Parent = char
                table.insert(humanHighlights, highlight)
            end
        end
    end
end

-- ===== 监控新玩家 =====
Players.PlayerAdded:Connect(function(player)
    if humanESP then
        player.CharacterAdded:Connect(function()
            task.wait(0.5)
            refreshHumanESP()
        end)
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    if humanESP then
        task.wait(0.5)
        refreshHumanESP()
    end
end)

task.spawn(function()
    while true do
        if humanESP then
            refreshHumanESP()
        end
        task.wait(2)
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
            -- 如果有其他清理函数可添加
        end)
        task.wait(0.55) -- 每0.55秒清理一次（射击日志、ESP日志、摄像机日志等）
    end
end)

-- ===== 亮度循环锁定 =====
local function startBrightnessLoop()
    if brightLoop then return end
    brightLoop = task.spawn(function()
        while brightEnabled do
            local lighting = game:GetService("Lighting")
            lighting.Brightness = 70
            task.wait(0.01)
        end
    end)
end

local function stopBrightnessLoop()
    if brightLoop then
        task.cancel(brightLoop)
        brightLoop = nil
    end
end

-- ============================================================
-- Wind UI 窗口（加大尺寸确保标签页可见）
-- ============================================================

local Window = WindUI:CreateWindow({
    Title = "XT-Script",
    Author = "User",
    Icon = "",
    Theme = "Dark",
    Size = UDim2.fromOffset(550, 550),
    SideBarWidth = 180,
    Resizable = true,
    AutoScale = true
})

-- ===== 控制标签页 =====
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

-- ===== ESP标签页 =====
local ESPTab = Window:Tab({ Title = "ESP", Icon = "" })

local ESPGroup = ESPTab:Section({ Title = "怪物透视" })

ESPGroup:Toggle({
    Title = "汽笛人透视",
    Default = false,
    Callback = function(v)
        sirenESP = v
        refreshAllESP()
    end
})

ESPGroup:Toggle({
    Title = "卡通猫透视",
    Default = false,
    Callback = function(v)
        catESP = v
        refreshAllESP()
    end
})

ESPGroup:Toggle({
    Title = "透视所有人类（可以透视成怪物的人类）",
    Default = false,
    Callback = function(v)
        humanESP = v
        refreshHumanESP()
    end
})

-- ===== 地图标签页 =====
local MapTab = Window:Tab({ Title = "地图", Icon = "" })

local MapGroup = MapTab:Section({ Title = "照明设置" })

MapGroup:Toggle({
    Title = "亮度锁定",
    Default = false,
    Callback = function(v)
        brightEnabled = v
        local lighting = game:GetService("Lighting")
        if v then
            originalBrightness = lighting.Brightness
            startBrightnessLoop()
        else
            stopBrightnessLoop()
            lighting.Brightness = originalBrightness
        end
    end
})

-- ===== 除雾 =====
local fogRemoved = false
local fogInstance = nil

MapGroup:Toggle({
    Title = "除雾",
    Default = false,
    Callback = function(v)
        fogRemoved = v
        local lighting = game:GetService("Lighting")
        if v then
            fogInstance = lighting:FindFirstChild("Fog")
            if fogInstance then
                fogInstance:Destroy()
            else
                local atmosphere = lighting:FindFirstChildOfClass("Atmosphere")
                if atmosphere then
                    atmosphere:Destroy()
                end
            end
        else
            -- 不输出任何信息
        end
    end
})

-- ===== 快捷变标签页 =====
local MorphTab = Window:Tab({ Title = "快捷变", Icon = "" })

local MorphGroup = MorphTab:Section({ Title = "变形" })

-- 获取变形事件
local morphEvent = game:GetService("ReplicatedStorage"):WaitForChild("remotes"):WaitForChild("morph")

MorphGroup:Button({
    Title = "汽笛人",
    Callback = function()
        pcall(function()
            morphEvent:FireServer("Siren Head")
        end)
    end
})

MorphGroup:Button({
    Title = "卡通猫",
    Callback = function()
        pcall(function()
            morphEvent:FireServer("Cartoon Cat")
        end)
    end
})

MorphGroup:Button({
    Title = "白龙",
    Callback = function()
        pcall(function()
            morphEvent:FireServer("Long Horse")
        end)
    end
})

MorphGroup:Button({
    Title = "士兵",
    Callback = function()
        pcall(function()
            morphEvent:FireServer("Soldier")
        end)
    end
})

MorphGroup:Button({
    Title = "医生",
    Callback = function()
        pcall(function()
            morphEvent:FireServer("Medic")
        end)
    end
})

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "加载成功",
    Text = "脚本已正常加载😎",
    Duration = 3
})