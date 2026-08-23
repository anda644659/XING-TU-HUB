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

-- ===== 射击变量 =====
local isRunning = false
local loopConnection = nil
local shoot = game:GetService("ReplicatedStorage"):WaitForChild("remotes"):WaitForChild("shoot")
local fireRate = 40
local redButtonGUI = nil

-- ===== ESP变量 =====
local sirenESP = false
local catESP = false
local sirenHighlights = {}
local catHighlights = {}

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

-- ===== 创建红色按钮 =====
local function createOrShowRedButton()
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

    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "连射按钮",
        Text = "oh my god😍",
        Duration = 2
    })
end

-- ============================================================
-- ESP 功能
-- ============================================================

-- ===== 获取所有匹配的模型 =====
local function getModelsByName(name)
    local results = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:lower() == name:lower() then
            table.insert(results, obj)
        end
    end
    return results
end

-- ===== 添加高亮 =====
local function addHighlight(model, color)
    if model:FindFirstChild("ESP_Highlight") then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.FillColor = color
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = color
    highlight.OutlineTransparency = 0
    highlight.Parent = model
    return highlight
end

-- ===== 移除高亮 =====
local function removeHighlight(model)
    local highlight = model:FindFirstChild("ESP_Highlight")
    if highlight then highlight:Destroy() end
end

-- ===== 刷新汽笛人透视 =====
local function refreshSirenESP()
    local models = getModelsByName("real_siren")
    for _, model in ipairs(models) do
        if sirenESP then
            if not model:FindFirstChild("ESP_Highlight") then
                addHighlight(model, Color3.fromRGB(255, 100, 0))
            end
        else
            removeHighlight(model)
        end
    end
end

-- ===== 刷新卡通猫透视 =====
local function refreshCatESP()
    local models = getModelsByName("cartoon_cat")
    for _, model in ipairs(models) do
        if catESP then
            if not model:FindFirstChild("ESP_Highlight") then
                addHighlight(model, Color3.fromRGB(255, 0, 255))
            end
        else
            removeHighlight(model)
        end
    end
end

-- ===== 监控新生成的模型 =====
local function startESPMonitoring()
    workspace.DescendantAdded:Connect(function(child)
        if child:IsA("Model") then
            local name = child.Name:lower()
            if name == "real_siren" and sirenESP then
                addHighlight(child, Color3.fromRGB(255, 100, 0))
            elseif name == "cartoon_cat" and catESP then
                addHighlight(child, Color3.fromRGB(255, 0, 255))
            end
        end
    end)
end
startESPMonitoring()

-- ============================================================
-- Wind UI 窗口
-- ============================================================

local Window = WindUI:CreateWindow({
    Title = "射击控制 & ESP",
    Author = "User",
    Icon = "",
    Theme = "Dark",
    Size = UDim2.fromOffset(400, 350),
    SideBarWidth = 150,
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
    Title = "汽笛人透视 (real_siren)",
    Default = false,
    Callback = function(v)
        sirenESP = v
        refreshSirenESP()
        print(v and "汽笛人透视已开启" or "汽笛人透视已关闭")
    end
})

ESPGroup:Toggle({
    Title = "卡通猫透视 (cartoon_cat)",
    Default = false,
    Callback = function(v)
        catESP = v
        refreshCatESP()
        print(v and "卡通猫透视已开启" or "卡通猫透视已关闭")
    end
})

print("Wind UI 脚本已加载（射击 + ESP）")
print("控制标签页：射速设置 + 红色按钮")
print("ESP标签页：汽笛人透视 + 卡通猫透视")