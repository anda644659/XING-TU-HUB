if getgenv().XingTuV3Loaded then
    return
end
getgenv().XingTuV3Loaded = true

local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "XingTuLoading"
loadingGui.IgnoreGuiInset = true
loadingGui.ResetOnSpawn = false
loadingGui.DisplayOrder = 999999
loadingGui.Parent = game:GetService("CoreGui")

local loadingBg = Instance.new("Frame")
loadingBg.Size = UDim2.new(1, 0, 1, 0)
loadingBg.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
loadingBg.BorderSizePixel = 0
loadingBg.Parent = loadingGui

local loadingTitle = Instance.new("TextLabel")
loadingTitle.Size = UDim2.new(1, 0, 0, 40)
loadingTitle.Position = UDim2.new(0, 0, 0.5, -60)
loadingTitle.BackgroundTransparency = 1
loadingTitle.Text = "星途V3"
loadingTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
loadingTitle.Font = Enum.Font.GothamBold
loadingTitle.TextSize = 36
loadingTitle.Parent = loadingBg

local loadingSub = Instance.new("TextLabel")
loadingSub.Size = UDim2.new(1, 0, 0, 24)
loadingSub.Position = UDim2.new(0, 0, 0.5, -16)
loadingSub.BackgroundTransparency = 1
loadingSub.Text = "脚本正在加载中…谢谢你使用XT脚本V3 作者星际/蒸饺"
loadingSub.TextColor3 = Color3.fromRGB(180, 180, 190)
loadingSub.Font = Enum.Font.Gotham
loadingSub.TextSize = 16
loadingSub.Parent = loadingBg

local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0, 400, 0, 8)
barBg.Position = UDim2.new(0.5, -200, 0.5, 30)
barBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
barBg.BorderSizePixel = 0
barBg.Parent = loadingBg
Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
barFill.BorderSizePixel = 0
barFill.Parent = barBg
Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

local percentLabel = Instance.new("TextLabel")
percentLabel.Size = UDim2.new(0, 400, 0, 20)
percentLabel.Position = UDim2.new(0.5, -200, 0.5, 45)
percentLabel.BackgroundTransparency = 1
percentLabel.Text = "0%"
percentLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
percentLabel.Font = Enum.Font.Gotham
percentLabel.TextSize = 14
percentLabel.Parent = loadingBg

task.spawn(function()
    for i = 0, 100 do
        barFill.Size = UDim2.new(i / 100, 0, 1, 0)
        percentLabel.Text = i .. "%"
        task.wait(0.03)
    end
    task.wait(0.3)
    loadingGui:Destroy()
end)

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

task.spawn(function()
    task.wait(2)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "星途V3 加载成功",
            Text = "作者：星际 + 蒸饺\nQQ群：1020592687",
            Duration = 5,
        })
    end)
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera
local mouse = player:GetMouse()

if not isfolder("XA-Hub") then makefolder("XA-Hub") end
if not isfolder("XA-Hub/Music") then makefolder("XA-Hub/Music") end

local Window = Library:CreateWindow({
    Title = "星途V3",
    Footer = "v1.0",
    Icon = 95816097006870,
    ShowCustomCursor = true,
})

local Tab = Window:AddTab("通用功能", "settings")
local VisualTab = Window:AddTab("视觉功能", "eye")
local AimbotTab = Window:AddTab("自瞄功能", "crosshair")
local TriggerTab = Window:AddTab("触发功能", "zap")
local NetworkTab = Window:AddTab("网络所有权", "wifi")
local AnimTab = Window:AddTab("动画区", "play")
local MusicTab = Window:AddTab("音乐区", "music")
local DevTab = Window:AddTab("开发工具", "wrench")
local SirenTab = Window:AddTab("警笛头遗产", "skull")

local SpeedGroup = Tab:AddLeftGroupbox("人物速度")
local FlyGroup = Tab:AddRightGroupbox("飞行功能")
local JumpGroup = Tab:AddLeftGroupbox("跳跃功能")
local PlayerGroup = Tab:AddRightGroupbox("玩家选择")
local TpGroup = Tab:AddLeftGroupbox("传送功能")
local ThrowGroup = Tab:AddRightGroupbox("甩飞功能")
local SpinGroup = Tab:AddLeftGroupbox("旋转功能")
local MiscGroup = Tab:AddLeftGroupbox("杂项功能")
local ScriptGroup = Tab:AddRightGroupbox("外链脚本")

local InfoGroup = VisualTab:AddLeftGroupbox("玩家信息")
local EspGroup = VisualTab:AddRightGroupbox("透视 ESP")
local EnvGroup = VisualTab:AddLeftGroupbox("环境")

local AimGroup = AimbotTab:AddLeftGroupbox("Aimbot")
local BulletGroup = AimbotTab:AddRightGroupbox("子弹追踪")
local FovGroup = AimbotTab:AddLeftGroupbox("FOV")
local TrgBotGroup = AimbotTab:AddRightGroupbox("Trigger Bot")

local TouchGroup = TriggerTab:AddLeftGroupbox("TouchInterests")
local ClickGroup = TriggerTab:AddRightGroupbox("ClickDetectors")
local PromptGroup = TriggerTab:AddLeftGroupbox("ProximityPrompts")

local ObjGroup = NetworkTab:AddLeftGroupbox("未锚固物体")
local NpcGroup = NetworkTab:AddRightGroupbox("NPC 控制")

local PresetAnimGroup = AnimTab:AddLeftGroupbox("预设动画包")
local EmoteGroup = AnimTab:AddRightGroupbox("动画 Emotes")
local GameAnimGroup = AnimTab:AddLeftGroupbox("游戏中的动画")

local MusicLocalGroup = MusicTab:AddLeftGroupbox("本地音乐")
local MusicOnlineGroup = MusicTab:AddRightGroupbox("在线音乐")
local MusicSettingGroup = MusicTab:AddLeftGroupbox("播放器设置")

local DevToolGroup = DevTab:AddLeftGroupbox("调试工具")
local DevUtilGroup = DevTab:AddRightGroupbox("实用工具")

local SirenGroup = SirenTab:AddLeftGroupbox("警笛头")

local walkSpeed = 16
local flying = false
local flySpeed = 50
local bv, bg
local jumpPower = 50
local infiniteJump = false
local selectedPlayer = nil
local followConn = nil
local frontDistance = 5
local backDistance = 5
local headDistance = 5
local loopFlingRunning = false
local loopFlingAll = false
local flingAllThread = nil

local espEnabled = false
local noclipEnabled = false
local nightVisionEnabled = false
local antiPushEnabled = false
local autoTranslateEnabled = false
local smoothFollowEnabled = false
local followNearestEnabled = false
local aimbotEnabled = false
local lockViewEnabled = false
local crosshairEnabled = false
local crosshairSpinEnabled = false
local aimbotRadius = math.floor(Camera.ViewportSize.Y / 3)
local translateLoop = nil
local translatedTexts = {}
local speedAntiPull = nil
local noclipConn = nil
local lastGroundY = 0
local joinNotifyEnabled = false
local fullbrightEnabled = false
local noFogEnabled = false

local gunAimbotEnabled = false
local gunAimbotTarget = nil
local gunAimbotFov = 120
local gunAimbotPart = "Head"
local gunAimbotTeam = false
local gunAimbotWall = false
local gunAimbotAlive = false
local gunAimbotDist = 500
local gunAimbotSmooth = 0.4
local gunAimbotPred = 0.15
local gunAimbotMethod = "Camera"

local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1
fovCircle.Color = Color3.fromRGB(0, 150, 255)
fovCircle.Filled = false
fovCircle.Radius = 120
fovCircle.NumSides = 60
fovCircle.Transparency = 1
fovCircle.Visible = false

local function getPlayerList()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then table.insert(list, p.Name) end
    end
    if #list == 0 then list = { "无其他玩家" } end
    return list
end

local function getHRP(name)
    local p = Players:FindFirstChild(name)
    if p and p.Character then return p.Character:FindFirstChild("HumanoidRootPart") end
end

local function notify(text, title)
    StarterGui:SetCore("SendNotification", {
        Title = title or "星途V3",
        Text = text,
        Duration = 3,
    })
end

local function enableESP(p)
    if p == player then return end
    local char = p.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    if not char:FindFirstChild("EspHighlight") then
        local h = Instance.new("Highlight")
        h.Name = "EspHighlight"
        h.Parent = char
        h.FillTransparency = 1
        h.OutlineColor = Color3.fromRGB(0, 150, 255)
        h.OutlineTransparency = 0
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end
end

local function disableESP(p)
    local char = p.Character
    if char and char:FindFirstChild("EspHighlight") then char.EspHighlight:Destroy() end
end

local function stopFollow()
    if followConn then followConn:Disconnect() followConn = nil end
end

local function startFly()
    if flying then return end
    flying = true
    humanoid.PlatformStand = true
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    bv.Velocity = Vector3.zero
    bv.Parent = hrp
    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
    bg.CFrame = hrp.CFrame
    bg.Parent = hrp
end

local function stopFly()
    flying = false
    if humanoid then humanoid.PlatformStand = false end
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
    bv, bg = nil, nil
end

local function startNoclip()
    if noclipConn then noclipConn:Disconnect() end
    noclipConn = RunService.Stepped:Connect(function()
        if not noclipEnabled then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.FloorMaterial ~= Enum.Material.Air then lastGroundY = root.Position.Y end
        root.CanCollide = false
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
        end
        if lastGroundY ~= 0 and root.Position.Y < lastGroundY - 5 then
            root.CFrame = CFrame.new(root.CFrame.X, lastGroundY, root.CFrame.Z)
            if hum then hum:ChangeState(Enum.HumanoidStateType.Landed) end
        end
    end)
end

local function stopNoclip()
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    local char = player.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then root.CanCollide = true end
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") and not v.CanCollide then v.CanCollide = true end
        end
    end
end

local function clearSpin()
    local c = player.Character
    if not c then return end
    local r = c:FindFirstChild("HumanoidRootPart")
    if r then
        local s = r:FindFirstChild("Spinbot") if s then s:Destroy() end
        local av = r:FindFirstChildOfClass("AngularVelocity") if av then av:Destroy() end
    end
    local h = c:FindFirstChildOfClass("Humanoid")
    if h then h.AutoRotate = true end
end

local function applySpin(speed)
    local c = player.Character
    if not c then return end
    local r = c:WaitForChild("HumanoidRootPart")
    local h = c:FindFirstChildOfClass("Humanoid")
    if h then h.AutoRotate = false end
    local old = r:FindFirstChild("Spinbot") if old then old:Destroy() end
    local av = Instance.new("AngularVelocity")
    av.Attachment0 = r:WaitForChild("RootAttachment")
    av.MaxTorque = math.huge
    av.AngularVelocity = Vector3.new(0, speed, 0)
    av.Parent = r
    av.Name = "Spinbot"
end

local function skidFling(target)
    if not target or target == player then return end
    local tChar = target.Character
    if not tChar then return end
    local tHum = tChar:FindFirstChildOfClass("Humanoid")
    local tRoot = tHum and tHum.RootPart
    local tHead = tChar:FindFirstChild("Head")
    if not (tHum and tRoot) then return end
    if tHum.Sit then return end

    local myChar = player.Character
    local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
    local myRoot = myHum and myHum.RootPart
    if not (myHum and myRoot) then return end

    if myRoot.Velocity.Magnitude < 50 then getgenv().OldPos = myRoot.CFrame end

    local FPos = function(BasePart, Pos, Ang)
        myRoot.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
        myChar:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
        myRoot.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
        myRoot.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
    end

    local SFBasePart = function(BasePart)
        local TimeToWait = 2
        local Time = tick()
        local Angle = 0
        repeat
            if myRoot and tHum then
                if BasePart.Velocity.Magnitude < 50 then
                    Angle = Angle + 100
                    FPos(BasePart, CFrame.new(0, 1.5, 0) + tHum.MoveDirection * BasePart.Velocity.Magnitude / 0.95, CFrame.Angles(math.rad(Angle), 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, 0) + tHum.MoveDirection * BasePart.Velocity.Magnitude / 0.95, CFrame.Angles(math.rad(Angle), 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + tHum.MoveDirection * BasePart.Velocity.Magnitude / 0.95, CFrame.Angles(math.rad(Angle), 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + tHum.MoveDirection * BasePart.Velocity.Magnitude / 0.95, CFrame.Angles(math.rad(Angle), 0, 0))
                    task.wait()
                else
                    FPos(BasePart, CFrame.new(0, 1.5, tHum.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, -tHum.WalkSpeed), CFrame.Angles(0, 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, 1.5, tHum.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                    task.wait()
                end
            else break end
        until BasePart.Velocity.Magnitude > 500
            or BasePart.Parent ~= tChar
            or target.Parent ~= Players
            or tHum.Sit
            or myHum.Health <= 0
            or tick() > Time + TimeToWait
    end

    local oldFall = workspace.FallenPartsDestroyHeight
    workspace.FallenPartsDestroyHeight = -math.huge

    local bv2 = Instance.new("BodyVelocity")
    bv2.Name = "EpixVel"
    bv2.Parent = myRoot
    bv2.Velocity = Vector3.new(9e8, 9e8, 9e8)
    bv2.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    myHum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

    if tRoot and tHead then
        if (tRoot.CFrame.Position - tHead.CFrame.Position).Magnitude > 5 then SFBasePart(tHead) else SFBasePart(tRoot) end
    elseif tRoot then SFBasePart(tRoot)
    elseif tHead then SFBasePart(tHead) end

    bv2:Destroy()
    myHum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    workspace.CurrentCamera.CameraSubject = myHum

    repeat
        myRoot.CFrame = getgenv().OldPos * CFrame.new(0, 0.5, 0)
        myChar:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, 0.5, 0))
        myHum:ChangeState(Enum.HumanoidStateType.GettingUp)
        for _, x in ipairs(myChar:GetChildren()) do
            if x:IsA("BasePart") then x.Velocity = Vector3.zero x.RotVelocity = Vector3.zero end
        end
        task.wait()
    until (myRoot.Position - getgenv().OldPos.Position).Magnitude < 25

    workspace.FallenPartsDestroyHeight = oldFall
end

RunService.Heartbeat:Connect(function()
    if flying and bv and bg then
        local look = Camera.CFrame.LookVector
        bv.Velocity = look * flySpeed
        bg.CFrame = CFrame.new(hrp.Position, hrp.Position + look)
    end
end)

SirenGroup:AddButton({
    Text = "星途警笛头",
    Func = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/anda644659/XING-TU-HUB/main/XTScript"))()
    end,
})

SpeedGroup:AddSlider("WalkSpeed", {
    Text = "移动速度",
    Default = 16, Min = 0, Max = 200, Rounding = 1,
    Callback = function(v)
        walkSpeed = v
        if humanoid then humanoid.WalkSpeed = v end
    end,
})

FlyGroup:AddToggle("FlyToggle", {
    Text = "开启飞行", Default = false,
    Callback = function(state) if state then startFly() else stopFly() end end,
})

FlyGroup:AddSlider("FlySpeed", {
    Text = "飞行速度", Default = 50, Min = 10, Max = 300, Rounding = 1,
    Callback = function(v) flySpeed = v end,
})

JumpGroup:AddSlider("JumpPower", {
    Text = "跳跃高度", Default = 50, Min = 0, Max = 300, Rounding = 1,
    Callback = function(v)
        jumpPower = v
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = v
        end
    end,
})

JumpGroup:AddToggle("InfiniteJump", {
    Text = "无限跳跃", Default = false,
    Callback = function(state) infiniteJump = state end,
})

UIS.JumpRequest:Connect(function()
    if infiniteJump and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

local dropdown
dropdown = PlayerGroup:AddDropdown("PlayerSelect", {
    Text = "选择玩家", Values = getPlayerList(), Default = 1, Multi = false,
    Callback = function(value) selectedPlayer = value end,
})

local function refreshDropdown()
    if dropdown then dropdown:SetValues(getPlayerList()) end
end

Players.PlayerAdded:Connect(function() task.wait(1) refreshDropdown() end)
Players.PlayerRemoving:Connect(function() task.wait(0.5) refreshDropdown() end)

TpGroup:AddButton({
    Text = "传送到选定玩家旁边",
    Func = function()
        if not selectedPlayer or selectedPlayer == "无其他玩家" then return end
        local tHrp = getHRP(selectedPlayer)
        if tHrp and hrp then hrp.CFrame = tHrp.CFrame + Vector3.new(3, 0, 3) end
    end,
})

TpGroup:AddToggle("LockTP", {
    Text = "锁定传送", Default = false,
    Callback = function(state)
        stopFollow()
        if state and selectedPlayer and selectedPlayer ~= "无其他玩家" then
            followConn = RunService.Heartbeat:Connect(function()
                local tHrp = getHRP(selectedPlayer)
                if tHrp and hrp then hrp.CFrame = tHrp.CFrame + Vector3.new(3, 0, 3) end
            end)
        end
    end,
})

TpGroup:AddButton({
    Text = "把玩家传送过来",
    Func = function()
        if not selectedPlayer or selectedPlayer == "无其他玩家" then return end
        local tHrp = getHRP(selectedPlayer)
        if tHrp and hrp then tHrp.CFrame = hrp.CFrame + Vector3.new(3, 0, 3) end
    end,
})

TpGroup:AddToggle("LoopTP", {
    Text = "循环把玩家传送过来", Default = false,
    Callback = function(state)
        stopFollow()
        if state and selectedPlayer and selectedPlayer ~= "无其他玩家" then
            followConn = RunService.Heartbeat:Connect(function()
                local tHrp = getHRP(selectedPlayer)
                if tHrp and hrp then tHrp.CFrame = hrp.CFrame + Vector3.new(3, 0, 3) end
            end)
        end
    end,
})

TpGroup:AddSlider("FrontDistance", {
    Text = "传送前方距离", Default = 5, Min = 1, Max = 50, Rounding = 1,
    Callback = function(v) frontDistance = v end,
})

TpGroup:AddToggle("LoopFrontTP", {
    Text = "循环传送至玩家前方", Default = false,
    Callback = function(state)
        stopFollow()
        if state and selectedPlayer and selectedPlayer ~= "无其他玩家" then
            followConn = RunService.Heartbeat:Connect(function()
                local tHrp = getHRP(selectedPlayer)
                if tHrp and hrp then
                    local frontPos = tHrp.CFrame.Position + tHrp.CFrame.LookVector * frontDistance
                    hrp.CFrame = CFrame.new(frontPos)
                end
            end)
        end
    end,
})

TpGroup:AddSlider("HeadDistance", {
    Text = "传送头顶距离", Default = 5, Min = 1, Max = 50, Rounding = 1,
    Callback = function(v) headDistance = v end,
})

TpGroup:AddToggle("LoopHeadTP", {
    Text = "循环传送至玩家头顶", Default = false,
    Callback = function(state)
        stopFollow()
        if state and selectedPlayer and selectedPlayer ~= "无其他玩家" then
            followConn = RunService.Heartbeat:Connect(function()
                local tHrp = getHRP(selectedPlayer)
                if tHrp and hrp then
                    local p = tHrp.Position
                    hrp.CFrame = CFrame.new(p.X, p.Y + headDistance, p.Z)
                end
            end)
        end
    end,
})

TpGroup:AddSlider("BackDistance", {
    Text = "传送后方距离", Default = 5, Min = 1, Max = 50, Rounding = 1,
    Callback = function(v) backDistance = v end,
})

TpGroup:AddToggle("LoopBackTP", {
    Text = "循环传送至玩家后面", Default = false,
    Callback = function(state)
        stopFollow()
        if state and selectedPlayer and selectedPlayer ~= "无其他玩家" then
            followConn = RunService.Heartbeat:Connect(function()
                local tHrp = getHRP(selectedPlayer)
                if tHrp and hrp then
                    local backPos = tHrp.CFrame.Position - tHrp.CFrame.LookVector * backDistance
                    hrp.CFrame = CFrame.new(backPos)
                end
            end)
        end
    end,
})

local backBoneDistance = 3.5
local noDizzyEnabled = false

TpGroup:AddSlider("BackBoneDist", {
    Text = "贴背距离",
    Default = 3.5, Min = 0, Max = 20, Rounding = 0.1,
    Callback = function(v) backBoneDistance = v end,
})

local function getBackBone(target)
    local char = target.Character
    if not char then return nil end
    return char:FindFirstChild("UpperTorso")
        or char:FindFirstChild("Torso")
        or char:FindFirstChild("HumanoidRootPart")
end

local function setSelfNoCollide()
    local char = player.Character
    if not char then return end
    for _, v in ipairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
            v.Massless = true
        end
    end
end

getgenv().XT_InstantBack = false

local function snapToBack(target)
    local bone = getBackBone(target)
    if not bone or not hrp then return end
    local backPos = bone.CFrame.Position - bone.CFrame.LookVector * backBoneDistance
    hrp.CFrame = CFrame.new(backPos, bone.CFrame.Position)
    hrp.Velocity = Vector3.zero
    hrp.RotVelocity = Vector3.zero
    if noDizzyEnabled then
        local dir = bone.CFrame.LookVector
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + Vector3.new(dir.X, 0, dir.Z))
    end
    setSelfNoCollide()
end

TpGroup:AddButton({
    Text = "瞬移贴背",
    Func = function()
        if not selectedPlayer or selectedPlayer == "无其他玩家" then return end
        local target = Players:FindFirstChild(selectedPlayer)
        if target then snapToBack(target) end
    end,
})

EspGroup:AddToggle("NoDizzy", {
    Text = "无眩晕", Default = false,
    Callback = function(state) noDizzyEnabled = state end,
})

TpGroup:AddToggle("InstantBackTP", {
    Text = "死死贴背",
    Default = false,
    Callback = function(state)
        getgenv().XT_InstantBack = state
        if state then
            noDizzyEnabled = true
        end
        stopFollow()
        if state and selectedPlayer and selectedPlayer ~= "无其他玩家" then
            followConn = RunService.RenderStepped:Connect(function()
                local target = Players:FindFirstChild(selectedPlayer)
                if target and target.Character then
                    snapToBack(target)
                end
            end)
        end
    end,
})

task.spawn(function()
    while true do
        task.wait(0.2)
        if getgenv().XT_InstantBack then
            local char = player.Character
            if char then
                for _, v in ipairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                        v.Massless = true
                    end
                end
            end
        end
    end
end)

RunService:BindToRenderStep("XT_NoDizzyCam", Enum.RenderPriority.Camera.Value + 2, function()
    if not getgenv().XT_InstantBack then return end
    if not noDizzyEnabled then return end
    local target = Players:FindFirstChild(selectedPlayer)
    if not target or not target.Character then return end
    local bone = getBackBone(target)
    if not bone then return end
    local dir = bone.CFrame.LookVector
    Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + Vector3.new(dir.X, 0, dir.Z))
end)

player.CharacterAdded:Connect(function()
    task.wait(0.5)
    if getgenv().XT_InstantBack then
        setSelfNoCollide()
        noDizzyEnabled = true
    end
end)

if humanoid then
    humanoid.Died:Connect(function()
        task.wait(0.1)
        if getgenv().XT_InstantBack then
            setSelfNoCollide()
        end
    end)
end

ThrowGroup:AddButton({
    Text = "甩飞一次选中的人",
    Func = function()
        if not selectedPlayer or selectedPlayer == "无其他玩家" then return end
        local target = Players:FindFirstChild(selectedPlayer)
        if target then skidFling(target) end
    end,
})

ThrowGroup:AddToggle("LoopFling", {
    Text = "锁定甩飞选中的人", Default = false,
    Callback = function(state)
        loopFlingRunning = state
        if not state then return end
        task.spawn(function()
            while loopFlingRunning do
                if selectedPlayer and selectedPlayer ~= "无其他玩家" then
                    local target = Players:FindFirstChild(selectedPlayer)
                    if target and target.Character then skidFling(target) end
                end
                task.wait(0.1)
            end
        end)
    end,
})

ThrowGroup:AddButton({
    Text = "甩飞所有人",
    Func = function()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player then skidFling(p) end
        end
    end,
})

ThrowGroup:AddToggle("LoopFlingAll", {
    Text = "锁定甩飞所有人", Default = false,
    Callback = function(state)
        loopFlingAll = state
        if not state then
            if flingAllThread then task.cancel(flingAllThread) flingAllThread = nil end
            return
        end
        flingAllThread = task.spawn(function()
            while loopFlingAll do
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player and p.Character then
                        local h = p.Character:FindFirstChildOfClass("Humanoid")
                        if h and h.Health > 0 and not h.Sit then
                            task.spawn(function() skidFling(p) end)
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    end,
})

ThrowGroup:AddButton({
    Text = "关闭所有人的甩飞",
    Func = function()
        loopFlingAll = false
        loopFlingRunning = false
        if flingAllThread then task.cancel(flingAllThread) flingAllThread = nil end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local c = p.Character
                local h = c:FindFirstChildOfClass("Humanoid")
                local r = h and h.RootPart
                for _, part in ipairs(c:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                        part.CustomPhysicalProperties = nil
                    end
                end
                if r then
                    local av = r:FindFirstChildOfClass("AngularVelocity")
                    if av then av:Destroy() end
                    local epix = r:FindFirstChild("EpixVel")
                    if epix then epix:Destroy() end
                end
                if h then
                    h.PlatformStand = false
                    h:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                    h:ChangeState(Enum.HumanoidStateType.GettingUp)
                end
            end
        end
    end,
})

SpinGroup:AddButton({ Text = "关闭旋转", Func = clearSpin })

for _, spd in ipairs({ 10, 20, 40, 50, 60, 70, 80, 90, 100, 150, 200, 250 }) do
    SpinGroup:AddButton({ Text = "旋转" .. spd, Func = function() applySpin(spd) end })
end

MiscGroup:AddToggle("AutoTranslate", {
    Text = "自动翻译", Default = false,
    Callback = function(state)
        autoTranslateEnabled = state
        if state then
            if translateLoop then return end
            translateLoop = true
            task.spawn(function()
                while translateLoop and autoTranslateEnabled do
                    local pg = player:FindFirstChild("PlayerGui")
                    if pg then
                        for _, obj in ipairs(pg:GetDescendants()) do
                            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                                local ok, err = pcall(function()
                                    local text = obj.Text
                                    if text and #text > 1 then
                                        local en, total = 0, 0
                                        for char in text:gmatch(".") do
                                            local byte = string.byte(char)
                                            if byte then
                                                total = total + 1
                                                if (byte >= 65 and byte <= 90) or (byte >= 97 and byte <= 122) then en = en + 1 end
                                            end
                                        end
                                        if total > 0 and (en / total) > 0.5 then
                                            if translatedTexts[text] then
                                                obj.Text = translatedTexts[text]
                                            else
                                                local url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=zh-CN&dt=t&q=" .. HttpService:UrlEncode(text)
                                                local res = game:HttpGet(url)
                                                local decoded = HttpService:JSONDecode(res)
                                                if decoded and decoded[1] and decoded[1][1] and decoded[1][1][1] then
                                                    translatedTexts[text] = decoded[1][1][1]
                                                    obj.Text = decoded[1][1][1]
                                                end
                                            end
                                        end
                                    end
                                end)
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end)
        else
            translateLoop = false
        end
    end,
})

MiscGroup:AddToggle("FollowNearest", {
    Text = "跟随最近玩家", Default = false,
    Callback = function(state) followNearestEnabled = state end,
})

MiscGroup:AddToggle("SmoothFollow", {
    Text = "平滑跟随", Default = false,
    Callback = function(state) smoothFollowEnabled = state end,
})

MiscGroup:AddButton({
    Text = "传送最近玩家",
    Func = function()
        local myChar = player.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        local nearest, minDist = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (p.Character.HumanoidRootPart.Position - myRoot.Position).Magnitude
                if dist < minDist then minDist = dist nearest = p end
            end
        end
        if nearest then myRoot.CFrame = nearest.Character.HumanoidRootPart.CFrame + Vector3.new(0, 0, 3) end
    end,
})

MiscGroup:AddButton({
    Text = "传送到指定玩家",
    Func = function()
        if not selectedPlayer or selectedPlayer == "无其他玩家" then return end
        local tHrp = getHRP(selectedPlayer)
        if tHrp and hrp then hrp.CFrame = tHrp.CFrame + Vector3.new(0, 0, 3) end
    end,
})

MiscGroup:AddButton({
    Text = "美化包排行榜第一",
    Func = function()
        local ls = player:FindFirstChild("leaderstats")
        if ls then
            for _, stat in ipairs(ls:GetChildren()) do
                if stat:IsA("IntValue") or stat:IsA("NumberValue") then stat.Value = 999 end
            end
        end
        local st = player:FindFirstChild("Stats") or player:FindFirstChild("stats")
        if st then
            for _, v in ipairs(st:GetChildren()) do
                if v:IsA("IntValue") or v:IsA("NumberValue") then v.Value = 999 end
            end
        end
    end,
})

MiscGroup:AddButton({
    Text = "偷取道具",
    Func = function()
        local myBackpack = player:FindFirstChild("Backpack")
        if not myBackpack then
            myBackpack = Instance.new("Backpack")
            myBackpack.Parent = player
        end
        for _, tp in ipairs(Players:GetPlayers()) do
            if tp ~= player and tp.Character then
                local containers = {
                    tp:FindFirstChild("Backpack"),
                    tp:FindFirstChild("Inventory"),
                    tp:FindFirstChild("Storage"),
                    tp:FindFirstChild("Bag"),
                    tp.Character:FindFirstChild("Backpack"),
                }
                for _, c in ipairs(containers) do
                    if c then
                        for _, item in ipairs(c:GetChildren()) do
                            if item:IsA("Tool") or item:IsA("Model") or item:IsA("Part") or item:IsA("Accessory") then
                                pcall(function() item.Parent = myBackpack end)
                                task.wait(0.1)
                            end
                        end
                    end
                end
            end
        end
    end,
})

MiscGroup:AddButton({
    Text = "查询坐标传送",
    Func = function()
        local pos = hrp and hrp.Position
        if pos then
            notify(string.format("当前坐标: %.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z), "坐标")
            pcall(function() setclipboard(string.format("%.1f,%.1f,%.1f", pos.X, pos.Y, pos.Z)) end)
        end
    end,
})

MiscGroup:AddToggle("JoinNotify", {
    Text = "玩家进入通知", Default = false,
    Callback = function(state)
        joinNotifyEnabled = state
        if state then notify("已开启玩家进入通知", "玩家进入") end
    end,
})

MiscGroup:AddSlider("Gravity", {
    Text = "重力设置", Default = workspace.Gravity, Min = 1, Max = 2000, Rounding = 1,
    Callback = function(v) workspace.Gravity = v end,
})

MiscGroup:AddButton({
    Text = "重置重力 (196.2)",
    Func = function()
        workspace.Gravity = 196.2
        notify("重力已重置为 196.2", "重力")
    end,
})

local function onPlayerAdded(p)
    if not joinNotifyEnabled then return end
    if p == player then return end
    notify(p.Name .. " 加入了游戏", "玩家进入")
end

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= player then onPlayerAdded(p) end
end

Players.PlayerAdded:Connect(function(p)
    task.wait(0.5)
    onPlayerAdded(p)
end)

InfoGroup:AddLabel("用户名：" .. player.Name)
InfoGroup:AddLabel("昵称：" .. player.DisplayName)
InfoGroup:AddLabel("UserId：" .. player.UserId)
InfoGroup:AddLabel("账号年龄：" .. player.AccountAge .. " 天")
InfoGroup:AddLabel("执行器：" .. (identifyexecutor and identifyexecutor() or "未知"))
InfoGroup:AddLabel("服务器ID：" .. game.JobId)
InfoGroup:AddLabel("PlaceId：" .. game.PlaceId)
local playersLabel = InfoGroup:AddLabel("当前玩家数：加载中")
local pingLabel = InfoGroup:AddLabel("延迟：加载中")

task.spawn(function()
    while true do
        task.wait(1)
        playersLabel:Set("当前玩家数：" .. #Players:GetPlayers() .. " / " .. Players.MaxPlayers)
        local ps = Stats:FindFirstChild("PerformanceStats")
        if ps and ps:FindFirstChild("Ping") then
            pingLabel:Set("延迟：" .. math.round(ps.Ping:GetValue()) .. " ms")
        end
    end
end)

EspGroup:AddToggle("ESP", {
    Text = "透视 ESP", Default = false,
    Callback = function(state)
        espEnabled = state
        if state then
            for _, p in ipairs(Players:GetPlayers()) do enableESP(p) end
        else
            for _, p in ipairs(Players:GetPlayers()) do disableESP(p) end
        end
    end,
})

EspGroup:AddToggle("Noclip", {
    Text = "穿墙", Default = false,
    Callback = function(state)
        noclipEnabled = state
        if state then startNoclip() else stopNoclip() end
    end,
})

EspGroup:AddToggle("NightVision", {
    Text = "夜视", Default = false,
    Callback = function(state)
        nightVisionEnabled = state
        if state then
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
            Lighting.ColorShift_Top = Color3.new(1, 1, 1)
            Lighting.FogEnd = 100000
            Lighting.FogStart = 100000
            Lighting.Brightness = 1
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
            Lighting.ClockTime = 12
        else
            Lighting.Ambient = Color3.new(0, 0, 0)
            Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
            Lighting.ColorShift_Top = Color3.new(0, 0, 0)
            Lighting.FogEnd = 1000
            Lighting.FogStart = 0
            Lighting.Brightness = 1
            Lighting.GlobalShadows = true
            Lighting.OutdoorAmbient = Color3.new(0.7, 0.7, 0.7)
        end
    end,
})

EspGroup:AddToggle("AntiPush", {
    Text = "防甩飞", Default = false,
    Callback = function(state)
        antiPushEnabled = state
        if not state then
            local char = player.Character
            if char then
                for _, v in ipairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = true end
                end
            end
        end
    end,
})

EspGroup:AddToggle("LockView", {
    Text = "锁定视角", Default = false,
    Callback = function(state) lockViewEnabled = state end,
})

EspGroup:AddToggle("Crosshair", {
    Text = "准星", Default = false,
    Callback = function(state) crosshairEnabled = state end,
})

EspGroup:AddToggle("CrosshairSpin", {
    Text = "准星旋转", Default = false,
    Callback = function(state) crosshairSpinEnabled = state end,
})

EnvGroup:AddToggle("Fullbright", {
    Text = "高亮", Default = false,
    Callback = function(state)
        fullbrightEnabled = state
        if state then
            Lighting.Ambient = Color3.new(1, 1, 1)
        else
            Lighting.Ambient = Color3.new(0, 0, 0)
        end
        for _, v in ipairs(Lighting:GetDescendants()) do
            if v:IsA("PostEffect") then v.Enabled = not state end
        end
    end,
})

EnvGroup:AddToggle("NoFog", {
    Text = "去除雾", Default = false,
    Callback = function(state)
        noFogEnabled = state
        if state then
            Lighting.FogEnd = 100000
            for _, v in ipairs(Lighting:GetDescendants()) do
                if v:IsA("Atmosphere") then v:Destroy() end
            end
        else
            Lighting.FogEnd = 1000
        end
    end,
})

EnvGroup:AddToggle("NoShadow", {
    Text = "去除阴影", Default = false,
    Callback = function(state) Lighting.GlobalShadows = not state end,
})

local aimbotFlags = {
    Enabled = false,
    FovPos = "准星",
    LockMethod = "相机",
    AimPart = "Head",
    TeamCheck = false,
    WallCheck = false,
    AliveCheck = false,
    MaxDistance = 500,
    Smoothness = 0.4,
    Prediction = 0.15,
    Targets = { Players = true, NPCs = false },
    FacingAim = false,
}

local aimbotTarget = nil

local function getAimbotTarget()
    local closest = nil
    local closestDist = math.huge
    local getMouseLoc
    if aimbotFlags.FovPos == "准星" then
        getMouseLoc = Camera.ViewportSize / 2
    else
        getMouseLoc = UIS:GetMouseLocation()
    end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local part = p.Character:FindFirstChild(aimbotFlags.AimPart == "随机" and "Head" or aimbotFlags.AimPart)
            if part then
                if not aimbotFlags.AliveCheck or (p.Character:FindFirstChildOfClass("Humanoid") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0) then
                    if not aimbotFlags.TeamCheck or p.Team ~= player.Team then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                        if onScreen then
                            local dist
                            if aimbotFlags.LockMethod == "相机" then
                                dist = (part.Position - Camera.CFrame.Position).Magnitude
                            else
                                dist = (getMouseLoc - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                            end
                            if dist < closestDist and (not aimbotFlags.WallCheck or true) then
                                closestDist = dist
                                closest = part
                            end
                        end
                    end
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if not aimbotEnabled then
        fovCircle.Visible = false
        return
    end
    fovCircle.Visible = true
    fovCircle.Position = (aimbotFlags.FovPos == "准星") and (Camera.ViewportSize / 2) or UIS:GetMouseLocation()
    fovCircle.Radius = gunAimbotFov

    aimbotTarget = getAimbotTarget()
    if aimbotTarget then
        local targetPos = aimbotTarget.Position + aimbotTarget.Velocity * aimbotFlags.Prediction
        local camPos = Camera.CFrame.Position
        if aimbotFlags.LockMethod == "相机" then
            local targetCf = CFrame.lookAt(camPos, camPos + (targetPos - camPos).Unit)
            Camera.CFrame = Camera.CFrame:Lerp(targetCf, aimbotFlags.Smoothness)
        end
        if aimbotFlags.FacingAim and hrp then
            hrp.CFrame = CFrame.new(hrp.Position, aimbotTarget.Position)
        end
    end
end)

AimGroup:AddToggle("Aimbot", {
    Text = "自瞄", Default = false,
    Callback = function(state) aimbotEnabled = state end,
})

AimGroup:AddSlider("AimbotRadius", {
    Text = "自瞄半径", Default = 120, Min = 50, Max = math.floor(Camera.ViewportSize.Y * 0.8), Rounding = 1,
    Callback = function(v) gunAimbotFov = v end,
})

AimGroup:AddDropdown("AimPart", {
    Text = "瞄准部位", Values = { "Head", "HumanoidRootPart" }, Default = 1, Multi = false,
    Callback = function(v) aimbotFlags.AimPart = v end,
})

AimGroup:AddSlider("MaxDist", {
    Text = "最大距离", Default = 500, Min = 50, Max = 2000, Rounding = 1,
    Callback = function(v) aimbotFlags.MaxDistance = v end,
})

AimGroup:AddSlider("Smooth", {
    Text = "平滑度", Default = 0.4, Min = 0, Max = 1, Rounding = 0.01,
    Callback = function(v) aimbotFlags.Smoothness = v end,
})

AimGroup:AddToggle("TeamCheck", {
    Text = "队伍检查", Default = false,
    Callback = function(state) aimbotFlags.TeamCheck = state end,
})

AimGroup:AddToggle("FacingAim", {
    Text = "朝向自瞄目标", Default = false,
    Callback = function(state) aimbotFlags.FacingAim = state end,
})

FovGroup:AddToggle("FovToggle", {
    Text = "显示 FOV 圈", Default = false,
    Callback = function(state) fovCircle.Visible = state end,
})

FovGroup:AddSlider("FovRadius", {
    Text = "FOV 大小", Default = 120, Min = 20, Max = 400, Rounding = 1,
    Callback = function(v) fovCircle.Radius = v end,
})

TrgBotGroup:AddToggle("TriggerBot", {
    Text = "Trigger Bot", Default = false,
    Callback = function(state)
        task.spawn(function()
            while state do
                task.wait(0.05)
                if mouse.Target and mouse.Target.Parent then
                    local targetModel = mouse.Target:FindFirstAncestorOfClass("Model")
                    if targetModel and Players:GetPlayerFromCharacter(targetModel) then
                        local h = targetModel:FindFirstChildOfClass("Humanoid")
                        if h and h.Health > 0 then
                            pcall(function()
                                local vim = game:GetService("VirtualInputManager")
                                vim:SendMouseButtonEvent(mouse.X, mouse.Y, 0, true, game, 0)
                                task.wait(0.02)
                                vim:SendMouseButtonEvent(mouse.X, mouse.Y, 0, false, game, 0)
                            end)
                        end
                    end
                end
            end
        end)
    end,
})

TouchGroup:AddButton({
    Text = "触发所有 TouchInterests",
    Func = function()
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("TouchTransmitter") then
                pcall(function()
                    firetouchinterest(v.Parent, hrp, 0)
                    firetouchinterest(v.Parent, hrp, 1)
                end)
            end
        end
    end,
})

TouchGroup:AddToggle("AutoFireTouch", {
    Text = "自动触发 TouchInterest", Default = false,
    Callback = function(state)
        task.spawn(function()
            while state do
                task.wait(0.1)
                for _, v in ipairs(workspace:GetDescendants()) do
                    if v:IsA("TouchTransmitter") and v.Parent then
                        pcall(function()
                            firetouchinterest(v.Parent, hrp, 0)
                            firetouchinterest(v.Parent, hrp, 1)
                        end)
                    end
                end
            end
        end)
    end,
})

ClickGroup:AddButton({
    Text = "触发所有 ClickDetectors",
    Func = function()
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ClickDetector") then
                pcall(function() fireclickdetector(v) end)
            end
        end
    end,
})

ClickGroup:AddToggle("AutoFireClick", {
    Text = "自动触发 ClickDetector", Default = false,
    Callback = function(state)
        task.spawn(function()
            while state do
                task.wait(0.1)
                for _, v in ipairs(workspace:GetDescendants()) do
                    if v:IsA("ClickDetector") then
                        pcall(function() fireclickdetector(v) end)
                    end
                end
            end
        end)
    end,
})

PromptGroup:AddButton({
    Text = "触发所有 ProximityPrompts",
    Func = function()
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                pcall(function() fireproximityprompt(v) end)
            end
        end
    end,
})

PromptGroup:AddToggle("AutoInteract", {
    Text = "自动互动 (ProximityPrompt)", Default = false,
    Callback = function(state)
        task.spawn(function()
            while state do
                task.wait(0.15)
                for _, v in ipairs(workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") then
                        pcall(function() fireproximityprompt(v) end)
                    end
                end
            end
        end)
    end,
})

PromptGroup:AddButton({
    Text = "设置所有交互距离",
    Func = function()
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                pcall(function() v.MaxActivationDistance = 32 end)
            end
        end
    end,
})

local unanchoredParts = {}
task.spawn(function()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v.Anchored then table.insert(unanchoredParts, v) end
    end
end)

workspace.DescendantAdded:Connect(function(d)
    if d:IsA("BasePart") and not d.Anchored then table.insert(unanchoredParts, d) end
end)

local function isNetworkOwner(part)
    if not part then return false end
    if not part:IsGrounded() and not part.Anchored and part.ReceiveAge == 0 then
        return true
    end
    return false
end

ObjGroup:AddButton({
    Text = "传送未锚固物体至自己",
    Func = function()
        for _, v in ipairs(unanchoredParts) do
            if v.Parent and v ~= hrp and isNetworkOwner(v) then
                v.CFrame = hrp.CFrame
            end
        end
    end,
})

ObjGroup:AddButton({
    Text = "用未锚固物体甩飞选定玩家",
    Func = function()
        if not selectedPlayer or selectedPlayer == "无其他玩家" then return end
        local target = Players:FindFirstChild(selectedPlayer)
        if not target or not target.Character then return end
        local targetHrp = target.Character:FindFirstChild("HumanoidRootPart")
        if not targetHrp then return end
        for _, v in ipairs(unanchoredParts) do
            if v.Parent and isNetworkOwner(v) and v.CanCollide then
                v.CFrame = targetHrp.CFrame
                v.Velocity = Vector3.new(0, 1000000, 0)
                break
            end
        end
    end,
})

ObjGroup:AddButton({
    Text = "传送未锚固物体给选定玩家",
    Func = function()
        if not selectedPlayer or selectedPlayer == "无其他玩家" then return end
        local target = Players:FindFirstChild(selectedPlayer)
        if not target or not target.Character then return end
        local targetHrp = target.Character:FindFirstChild("HumanoidRootPart")
        if not targetHrp then return end
        for _, v in ipairs(unanchoredParts) do
            if v.Parent and v ~= hrp and isNetworkOwner(v) then
                v.CFrame = targetHrp.CFrame
            end
        end
    end,
})

local selectedNpc = nil
local selectedNpcPart = nil
local npcHighlight = Instance.new("Highlight", CoreGui)
npcHighlight.FillTransparency = 1
npcHighlight.OutlineColor = Color3.fromRGB(0, 255, 0)
npcHighlight.Adornee = nil

mouse.Button1Down:Connect(function()
    if not mouse.Target then return end
    local model = mouse.Target:FindFirstAncestorOfClass("Model")
    if model and model:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(model) then
        selectedNpc = model
        selectedNpcPart = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
        npcHighlight.Adornee = model
    end
end)

NpcGroup:AddButton({
    Text = "杀死选中的 NPC",
    Func = function()
        if selectedNpc and selectedNpcPart and isNetworkOwner(selectedNpcPart) then
            local h = selectedNpc:FindFirstChildOfClass("Humanoid")
            if h then h.Health = 0 end
        end
    end,
})

NpcGroup:AddButton({
    Text = "带来选中的 NPC",
    Func = function()
        if selectedNpc and selectedNpcPart and isNetworkOwner(selectedNpcPart) then
            selectedNpc:PivotTo(hrp.CFrame)
        end
    end,
})

NpcGroup:AddButton({
    Text = "传送至选中的 NPC",
    Func = function()
        if selectedNpc then
            character:PivotTo(selectedNpc:GetPivot())
        end
    end,
})

NpcGroup:AddButton({
    Text = "甩飞选中的 NPC",
    Func = function()
        if selectedNpc and selectedNpcPart and isNetworkOwner(selectedNpcPart) then
            selectedNpcPart.Velocity = Vector3.new(9e9, 9e9, 9e9)
        end
    end,
})

NpcGroup:AddButton({
    Text = "让选中的 NPC 跳",
    Func = function()
        if selectedNpc and selectedNpcPart and isNetworkOwner(selectedNpcPart) then
            local h = selectedNpc:FindFirstChildOfClass("Humanoid")
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end,
})

local presetAnims = {
    ["Vampire"] = {idle="1083445855", idle2="1083450166", walk="1083473930", run="1083462077", jump="1083455352", climb="1083439238", fall="1083443587"},
    ["Hero"] = {idle="616111295", idle2="616113536", walk="616122287", run="616117076", jump="616115533", climb="616104706", fall="616108001"},
    ["Zombie"] = {idle="616158929", idle2="616160636", walk="616168032", run="616163682", jump="616161997", climb="616156119", fall="616157476"},
    ["Mage"] = {idle="707742142", idle2="707855907", walk="707897309", run="707861613", jump="707853694", climb="707826056", fall="707829716"},
    ["Ghost"] = {idle="616006778", idle2="616008087", walk="616010382", run="616013216", jump="616008936", climb="616003713", fall="616005863"},
    ["Elder"] = {idle="845397899", idle2="845400520", walk="845403856", run="845386501", jump="845398858", climb="845392038", fall="845396048"},
    ["Astronaut"] = {idle="891621366", idle2="891633237", walk="891667138", run="891636393", jump="891627522", climb="891609353", fall="891617961"},
    ["Ninja"] = {idle="656117400", idle2="656118341", walk="656121766", run="656118852", jump="656117878", climb="656114359", fall="656115606"},
    ["Werewolf"] = {idle="1083195517", idle2="1083214717", walk="1083178339", run="1083216690", jump="1083218792", climb="1083182000", fall="1083189019"},
    ["Cartoon"] = {idle="742637544", idle2="742638445", walk="742640026", run="742638842", jump="742637942", climb="742636889", fall="742637151"},
    ["Pirate"] = {idle="750781874", idle2="750782770", walk="750785693", run="750783738", jump="750782230", climb="750779899", fall="750780242"},
    ["Sneaky"] = {idle="1132473842", idle2="1132477671", walk="1132510133", run="1132494274", jump="1132489853", climb="1132461372", fall="1132469004"},
    ["Toy"] = {idle="782841498", idle2="782845736", walk="782843345", run="782842708", jump="782847020", climb="782843869", fall="782846423"},
    ["Knight"] = {idle="657595757", idle2="657568135", walk="657552124", run="657564596", jump="658409194", climb="658360781", fall="657600338"},
    ["Confident"] = {idle="1069977950", idle2="1069987858", walk="1070017263", run="1070001516", jump="1069984524", climb="1069946257", fall="1069973677"},
    ["Popstar"] = {idle="1212900985", idle2="1212900985", walk="1212980338", run="1212980348", jump="1212954642", climb="1213044953", fall="1212900995"},
    ["Princess"] = {idle="941003647", idle2="941013098", walk="941028902", run="941015281", jump="941008832", climb="940996062", fall="941000007"},
    ["Cowboy"] = {idle="1014390418", idle2="1014398616", walk="1014421541", run="1014401683", jump="1014394726", climb="1014380606", fall="1014384571"},
    ["Patrol"] = {idle="1149612882", idle2="1150842221", walk="1151231493", run="1150967949", jump="1150944216", climb="1148811837", fall="1148863382"},
}

local function applyPresetAnim(name)
    local data = presetAnims[name]
    if not data then return end
    local c = player.Character
    if not c then return end
    local animate = c:FindFirstChild("Animate")
    if not animate then return end

    animate.Disabled = true
    for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
        track:Stop()
    end

    local function setId(obj, id)
        if obj then obj.AnimationId = "http://www.roblox.com/asset/?id=" .. id end
    end

    setId(animate.idle and animate.idle.Animation1, data.idle)
    setId(animate.idle and animate.idle.Animation2, data.idle2)
    setId(animate.walk and animate.walk.WalkAnim, data.walk)
    setId(animate.run and animate.run.RunAnim, data.run)
    setId(animate.jump and animate.jump.JumpAnim, data.jump)
    setId(animate.climb and animate.climb.ClimbAnim, data.climb)
    setId(animate.fall and animate.fall.FallAnim, data.fall)

    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    animate.Disabled = false
    notify("已切换到动画包：" .. name, "动画")
end

for name, _ in pairs(presetAnims) do
    PresetAnimGroup:AddButton({
        Text = name,
        Func = function() applyPresetAnim(name) end,
    })
end

local animId = nil

EmoteGroup:AddInput("AnimInput", {
    Text = "输入动画 ID",
    Default = "",
    Placeholder = "动画 ID 或链接",
    Callback = function(text)
        if string.match(text, "id=(%d+)") then
            animId = text
        elseif not text:find("rbxassetid://") then
            animId = "rbxassetid://" .. text
        else
            animId = text
        end
    end,
})

EmoteGroup:AddButton({
    Text = "播放动画",
    Func = function()
        if not animId then return notify("请先输入动画 ID", "动画") end
        local a = Instance.new("Animation")
        a.AnimationId = animId
        local track = humanoid:LoadAnimation(a)
        track:Play()
    end,
})

EmoteGroup:AddButton({
    Text = "停止所有动画",
    Func = function()
        for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
        end
    end,
})

local gameAnimations = {}

GameAnimGroup:AddButton({
    Text = "刷新动画列表",
    Func = function()
        gameAnimations = {}
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("Animation") then
                gameAnimations[v.Name] = v
            end
        end
        notify("已刷新动画列表，共 " .. tostring(#game:GetDescendants()) .. " 个对象", "动画")
    end,
})

GameAnimGroup:AddInput("GameAnimId", {
    Text = "输入动画名称并播放",
    Default = "",
    Placeholder = "动画名称",
    Callback = function(text)
        local anim = gameAnimations[text]
        if anim then
            local track = humanoid:LoadAnimation(anim)
            track:Play()
        end
    end,
})

local musicGui = Instance.new("ScreenGui")
musicGui.Name = "XingTuMusic"
musicGui.ResetOnSpawn = false
musicGui.IgnoreGuiInset = true
musicGui.DisplayOrder = 999998
musicGui.Parent = CoreGui

local musicMain = Instance.new("Frame")
musicMain.Size = UDim2.new(0, 500, 0, 300)
musicMain.Position = UDim2.new(0, 172, 0, 7)
musicMain.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
musicMain.BorderSizePixel = 0
musicMain.Active = true
musicMain.Visible = false
musicMain.Parent = musicGui
Instance.new("UICorner", musicMain).CornerRadius = UDim.new(0, 10)

local dragDet = Instance.new("UIDragDetector", musicMain)

local musicBottom = Instance.new("Frame")
musicBottom.Size = UDim2.new(1, 0, 0, 62)
musicBottom.Position = UDim2.new(0, 0, 1, 0)
musicBottom.AnchorPoint = Vector2.new(0, 1)
musicBottom.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
musicBottom.BorderSizePixel = 0
musicBottom.Parent = musicMain
Instance.new("UICorner", musicBottom).CornerRadius = UDim.new(0, 10)

local songNameLbl = Instance.new("TextLabel")
songNameLbl.Size = UDim2.new(0, 86, 0, 18)
songNameLbl.Position = UDim2.new(0, 10, 0, 7)
songNameLbl.BackgroundTransparency = 1
songNameLbl.Text = "歌曲名称"
songNameLbl.TextSize = 13
songNameLbl.TextXAlignment = Enum.TextXAlignment.Left
songNameLbl.TextColor3 = Color3.fromRGB(220, 220, 225)
songNameLbl.Font = Enum.Font.Gotham
songNameLbl.Parent = musicBottom

local singerLbl = Instance.new("TextLabel")
singerLbl.Size = UDim2.new(0, 78, 0, 14)
singerLbl.Position = UDim2.new(0, 10, 0, 27)
singerLbl.BackgroundTransparency = 1
singerLbl.Text = "歌手"
singerLbl.TextSize = 10
singerLbl.TextXAlignment = Enum.TextXAlignment.Left
singerLbl.TextColor3 = Color3.fromRGB(160, 160, 170)
singerLbl.Font = Enum.Font.Gotham
singerLbl.Parent = musicBottom

local timeLbl = Instance.new("TextLabel")
timeLbl.Size = UDim2.new(0.2, 0, 0.3, 0)
timeLbl.Position = UDim2.new(0, 390, 0, 10)
timeLbl.BackgroundTransparency = 1
timeLbl.Text = "00:00/00:00"
timeLbl.TextSize = 10
timeLbl.TextColor3 = Color3.fromRGB(200, 200, 210)
timeLbl.Font = Enum.Font.Gotham
timeLbl.Parent = musicBottom

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(1, 0, 0, 4)
progressBar.Position = UDim2.new(0, 0, 0, 50)
progressBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
progressBar.BorderSizePixel = 0
progressBar.Active = true
progressBar.Parent = musicBottom

local progressFill = Instance.new("Frame")
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
progressFill.BorderSizePixel = 0
progressFill.Parent = progressBar

local progressCircle = Instance.new("Frame")
progressCircle.Size = UDim2.new(0, 10, 0, 10)
progressCircle.AnchorPoint = Vector2.new(1, 0.5)
progressCircle.Position = UDim2.new(1, 0, 0.5, 0)
progressCircle.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
progressCircle.BorderSizePixel = 0
progressCircle.ZIndex = 2
progressCircle.Parent = progressFill
Instance.new("UICorner", progressCircle).CornerRadius = UDim.new(1, 0)

local function makeMusicBtn(parent, image, xPos, size)
    local btn = Instance.new("ImageButton")
    btn.BackgroundTransparency = 1
    btn.Image = image
    btn.ImageColor3 = Color3.fromRGB(220, 220, 225)
    btn.AnchorPoint = Vector2.new(0.5, 0.5)
    btn.Size = UDim2.new(0, size, 0, size)
    btn.Position = UDim2.new(0.5, xPos, 0.5, 5)
    btn.Parent = parent
    return btn
end

local playBtn = makeMusicBtn(musicBottom, "rbxassetid://129543182573744", 0, 40)
local prevBtn = makeMusicBtn(musicBottom, "rbxassetid://114138954917019", -50, 25)
local nextBtn = makeMusicBtn(musicBottom, "rbxassetid://128554058391470", 50, 25)
local likeBtn = makeMusicBtn(musicBottom, "rbxassetid://122940095996865", -100, 25)
local loopBtn = makeMusicBtn(musicBottom, "rbxassetid://116146140475722", 100, 25)

local toggleLyricBtn = Instance.new("TextButton")
toggleLyricBtn.Size = UDim2.new(0, 30, 0, 30)
toggleLyricBtn.Position = UDim2.new(0, 450, 0, 27)
toggleLyricBtn.BackgroundTransparency = 1
toggleLyricBtn.Text = "∧"
toggleLyricBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
toggleLyricBtn.Font = Enum.Font.GothamBold
toggleLyricBtn.TextSize = 18
toggleLyricBtn.Parent = musicBottom

local musicTitle = Instance.new("TextLabel")
musicTitle.Size = UDim2.new(0, 96, 0, 24)
musicTitle.Position = UDim2.new(0, 6, 0, 5)
musicTitle.BackgroundTransparency = 1
musicTitle.Text = "网易云音乐"
musicTitle.TextColor3 = Color3.fromRGB(220, 220, 225)
musicTitle.Font = Enum.Font.GothamBold
musicTitle.TextSize = 15
musicTitle.Parent = musicMain

local closeMusicBtn = Instance.new("ImageButton")
closeMusicBtn.Size = UDim2.new(0, 18, 0, 18)
closeMusicBtn.Position = UDim2.new(0.95, 0, 0, 10)
closeMusicBtn.BackgroundTransparency = 1
closeMusicBtn.Image = "rbxassetid://137161637202736"
closeMusicBtn.ImageColor3 = Color3.fromRGB(220, 220, 225)
closeMusicBtn.Parent = musicMain

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(0, 130, 0, 22)
searchBox.Position = UDim2.new(0.62, 0, 0, 10)
searchBox.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
searchBox.BorderSizePixel = 0
searchBox.TextColor3 = Color3.fromRGB(230, 230, 235)
searchBox.PlaceholderText = "搜索..."
searchBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 130)
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 12
searchBox.Text = ""
searchBox.Parent = musicMain
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 6)

local pages = Instance.new("Frame")
pages.Size = UDim2.new(1, 0, 0.67, 0)
pages.Position = UDim2.new(0, 0, 1, -62)
pages.AnchorPoint = Vector2.new(0, 1)
pages.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
pages.BorderSizePixel = 0
pages.Parent = musicMain

local leftFrame = Instance.new("ScrollingFrame")
leftFrame.Size = UDim2.new(0, 98, 1, 0)
leftFrame.Position = UDim2.new(0, 0, 1, 0)
leftFrame.AnchorPoint = Vector2.new(0, 1)
leftFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
leftFrame.BorderSizePixel = 0
leftFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
leftFrame.ScrollBarThickness = 1
leftFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
leftFrame.Parent = pages

local leftLayout = Instance.new("UIListLayout", leftFrame)
leftLayout.Padding = UDim.new(0.005, 0)

local contents = Instance.new("Frame")
contents.Size = UDim2.new(1, 0, 0.67, 0)
contents.Position = UDim2.new(0, 0, 1, -62)
contents.AnchorPoint = Vector2.new(0, 1)
contents.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
contents.BorderSizePixel = 0
contents.Visible = false
contents.Parent = musicMain

local songList = Instance.new("ScrollingFrame")
songList.Size = UDim2.new(0.25, 0, 1, 0)
songList.Position = UDim2.new(0, 0, 1, 0)
songList.AnchorPoint = Vector2.new(0, 1)
songList.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
songList.BorderSizePixel = 0
songList.AutomaticCanvasSize = Enum.AutomaticSize.Y
songList.ScrollBarThickness = 1
songList.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
songList.Parent = contents

local songListLayout = Instance.new("UIListLayout", songList)
songListLayout.Padding = UDim.new(0.005, 0)

local lyricsBox = Instance.new("ScrollingFrame")
lyricsBox.Size = UDim2.new(0.75, 0, 1, 0)
lyricsBox.Position = UDim2.new(1, 0, 0, 0)
lyricsBox.AnchorPoint = Vector2.new(1, 0)
lyricsBox.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
lyricsBox.BorderSizePixel = 0
lyricsBox.AutomaticCanvasSize = Enum.AutomaticSize.Y
lyricsBox.ScrollBarThickness = 3
lyricsBox.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
lyricsBox.Parent = contents

local lyricsLayout = Instance.new("UIListLayout", lyricsBox)
lyricsLayout.Padding = UDim.new(0.005, 0)
lyricsLayout.SortOrder = Enum.SortOrder.LayoutOrder

local musicState = {
    Self = nil,
    IsPlaying = false,
    LoopPlay = false,
    CurrentIndex = 1,
    Current = "首页",
    Lyrics = nil,
    CurrentLabel = nil,
}

local function getTimeStr(sec)
    local m = math.floor(sec / 60)
    return string.format("%02d:%02d", m, sec % 60)
end

local function makeSongBtn(parent, name, singer, duration, onClick)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.Parent = parent
    btn.AutoButtonColor = true

    local numLbl = Instance.new("TextLabel", btn)
    numLbl.Size = UDim2.new(0, 10, 1, 0)
    numLbl.Position = UDim2.new(0, 10, 0, 0)
    numLbl.BackgroundTransparency = 1
    numLbl.TextSize = 11
    numLbl.Text = ""
    numLbl.TextColor3 = Color3.fromRGB(180, 180, 190)
    numLbl.TextXAlignment = Enum.TextXAlignment.Left

    local nameLbl = Instance.new("TextLabel", btn)
    nameLbl.Size = UDim2.new(0.5, 0, 1, 0)
    nameLbl.Position = UDim2.new(0, 25, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.TextSize = 11
    nameLbl.Text = name
    nameLbl.TextColor3 = Color3.fromRGB(220, 220, 225)
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.TextTruncate = Enum.TextTruncate.AtEnd

    local timeLbl2 = Instance.new("TextLabel", btn)
    timeLbl2.Size = UDim2.new(0, 40, 1, 0)
    timeLbl2.Position = UDim2.new(1, -45, 0, 0)
    timeLbl2.BackgroundTransparency = 1
    timeLbl2.TextSize = 10
    timeLbl2.Text = duration
    timeLbl2.TextColor3 = Color3.fromRGB(160, 160, 170)
    timeLbl2.TextXAlignment = Enum.TextXAlignment.Right

    btn.MouseButton1Click:Connect(function()
        nameLbl.TextColor3 = Color3.fromRGB(0, 180, 255)
        onClick()
    end)

    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55) end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(38, 38, 46) end)

    return btn
end

local function clearLyrics()
    for _, v in ipairs(lyricsBox:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
end

local function parseLyrics(text)
    clearLyrics()
    local list = {}
    local iter = text:gmatch("%[(%d+):(%d+%.?%d*)%](.-)\n")
    local m, s, t = iter()
    while m do
        table.insert(list, {time = tonumber(m) * 60 + tonumber(s), text = t})
        m, s, t = iter()
    end
    table.sort(list, function(a, b) return a.time < b.time end)
    musicState.Lyrics = list

    for i, line in ipairs(list) do
        local lbl = Instance.new("TextButton", lyricsBox)
        lbl.Size = UDim2.new(1, 0, 0, 22)
        lbl.BackgroundTransparency = 1
        lbl.Text = line.text
        lbl.TextColor3 = Color3.fromRGB(120, 120, 130)
        lbl.TextSize = 13
        lbl.Font = Enum.Font.Gotham
        lbl.LayoutOrder = i
        lbl.TextWrapped = true
        lbl.MouseButton1Click:Connect(function()
            if musicState.Self then musicState.Self.TimePosition = line.time end
        end)
    end
end

local favoriteList = {}
if isfile("XA-Hub/Music/FavoriteList.json") then
    pcall(function() favoriteList = HttpService:JSONDecode(readfile("XA-Hub/Music/FavoriteList.json")) end)
end

local function saveFavorites()
    pcall(function()
        writefile("XA-Hub/Music/FavoriteList.json", HttpService:JSONEncode(favoriteList))
    end)
end

local function playMusic(soundId, name, singer)
    for _, v in ipairs(SoundService:GetChildren()) do
        if v:IsA("Sound") then v:Stop() v:Destroy() end
    end

    local sound = Instance.new("Sound")
    sound.Name = name or "music"
    sound.SoundId = soundId
    sound.Volume = 0.5
    sound.Looped = musicState.LoopPlay
    sound.Parent = SoundService
    sound:Play()

    sound.Ended:Connect(function()
        sound:Destroy()
        if not musicState.LoopPlay then
            local list = musicState[musicState.Current]
            if list and #list > 0 then
                local nextIdx = musicState.CurrentIndex + 1
                if nextIdx > #list then nextIdx = 1 end
                if list[nextIdx] and list[nextIdx].Play then
                    list[nextIdx].Play()
                end
            end
        end
    end)

    sound.Loaded:Wait()

    musicState.Self = sound
    musicState.IsPlaying = true
    playBtn.Image = "rbxassetid://79730020141529"
    songNameLbl.Text = (name or "未知"):gsub("%.mp3", "")
    singerLbl.Text = singer or "未知"

    likeBtn.Image = favoriteList[name] and "rbxassetid://81577006040798" or "rbxassetid://122940095996865"

    local lrcFile = "XA-Hub/Music/" .. (name or ""):gsub("%.mp3", ".lrc")
    if isfile(lrcFile) then
        pcall(function() parseLyrics(readfile(lrcFile)) end)
    else
        parseLyrics("[00:00.000]暂无歌词\n")
    end

    notify("正在播放：" .. (name or "") .. "\n时长：" .. getTimeStr(sound.TimeLength), "音乐")
end

local currentTabs = {}

local function createTab(name, isFirst)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextSize = 12
    btn.TextColor3 = Color3.fromRGB(220, 220, 225)
    btn.Font = Enum.Font.Gotham
    btn.Parent = leftFrame

    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(1, -98, 1, 0)
    frame.Position = UDim2.new(0, 98, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
    frame.BorderSizePixel = 0
    frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    frame.ScrollBarThickness = 3
    frame.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
    frame.Visible = false
    frame.Parent = pages

    local layout = Instance.new("UIListLayout", frame)
    layout.Padding = UDim.new(0.005, 0)

    local function activate()
        for _, v in ipairs(leftFrame:GetChildren()) do
            if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(220, 220, 225) end
        end
        btn.TextColor3 = Color3.fromRGB(0, 180, 255)
        for _, v in ipairs(pages:GetChildren()) do
            if v:IsA("ScrollingFrame") then v.Visible = false end
        end
        frame.Visible = true
        musicState.Current = name
    end

    btn.MouseButton1Click:Connect(activate)
    if isFirst then activate() end

    currentTabs[name] = frame
    return frame
end

local homeTab = createTab("首页", true)
local favTab = createTab("我喜欢的")
musicState["首页"] = {}
musicState["我喜欢的"] = {}

local function addSongToList(listFrame, listName, name, singer, duration, onClick)
    if not musicState[listName] then musicState[listName] = {} end
    local index = #musicState[listName] + 1
    musicState[listName][index] = {
        Play = onClick,
        SongName = name,
        Time = duration,
    }
    makeSongBtn(listFrame, name, singer, getTimeStr(duration), onClick)
end

local function loadFavorites()
    for _, v in ipairs(favTab:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    musicState["我喜欢的"] = {}

    for name, data in pairs(favoriteList) do
        local ok = false
        if name:match("%.mp3") then
            ok = pcall(readfile, "XA-Hub/Music/" .. name)
        else
            ok = true
        end
        if ok then
            addSongToList(favTab, "我喜欢的", name, data.Singer, data.Duration, function()
                if name:match("%.mp3") then
                    pcall(function()
                        playMusic(getcustomasset("XA-Hub/Music/" .. name), name, data.Singer)
                    end)
                else
                    playMusic(data.SoundId, name, data.Singer)
                end
            end)
        end
    end
end

loadFavorites()

local searchCount = 5

MusicOnlineGroup:AddInput("SearchCount", {
    Text = "搜索数量",
    Default = "5",
    Placeholder = "默认 5",
    Callback = function(text)
        local n = tonumber(text)
        if n then searchCount = n end
    end,
})

MusicOnlineGroup:AddButton({
    Text = "搜索网易云",
    Func = function()
        local keyword = searchBox.Text
        if not keyword or keyword == "" then return notify("请输入搜索内容", "音乐") end

        for _, v in ipairs(homeTab:GetChildren()) do
            if v:IsA("TextButton") then v:Destroy() end
        end
        musicState["首页"] = {}

        local ok, res = pcall(function()
            return game:HttpGet("https://music.163.com/api/search/get?s=" .. HttpService:UrlEncode(keyword) .. "&type=1&offset=0&total=true&limit=" .. searchCount)
        end)
        if not ok then return notify("搜索失败", "音乐") end

        local data = HttpService:JSONDecode(res)
        if data.code == 200 and data.result and data.result.songs then
            for _, song in ipairs(data.result.songs) do
                local id = song.id
                local name = song.name
                local singer = song.artists[1].name
                local dur = song.duration / 1000
                addSongToList(homeTab, "首页", name, singer, dur, function()
                    local url = "http://music.163.com/song/media/outer/url?id=" .. id
                    local ok2, resp = pcall(function() return request({Url = url, Method = "GET"}) end)
                    if ok2 and resp and resp.Body and #resp.Body > 100 then
                        local fname = name:gsub("[\\/:*?\"<>|]", "_") .. ".mp3"
                        pcall(function()
                            writefile("XA-Hub/Music/" .. fname, resp.Body)
                        end)
                        pcall(function()
                            local lrcUrl = "https://music.163.com/api/song/media?id=" .. id
                            local lrcRes = HttpService:JSONDecode(game:HttpGet(lrcUrl))
                            if lrcRes and lrcRes.lyric then
                                writefile("XA-Hub/Music/" .. fname:gsub(".mp3", ".lrc"), lrcRes.lyric)
                            end
                        end)
                        task.wait(0.3)
                        playMusic(getcustomasset("XA-Hub/Music/" .. fname), fname, singer)
                    else
                        notify("音乐加载失败", "音乐")
                    end
                end)
            end
            notify("搜索成功，共找到 " .. #data.result.songs .. " 首", "音乐")
        else
            notify("搜索失败，状态码 " .. tostring(data.code), "音乐")
        end
    end,
})

MusicLocalGroup:AddButton({
    Text = "刷新本地音乐",
    Func = function()
        for _, v in ipairs(currentTabs["本地"] and currentTabs["本地"]:GetChildren() or {}) do
            if v:IsA("TextButton") then v:Destroy() end
        end
        local files = listfiles("XA-Hub/Music")
        for _, f in ipairs(files) do
            if f:match("%.mp3$") then
                local fname = f:match("([^/]+)$")
                notify("发现本地音乐：" .. fname, "音乐")
            end
        end
    end,
})

MusicSettingGroup:AddSlider("Volume", {
    Text = "音量", Default = 0.5, Min = 0, Max = 1, Rounding = 0.01,
    Callback = function(v)
        for _, s in ipairs(SoundService:GetChildren()) do
            if s:IsA("Sound") then s.Volume = v end
        end
    end,
})

MusicSettingGroup:AddSlider("Speed", {
    Text = "播放速度", Default = 1, Min = 0.1, Max = 5, Rounding = 0.05,
    Callback = function(v)
        for _, s in ipairs(SoundService:GetChildren()) do
            if s:IsA("Sound") then s.PlaybackSpeed = v end
        end
    end,
})

MusicSettingGroup:AddToggle("ShowPlayer", {
    Text = "显示播放器窗口", Default = false,
    Callback = function(state) musicMain.Visible = state end,
})

closeMusicBtn.MouseButton1Click:Connect(function() musicMain.Visible = false end)

playBtn.MouseButton1Click:Connect(function()
    musicState.IsPlaying = not musicState.IsPlaying
    playBtn.Image = musicState.IsPlaying and "rbxassetid://79730020141529" or "rbxassetid://129543182573744"
    for _, v in ipairs(SoundService:GetChildren()) do
        if v:IsA("Sound") then v.Playing = musicState.IsPlaying end
    end
end)

loopBtn.MouseButton1Click:Connect(function()
    musicState.LoopPlay = not musicState.LoopPlay
    loopBtn.Image = musicState.LoopPlay and "rbxassetid://127031857777656" or "rbxassetid://116146140475722"
    for _, v in ipairs(SoundService:GetChildren()) do
        if v:IsA("Sound") then v.Looped = musicState.LoopPlay end
    end
end)

nextBtn.MouseButton1Click:Connect(function()
    local list = musicState[musicState.Current]
    if not list or #list == 0 then return end
    local nextIdx = musicState.CurrentIndex + 1
    if nextIdx > #list then nextIdx = 1 end
    if list[nextIdx] and list[nextIdx].Play then
        musicState.CurrentIndex = nextIdx
        list[nextIdx].Play()
    end
end)

prevBtn.MouseButton1Click:Connect(function()
    local list = musicState[musicState.Current]
    if not list or #list == 0 then return end
    local prevIdx = musicState.CurrentIndex - 1
    if prevIdx < 1 then prevIdx = #list end
    if list[prevIdx] and list[prevIdx].Play then
        musicState.CurrentIndex = prevIdx
        list[prevIdx].Play()
    end
end)

likeBtn.MouseButton1Click:Connect(function()
    if not musicState.Self then return end
    local name = musicState.Self.Name
    if favoriteList[name] then
        favoriteList[name] = nil
        likeBtn.Image = "rbxassetid://122940095996865"
    else
        favoriteList[name] = {
            Singer = singerLbl.Text,
            Duration = musicState.Self.TimeLength,
            SoundId = musicState.Self.SoundId,
        }
        likeBtn.Image = "rbxassetid://81577006040798"
    end
    saveFavorites()
    loadFavorites()
end)

toggleLyricBtn.MouseButton1Click:Connect(function()
    pages.Visible = not pages.Visible
    contents.Visible = not contents.Visible
    toggleLyricBtn.Text = pages.Visible and "∧" or "∨"
end)

RunService.RenderStepped:Connect(function()
    if musicState.IsPlaying and musicState.Self then
        local s = musicState.Self
        timeLbl.Text = getTimeStr(s.TimePosition) .. "/" .. getTimeStr(s.TimeLength)
        if s.TimeLength > 0 then
            progressFill.Size = UDim2.new(s.TimePosition / s.TimeLength, 0, 1, 0)
        end

        if musicState.Lyrics then
            local tp = s.TimePosition
            for i = #musicState.Lyrics, 1, -1 do
                if tp >= musicState.Lyrics[i].time then
                    for _, lbl in ipairs(lyricsBox:GetChildren()) do
                        if lbl:IsA("TextButton") then
                            lbl.TextColor3 = Color3.fromRGB(120, 120, 130)
                        end
                    end
                    local cur = lyricsBox:FindFirstChild("Line_" .. i)
                    if not cur then
                        local children = lyricsBox:GetChildren()
                        local sorted = {}
                        for _, c in ipairs(children) do
                            if c:IsA("TextButton") then table.insert(sorted, c) end
                        end
                        table.sort(sorted, function(a, b) return a.LayoutOrder < b.LayoutOrder end)
                        cur = sorted[i]
                    end
                    if cur then
                        cur.TextColor3 = Color3.fromRGB(0, 180, 255)
                        musicState.CurrentLabel = cur
                    end
                    break
                end
            end
        end
    end
end)

DevToolGroup:AddButton({
    Text = "反挂机",
    Func = function()
        pcall(function()
            for _, c in pairs(getconnections(player.Idled)) do
                if c.Disable then c:Disable()
                elseif c.Disconnect then c:Disconnect() end
            end
        end)
    end,
})

DevToolGroup:AddButton({
    Text = "防踢（客户端）",
    Func = function()
        pcall(function()
            local oldNC
            oldNC = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if self == player and method:lower() == "kick" then
                    notify("已拦截踢出", "防踢")
                    return
                end
                return oldNC(self, ...)
            end))
        end)
    end,
})

DevToolGroup:AddToggle("PingWarn", {
    Text = "掉线警告", Default = false,
    Callback = function(state)
        if state then
            task.spawn(function()
                local lastPing = tick()
                while state do
                    task.wait(1)
                    local ps = Stats:FindFirstChild("PerformanceStats")
                    if ps and ps:FindFirstChild("Ping") then
                        lastPing = tick()
                    elseif tick() - lastPing > 5 then
                        notify("您可能已经掉线", "警告")
                        lastPing = tick() + 999
                    end
                end
            end)
        end
    end,
})

DevToolGroup:AddToggle("ShowFPS", {
    Text = "显示 FPS", Default = false,
    Callback = function(state)
        if state then
            local fpsGui = Instance.new("ScreenGui", CoreGui)
            fpsGui.Name = "XTFpsGui"
            local lbl = Instance.new("TextLabel", fpsGui)
            lbl.Size = UDim2.new(0, 130, 0, 30)
            lbl.Position = UDim2.new(0.78, 0, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.TextColor3 = Color3.fromRGB(220, 220, 225)
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 14
            lbl.Text = "FPS: 0"
            local frames = 0
            RunService.RenderStepped:Connect(function(dt)
                frames = frames + 1
                if frames >= 10 then
                    lbl.Text = "FPS: " .. math.floor(1 / dt)
                    frames = 0
                end
            end)
        else
            local g = CoreGui:FindFirstChild("XTFpsGui")
            if g then g:Destroy() end
        end
    end,
})

DevUtilGroup:AddButton({
    Text = "反挂机",
    Func = function()
        for _, c in pairs(getconnections(player.Idled)) do
            if c.Disable then c:Disable() elseif c.Disconnect then c:Disconnect() end
        end
    end,
})

DevUtilGroup:AddButton({
    Text = "重新加入服务器",
    Func = function()
        TeleportService:Teleport(game.PlaceId, player)
    end,
})

DevUtilGroup:AddButton({
    Text = "复制当前服务器脚本",
    Func = function()
        setclipboard(string.format(
            "game:GetService(\"TeleportService\"):TeleportToPlaceInstance(%d, \"%s\", game:GetService(\"Players\").LocalPlayer)",
            game.PlaceId, game.JobId
        ))
        notify("已复制到剪贴板", "工具")
    end,
})

DevUtilGroup:AddButton({
    Text = "打开 Console",
    Func = function() StarterGui:SetCore("DevConsoleVisible", true) end,
})

DevUtilGroup:AddButton({
    Text = "最高 FPS",
    Func = function()
        pcall(function() setfpscap(120) end)
    end,
})

DevUtilGroup:AddButton({
    Text = "退出游戏",
    Func = function() game:Shutdown() end,
})

local savedCFrame = nil

DevUtilGroup:AddButton({
    Text = "保存当前位置",
    Func = function()
        savedCFrame = hrp.CFrame
        notify("已保存当前位置", "工具")
    end,
})

DevUtilGroup:AddButton({
    Text = "传送至保存位置",
    Func = function()
        if savedCFrame then
            character:PivotTo(savedCFrame)
        else
            notify("请先保存位置", "工具")
        end
    end,
})

RunService.Stepped:Connect(function()
    if antiPushEnabled then
        local char = player.Character
        if char then
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                end
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if smoothFollowEnabled then
        local myChar = player.Character
        if myChar then
            local myRoot = myChar:FindFirstChild("HumanoidRootPart")
            if myRoot then
                local nearest, minDist = nil, math.huge
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (p.Character.HumanoidRootPart.Position - myRoot.Position).Magnitude
                        if dist < minDist then minDist = dist nearest = p end
                    end
                end
                if nearest then
                    local tRoot = nearest.Character.HumanoidRootPart
                    local offset = tRoot.CFrame.LookVector * -2.5
                    myRoot.CFrame = CFrame.new(tRoot.Position + offset, tRoot.Position)
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        if followNearestEnabled then
            local myChar = player.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myRoot then
                local nearest, minDist = nil, math.huge
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (p.Character.HumanoidRootPart.Position - myRoot.Position).Magnitude
                        if dist < minDist then minDist = dist nearest = p end
                    end
                end
                if nearest then
                    myRoot.CFrame = nearest.Character.HumanoidRootPart.CFrame + Vector3.new(0, 0, 3)
                end
            end
        end
        task.wait(0.1)
    end
end)

RunService:BindToRenderStep("LockView", Enum.RenderPriority.Camera.Value + 1, function()
    if not lockViewEnabled then return end
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local camDir = Camera.CFrame.LookVector
    local flatDir = Vector3.new(camDir.X, 0, camDir.Z)
    if flatDir.Magnitude > 0.01 then
        root.CFrame = CFrame.new(root.Position, root.Position + flatDir)
    end
end)

local CrosshairGui = Instance.new("ScreenGui")
CrosshairGui.Name = "CrosshairGui"
CrosshairGui.Parent = player:WaitForChild("PlayerGui")
CrosshairGui.ResetOnSpawn = false
CrosshairGui.IgnoreGuiInset = true

local CrosshairFrame = Instance.new("Frame")
CrosshairFrame.Name = "Crosshair"
CrosshairFrame.Parent = CrosshairGui
CrosshairFrame.Size = UDim2.new(0, 30, 0, 30)
CrosshairFrame.Position = UDim2.new(0.5, -15, 0.5, -15)
CrosshairFrame.BackgroundTransparency = 1
CrosshairFrame.Visible = false

local hLine = Instance.new("Frame")
hLine.Parent = CrosshairFrame
hLine.Size = UDim2.new(1, 0, 0, 2)
hLine.Position = UDim2.new(0, 0, 0.5, -1)
hLine.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
hLine.BorderSizePixel = 0

local vLine = Instance.new("Frame")
vLine.Parent = CrosshairFrame
vLine.Size = UDim2.new(0, 2, 1, 0)
vLine.Position = UDim2.new(0.5, -1, 0, 0)
vLine.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
vLine.BorderSizePixel = 0

local dot = Instance.new("Frame")
dot.Parent = CrosshairFrame
dot.Size = UDim2.new(0, 6, 0, 6)
dot.Position = UDim2.new(0.5, -3, 0.5, -3)
dot.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
dot.BorderSizePixel = 0
Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

RunService.Heartbeat:Connect(function()
    if crosshairEnabled and crosshairSpinEnabled then
        CrosshairFrame.Rotation = (CrosshairFrame.Rotation + 1) % 360
    elseif crosshairEnabled and not crosshairSpinEnabled then
        CrosshairFrame.Rotation = 0
    end
    CrosshairFrame.Visible = crosshairEnabled
end)

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    hrp = newChar:WaitForChild("HumanoidRootPart")
    humanoid.WalkSpeed = walkSpeed
    humanoid.UseJumpPower = true
    humanoid.JumpPower = jumpPower
    stopFollow()
    stopFly()
    if antiPushEnabled then
        task.wait(0.5)
        for _, v in ipairs(newChar:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)