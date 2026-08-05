-- ============================================================
-- 星途综合脚本 v2
-- ============================================================
-- 作者: B站蒸饺巡捕 Roblox星际 b站郑祥富 访客1377 猫叠
-- 说明: 星途脚本 V2破解了拿去缝合圈钱的操你妈 
-- ============================================================

-- ===== 加载UI库 =====
local success, ui = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/3345179204-sudo/-/refs/heads/main/UI%E5%BA%93", true))()
end)

if not success or not ui then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "错误",
        Text = "UI库加载失败，请检查网络",
        Duration = 5
    })
    return
end

local Player = game:GetService("Players").LocalPlayer
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local function SendNotif(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 1.5,
            Button1 = "确定"
        })
    end)
end

-- ============================================================
-- 卡密系统 (Key System)
-- ============================================================
local KeySystem = {
    CorrectKey = "星际真帅",
    EnteredKey = "",
    Verified = false
}

local function ShowKeySystem()
    local keyWindow = Instance.new("ScreenGui")
    keyWindow.Name = "KeySystem"
    keyWindow.Parent = Player.PlayerGui
    keyWindow.ResetOnSpawn = false

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 350, 0, 220)
    frame.Position = UDim2.new(0.5, -175, 0.5, -110)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    frame.BorderColor3 = Color3.fromRGB(60, 60, 70)
    frame.BackgroundTransparency = 0.1
    frame.Parent = keyWindow

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 45)
    title.Position = UDim2.new(0, 0, 0, 5)
    title.Text = "🔑 星途验证"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 24
    title.Parent = frame

    local subTitle = Instance.new("TextLabel")
    subTitle.Size = UDim2.new(1, 0, 0, 25)
    subTitle.Position = UDim2.new(0, 0, 0, 50)
    subTitle.Text = "请输入卡密以继续"
    subTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
    subTitle.BackgroundTransparency = 1
    subTitle.Font = Enum.Font.SourceSans
    subTitle.TextSize = 16
    subTitle.Parent = frame

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0, 250, 0, 40)
    input.Position = UDim2.new(0.5, -125, 0, 80)
    input.PlaceholderText = "请输入卡密..."
    input.Text = ""
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    input.BorderColor3 = Color3.fromRGB(60, 60, 70)
    input.Font = Enum.Font.SourceSans
    input.TextSize = 18
    input.Parent = frame

    local confirm = Instance.new("TextButton")
    confirm.Size = UDim2.new(0, 150, 0, 40)
    confirm.Position = UDim2.new(0.5, -75, 0, 135)
    confirm.Text = "验证"
    confirm.TextColor3 = Color3.fromRGB(255, 255, 255)
    confirm.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    confirm.BorderColor3 = Color3.fromRGB(0, 80, 160)
    confirm.Font = Enum.Font.SourceSansBold
    confirm.TextSize = 18
    confirm.Parent = frame

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 25)
    status.Position = UDim2.new(0, 0, 0, 185)
    status.Text = ""
    status.TextColor3 = Color3.fromRGB(255, 100, 100)
    status.BackgroundTransparency = 1
    status.Font = Enum.Font.SourceSans
    status.TextSize = 14
    status.Parent = frame

    confirm.MouseButton1Click:Connect(function()
        local entered = input.Text
        if entered == KeySystem.CorrectKey then
            KeySystem.Verified = true
            KeySystem.EnteredKey = entered
            status.Text = "✅ 验证成功！"
            status.TextColor3 = Color3.fromRGB(0, 255, 100)
            task.wait(0.5)
            keyWindow:Destroy()
            SendNotif("卡密验证", "✅ 验证成功！欢迎使用星途脚本", 2)
        else
            status.Text = "❌ 卡密错误，请重试"
            status.TextColor3 = Color3.fromRGB(255, 100, 100)
            input.Text = ""
        end
    end)

    input.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            confirm.MouseButton1Click:Fire()
        end
    end)

    keyWindow.Parent = Player.PlayerGui
end

-- 显示卡密系统
ShowKeySystem()

-- 等待验证完成
repeat task.wait(0.1) until KeySystem.Verified

-- ============================================================
-- 创建主窗口 
-- ============================================================
local win = ui:new("星途综合脚本")

-- ============================================================
-- 通用功能变量
-- ============================================================
local wsValue = 16
local noclipConnection = nil
local ijConnection = nil
local godConnection = nil
local spinConnection = nil
local spinSpeed = 10
local aimbotConnection = nil
local aimRange = 500
local afkConnection = nil
local espObjects = {}
local selectedPlayer = ""
local loopTeleportToPlayer = false
local loopBringPlayer = false
local loopFlingPlayer = false

-- ============================================================
-- 通用功能函数
-- ============================================================
local function openFlyGUI()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/396abc/Script/refs/heads/main/MobileFly.lua"))()
end

local function enNoclip()
    noclipConnection = RunService.Stepped:Connect(function()
        if Player.Character then
            for _, part in ipairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function disNoclip()
    if noclipConnection then noclipConnection:Disconnect() end
end

local function enIJ()
    ijConnection = UserInputService.JumpRequest:Connect(function()
        if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
            Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

local function disIJ()
    if ijConnection then ijConnection:Disconnect() end
end

local function enFrozen()
    if Player.Character then
        for _, part in ipairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Anchored = true
            end
        end
    end
end

local function disFrozen()
    if Player.Character then
        for _, part in ipairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Anchored = false
            end
        end
    end
end

local function enGod()
    godConnection = Player.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid")
        hum:GetPropertyChangedSignal("Health"):Connect(function()
            if hum.Health < hum.MaxHealth then
                hum.Health = hum.MaxHealth
            end
        end)
    end)
    if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
        local hum = Player.Character:FindFirstChildOfClass("Humanoid")
        hum.Health = hum.MaxHealth
    end
end

local function disGod()
    if godConnection then godConnection:Disconnect() end
end

local function enInvisible()
    if Player.Character then
        for _, part in ipairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0.7
            end
        end
    end
end

local function disInvisible()
    if Player.Character then
        for _, part in ipairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            end
        end
    end
end

local function enESP()
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= Player and plr.Character and plr.Character:FindFirstChild("Head") then
            local highlight = Instance.new("Highlight")
            highlight.Parent = plr.Character
            highlight.FillTransparency = 1
            highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
            espObjects[plr] = highlight
        end
    end
    game.Players.PlayerAdded:Connect(function(plr)
        plr.CharacterAdded:Connect(function(char)
            local highlight = Instance.new("Highlight")
            highlight.Parent = char
            highlight.FillTransparency = 1
            highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
            espObjects[plr] = highlight
        end)
    end)
end

local function disESP()
    for _, hl in pairs(espObjects) do
        hl:Destroy()
    end
    espObjects = {}
end

local function killAll()
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= Player and plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
            plr.Character:FindFirstChildOfClass("Humanoid").Health = 0
        end
    end
end

local function suicide()
    if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
        Player.Character:FindFirstChildOfClass("Humanoid").Health = 0
    end
end

local function stealItems()
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        for _, plr in ipairs(game.Players:GetPlayers()) do
            if plr ~= Player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                for _, item in ipairs(Workspace:GetDescendants()) do
                    if item:IsA("Tool") and (item.Parent == plr.Character or item.Parent == plr.Backpack) then
                        item.Parent = Player.Backpack
                    end
                end
            end
        end
    end
end

local function enSpin()
    spinConnection = RunService.RenderStepped:Connect(function()
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
        end
    end)
end

local function disSpin()
    if spinConnection then spinConnection:Disconnect() end
end

local function setSpinSpeed(v) spinSpeed = v end

local function enNV()
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
end

local function disNV()
    Lighting.Brightness = 1
    Lighting.ClockTime = 14
end

local pjnConnection

local function enPJN()
    pjnConnection = game.Players.PlayerAdded:Connect(function(plr)
        SendNotif("玩家进入", plr.Name .. " 加入了游戏", 3)
    end)
end

local function disPJN()
    if pjnConnection then pjnConnection:Disconnect() end
end

local function enAimbot()
    local camera = Workspace.CurrentCamera
    aimbotConnection = RunService.RenderStepped:Connect(function()
        local closest = nil
        local shortest = aimRange
        for _, plr in ipairs(game.Players:GetPlayers()) do
            if plr ~= Player and plr.Character and plr.Character:FindFirstChild("Head") then
                local pos, onScreen = camera:WorldToScreenPoint(plr.Character.Head.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - camera.ViewportSize / 2).Magnitude
                    if dist < shortest then
                        shortest = dist
                        closest = plr.Character.Head
                    end
                end
            end
        end
        if closest then
            camera.CFrame = CFrame.lookAt(camera.CFrame.Position, closest.Position)
        end
    end)
end

local function disAimbot()
    if aimbotConnection then aimbotConnection:Disconnect() end
end

local function enAFK()
    local vu = VirtualUser
    afkConnection = RunService.Heartbeat:Connect(function()
        vu:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        task.wait(0.1)
        vu:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    end)
end

local function disAFK()
    if afkConnection then afkConnection:Disconnect() end
end

local function rejoin()
    game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
end

local function leave()
    game:Shutdown()
end

local function setGravity(v)
    Workspace.Gravity = v
end

local function getPlayerList()
    local list = {}
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= Player then
            table.insert(list, plr.Name)
        end
    end
    if #list == 0 then
        table.insert(list, "无其他玩家")
    end
    return list
end

-- ============================================================
-- 强力甩飞功能
-- ============================================================
local function FlingPlayer(targetName)
    if not targetName or targetName == "" or targetName == "无其他玩家" then
        SendNotif("甩飞", "请先选择目标玩家", 2)
        return
    end
    local target = game.Players:FindFirstChild(targetName)
    if not target then
        SendNotif("甩飞", "目标玩家不存在", 2)
        return
    end
    local char = Player.Character
    if not char then
        SendNotif("甩飞", "你还没有角色", 2)
        return
    end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local targetChar = target.Character
    if not targetChar then
        SendNotif("甩飞", "目标玩家没有角色", 2)
        return
    end
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot then
        SendNotif("甩飞", "目标玩家没有 HumanoidRootPart", 2)
        return
    end
    
    root.CFrame = CFrame.lookAt(root.Position, Vector3.new(targetRoot.Position.X, root.Position.Y, targetRoot.Position.Z))
    task.wait(0.05)
    
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = (targetRoot.Position - root.Position).Unit * 250 + Vector3.new(0, 80, 0)
    bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bv.Parent = targetRoot
    task.wait(0.15)
    bv:Destroy()
    
    targetRoot.RotVelocity = Vector3.new(1e9, 1e9, 1e9)
    
    SendNotif("甩飞", "已甩飞 " .. targetName, 2)
end

local function TeleportToPlayer(targetName)
    if not targetName or targetName == "" or targetName == "无其他玩家" then
        SendNotif("传送", "请先选择目标玩家", 2)
        return
    end
    local target = game.Players:FindFirstChild(targetName)
    if not target then
        SendNotif("传送", "目标玩家不存在", 2)
        return
    end
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local targetChar = target.Character
    if not targetChar then return end
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    root.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
    SendNotif("传送", "已传送到 " .. targetName, 2)
end

local function BringPlayer(targetName)
    if not targetName or targetName == "" or targetName == "无其他玩家" then
        SendNotif("传送", "请先选择目标玩家", 2)
        return
    end
    local target = game.Players:FindFirstChild(targetName)
    if not target then
        SendNotif("传送", "目标玩家不存在", 2)
        return
    end
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local targetChar = target.Character
    if not targetChar then return end
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    targetRoot.CFrame = root.CFrame + Vector3.new(0, 3, 0)
    SendNotif("传送", "已把 " .. targetName .. " 传送过来", 2)
end

function TeleportTo(position)
    local char = Player.Character
    if not char then
        SendNotif("传送失败", "角色不存在，请重生后重试", 3)
        return false
    end
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        SendNotif("传送失败", "未找到 HumanoidRootPart", 3)
        return false
    end
    pcall(function()
        rootPart.CFrame = CFrame.new(position)
        SendNotif("传送成功", "已传送至目标位置", 2)
    end)
    return true
end

-- ============================================================
-- 创建标签页 
-- ============================================================
-- 按照脚本UI库的格式创建标签页
-- 脚本UI库使用 win:Tab("名称", '图标ID') 格式
-- 使用 about:Label / about:Button / about:Toggle / about:Slider / about:Textbox / about:Dropdown

-- 标签页1: 公告/信息
local InfoTab = win:Tab("『公告』", '114514')
local infoSection = InfoTab:section("『信息』", true)

infoSection:Label("作者：B站蒸饺巡捕 roblox星际")
infoSection:Label("版本：星途v2")

infoSection:Button("复制作者B站号", function()
    local id = "3546917738908337"
    pcall(function()
        if setclipboard then setclipboard(id)
        else StarterGui:SetCore("CopyToClipboard", {Text = id}) end
    end)
    SendNotif("复制成功", "已复制B站号: " .. id, 2)
end)

infoSection:Button("复制QQ群聊", function()
    local qq = "1020592687"
    pcall(function()
        if setclipboard then setclipboard(qq)
        else StarterGui:SetCore("CopyToClipboard", {Text = qq}) end
    end)
    SendNotif("复制成功", "已复制QQ群号: " .. qq, 2)
end)

local infoSection2 = InfoTab:section("『信息2』", true)
local function safeIdentify()
    local success, res = pcall(identifyexecutor)
    return success and res or "未知"
end
infoSection2:Label("你的注入器:" .. safeIdentify())
infoSection2:Label("服务器名称:" .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
infoSection2:Label("当前服务器ID:" .. game.GameId)
infoSection2:Label("你的用户名:" .. Player.DisplayName)
infoSection2:Label("你的账号年龄:" .. Player.AccountAge .. "天")
if Player.MembershipType == Enum.MembershipType.Premium then
    infoSection2:Label("会员状态：有会员")
else
    infoSection2:Label("会员状态：没有会员")
end

local infoSection3 = InfoTab:section("『操作』", true)
infoSection3:Button("重新加入服务器", function()
    pcall(function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
    end)
end)

infoSection3:Button("关闭UI", function()
    local coreGui = game:GetService("CoreGui")
    local targetGui = coreGui:FindFirstChild("frosty")
    if targetGui then
        targetGui:Destroy()
    end
    -- 也尝试关闭脚本UI
    local winGui = coreGui:FindFirstChild("脚本通用源码")
    if winGui then
        winGui:Destroy()
    end
end)

-- ============================================================
-- 标签页2: 通用 (General)
-- ============================================================
local GeneralTab = win:Tab("『通用』", '114514')
local genSection = GeneralTab:section("『基础功能』", true)

genSection:Button("飞行", openFlyGUI)

genSection:Toggle("穿墙", "Toggle", false, function(v)
    if v then enNoclip() else disNoclip() end
end)

genSection:Toggle("无限跳", "Toggle", false, function(v)
    if v then enIJ() else disIJ() end
end)

genSection:Toggle("无法移动", "Toggle", false, function(v)
    if v then enFrozen() else disFrozen() end
end)

genSection:Toggle("无敌", "Toggle", false, function(v)
    if v then enGod() else disGod() end
end)

genSection:Toggle("隐身", "Toggle", false, function(v)
    if v then enInvisible() else disInvisible() end
end)

genSection:Toggle("ESP透视", "Toggle", false, function(v)
    if v then enESP() else disESP() end
end)

genSection:Toggle("旋转", "Toggle", false, function(v)
    if v then enSpin() else disSpin() end
end)

genSection:Toggle("夜视", "Toggle", false, function(v)
    if v then enNV() else disNV() end
end)

genSection:Toggle("玩家进入通知", "Toggle", false, function(v)
    if v then enPJN() else disPJN() end
end)

genSection:Toggle("自瞄", "Toggle", false, function(v)
    if v then enAimbot() else disAimbot() end
end)

genSection:Toggle("反挂机", "Toggle", false, function(v)
    if v then enAFK() else disAFK() end
end)

local genSection2 = GeneralTab:section("『数值调节』", true)

genSection2:Slider("旋转速度", "SpinSpeed", 10, 1, 50, false, function(v)
    setSpinSpeed(v)
end)

genSection2:Slider("重力设置", "Gravity", Workspace.Gravity, 0, 500, false, function(v)
    setGravity(v)
end)

genSection2:Slider("自瞄范围", "AimRange", 500, 100, 1000, false, function(v)
    aimRange = v
end)

local genSection3 = GeneralTab:section("『泽功能增强』", true)

local lockState = false
local lockConnection = nil

genSection3:Toggle("锁定朝向", "Toggle", false, function(Value)
    lockState = Value
    if Value then
        local char = Player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.AutoRotate = false
            end
            if lockConnection then lockConnection:Disconnect() end
            lockConnection = RunService.RenderStepped:Connect(function()
                if not lockState then return end
                local c = Player.Character
                if not c then return end
                local h = c:FindFirstChildOfClass("Humanoid")
                local r = c:FindFirstChild("HumanoidRootPart")
                if h and r then
                    local cam = Workspace.CurrentCamera
                    if cam then
                        local look = cam.CFrame.LookVector
                        local dir = Vector3.new(look.X, 0, look.Z).Unit
                        if dir.Magnitude > 0 then
                            r.CFrame = CFrame.new(r.Position, r.Position + dir)
                        end
                    end
                end
            end)
        end
    else
        if lockConnection then
            lockConnection:Disconnect()
            lockConnection = nil
        end
        local char = Player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.AutoRotate = true
            end
        end
    end
end)

genSection3:Button("抓取目标", function()
    local nearest = nil
    local minDist = math.huge
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= Player then
            local tChar = plr.Character
            if tChar then
                local tRoot = tChar:FindFirstChild("HumanoidRootPart")
                if tRoot then
                    local dist = (root.Position - tRoot.Position).Magnitude
                    if dist < minDist and dist <= 50 then
                        minDist = dist
                        nearest = plr
                    end
                end
            end
        end
    end
    if nearest then
        SendNotif("抓取", "正在抓取 " .. nearest.Name, 2)
    else
        SendNotif("抓取", "未找到目标", 2)
    end
end)

genSection3:Button("电击目标", function()
    local nearest = nil
    local minDist = math.huge
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= Player then
            local tChar = plr.Character
            if tChar then
                local tRoot = tChar:FindFirstChild("HumanoidRootPart")
                if tRoot then
                    local dist = (root.Position - tRoot.Position).Magnitude
                    if dist < minDist and dist <= 50 then
                        minDist = dist
                        nearest = plr
                    end
                end
            end
        end
    end
    if nearest then
        SendNotif("电击", "正在电击 " .. nearest.Name, 2)
    else
        SendNotif("电击", "未找到目标", 2)
    end
end)

genSection3:Button("控制目标", function()
    local nearest = nil
    local minDist = math.huge
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= Player then
            local tChar = plr.Character
            if tChar then
                local tRoot = tChar:FindFirstChild("HumanoidRootPart")
                if tRoot then
                    local dist = (root.Position - tRoot.Position).Magnitude
                    if dist < minDist and dist <= 50 then
                        minDist = dist
                        nearest = plr
                    end
                end
            end
        end
    end
    if nearest then
        SendNotif("控制", "正在控制 " .. nearest.Name, 2)
    else
        SendNotif("控制", "未找到目标", 2)
    end
end)

local genSection4 = GeneralTab:section("『操作』", true)

genSection4:Button("击杀所有人", killAll)
genSection4:Button("自杀", suicide)
genSection4:Button("偷走玩家物品道具", stealItems)
genSection4:Button("静默甩飞所有人", function() loadstring(game:HttpGet("https://pastebin.com/raw/zqyDSUWX"))() end)
genSection4:Button("雷欧飞踢", function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-THE-REAL-dropkick-177199"))() end)
genSection4:Button("铁拳甩飞", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/0Ben1/fe/main/obf_rf6iQURzu1fqrytcnLBAvW34C9N55kS9g9G3CKz086rC47M6632sEd4ZZYB0AYgV.lua.txt'))() end)
genSection4:Button("FPS（变流畅）", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/gclich/FPS-X-GUI/main/FPS_X.lua"))() end)
genSection4:Button("获取管理员", function() loadstring(game:HttpGet("https://pastebin.com/raw/sZpgTVas"))() end)
genSection4:Button("死亡笔记", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/dingding123hhh/tt/main/%E6%AD%BB%E4%BA%A1%E7%AC%94%E8%AE%B0%20(1).txt"))() end)
genSection4:Button("飞车", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/dingding123hhh/vb/main/%E9%A3%9E%E8%BD%A6.lua"))() end)
genSection4:Button("假延迟脚本", function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Egor-simple-ui-91106"))() end)
genSection4:Button("操人脚本", function() loadstring(game:HttpGet("https://pastefy.app/BkeffrT5/raw"))() end)
genSection4:Button("防甩飞（可开关）", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Linux6699/DaHubRevival/main/AntiFling.lua"))() end)
genSection4:Button("重新加入", rejoin)
genSection4:Button("离开游戏", leave)

-- ============================================================
-- 标签页3: 脚本列表 (Script Tab)
-- ============================================================
local ScriptTab = win:Tab("『脚本列表』", '114514')
local scriptSection = ScriptTab:section("『外部脚本』", true)

local scripts = {
    {name = "皮脚本", url = "https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/QQ1002100032-Roblox-Pi-script.lua", env = {XiaoPi = "皮脚本QQ群1002100032"}},
    {name = "叶脚本", url = "https://raw.githubusercontent.com/roblox-ye/QQ515966991/refs/heads/main/ROBLOX-CNVIP-XIAOYE.lua"},
    {name = "BS脚本", url = "https://gitee.com/BS_script/script/raw/master/BS_Script.Luau"},
    {name = "情云脚本", url = "https://raw.githubusercontent.com/ChinaQY/-/main/%E6%83%85%E4%BA%91"},
    {name = "Aero栽赃脚本卡密（Yisan）", url = "https://api.jnkie.com/api/v1/luascripts/public/d975bd4e6385076888cb440390a8a53d8763b5e17f23f15a66516cd2f87974f7/download", env = {SCRIPT_KEY = "Yisan"}},
    {name = "窗脚本（卡密：星际真帅）", url = "https://raw.githubusercontent.com/pl11451481mvcxz/-3-/refs/heads/main/%E7%AA%97%E8%84%9A%E6%9C%AC%E5%8A%A0%E8%BD%BD%E5%99%A8"},
    {name = "刘某脚本", url = "https://pastefy.app/T1O0kwhD/raw"},
    {name = "弑脚本", url = "https://raw.githubusercontent.com/FengYu-X/_Hub_/refs/heads/X/sha.lua"},
    {name = "XK脚本", url = "https://raw.githubusercontent.com/XiaoXuAnZang/XKscript/refs/heads/main/XUAN.lua", env = {XK = "XK脚本中心"}},
    {name = "ROB脚本", url = "https://raw.gitcode.com/ROB5201314/robscript/raw/main/ROB.V3"},
    {name = "YI HUB", url = "http://YI-Script.top", env = {YI_HUB = "YI_HUB群979312897"}},
    {name = "林脚本", url = "https://raw.githubusercontent.com/linnblin/lin/main/lin"},
}

for _, s in ipairs(scripts) do
    scriptSection:Button(s.name, function()
        pcall(function()
            if s.env then
                for k, v in pairs(s.env) do
                    getgenv()[k] = v
                end
            end
            if s.name == "YI HUB" then
                loadstring(game:HttpGet(s.url))("")
            else
                loadstring(game:HttpGet(s.url))()
            end
            SendNotif("加载", s.name .. " 已加载", 2)
        end)
    end)
end

-- ============================================================
-- 标签页4: 传送与甩飞 (Teleport & Fling)
-- ============================================================
local TeleportFlingTab = win:Tab("『传送与甩飞』", '114514')
local tfSection = TeleportFlingTab:section("『玩家选择』", true)

local selectedPlayer = ""
local playerList = {}

local function refreshPlayers()
    table.clear(playerList)
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= Player then
            table.insert(playerList, player.Name)
        end
    end
end

refreshPlayers()

-- 脚本UI库的Dropdown用法
local playerDropdown = tfSection:Dropdown("选择玩家的名称", "Dropdown", playerList, function(selected)
    selectedPlayer = game.Players:FindFirstChild(selected)
end)

tfSection:Button("刷新列表", function()
    local newPlayerList = {}
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= Player then
            table.insert(newPlayerList, player.Name)
        end
    end
    playerDropdown:SetOptions(newPlayerList)
    SendNotif("刷新", "列表刷新成功", 2)
end)

tfSection:Button("查看玩家", function()
    if selectedPlayer then
        game.Workspace.CurrentCamera.CameraSubject = selectedPlayer.Character.Humanoid
    end
end)

tfSection:Button("停止查看", function()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        game.Workspace.CurrentCamera.CameraSubject = Player.Character.Humanoid
    end
end)

local tfSection2 = TeleportFlingTab:section("『传送功能』", true)

tfSection2:Button("传送到玩家旁边", function()
    if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPos = selectedPlayer.Character.HumanoidRootPart.Position
        Player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(3, 0, 3))
    end
end)

tfSection2:Toggle("锁定传送", "Toggle", false, function(state)
    loopTeleportToPlayer = state
    if state then
        SendNotif("循环传送", "已开启循环传送到玩家", 2)
        task.spawn(function()
            while loopTeleportToPlayer do
                if selectedPlayer and selectedPlayer ~= "" and selectedPlayer ~= "无其他玩家" then
                    TeleportToPlayer(selectedPlayer.Name)
                end
                task.wait(0.3)
            end
        end)
    else
        SendNotif("循环传送", "已关闭循环传送", 2)
    end
end)

tfSection2:Button("把玩家传送过来", function()
    if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local myPos = Player.Character.HumanoidRootPart.Position
        selectedPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(myPos + Vector3.new(3, 0, 3))
    end
end)

tfSection2:Toggle("循环传送玩家过来", "Toggle", false, function(state)
    loopBringPlayer = state
    if state then
        SendNotif("循环传送", "已开启循环传送玩家过来", 2)
        task.spawn(function()
            while loopBringPlayer do
                if selectedPlayer and selectedPlayer ~= "" and selectedPlayer ~= "无其他玩家" then
                    BringPlayer(selectedPlayer.Name)
                end
                task.wait(0.3)
            end
        end)
    else
        SendNotif("循环传送", "已关闭循环传送玩家过来", 2)
    end
end)

local tfSection3 = TeleportFlingTab:section("『甩飞』", true)

tfSection3:Button("甩飞一次选中的人", function()
    if selectedPlayer and selectedPlayer ~= Player then
        FlingPlayer(selectedPlayer.Name)
    else
        SendNotif("甩飞", "请选择目标玩家", 2)
    end
end)

tfSection3:Toggle("锁定甩飞选中的人", "Toggle", false, function(state)
    loopFlingPlayer = state
    if state then
        SendNotif("循环甩飞", "已开启循环甩飞", 2)
        task.spawn(function()
            while loopFlingPlayer do
                if selectedPlayer and selectedPlayer ~= "" and selectedPlayer ~= "无其他玩家" then
                    FlingPlayer(selectedPlayer.Name)
                end
                task.wait(0.5)
            end
        end)
    else
        SendNotif("循环甩飞", "已关闭循环甩飞", 2)
    end
end)

tfSection3:Button("甩飞所有人", function()
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= Player then
            FlingPlayer(plr.Name)
            task.wait(0.1)
        end
    end
end)

-- ============================================================
-- 标签页5: 防甩飞 (AntiFling)
-- ============================================================
local AntiFlingTab = win:Tab("『防甩飞』", '114514')
local afSection = AntiFlingTab:section("『防甩飞功能』", true)

afSection:Label("防止被其他玩家甩飞")

local antiFlingActive = false
local antiFlingConnection = nil

local function enableAntiFling()
    if antiFlingActive then
        SendNotif("防甩飞", "已开启", 2)
        return
    end
    antiFlingActive = true
    
    antiFlingConnection = RunService.Heartbeat:Connect(function()
        if not antiFlingActive then
            if antiFlingConnection then
                antiFlingConnection:Disconnect()
                antiFlingConnection = nil
            end
            return
        end
        
        local char = Player.Character
        if not char then return end
        
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.AssemblyLinearVelocity then
                local vel = part.AssemblyLinearVelocity
                if vel.Magnitude > 200 then
                    part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end
            end
        end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        if root and root.AssemblyLinearVelocity and root.AssemblyLinearVelocity.Magnitude > 200 then
            root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end
    end)
    
    SendNotif("防甩飞", "已开启，可防止被甩飞", 3)
end

local function disableAntiFling()
    antiFlingActive = false
    if antiFlingConnection then
        antiFlingConnection:Disconnect()
        antiFlingConnection = nil
    end
    SendNotif("防甩飞", "已关闭", 2)
end

afSection:Toggle("开启防甩飞", "Toggle", false, function(v)
    if v then
        enableAntiFling()
    else
        disableAntiFling()
    end
end)

afSection:Button("一键开启防甩飞（外部脚本）", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Linux6699/DaHubRevival/main/AntiFling.lua"))()
    SendNotif("防甩飞", "外部防甩飞脚本已加载", 2)
end)

-- ============================================================
-- 标签页6: LC脚本
-- ============================================================
local LCTab = win:Tab("『LC脚本』", '114514')
local lcSection = LCTab:section("『LC脚本』", true)
lcSection:Button("lc合集", function() loadstring(game:HttpGet("https://pastefy.app/SpHM7OAK/raw"))() end)
lcSection:Button("lcNEX脚本", function() loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/6bd5c94e9da68dce4a2bdf5abd1f6fb9a1379f41faaadbc0354b98d543066f58/download"))() end)

-- ============================================================
-- 标签页7: 死铁轨
-- ============================================================
local RailTab = win:Tab("『死铁轨』", '114514')
local railSection = RailTab:section("『死铁轨脚本』", true)
railSection:Button("死铁轨本熊脚本", function() loadstring(game:HttpGet(('https://raw.%s/%s/%s'):format('githubusercontent.com','jbu7666gvv/BHBUO/refs/heads/main','loader')))() end)
railSection:Button("死铁轨杀戮光环", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/HeadHarse/Dusty/refs/heads/main/OPAUTOSWINGV2"))() end)
railSection:Button("死铁轨通用脚本", function() loadstring(game:HttpGet("https://getnative.cc/script/loader"))() end)

-- ============================================================
-- 标签页8: 内脏与黑火药
-- ============================================================
local OrganTab = win:Tab("『内脏与黑火药』", '114514')
local organSection = OrganTab:section("『内脏与黑火药』", true)
organSection:Button("skin阉割版", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/wzhxll/2/refs/heads/main/%E9%98%89%E5%89%B2%E7%89%88.lua"))() end)
organSection:Button("鲨鱼清水脚本", function() loadstring(game:HttpGet("\104\116\116\112\115\58\47\47\112\97\115\116\101\102\121\46\97\112\112\47\65\51\78\113\122\52\78\112\47\114\97\119"))() end)

-- ============================================================
-- 标签页9: tsb
-- ============================================================
local TSBTab = win:Tab("『tsb』", '114514')
local tsbSection = TSBTab:section("『TSB脚本』", true)
local tsbScripts = {
    {name = "侧闪脚本", url = "https://api.getpolsec.com/scripts/hosted/94a29c6b88bfe8c49ea221eaa9225398790c1b7436b0f08caf7517c3002e8782.lua"},
    {name = "tsb中心脚本", url = "https://raw.githubusercontent.com/ATrainz/Phantasm/refs/heads/main/Games/TSB.lua"},
    {name = "dovi中心（自己解卡）", url = "https://raw.githubusercontent.com/needanewphone32-eng/tsbfiles/refs/heads/main/Main1.lua"},
    {name = "隐身脚本", url = "https://rawscripts.net/raw/The-Strongest-Battlegrounds-SION-ELTNAM-ATLASIA-61168"},
    {name = "垃圾桶战神", url = "https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/Trashcan%20Man"},
    {name = "镜头灵敏度操纵", url = "https://pastebin.com/raw/UQE2KDxV"}
}
for _, s in ipairs(tsbScripts) do
    tsbSection:Button(s.name, function() loadstring(game:HttpGet(s.url, true))() end)
end

-- ============================================================
-- 标签页10: doors外部
-- ============================================================
local DoorsTab = win:Tab("『doors外部』", '114514')
local doorsSection = DoorsTab:section("『DOORS外部脚本』", true)
local doorsScripts = {
    {name = "Abysall Hub脚本（免卡）", url = "https://raw.githubusercontent.com/XxwanhexxX/doors-zh/refs/heads/main/Abysall.Hub"},
    {name = "ms脚本（最强绕过，要解卡）", url = "https://api.luarmor.net/files/v3/loaders/002c19202c9946e6047b0c6e0ad51f84.lua"},
    {name = "rehax", url = "https://raw.githubusercontent.com/Cucumber190/roblox-/refs/heads/main/rehax%20Qcumber.lua"},
    {name = "bob", url = "https://raw.githubusercontent.com/notzanocoddz4/bobdoors/main/main.lua"}
}
for _, s in ipairs(doorsScripts) do
    doorsSection:Button(s.name, function() loadstring(game:HttpGet(s.url))() end)
end

-- ============================================================
-- 标签页11: 暴力区
-- ============================================================
local ViolenceTab = win:Tab("『暴力区』", '114514')
local violenceSection = ViolenceTab:section("『暴力区』", true)
violenceSection:Button("暴力区", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Pandu-Hub12/rosblox/refs/heads/main/violence"))() end)

-- ============================================================
-- 标签页12: evade
-- ============================================================
local EvadeTab = win:Tab("『evade』", '114514')
local evadeSection = EvadeTab:section("『evade』", true)
evadeSection:Button("evade", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/sccv8/Whakizashix/refs/heads/main/old%20whakizashi.txt"))() end)

-- ============================================================
-- 标签页13: 被遗弃
-- ============================================================
local AbandonedTab = win:Tab("『被遗弃』", '114514')
local abandonedSection = AbandonedTab:section("『被遗弃脚本』", true)
abandonedSection:Button("被遗弃（最强绕过）", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/aibabylaugh/catsaken-real-script-not-assets/refs/heads/main/obfuscated-1448974601077002340.lua"))() end)
abandonedSection:Button("被遗弃脚本（修机延迟改5）", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/LolnotaKid/project/refs/heads/main/AutoBLOCKKKWAHV1"))() end)
abandonedSection:Button("1", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Potato5466794/Nolsaken/refs/heads/main/EN/Nolsaken.lua"))() end)
abandonedSection:Button("情云", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/ChinaQY/Scripts/Main/Forsaken"))() end)

-- ============================================================
-- 标签页14: 监狱人生
-- ============================================================
local PrisonTab = win:Tab("『监狱人生』", '114514')
local prisonSection = PrisonTab:section("『监狱人生脚本』", true)
prisonSection:Button("监狱人生脚本", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/zenss555a/script/refs/heads/main/Prison-Life.lua"))()
end)

local prisonSection2 = PrisonTab:section("『监狱人生专用功能』", true)
prisonSection2:Button("刷武器（M9/霰弹/AK）", function()
    local char = Player.Character
    if not char then
        SendNotif("刷武器", "角色不存在", 3)
        return
    end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then
        SendNotif("刷武器", "未找到 HumanoidRootPart", 3)
        return
    end
    SendNotif("刷武器", "开始刷武器...", 3)
    root.CFrame = CFrame.new(822, 101, 2251)
    task.wait(1.1)
    pcall(function()
        if workspace.Remote and workspace.Remote.ItemHandler then
            workspace.Remote.ItemHandler:InvokeServer(unpack({ workspace.Prison_ITEMS.giver.M9.ITEMPICKUP }))
        end
    end)
    SendNotif("刷武器", "已获取 M9", 2)
    task.wait(1.1)
    root.CFrame = CFrame.new(824.801025, 104.330627, 2250.36157)
    task.wait(1.1)
    pcall(function()
        if workspace.Remote and workspace.Remote.ItemHandler then
            workspace.Remote.ItemHandler:InvokeServer(unpack({ workspace.Prison_ITEMS.giver["Remington 870"].ITEMPICKUP }))
        end
    end)
    SendNotif("刷武器", "已获取 Remington 870", 2)
    task.wait(1.1)
    root.CFrame = CFrame.new(-936.710632, 93.5627747, 2054.66602)
    task.wait(1.1)
    pcall(function()
        if workspace.Remote and workspace.Remote.ItemHandler then
            workspace.Remote.ItemHandler:InvokeServer(unpack({ workspace.Prison_ITEMS.giver["AK-47"].ITEMPICKUP }))
        end
    end)
    SendNotif("刷武器", "已获取 AK-47", 2)
    SendNotif("刷武器", "刷武器完成！", 3)
end)

prisonSection2:Button("切换警察", function()
    pcall(function()
        workspace.Remote.TeamEvent:FireServer("Bright blue")
        SendNotif("切换队伍", "已切换到警察", 2)
    end)
end)

prisonSection2:Button("切换罪犯", function()
    pcall(function()
        workspace.Remote.TeamEvent:FireServer("Bright orange")
        SendNotif("切换队伍", "已切换到罪犯", 2)
    end)
end)

-- ============================================================
-- 标签页15: 血与铁
-- ============================================================
local BloodTab = win:Tab("『血与铁』", '114514')
local bloodSection = BloodTab:section("『血与铁』", true)
bloodSection:Button("血与铁静默自瞄脚本", function() loadstring(game:HttpGet("\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\115\108\101\101\110\110\100\110\47\77\97\116\100\115\47\114\101\102\115\47\104\101\97\100\115\47\109\97\105\110\47\98\105\50\46\48"))() end)

-- ============================================================
-- 标签页16: 墨水游戏
-- ============================================================
local InkTab = win:Tab("『墨水游戏』", '114514')
local inkSection = InkTab:section("『墨水游戏』", true)
inkSection:Button("墨水游戏1", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/hdjsjjdgrhj/OK/refs/heads/main/sb"))() end)
inkSection:Button("墨水游戏2", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/QQ161475237/IDK/main/HX%E6%B1%89%E5%8C%96.txt"))() end)
inkSection:Button("墨水游戏2永久卡密", function()
    local card = "HSX-7562-3194-0835-4981-2470-1488-1029-6967"
    pcall(function()
        if setclipboard then setclipboard(card)
        else StarterGui:SetCore("CopyToClipboard", {Text = card}) end
    end)
    SendNotif("复制成功", "卡密已复制到剪切板", 2)
end)

-- ============================================================
-- 标签页17: 表情页FE动作
-- ============================================================
local EmoteTab = win:Tab("『表情页FE动作』", '114514')
local emoteSection = EmoteTab:section("『表情页FE动作』", true)
emoteSection:Button("动作脚本", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/7yd7/Hub/refs/heads/Branch/GUIS/Emotes.lua"))() end)

-- ============================================================
-- 标签页18: 娱乐
-- ============================================================
local FunTab = win:Tab("『娱乐』", '114514')
local funSection = FunTab:section("『娱乐功能』", true)
funSection:Button("ws仿真按键", function()
    do
        local gui = Instance.new("ScreenGui")
        gui.Name = "移动控制中心"
        gui.Parent = Player:WaitForChild("PlayerGui")
        gui.ResetOnSpawn = false
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 240, 0, 180)
        frame.Position = UDim2.new(0.5, -120, 0.5, -90)
        frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        frame.BackgroundTransparency = 0.15
        frame.BorderColor3 = Color3.fromRGB(60, 60, 70)
        frame.Parent = gui
        frame.Active = true
        frame.Draggable = true
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 30)
        title.Text = "🎮 移动控制 (速度版)"
        title.TextColor3 = Color3.new(1, 1, 1)
        title.BackgroundTransparency = 1
        title.Font = Enum.Font.SourceSansBold
        title.TextSize = 18
        title.Parent = frame
        local wsToggle = Instance.new("TextButton")
        wsToggle.Size = UDim2.new(0, 200, 0, 35)
        wsToggle.Position = UDim2.new(0.5, -100, 0, 40)
        wsToggle.Text = "🔴 WS模拟 (关)"
        wsToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        wsToggle.TextColor3 = Color3.new(1, 1, 1)
        wsToggle.BorderColor3 = Color3.fromRGB(80, 80, 90)
        wsToggle.Font = Enum.Font.SourceSans
        wsToggle.TextSize = 16
        wsToggle.Parent = frame
        local lockToggle = Instance.new("TextButton")
        lockToggle.Size = UDim2.new(0, 200, 0, 35)
        lockToggle.Position = UDim2.new(0.5, -100, 0, 85)
        lockToggle.Text = "🔒 视角锁定 (关)"
        lockToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        lockToggle.TextColor3 = Color3.new(1, 1, 1)
        lockToggle.BorderColor3 = Color3.fromRGB(80, 80, 90)
        lockToggle.Font = Enum.Font.SourceSans
        lockToggle.TextSize = 16
        lockToggle.Parent = frame
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 30, 0, 30)
        closeBtn.Position = UDim2.new(1, -35, 0, 0)
        closeBtn.Text = "✕"
        closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        closeBtn.TextColor3 = Color3.new(1, 1, 1)
        closeBtn.Font = Enum.Font.SourceSans
        closeBtn.TextSize = 16
        closeBtn.Parent = frame
        local wsEnabled = false
        local lockEnabled = false
        local runningWS = false
        local character = nil
        local rootPart = nil
        local humanoid = nil
        local function updateChar()
            character = Player.Character
            if character then
                rootPart = character:FindFirstChild("HumanoidRootPart")
                humanoid = character:FindFirstChildOfClass("Humanoid")
            end
        end
        updateChar()
        Player.CharacterAdded:Connect(function(newChar)
            character = newChar
            rootPart = newChar:FindFirstChild("HumanoidRootPart")
            humanoid = newChar:FindFirstChildOfClass("Humanoid")
            if lockEnabled and humanoid then
                humanoid.AutoRotate = false
            end
        end)
        local function wsLoop()
            local direction = 1
            local speed = 30
            while runningWS and wsEnabled do
                if rootPart then
                    local lookVec = Workspace.CurrentCamera.CFrame.LookVector
                    lookVec = Vector3.new(lookVec.X, 0, lookVec.Z).Unit
                    if lookVec.Magnitude < 0.01 then
                        lookVec = Vector3.new(1, 0, 0)
                    end
                    rootPart.Velocity = lookVec * direction * speed
                    direction = direction * -1
                end
                task.wait(0.1)
            end
            if rootPart then
                rootPart.Velocity = Vector3.new(0, 0, 0)
            end
        end
        RunService.RenderStepped:Connect(function()
            if not lockEnabled then return end
            if not rootPart or not humanoid then return end
            local lookVec = Workspace.CurrentCamera.CFrame.LookVector
            lookVec = Vector3.new(lookVec.X, 0, lookVec.Z).Unit
            if lookVec.Magnitude > 0.01 then
                rootPart.CFrame = CFrame.lookAt(rootPart.Position, rootPart.Position + lookVec)
            end
        end)
        wsToggle.MouseButton1Click:Connect(function()
            wsEnabled = not wsEnabled
            wsToggle.Text = wsEnabled and "🟢 WS模拟 (开)" or "🔴 WS模拟 (关)"
            if wsEnabled then
                if not runningWS then
                    runningWS = true
                    task.spawn(wsLoop)
                end
            else
                runningWS = false
            end
        end)
        lockToggle.MouseButton1Click:Connect(function()
            lockEnabled = not lockEnabled
            lockToggle.Text = lockEnabled and "🔓 视角锁定 (开)" or "🔒 视角锁定 (关)"
            if lockEnabled then
                UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
                if humanoid then
                    humanoid.AutoRotate = false
                end
            else
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                if humanoid then
                    humanoid.AutoRotate = true
                end
            end
        end)
        closeBtn.MouseButton1Click:Connect(function()
            runningWS = false
            wsEnabled = false
            lockEnabled = false
            if rootPart then
                rootPart.Velocity = Vector3.new(0, 0, 0)
            end
            if humanoid then
                humanoid.AutoRotate = true
            end
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            gui:Destroy()
        end)
        Player.CameraMode = Enum.CameraMode.Classic
        Player.CharacterAdded:Connect(function()
            task.wait(0.5)
            local char = Player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.AutoRotate = lockEnabled and false or true
                end
            end
        end)
    end
end)

-- ============================================================
-- 标签页19: 戒网中心
-- ============================================================
local JieWangTab = win:Tab("『戒网中心』", '114514')
local jieSection = JieWangTab:section("『戒网中心』", true)
jieSection:Button("1", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/chinzhuoxuan3-byte/Ys-Hub/refs/heads/main/Wifi"))() end)

-- ============================================================
-- 标签页20: 无敌少侠
-- ============================================================
local InvincibleTab = win:Tab("『无敌少侠』", '114514')
local invSection = InvincibleTab:section("『无敌少侠』", true)
invSection:Button("启动器", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/giobolqv1/invincible-characters-animations-by-GioBolqv1-/refs/heads/main/universal.lua"))() end)

-- ============================================================
-- 标签页21: 传送 (自制骚乱之城)
-- ============================================================
local TeleportTab = win:Tab("『自制骚乱之城（传送）』", '114514')
local teleSection = TeleportTab:section("『传送点』", true)
local locations = {
    {name = "银行金库", pos = Vector3.new(669.76, -6.35, -1252.18)},
    {name = "破解银行", pos = Vector3.new(682.79, -30.30, -1219.21)},
    {name = "武器店", pos = Vector3.new(-155.51, -30.14, -1266.23)},
    {name = "监狱", pos = Vector3.new(17.51, -7.90, -0.22)},
    {name = "囚犯老巢", pos = Vector3.new(281.07, 14.60, -2948.30)},
    {name = "加油站", pos = Vector3.new(823.37, -30.01, -433.86)},
    {name = "珠宝店", pos = Vector3.new(307.63, -20.12, -1624.80)},
    {name = "豪宅", pos = Vector3.new(382.42, 1.71, -2415.86)},
    {name = "拿AK", pos = Vector3.new(-1517.32, 14.89, -2850.98)},
}
for _, loc in ipairs(locations) do
    teleSection:Button(loc.name, function() TeleportTo(loc.pos) end)
end

-- ============================================================
-- 标签页22: 合成一个核弹
-- ============================================================
local BombTab = win:Tab("『合成一个核弹』", '114514')
local bombSection = BombTab:section("『合成一个核弹』", true)
bombSection:Button("YI_HUB合成一个核弹脚本", function()
    getgenv().YI_HUB = "YI_HUB群979312897"
    loadstring(game:HttpGet('http://YI-Script.top'))("")
end)

-- ============================================================
-- 标签页23: 幸运方块战争
-- ============================================================
local LuckyTab = win:Tab("『幸运方块战争』", '114514')
local luckySection = LuckyTab:section("『幸运方块战争』", true)
luckySection:Button("执行自动获取一个彩虹物品", function()
    local Event = ReplicatedStorage:FindFirstChild("SpawnRainbowBlock")
    if Event then Event:FireServer() end
end)

-- ============================================================
-- 标签页24: 战斗辅助
-- ============================================================
local CombatTab = win:Tab("『战斗辅助』", '114514')
local combatSection = CombatTab:section("『战斗设置』", true)
combatSection:Toggle("自动防御", "Toggle", false, function(v) end)
combatSection:Toggle("防挂机", "Toggle", false, function(v) end)
combatSection:Slider("防御范围", "ParryRange", 2, 0.5, 3, false, function(v) _G.ParryRangeMultiplier = v end)

local combatSection2 = CombatTab:section("『技能装备』", true)
local abilities = {"短划线", "磁场", "隐身", "平台", "狂暴偏转", "阴影步骤", "超级跳跃", "心灵感应", "雷霆冲刺", "狂喜"}
for _, ability in ipairs(abilities) do
    combatSection2:Button(ability, function()
        pcall(function()
            local remote = ReplicatedStorage:FindFirstChild("Remotes")
            if remote and remote:FindFirstChild("Store") then
                remote.Store.RequestEquipAbility:InvokeServer(ability)
                SendNotif("技能", "已装备: " .. ability, 1.5)
            end
        end)
    end)
end

-- ============================================================
-- 标签页25: 躲避
-- ============================================================
local DodgeTab = win:Tab("『躲避』", '114514')
local dodgeSection = DodgeTab:section("『躲避功能』", true)

local ActiveAutoWin = false
dodgeSection:Toggle("自动获胜", "Toggle", false, function(state)
    ActiveAutoWin = state
    if ActiveAutoWin then
        SendNotif("自动获胜", "已开启", 2)
        task.spawn(function()
            while ActiveAutoWin do
                local character = Player.Character or Player.CharacterAdded:Wait()
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if character and rootPart then
                    if character:GetAttribute("Downed") then
                        pcall(function()
                            ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(true)
                        end)
                        task.wait(0.5)
                    end
                    if not character:GetAttribute("Downed") then
                        local securityPart = Instance.new("Part")
                        securityPart.Name = "SecurityPartTemp"
                        securityPart.Size = Vector3.new(10, 1, 10)
                        securityPart.Position = Vector3.new(0, 500, 0)
                        securityPart.Anchored = true
                        securityPart.Transparency = 1
                        securityPart.CanCollide = true
                        securityPart.Parent = Workspace
                        rootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
                        task.wait(0.5)
                        securityPart:Destroy()
                    end
                end
                task.wait(0.1)
            end
        end)
    else
        SendNotif("自动获胜", "已关闭", 2)
    end
end)

local ActiveAutoFarmMoney = false
dodgeSection:Toggle("自动刷钱", "Toggle", false, function(state)
    ActiveAutoFarmMoney = state
    if ActiveAutoFarmMoney then
        SendNotif("自动刷钱", "已开启", 2)
        task.spawn(function()
            while ActiveAutoFarmMoney do
                local character = Player.Character or Player.CharacterAdded:Wait()
                local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                if character and rootPart then
                    if character:GetAttribute("Downed") then
                        pcall(function()
                            ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(true)
                        end)
                        task.wait(0.5)
                    end
                    local downedPlayerFound = false
                    local playersInGame = Workspace:FindFirstChild("Game") and Workspace.Game:FindFirstChild("Players")
                    if playersInGame then
                        for _, v in pairs(playersInGame:GetChildren()) do
                            if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and v:GetAttribute("Downed") then
                                rootPart.CFrame = v.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                                pcall(function()
                                    ReplicatedStorage.Events.Character.Interact:FireServer("Revive", true, v)
                                end)
                                task.wait(0.5)
                                downedPlayerFound = true
                                break
                            end
                        end
                    end
                    if not downedPlayerFound then
                        local securityPart = Instance.new("Part")
                        securityPart.Name = "SecurityPartTemp"
                        securityPart.Size = Vector3.new(10, 1, 10)
                        securityPart.Position = Vector3.new(0, 500, 0)
                        securityPart.Anchored = true
                        securityPart.Transparency = 1
                        securityPart.CanCollide = true
                        securityPart.Parent = Workspace
                        rootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
                    end
                end
                task.wait(1)
            end
        end)
    else
        SendNotif("自动刷钱", "已关闭", 2)
    end
end)

local dodgeSection2 = DodgeTab:section("『投票功能』", true)
local selectedMapNumber = 1
local autoVoteEnabled = false
local voteConnection = nil

local function fireVoteServer(mapNumber)
    pcall(function()
        local eventsFolder = ReplicatedStorage:FindFirstChild("Events")
        if eventsFolder then
            local playerFolder = eventsFolder:FindFirstChild("Player")
            if playerFolder then
                local voteEvent = playerFolder:FindFirstChild("Vote")
                if voteEvent and voteEvent:IsA("RemoteEvent") then
                    voteEvent:FireServer(mapNumber)
                end
            end
        end
    end)
end

local voteDropdown = dodgeSection2:Dropdown("选择地图", "Dropdown", {"地图 1", "地图 2", "地图 3", "地图 4"}, function(value)
    if value == "地图 1" then selectedMapNumber = 1
    elseif value == "地图 2" then selectedMapNumber = 2
    elseif value == "地图 3" then selectedMapNumber = 3
    elseif value == "地图 4" then selectedMapNumber = 4
    end
    SendNotif("地图选择", "已选择: " .. value, 2)
end)

dodgeSection2:Button("投票", function()
    fireVoteServer(selectedMapNumber)
    SendNotif("投票", "已投票给地图 " .. selectedMapNumber, 2)
end)

dodgeSection2:Toggle("自动投票", "Toggle", false, function(state)
    autoVoteEnabled = state
    if autoVoteEnabled then
        SendNotif("自动投票", "已开启", 2)
        if not voteConnection then
            voteConnection = RunService.Heartbeat:Connect(function()
                fireVoteServer(selectedMapNumber)
            end)
        end
    else
        SendNotif("自动投票", "已关闭", 2)
        if voteConnection then
            voteConnection:Disconnect()
            voteConnection = nil
        end
    end
end)

local dodgeSection3 = DodgeTab:section("『复活功能』", true)
local autoReviveEnabled = false
local lastCheckTime = 0
local checkInterval = 5

dodgeSection3:Button("复活自己", function()
    local character = Player.Character
    if character and character:GetAttribute("Downed") then
        pcall(function()
            ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(true)
        end)
        SendNotif("复活", "✅ 已复活!", 2)
    else
        SendNotif("复活", "你还没有倒地!", 2)
    end
end)

dodgeSection3:Toggle("自动复活自己", "Toggle", false, function(state)
    autoReviveEnabled = state
    SendNotif("自动复活", state and "已开启" or "已关闭", 2)
end)

RunService.Heartbeat:Connect(function()
    if autoReviveEnabled then
        if tick() - lastCheckTime >= checkInterval then
            lastCheckTime = tick()
            local character = Player.Character
            if character and character:GetAttribute("Downed") then
                pcall(function()
                    ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(true)
                end)
            end
        end
    end
end)

-- ============================================================
-- 标签页26: 范围+自瞄 
-- ============================================================
local AimTab = win:Tab("『范围+自瞄』", '114514')
local aimSection = AimTab:section("『范围』", true)

aimSection:Textbox("自定义范围", "HitBox", "输入", function(Value)
    _G.HeadSize = tonumber(Value)
    _G.Disabled = true 
    if _G.HeadSize then
        for i,v in next, game:GetService('Players'):GetPlayers() do
            if v.Name ~= Player.Name then 
                pcall(function()
                    v.Character.HumanoidRootPart.Size = Vector3.new(_G.HeadSize,_G.HeadSize,_G.HeadSize) 
                    v.Character.HumanoidRootPart.Transparency = 0.7 
                    v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really red")
                    v.Character.HumanoidRootPart.Material = "Neon"
                    v.Character.HumanoidRootPart.CanCollide = false
                end)
            end 
        end
        SendNotif("范围", "范围已设置", 2)
    else
        SendNotif("范围", "请输入数字", 2)
    end
end)

aimSection:Button("关闭范围", function()
    _G.Disabled = false
    for i,v in next, game:GetService('Players'):GetPlayers() do
        if v.Name ~= Player.Name and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                v.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                v.Character.HumanoidRootPart.Transparency = 1
                v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Medium stone grey")
                v.Character.HumanoidRootPart.Material = "Plastic"
                v.Character.HumanoidRootPart.CanCollide = true
            end)
        end
    end
    SendNotif("范围", "范围已关闭", 2)
end)

aimSection:Button("彩虹范围", function()
    _G.HeadSize = 20 
    _G.Disabled = true 
    
    game:GetService('RunService').RenderStepped:connect(function() 
        if _G.Disabled then
            local hue = tick() % 5 / 5
            local r = math.sin(hue * 6.28 + 0) * 127 + 128
            local g = math.sin(hue * 6.28 + 2) * 127 + 128
            local b = math.sin(hue * 6.28 + 4) * 127 + 128
            
            for i,v in next, game:GetService('Players'):GetPlayers() do 
                if v.Name ~= Player.Name then 
                    pcall(function() 
                        v.Character.HumanoidRootPart.Size = Vector3.new(_G.HeadSize,_G.HeadSize,_G.HeadSize) 
                        v.Character.HumanoidRootPart.Transparency = 0.7 
                        v.Character.HumanoidRootPart.Color = Color3.fromRGB(r, g, b)
                        v.Character.HumanoidRootPart.Material = "Neon"
                        v.Character.HumanoidRootPart.CanCollide = false
                    end) 
                end 
            end 
        end
    end)
    SendNotif("范围", "彩虹已启用", 2)
end)

local aimSection2 = AimTab:section("『快速调』", true)
local rangePresets = {15, 50, 100, 150, 200, 250, 300, 400, 500}
for _, val in ipairs(rangePresets) do
    aimSection2:Button("范围" .. val, function()
        _G.HeadSize = val
        _G.Disabled = true
        if _G.Disabled then
            for i,v in next, game:GetService('Players'):GetPlayers() do
                if v.Name ~= Player.Name then
                    pcall(function()
                        v.Character.HumanoidRootPart.Size = Vector3.new(_G.HeadSize,_G.HeadSize,_G.HeadSize)
                        v.Character.HumanoidRootPart.Transparency = 0.7
                        v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really blue")
                        v.Character.HumanoidRootPart.Material = "Neon"
                        v.Character.HumanoidRootPart.CanCollide = false
                    end)
                end
            end
        end
        SendNotif("范围", "已设置范围: " .. val, 1.5)
    end)
end

local aimSection3 = AimTab:section("『自瞄』", true)

local currentAimbotConnection = nil
local currentFOVring = nil
local currentInputConnection = nil
local rainbowHue = 0

local function cleanupCurrentAimbot()
    if currentAimbotConnection then
        currentAimbotConnection:Disconnect()
        currentAimbotConnection = nil
    end
    if currentFOVring then
        currentFOVring:Remove()
        currentFOVring = nil
    end
    if currentInputConnection then
        currentInputConnection:Disconnect()
        currentInputConnection = nil
    end
end

aimSection3:Button("关闭自瞄", function()
    cleanupCurrentAimbot()
    SendNotif("自瞄", "已关闭", 2)
end)

local function createAimbot(fov)
    cleanupCurrentAimbot()
    
    local Cam = Workspace.CurrentCamera
    
    currentFOVring = Drawing.new("Circle")
    currentFOVring.Visible = true
    currentFOVring.Thickness = 1
    currentFOVring.NumSides = 64
    currentFOVring.Filled = false
    currentFOVring.Radius = fov
    currentFOVring.Position = Cam.ViewportSize / 2
    
    local function updateDrawings()
        local camViewportSize = Cam.ViewportSize
        currentFOVring.Position = camViewportSize / 2
        rainbowHue = (rainbowHue + 0.02) % 1
        currentFOVring.Color = Color3.fromHSV(rainbowHue, 1, 1)
    end
    
    local function onKeyDown(input)
        if input.KeyCode == Enum.KeyCode.Delete then
            cleanupCurrentAimbot()
        end
    end
    
    currentInputConnection = UserInputService.InputBegan:Connect(onKeyDown)
    
    local function lookAt(target)
        local lookVector = (target - Cam.CFrame.Position).unit
        local newCFrame = CFrame.new(Cam.CFrame.Position, Cam.CFrame.Position + lookVector)
        Cam.CFrame = newCFrame
    end
    
    local function getClosestPlayerInFOV(trg_part)
        local nearest = nil
        local last = math.huge
        local playerMousePos = Cam.ViewportSize / 2
    
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= Player then
                local part = player.Character and player.Character:FindFirstChild(trg_part)
                if part then
                    local ePos, isVisible = Cam:WorldToViewportPoint(part.Position)
                    local distance = (Vector2.new(ePos.x, ePos.y) - playerMousePos).Magnitude
    
                    if distance < last and isVisible and distance < fov then
                        last = distance
                        nearest = player
                    end
                end
            end
        end
        return nearest
    end
    
    currentAimbotConnection = RunService.RenderStepped:Connect(function()
        updateDrawings()
        local closest = getClosestPlayerInFOV("Head")
        if closest and closest.Character and closest.Character:FindFirstChild("Head") then
            lookAt(closest.Character.Head.Position)
        end
    end)
end

local aimPresets = {10, 30, 50, 100, 200, 300, 400, 1600}
local aimNames = {"10", "30", "50", "100", "200", "300", "400", "全屏"}
for i, fov in ipairs(aimPresets) do
    aimSection3:Button("自瞄" .. aimNames[i], function()
        createAimbot(fov)
        SendNotif("自瞄", "已开启自瞄: " .. aimNames[i], 1.5)
    end)
end

-- ============================================================
-- 标签页27: ESP
-- ============================================================
local ESPTab = win:Tab("『ESP』", '114514')
local espSection = ESPTab:section("『ESP』", true)
espSection:Button("人物透视+名字", function()
    local function ApplyESP(v)
        if v.Character and v.Character:FindFirstChildOfClass('Humanoid') then
            v.Character.Humanoid.NameDisplayDistance = 9e9
            v.Character.Humanoid.NameOcclusion = "NoOcclusion"
            v.Character.Humanoid.HealthDisplayDistance = 9e9
            v.Character.Humanoid.HealthDisplayType = "AlwaysOn"
        end
    end
    for i,v in pairs(game.Players:GetPlayers()) do
        ApplyESP(v)
        v.CharacterAdded:Connect(function()
            task.wait(0.33)
            ApplyESP(v)
        end)
    end
    
    game.Players.PlayerAdded:Connect(function(v)
        ApplyESP(v)
        v.CharacterAdded:Connect(function()
            task.wait(0.33)
            ApplyESP(v)
        end)
    end)
    
    local Players = game:GetService("Players"):GetChildren()
    local highlight = Instance.new("Highlight")
    highlight.Name = "Highlight"
    
    for i, v in pairs(Players) do
        repeat task.wait() until v.Character
        if not v.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("Highlight") then
            local highlightClone = highlight:Clone()
            highlightClone.Adornee = v.Character
            highlightClone.Parent = v.Character:FindFirstChild("HumanoidRootPart")
            highlightClone.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlightClone.Name = "Highlight"
        end
    end
    
    game.Players.PlayerAdded:Connect(function(player)
        repeat task.wait() until player.Character
        if not player.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("Highlight") then
            local highlightClone = highlight:Clone()
            highlightClone.Adornee = player.Character
            highlightClone.Parent = player.Character:FindFirstChild("HumanoidRootPart")
            highlightClone.Name = "Highlight"
        end
    end)
    
    game.Players.PlayerRemoving:Connect(function(playerRemoved)
        playerRemoved.Character:FindFirstChild("HumanoidRootPart").Highlight:Destroy()
    end)
    
    RunService.Heartbeat:Connect(function()
        for i, v in pairs(Players) do
            repeat task.wait() until v.Character
            if not v.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("Highlight") then
                local highlightClone = highlight:Clone()
                highlightClone.Adornee = v.Character
                highlightClone.Parent = v.Character:FindFirstChild("HumanoidRootPart")
                highlightClone.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlightClone.Name = "Highlight"
                task.wait()
            end
        end
    end)
    SendNotif("ESP", "人物透视已开启", 2)
end)

-- ============================================================
-- 标签页28: 旋转
-- ============================================================
local SpinTab = win:Tab("『旋转』", '114514')
local spinSection = SpinTab:section("『旋转速度』", true)

spinSection:Button("关闭旋转", function()
    local plr = Player
    if plr.Character then
        local humRoot = plr.Character:FindFirstChild("HumanoidRootPart")
        if humRoot then
            local spinbot = humRoot:FindFirstChild("Spinbot")
            if spinbot then
                spinbot:Destroy()
            end
        end
        local humanoid = plr.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.AutoRotate = true
        end
    end
    SendNotif("旋转", "已关闭", 2)
end)

local spinSpeeds = {10, 20, 40, 50, 60, 70, 80, 90, 100, 150, 200, 250}
for _, speed in ipairs(spinSpeeds) do
    spinSection:Button("旋转" .. speed, function()
        local plr = Player
        repeat task.wait() until plr.Character
        local humRoot = plr.Character:WaitForChild("HumanoidRootPart")
        plr.Character:WaitForChild("Humanoid").AutoRotate = false
        local velocity = Instance.new("AngularVelocity")
        velocity.Attachment0 = humRoot:WaitForChild("RootAttachment")
        velocity.MaxTorque = math.huge
        velocity.AngularVelocity = Vector3.new(0, speed, 0)
        velocity.Parent = humRoot
        velocity.Name = "Spinbot"
        SendNotif("旋转", "已开启旋转: " .. speed, 1.5)
    end)
end

-- ============================================================
-- 启动通知
-- ============================================================
SendNotif("脚本中心", "欢迎使用星途综合脚本", 2)
task.wait(1)
SendNotif("脚本中心", "此脚本完全免费，共20个服务器", 2)
task.wait(1)
SendNotif("👤 欢迎", "欢迎 " .. Player.Name .. " 使用本脚本", 2.5)
task.wait(1)
SendNotif("✅", "所有功能已加载完成", 1.5)

print("✅ 星途综合脚本已加载")
print("✅ 支持30个服务器😋😋")