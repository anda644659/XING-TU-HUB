--开源 by 星际 

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local MarketplaceService = game:GetService("MarketplaceService")
local gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local Options = Library.Options
local Toggles = Library.Toggles
Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true
local Window = Library:CreateWindow({
    Title = "星  途🤫",
    Footer = LP.Name .. " | " .. gameName,
    NotifySide = "Right",
    ShowCustomCursor = true,
    Icon = "rbxassetid://111271260721038"
})
local Tabs = {
    ["玩家信息"] = Window:AddTab("玩家信息", "user"),
    ["透视"] = Window:AddTab("透视", "eye"),
    ["发电机"] = Window:AddTab("发电机", "zap"),
    ["玩家"] = Window:AddTab("玩家", "user"),
    ["自瞄"] = Window:AddTab("自动瞄准", "crosshair"),
    ["格挡"] = Window:AddTab("格挡", "shield"),
    ["背刺"] = Window:AddTab("背刺", "sword"),
    ["滑板"] = Window:AddTab("滑板", "zap"),
    ["动作"] = Window:AddTab("动作", "smile"),
    ["音乐"]  = Window:AddTab("音乐", "music"),
    ["其余"] = Window:AddTab("杂项", "paperclip"),
    ["界面设置"] = Window:AddTab("界面设置", "settings"),
}
local information = Tabs["玩家信息"]:AddLeftGroupbox("玩家", "user")
local avatarImage = Instance.new("ImageLabel")
avatarImage.Name = "AvatarThumbnail"
avatarImage.Size = UDim2.new(0, 220, 0, 220)
avatarImage.Position = UDim2.new(0.5, -90, 0, 10)
avatarImage.Image = "rbxassetid://0"
avatarImage.BackgroundTransparency = 1
avatarImage.BorderSizePixel = 0
avatarImage.ScaleType = Enum.ScaleType.Fit
if information.Container then
    avatarImage.Parent = information.Container
elseif information.Frame then
    avatarImage.Parent = information.Frame
else
    avatarImage.Parent = information
end
spawn(function()
    local player = LP
    if not player then repeat task.wait(0.1) player = Players.LocalPlayer until player end
    task.wait(1)
    local success, thumbnail = pcall(function()
        return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180)
    end)
    if success and thumbnail then
        avatarImage.Image = thumbnail
    else
        local alternatives = {Enum.ThumbnailType.AvatarThumbnail, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailType.Avatar}
        for i, thumbnailType in ipairs(alternatives) do
            local altSuccess, altThumbnail = pcall(function()
                return Players:GetUserThumbnailAsync(player.UserId, thumbnailType, Enum.ThumbnailSize.Size180x180)
            end)
            if altSuccess and altThumbnail then avatarImage.Image = altThumbnail break end
        end
    end
end)
information:AddLabel("执行器 : " .. identifyexecutor())
information:AddLabel("用户名 : " .. game.Players.LocalPlayer.Name)
information:AddLabel("用户ID : " .. game.Players.LocalPlayer.UserId)
information:AddLabel("显示名称 : " .. game.Players.LocalPlayer.DisplayName)
information:AddLabel("账号年龄 : " .. game.Players.LocalPlayer.AccountAge .. " 天")
local InfoGroup = Tabs["玩家信息"]:AddRightGroupbox("信息", "info")
local welcomeLabel = InfoGroup:AddLabel({Text = "欢迎使用 星途", DoesWrap = true})
task.spawn(function()
    while true do
        task.wait(0.1)
        local accentColor = ThemeManager.ThemeData.AccentColor or Color3.fromRGB(137, 180, 250)
        local fullText = '欢迎使用 <font color="#' .. string.format("%02x%02x%02x",
            math.floor(accentColor.R * 255), math.floor(accentColor.G * 255), math.floor(accentColor.B * 255)) .. '">Fixsaken</font>'
        welcomeLabel:SetText(fullText)
        if Library.Unloaded then break end
    end
end)
local CommunityGroup = Tabs["玩家信息"]:AddRightGroupbox("社区", "users")
CommunityGroup:AddButton("复制Discord链接", function()
    pcall(function()
        setclipboard("https://discord.gg/F4wrAGnRgF")
        Library:Notify({Title = "Discord", Description = "链接已复制到剪贴板", Time = 2})
    end)
end)
CommunityGroup:AddButton("QQ群", function()
    pcall(function()
        setclipboard("1058111379")
        Library:Notify({Title = "QQ", Description = "QQ号已复制到剪贴板", Time = 2})
    end)
end)

local EspLib = {}
local Camera = Workspace.CurrentCamera
local MapFolder = nil
local mapObj = Workspace:FindFirstChild("Map")
if mapObj then MapFolder = mapObj:FindFirstChild("Ingame") end
local DummyNames = {
    "PizzaDeliveryRig", "Mafiaso1", "Mafiaso2", "Builderman", "Elliot",
    "ShedletskyCORRUPT", "ChancecORRUPT", "ChanceCORRUPT", "Mafia1", "Mafia2",
    "Mafia3", "Mafia4", "Mafia5", "Mafia6", "Mafia7", "Mafia8", "Mafia9",
    "GreenGuy", "RedGuy", "BlueGuy", "PurpleGuy", "PinkGuy", "YellowGuy",
    "OrangeGuy", "GreyGuy"
}
local ObjectESPData = {}
local PlayerESPData = {}
local ESPSettings = {
    generatorESP = false, itemESP = false, pizzaEsp = false, pizzaDeliveryEsp = false,
    zombieEsp = false, taphTripwireEsp = false, tripMineEsp = false, twoTimeRespawnEsp = false,
    graffitiEsp = false,
    generatorColor = Color3.fromRGB(200, 100, 200), itemColor = Color3.fromRGB(200, 200, 0),
    pizzaColor = Color3.fromRGB(200, 150, 0), pizzaDeliveryColor = Color3.fromRGB(200, 100, 100),
    zombieColor = Color3.fromRGB(200, 100, 100), taphTripwireColor = Color3.fromRGB(100, 0, 100),
    tripMineColor = Color3.fromRGB(255, 0, 255), twoTimeRespawnColor = Color3.fromRGB(0, 150, 200),
    graffitiColor = Color3.fromRGB(255, 255, 255),
    limitDistance = false, maxDistance = 150,
    killerESP = false, playerESP = false, killerNameESP = true, survivorNameESP = true,
    killerHealthESP = true, survivorHealthESP = true, killerSkinESP = false, survivorSkinESP = false,
    killerColor = Color3.fromRGB(255, 100, 100), survivorColor = Color3.fromRGB(100, 255, 100),
    killerFillTransparency = 0.7, killerOutlineTransparency = 0.3,
    survivorFillTransparency = 0.7, survivorOutlineTransparency = 0.3,
    generatorTracers = false, itemTracers = false, pizzaTracers = false, pizzaDeliveryTracers = false,
    zombieTracers = false, taphTripwireTracers = false, tripMineTracers = false, twoTimeRespawnTracers = false,
    killerTracers = false, survivorTracers = false,
    showGeneratorName = true, showItemName = true, showPizzaName = true, showPizzaDeliveryName = true,
    showZombieName = true, showTaphTripwireName = true, showTripMineName = true, showTwoTimeRespawnName = true,
    showGraffitiName = true,
    azureGroundBulbESP = false,
    azureVineESP = false,
    azureGroundBulbColor = Color3.fromRGB(0, 255, 200),
    azureVineColor = Color3.fromRGB(200, 0, 255),
}
local function IsRagdoll(model)
    local ragdolls = Workspace:FindFirstChild("Ragdolls")
    return ragdolls and (model:IsDescendantOf(ragdolls) or model.Parent == ragdolls)
end
local function IsSpectating(player)
    if not player then return false end
    local pf = Workspace:FindFirstChild("Players")
    if not pf then return false end
    local sp = pf:FindFirstChild("Spectating")
    return sp and sp:FindFirstChild(player.Name) ~= nil
end
local function GetGeneratorPart(model)
    if not model then return nil end
    local instances = model:FindFirstChild("Instances")
    if instances then
        local generator = instances:FindFirstChild("Generator")
        if generator then
            local cube = generator:FindFirstChild("Cube.003")
            if cube and cube:IsA("BasePart") then return cube end
            for _, v in ipairs(generator:GetDescendants()) do if v:IsA("BasePart") then return v end end
        end
        for _, v in ipairs(instances:GetDescendants()) do if v:IsA("BasePart") and tostring(v.Name):lower():find("cube") then return v end end
    end
    for _, v in ipairs(model:GetDescendants()) do if v:IsA("BasePart") and v.Name:lower():find("cube") then return v end end
    for _, v in ipairs(model:GetDescendants()) do if v:IsA("BasePart") then return v end end
    return nil
end
local function createPlayerESP(model, color, isKiller)
    if model:FindFirstChild("Fixsaken_Highlight") then return end
    if IsRagdoll(model) then return end
    local hrp = model:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "Fixsaken_Highlight"
    highlight.Adornee = model
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = isKiller and ESPSettings.killerFillTransparency or ESPSettings.survivorFillTransparency
    highlight.OutlineTransparency = isKiller and ESPSettings.killerOutlineTransparency or ESPSettings.survivorOutlineTransparency
    highlight.Parent = model
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "Fixsaken_Billboard"
    billboard.Adornee = hrp
    billboard.Size = UDim2.new(0, 120, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = model
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.4, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = "加载中..."
    nameLabel.Font = Enum.Font.Jura
    nameLabel.TextColor3 = color
    nameLabel.TextSize = 8
    nameLabel.TextStrokeTransparency = 0.6
    nameLabel.Parent = billboard
    local hpLabel = Instance.new("TextLabel")
    hpLabel.Size = UDim2.new(1, 0, 0.4, 0)
    hpLabel.Position = UDim2.new(0, 0, 0.4, 0)
    hpLabel.BackgroundTransparency = 1
    hpLabel.Text = "HP: 无"
    hpLabel.Font = Enum.Font.Jura
    hpLabel.TextColor3 = color
    hpLabel.TextSize = 8
    hpLabel.TextStrokeTransparency = 0.6
    hpLabel.Parent = billboard
    local data = { model = model, nameLabel = nameLabel, hpLabel = hpLabel, isKiller = isKiller }
    table.insert(PlayerESPData, data)
    local function updateText()
        if not data.model or not data.model.Parent then return end
        local m = data.model
        local isK = data.isKiller
        local displayName = m:GetAttribute("ActorDisplayName") or (isK and "杀手" or "幸存者")
        local skinName = m:GetAttribute("SkinNameDisplay")
        local text = displayName
        if (isK and ESPSettings.killerSkinESP) or (not isK and ESPSettings.survivorSkinESP) then
            if skinName and skinName ~= "" then text = text .. " | " .. skinName end
        end
        nameLabel.Text = text
        local humanoid = m:FindFirstChild("Humanoid")
        if humanoid then
            hpLabel.Text = string.format("HP: %d/%d", math.floor(humanoid.Health), math.floor(humanoid.MaxHealth))
        end
        if highlight and highlight.Parent then
            if isK then
                highlight.FillTransparency = ESPSettings.killerFillTransparency
                highlight.OutlineTransparency = ESPSettings.killerOutlineTransparency
            else
                highlight.FillTransparency = ESPSettings.survivorFillTransparency
                highlight.OutlineTransparency = ESPSettings.survivorOutlineTransparency
            end
        end
    end
    updateText()
    model:GetAttributeChangedSignal("ActorDisplayName"):Connect(updateText)
    model:GetAttributeChangedSignal("SkinNameDisplay"):Connect(updateText)
    local humanoid = model:FindFirstChild("Humanoid")
    if humanoid then
        humanoid:GetPropertyChangedSignal("Health"):Connect(updateText)
        humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(updateText)
    end
end
local function removePlayerESP(model)
    for i = #PlayerESPData, 1, -1 do if PlayerESPData[i].model == model then table.remove(PlayerESPData, i) end end
    pcall(function()
        if model:FindFirstChild("Fixsaken_Highlight") then model.Fixsaken_Highlight:Destroy() end
        if model:FindFirstChild("Fixsaken_Billboard") then model.Fixsaken_Billboard:Destroy() end
    end)
end
local function CreateObjectESP(model, color, isGenerator, isItem, isPizza, isPizzaDelivery, isZombie, isTaph, isTripMine, isRespawn, isGraffiti, displayText)
    if not model then return end
    if model:FindFirstChild("TAOWARE_Highlight") then return end
    if isGenerator and model:FindFirstChild("Progress") and model.Progress.Value == 100 then return end
    if IsRagdoll(model) then return end
    if ESPSettings.limitDistance then
        local rootPart = model:IsA("BasePart") and model or model:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local distance = (Camera.CFrame.Position - rootPart.Position).Magnitude
            if distance > ESPSettings.maxDistance then return end
        end
    end
    local targetPart
    if isGenerator then targetPart = GetGeneratorPart(model)
    elseif isItem then targetPart = model:FindFirstChild("ItemRoot")
    elseif isPizza then targetPart = model:IsA("BasePart") and model or model:FindFirstChildWhichIsA("BasePart", true)
    elseif isPizzaDelivery then targetPart = model:IsA("BasePart") and model or model:FindFirstChildWhichIsA("BasePart", true)
    elseif isZombie then targetPart = model:IsA("BasePart") and model or model:FindFirstChildWhichIsA("BasePart", true)
    elseif isTaph then targetPart = model:IsA("Model") and (GetGeneratorPart(model) or model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)) or model
    elseif isTripMine then targetPart = model:IsA("Model") and (GetGeneratorPart(model) or model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)) or model
    elseif isRespawn then targetPart = model:IsA("Model") and (GetGeneratorPart(model) or model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)) or model
    elseif isGraffiti then targetPart = model:IsA("BasePart") and model or model:FindFirstChildWhichIsA("BasePart", true)
    else return end
    if not targetPart then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "TAOWARE_Highlight"
    highlight.Adornee = model
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0.3
    highlight.Parent = model
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "TAOWARE_Billboard"
    billboard.Adornee = targetPart
    billboard.Size = UDim2.new(0, 120, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = model
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    if displayText then
        textLabel.Text = displayText
    else
        local typeAttr = model:GetAttribute("Type")
        if typeAttr then
            textLabel.Text = typeAttr
        else
            textLabel.Text = model.Name
        end
    end
    textLabel.Font = Enum.Font.Jura
    textLabel.TextColor3 = color
    textLabel.TextSize = 8
    textLabel.TextStrokeTransparency = 0.6
    textLabel.Parent = billboard
    local espData = {model = model, highlight = highlight, billboard = billboard}
    table.insert(ObjectESPData, espData)
end
local function RemoveObjectESP(model)
    if not model then return end
    for i = #ObjectESPData, 1, -1 do if ObjectESPData[i].model == model then table.remove(ObjectESPData, i) end end
    pcall(function()
        if model:FindFirstChild("TAOWARE_Highlight") then model.TAOWARE_Highlight:Destroy() end
        if model:FindFirstChild("TAOWARE_Billboard") then model.TAOWARE_Billboard:Destroy() end
    end)
end
local function UpdateESP()
    local pf = Workspace:FindFirstChild("Players")
    if pf then
        local killersFolder = pf:FindFirstChild("Killers")
        local survivorsFolder = pf:FindFirstChild("Survivors")
        if killersFolder then
            for _, killer in ipairs(killersFolder:GetChildren()) do
                if killer == LP.Character then continue end
                if IsRagdoll(killer) then removePlayerESP(killer); continue end
                local player = Players:GetPlayerFromCharacter(killer)
                if not player or IsSpectating(player) then removePlayerESP(killer); continue end
                if ESPSettings.killerESP then
                    if not killer:FindFirstChild("Fixsaken_Highlight") then createPlayerESP(killer, ESPSettings.killerColor, true) end
                else removePlayerESP(killer) end
            end
        end
        if survivorsFolder then
            for _, survivor in ipairs(survivorsFolder:GetChildren()) do
                if survivor == LP.Character then continue end
                if IsRagdoll(survivor) then removePlayerESP(survivor); continue end
                local player = Players:GetPlayerFromCharacter(survivor)
                if not player or IsSpectating(player) then removePlayerESP(survivor); continue end
                if ESPSettings.playerESP then
                    if not survivor:FindFirstChild("Fixsaken_Highlight") then createPlayerESP(survivor, ESPSettings.survivorColor, false) end
                else removePlayerESP(survivor) end
            end
        end
    end
    if not MapFolder then return end
    local ingame = MapFolder
    if ingame:FindFirstChild("Map") then
        for _, gen in ipairs(ingame.Map:GetChildren()) do
            if gen:IsA("Model") and gen.Name:lower():find("generator") and gen.Name ~= "FakeGenerator" then
                if IsRagdoll(gen) then RemoveObjectESP(gen); continue end
                local progress = gen:FindFirstChild("Progress")
                if ESPSettings.generatorESP and progress and progress.Value < 100 and not gen:FindFirstChild("TAOWARE_Highlight") then
                    CreateObjectESP(gen, ESPSettings.generatorColor, true)
                elseif not ESPSettings.generatorESP or (progress and progress.Value >= 100) then RemoveObjectESP(gen) end
            end
        end
        for _, item in ipairs(ingame.Map:GetDescendants()) do
            if item.Name == "ItemRoot" and item.Parent and item.Parent:IsA("Model") then
                local itemModel = item.Parent
                if ESPSettings.itemESP and not itemModel:FindFirstChild("TAOWARE_Highlight") then
                    CreateObjectESP(itemModel, ESPSettings.itemColor, false, true)
                elseif not ESPSettings.itemESP then RemoveObjectESP(itemModel) end
            end
        end
    end
    for _, pizza in ipairs(ingame:GetChildren()) do
        if pizza.Name == "Pizza" and pizza:IsA("BasePart") then
            if ESPSettings.pizzaEsp and not pizza:FindFirstChild("TAOWARE_Highlight") then
                CreateObjectESP(pizza, ESPSettings.pizzaColor, false, false, true)
            elseif not ESPSettings.pizzaEsp then RemoveObjectESP(pizza) end
        end
    end
    for _, delivery in ipairs(ingame:GetChildren()) do
        if delivery:IsA("Model") and table.find(DummyNames, delivery.Name) then
            if ESPSettings.pizzaDeliveryEsp and not delivery:FindFirstChild("TAOWARE_Highlight") then
                if delivery:FindFirstChild("HumanoidRootPart") then
                    CreateObjectESP(delivery, ESPSettings.pizzaDeliveryColor, false, false, false, true)
                end
            elseif not ESPSettings.pizzaDeliveryEsp then RemoveObjectESP(delivery) end
        end
    end
    for _, zombie in ipairs(ingame:GetChildren()) do
        if zombie.Name == "1x1x1x1Zombie" and zombie:IsA("Model") then
            if ESPSettings.zombieEsp and not zombie:FindFirstChild("TAOWARE_Highlight") then
                if zombie:FindFirstChild("HumanoidRootPart") then
                    CreateObjectESP(zombie, ESPSettings.zombieColor, false, false, false, false, true)
                end
            elseif not ESPSettings.zombieEsp then RemoveObjectESP(zombie) end
        end
    end
    for _, obj in ipairs(ingame:GetChildren()) do
        if obj.Name:match("TaphTripwire$") and obj:IsA("Model") then
            if ESPSettings.taphTripwireEsp and not obj:FindFirstChild("TAOWARE_Highlight") then
                CreateObjectESP(obj, ESPSettings.taphTripwireColor, false, false, false, false, false, true)
            elseif not ESPSettings.taphTripwireEsp then RemoveObjectESP(obj) end
        end
        if obj.Name == "SubspaceTripmine" and obj:IsA("Model") then
            if ESPSettings.tripMineEsp and not obj:FindFirstChild("TAOWARE_Highlight") then
                CreateObjectESP(obj, ESPSettings.tripMineColor, false, false, false, false, false, false, true)
            elseif not ESPSettings.tripMineEsp then RemoveObjectESP(obj) end
        end
        if obj.Name == "GraffitiCL" and obj:IsA("BasePart") then
            if ESPSettings.graffitiEsp and not obj:FindFirstChild("TAOWARE_Highlight") then
                CreateObjectESP(obj, ESPSettings.graffitiColor, false, false, false, false, false, false, false, false, true)
            elseif not ESPSettings.graffitiEsp then RemoveObjectESP(obj) end
        end
    end
    for _, obj in ipairs(ingame:GetDescendants()) do
        if obj and obj.Name and tostring(obj.Name):lower():find("respawnlocation") then
            local target = obj:IsA("Model") and obj or obj:IsA("BasePart") and obj or (obj:FindFirstAncestorOfClass("Model") or obj)
            if not target or IsRagdoll(target) then continue end
            if ESPSettings.twoTimeRespawnEsp and not target:FindFirstChild("TAOWARE_Highlight") then
                CreateObjectESP(target, ESPSettings.twoTimeRespawnColor, false, false, false, false, false, false, false, true)
            elseif not ESPSettings.twoTimeRespawnEsp then RemoveObjectESP(target) end
        end
    end
    if MapFolder then
        for _, obj in ipairs(MapFolder:GetDescendants()) do
            if obj:IsA("Model") then
                local nameLower = obj.Name:lower()
                if nameLower == "groundbulbmodel" then
                    if ESPSettings.azureGroundBulbESP then
                        if not obj:FindFirstChild("TAOWARE_Highlight") then
                            CreateObjectESP(obj, ESPSettings.azureGroundBulbColor, false, false, false, false, false, false, false, false, true, "地面灯泡")
                        end
                    else
                        RemoveObjectESP(obj)
                    end
                elseif nameLower == "vinemodel" then
                    if ESPSettings.azureVineESP then
                        if not obj:FindFirstChild("TAOWARE_Highlight") then
                            CreateObjectESP(obj, ESPSettings.azureVineColor, false, false, false, false, false, false, false, false, true, "藤蔓")
                        end
                    else
                        RemoveObjectESP(obj)
                    end
                end
            end
        end
    end
end
task.spawn(function() while task.wait(0.5) do pcall(UpdateESP) end end)
function EspLib:GetSettings() return ESPSettings end
function EspLib:UpdateAllPlayerText()
    for _, d in ipairs(PlayerESPData) do
        local m = d.model
        local isK = d.isKiller
        local displayName = m:GetAttribute("ActorDisplayName") or (isK and "杀手" or "幸存者")
        local skinName = m:GetAttribute("SkinNameDisplay")
        local text = displayName
        if (isK and ESPSettings.killerSkinESP) or (not isK and ESPSettings.survivorSkinESP) then
            if skinName and skinName ~= "" then text = text .. " | " .. skinName end
        end
        d.nameLabel.Text = text
        local humanoid = m:FindFirstChild("Humanoid")
        if humanoid then
            d.hpLabel.Text = string.format("HP: %d/%d", math.floor(humanoid.Health), math.floor(humanoid.MaxHealth))
        end
    end
end
function EspLib:UpdateObjectNames() end
local KillerGroup = Tabs.透视:AddLeftGroupbox("杀手", "user")
local SurvivorGroup = Tabs.透视:AddLeftGroupbox("幸存者", "user")
local ItemGroup = Tabs.透视:AddRightGroupbox("物品", "box")
local SpecialGroup = Tabs.透视:AddRightGroupbox("特殊", "alert")
local TracerGroup = Tabs.透视:AddRightGroupbox("轨迹线", "line")
local NameToggleGroup = Tabs.透视:AddRightGroupbox("名称显示", "font")
KillerGroup:AddToggle("KillerESP", { Text = "杀手透视", Default = false, Callback = function(Value) ESPSettings.killerESP = Value end })
KillerGroup:AddToggle("KillerNameESP", { Text = "显示杀手名称", Default = true, Callback = function(Value) ESPSettings.killerNameESP = Value; EspLib:UpdateAllPlayerText() end })
KillerGroup:AddToggle("KillerHealthESP", { Text = "显示杀手生命值", Default = true, Callback = function(Value) ESPSettings.killerHealthESP = Value; EspLib:UpdateAllPlayerText() end })
KillerGroup:AddToggle("KillerSkinESP", { Text = "显示杀手皮肤", Default = false, Callback = function(Value) ESPSettings.killerSkinESP = Value; EspLib:UpdateAllPlayerText() end })
KillerGroup:AddSlider("KillerFillTransparency", { Text = "填充透明度", Default = 0.7, Min = 0, Max = 1, Rounding = 2, Compact = false, Callback = function(Value) ESPSettings.killerFillTransparency = Value; EspLib:UpdateAllPlayerText() end })
KillerGroup:AddSlider("KillerOutlineTransparency", { Text = "轮廓透明度", Default = 0.3, Min = 0, Max = 1, Rounding = 2, Compact = false, Callback = function(Value) ESPSettings.killerOutlineTransparency = Value; EspLib:UpdateAllPlayerText() end })
KillerGroup:AddLabel("杀手颜色"):AddColorPicker("KillerColor", { Default = ESPSettings.killerColor, Title = "杀手透视颜色", Callback = function(Value) ESPSettings.killerColor = Value end })
SurvivorGroup:AddToggle("SurvivorESP", { Text = "幸存者透视", Default = false, Callback = function(Value) ESPSettings.playerESP = Value end })
SurvivorGroup:AddToggle("SurvivorNameESP", { Text = "显示幸存者名称", Default = true, Callback = function(Value) ESPSettings.survivorNameESP = Value; EspLib:UpdateAllPlayerText() end })
SurvivorGroup:AddToggle("SurvivorHealthESP", { Text = "显示幸存者生命值", Default = true, Callback = function(Value) ESPSettings.survivorHealthESP = Value; EspLib:UpdateAllPlayerText() end })
SurvivorGroup:AddToggle("SurvivorSkinESP", { Text = "显示幸存者皮肤", Default = false, Callback = function(Value) ESPSettings.survivorSkinESP = Value; EspLib:UpdateAllPlayerText() end })
SurvivorGroup:AddSlider("SurvivorFillTransparency", { Text = "填充透明度", Default = 0.7, Min = 0, Max = 1, Rounding = 2, Compact = false, Callback = function(Value) ESPSettings.survivorFillTransparency = Value; EspLib:UpdateAllPlayerText() end })
SurvivorGroup:AddSlider("SurvivorOutlineTransparency", { Text = "轮廓透明度", Default = 0.3, Min = 0, Max = 1, Rounding = 2, Compact = false, Callback = function(Value) ESPSettings.survivorOutlineTransparency = Value; EspLib:UpdateAllPlayerText() end })
SurvivorGroup:AddLabel("幸存者颜色"):AddColorPicker("SurvivorColor", { Default = ESPSettings.survivorColor, Title = "幸存者透视颜色", Callback = function(Value) ESPSettings.survivorColor = Value end })
ItemGroup:AddToggle("GeneratorESP", { Text = "发电机透视", Default = false, Callback = function(Value) ESPSettings.generatorESP = Value end }):AddColorPicker("GeneratorColor", { Default = ESPSettings.generatorColor, Title = "发电机颜色", Callback = function(Value) ESPSettings.generatorColor = Value end })
ItemGroup:AddToggle("ItemESP", { Text = "物品透视", Default = false, Callback = function(Value) ESPSettings.itemESP = Value end }):AddColorPicker("ItemColor", { Default = ESPSettings.itemColor, Title = "物品颜色", Callback = function(Value) ESPSettings.itemColor = Value end })
ItemGroup:AddToggle("PizzaESP", { Text = "披萨透视", Default = false, Callback = function(Value) ESPSettings.pizzaEsp = Value end }):AddColorPicker("PizzaColor", { Default = ESPSettings.pizzaColor, Title = "披萨颜色", Callback = function(Value) ESPSettings.pizzaColor = Value end })
ItemGroup:AddToggle("TaphTripwireESP", { Text = "绊线透视", Default = false, Callback = function(Value) ESPSettings.taphTripwireEsp = Value end }):AddColorPicker("TaphTripwireColor", { Default = ESPSettings.taphTripwireColor, Title = "绊线颜色", Callback = function(Value) ESPSettings.taphTripwireColor = Value end })
ItemGroup:AddToggle("TripMineESP", { Text = "地雷透视", Default = false, Callback = function(Value) ESPSettings.tripMineEsp = Value end }):AddColorPicker("TripMineColor", { Default = ESPSettings.tripMineColor, Title = "地雷颜色", Callback = function(Value) ESPSettings.tripMineColor = Value end })
ItemGroup:AddToggle("TwoTimeRespawnESP", { Text = "重生点透视", Default = false, Callback = function(Value) ESPSettings.twoTimeRespawnEsp = Value end }):AddColorPicker("TwoTimeRespawnColor", { Default = ESPSettings.twoTimeRespawnColor, Title = "重生点颜色", Callback = function(Value) ESPSettings.twoTimeRespawnColor = Value end })
ItemGroup:AddToggle("GraffitiESP", { Text = "涂鸦透视", Default = false, Callback = function(Value) ESPSettings.graffitiEsp = Value end }):AddColorPicker("GraffitiColor", { Default = ESPSettings.graffitiColor, Title = "涂鸦颜色", Callback = function(Value) ESPSettings.graffitiColor = Value end })
SpecialGroup:AddToggle("PizzaDeliveryESP", { Text = "披萨外卖员透视", Default = false, Callback = function(Value) ESPSettings.pizzaDeliveryEsp = Value end }):AddColorPicker("PizzaDeliveryColor", { Default = ESPSettings.pizzaDeliveryColor, Title = "外卖员颜色", Callback = function(Value) ESPSettings.pizzaDeliveryColor = Value end })
SpecialGroup:AddToggle("ZombieESP", { Text = "僵尸透视", Default = false, Callback = function(Value) ESPSettings.zombieEsp = Value end }):AddColorPicker("ZombieColor", { Default = ESPSettings.zombieColor, Title = "僵尸颜色", Callback = function(Value) ESPSettings.zombieColor = Value end })
SpecialGroup:AddToggle("AzureGroundBulbESP", {
    Text = "地面灯泡透视",
    Default = false,
    Callback = function(Value) ESPSettings.azureGroundBulbESP = Value end
}):AddColorPicker("AzureGroundBulbColor", {
    Default = ESPSettings.azureGroundBulbColor,
    Title = "地面灯泡颜色",
    Callback = function(Value) ESPSettings.azureGroundBulbColor = Value end
})
SpecialGroup:AddToggle("AzureVineESP", {
    Text = "藤蔓透视",
    Default = false,
    Callback = function(Value) ESPSettings.azureVineESP = Value end
}):AddColorPicker("AzureVineColor", {
    Default = ESPSettings.azureVineColor,
    Title = "藤蔓颜色",
    Callback = function(Value) ESPSettings.azureVineColor = Value end
})
TracerGroup:AddToggle("GeneratorTracers", { Text = "发电机轨迹线", Default = false, Callback = function(Value) ESPSettings.generatorTracers = Value end })
TracerGroup:AddToggle("ItemTracers", { Text = "物品轨迹线", Default = false, Callback = function(Value) ESPSettings.itemTracers = Value end })
TracerGroup:AddToggle("PizzaTracers", { Text = "披萨轨迹线", Default = false, Callback = function(Value) ESPSettings.pizzaTracers = Value end })
TracerGroup:AddToggle("PizzaDeliveryTracers", { Text = "外卖员轨迹线", Default = false, Callback = function(Value) ESPSettings.pizzaDeliveryTracers = Value end })
TracerGroup:AddToggle("ZombieTracers", { Text = "僵尸轨迹线", Default = false, Callback = function(Value) ESPSettings.zombieTracers = Value end })
TracerGroup:AddToggle("TaphTripwireTracers", { Text = "绊线轨迹线", Default = false, Callback = function(Value) ESPSettings.taphTripwireTracers = Value end })
TracerGroup:AddToggle("TripMineTracers", { Text = "地雷轨迹线", Default = false, Callback = function(Value) ESPSettings.tripMineTracers = Value end })
TracerGroup:AddToggle("TwoTimeRespawnTracers", { Text = "重生点轨迹线", Default = false, Callback = function(Value) ESPSettings.twoTimeRespawnTracers = Value end })
NameToggleGroup:AddToggle("ShowGeneratorName", { Text = "显示发电机名称", Default = true, Callback = function(Value) ESPSettings.showGeneratorName = Value end })
NameToggleGroup:AddToggle("ShowItemName", { Text = "显示物品名称", Default = true, Callback = function(Value) ESPSettings.showItemName = Value end })
NameToggleGroup:AddToggle("ShowPizzaName", { Text = "显示披萨名称", Default = true, Callback = function(Value) ESPSettings.showPizzaName = Value end })
NameToggleGroup:AddToggle("ShowPizzaDeliveryName", { Text = "显示外卖员名称", Default = true, Callback = function(Value) ESPSettings.showPizzaDeliveryName = Value end })
NameToggleGroup:AddToggle("ShowZombieName", { Text = "显示僵尸名称", Default = true, Callback = function(Value) ESPSettings.showZombieName = Value end })
NameToggleGroup:AddToggle("ShowTaphTripwireName", { Text = "显示绊线名称", Default = true, Callback = function(Value) ESPSettings.showTaphTripwireName = Value end })
NameToggleGroup:AddToggle("ShowTripMineName", { Text = "显示地雷名称", Default = true, Callback = function(Value) ESPSettings.showTripMineName = Value end })
NameToggleGroup:AddToggle("ShowTwoTimeRespawnName", { Text = "显示重生点名称", Default = true, Callback = function(Value) ESPSettings.showTwoTimeRespawnName = Value end })
NameToggleGroup:AddToggle("ShowGraffitiName", { Text = "显示涂鸦名称", Default = true, Callback = function(Value) ESPSettings.showGraffitiName = Value end })

local flow = { on = false, nodeDelay = 0.04 }
local function flowKey(n) return n.row .. "-" .. n.col end
local function flowNeighbour(r1, c1, r2, c2)
    if r2 == r1 - 1 and c2 == c1 then return "上" end
    if r2 == r1 + 1 and c2 == c1 then return "下" end
    if r2 == r1 and c2 == c1 - 1 then return "左" end
    if r2 == r1 and c2 == c1 + 1 then return "右" end
    return false
end
local function flowOrder(path, endpoints)
    if not path or #path == 0 then return path end
    local lookup = {}
    for _, n in ipairs(path) do lookup[flowKey(n)] = n end
    local start
    for _, ep in ipairs(endpoints or {}) do
        for _, n in ipairs(path) do
            if n.row == ep.row and n.col == ep.col then start = { row = ep.row, col = ep.col }; break end
        end
        if start then break end
    end
    if not start then
        for _, n in ipairs(path) do
            local nb = 0
            for _, d in ipairs({ { -1, 0 }, { 1, 0 }, { 0, -1 }, { 0, 1 } }) do
                if lookup[(n.row + d[1]) .. "-" .. (n.col + d[2])] then nb = nb + 1 end
            end
            if nb == 1 then start = { row = n.row, col = n.col }; break end
        end
    end
    if not start then start = { row = path[1].row, col = path[1].col } end
    local pool, ordered = {}, {}
    for _, n in ipairs(path) do pool[flowKey(n)] = { row = n.row, col = n.col } end
    local cur = start
    table.insert(ordered, { row = cur.row, col = cur.col }); pool[flowKey(cur)] = nil
    while next(pool) do
        local moved = false
        for k, node in pairs(pool) do
            if flowNeighbour(cur.row, cur.col, node.row, node.col) then
                table.insert(ordered, { row = node.row, col = node.col })
                pool[k] = nil; cur = node; moved = true; break
            end
        end
        if not moved then break end
    end
    return ordered
end
local function flowSolve(puzzle)
    pcall(function()
        if not puzzle or not puzzle.Solution then return end
        local indices = {}
        for i = 1, #puzzle.Solution do indices[i] = i end
        for i = #indices, 2, -1 do local j = math.random(1, i); indices[i], indices[j] = indices[j], indices[i] end
        for _, ci in ipairs(indices) do
            local solution = puzzle.Solution[ci]; if not solution then continue end
            local ordered = flowOrder(solution, puzzle.targetPairs[ci])
            if not ordered or #ordered == 0 then continue end
            puzzle.paths[ci] = {}
            for _, node in ipairs(ordered) do
                table.insert(puzzle.paths[ci], { row = node.row, col = node.col })
                puzzle:updateGui(); task.wait(flow.nodeDelay)
            end
            task.wait(0)
            puzzle:checkForWin()
        end
    end)
end
do
    pcall(function()
        local modFolder  = ReplicatedStorage:FindFirstChild("Modules")
        local miniFolder = modFolder and modFolder:FindFirstChild("Minigames")
        local fgFolder   = miniFolder and miniFolder:FindFirstChild("FlowGameManager")
        local fgModule   = fgFolder and fgFolder:FindFirstChild("FlowGame")
        if fgModule then
            local ok, FG = pcall(require, fgModule)
            if ok and FG and FG.new then
                local orig = FG.new
                FG.new = function(...)
                    local p = orig(...)
                    if flow.on then task.spawn(function() task.wait(0.3); flowSolve(p) end) end
                    return p
                end
            end
        end
    end)
end
local genLeft = Tabs.发电机:AddLeftGroupbox("自动解谜", "zap")
genLeft:AddToggle("FlowAutoSolve", { Text = "自动解谜", Default = flow.on, Callback = function(Value) flow.on = Value end })
local genRight = Tabs.发电机:AddRightGroupbox("设置", "sliders")
genRight:AddSlider("FlowSpeed", { Text = "自动解谜速度", Default = flow.nodeDelay, Min = 0.01, Max = 0.50, Rounding = 2, Compact = false, Callback = function(Value) flow.nodeDelay = Value end })

local SpeedGroup = Tabs.玩家:AddLeftGroupbox("速度", "bolt")
local FlightGroup = Tabs.玩家:AddLeftGroupbox("飞行", "plane")
local speedEnabled = false
local speedValue = 16
SpeedGroup:AddToggle("SpeedToggle", { Text = "启用加速", Default = false, Callback = function(v)
    speedEnabled = v
    if v then
        task.spawn(function()
            while speedEnabled do
                local char = LP.Character
                local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.MoveDirection.Magnitude > 0 then
                    char:TranslateBy(humanoid.MoveDirection * speedValue * RunService.RenderStepped:Wait())
                end
                task.wait()
            end
        end)
    end
end })
SpeedGroup:AddSlider("SpeedValue", { Text = "速度值", Default = 16, Min = 1, Max = 500, Rounding = 0, Callback = function(v) speedValue = v end })
local flightEnabled = false
local flightSpeed = 50
local flightLoop = nil
local function startFlight()
    local char = LP.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local head = char:FindFirstChild("Head")
    if not humanoid or not head then return end
    humanoid.PlatformStand = true
    head.Anchored = true
    if flightLoop then flightLoop:Disconnect() end
    flightLoop = RunService.Heartbeat:Connect(function(dt)
        if not char or not char.Parent then
            if flightLoop then flightLoop:Disconnect(); flightLoop = nil end
            return
        end
        local md = humanoid.MoveDirection * (flightSpeed * dt)
        local cam = Workspace.CurrentCamera
        local headCF = head.CFrame
        local camCF = cam.CFrame
        local off = headCF:ToObjectSpace(camCF).Position
        camCF = camCF * CFrame.new(-off.X, -off.Y, -off.Z + 1)
        local cp = camCF.Position
        local hp = headCF.Position
        local ov = CFrame.new(cp, Vector3.new(hp.X, cp.Y, hp.Z)):VectorToObjectSpace(md)
        head.CFrame = CFrame.new(hp) * (camCF - cp) * CFrame.new(ov)
    end)
end
local function stopFlight()
    if flightLoop then flightLoop:Disconnect(); flightLoop = nil end
    local char = LP.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local head = char:FindFirstChild("Head")
        if humanoid then humanoid.PlatformStand = false end
        if head then head.Anchored = false end
    end
end
FlightGroup:AddToggle("FlightToggle", { Text = "启用飞行", Default = false, Callback = function(v)
    flightEnabled = v
    if v then startFlight() else stopFlight() end
end })
FlightGroup:AddSlider("FlightSpeed", { Text = "飞行速度", Default = 50, Min = 1, Max = 200, Rounding = 0, Callback = function(v) flightSpeed = v end })
local StaminaTabbox = Tabs.玩家:AddRightTabbox()
local MVP = StaminaTabbox:AddTab("体力")
local MVP2 = StaminaTabbox:AddTab("设置")
local SprintingModule = ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Character"):WaitForChild("Game"):WaitForChild("Sprinting")
local GetModule = function() return require(SprintingModule) end
local StaminaSettings = { MaxStamina = 100, StaminaGain = 25, StaminaLoss = 10, SprintSpeed = 28, InfiniteGain = 9999 }
local SettingToggles = { MaxStamina = false, StaminaGain = false, StaminaLoss = false, SprintSpeed = false }
task.spawn(function()
    while true do
        local m = GetModule()
        for key, value in pairs(StaminaSettings) do
            if SettingToggles[key] then m[key] = value end
        end
        task.wait(0.5)
    end
end)
local bai = {Spr = false}
local connection
MVP:AddToggle("InfiniteStamina", { Text = "无限体力", Default = false, Callback = function(state)
    bai.Spr = state
    local Sprinting = GetModule()
    if state then
        Sprinting.StaminaLoss = 0
        Sprinting.StaminaGain = StaminaSettings.InfiniteGain
        if connection then connection:Disconnect() end
        connection = RunService.Heartbeat:Connect(function()
            if not bai.Spr then return end
            Sprinting.StaminaLoss = 0
            Sprinting.StaminaGain = StaminaSettings.InfiniteGain
        end)
    else
        Sprinting.StaminaLoss = 10
        Sprinting.StaminaGain = 25
        if connection then connection:Disconnect(); connection = nil end
    end
end })
MVP:AddToggle("MaxStaminaToggle", { Text = "修改最大体力", Default = false, Callback = function(v) SettingToggles.MaxStamina = v end })
MVP:AddToggle("StaminaGainToggle", { Text = "修改体力恢复速度", Default = false, Callback = function(v) SettingToggles.StaminaGain = v end })
MVP:AddToggle("StaminaLossToggle", { Text = "修改体力消耗速度", Default = false, Callback = function(v) SettingToggles.StaminaLoss = v end })
MVP:AddToggle("SprintSpeedToggle", { Text = "修改冲刺速度", Default = false, Callback = function(v) SettingToggles.SprintSpeed = v end })
MVP2:AddSlider("MaxStaminaSlider", { Text = "最大体力", Default = 100, Min = 1, Max = 500, Rounding = 0, Callback = function(v)
    StaminaSettings.MaxStamina = v
    if SettingToggles.MaxStamina then GetModule().MaxStamina = v end
end })
MVP2:AddSlider("SprintSpeedSlider", { Text = "冲刺速度", Default = 28, Min = 1, Max = 60, Rounding = 0, Callback = function(v)
    StaminaSettings.SprintSpeed = v
    if SettingToggles.SprintSpeed then GetModule().SprintSpeed = v end
end })
MVP2:AddSlider("StaminaGainSlider", { Text = "体力恢复速度", Default = 25, Min = 0, Max = 120, Rounding = 0, Callback = function(v)
    StaminaSettings.StaminaGain = v
    if SettingToggles.StaminaGain and not bai.Spr then GetModule().StaminaGain = v end
end })
MVP2:AddSlider("StaminaLossSlider", { Text = "体力消耗速度", Default = 10, Min = 0, Max = 100, Rounding = 0, Callback = function(v)
    StaminaSettings.StaminaLoss = v
    if SettingToggles.StaminaLoss and not bai.Spr then GetModule().StaminaLoss = v end
end })

local ExtraGroup = Tabs.玩家:AddRightGroupbox("额外", "plus")
local deleteFakeNoli = false
task.spawn(function()
    while true do
        task.wait(0.2)
        if not deleteFakeNoli then continue end
        local killers = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Killers")
        if killers then
            for _, model in pairs(killers:GetChildren()) do
                if model:IsA("Model") and model:GetAttribute("IsFakeNoli") == true then model:Destroy() end
            end
        end
    end
end)
ExtraGroup:AddToggle("DeleteFakeNoli", { Text = "删除假Noli", Default = false, Callback = function(v) deleteFakeNoli = v end })
local dashTurnConn = nil
local function getInputDirection()
    local cf = Workspace.CurrentCamera.CFrame
    local fwd = Vector3.new(cf.LookVector.X, 0, cf.LookVector.Z).Unit
    local right = Vector3.new(cf.RightVector.X, 0, cf.RightVector.Z).Unit
    local x, z = 0, 0
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then z = z - 1 end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then z = z + 1 end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then x = x - 1 end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then x = x + 1 end
    local dir = fwd * -z + right * x
    return dir.Magnitude > 0.01 and dir.Unit or fwd
end
local function enableDashTurn()
    if dashTurnConn then return end
    dashTurnConn = RunService.RenderStepped:Connect(function(dt)
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not hrp or char.Name ~= "c00lkidd" then return end
        if char:GetAttribute("FootstepsMuted") ~= true then return end
        local dir = getInputDirection()
        local lv = hrp:FindFirstChildWhichIsA("LinearVelocity")
        if lv then lv.LineDirection = dir end
        if dir.Magnitude > 0.01 then
            local targetRot = CFrame.new(hrp.Position, hrp.Position + dir).Rotation
            hrp.CFrame = CFrame.new(hrp.Position) * hrp.CFrame.Rotation:Lerp(targetRot, math.min(dt * 16, 1))
        end
    end)
end
local function disableDashTurn()
    if dashTurnConn then dashTurnConn:Disconnect(); dashTurnConn = nil end
end
ExtraGroup:AddToggle("C00lkiddDashTurn", { Text = "c00lkidd 冲刺转向", Default = false, Callback = function(v) if v then enableDashTurn() else disableDashTurn() end end })
local breakFreeTask = nil
local anti_breakFree = false
local function startBreakFree()
    if breakFreeTask then return end
    breakFreeTask = task.spawn(function()
        while true do
            if not anti_breakFree then break end
            local tui = LP.PlayerGui:FindFirstChild("TemporaryUI")
            if tui and tui:FindFirstChild("QTE") then
                local killers = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Killers")
                if killers then
                    for _, k in ipairs(killers:GetChildren()) do
                        if k:IsA("Model") and k.Name == "Nosferatu" then
                            local un = k:GetAttribute("Username")
                            if un and un ~= LP.Name then
                                pcall(function()
                                    ReplicatedStorage.Modules.Network.Network.RemoteEvent:FireServer(un .. "NosHookQTE", {buffer.fromstring("\x01\x01")})
                                end)
                                break
                            end
                        end
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end
local function stopBreakFree()
    if breakFreeTask then task.cancel(breakFreeTask); breakFreeTask = nil end
end
ExtraGroup:AddToggle("AutoBreakFree", { Text = "自动挣脱", Default = false, Callback = function(v)
    anti_breakFree = v
    if v then startBreakFree() else stopBreakFree() end
end })
local pullRopeTask = nil
local anti_pullRope = false
local function startPullRope()
    if pullRopeTask then return end
    pullRopeTask = task.spawn(function()
        while true do
            if not anti_pullRope then break end
            local killers = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Killers")
            local isNos = false
            if killers then
                for _, k in ipairs(killers:GetChildren()) do
                    if k:IsA("Model") and k.Name == "Nosferatu" then
                        local un = k:GetAttribute("Username")
                        if un == LP.Name then isNos = true break end
                    end
                end
            end
            if isNos then
                local hum = LP.Character and LP.Character:FindFirstChild("Humanoid")
                if hum then
                    for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
                        local animId = track.Animation and track.Animation.AnimationId
                        if animId then
                            local id = animId:match("%d+")
                            if id == "113403615979705" then
                                pcall(function()
                                    ReplicatedStorage.Modules.Network.Network.RemoteEvent:FireServer(LP.Name .. "NosHookQTE", {buffer.fromstring("\x01\x01")})
                                end)
                                break
                            end
                        end
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end
local function stopPullRope()
    if pullRopeTask then task.cancel(pullRopeTask); pullRopeTask = nil end
end
ExtraGroup:AddToggle("AutoPullRope", { Text = "自动拉绳", Default = false, Callback = function(v)
    anti_pullRope = v
    if v then startPullRope() else stopPullRope() end
end })
local azureQTEEnabled = false
local originalGetHitZoneIndex = nil
local hookSlot = nil
local function enableQTE()
    if azureQTEEnabled then return end
    azureQTEEnabled = true
    local BehaviorModule = ReplicatedStorage:FindFirstChild("Assets")
        and ReplicatedStorage.Assets:FindFirstChild("Killers")
        and ReplicatedStorage.Assets.Killers:FindFirstChild("Azure")
        and ReplicatedStorage.Assets.Killers.Azure:FindFirstChild("Config")
        and ReplicatedStorage.Assets.Killers.Azure.Config:FindFirstChild("cl_WorkaroundModules")
        and ReplicatedStorage.Assets.Killers.Azure.Config.cl_WorkaroundModules:FindFirstChild("cl_ConstructQTE")
    if not BehaviorModule then
        Library:Notify({ Title = "QTE错误", Description = "未找到QTE模块", Time = 3 })
        return
    end
    local Behavior
    pcall(function() Behavior = require(BehaviorModule) end)
    if not Behavior or not Behavior.new then return end
    local function cheatGetHitZoneIndex(currentValue, qteBounds, completedZones)
        if type(completedZones) == "table" then
            for i = 1, 3 do
                if not completedZones[i] then return i end
            end
        end
        return 1
    end
    local upvalues = debug.getupvalues(Behavior.new)
    for slot, value in pairs(upvalues) do
        if type(value) == "function" and debug.info(value, "a") == 3 then
            originalGetHitZoneIndex = value
            hookSlot = slot
            debug.setupvalue(Behavior.new, slot, cheatGetHitZoneIndex)
            Library:Notify({ Title = "QTE", Description = "已注入自动QTE", Time = 2 })
            return
        end
    end
    Library:Notify({ Title = "QTE错误", Description = "在上级值中未找到3参数函数", Time = 3 })
end
local function disableQTE()
    azureQTEEnabled = false
    if hookSlot and originalGetHitZoneIndex then
        local BehaviorModule = ReplicatedStorage:FindFirstChild("Assets")
            and ReplicatedStorage.Assets:FindFirstChild("Killers")
            and ReplicatedStorage.Assets.Killers:FindFirstChild("Azure")
            and ReplicatedStorage.Assets.Killers.Azure:FindFirstChild("Config")
            and ReplicatedStorage.Assets.Killers.Azure.Config:FindFirstChild("cl_WorkaroundModules")
            and ReplicatedStorage.Assets.Killers.Azure.Config.cl_WorkaroundModules:FindFirstChild("cl_ConstructQTE")
        if BehaviorModule then
            local Behavior
            pcall(function() Behavior = require(BehaviorModule) end)
            if Behavior and Behavior.new then
                debug.setupvalue(Behavior.new, hookSlot, originalGetHitZoneIndex)
            end
        end
        hookSlot = nil
        originalGetHitZoneIndex = nil
    end
end
ExtraGroup:AddToggle("AzureAutoQTE", {
    Text = "Azure自动QTE",
    Default = false,
    Callback = function(val)
        if val then enableQTE() else disableQTE() end
    end
})

local generalGroup = Tabs.自动瞄准:AddLeftGroupbox("常规瞄准")
local survivorGroup = Tabs.自动瞄准:AddLeftGroupbox("杀手瞄准")
local killerGroup = Tabs.自动瞄准:AddRightGroupbox("幸存者瞄准")
local settings = { distance = 100, smoothness = 20, duration = 50, targetPath = "auto", globalSound = false, silentAim = false, janeDoe = false, janeDoeAxe = false, chance = false, dusekkar = false, onex4 = false, cookidd = false, noilStar = false, noilVoid = false, punch = false }
pcall(function() generalGroup:AddSlider("GAA_Distance", { Text = "瞄准距离", Default = settings.distance, Min = 10, Max = 500, Rounding = 1, Callback = function(v) settings.distance = v end }) end)
pcall(function() generalGroup:AddSlider("GAA_Smoothness", { Text = "摄像头平滑度", Default = settings.smoothness, Min = 0, Max = 100, Rounding = 1, Callback = function(v) settings.smoothness = v end }) end)
pcall(function() generalGroup:AddSlider("GAA_Duration", { Text = "锁定持续时间", Default = settings.duration, Min = 1, Max = 200, Rounding = 1, Callback = function(v) settings.duration = v end }) end)
pcall(function() generalGroup:AddTextbox("GAA_TargetPath", { Text = "目标路径 (留空为自动)", Default = "", Placeholder = "例如 workspace.Players", Callback = function(v) settings.targetPath = (v ~= "" and v) or "auto" end }) end)
pcall(function() generalGroup:AddToggle("SilentAimToggle", { Text = "静默瞄准 (杀手)", Default = false, Callback = function(v) toggleModule("SilentAim", v) end }) end)
pcall(function() generalGroup:AddToggle("SoundTriggerToggle", { Text = "声音触发瞄准", Default = false, Callback = function(v) toggleModule("SoundTrigger", v) end }) end)
pcall(function() survivorGroup:AddToggle("Onex4Toggle", { Text = "1x4瞄准", Default = false, Callback = function(v) toggleModule("1x4", v) end }) end)
pcall(function() survivorGroup:AddToggle("CookiddToggle", { Text = "C00kidd瞄准 (摄像头)", Default = false, Callback = function(v) toggleModule("C00kidd", v) end }) end)
pcall(function() survivorGroup:AddToggle("JohnDoeToggle", { Text = "John Doe瞄准 (摄像头)", Default = false, Callback = function(v) toggleModule("JohnDoe", v) end }) end)
pcall(function() survivorGroup:AddToggle("NosferatuToggle", { Text = "Nosferatu瞄准 (摄像头)", Default = false, Callback = function(v) toggleModule("Nosferatu", v) end }) end)
pcall(function() survivorGroup:AddToggle("NoilStarToggle", { Text = "Noil 星爆瞄准", Default = false, Callback = function(v) toggleModule("NoilStar", v) end }) end)
pcall(function() survivorGroup:AddToggle("NoilVoidToggle", { Text = "Noil 虚空冲刺瞄准", Default = false, Callback = function(v) toggleModule("NoilVoid", v) end }) end)
pcall(function() killerGroup:AddToggle("JaneDoeToggle", { Text = "Jane Doe瞄准", Default = false, Callback = function(v) toggleModule("JaneDoe", v) end }) end)
pcall(function() killerGroup:AddToggle("JaneDoeAxeToggle", { Text = "Jane Doe斧头瞄准", Default = false, Callback = function(v) toggleModule("JaneDoeAxe", v) end }) end)
pcall(function() killerGroup:AddToggle("ChanceToggle", { Text = "Chance瞄准", Default = false, Callback = function(v) toggleModule("Chance", v) end }) end)
pcall(function() killerGroup:AddToggle("DusekkarToggle", { Text = "Dusekkar瞄准 (摄像头)", Default = false, Callback = function(v) toggleModule("Dusekkar", v) end }) end)
pcall(function() killerGroup:AddToggle("PunchToggle", { Text = "重击瞄准", Default = false, Callback = function(v) toggleModule("Punch", v) end }) end)
local function getTargetsFromPath(pathString)
    if pathString == "auto" then return nil end
    local parts = {}
    for part in string.gmatch(pathString, "[^%.]+") do table.insert(parts, part) end
    local current = _G
    for _, part in ipairs(parts) do current = current[part]; if not current then break end end
    return current
end
function getNearestTarget()
    local player = game.Players.LocalPlayer
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return nil end
    local myHRP = player.Character.HumanoidRootPart
    local nearest, nearestDist = nil, math.huge
    local targetContainer = nil
    local path = settings.targetPath
    if path == "auto" then
        local candidates = {
            workspace:FindFirstChild("Players"), workspace:FindFirstChild("Characters"), workspace:FindFirstChild("Living"),
            workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players"),
            workspace:FindFirstChild("Model") and workspace.Model:FindFirstChild("Players"),
        }
        for _, container in ipairs(candidates) do
            if container and (container:IsA("Folder") or container:IsA("Model")) then
                local hasPlayer = false
                for _, child in ipairs(container:GetChildren()) do
                    if child:IsA("Model") and child:FindFirstChild("HumanoidRootPart") then hasPlayer = true; break end
                end
                if hasPlayer then targetContainer = container; break end
            end
        end
        if not targetContainer then targetContainer = workspace end
    else
        local obj = getTargetsFromPath(path)
        targetContainer = obj or workspace
    end
    local function processModel(model)
        if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") then
            if model == player.Character then return end
            local hrp = model.HumanoidRootPart
            local dist = (hrp.Position - myHRP.Position).Magnitude
            if dist < nearestDist and dist <= settings.distance then nearestDist = dist; nearest = model end
        end
    end
    if targetContainer == workspace then
        for _, child in ipairs(workspace:GetChildren()) do processModel(child) end
    else
        for _, child in ipairs(targetContainer:GetChildren()) do processModel(child) end
    end
    return nearest
end
function SmoothCameraLookAt(currentCamCF, targetPos, progress)
    local targetLook = (targetPos - currentCamCF.Position).Unit
    local currentLook = currentCamCF.LookVector
    local newLook = currentLook:Lerp(targetLook, progress)
    return CFrame.lookAt(currentCamCF.Position, currentCamCF.Position + newLook * 100)
end
local activeAimConnection = nil
function executeAim()
    if activeAimConnection then activeAimConnection:Disconnect(); activeAimConnection = nil end
    local target = getNearestTarget()
    if not target or not target:FindFirstChild("HumanoidRootPart") then return end
    local totalFrames = settings.duration
    local smoothPower = settings.smoothness / 100
    local currentFrame = 0
    local conn
    conn = game:GetService("RunService").RenderStepped:Connect(function()
        currentFrame = currentFrame + 1
        local progress = math.clamp(currentFrame / totalFrames, 0, 1)
        progress = progress ^ (1 - smoothPower)
        if currentFrame <= totalFrames then
            local currentCamCF = workspace.CurrentCamera.CFrame
            local targetPos = target.HumanoidRootPart.Position
            workspace.CurrentCamera.CFrame = SmoothCameraLookAt(currentCamCF, targetPos, progress)
        else
            conn:Disconnect()
            if activeAimConnection == conn then activeAimConnection = nil end
        end
    end)
    activeAimConnection = conn
end
local triggerConnections = {}
local modules = {}
function registerTriggerModule(name, enableFunc, disableFunc)
    modules[name] = { enabled = false, enable = enableFunc, disable = disableFunc }
end
function toggleModule(name, state)
    local mod = modules[name]; if not mod then return end
    if state and not mod.enabled then mod.enable(); mod.enabled = true
    elseif not state and mod.enabled then mod.disable(); mod.enabled = false end
end
local function getPlayingAnimationIds(humanoid)
    local ids = {}
    if humanoid then
        for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
            if track.Animation and track.Animation.AnimationId then
                local id = track.Animation.AnimationId:match("%d+")
                if id then ids[id] = true end
            end
        end
    end
    return ids
end
function createAnimationTrigger(moduleName, animIds, targetType, useCamera)
    local humanoid = nil; local hrp = nil; local isActive = false
    local function getTarget()
        if targetType then
            local folder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild(targetType)
            if not folder then return nil end
            local player = game.Players.LocalPlayer
            if not hrp then return nil end
            local closest, closestDist = nil, math.huge
            for _, model in ipairs(folder:GetChildren()) do
                if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") and model ~= player.Character then
                    local dist = (model.HumanoidRootPart.Position - hrp.Position).Magnitude
                    if dist < closestDist and dist <= settings.distance then closestDist = dist; closest = model end
                end
            end
            return closest
        else
            return getNearestTarget()
        end
    end
    local function onRenderStep()
        if not isActive or not humanoid or not hrp then return end
        local playing = getPlayingAnimationIds(humanoid)
        local triggered = false
        for id in pairs(animIds) do if playing[id] then triggered = true; break end end
        if triggered then
            local target = getTarget()
            if target and target:FindFirstChild("HumanoidRootPart") then
                if useCamera then
                    local targetPos = target.HumanoidRootPart.Position
                    local cam = workspace.CurrentCamera
                    local direction = (targetPos - cam.CFrame.Position).Unit
                    cam.CFrame = CFrame.lookAt(cam.CFrame.Position, cam.CFrame.Position + direction)
                else
                    local direction = (target.HumanoidRootPart.Position - hrp.Position).Unit
                    local yRot = math.atan2(-direction.X, -direction.Z)
                    hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, yRot, 0)
                    if targetType == "Dusekkar" or targetType == "JaneDoe" then
                        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.HumanoidRootPart.Position)
                    end
                end
            end
        end
    end
    local function setupCharacter(char)
        if char == game.Players.LocalPlayer.Character then humanoid = char:WaitForChild("Humanoid"); hrp = char:WaitForChild("HumanoidRootPart") end
    end
    local function enable()
        isActive = true
        local player = game.Players.LocalPlayer
        if player.Character then setupCharacter(player.Character) end
        player.CharacterAdded:Connect(setupCharacter)
        local conn = game:GetService("RunService").RenderStepped:Connect(onRenderStep)
        table.insert(triggerConnections, conn)
    end
    local function disable() isActive = false; humanoid = nil; hrp = nil end
    registerTriggerModule(moduleName, enable, disable)
end
local silentAimEnabled = false
local silentAimDistance = 100
local silentAimConnection = nil
local silentTarget = nil
function isKiller()
    local killersFolder = workspace.Players and workspace.Players:FindFirstChild("Killers")
    local LocalPlayer = game.Players.LocalPlayer
    if killersFolder and LocalPlayer.Character then
        for _, v in ipairs(killersFolder:GetChildren()) do
            if v == LocalPlayer.Character then return true end
        end
    end
    return false
end
function getClosestSurvivor()
    local survivorsFolder = workspace.Players and workspace.Players:FindFirstChild("Survivors")
    if not survivorsFolder then return nil end
    local LocalPlayer = game.Players.LocalPlayer
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = char.HumanoidRootPart.Position
    local closest = nil; local shortest = math.huge
    for _, model in ipairs(survivorsFolder:GetChildren()) do
        if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") then
            local dist = (model.HumanoidRootPart.Position - myPos).Magnitude
            if dist < shortest and dist <= silentAimDistance then shortest = dist; closest = model end
        end
    end
    return closest
end
function faceTarget(model)
    if not model or not model:FindFirstChild("HumanoidRootPart") then return end
    local LocalPlayer = game.Players.LocalPlayer
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    local targetPos = model.HumanoidRootPart.Position
    root.CFrame = CFrame.new(root.Position, Vector3.new(targetPos.X, root.Position.Y, targetPos.Z))
end
function StartSilentAim()
    if silentAimConnection then silentAimConnection:Disconnect() end
    silentAimConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not silentAimEnabled or not isKiller() then return end
        silentTarget = getClosestSurvivor()
        if silentTarget then faceTarget(silentTarget) end
    end)
end
registerTriggerModule("SilentAim", function() silentAimEnabled = true; StartSilentAim() end, function() silentAimEnabled = false; if silentAimConnection then silentAimConnection:Disconnect(); silentAimConnection = nil end end)
local johnaim = false; local Noloop = nil; local No2loop = nil
local aimbotNoilsounds = { "StarBomb", "StarBombTrail", "StarBombExplosion" }
local aimbotNoilsounds2 = { "VoidRush", "VoidRushTrail" }
function NoilStarAim(state)
    johnaim = state; local LocalPlayer = game.Players.LocalPlayer
    if state then
        if Noloop then Noloop:Disconnect() end
        local char = LocalPlayer.Character; if not char then return end
        local rootPart = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart")
        Noloop = rootPart.ChildAdded:Connect(function(child)
            if not johnaim then return end
            for _, v in pairs(aimbotNoilsounds) do
                if child.Name == v then
                    local survivors = {}
                    for _, player in pairs(game.Players:GetPlayers()) do
                        if player ~= LocalPlayer then
                            local character = player.Character
                            if character and character:FindFirstChild("HumanoidRootPart") then table.insert(survivors, character) end
                        end
                    end
                    local nearestSurvivor = nil; local shortestDistance = math.huge
                    local playerHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if not playerHRP then return end
                    for _, survivor in pairs(survivors) do
                        local survivorHRP = survivor.HumanoidRootPart
                        local distance = (survivorHRP.Position - playerHRP.Position).Magnitude
                        if distance < shortestDistance then shortestDistance = distance; nearestSurvivor = survivor end
                    end
                    if nearestSurvivor then
                        local nearestHRP = nearestSurvivor.HumanoidRootPart
                        if playerHRP then
                            local num = 1
                            while num <= 50 do
                                task.wait(0.01); num = num + 1
                                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, nearestHRP.Position)
                                playerHRP.CFrame = CFrame.lookAt(playerHRP.Position, Vector3.new(nearestHRP.Position.X, nearestHRP.Position.Y, nearestHRP.Position.Z))
                            end
                        end
                    end
                end
            end
        end)
    else if Noloop then Noloop:Disconnect(); Noloop = nil end end
end
function NoilVoidAim(state)
    johnaim = state; local LocalPlayer = game.Players.LocalPlayer
    if state then
        if No2loop then No2loop:Disconnect() end
        local char = LocalPlayer.Character; if not char then return end
        local rootPart = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart")
        No2loop = rootPart.ChildAdded:Connect(function(child)
            if not johnaim then return end
            for _, v in pairs(aimbotNoilsounds2) do
                if child.Name == v then
                    local survivors = {}
                    for _, player in pairs(game.Players:GetPlayers()) do
                        if player ~= LocalPlayer then
                            local character = player.Character
                            if character and character:FindFirstChild("HumanoidRootPart") then table.insert(survivors, character) end
                        end
                    end
                    local nearestSurvivor = nil; local shortestDistance = math.huge
                    local playerHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if not playerHRP then return end
                    for _, survivor in pairs(survivors) do
                        local survivorHRP = survivor.HumanoidRootPart
                        local distance = (survivorHRP.Position - playerHRP.Position).Magnitude
                        if distance < shortestDistance then shortestDistance = distance; nearestSurvivor = survivor end
                    end
                    if nearestSurvivor then
                        local nearestHRP = nearestSurvivor.HumanoidRootPart
                        if playerHRP then
                            local num = 1
                            while num <= 50 do
                                task.wait(0.01); num = num + 1
                                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, nearestHRP.Position)
                                playerHRP.CFrame = CFrame.lookAt(playerHRP.Position, Vector3.new(nearestHRP.Position.X, nearestHRP.Position.Y, nearestHRP.Position.Z))
                            end
                        end
                    end
                end
            end
        end)
    else if No2loop then No2loop:Disconnect(); No2loop = nil end end
end
registerTriggerModule("NoilStar", function() NoilStarAim(true) end, function() NoilStarAim(false) end)
registerTriggerModule("NoilVoid", function() NoilVoidAim(true) end, function() NoilVoidAim(false) end)
createAnimationTrigger("JaneDoe", { ["106527725058030"] = true, ["139929602101552"] = true }, "Killers", false)
createAnimationTrigger("JaneDoeAxe", { ["111918351126361"] = true }, "Killers", false)
createAnimationTrigger("Chance", { ["103601716322988"] = true, ["133491532453922"] = true, ["86371356500204"] = true, ["76649505662612"] = true, ["81698196845041"] = true }, "Killers", false)
createAnimationTrigger("Dusekkar", { ["77894750279891"] = true }, "Killers", true)
createAnimationTrigger("1x4", { ["99050723653468"] = true, ["119181003138006"] = true }, "Survivors", false)
createAnimationTrigger("C00kidd", { ["18885919947"] = true }, "Survivors", true)
createAnimationTrigger("JohnDoe", { ["127172483138092"] = true }, "Survivors", true)
createAnimationTrigger("Nosferatu", { ["79282445348798"] = true, ["128009545282102"] = true }, "Survivors", true)
createAnimationTrigger("Punch", { ["108911997126897"] = true, ["82137285150006"] = true, ["129843313690921"] = true, ["140703210927645"] = true, ["136007065400978"] = true, ["86096387000557"] = true, ["87259391926321"] = true, ["86709774283672"] = true, ["108807732150251"] = true, ["138040001965654"] = true }, "Killers", false)
local soundTriggerEnabled = false
local soundConnections = {}
local globalSoundConn = nil
local targetSoundIds = { "rbxassetid://120944766765949", "rbxassetid://92445809840331", "rbxassetid://89315669689903", "rbxassetid://77069367360935", "rbxassetid://123979582011869", "rbxassetid://109525294317144", "rbxassetid://105934041806374", "rbxassetid://132331977491979", "rbxassetid://128009545282102", "rbxassetid://79282445348798" }
local function onSoundPlayed(sound)
    if not soundTriggerEnabled then return end
    local soundId = sound.SoundId
    for _, id in ipairs(targetSoundIds) do if soundId == id then executeAim(); break end end
end
local function bindSound(sound)
    if not sound:IsA("Sound") then return end
    local conn = sound.Played:Connect(function() onSoundPlayed(sound) end)
    table.insert(soundConnections, conn)
end
local function setupSoundTrigger()
    local function bindAll(container) for _, obj in ipairs(container:GetDescendants()) do if obj:IsA("Sound") then bindSound(obj) end end end
    local player = game.Players.LocalPlayer
    if player.Character then bindAll(player.Character) end
    local charConn = player.CharacterAdded:Connect(function(char) task.wait(0.2); bindAll(char) end)
    table.insert(soundConnections, charConn)
    if settings.globalSound then
        globalSoundConn = workspace.DescendantAdded:Connect(function(child) if child:IsA("Sound") then bindSound(child) end end)
        table.insert(soundConnections, globalSoundConn)
        bindAll(workspace)
    end
end
registerTriggerModule("SoundTrigger", function() soundTriggerEnabled = true; setupSoundTrigger() end, function()
    soundTriggerEnabled = false
    for _, conn in ipairs(soundConnections) do conn:Disconnect() end
    soundConnections = {}
    if globalSoundConn then globalSoundConn:Disconnect(); globalSoundConn = nil end
end)

_G.BaseHitboxSize = Vector3.new(4.5, 6, 7.5)
_G.HitboxScale = 1.0
_G.HitboxOffset = -1.4
_G.HitboxColor = Color3.fromRGB(255, 255, 255)
_G.ShowOutline = true
_G.OutlineThickness = 0.01
_G.ShowHitboxVisual = true
_G.HitboxTransparency = 0.5
_G.HitboxDuration = 1.5
_G.BlockDelay = 0
_G.AutoBlockEnabled = false
_G.AutoBlockConnections = {}

local BlockRemote = nil
local function getBlockRemote()
    if BlockRemote then return BlockRemote end
    local success, remote = pcall(function()
        return ReplicatedStorage:WaitForChild("Modules", 10):WaitForChild("Network", 5):WaitForChild("Network", 5):WaitForChild("RemoteEvent", 5)
    end)
    if success and remote then
        BlockRemote = remote
        return remote
    end
    return nil
end
local function fireBlockRemote()
    local remote = getBlockRemote()
    if not remote then return end
    pcall(function()
        local args = {
            "UseActorAbility",
            { buffer.fromstring("\003\005\000\000\000Block") }
        }
        remote:FireServer(unpack(args))
    end)
end

local isBoxDetecting = false
local function createSpatialOverlapBox(creatorChar, size, onHitDetected)
    local creatorRoot = creatorChar:FindFirstChild("HumanoidRootPart") or creatorChar:FindFirstChild("RootPart")
    if not creatorRoot then return end
    local overlapParams = OverlapParams.new()
    overlapParams.FilterType = Enum.RaycastFilterType.Exclude
    overlapParams.FilterDescendantsInstances = { creatorChar }
    isBoxDetecting = true
    task.spawn(function()
        local timePast = 0
        while creatorChar.Parent and creatorRoot and creatorRoot.Parent and timePast < _G.HitboxDuration do
            local Part = Instance.new("Part")
            Part.Name = "AutoBlockHitbox_Frame"
            Part.Transparency = _G.HitboxTransparency
            Part.CanCollide = false
            Part.CanTouch = false
            Part.CanQuery = false
            Part.CastShadow = false
            Part.Anchored = true
            Part.Size = size
            Part.Color = _G.HitboxColor
            Part.Material = Enum.Material.ForceField
            local dynamicOffset = CFrame.new(0, 0, _G.HitboxOffset)
            Part.CFrame = creatorRoot.CFrame * dynamicOffset
            Part.Parent = workspace
            if _G.ShowOutline and _G.ShowHitboxVisual then
                local outline = Instance.new("SelectionBox")
                outline.Adornee = Part
                outline.Color3 = _G.HitboxColor
                outline.LineThickness = _G.OutlineThickness
                outline.Transparency = 0.1
                outline.Visible = true
                outline.Parent = Part
            end
            Debris:AddItem(Part, 0.05)
            local parts = workspace:GetPartsInPart(Part, overlapParams)
            local localPlayerHit = false
            for _, v in ipairs(parts) do
                local humanoid = v.Parent:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    local player = Players:GetPlayerFromCharacter(humanoid.Parent)
                    if player == LP then
                        localPlayerHit = true
                        break
                    end
                end
            end
            if localPlayerHit then
                if onHitDetected then onHitDetected() end
                break
            end
            timePast = timePast + RunService.Heartbeat:Wait()
        end
        isBoxDetecting = false
    end)
end

local lastAbilityLastUsed = nil
local lastAbilitiesUsed = nil
local blockLocked = false
local function checkAbilityAttributes()
    local killersFolder = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Killers")
    if not killersFolder then return end
    local slasher = killersFolder:GetChildren()[1]
    if not slasher or not slasher:IsA("Model") then return end
    local currentAbilityLastUsed = slasher:GetAttribute("AbilityLastUsed") or 0
    local currentAbilitiesUsed = slasher:GetAttribute("AbilitiesUsed") or 0
    if lastAbilityLastUsed == nil then
        lastAbilityLastUsed = currentAbilityLastUsed
        lastAbilitiesUsed = currentAbilitiesUsed
        return
    end
    local abilityLastUsedIncreased = (currentAbilityLastUsed > lastAbilityLastUsed)
    local abilitiesUsedIncreased = (currentAbilitiesUsed > lastAbilitiesUsed)
    if abilitiesUsedIncreased then
        blockLocked = true
    end
    if abilityLastUsedIncreased then
        if blockLocked then
            blockLocked = false
        else
            local baseSize = _G.BaseHitboxSize * _G.HitboxScale
            createSpatialOverlapBox(
                slasher,
                Vector3.new(baseSize.X, baseSize.Y, baseSize.Z),
                function()
                    fireBlockRemote()
                end
            )
        end
    end
    lastAbilityLastUsed = currentAbilityLastUsed
    lastAbilitiesUsed = currentAbilitiesUsed
end

RunService.Heartbeat:Connect(function()
    if _G.AutoBlockEnabled then
        checkAbilityAttributes()
    end
end)

local function EnableAutoBlock()
    lastAbilityLastUsed = nil
    lastAbilitiesUsed = nil
    blockLocked = false
    isBoxDetecting = false
    getBlockRemote()
end
local function DisableAutoBlock()
    lastAbilityLastUsed = nil
    lastAbilitiesUsed = nil
    blockLocked = false
    isBoxDetecting = false
end

local BlockLeft = Tabs.格挡:AddLeftGroupbox("自动格挡", "shield")
BlockLeft:AddToggle("AutoBlockToggle", { Text = "启用自动格挡", Default = false, Callback = function(state)
    _G.AutoBlockEnabled = state
    if state then EnableAutoBlock() else DisableAutoBlock() end
end })
BlockLeft:AddSlider("HitboxTransparency", { Text = "透明度", Default = 0.5, Min = 0, Max = 1, Rounding = 2, Callback = function(v) _G.HitboxTransparency = v end })
BlockLeft:AddLabel("命中盒颜色"):AddColorPicker("HitboxColor", { Default = _G.HitboxColor, Title = "命中盒颜色", Callback = function(color) _G.HitboxColor = color end })
local BlockRight = Tabs.格挡:AddRightGroupbox("命中盒设置", "sliders")
BlockRight:AddSlider("HitboxSize", { Text = "大小", Default = 1.0, Min = 0.2, Max = 3.0, Rounding = 2, Callback = function(v) _G.HitboxScale = v end })
BlockRight:AddSlider("HitboxOffset", { Text = "偏移 (Z轴)", Default = -1.4, Min = -10, Max = 0, Rounding = 1, Callback = function(v) _G.HitboxOffset = v end })
BlockRight:AddSlider("HitboxDuration", { Text = "持续时间", Default = 1.5, Min = 0.1, Max = 5.0, Rounding = 1, Callback = function(v) _G.HitboxDuration = v end })
BlockRight:AddSlider("BlockDelay", { Text = "格挡延迟", Default = 0, Min = 0, Max = 1, Rounding = 2, Callback = function(v) _G.BlockDelay = v end })

local TARGET_ANIMATION_ID = "100725497418533"
local DASHSTAB_ANIM_ID = "89448354637442"
local stabEnabledBackstab = false
local stabEnabledDashstab = false
local behindStuds = 4
local backstabDelay = 0.05
local backstabDuration = 0.5
local dashstabDelay = 0.25
local function getCharacter()
    return LP.Character or LP.CharacterAdded:Wait()
end
local function getFirstValidKiller()
    local killersFolder = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Killers")
    if not killersFolder then return nil end
    for _, inst in ipairs(killersFolder:GetDescendants()) do
        if inst:IsA("Model") then
            local hum = inst:FindFirstChildOfClass("Humanoid")
            local hrp = inst:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 then
                return inst
            end
        end
    end
    return nil
end
local function runBackstab()
    local char = getCharacter()
    local hrp = char:WaitForChild("HumanoidRootPart")
    task.wait(backstabDelay)
    local killer = getFirstValidKiller()
    if not killer or not char.Parent then return end
    local killerRoot = killer:FindFirstChild("HumanoidRootPart")
    if not killerRoot then return end
    local anchor = Instance.new("Part")
    anchor.Size = Vector3.new(1, 1, 1)
    anchor.Transparency = 1
    anchor.Anchored = true
    anchor.CanCollide = false
    anchor.Parent = Workspace
    local startTime = tick()
    while tick() - startTime < backstabDuration do
        if not char.Parent then break end
        anchor.CFrame = killerRoot.CFrame * CFrame.new(0, 0, behindStuds)
        hrp.CFrame = anchor.CFrame
        RunService.PreRender:Wait()
    end
    anchor:Destroy()
end
local function runDashstab()
    local char = getCharacter()
    task.wait(dashstabDelay)
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not char.Parent or not hrp then return end
    local killer = getFirstValidKiller()
    if not killer then return end
    local killerRoot = killer:FindFirstChild("HumanoidRootPart")
    if not killerRoot then return end
    local anchor = Instance.new("Part")
    anchor.Size = Vector3.new(1, 1, 1)
    anchor.Transparency = 1
    anchor.Anchored = true
    anchor.CanCollide = false
    anchor.Parent = Workspace
    local startTime = tick()
    while tick() - startTime < backstabDuration do
        if not char.Parent then break end
        anchor.CFrame = killerRoot.CFrame * CFrame.new(0, 0, behindStuds)
        hrp.CFrame = anchor.CFrame
        RunService.PreRender:Wait()
    end
    anchor:Destroy()
end
local function hookCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")
    local animator = humanoid:WaitForChild("Animator")
    animator.AnimationPlayed:Connect(function(track)
        if not track or not track.Animation then return end
        local id = tostring(track.Animation.AnimationId or ""):gsub("%D", "")
        if id == TARGET_ANIMATION_ID and stabEnabledBackstab then
            task.spawn(runBackstab)
        elseif id == DASHSTAB_ANIM_ID and stabEnabledDashstab then
            task.spawn(runDashstab)
        end
    end)
end
if LP.Character then hookCharacter(LP.Character) end
LP.CharacterAdded:Connect(hookCharacter)
local StabLeft = Tabs.背刺:AddLeftGroupbox("背刺", "sword")
StabLeft:AddToggle("EnableBackstab", { Text = "启用背刺", Default = false, Callback = function(v) stabEnabledBackstab = v end })
StabLeft:AddToggle("EnableDashstab", { Text = "启用冲刺背刺", Default = false, Callback = function(v) stabEnabledDashstab = v end })
local StabRight = Tabs.背刺:AddRightGroupbox("设置", "sliders")
StabRight:AddSlider("BehindStuds", { Text = "背后距离 (格数)", Default = 4, Min = 1, Max = 10, Rounding = 1, Callback = function(v) behindStuds = v end })
StabRight:AddSlider("BackstabDelay", { Text = "背刺启动延迟", Default = 0.05, Min = 0, Max = 0.5, Rounding = 2, Callback = function(v) backstabDelay = v end })
StabRight:AddSlider("BackstabDuration", { Text = "背刺持续时间", Default = 0.5, Min = 0.1, Max = 2, Rounding = 2, Callback = function(v) backstabDuration = v end })
StabRight:AddSlider("DashstabDelay", { Text = "冲刺背刺启动延迟", Default = 0.25, Min = 0, Max = 0.5, Rounding = 2, Callback = function(v) dashstabDelay = v end })

do
    local Sk8Player = LP
    local Sk8Workspace = Workspace
    local Sk8RunService = RunService
    local Sk8ReplicatedStorage = ReplicatedStorage
    local Sk8UserInputService = UserInputService
    local atEnabled = false
    local atActiveMonitors = {}
    local atDescendantAddedConn = nil
    local function atGetBehaviorFolder()
        return Sk8ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Survivors"):WaitForChild("Veeronica"):WaitForChild("Behavior")
    end
    local function atGetSprintingButton()
        return Sk8Player.PlayerGui:WaitForChild("MainUI"):WaitForChild("SprintingButton")
    end
    local atBehaviorFolder = nil
    task.spawn(function()
        local ok, f = pcall(atGetBehaviorFolder)
        if ok and f then atBehaviorFolder = f end
    end)
    local function atMonitorHighlight(h)
        if not h or atActiveMonitors[h] then return end
        local connections = {}
        local prevState = false
        local function cleanup()
            for _, conn in ipairs(connections) do
                if conn and conn.Connected then conn:Disconnect() end
            end
            atActiveMonitors[h] = nil
        end
        local function adorneeIsPlayer(hh)
            if not hh then return false end
            local adornee = hh.Adornee
            local char = Sk8Player.Character
            if not adornee or not char then return false end
            return adornee == char or adornee:IsDescendantOf(char)
        end
        local function onChanged()
            if not atEnabled then return end
            if not h or not h.Parent then cleanup(); return end
            local currState = adorneeIsPlayer(h)
            if prevState ~= currState then
                if currState then
                    local ok2, btn = pcall(atGetSprintingButton)
                    if ok2 and btn then
                        for _, v in pairs(getconnections(btn.MouseButton1Down)) do
                            pcall(function() v:Fire() end)
                        end
                    end
                end
            end
            prevState = currState
        end
        local c = h:GetPropertyChangedSignal("Adornee"):Connect(onChanged)
        if c then table.insert(connections, c) end
        table.insert(connections, h.AncestryChanged:Connect(function(_, parent)
            if not parent then cleanup() else onChanged() end
        end))
        atActiveMonitors[h] = cleanup
        task.spawn(onChanged)
    end
    local function atStartManager()
        if atDescendantAddedConn or not atBehaviorFolder then return end
        for _, desc in ipairs(atBehaviorFolder:GetDescendants()) do
            if desc:IsA("Highlight") then atMonitorHighlight(desc) end
        end
        atDescendantAddedConn = atBehaviorFolder.DescendantAdded:Connect(function(child)
            if child:IsA("Highlight") then atMonitorHighlight(child) end
        end)
    end
    local function atStopManager()
        if atDescendantAddedConn and atDescendantAddedConn.Connected then atDescendantAddedConn:Disconnect() end
        atDescendantAddedConn = nil
        for _, cleanup in pairs(atActiveMonitors) do
            if type(cleanup) == "function" then pcall(cleanup) end
        end
        atActiveMonitors = {}
    end
    local sk8Camera = Sk8Workspace.CurrentCamera
    local sk8ShiftlockEnabled = false
    local sk8ShiftConn = nil
    local function sk8SetShiftlock(state)
        sk8ShiftlockEnabled = state
        if sk8ShiftConn then sk8ShiftConn:Disconnect(); sk8ShiftConn = nil end
        if sk8ShiftlockEnabled then
            Sk8UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
            sk8ShiftConn = Sk8RunService.RenderStepped:Connect(function()
                local character = Sk8Player.Character
                local root = character and character:FindFirstChild("HumanoidRootPart")
                if root then
                    local camCF = sk8Camera.CFrame
                    root.CFrame = CFrame.new(root.Position, Vector3.new(camCF.LookVector.X + root.Position.X, root.Position.Y, camCF.LookVector.Z + root.Position.Z))
                end
            end)
        else
            Sk8UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        end
    end
    local sk8ChargeAnimIds = { "117058860640843" }
    local SK8_DASH_SPEED = 60
    local sk8ControlEnabled = false
    local sk8ControlActive = false
    local sk8OverrideConn = nil
    local sk8SavedHumState = {}
    local function sk8GetHumanoid()
        if not Sk8Player or not Sk8Player.Character then return nil end
        return Sk8Player.Character:FindFirstChildOfClass("Humanoid")
    end
    local function sk8SaveHumState(hum)
        if not hum or sk8SavedHumState[hum] then return end
        local s = {}
        pcall(function()
            s.WalkSpeed = hum.WalkSpeed
            local ok, ar = pcall(function() return hum.AutoRotate end)
            if ok then s.AutoRotate = ar end
        end)
        sk8SavedHumState[hum] = s
    end
    local function sk8RestoreHumState(hum)
        if not hum then return end
        local s = sk8SavedHumState[hum]
        if not s then return end
        pcall(function()
            if s.WalkSpeed ~= nil then hum.WalkSpeed = s.WalkSpeed end
            if s.AutoRotate ~= nil then pcall(function() hum.AutoRotate = s.AutoRotate end) end
        end)
        sk8SavedHumState[hum] = nil
    end
    local function sk8StartOverride()
        if sk8ControlActive then return end
        local hum = sk8GetHumanoid()
        if not hum then return end
        sk8ControlActive = true
        sk8SaveHumState(hum)
        pcall(function() hum.WalkSpeed = SK8_DASH_SPEED; hum.AutoRotate = false end)
        sk8SetShiftlock(true)
        sk8OverrideConn = Sk8RunService.RenderStepped:Connect(function()
            local humanoid = sk8GetHumanoid()
            local rootPart = humanoid and humanoid.Parent and humanoid.Parent:FindFirstChild("HumanoidRootPart")
            if not humanoid or not rootPart then return end
            pcall(function() humanoid.WalkSpeed = SK8_DASH_SPEED; humanoid.AutoRotate = false end)
            local direction = rootPart.CFrame.LookVector
            local horizontal = Vector3.new(direction.X, 0, direction.Z)
            if horizontal.Magnitude > 0 then humanoid:Move(horizontal.Unit) end
        end)
    end
    local function sk8StopOverride()
        if not sk8ControlActive then return end
        sk8ControlActive = false
        if sk8OverrideConn then pcall(function() sk8OverrideConn:Disconnect() end); sk8OverrideConn = nil end
        sk8SetShiftlock(false)
        local hum = sk8GetHumanoid()
        if hum then
            pcall(function()
                sk8RestoreHumState(hum)
                hum.AutoRotate = true
                hum:Move(Vector3.new(0,0,0))
            end)
        end
    end
    local function sk8DetectChargeAnim()
        local hum = sk8GetHumanoid()
        if not hum then return false end
        for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
            local ok, animId = pcall(function()
                return tostring(track.Animation and track.Animation.AnimationId or ""):match("%d+")
            end)
            if ok and animId and animId ~= "" then
                if table.find(sk8ChargeAnimIds, animId) then return true end
            end
        end
        return false
    end
    Sk8RunService.RenderStepped:Connect(function()
        if not sk8ControlEnabled then
            if sk8ControlActive then sk8StopOverride() end
            return
        end
        local hum = sk8GetHumanoid()
        if not hum then
            if sk8ControlActive then sk8StopOverride() end
            return
        end
        if sk8DetectChargeAnim() then
            if not sk8ControlActive then sk8StartOverride() end
        else
            if sk8ControlActive then sk8StopOverride() end
        end
    end)
    Sk8Player.CharacterAdded:Connect(function()
        if sk8ShiftConn then sk8ShiftConn:Disconnect(); sk8ShiftConn = nil end
        sk8SavedHumState = {}
    end)
    local SPRAY_ANIM_ID = "96618767275101"
    local veeFastSpray = false
    local sprayPhase = 0
    local sprayBaseCF = nil
    local spraySpeed = 4.5
    local function isSprayPainting()
        local char = Sk8Player.Character
        if not char then return false end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return false end
        for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
            local ok, id = pcall(function()
                return tostring(track.Animation and track.Animation.AnimationId or ""):match("%d+")
            end)
            if ok and id == SPRAY_ANIM_ID then return true end
        end
        return false
    end
    Sk8RunService.RenderStepped:Connect(function(dt)
        if not veeFastSpray then
            sprayPhase = 0
            sprayBaseCF = nil
            return
        end
        if not isSprayPainting() then
            sprayPhase = 0
            sprayBaseCF = nil
            return
        end
        local char = Sk8Player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if not sprayBaseCF or math.abs(math.sin(sprayPhase)) < 0.05 then
            sprayBaseCF = hrp.CFrame
        end
        sprayPhase = sprayPhase + dt * (math.pi * spraySpeed)
        local offset = math.sin(sprayPhase) * 2
        hrp.CFrame = sprayBaseCF + (sprayBaseCF.LookVector * (-offset))
    end)
    Sk8Player.CharacterAdded:Connect(function()
        sprayPhase = 0
        sprayBaseCF = nil
    end)
    local Sk8Tab = Tabs["滑板"]
    local Sk8Left = Sk8Tab:AddLeftGroupbox("主要", "zap")
    local Sk8Right = Sk8Tab:AddRightGroupbox("快速喷涂", "brush")
    Sk8Left:AddToggle("AutoTrick", { Text = "自动技巧", Default = false, Callback = function(state)
        atEnabled = state
        if state then
            if not atBehaviorFolder then
                local ok, f = pcall(atGetBehaviorFolder)
                if ok and f then atBehaviorFolder = f end
            end
            atStartManager()
        else
            atStopManager()
        end
    end })
    Sk8Left:AddToggle("Sk8Control", { Text = "启用滑板控制", Default = false, Callback = function(state)
        sk8ControlEnabled = state
        if not state and sk8ControlActive then sk8StopOverride() end
    end })
    Sk8Right:AddToggle("FastSpray", { Text = "启用快速喷涂", Default = false, Callback = function(state)
        veeFastSpray = state
        if not state then sprayPhase = 0; sprayBaseCF = nil end
    end })
    Sk8Right:AddSlider("SpraySpeed", { Text = "喷涂速度", Default = 4.5, Min = 0.5, Max = 10, Rounding = 1, Callback = function(val) spraySpeed = val end })
end

local EmotesGroup = Tabs.动作:AddLeftGroupbox("表情", "smile")
local svc = { RS = ReplicatedStorage, Run = RunService, TS = game:GetService("TweenService"), Input = UserInputService }
local lp = LP
local emState = { emoting = false, track = nil, spd = 16, jump = 50, rotConn = nil }
local function emStop()
    if not emState.emoting then return end
    emState.emoting = false
    if emState.rotConn then emState.rotConn:Disconnect(); emState.rotConn = nil end
    local ch = lp.Character
    if ch then
        local root = ch:FindFirstChild("HumanoidRootPart") or ch.PrimaryPart
        local hum  = ch:FindFirstChildOfClass("Humanoid")
        local vfx  = ch:FindFirstChild("PlayerEmoteVFX"); if vfx then vfx:Destroy() end
        if root then root.Anchored = false; local snd = root:FindFirstChild("EmoteSound"); if snd then snd:Destroy() end; local att = root:FindFirstChild("RootAttachment"); if att then att:Destroy() end end
        if hum then hum.WalkSpeed = emState.spd; hum.JumpPower = emState.jump end
    end
    if emState.track then pcall(function() emState.track:Stop() end); emState.track = nil end
end
local function emPlay(mod)
    if emState.emoting then emStop(); task.wait(0.1) end
    local ch = lp.Character; if not ch then return end
    local hum = ch:FindFirstChildOfClass("Humanoid")
    local root = ch:FindFirstChild("HumanoidRootPart") or ch.PrimaryPart
    local anim = hum and hum:WaitForChild("Animator", 2)
    if not hum or not root or not anim then return end
    local ok, data = pcall(require, mod)
    if not ok or not data.AssetID then return end
    emState.emoting = true; emState.spd = hum.WalkSpeed; emState.jump = hum.JumpPower
    hum.WalkSpeed = 0; hum.JumpPower = 0; root.Anchored = true
    local an = Instance.new("Animation"); an.AnimationId = tostring(data.AssetID)
    emState.track = anim:LoadAnimation(an); emState.track.Looped = true; emState.track:Play()
    if emState.rotConn then emState.rotConn:Disconnect() end
    emState.rotConn = svc.Run.RenderStepped:Connect(function()
        if not emState.emoting then return end
        local cam = Workspace.CurrentCamera; if not cam then return end
        local ch2 = lp.Character; if not ch2 then return end
        local r2 = ch2:FindFirstChild("HumanoidRootPart"); if not r2 then return end
        if lp.CameraMode ~= Enum.CameraMode.LockFirstPerson then return end
        local _, camY, _ = cam.CFrame:ToEulerAnglesYXZ()
        r2.CFrame = CFrame.new(r2.Position) * CFrame.Angles(0, camY, 0)
    end)
    if data.SFX then
        local old2 = root:FindFirstChild("EmoteSound"); if old2 then old2:Destroy() end
        local snd = Instance.new("Sound"); snd.Name = "EmoteSound"; snd.SoundId = tostring(data.SFX); snd.Volume = 1; snd.Looped = true; snd.Parent = root; snd:Play()
    end
    local att = Instance.new("Attachment"); att.Name = "RootAttachment"; att.Parent = root
    local burst = Instance.new("ParticleEmitter"); burst.Name = "EmoteBurst"; burst.Texture = "rbxassetid://635533604"; burst.Rate = 60; burst.Speed = NumberRange.new(2,5); burst.Lifetime = NumberRange.new(0.5,1.2); burst.Drag = 5; burst.Parent = att
    if string.lower(mod.Name) == "hakaridance" or string.lower(mod.Name) == "hakari" then
        local beamVFX = mod:FindFirstChild("HakariBeamEffect")
        if beamVFX then
            local v3 = beamVFX:Clone(); v3.Name = "PlayerEmoteVFX"; v3.CFrame = root.CFrame * CFrame.new(0,-1,-0.3)
            local weld = Instance.new("WeldConstraint"); weld.Part0 = root; weld.Part1 = v3; weld.Parent = v3; v3.Parent = ch
        end
    end
end
local emoteModules = {}
local EmFolderPath = svc.RS:FindFirstChild("Assets") and svc.RS.Assets:FindFirstChild("Emotes")
if EmFolderPath then
    for _, v in ipairs(EmFolderPath:GetDescendants()) do if v:IsA("ModuleScript") then table.insert(emoteModules, v) end end
    table.sort(emoteModules, function(a,b) return a.Name<b.Name end)
end
local emoteNames = {}
for _, mod in ipairs(emoteModules) do table.insert(emoteNames, mod.Name) end
local selectedEmote = emoteNames[1] or ""
EmotesGroup:AddDropdown("SelectedEmote", { Text = "选择表情", Values = emoteNames, Default = selectedEmote, Callback = function(val) selectedEmote = val end })
EmotesGroup:AddButton("播放表情", function()
    if selectedEmote == "" then return end
    for _, mod in ipairs(emoteModules) do if mod.Name == selectedEmote then emPlay(mod); break end end
end)
EmotesGroup:AddButton("停止表情", function() emStop() end)
lp.CharacterAdded:Connect(function() task.wait(0.5); if emState.emoting then emStop() end end)
lp.CharacterRemoving:Connect(function() if emState.emoting then emStop() end end)
local PlayerAnimGroup = Tabs.动作:AddRightGroupbox("玩家动画", "user")
local baseAnimations = {}
local animationEntries = {}
local function getAnimId(animValue) return animValue and tostring(animValue) or nil end
local function collectBaseAnimations()
    baseAnimations = {}
    local assets = svc.RS:FindFirstChild("Assets")
    if not assets then return end
    for _, roleType in ipairs({"Killers", "Survivors"}) do
        local folder = assets:FindFirstChild(roleType)
        if folder then
            for _, charFolder in ipairs(folder:GetChildren()) do
                if charFolder:IsA("Folder") then
                    local configScript = charFolder:FindFirstChild("Config")
                    if configScript and configScript:IsA("ModuleScript") then
                        local ok, data = pcall(require, configScript)
                        if ok and data and data.Animations then
                            local anims = data.Animations
                            baseAnimations[charFolder.Name] = { Idle = getAnimId(anims.Idle), Walk = getAnimId(anims.Walk), Run = getAnimId(anims.Run), DisplayName = data.DisplayName or charFolder.Name }
                        end
                    end
                end
            end
        end
    end
end
local function buildUniqueList()
    animationEntries = {}
    local seen = {}
    local function addEntry(name, idle, walk, run)
        local key = idle .. "|" .. walk .. "|" .. run
        if not seen[key] then table.insert(animationEntries, { Name = name, Idle = idle, Walk = walk, Run = run }); seen[key] = true end
    end
    for charName, data in pairs(baseAnimations) do addEntry(data.DisplayName or charName, data.Idle or "", data.Walk or "", data.Run or "") end
    local assets = svc.RS:FindFirstChild("Assets")
    if assets then
        local skinsFolder = assets:FindFirstChild("Skins")
        if skinsFolder then
            for _, roleType in ipairs({"Killers", "Survivors"}) do
                local skinRoleFolder = skinsFolder:FindFirstChild(roleType)
                if skinRoleFolder then
                    for _, charFolder in ipairs(skinRoleFolder:GetChildren()) do
                        if charFolder:IsA("Folder") then
                            local baseCharName = charFolder.Name
                            local baseData = baseAnimations[baseCharName]
                            for _, skinItem in ipairs(charFolder:GetChildren()) do
                                if skinItem:IsA("Folder") then
                                    local configScript = skinItem:FindFirstChild("Config")
                                    if configScript and configScript:IsA("ModuleScript") then
                                        local ok, data = pcall(require, configScript)
                                        if ok and data and data.Animations then
                                            local anims = data.Animations
                                            local idle = getAnimId(anims.Idle) or (baseData and baseData.Idle)
                                            local walk = getAnimId(anims.Walk) or (baseData and baseData.Walk)
                                            local run = getAnimId(anims.Run) or (baseData and baseData.Run)
                                            if idle and walk and run then
                                                local name = data.DisplayName or skinItem.Name
                                                addEntry(name, idle, walk, run)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
collectBaseAnimations()
buildUniqueList()
local animEntryNames = {}
for _, entry in ipairs(animationEntries) do table.insert(animEntryNames, entry.Name) end
local selectedEntry = animEntryNames[1] or ""
PlayerAnimGroup:AddDropdown("SelectedEntry", { Text = "选择动画", Values = animEntryNames, Default = selectedEntry, Callback = function(val) selectedEntry = val end })
local currentTracks = {}
local moveConn = nil
local function stopAnimations()
    if moveConn then moveConn:Disconnect(); moveConn = nil end
    for _, track in pairs(currentTracks) do if track then track:Stop(); track:Destroy() end end
    currentTracks = {}
end
local function applyAnimation()
    stopAnimations()
    local entry = nil
    for _, e in ipairs(animationEntries) do if e.Name == selectedEntry then entry = e; break end end
    if not entry then return end
    local char = lp.Character; if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then animator = Instance.new("Animator"); animator.Parent = hum end
    local loaded = {}
    local animTypes = {"Idle", "Walk", "Run"}
    for _, animType in ipairs(animTypes) do
        local id = entry[animType]
        if id and id ~= "" then
            local anim = Instance.new("Animation"); anim.AnimationId = id
            local track = animator:LoadAnimation(anim); track.Priority = Enum.AnimationPriority.Movement; loaded[animType] = track
        end
    end
    currentTracks = loaded
    moveConn = svc.Run.RenderStepped:Connect(function()
        if not (char and char.Parent) then stopAnimations(); return end
        local spd = hum.WalkSpeed; local dir = hum.MoveDirection.Magnitude
        local newTrack = nil
        if dir > 0.1 then
            if spd >= 20 then newTrack = loaded.Run or loaded.Walk else newTrack = loaded.Walk or loaded.Run end
        else newTrack = loaded.Idle end
        for _, track in pairs(loaded) do if track.IsPlaying and track ~= newTrack then track:Stop() end end
        if newTrack and not newTrack.IsPlaying then newTrack:Play() end
    end)
end
PlayerAnimGroup:AddButton("应用动画", applyAnimation)
PlayerAnimGroup:AddButton("停止动画", function() stopAnimations() end)
PlayerAnimGroup:AddButton("刷新列表", function() collectBaseAnimations(); buildUniqueList() end)
lp.CharacterAdded:Connect(function() task.wait(0.5); if next(currentTracks) then stopAnimations() end end)

do
    local tabMusic = Tabs["音乐"]
    local leftGroup = tabMusic:AddLeftGroupbox("LMS音乐", "music")
    local rightGroup = tabMusic:AddRightGroupbox("预览", "headphones")
    local musicTracks = {
        ["MADE JUST 4 U"] = "https://raw.githubusercontent.com/FixFox550/FixFox/refs/heads/main/IMG_7277.mp3",
        ["Hello"] = "https://raw.githubusercontent.com/FixFox550/FixFox/refs/heads/main/IMG_7280.mp3",
        ["APOCOOLYPSE"] = "https://raw.githubusercontent.com/FixFox550/FixFox/refs/heads/main/IMG_7282.mp3",
        ["A BRAVE SOUL"] = "https://raw.githubusercontent.com/FixFox550/FixFox/refs/heads/main/IMG_7283.mp3",
        ["Profitable Passion"] = "https://raw.githubusercontent.com/FixFox550/FixFox/refs/heads/main/IMG_7287.mp3",
        ["ARTIST BLOCK:Reprise"] = "https://raw.githubusercontent.com/FixFox550/FixFox/refs/heads/main/IMG_7290.mp3",
        ["Faith's Answer"] = "https://raw.githubusercontent.com/FixFox550/FixFox/refs/heads/main/IMG_7292.mp3",
        ["Teapot Palace"] = "https://raw.githubusercontent.com/FixFox550/FixFox/refs/heads/main/IMG_7295.mp3",
        ["Ready To Die"] = "https://raw.githubusercontent.com/FixFox550/FixFox/refs/heads/main/IMG_7309.mp3",
        ["Escape The Necrobloxians"] = "https://raw.githubusercontent.com/FixFox550/FixFox/refs/heads/main/Hwoowowow.mp3",
    }
    local musicList = {}
    for k in pairs(musicTracks) do table.insert(musicList, k) end
    table.sort(musicList)
    local musicDir = "FixsakenMusic"
    if not isfolder(musicDir) then makefolder(musicDir) end
    local music = {
        on = false,
        selected = musicList[1] or "",
        cached = {},
        origId = nil,
        thread = nil,
        lastSoundCheck = 0,
        cachedSound = nil,
        previewSound = nil,
    }
    local function musicTrackPath(name)
        return musicDir .. "/" .. name .. ".mp3"
    end
    local function musicHttpGet(url)
        local ok, data = pcall(function() return game:HttpGet(url) end)
        return ok and data or nil
    end
    local function musicFetch(name)
        if music.cached[name] then return music.cached[name] end
        local url = musicTracks[name]
        if not url then return nil end
        local path = musicTrackPath(name)
        if not isfile(path) then
            local data = musicHttpGet(url)
            if not data then return nil end
            writefile(path, data)
        end
        local ok, asset = pcall(function() return getcustomasset(path) end)
        if ok and asset then
            music.cached[name] = asset
            return asset
        end
        return nil
    end
    local musicFetchInFlight = {}
    local function musicFetchAsync(name, cb)
        if music.cached[name] then
            if cb then cb(music.cached[name]) end
            return
        end
        if musicFetchInFlight[name] then return end
        musicFetchInFlight[name] = true
        task.spawn(function()
            local asset = musicFetch(name)
            musicFetchInFlight[name] = nil
            if asset and cb then cb(asset) end
        end)
    end
    local function musicGetSound()
        local now = tick()
        if music.cachedSound and music.cachedSound.Parent and (now - music.lastSoundCheck) < 0.5 then
            return music.cachedSound
        end
        music.lastSoundCheck = now
        local snd = Workspace:FindFirstChild("Themes") and Workspace.Themes:FindFirstChild("LastSurvivor")
            or Workspace:FindFirstChild("LastSurvivor", true)
            or game:GetService("SoundService"):FindFirstChild("LastSurvivor", true)
        if snd and snd:IsA("Sound") then
            music.cachedSound = snd
            return snd
        end
        music.cachedSound = nil
        return nil
    end
    local function applyMusic(name)
        pcall(function()
            local snd = musicGetSound()
            if not snd then return end
            if not music.origId then music.origId = snd.SoundId end
            local asset = musicFetch(name)
            if not asset then return end
            if snd.SoundId ~= asset then
                snd.SoundId = asset
                snd:Stop()
                task.wait(0.05)
                snd:Play()
            elseif not snd.IsPlaying then
                snd:Play()
            end
        end)
    end
    local function musicReset()
        pcall(function()
            local snd = musicGetSound()
            if snd and music.origId then
                snd.SoundId = music.origId
                snd:Stop()
                task.wait(0.05)
                snd:Play()
            end
        end)
    end
    local function musicMonitor()
        while music.on do
            pcall(function()
                local snd = musicGetSound()
                if snd then
                    local asset = music.cached[music.selected]
                    if asset then
                        if snd.SoundId ~= asset then
                            if not music.origId then music.origId = snd.SoundId end
                            snd.SoundId = asset
                            snd:Stop()
                            task.wait(0.05)
                            snd:Play()
                        elseif not snd.IsPlaying then
                            snd:Play()
                        end
                    else
                        musicFetchAsync(music.selected, function(a)
                            applyMusic(music.selected)
                        end)
                    end
                end
            end)
            task.wait(1)
        end
    end
    local function previewStart(name)
        pcall(function()
            local asset = musicFetch(name)
            if not asset then
                Library:Notify({Title = "预览", Description = "加载歌曲失败", Time = 3})
                return
            end
            if music.previewSound then
                music.previewSound:Stop()
                music.previewSound:Destroy()
            end
            local sound = Instance.new("Sound")
            sound.Name = "FixsakenPreview"
            sound.SoundId = asset
            sound.Volume = 1
            sound.Parent = game:GetService("SoundService")
            sound:Play()
            music.previewSound = sound
            Library:Notify({Title = "预览", Description = "正在播放: " .. name, Time = 2})
        end)
    end
    local function previewStop()
        if music.previewSound then
            music.previewSound:Stop()
            music.previewSound:Destroy()
            music.previewSound = nil
            Library:Notify({Title = "预览", Description = "预览已停止", Time = 2})
        end
    end
    leftGroup:AddToggle("ApplyLMS", { Text = "应用LMS音乐", Default = false, Callback = function(on)
        pcall(function()
            music.on = on
            if on then
                musicFetchAsync(music.selected)
                music.thread = task.spawn(musicMonitor)
            else
                if music.thread then task.cancel(music.thread); music.thread = nil end
                musicReset()
            end
        end)
    end })
    leftGroup:AddDropdown("TrackSelect", { Text = "音轨", Values = musicList, Default = music.selected, Callback = function(sel)
        pcall(function()
            music.selected = type(sel) == "table" and sel[1] or sel
            task.spawn(function() musicFetchAsync(music.selected) end)
        end)
    end })
    leftGroup:AddButton("预加载LMS", function()
        pcall(function()
            for name in pairs(musicTracks) do
                musicFetchAsync(name)
                task.wait(0.05)
            end
            Library:Notify({Title = "音乐", Description = "预加载完成", Time = 2})
        end)
    end)
    rightGroup:AddButton("预览", function() pcall(function() previewStart(music.selected) end) end)
    rightGroup:AddButton("停止预览", function() pcall(function() previewStop() end) end)
end

local ImpersonateGroup = Tabs.杂项:AddLeftGroupbox("冒充", "user")
local FlipGroupMisc = Tabs.杂项:AddLeftGroupbox("前空翻", "flip")
local ChatGroupMisc = Tabs.杂项:AddLeftGroupbox("聊天", "message")
local AntiHiddenGroup = Tabs.杂项:AddRightGroupbox("反隐藏数据", "eye-off")
local KillerWallGroup = Tabs.杂项:AddRightGroupbox("杀手墙壁", "door")
local TimerPosGroup = Tabs.杂项:AddRightGroupbox("计时器位置", "clock")
local CameraGroupMisc = Tabs.杂项:AddRightGroupbox("摄像头", "camera")
local LightingGroupMisc = Tabs.杂项:AddRightGroupbox("光照", "sun")
local victimName = "Roblox"
ImpersonateGroup:AddInput("VictimInput", { Default = victimName, Numeric = false, Finished = false, ClearTextOnFocus = true, Text = "玩家用户名", Tooltip = "输入要冒充的玩家名称", Placeholder = "输入受害者名称...", Callback = function(Value) victimName = Value end })
ImpersonateGroup:AddButton({ Text = "冒充玩家", Func = function()
    if victimName == "" then Library:Notify({Title = "错误", Description = "请输入受害者名称", Time = 3}); return end
    pcall(function()
        local HttpService = game:GetService("HttpService")
        local localPlayer = LP
        local function getUserIdByUsername(username)
            local success, result = pcall(function() return game:HttpGet("https://users.roblox.com/v1/users/search?keyword=" .. username, true) end)
            if success then local data = HttpService:JSONDecode(result) if data and data.data and #data.data > 0 then return data.data[1].id, data.data[1].name, data.data[1].displayName end end
            return nil, nil, nil
        end
        local userId, userName, displayName = getUserIdByUsername(victimName)
        if not userId then Library:Notify({Title = "错误", Description = "未找到玩家", Time = 3}); return end
        local function applyCharacterAppearance(character, userId)
            local appearance = Players:GetCharacterAppearanceAsync(userId)
            for i,v in pairs(character:GetChildren()) do if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("BodyColors") then v:Destroy() end end
            for i,v in pairs(appearance:GetChildren()) do if v:IsA("Shirt") or v:IsA("Pants") or v:IsA("BodyColors") then v.Parent = character elseif v:IsA("Accessory") then character.Humanoid:AddAccessory(v) end end
            if appearance:FindFirstChild("face") then
                if character:WaitForChild("Head"):FindFirstChild("face") then character.Head.face:Destroy() end
                appearance.face.Parent = character.Head
            else
                if character:WaitForChild("Head"):FindFirstChild("face") then character.Head.face:Destroy() end
                local face = Instance.new("Decal"); face.Face = "Front"; face.Name = "face"; face.Texture = "rbxasset://textures/face.png"; face.Transparency = 0; face.Parent = character.Head
            end
            local parent = character.Parent; character.Parent = nil; character.Parent = parent
        end
        local function updatePlayerListName(newName)
            if localPlayer and localPlayer.PlayerGui and localPlayer.PlayerGui.MainUI and localPlayer.PlayerGui.MainUI.PlayerListHolder and localPlayer.PlayerGui.MainUI.PlayerListHolder.Contents and localPlayer.PlayerGui.MainUI.PlayerListHolder.Contents.Players then
                local myEntry = localPlayer.PlayerGui.MainUI.PlayerListHolder.Contents.Players[localPlayer.Name]
                if myEntry and myEntry.PlayerInfo and myEntry.PlayerInfo.Username then myEntry.PlayerInfo.Username.Text = newName end
            end
        end
        if not localPlayer.Character then localPlayer.CharacterAdded:Wait() end
        repeat task.wait() until localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid")
        localPlayer.Name = userName; localPlayer.UserId = userId; localPlayer.CharacterAppearanceId = userId; localPlayer.DisplayName = displayName
        localPlayer.Character.Name = userName
        if localPlayer.Character:FindFirstChild("Humanoid") then localPlayer.Character.Humanoid.DisplayName = displayName end
        applyCharacterAppearance(localPlayer.Character, userId)
        updatePlayerListName(displayName)
        localPlayer.CharacterAdded:Connect(function(character)
            task.wait(0.5)
            if character and character:FindFirstChild("Humanoid") then
                character.Name = userName
                if character:FindFirstChild("Humanoid") then character.Humanoid.DisplayName = displayName end
                applyCharacterAppearance(character, userId)
            end
        end)
        Library:Notify({Title = "成功", Description = string.format("已将名称更改为: %s\n并应用了 %s 的外观", displayName, victimName), Time = 3})
    end)
end, DoubleClick = false, Tooltip = "点击应用受害者的名称和外观到你的角色" })
local ffEnabled = false
local jumpHeight = 72
local jumpDistance = 35
local ffConn, ffBtnFrame = nil, nil
local function flip()
    if ffEnabled then return end; ffEnabled = true
    local char = LP.Character; if not char then ffEnabled = false return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then ffEnabled = false return end
    local saved = {}; local animator = hum:FindFirstChildOfClass("Animator")
    if animator then for _, track in ipairs(animator:GetPlayingAnimationTracks()) do saved[#saved + 1] = { track = track, time = track.TimePosition }; track:Stop(0) end end
    hum:ChangeState(Enum.HumanoidStateType.Physics)
    for _, state in ipairs({Enum.HumanoidStateType.FallingDown, Enum.HumanoidStateType.Freefall, Enum.HumanoidStateType.Running, Enum.HumanoidStateType.Seated, Enum.HumanoidStateType.Climbing}) do hum:SetStateEnabled(state, false) end
    local dur = 0.45; local steps = 120; local startCF = hrp.CFrame; local fwd = startCF.LookVector; local up = Vector3.new(0, 1, 0)
    task.spawn(function()
        local st = tick()
        for i = 1, steps do
            local t = i / steps; local h = jumpHeight * (t - t * t); local pos = startCF.Position + fwd * (jumpDistance * t) + up * h; local rot = startCF.Rotation * CFrame.Angles(-math.rad(i * (360 / steps)), 0, 0)
            hrp.CFrame = CFrame.new(pos) * rot
            local elapsed = tick() - st; local waitTime = (dur / steps) * i - elapsed; if waitTime > 0 then task.wait(waitTime) end
        end
        hrp.CFrame = CFrame.new(startCF.Position + fwd * jumpDistance) * startCF.Rotation
        for _, state in ipairs({Enum.HumanoidStateType.FallingDown, Enum.HumanoidStateType.Freefall, Enum.HumanoidStateType.Running, Enum.HumanoidStateType.Seated, Enum.HumanoidStateType.Climbing}) do hum:SetStateEnabled(state, true) end
        hum:ChangeState(Enum.HumanoidStateType.Running)
        if animator then for _, d in ipairs(saved) do d.track:Play(); d.track.TimePosition = d.time end end
        task.wait(0.25); ffEnabled = false
    end)
end
local function toggleFlipButton(v)
    if v then
        pcall(function()
            local sh = game.CoreGui.TopBarApp.TopBarApp.UnibarLeftFrame.UnibarMenu["2"]
            if not sh then return end
            local osize = sh.Size.X.Offset
            ffBtnFrame = Instance.new("Frame", sh); ffBtnFrame.Size = UDim2.new(0, 48, 0, 44); ffBtnFrame.BackgroundTransparency = 1; ffBtnFrame.Position = UDim2.new(0, sh.Size.X.Offset - 48, 0, 0)
            local ib = Instance.new("ImageButton", ffBtnFrame); ib.BackgroundTransparency = 1; ib.Size = UDim2.new(0, 36, 0, 36); ib.AnchorPoint = Vector2.new(0.5, 0.5); ib.Position = UDim2.new(0.5, 0, 0.5, 0); ib.Image = "rbxthumb://type=Asset&id=2714338264&w=150&h=150"
            ffConn = ib.Activated:Connect(flip)
            sh.Size = UDim2.new(0, osize + 48, 0, sh.Size.Y.Offset); ffBtnFrame.Position = UDim2.new(0, sh.Size.X.Offset - 48, 0, 0)
        end)
    else if ffConn then ffConn:Disconnect(); ffConn = nil end; if ffBtnFrame then ffBtnFrame:Destroy(); ffBtnFrame = nil end end
end
FlipGroupMisc:AddToggle("FlipButtonToggle", { Text = "显示空翻按钮", Default = false, Callback = function(v) toggleFlipButton(v) end })
FlipGroupMisc:AddSlider("JumpHeight", { Text = "跳跃高度", Default = 72, Min = 20, Max = 200, Rounding = 0, Callback = function(v) jumpHeight = v end })
FlipGroupMisc:AddSlider("JumpDistance", { Text = "跳跃距离", Default = 35, Min = 10, Max = 100, Rounding = 0, Callback = function(v) jumpDistance = v end })
ChatGroupMisc:AddToggle("AlwaysShowChat", { Text = "显示聊天", Default = false, Callback = function(state)
    if state then
        _G.showChat = true
        task.spawn(function() while _G.showChat and task.wait() do local chatConfig = game:GetService("TextChatService"):FindFirstChildOfClass("ChatWindowConfiguration") if chatConfig then chatConfig.Enabled = true end end end)
    else
        _G.showChat = false
        local playingState = LP:GetAttribute("PlayingState") or "Playing"
        if playingState ~= "Spectating" then local chatConfig = game:GetService("TextChatService"):FindFirstChildOfClass("ChatWindowConfiguration") if chatConfig then chatConfig.Enabled = false end end
    end
end })
local hiddenStatsEnabled = false
local originalValues = {}
local paths = {"HideKillerWins", "HidePlaytime", "HideSurvivorWins"}
local function saveOriginals(p)
    originalValues[p.UserId] = originalValues[p.UserId] or {}
    for _, k in ipairs(paths) do local v = p.PlayerData.Settings.Privacy:FindFirstChild(k) if v then originalValues[p.UserId][k] = v.Value end end
end
local function reveal(p) for _, k in ipairs(paths) do local v = p.PlayerData.Settings.Privacy:FindFirstChild(k) if v then v.Value = false end end end
local function restore(p)
    if not originalValues[p.UserId] then return end
    for k, val in pairs(originalValues[p.UserId]) do local v = p.PlayerData.Settings.Privacy:FindFirstChild(k) if v then v.Value = val end end
end
local function toggleHiddenStats(on)
    for _, p in ipairs(Players:GetPlayers()) do if on then saveOriginals(p); reveal(p) else restore(p) end end
end
Players.PlayerAdded:Connect(function(p) if hiddenStatsEnabled then saveOriginals(p); reveal(p) end end)
AntiHiddenGroup:AddToggle("AntiHiddenStatsToggle", { Text = "反隐藏数据", Default = false, Callback = function(v) hiddenStatsEnabled = v; toggleHiddenStats(v) end })
local function setKillerWalls(collide)
    for _, v in ipairs(Workspace:GetDescendants()) do if v.Name == "KillerDoors" then for _, wall in ipairs(v:GetChildren()) do if wall:IsA("BasePart") then wall.CanCollide = collide end end end end
end
KillerWallGroup:AddToggle("KillerWallsToggle", { Text = "禁用杀手墙壁", Default = false, Callback = function(v) setKillerWalls(not v) end })
local timerX = 0.5
local function applyTimerPos()
    local rt = LP.PlayerGui:FindFirstChild("RoundTimer"); local m = rt and rt:FindFirstChild("Main")
    if m then m.Position = UDim2.new(timerX, 0, m.Position.Y.Scale, m.Position.Y.Offset) end
end
applyTimerPos()
TimerPosGroup:AddSlider("TimerX", { Text = "计时器X位置", Default = 0.5, Min = 0, Max = 1, Rounding = 2, Callback = function(v) timerX = v; applyTimerPos() end })
LP.CharacterAdded:Connect(function() task.delay(1, applyTimerPos) end)
CameraGroupMisc:AddToggle("FreeZoom", { Text = "自由缩放", Default = false, Callback = function(v) LP.CameraMaxZoomDistance = v and math.huge or 12 end })
CameraGroupMisc:AddToggle("CameraNoclip", { Text = "摄像头穿墙", Default = false, Callback = function(v) LP.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode[v and "Invisicam" or "Zoom"] end })
local fovValueMisc = 70
CameraGroupMisc:AddSlider("FOVSlider", { Text = "视野范围", Default = 70, Min = 70, Max = 120, Rounding = 0, Callback = function(v) fovValueMisc = v; if _G.FOV then Workspace.CurrentCamera.FieldOfView = v end end })
CameraGroupMisc:AddToggle("FOVToggle", { Text = "启用视野调整", Default = false, Callback = function(v) _G.FOV = v; if v then Workspace.CurrentCamera.FieldOfView = fovValueMisc else Workspace.CurrentCamera.FieldOfView = 70 end end })
task.spawn(function() while true do if _G.FOV then Workspace.CurrentCamera.FieldOfView = fovValueMisc end task.wait() end end)
LightingGroupMisc:AddSlider("Brightness", { Text = "亮度", Default = 0, Min = 0, Max = 3, Rounding = 1, Callback = function(v) _G.Brightness = v; if _G.Fullbright then Lighting.Brightness = v end end })
LightingGroupMisc:AddToggle("NoShadows", { Text = "无阴影", Default = false, Callback = function(v) _G.GlobalShadows = v; if _G.Fullbright then Lighting.GlobalShadows = not v end end })
LightingGroupMisc:AddToggle("NoFog", { Text = "无雾", Default = false, Callback = function(v) _G.NoFog = v end })
LightingGroupMisc:AddToggle("EnableLighting", { Text = "启用光照", Default = false, Callback = function(v)
    _G.Fullbright = v
    if not v then
        Lighting.OutdoorAmbient = Color3.fromRGB(55, 55, 55); Lighting.Brightness = 0; Lighting.GlobalShadows = true
        local fog = Lighting:FindFirstChildOfClass("Atmosphere"); if fog and fog:GetAttribute("Density") then fog.Density = fog:GetAttribute("Density") end
        Lighting.FogStart = Lighting:GetAttribute("FogStart") or 0; Lighting.FogEnd = Lighting:GetAttribute("FogEnd") or 10000
    end
end })
task.spawn(function()
    while true do
        if _G.Fullbright then
            if not Lighting:GetAttribute("FogStart") then Lighting:SetAttribute("FogStart", Lighting.FogStart) end
            if not Lighting:GetAttribute("FogEnd") then Lighting:SetAttribute("FogEnd", Lighting.FogEnd) end
            local fog = Lighting:FindFirstChildOfClass("Atmosphere"); if fog and not fog:GetAttribute("Density") then fog:SetAttribute("Density", fog.Density) end
            Lighting.FogStart = _G.NoFog and 0 or Lighting:GetAttribute("FogStart"); Lighting.FogEnd = _G.NoFog and math.huge or Lighting:GetAttribute("FogEnd")
            if fog then fog.Density = _G.NoFog and 0 or fog:GetAttribute("Density") end
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1); Lighting.Brightness = _G.Brightness or 0; Lighting.GlobalShadows = not (_G.GlobalShadows or false)
        end
        task.wait()
    end
end)

local MenuGroup = Tabs["界面设置"]:AddLeftGroupbox("菜单", "wrench")
MenuGroup:AddToggle("KeybindMenuOpen", { Default = Library.KeybindFrame.Visible, Text = "打开快捷键菜单", Callback = function(value) Library.KeybindFrame.Visible = value end })
MenuGroup:AddToggle("ShowCustomCursor", { Text = "自定义光标", Default = true, Callback = function(Value) Library.ShowCustomCursor = Value end })
MenuGroup:AddDropdown("NotificationSide", { Values = { "左侧", "右侧" }, Default = "右侧", Text = "通知位置", Callback = function(Value) Library:SetNotifySide(Value) end })
MenuGroup:AddDropdown("DPIDropdown", { Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" }, Default = "100%", Text = "DPI缩放", Callback = function(Value) Value = Value:gsub("%%", ""); local DPI = tonumber(Value); Library:SetDPIScale(DPI) end })
MenuGroup:AddDivider()
MenuGroup:AddLabel("菜单快捷键"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "菜单快捷键" })
MenuGroup:AddButton("卸载", function() Library:Unload() end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
ThemeManager:SetDefaultTheme({ BackgroundColor = Color3.fromRGB(26, 26, 46), AccentColor = Color3.fromRGB(137, 180, 250), OutlineColor = Color3.fromRGB(49, 50, 68), FontColor = Color3.fromRGB(205, 214, 244), FontFace = Enum.Font.Jura })
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("MyScriptHub")
SaveManager:SetFolder("MyScriptHub/specific-game")
SaveManager:SetSubFolder("specific-place")
SaveManager:BuildConfigSection(Tabs["界面设置"])
ThemeManager:ApplyToTab(Tabs["界面设置"])
SaveManager:LoadAutoloadConfig()
Library:OnUnload(function() print("已卸载!") end)


local cloneref = (cloneref or clonereference or function(instance: any)
    return instance
end)
local CoreGui: CoreGui = cloneref(game:GetService("CoreGui"))
local Players: Players = cloneref(game:GetService("Players"))
local RunService: RunService = cloneref(game:GetService("RunService"))
local SoundService: SoundService = cloneref(game:GetService("SoundService"))
local UserInputService: UserInputService = cloneref(game:GetService("UserInputService"))
local TextService: TextService = cloneref(game:GetService("TextService"))
local Teams: Teams = cloneref(game:GetService("Teams"))
local TweenService: TweenService = cloneref(game:GetService("TweenService"))

local getgenv = getgenv or function()
    return shared
end
local setclipboard = setclipboard or nil
local protectgui = protectgui or (syn and syn.protect_gui) or function() end
local gethui = gethui or function()
    return CoreGui
end

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Mouse = cloneref(LocalPlayer:GetMouse())

local Labels = {}
local Buttons = {}
local Toggles = {}
local Options = {}
local Tooltips = {}

local BaseURL = "https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/"
local CustomImageManager = {}
local CustomImageManagerAssets = {
    TransparencyTexture = {
        RobloxId = 139785960036434,
        Path = "Obsidian/assets/TransparencyTexture.png",
        URL = BaseURL .. "assets/TransparencyTexture.png",

        Id = nil,
    },

    SaturationMap = {
        RobloxId = 4155801252,
        Path = "Obsidian/assets/SaturationMap.png",
        URL = BaseURL .. "assets/SaturationMap.png",

        Id = nil,
    },

    LoadingIcon = {
        RobloxId = 97544096941083,
        Path = "Obsidian/assets/LoadingIcon.png",
        URL = BaseURL .. "assets/LoadingIcon.png",

        Id = nil,
    },

    CheckIcon = {
        RobloxId = 97682394690683,
        Path = "Obsidian/assets/CheckIcon.png",
        URL = BaseURL .. "assets/CheckIcon.png",

        Id = nil,
    },
}
do
    local function RecursiveCreatePath(Path: string, IsFile: boolean?)
        if not isfolder or not makefolder then
            return
        end

        local Segments = Path:split("/")
        local TraversedPath = ""

        if IsFile then
            table.remove(Segments, #Segments)
        end

        for _, Segment in ipairs(Segments) do
            if not isfolder(TraversedPath .. Segment) then
                makefolder(TraversedPath .. Segment)
            end

            TraversedPath = TraversedPath .. Segment .. "/"
        end

        return TraversedPath
    end

    function CustomImageManager.AddAsset(
        AssetName: string,
        RobloxAssetId: number,
        URL: string,
        ForceRedownload: boolean?
    )
        if CustomImageManagerAssets[AssetName] ~= nil then
            error(string.format("Asset %q already exists", AssetName))
        end

        assert(typeof(RobloxAssetId) == "number", "RobloxAssetId must be a number")

        CustomImageManagerAssets[AssetName] = {
            RobloxId = RobloxAssetId,
            Path = string.format("Obsidian/custom_assets/%s", AssetName),
            URL = URL,

            Id = nil,
        }

        CustomImageManager.DownloadAsset(AssetName, ForceRedownload)
    end

    function CustomImageManager.GetAsset(AssetName: string)
        if not CustomImageManagerAssets[AssetName] then
            return nil
        end

        local AssetData = CustomImageManagerAssets[AssetName]
        if AssetData.Id then
            return AssetData.Id
        end

        local AssetID = string.format("rbxassetid://%s", AssetData.RobloxId)

        if getcustomasset then
            local Success, NewID = pcall(getcustomasset, AssetData.Path)

            if Success and NewID then
                AssetID = NewID
            end
        end

        AssetData.Id = AssetID
        return AssetID
    end

    function CustomImageManager.DownloadAsset(AssetName: string, ForceRedownload: boolean?)
        if not getcustomasset or not writefile or not isfile then
            return false, "missing functions"
        end

        local AssetData = CustomImageManagerAssets[AssetName]

        RecursiveCreatePath(AssetData.Path, true)

        if ForceRedownload ~= true and isfile(AssetData.Path) then
            return true, nil
        end

        local success, errorMessage = pcall(function()
            writefile(AssetData.Path, game:HttpGet(AssetData.URL))
        end)

        return success, errorMessage
    end

    for AssetName, _ in CustomImageManagerAssets do
        CustomImageManager.DownloadAsset(AssetName)
    end
end

local Library = {
    LocalPlayer = LocalPlayer,
    IsRobloxFocused = true,

    --// Device \\--
    DevicePlatform = nil,
    IsMobile = false,

    --// Obsidian Windows \\--
    ScreenGui = nil,
    Window = nil,
    WindowContainer = nil,

    --// Search \\--
    SearchText = "",
    Searching = false,
    GlobalSearch = false,
    LastSearchTab = nil,

    --// Tabs \\--
    ActiveTab = nil,
    Tabs = {},
    TabButtons = {},

    --// Dependency Boxes \\--
    DependencyBoxes = {},

    --// Keybinds Frame \\--
    KeybindFrame = nil,
    KeybindContainer = nil,
    KeybindToggles = {},

    --// Notifications \\--
    Notifications = {},
    NotifySide = "Right",
    NotifyTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),

    --// Dialogues \\--
    Dialogues = {},
    ActiveDialog = nil,

    --// Loading Window \\--
    ActiveLoading = nil,

    --// Corners \\--
    Corners = {},
    SpecificCorners = {},

    --// Animations \\--
    TweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),

    TabTransitionInfo = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    TabSwipeOffset = 26,
    TabSwipeFrom = "bottom",

    WindowAnimationInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    DropdownTransitionInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    KeyPickerTransitionInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),

    GroupboxTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    RotatingChevronTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),

    Animations = {
        ToggleWindow = false,
        TabSwitch = false,
        Groupbox = false,
        Dropdown = false,
        KeyPicker = false
    },

    --// States \\--
    Toggled = false,
    Unloaded = false,

    --// Elements \\--
    Labels = Labels,
    Buttons = Buttons,
    Toggles = Toggles,
    Options = Options,

    --// Options \\--
    ToggleKeybind = Enum.KeyCode.RightControl,
    ShowToggleFrameInKeybinds = true,

    NotifyOnError = false,
    ShowCustomCursor = true,
    ForceCheckbox = false,

    CantDragForced = false,
    DraggableElements = {},

    --// Signals \\--
    Signals = {},
    UnloadSignals = {},

    OriginalMinSize = Vector2.new(480, 360),
    MinSize = Vector2.new(480, 360),
    DPIScale = 1,
    CornerRadius = 4,

    --// Scheme \\--
    IsLightTheme = false,
    Scheme = {
        BackgroundColor = Color3.fromRGB(15, 15, 15),
        MainColor = Color3.fromRGB(25, 25, 25),
        AccentColor = Color3.fromRGB(125, 85, 255),
        OutlineColor = Color3.fromRGB(40, 40, 40),
        FontColor = Color3.new(1, 1, 1),
        Font = Font.fromEnum(Enum.Font.Code),

        RedColor = Color3.fromRGB(255, 50, 50),
        DestructiveColor = Color3.fromRGB(220, 38, 38),
        DarkColor = Color3.new(0, 0, 0),
        WhiteColor = Color3.new(1, 1, 1),

        BackgroundImage = ""
    },

    --// Registry \\--
    Registry = {},
	Scales = {},
	ScalesOffset = {},

    --// Misc \\--
    ImageManager = CustomImageManager,
    ShowCursorBinding = string.sub(tostring({}), 10),

    Notify = nil, Toggle = nil -- we love luau lsp
}

if RunService:IsStudio() then
    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
        Library.IsMobile = true
        Library.OriginalMinSize = Vector2.new(480, 240)
    else
        Library.IsMobile = false
        Library.OriginalMinSize = Vector2.new(480, 360)
    end
else
    pcall(function()
        Library.DevicePlatform = UserInputService:GetPlatform()
    end)

    Library.IsMobile = (Library.DevicePlatform == Enum.Platform.Android or Library.DevicePlatform == Enum.Platform.IOS)
    Library.OriginalMinSize = Library.IsMobile and Vector2.new(480, 240) or Vector2.new(480, 360)
end

local Templates = {
    --// UI \\--
    Frame = {
        BorderSizePixel = 0,
    },
    ImageLabel = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    },
    ImageButton = {
        AutoButtonColor = false,
        BorderSizePixel = 0,
    },
    ScrollingFrame = {
        BorderSizePixel = 0,
    },
    TextLabel = {
        BorderSizePixel = 0,
        FontFace = "Font",
        RichText = true,
        TextColor3 = "FontColor",
    },
    TextButton = {
        AutoButtonColor = false,
        BorderSizePixel = 0,
        FontFace = "Font",
        RichText = true,
        TextColor3 = "FontColor",
    },
    TextBox = {
        BorderSizePixel = 0,
        FontFace = "Font",
        PlaceholderColor3 = function()
            local H, S, V = Library.Scheme.FontColor:ToHSV()
            return Color3.fromHSV(H, S, V / 2)
        end,
        Text = "",
        TextColor3 = "FontColor",
    },
    UIListLayout = {
        SortOrder = Enum.SortOrder.LayoutOrder,
    },
    UIStroke = {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    },

    --// Library \\--
    Window = {
        Title = "No Title",
        Footer = "No Footer",

        Position = UDim2.fromOffset(6, 6),
        Size = UDim2.fromOffset(720, 600),
        IconSize = UDim2.fromOffset(30, 30),

        AutoShow = true,
        Center = true,
        Resizable = true,

        SearchbarSize = UDim2.fromScale(1, 1),
        GlobalSearch = false,

        CornerRadius = 4,
        NotifySide = "Right",
        ShowCustomCursor = true,

        Font = Enum.Font.Code,
        ToggleKeybind = Enum.KeyCode.RightControl,

        ShowMobileButtons = true,
        MobileButtonsSide = "Left",

        UnlockMouseWhileOpen = true,

        EnableSidebarResize = false,
        EnableCompacting = true,
        DisableCompactingSnap = false,
        SidebarCompacted = false,
        MinContainerWidth = 256,

        --// Snapping \\--
        MinSidebarWidth = 128,
        SidebarCompactWidth = 48,
        SidebarCollapseThreshold = 0.5,

        --// Dragging \\--
        CompactWidthActivation = 128,

        --// Background \\--
        BackgroundImage = "",

        --// Animations \\--
        Animations = {
            ToggleWindow = false,
            TabSwitch = false,
            Groupbox = false,
            Dropdown = false,
            KeyPicker = false
        },

        TabTransitionTime = 0.22,
        TabSwipeOffset = 26,
        TabSwipeFrom = "bottom"
    },
    Dialog = {
        Title = "Dialog",
        Description = "Description",
        AutoDismiss = true,
        OutsideClickDismiss = true,
        FooterButtons = {}
    },
    Loading = {
        Title = "mspaint",
        Icon = 95816097006870,
        IconSize = UDim2.fromOffset(30, 30),

        LoadingIcon = CustomImageManager.GetAsset("LoadingIcon"),
        LoadingIconColor = nil,
        LoadingIconTweenTime = 1,

        CurrentStep = 0,
        TotalSteps = 10,

        ShowSidebar = false,
        AutoResizeHeight = false,

        WindowWidth = 450,
        WindowHeight = 275,

        ContentWidth = 450,
        SidebarWidth = 250,
    },
    Toggle = {
        Text = "Toggle",
        Default = false,

        Callback = function() end,
        Changed = function() end,

        Risky = false,
        Disabled = false,
        Visible = true,
    },
    Input = {
        Text = "Input",
        Default = "",
        Finished = false,
        Numeric = false,
        ClearTextOnFocus = true,
        ClearTextOnBlur = false,
        Placeholder = "",
        AllowEmpty = true,
        EmptyReset = "---",

        Callback = function() end,
        Changed = function() end,
        VerifyValue = nil,

        Disabled = false,
        Visible = true,
    },
    Slider = {
        Text = "Slider",
        Default = 0,
        Min = 0,
        Max = 100,
        Rounding = 0,

        Prefix = "",
        Suffix = "",

        Callback = function() end,
        Changed = function() end,

        Disabled = false,
        Visible = true,

        AllowRightClickInput = true
    },
    Dropdown = {
        Values = {},
        DisabledValues = {},
        ValueImages = {},

        Multi = false,
        DragSelect = false,
        MaxVisibleDropdownItems = 8,

        Callback = function() end,
        Changed = function() end,

        Disabled = false,
        Visible = true,
    },
    Viewport = {
        Object = nil,
        Camera = nil,
        Clone = true,
        AutoFocus = true,
        Interactive = false,
        Height = 200,
        Visible = true,
    },
    Image = {
        Image = "",
        Transparency = 0,
        BackgroundTransparency = 0,
        Color = Color3.new(1, 1, 1),
        RectOffset = Vector2.zero,
        RectSize = Vector2.zero,
        ScaleType = Enum.ScaleType.Fit,
        Height = 200,
        Visible = true,
    },
    Video = {
        Video = "",
        Looped = false,
        Playing = false,
        Volume = 1,
        Height = 200,
        Visible = true,
    },
    UIPassthrough = {
        Instance = nil,
        Height = 24,
        Visible = true,
    },

    --// Addons \\-
    KeyPicker = {
        Text = "KeyPicker",

        Default = "None",
        DefaultModifiers = {},

        Blacklisted = {},
        BlacklistedModifiers = {},
        Whitelisted = {},
        WhitelistedModifiers = {},

        Mode = "Toggle",
        Modes = { "Always", "Toggle", "Hold" },
        SyncToggleState = false,

        Callback = function() end,
        ChangedCallback = function() end,
        Changed = function() end,
        Clicked = function() end,
    },
    ColorPicker = {
        Default = Color3.new(1, 1, 1),

        Callback = function() end,
        Changed = function() end,
    },
}

local Places = {
    Bottom = { 0, 1 },
    Right = { 1, 0 },
}
local Sizes = {
    Left = { 0.5, 1 },
    Right = { 0.5, 1 },
}

--// Scheme Functions \\--
local SchemeReplaceAlias = {
    RedColor = "Red",
    WhiteColor = "White",
    DarkColor = "Dark"
}

local SchemeAlias = {
    Red = "RedColor",
    White = "WhiteColor",
    Dark = "DarkColor"
}

local function GetSchemeValue(Index)
    if not Index then
        return nil
    end

    local ReplaceAliasIndex = SchemeReplaceAlias[Index]
    if ReplaceAliasIndex and Library.Scheme[ReplaceAliasIndex] ~= nil then
        Library.Scheme[Index] = Library.Scheme[ReplaceAliasIndex]
        Library.Scheme[ReplaceAliasIndex] = nil

        return Library.Scheme[Index]
    end

    local AliasIndex = SchemeAlias[Index]
    if AliasIndex and Library.Scheme[AliasIndex] ~= nil then
        warn(string.format("Scheme Value %q is deprecated, please use %q instead.", Index, AliasIndex))
        return Library.Scheme[AliasIndex]
    end

    return Library.Scheme[Index]
end

--// Basic Functions \\--
local function WaitForEvent(Event, Timeout, Condition)
    local Bindable = Instance.new("BindableEvent")
    local Connection = Event:Once(function(...)
        if not Condition or typeof(Condition) == "function" and Condition(...) then
            Bindable:Fire(true)
        else
            Bindable:Fire(false)
        end
    end)
    task.delay(Timeout, function()
        Connection:Disconnect()
        Bindable:Fire(false)
    end)

    local Result = Bindable.Event:Wait()
    Bindable:Destroy()

    return Result
end

local function IsMouseInput(Input: InputObject, IncludeM2: boolean?)
    return Input.UserInputType == Enum.UserInputType.MouseButton1
        or (IncludeM2 == true and Input.UserInputType == Enum.UserInputType.MouseButton2)
        or Input.UserInputType == Enum.UserInputType.Touch
end
local function IsClickInput(Input: InputObject, IncludeM2: boolean?)
    return IsMouseInput(Input, IncludeM2)
        and Input.UserInputState == Enum.UserInputState.Begin
        and Library.IsRobloxFocused
end
local function IsHoverInput(Input: InputObject)
    return (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)
        and Input.UserInputState == Enum.UserInputState.Change
end
local function IsDragInput(Input: InputObject, IncludeM2: boolean?)
    return IsMouseInput(Input, IncludeM2)
        and (Input.UserInputState == Enum.UserInputState.Begin or Input.UserInputState == Enum.UserInputState.Change)
        and Library.IsRobloxFocused
end
local function IsMouseClickInput(Input: InputObject)
    return Input.UserInputType == Enum.UserInputType.MouseButton1 or 
        Input.UserInputType == Enum.UserInputType.MouseButton2 or 
        Input.UserInputType == Enum.UserInputType.MouseButton3
end
local function IsMovementInput(Input: InputObject)
    return (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)
        and Library.IsRobloxFocused
end

local function GetTableSize(Table: { [any]: any })
    local Size = 0

    for _, _ in Table do
        Size += 1
    end

    return Size
end
local function StopTween(Tween: TweenBase, Destroy: boolean?)
    if not Tween then
        return
    end

    if Tween.PlaybackState == Enum.PlaybackState.Playing then
        Tween:Cancel()
    end

    if Destroy == true then
        pcall(Tween.Destroy, Tween)
    end
end
local function Trim(Text: string)
    return Text:match("^%s*(.-)%s*$")
end
local function Round(Value, Rounding)
    assert(Rounding >= 0, "Invalid rounding number.")

    if Rounding == 0 then
        return math.floor(Value)
    end

    return tonumber(string.format("%." .. Rounding .. "f", Value))
end

local function GetPlayers(ExcludeLocalPlayer: boolean?)
    local PlayerList = Players:GetPlayers()

    if ExcludeLocalPlayer then
        local Idx = table.find(PlayerList, LocalPlayer)
        if Idx then
            table.remove(PlayerList, Idx)
        end
    end

    table.sort(PlayerList, function(Player1, Player2)
        return Player1.Name:lower() < Player2.Name:lower()
    end)

    return PlayerList
end
local function GetTeams()
    local TeamList = Teams:GetTeams()

    table.sort(TeamList, function(Team1, Team2)
        return Team1.Name:lower() < Team2.Name:lower()
    end)

    return TeamList
end

function Library:UpdateDependencyBoxes()
    for _, Depbox in Library.DependencyBoxes do
        Depbox:Update(true)
    end

    if Library.Searching then
        Library:UpdateSearch(Library.SearchText)
    end
end

local function CheckDepbox(Box, Search)
    local VisibleElements = 0

    for _, ElementInfo in Box.Elements do
        if ElementInfo.Type == "Divider" then
            ElementInfo.Holder.Visible = false
            continue
        elseif ElementInfo.SubButton then
            --// Check if any of the Buttons Name matches with Search
            local Visible = false

            --// Check if Search matches Element's Name and if Element is Visible
            if ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then
                Visible = true
            else
                ElementInfo.Base.Visible = false
            end
            if ElementInfo.SubButton.Text:lower():match(Search) and ElementInfo.SubButton.Visible then
                Visible = true
            else
                ElementInfo.SubButton.Base.Visible = false
            end
            ElementInfo.Holder.Visible = Visible
            if Visible then
                VisibleElements += 1
            end

            continue
        end

        --// Check if Search matches Element's Name and if Element is Visible
        if ElementInfo.Text and ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then
            ElementInfo.Holder.Visible = true
            VisibleElements += 1
        else
            ElementInfo.Holder.Visible = false
        end
    end

    for _, Depbox in Box.DependencyBoxes do
        if not Depbox.Visible then
            continue
        end

        VisibleElements += CheckDepbox(Depbox, Search)
    end

    Box.Holder.Visible = VisibleElements > 0
    return VisibleElements
end
local function RestoreDepbox(Box)
    for _, ElementInfo in Box.Elements do
        ElementInfo.Holder.Visible = ElementInfo.Visible ~= false

        if ElementInfo.SubButton then
            ElementInfo.Base.Visible = ElementInfo.Visible
            ElementInfo.SubButton.Base.Visible = ElementInfo.SubButton.Visible
        end
    end

    Box:Resize()
    Box.Holder.Visible = true

    for _, Depbox in Box.DependencyBoxes do
        if not Depbox.Visible then
            continue
        end

        RestoreDepbox(Depbox)
    end
end

local function ApplySearchToTab(Tab, Search)
    if not Tab then
        return
    end

    local HasVisible = false

    --// Loop through Groupboxes to get Elements Info
    for _, Groupbox in Tab.Groupboxes do
        if Groupbox.Visible == false then
            continue
        end

        local VisibleElements = 0
        for _, ElementInfo in Groupbox.Elements do
            if ElementInfo.Type == "Divider" then
                ElementInfo.Holder.Visible = false
                continue
            elseif ElementInfo.SubButton then
                --// Check if any of the Buttons Name matches with Search
                local Visible = false

                --// Check if Search matches Element's Name and if Element is Visible
                if ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then
                    Visible = true
                else
                    ElementInfo.Base.Visible = false
                end
                if ElementInfo.SubButton.Text:lower():match(Search) and ElementInfo.SubButton.Visible then
                    Visible = true
                else
                    ElementInfo.SubButton.Base.Visible = false
                end
                ElementInfo.Holder.Visible = Visible

                if Visible then
                    VisibleElements += 1
                end

                continue
            end

            --// Check if Search matches Element's Name and if Element is Visible
            if ElementInfo.Text and ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then
                ElementInfo.Holder.Visible = true
                VisibleElements += 1
            else
                ElementInfo.Holder.Visible = false
            end
        end

        for _, Depbox in Groupbox.DependencyBoxes do
            if not Depbox.Visible then
                continue
            end

            VisibleElements += CheckDepbox(Depbox, Search)
        end

        --// Update Groupbox Size and Visibility if found any element
        if VisibleElements > 0 then
            Groupbox:Resize()
            HasVisible = true
        end
        Groupbox.BoxHolder.Visible = VisibleElements > 0
    end

    for _, Tabbox in Tab.Tabboxes do
        local VisibleTabs = 0
        local VisibleElements = {}

        for _, SubTab in Tabbox.Tabs do
            VisibleElements[SubTab] = 0

            for _, ElementInfo in SubTab.Elements do
                if ElementInfo.Type == "Divider" then
                    ElementInfo.Holder.Visible = false
                    continue
                elseif ElementInfo.SubButton then
                    --// Check if any of the Buttons Name matches with Search
                    local Visible = false

                    --// Check if Search matches Element's Name and if Element is Visible
                    if ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then
                        Visible = true
                    else
                        ElementInfo.Base.Visible = false
                    end
                    if ElementInfo.SubButton.Text:lower():match(Search) and ElementInfo.SubButton.Visible then
                        Visible = true
                    else
                        ElementInfo.SubButton.Base.Visible = false
                    end
                    ElementInfo.Holder.Visible = Visible
                    if Visible then
                        VisibleElements[SubTab] += 1
                    end

                    continue
                end

                --// Check if Search matches Element's Name and if Element is Visible
                if ElementInfo.Text and ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then
                    ElementInfo.Holder.Visible = true
                    VisibleElements[SubTab] += 1
                else
                    ElementInfo.Holder.Visible = false
                end
            end

            for _, Depbox in SubTab.DependencyBoxes do
                if not Depbox.Visible then
                    continue
                end

                VisibleElements[SubTab] += CheckDepbox(Depbox, Search)
            end
        end

        for SubTab, Visible in VisibleElements do
            SubTab.ButtonHolder.Visible = Visible > 0
            if Visible > 0 then
                VisibleTabs += 1
                HasVisible = true

                if Tabbox.ActiveTab == SubTab then
                    SubTab:Resize()
                elseif Tabbox.ActiveTab and VisibleElements[Tabbox.ActiveTab] == 0 then
                    SubTab:Show()
                end
            end
        end

        --// Update Tabbox Visibility if any visible
        Tabbox.BoxHolder.Visible = VisibleTabs > 0
    end

    return HasVisible
end
local function ResetTab(Tab)
    if not Tab then
        return
    end

    for _, Groupbox in Tab.Groupboxes do
        for _, ElementInfo in Groupbox.Elements do
            ElementInfo.Holder.Visible = ElementInfo.Visible ~= false

            if ElementInfo.SubButton then
                ElementInfo.Base.Visible = ElementInfo.Visible
                ElementInfo.SubButton.Base.Visible = ElementInfo.SubButton.Visible
            end
        end

        for _, Depbox in Groupbox.DependencyBoxes do
            if not Depbox.Visible then
                continue
            end

            RestoreDepbox(Depbox)
        end

        Groupbox:Resize()
        Groupbox.BoxHolder.Visible = Groupbox.Visible ~= false
    end

    for _, Tabbox in Tab.Tabboxes do
        for _, SubTab in Tabbox.Tabs do
            for _, ElementInfo in SubTab.Elements do
                ElementInfo.Holder.Visible = ElementInfo.Visible ~= false

                if ElementInfo.SubButton then
                    ElementInfo.Base.Visible = ElementInfo.Visible
                    ElementInfo.SubButton.Base.Visible = ElementInfo.SubButton.Visible
                end
            end

            for _, Depbox in SubTab.DependencyBoxes do
                if not Depbox.Visible then
                    continue
                end

                RestoreDepbox(Depbox)
            end

            SubTab.ButtonHolder.Visible = true
        end

        if Tabbox.ActiveTab then
            Tabbox.ActiveTab:Resize()
        end
        Tabbox.BoxHolder.Visible = true
    end
end

function Library:UpdateSearch(SearchText)
    Library.SearchText = SearchText

    local TabsToReset = {}

    if Library.GlobalSearch then
        for _, Tab in Library.Tabs do
            if typeof(Tab) == "table" and not Tab.IsKeyTab then
                table.insert(TabsToReset, Tab)
            end
        end
    elseif Library.LastSearchTab and typeof(Library.LastSearchTab) == "table" then
        table.insert(TabsToReset, Library.LastSearchTab)
    end

    for _, Tab in ipairs(TabsToReset) do
        ResetTab(Tab)
    end

    local Search = SearchText:lower()
    if Trim(Search) == "" then
        Library.Searching = false
        Library.LastSearchTab = nil
        return
    end
    if not Library.GlobalSearch and Library.ActiveTab and Library.ActiveTab.IsKeyTab then
        Library.Searching = false
        Library.LastSearchTab = nil
        return
    end

    Library.Searching = true

    local TabsToSearch = {}

    if Library.GlobalSearch then
        TabsToSearch = TabsToReset
        if #TabsToSearch == 0 then
            for _, Tab in Library.Tabs do
                if typeof(Tab) == "table" and not Tab.IsKeyTab then
                    table.insert(TabsToSearch, Tab)
                end
            end
        end
    elseif Library.ActiveTab then
        table.insert(TabsToSearch, Library.ActiveTab)
    end

    local FirstVisibleTab = nil
    local ActiveHasVisible = false

    for _, Tab in ipairs(TabsToSearch) do
        local HasVisible = ApplySearchToTab(Tab, Search)
        if HasVisible then
            if not FirstVisibleTab then
                FirstVisibleTab = Tab
            end
            if Tab == Library.ActiveTab then
                ActiveHasVisible = true
            end
        end
    end

    if Library.GlobalSearch then
        if ActiveHasVisible and Library.ActiveTab then
            Library.ActiveTab:RefreshSides()
        elseif FirstVisibleTab then
            local SearchMarker = SearchText
            task.defer(function()
                if Library.SearchText ~= SearchMarker then
                    return
                end

                if Library.ActiveTab ~= FirstVisibleTab then
                    FirstVisibleTab:Show()
                end
            end)
        end
        Library.LastSearchTab = nil
    else
        Library.LastSearchTab = Library.ActiveTab
    end
end

function Library:AddToRegistry(Instance, Properties)
    Library.Registry[Instance] = Properties
end

function Library:RemoveFromRegistry(Instance)
    Library.Registry[Instance] = nil
end

function Library:UpdateColorsUsingRegistry()
    for Instance, Properties in Library.Registry do
        for Property, Index in Properties do
            local SchemeValue = GetSchemeValue(Index)

            if SchemeValue or typeof(Index) == "function" then
                Instance[Property] = SchemeValue or Index()
            end
        end
    end
end

function Library:SetDPIScale(DPIScale: number)
    Library.DPIScale = DPIScale / 100
    Library.MinSize = Library.OriginalMinSize * Library.DPIScale

	for _, UIScale in Library.Scales do
        UIScale.Scale = Library.DPIScale - (tonumber(Library.ScalesOffset[UIScale]) or 0)
    end

    for _, Option in Options do
        if Option.Type == "Dropdown" then
            Option:RecalculateListSize()
        end
    end

    for _, Notification in Library.Notifications do
        Notification:Resize()
    end

    Library:UpdateNotificationPositions(true)
end

function Library:GiveSignal(Connection: RBXScriptConnection | RBXScriptSignal)
    local ConnectionType = typeof(Connection)
    if Connection and (ConnectionType == "RBXScriptConnection" or ConnectionType == "RBXScriptSignal") then
        table.insert(Library.Signals, Connection)
    end

    return Connection
end

function IsValidCustomIcon(Icon: string)
    return typeof(Icon) == "string" and (Icon:match("^rbxasset://textures/") or Icon:match("roblox%.com/asset/%?id=") or Icon:match("rbxthumb://type="))
end

local function IsCustomAssetIcon(Icon: string, IncludeAssetId: boolean)
    return typeof(Icon) == "string" and (Icon:match("^content://") or (Icon:match("^rbxasset://%x+/") or Icon:match("^rbxasset://[^/]+/")) or (IncludeAssetId == true and Icon:match("^rbxassetid://")))
end

type Icon = {
    Url: string,
    Id: number,
    IconName: string,
    ImageRectOffset: Vector2,
    ImageRectSize: Vector2,
}

type IconModule = {
    Icons: { string },
    GetAsset: (Name: string) -> Icon?,
}

local FetchIcons, Icons = pcall(function()
    return (loadstring(
        game:HttpGet("https://raw.githubusercontent.com/mstudio45/lucide-roblox-direct/refs/heads/main/source.lua")
    ) :: () -> IconModule)()
end)

function Library:GetIcon(IconName: string)
    if not FetchIcons or not Icons then
        return
    end

    local Success, Icon = pcall(Icons.GetAsset, IconName)
    if not Success then
        return
    end
    
    return Icon
end

function Library:GetCustomIcon(IconName: string): any
    if not IconName then
        return nil
    end

    if tonumber(IconName) then
        IconName = string.format("rbxassetid://%s", tostring(IconName))
    end

    if IsCustomAssetIcon(IconName, true) then
        return {
            Url = IconName,
            ImageRectOffset = Vector2.zero,
            ImageRectSize = Vector2.zero,
        }
    elseif IsValidCustomIcon(IconName) then
        return {
            Url = IconName,
            ImageRectOffset = Vector2.zero,
            ImageRectSize = Vector2.zero,
            Custom = true,
        }
    end

    local LucideIcon = Library:GetIcon(IconName)
    if LucideIcon then
        return LucideIcon
    end

    return nil
end

function Library:Validate(Table: { [string]: any }, Template: { [string]: any }): { [string]: any }
    if typeof(Table) ~= "table" then
        return Template
    end

    for k, v in Template do
        if typeof(k) == "number" then
            continue
        end

        if typeof(v) == "table" then
            Table[k] = Library:Validate(Table[k], v)
        elseif Table[k] == nil then
            Table[k] = v
        end
    end

    return Table
end

--// Creator Functions \\--
local function FillInstance(Table: { [string]: any }, Instance: GuiObject)
    local ThemeProperties = Library.Registry[Instance] or {}

    for key, value in Table do
        if key ~= "Text" then
            local SchemeValue = GetSchemeValue(value)

            if SchemeValue or typeof(value) == "function" then
                ThemeProperties[key] = value
                value = SchemeValue or value()
            else
                ThemeProperties[key] = nil
            end
        end

        Instance[key] = value
    end

    if GetTableSize(ThemeProperties) > 0 then
        Library.Registry[Instance] = ThemeProperties
    end
end

local function New(ClassName: string, Properties: { [string]: any }): any
    local Instance = Instance.new(ClassName)

    if Templates[ClassName] then
        FillInstance(Templates[ClassName], Instance)
    end
    FillInstance(Properties, Instance)

    if Properties["Parent"] and not Properties["ZIndex"] then
        pcall(function()
            Instance.ZIndex = Properties.Parent.ZIndex
        end)
    end

    return Instance
end

--// Main Instances \\-
local function SafeParentUI(Instance: Instance, Parent: Instance | () -> Instance)
    local success, _error = pcall(function()
        if not Parent then
            Parent = CoreGui
        end

        local DestinationParent
        if typeof(Parent) == "function" then
            DestinationParent = Parent()
        else
            DestinationParent = Parent
        end

        Instance.Parent = DestinationParent
    end)

    if not (success and Instance.Parent) then
        Instance.Parent = Library.LocalPlayer:WaitForChild("PlayerGui", math.huge)
    end
end

local function ParentUI(UI: Instance, SkipHiddenUI: boolean?)
    if SkipHiddenUI then
        SafeParentUI(UI, CoreGui)
        return
    end

    pcall(protectgui, UI)
    SafeParentUI(UI, gethui)
end

local ScreenGui = New("ScreenGui", {
    Name = "Obsidian",
    DisplayOrder = 998,
    ResetOnSpawn = false,
})
ParentUI(ScreenGui)
Library.ScreenGui = ScreenGui

ScreenGui.DescendantRemoving:Connect(function(Instance)
    Library:RemoveFromRegistry(Instance)
end)

local ModalElement = New("TextButton", {
    BackgroundTransparency = 1,
    Modal = false,
    Size = UDim2.fromScale(0, 0),
    AnchorPoint = Vector2.zero,
    Text = "",
    ZIndex = -999,
    Parent = ScreenGui,
})

--// Cursor
local Cursor, CursorCustomImage
do
    Cursor = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = "WhiteColor",
        Size = UDim2.fromOffset(9, 1),
        Visible = false,
        ZIndex = 11000,
        Parent = ScreenGui,
    })
    New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = "DarkColor",
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, 2, 1, 2),
        ZIndex = 10999,
        Parent = Cursor,
    })

    local CursorV = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = "WhiteColor",
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(1, 9),
        ZIndex = 11000,
        Parent = Cursor,
    })
    New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = "DarkColor",
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, 2, 1, 2),
        ZIndex = 10999,
        Parent = CursorV,
    })

    CursorCustomImage = New("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(20, 20),
        ZIndex = 11000,
        Visible = false,
        Parent = Cursor
    })
end

--// Notification \\--
local NotificationArea
local NotifyOrder = {}
do
    NotificationArea = New("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -6, 0, 6),
        Size = UDim2.new(0, 300, 1, -6),
        Parent = ScreenGui,
    })
    table.insert(
        Library.Scales,
        New("UIScale", {
            Parent = NotificationArea,
        })
    )
end

--// Lib Functions \\--
function Library:ResetCursorIcon()
    CursorCustomImage.Visible = false
    CursorCustomImage.Size = UDim2.fromOffset(20, 20)
end

function Library:ChangeCursorIcon(ImageId: string)
    if not ImageId or ImageId == "" then
        Library:ResetCursorIcon()
        return
    end

    local Icon = Library:GetCustomIcon(ImageId)
    assert(Icon, "Image must be a valid Roblox asset or a valid URL or a valid lucide icon.")

    CursorCustomImage.Visible = true
    CursorCustomImage.Image = Icon.Url
    CursorCustomImage.ImageRectOffset = Icon.ImageRectOffset
    CursorCustomImage.ImageRectSize = Icon.ImageRectSize
end

function Library:ChangeCursorIconSize(Size: UDim2)
    assert(typeof(Size) == "UDim2", "UDim2 expected.")
    CursorCustomImage.Size = Size
end

function Library:GetBetterColor(Color: Color3, Add: number): Color3
    Add = Add * (Library.IsLightTheme and -4 or 2)
    return Color3.fromRGB(
        math.clamp(Color.R * 255 + Add, 0, 255),
        math.clamp(Color.G * 255 + Add, 0, 255),
        math.clamp(Color.B * 255 + Add, 0, 255)
    )
end

function Library:GetLighterColor(Color: Color3): Color3
    local H, S, V = Color:ToHSV()
    return Color3.fromHSV(H, math.max(0, S - 0.1), math.min(1, V + 0.1))
end

function Library:GetDarkerColor(Color: Color3): Color3
    local H, S, V = Color:ToHSV()
    return Color3.fromHSV(H, S, V / 2)
end

function Library:GetKeyString(KeyCode: Enum.KeyCode)
    if KeyCode.EnumType == Enum.KeyCode and KeyCode.Value > 33 and KeyCode.Value < 127 then
        return string.char(KeyCode.Value)
    end

    return KeyCode.Name
end

function Library:GetTextBounds(Text: string, Font: Font, Size: number, Width: number?): (number, number)
    local Params = Instance.new("GetTextBoundsParams")
    Params.Text = Text
    Params.RichText = true
    Params.Font = Font
    Params.Size = Size
    Params.Width = Width or workspace.CurrentCamera.ViewportSize.X - 32

    local Bounds = TextService:GetTextBoundsAsync(Params)
    return Bounds.X, Bounds.Y
end

function Library:MouseIsOverFrame(Frame: GuiObject, Mouse: Vector2): boolean
    local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize
    return Mouse.X >= AbsPos.X
        and Mouse.X <= AbsPos.X + AbsSize.X
        and Mouse.Y >= AbsPos.Y
        and Mouse.Y <= AbsPos.Y + AbsSize.Y
end

function Library:IsInsideFrame(ParentFrame: GuiObject, Frame: GuiObject)
    local GuiPos = Frame.AbsolutePosition
	local GuiSize = Frame.AbsoluteSize

	local FramePos = ParentFrame.AbsolutePosition
	local FrameSize = ParentFrame.AbsoluteSize

	return GuiPos.X >= FramePos.X
		and GuiPos.X + GuiSize.X <= FramePos.X + FrameSize.X
		and GuiPos.Y >= FramePos.Y
		and GuiPos.Y + GuiSize.Y <= FramePos.Y + FrameSize.Y
end

function Library:SafeCallback(Func: (...any) -> ...any, ...: any)
    if not (Func and typeof(Func) == "function") then
        return
    end

    local Result = table.pack(xpcall(Func, function(Error)
        task.defer(error, debug.traceback(Error, 2))
        if Library.NotifyOnError and Library.Notify then
            Library:Notify(Error)
        end

        return Error
    end, ...))

    if not Result[1] then
        return nil
    end

    return table.unpack(Result, 2, Result.n)
end

function GetOverlappingDraggable(UI: GuiObject, TargetPos: Vector2?)
    local Pos1 = TargetPos or UI.AbsolutePosition
    local Size1 = UI.AbsoluteSize
    
    for _, Other in ipairs(Library.DraggableElements) do
        if Other == UI or not Other.Visible or not Other.Parent then
            continue
        end

        local Pos2 = Other.AbsolutePosition
        local Size2 = Other.AbsoluteSize
        
        if Pos1.X < Pos2.X + Size2.X and
            Pos1.X + Size1.X > Pos2.X and
            Pos1.Y < Pos2.Y + Size2.Y and
            Pos1.Y + Size1.Y > Pos2.Y then
            return Other
        end
    end
    
    return nil
end

function GetNonOverlappingPosition(UI: GuiObject, StartPos: UDim2?)
    local ScreenSize = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)) - Vector2.new(100, 100)
    local Start = StartPos and Vector2.new(StartPos.X.Offset, StartPos.Y.Offset) or Vector2.new(6, 6)
    local Padding = 6
    
    local CurrentX = Start.X
    local CurrentY = Start.Y
    
    local Size = UI.AbsoluteSize
    if Size.X == 0 and Size.Y == 0 then
        RunService.RenderStepped:Wait()
        Size = UI.AbsoluteSize
    end
    
    if Size.X == 0 then Size = Vector2.new(150, 40) end

    local MaxXInColumn = Size.X

    while true do
        local Obstacle = GetOverlappingDraggable(UI, Vector2.new(CurrentX, CurrentY))
        if not Obstacle then
            break
        end
        
        if Obstacle.AbsoluteSize.X > MaxXInColumn then
            MaxXInColumn = Obstacle.AbsoluteSize.X
        end
        
        local NextY = Obstacle.AbsolutePosition.Y + Obstacle.AbsoluteSize.Y + Padding
        if NextY + Size.Y > ScreenSize.Y - Padding then
            local NextX = CurrentX + MaxXInColumn + Padding
            
            if NextX + Size.X > ScreenSize.X - Padding then
                break
            end
            
            CurrentY = Start.Y
            CurrentX = NextX
            MaxXInColumn = Size.X
        else
            CurrentY = NextY
        end
    end
    
    return UDim2.fromOffset(CurrentX, CurrentY)
end

function PositionDraggable(UI: GuiObject, StartPos: UDim2?)
    UI.Position = GetNonOverlappingPosition(UI, StartPos)
end

function Library:MakeDraggable(UI: GuiObject, DragFrame: GuiObject, IgnoreToggled: boolean?, IsMainWindow: boolean?)
    local StartPos
    local FramePos
    local Dragging = false
    local Changed
    local InputBegan
    local InputChanged

    InputBegan = DragFrame.InputBegan:Connect(function(Input: InputObject)
        if not IsClickInput(Input) or IsMainWindow and Library.CantDragForced then
            return
        end

        StartPos = Input.Position
        FramePos = UI.Position
        Dragging = true

        Changed = Input.Changed:Connect(function()
            if Input.UserInputState ~= Enum.UserInputState.End then
                return
            end

            Dragging = false
            if Changed and Changed.Connected then
                Changed:Disconnect()
                Changed = nil
            end
        end)
    end)

    InputChanged = UserInputService.InputChanged:Connect(function(Input: InputObject)
        if
            (not IgnoreToggled and not Library.Toggled)
            or (IsMainWindow and Library.CantDragForced)
            or not (ScreenGui and ScreenGui.Parent)
        then
            Dragging = false
            if Changed and Changed.Connected then
                Changed:Disconnect()
                Changed = nil
            end

            return
        end

        if Dragging and IsHoverInput(Input) then
            local Delta = Input.Position - StartPos
            UI.Position =
                UDim2.new(FramePos.X.Scale, FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)
        end
    end)

    Library:GiveSignal(InputChanged)
    Library:GiveSignal(InputBegan)
    
    UI.Destroying:Once(function()
        if InputChanged and InputChanged.Connected then
            InputChanged:Disconnect()
        end

        if InputBegan and InputBegan.Connected then
            InputBegan:Disconnect()
        end

        if Changed and Changed.Connected then
            Changed:Disconnect()
        end

        local IdxChanged = table.find(Library.Signals, InputChanged)
        if IdxChanged then
            table.remove(Library.Signals, IdxChanged)
        end

        local IdxBegan = table.find(Library.Signals, InputBegan)
        if IdxBegan then
            table.remove(Library.Signals, IdxBegan)
        end
    end)
end

function Library:MakeResizable(UI: GuiObject, DragFrame: GuiObject, Callback: () -> ()?)
    local StartPos
    local FrameSize
    local Dragging = false
    local Changed
    local InputBegan
    local InputChanged

    InputBegan = DragFrame.InputBegan:Connect(function(Input: InputObject)
        if not IsClickInput(Input) then
            return
        end

        StartPos = Input.Position
        FrameSize = UI.Size
        Dragging = true

        Changed = Input.Changed:Connect(function()
            if Input.UserInputState ~= Enum.UserInputState.End then
                return
            end

            Dragging = false
            if Changed and Changed.Connected then
                Changed:Disconnect()
                Changed = nil
            end
        end)
    end)

    InputChanged = UserInputService.InputChanged:Connect(function(Input: InputObject)
        if not UI.Visible or not (ScreenGui and ScreenGui.Parent) then
            Dragging = false
            if Changed and Changed.Connected then
                Changed:Disconnect()
                Changed = nil
            end

            return
        end

        if Dragging and IsHoverInput(Input) then
            local Delta = Input.Position - StartPos
            UI.Size = UDim2.new(
                FrameSize.X.Scale,
                math.clamp(FrameSize.X.Offset + Delta.X, Library.MinSize.X, math.huge),
                FrameSize.Y.Scale,
                math.clamp(FrameSize.Y.Offset + Delta.Y, Library.MinSize.Y, math.huge)
            )
            if Callback then
                Library:SafeCallback(Callback)
            end
        end
    end)

    Library:GiveSignal(InputChanged)
    Library:GiveSignal(InputBegan)

    UI.Destroying:Once(function()
        if InputChanged and InputChanged.Connected then
            InputChanged:Disconnect()
        end

        if InputBegan and InputBegan.Connected then
            InputBegan:Disconnect()
        end

        if Changed and Changed.Connected then
            Changed:Disconnect()
        end

        local IdxChanged = table.find(Library.Signals, InputChanged)
        if IdxChanged then
            table.remove(Library.Signals, IdxChanged)
        end

        local IdxBegan = table.find(Library.Signals, InputBegan)
        if IdxBegan then
            table.remove(Library.Signals, IdxBegan)
        end
    end)
end

function Library:MakeCover(Holder: GuiObject, Place: string)
    local Pos = Places[Place] or { 0, 0 }
    local Size = Sizes[Place] or { 1, 0.5 }

    local Cover = New("Frame", {
        AnchorPoint = Vector2.new(Pos[1], Pos[2]),
        BackgroundColor3 = Holder.BackgroundColor3,
        Position = UDim2.fromScale(Pos[1], Pos[2]),
        Size = UDim2.fromScale(Size[1], Size[2]),
        Parent = Holder,
    })

    return Cover
end

function Library:MakeLine(Frame: GuiObject, Info)
    local Line = New("Frame", {
        AnchorPoint = Info.AnchorPoint or Vector2.zero,
        BackgroundColor3 = "OutlineColor",
        Position = Info.Position,
        Size = Info.Size,
        ZIndex = Info.ZIndex or Frame.ZIndex,
        Parent = Frame,
    })

    return Line
end

function Library:AddOutline(Frame: GuiObject)
    local OutlineStroke = New("UIStroke", {
        Color = "OutlineColor",
        Thickness = 1,
        ZIndex = 2,
        Parent = Frame,
    })
    local ShadowStroke = New("UIStroke", {
        Color = "DarkColor",
        Thickness = 1.5,
        ZIndex = 1,
        Parent = Frame,
    })
    return OutlineStroke, ShadowStroke
end

function Library:AddBlank(Frame: GuiObject, Size: UDim2)
    return New("Frame", {
        BackgroundTransparency = 1,
        Size = Size or UDim2.fromScale(0, 0),
        Parent = Frame,
    })
end

--// Animations \\--
local TransparencyCache = {}
local ActiveTabTweens = setmetatable({}, { __mode = "k" })

function Library:PlayTabAnimation(TabCanvas: CanvasGroup, Showing: boolean, OnComplete: (() -> ())?)
    if not TabCanvas then
        if OnComplete then
            OnComplete()
        end

        return
    end

    local Existing = ActiveTabTweens[TabCanvas]
    if Existing then
        StopTween(Existing, true)
        ActiveTabTweens[TabCanvas] = nil
    end

    local BaseZIndex = TabCanvas.ZIndex
    if not (Library.Animations and Library.Animations.TabSwitch) then
        TabCanvas.Visible = Showing
        TabCanvas.GroupTransparency = Showing and 0 or 1
        TabCanvas.Position = UDim2.fromScale(0, 0)
        TabCanvas.ZIndex = BaseZIndex

        if OnComplete then
            OnComplete()
        end

        return
    end

    if Showing then
        local TweenInfo = Library.TabTransitionInfo or TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local Offset = Library.TabSwipeOffset or 26
        local SwipeFrom = string.lower(Library.TabSwipeFrom or "bottom")
        local StartPosition

        if SwipeFrom == "left" then
            StartPosition = UDim2.fromOffset(-Offset, 0)
        elseif SwipeFrom == "top" then
            StartPosition = UDim2.fromOffset(0, -Offset)
        elseif SwipeFrom == "right" then
            StartPosition = UDim2.fromOffset(Offset, 0)
        else -- bottom (Default)
            StartPosition = UDim2.fromOffset(0, Offset)
        end

        TabCanvas.ZIndex = BaseZIndex + 1
        TabCanvas.GroupTransparency = 1
        TabCanvas.Position = StartPosition
        TabCanvas.Visible = true

        local Tween = TweenService:Create(TabCanvas, TweenInfo, {
            GroupTransparency = 0,
            Position = UDim2.fromScale(0, 0)
        })

        ActiveTabTweens[TabCanvas] = Tween
        Tween:Play()

        local Connection; Connection = Tween.Completed:Connect(function(PlaybackState)
            if Connection then
                Connection:Disconnect()
            end

            if ActiveTabTweens[TabCanvas] == Tween then
                ActiveTabTweens[TabCanvas] = nil
            end

            if PlaybackState == Enum.PlaybackState.Cancelled then
                return
            end

            TabCanvas.ZIndex = BaseZIndex
            if OnComplete then
                OnComplete()
            end
        end)
    else
        TabCanvas.GroupTransparency = 1
        TabCanvas.Visible = false
        TabCanvas.Position = UDim2.fromScale(0, 0)
        TabCanvas.ZIndex = BaseZIndex

        if OnComplete then
            OnComplete()
        end
    end
end

--// Deprecated \\--
function Library:MakeOutline(Frame: GuiObject, Corner: number?, ZIndex: number?)
    warn("Obsidian:MakeOutline is deprecated, please use Obsidian:AddOutline instead.")
    local Holder = New("Frame", {
        BackgroundColor3 = "DarkColor",
        Position = UDim2.fromOffset(-2, -2),
        Size = UDim2.new(1, 4, 1, 4),
        ZIndex = ZIndex,
        Parent = Frame,
    })

    local Outline = New("Frame", {
        BackgroundColor3 = "OutlineColor",
        Position = UDim2.fromOffset(1, 1),
        Size = UDim2.new(1, -2, 1, -2),
        ZIndex = ZIndex,
        Parent = Holder,
    })

    if Corner and Corner > 0 then
        New("UICorner", {
            CornerRadius = UDim.new(0, Corner + 1),
            Parent = Holder,
        })
        New("UICorner", {
            CornerRadius = UDim.new(0, Corner),
            Parent = Outline,
        })
    end

    return Holder, Outline
end

function Library:AddDraggableLabel(...)
    local Params = select(1, ...)
    local Text
    local Icon
    local IconPosition = "left"

    if typeof(Params) == "table" then
        Text = Params.Text
        Icon = Params.Icon
        IconPosition = Params.IconPosition or "left"
    elseif typeof(Params) == "string" then
        Text = Params
        Icon = select(2, ...)
        IconPosition = select(3, ...) or "left"
    end

    if typeof(IconPosition) ~= "string" then
        IconPosition = "left"
    end

    IconPosition = string.lower(IconPosition)
    assert(IconPosition == "left" or IconPosition == "right", "Icon Position needs to be either 'left' or 'right'.")

    local DraggableLabel = {
        Connections = {},
        Destroyed = false
    }

    local IconImage
    local Label = New("TextLabel", {
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundColor3 = "BackgroundColor",
        Size = UDim2.fromOffset(0, 0),
        Position = UDim2.fromOffset(6, 6),
        Text = Text,
        TextSize = 15,
        ZIndex = 10,
        Parent = ScreenGui,
    })

    table.insert(
        Library.Corners, 
        New("UICorner", {
            CornerRadius = UDim.new(0, Library.CornerRadius),
            Parent = Label,
        })
    )

    local Padding = New("UIPadding", {
        PaddingBottom = UDim.new(0, 6),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        PaddingTop = UDim.new(0, 6),
        Parent = Label,
    })
    table.insert(
        Library.Scales,
        New("UIScale", {
            Parent = Label,
        })
    )

    Library:AddOutline(Label)
    Library:MakeDraggable(Label, Label, true)

    function DraggableLabel:SetText(Text: string)
        Label.Text = Text
    end

    function DraggableLabel:SetIcon(NewIcon: string)
        Icon = NewIcon

        local IsNotEmpty = Icon and Trim(tostring(Icon)) ~= ""
        if IsNotEmpty then
            local CustomIcon = Library:GetCustomIcon(Icon)
            assert(CustomIcon, "Icon must be a valid Roblox asset or a valid URL or a valid lucide icon.")

            IconImage = IconImage or New("ImageLabel", {
                BackgroundTransparency = 1,
                ImageColor3 = "FontColor",
                Size = UDim2.fromOffset(16, 16),
                ZIndex = 11,
                Parent = Label,
            })

            IconImage.Image = CustomIcon.Url
            IconImage.ImageRectOffset = CustomIcon.ImageRectOffset
            IconImage.ImageRectSize = CustomIcon.ImageRectSize
        end

        if IconImage then IconImage.Visible = IsNotEmpty end
        DraggableLabel:SetIconPosition(IconPosition)
    end

    function DraggableLabel:SetIconPosition(NewPosition: string)
        IconPosition = string.lower(NewPosition)
        assert(IconPosition == "left" or IconPosition == "right", "Icon Position needs to be either 'left' or 'right'.")

        local IsNotEmpty = Icon and Trim(tostring(Icon)) ~= ""
        Padding.PaddingLeft = UDim.new(0, (IsNotEmpty and IconPosition == "left") and 34 or 12)
        Padding.PaddingRight = UDim.new(0, (IsNotEmpty and IconPosition == "right") and 34 or 12)

        if IconImage then
            if IconPosition == "left" then
                IconImage.AnchorPoint = Vector2.new(0, 0.5)
                IconImage.Position = UDim2.new(0, -22, 0.5, 0)
            else
                IconImage.AnchorPoint = Vector2.new(1, 0.5)
                IconImage.Position = UDim2.new(1, 22, 0.5, 0)
            end
        end
    end

    function DraggableLabel:SetVisible(Visible: boolean)
        Label.Visible = Visible
    end
    
    DraggableLabel:SetIcon(Icon)
    DraggableLabel.Label = Label

    if not table.find(Library.DraggableElements, Label) then
        table.insert(Library.DraggableElements, Label)
    end

    PositionDraggable(Label, Label.Position)

    function DraggableLabel:Destroy()
        DraggableLabel.Destroyed = true

        if DraggableLabel.Connections then
            for _, connection in DraggableLabel.Connections do
                connection:Disconnect()
            end
        end

        local ElemIdx = table.find(Library.DraggableElements, Label)
        if ElemIdx then
            table.remove(Library.DraggableElements, ElemIdx)
        end

        if Label then
            Label:Destroy()
        end
    end

    return DraggableLabel
end

function Library:AddDraggableButton(...)
    local Params = select(1, ...)

    local Text
    local Func
    local ExcludeScaling
    local ExcludeDragging

    if typeof(Params) == "table" then
        Text = Params.Text
        Func = Params.Callback or Params.Func
        ExcludeScaling = Params.ExcludeScaling
        ExcludeDragging = Params.ExcludeDragging
    elseif typeof(Params) == "string" then
        Text = Params
        Func = select(2, ...)
        ExcludeScaling = select(3, ...)
        ExcludeDragging = select(4, ...)
    end

    local DraggableButton = {
        Connections = {},
        Destroyed = false
    }

    local Button = New("TextButton", {
        BackgroundColor3 = "BackgroundColor",
        Position = UDim2.fromOffset(6, 6),
        TextSize = 16,
        ZIndex = 10,
        Parent = ScreenGui,
    })
    table.insert(
        Library.Corners, 
        New("UICorner", {
            CornerRadius = UDim.new(0, Library.CornerRadius),
            Parent = Button,
        })
    )
    if not ExcludeScaling then
        table.insert(
            Library.Scales,
            New("UIScale", {
                Parent = Button,
            })
        )
    end
    Library:AddOutline(Button)

    local DragThreshold = if ExcludeDragging then 0.25 else math.huge
    Button.InputBegan:Connect(function(Input: InputObject)
        if not IsClickInput(Input) then
            return
        end
        
        local Start = tick()

        local Changed
        Changed = Input.Changed:Connect(function()
            if Input.UserInputState ~= Enum.UserInputState.End then
                return
            end

            local IsLikelyDragging = tick() - Start > DragThreshold
            if IsLikelyDragging then
                return
            end

            Library:SafeCallback(Func, DraggableButton)

            if Changed and Changed.Connected then
                Changed:Disconnect()
                Changed = nil
            end
        end)
    end)

    function DraggableButton:SetText(Text: string)
        local X, Y = Library:GetTextBounds(Text, Library.Scheme.Font, 16)

        Button.Text = Text
        Button.Size = UDim2.fromOffset(X * 2, Y * 2)
    end

    Library:MakeDraggable(Button, Button, true)
    DraggableButton:SetText(Text)
    DraggableButton.Button = Button

    if not table.find(Library.DraggableElements, Button) then
        table.insert(Library.DraggableElements, Button)
    end

    PositionDraggable(Button, Button.Position)

    function DraggableButton:Destroy()
        DraggableButton.Destroyed = true

        if DraggableButton.Connections then
            for _, connection in DraggableButton.Connections do
                connection:Disconnect()
            end
        end

        local ElemIdx = table.find(Library.DraggableElements, Button)
        if ElemIdx then
            table.remove(Library.DraggableElements, ElemIdx)
        end

        if Button then
            Button:Destroy()
        end
    end

    return DraggableButton
end

function Library:AddDraggableMenu(Name: string)
    local Holder = New("Frame", {
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundColor3 = "BackgroundColor",
        Position = UDim2.fromOffset(6, 6),
        Size = UDim2.fromOffset(0, 0),
        ZIndex = 10,
        Parent = ScreenGui,
    })
    table.insert(
        Library.Corners,
        New("UICorner", {
            CornerRadius = UDim.new(0, Library.CornerRadius),
            Parent = Holder,
        })
    )
    table.insert(
        Library.Scales,
        New("UIScale", {
            Parent = Holder,
        })
    )
    Library:AddOutline(Holder)

    Library:MakeLine(Holder, {
        Position = UDim2.fromOffset(0, 34),
        Size = UDim2.new(1, 0, 0, 1),
    })

    local Label = New("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 34),
        Text = Name,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Holder,
    })
    New("UIPadding", {
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        Parent = Label,
    })

    local Container = New("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 35),
        Size = UDim2.new(1, 0, 1, -35),
        Parent = Holder,
    })
    New("UIListLayout", {
        Padding = UDim.new(0, 7),
        Parent = Container,
    })
    New("UIPadding", {
        PaddingBottom = UDim.new(0, 7),
        PaddingLeft = UDim.new(0, 7),
        PaddingRight = UDim.new(0, 7),
        PaddingTop = UDim.new(0, 7),
        Parent = Container,
    })

    Library:MakeDraggable(Holder, Label, true)

    if not table.find(Library.DraggableElements, Holder) then
        table.insert(Library.DraggableElements, Holder)
    end

    PositionDraggable(Holder, Holder.Position)

    return Holder, Container
end

function Library:AddDraggableImageButton(...)
    local Params = select(1, ...)

    local Icon
    local IconSize
    local Func
    local ExcludeScaling
    local ExcludeDragging

    if typeof(Params) == "table" then
        Icon = Params.Icon
        IconSize = Params.IconSize or 24
        Func = Params.Callback or Params.Func
        ExcludeScaling = Params.ExcludeScaling
        ExcludeDragging = Params.ExcludeDragging
    elseif typeof(Params) == "string" or typeof(Params) == "number" then
        Icon = Params
        IconSize = select(2, ...)
        Func = select(3, ...)
        ExcludeScaling = select(4, ...)
        ExcludeDragging = select(5, ...)
    end

    local DraggableImageButton = {}

    local Button = New("TextButton", {
        BackgroundColor3 = "BackgroundColor",
        Position = UDim2.fromOffset(6, 6),
        Size = UDim2.fromOffset(IconSize + 12, IconSize + 12),
        Text = "",
        ZIndex = 10,
        Parent = ScreenGui,
    })
    
    local IconImage = New("ImageLabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(IconSize, IconSize),
        ImageColor3 = "FontColor",
        ZIndex = 11,
        Parent = Button,
    })

    table.insert(
        Library.Corners, 
        New("UICorner", {
            CornerRadius = UDim.new(0, Library.CornerRadius),
            Parent = Button,
        })
    )
    if not ExcludeScaling then
        table.insert(
            Library.Scales,
            New("UIScale", {
                Parent = Button,
            })
        )
    end
    Library:AddOutline(Button)

    local DragThreshold = if ExcludeDragging then 0.25 else math.huge
    Button.InputBegan:Connect(function(Input: InputObject)
        if not IsClickInput(Input) then
            return
        end
        
        local Start = tick()

        local Changed
        Changed = Input.Changed:Connect(function()
            if Input.UserInputState ~= Enum.UserInputState.End then
                return
            end

            local IsLikelyDragging = tick() - Start > DragThreshold
            if IsLikelyDragging then
                return
            end

            Library:SafeCallback(Func, DraggableImageButton)

            if Changed and Changed.Connected then
                Changed:Disconnect()
                Changed = nil
            end
        end)
    end)

    function DraggableImageButton:SetIcon(NewIcon: string)
        Icon = NewIcon or Icon
        
        local CustomIcon = Library:GetCustomIcon(Icon)
        assert(CustomIcon, "Icon must be a valid Roblox asset or a valid URL or a valid lucide icon.")

        IconImage.Image = CustomIcon.Url
        IconImage.ImageRectOffset = CustomIcon.ImageRectOffset
        IconImage.ImageRectSize = CustomIcon.ImageRectSize
    end

    function DraggableImageButton:SetIconSize(NewSize: number)
        IconSize = NewSize
        IconImage.Size = UDim2.fromOffset(IconSize, IconSize)
        Button.Size = UDim2.fromOffset(IconSize + 12, IconSize + 12)
    end

    Library:MakeDraggable(Button, Button, true)
    DraggableImageButton:SetIcon(Icon)
    DraggableImageButton.Button = Button

    if not table.find(Library.DraggableElements, Button) then
        table.insert(Library.DraggableElements, Button)
    end

    PositionDraggable(Button, Button.Position)

    return DraggableImageButton
end

--// Watermark - Deprecated \\--
do
    local WatermarkLabel = Library:AddDraggableLabel("")
    WatermarkLabel:SetVisible(false)

    function Library:SetWatermark(Text: string)
        warn("Watermark is deprecated, please use Library:AddDraggableLabel instead.")
        WatermarkLabel:SetText(Text)
    end

    function Library:SetWatermarkVisibility(Visible: boolean)
        warn("Watermark is deprecated, please use Library:AddDraggableLabel instead.")
        WatermarkLabel:SetVisible(Visible)
    end
end

--// Context Menu \\--
local CurrentMenu
function Library:AddContextMenu(
    Holder: GuiObject,
    Size: UDim2 | () -> (),
    Offset: { [number]: number } | () -> {},
    List: number?,
    ActiveCallback: (Active: boolean) -> ()?,
    IgnoreCornerRadius: boolean?,
    SpecificCornersOnly: ("top" | "bottom" | "no_left" | "no_top_left")?, -- stupid way of doing this
    AnimationType: ("Dropdown" | "KeyPicker" | "none")?
)
    local Menu
    local ParentGui = Holder:FindFirstAncestorOfClass("ScreenGui")
    local MenuZIndex = math.max(10, Holder.ZIndex + 1)
    if ParentGui ~= ScreenGui and (Library.ActiveLoading and ParentGui ~= Library.ActiveLoading.ScreenGui) then
        ParentGui = ScreenGui
    end

    if List then
        Menu = New("ScrollingFrame", {
            AutomaticCanvasSize = List == 2 and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
            AutomaticSize = List == 1 and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
            BackgroundColor3 = "BackgroundColor",
            BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
            CanvasSize = UDim2.fromOffset(0, 0),
            ScrollBarImageColor3 = "OutlineColor",
            ScrollBarThickness = List == 2 and 2 or 0,
            Size = typeof(Size) == "function" and Size() or Size,
            TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
            Visible = false,
            ZIndex = MenuZIndex,
            Parent = ParentGui,
        })
    else
        Menu = New("Frame", {
            BackgroundColor3 = "BackgroundColor",
            Size = typeof(Size) == "function" and Size() or Size,
            Visible = false,
            ZIndex = MenuZIndex,
            Parent = ParentGui,
        })
    end
    table.insert(
        Library.Scales,
        New("UIScale", {
            Parent = Menu,
        })
    )

    New("UIStroke", {
        Color = "OutlineColor",
        Parent = Menu,
    })

    local Corner;
    if IgnoreCornerRadius ~= true then
        if SpecificCornersOnly == "top" then
            Corner = New("UICorner", {
                TopLeftRadius = UDim.new(0, Library.CornerRadius / 2),
                TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
                BottomRightRadius = UDim.new(0, 0),
                BottomLeftRadius = UDim.new(0, 0),
                Parent = Menu,
            }); table.insert(Library.SpecificCorners, Corner)
        elseif SpecificCornersOnly == "bottom" then
            Corner = New("UICorner", {
                TopLeftRadius = UDim.new(0, 0),
                TopRightRadius = UDim.new(0, 0),
                BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
                BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Menu,
            }); table.insert(Library.SpecificCorners, Corner)
        elseif SpecificCornersOnly == "no_left" then
            Corner = New("UICorner", {
                TopLeftRadius = UDim.new(0, 0),
                TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
                BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
                BottomLeftRadius = UDim.new(0, 0),
                Parent = Menu,
            }); table.insert(Library.SpecificCorners, Corner)
        elseif SpecificCornersOnly == "no_top_left" then
            Corner = New("UICorner", {
                TopLeftRadius = UDim.new(0, 0),
                TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
                BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
                BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Menu,
            }); table.insert(Library.SpecificCorners, Corner)
        else
            Corner = New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Menu,
            }); table.insert(Library.Corners, Corner)
        end
    end

    local Table = {
        Connections = {},
        Destroyed = false,

        Active = false,
        Holder = Holder,
        Menu = Menu,
        List = nil,
        Signal = nil,

        Size = Size,

        AutoSizeY = List == 1,
        OpenCloseTween = nil,
        Animated = function()
            if not AnimationType or AnimationType == "none" then
                return false
            end

            if not (Library.Animations and Library.Animations[AnimationType] == true) then
                return false
            end
            
            return true, Library[string.format("%sTransitionInfo", AnimationType)] or TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        end
    }

    if List then
        Table.List = New("UIListLayout", {
            Parent = Menu,
        })
    end

    function Table:Open()
        if CurrentMenu == Table then
            return
        elseif CurrentMenu then
            CurrentMenu:Close()
        end

        CurrentMenu = Table
        Table.Active = true

        if typeof(Offset) == "function" then
            Menu.Position = UDim2.fromOffset(
                math.floor(Holder.AbsolutePosition.X + Offset()[1]),
                math.floor(Holder.AbsolutePosition.Y + Offset()[2])
            )
        else
            Menu.Position = UDim2.fromOffset(
                math.floor(Holder.AbsolutePosition.X + Offset[1]),
                math.floor(Holder.AbsolutePosition.Y + Offset[2])
            )
        end

        local TargetSize = typeof(Table.Size) == "function" and Table.Size() or Table.Size

        if typeof(ActiveCallback) == "function" then
            Library:SafeCallback(ActiveCallback, true)
        end

        if Table.OpenCloseTween then
            StopTween(Table.OpenCloseTween, true)
            Table.OpenCloseTween = nil
        end

        local IsAnimated, TweenInfo = Table.Animated()
        if IsAnimated == true then
            local OpenSize = TargetSize
            if Table.AutoSizeY then
                local FullHeight = Menu.AbsoluteSize.Y

                Menu.AutomaticSize = Enum.AutomaticSize.None
                OpenSize = UDim2.new(TargetSize.X.Scale, TargetSize.X.Offset, 0, FullHeight)
            end

            Menu.Size = UDim2.new(OpenSize.X.Scale, OpenSize.X.Offset, 0, 0)
            Menu.Visible = true

            local Tween = TweenService:Create(Menu, TweenInfo, { Size = OpenSize })
            Table.OpenCloseTween = Tween

            local Connection; Connection = Library:GiveSignal(Tween.Completed:Once(function()
                if Connection then
                    Connection:Disconnect()
                end

                if Table.OpenCloseTween == Tween then
                    StopTween(Table.OpenCloseTween, true)
                    Table.OpenCloseTween = nil

                    if Table.AutoSizeY then
                        Menu.AutomaticSize = Enum.AutomaticSize.Y
                    end
                end
            end))

            Tween:Play()
        else
            Menu.Size = TargetSize
            Menu.Visible = true
        end

        Table.Signal = Holder:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
            if typeof(Offset) == "function" then
                Menu.Position = UDim2.fromOffset(
                    math.floor(Holder.AbsolutePosition.X + Offset()[1]),
                    math.floor(Holder.AbsolutePosition.Y + Offset()[2])
                )
            else
                Menu.Position = UDim2.fromOffset(
                    math.floor(Holder.AbsolutePosition.X + Offset[1]),
                    math.floor(Holder.AbsolutePosition.Y + Offset[2])
                )
            end

            if not Library:IsInsideFrame(Library.WindowContainer, Holder) and Table.Active then
                Table:Close()
            end
        end)
    end

    function Table:Close()
        if CurrentMenu ~= Table then
            return
        end

        if Table.Signal then
            Table.Signal:Disconnect()
            Table.Signal = nil
        end

        Table.Active = false
        CurrentMenu = nil

        if typeof(ActiveCallback) == "function" then
            Library:SafeCallback(ActiveCallback, false)
        end

        if Table.OpenCloseTween then
            StopTween(Table.OpenCloseTween, true)
            Table.OpenCloseTween = nil
        end

        local IsAnimated, TweenInfo = Table.Animated()
        if IsAnimated == true then
            if Table.AutoSizeY then
                Menu.AutomaticSize = Enum.AutomaticSize.None
            end

            local CurrentSize = Menu.Size
            local CollapsedSize = UDim2.new(CurrentSize.X.Scale, CurrentSize.X.Offset, 0, 0)

            local Tween = TweenService:Create(Menu, TweenInfo, { Size = CollapsedSize })
            Table.OpenCloseTween = Tween

            local Connection; Connection = Library:GiveSignal(Tween.Completed:Once(function(PlaybackState)
                if Connection then
                    Connection:Disconnect()
                end

                if Table.OpenCloseTween == Tween then
                    StopTween(Table.OpenCloseTween, true)
                    Table.OpenCloseTween = nil

                    Menu.Visible = false
                    if Table.AutoSizeY then
                        Menu.AutomaticSize = Enum.AutomaticSize.Y
                    end
                end
            end))

            Tween:Play()
        else
            Menu.Visible = false
        end
    end

    function Table:Toggle()
        if Table.Active then
            Table:Close()
        else
            Table:Open()
        end
    end

    function Table:SetSize(Size)
        Table.Size = Size
        Menu.Size = typeof(Size) == "function" and Size() or Size
    end

    function Table:Destroy()
        Table.Destroyed = true

        if Table.Connections then
            for _, Connection in Table.Connections do
                Connection:Disconnect()
            end
        end

        if CurrentMenu == Table then
            Table:Close()
        end

        if Table.OpenCloseTween then
            StopTween(Table.OpenCloseTween, true)
            Table.OpenCloseTween = nil
        end

        if Menu then
            Menu:Destroy()
        end
    end

    return Table
end

Library:GiveSignal(UserInputService.InputBegan:Connect(function(Input: InputObject)
    if Library.Unloaded then
        return
    end

    if IsClickInput(Input, true) then
        local Location = Input.Position

        if
            CurrentMenu
            and not (
                Library:MouseIsOverFrame(CurrentMenu.Menu, Location)
                or Library:MouseIsOverFrame(CurrentMenu.Holder, Location)
            )
        then
            CurrentMenu:Close()
        end
    end
end))

--// Tooltip \\--
local TooltipLabel = New("TextLabel", {
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundColor3 = "BackgroundColor",
    TextSize = 14,
    TextWrapped = true,
    Visible = false,
    ZIndex = 20,
    Parent = ScreenGui,
})
New("UIPadding", {
    PaddingBottom = UDim.new(0, 2),
    PaddingLeft = UDim.new(0, 4),
    PaddingRight = UDim.new(0, 4),
    PaddingTop = UDim.new(0, 2),
    Parent = TooltipLabel,
})
table.insert(
    Library.Scales,
    New("UIScale", {
        Parent = TooltipLabel,
    })
)
New("UIStroke", {
    Color = "OutlineColor",
    Parent = TooltipLabel,
})
table.insert(
    Library.Corners,
    New("UICorner", {
        CornerRadius = UDim.new(0, Library.CornerRadius / 2),
        Parent = TooltipLabel,
    })
)
TooltipLabel:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
    if Library.Unloaded then
        return
    end

    local X, _ = Library:GetTextBounds(
        TooltipLabel.Text,
        TooltipLabel.FontFace,
        TooltipLabel.TextSize,
        (workspace.CurrentCamera.ViewportSize.X - TooltipLabel.AbsolutePosition.X - 8) / Library.DPIScale
    )

    TooltipLabel.Size = UDim2.fromOffset(X + 8, 0)
end)

local CurrentHoverInstance
function Library:AddTooltip(InfoStr: string, DisabledInfoStr: string, HoverInstance: GuiObject)
    local TooltipTable = {
        Disabled = false,
        Hovering = false,
        Signals = {},
    }

    local function DoHover()
        if
            CurrentHoverInstance == HoverInstance
            or Library.ActiveDialog
            or (CurrentMenu and Library:MouseIsOverFrame(CurrentMenu.Menu, Mouse))
            or (TooltipTable.Disabled and typeof(DisabledInfoStr) ~= "string")
            or (not TooltipTable.Disabled and typeof(InfoStr) ~= "string")
        then
            return
        end
        CurrentHoverInstance = HoverInstance

        local ParentGui = HoverInstance:FindFirstAncestorOfClass("ScreenGui")
        if ParentGui ~= ScreenGui and (Library.ActiveLoading and ParentGui ~= Library.ActiveLoading.ScreenGui) then
            ParentGui = ScreenGui
        end
        TooltipLabel.Parent = ParentGui

        TooltipLabel.Text = TooltipTable.Disabled and DisabledInfoStr or InfoStr
        TooltipLabel.Visible = true

        while
            (Library.Toggled or Library.ActiveLoading)
            and not Library.ActiveDialog
            and Library:MouseIsOverFrame(HoverInstance, Mouse)
            and not (CurrentMenu and Library:MouseIsOverFrame(CurrentMenu.Menu, Mouse))
        do
            TooltipLabel.Position = UDim2.fromOffset(
                Mouse.X + (Library.ShowCustomCursor and 8 or 14),
                Mouse.Y + (Library.ShowCustomCursor and 8 or 12)
            )

            RunService.RenderStepped:Wait()
        end

        TooltipLabel.Visible = false
        CurrentHoverInstance = nil
    end

    local function GiveSignal(Connection: RBXScriptConnection | RBXScriptSignal)
        local ConnectionType = typeof(Connection)
        if Connection and (ConnectionType == "RBXScriptConnection" or ConnectionType == "RBXScriptSignal") then
            table.insert(TooltipTable.Signals, Connection)
        end

        return Connection
    end

    GiveSignal(HoverInstance.MouseEnter:Connect(DoHover))
    GiveSignal(HoverInstance.MouseMoved:Connect(DoHover))
    GiveSignal(HoverInstance.MouseLeave:Connect(function()
        if CurrentHoverInstance ~= HoverInstance then
            return
        end

        TooltipLabel.Visible = false
        CurrentHoverInstance = nil
    end))

    function TooltipTable:Destroy()
        for Index = #TooltipTable.Signals, 1, -1 do
            local Connection = table.remove(TooltipTable.Signals, Index)
            if Connection and Connection.Connected then
                Connection:Disconnect()
            end
        end

        if CurrentHoverInstance == HoverInstance then
            if TooltipLabel then
                TooltipLabel.Visible = false
            end

            CurrentHoverInstance = nil
        end
    end

    table.insert(Tooltips, TooltipLabel)
    return TooltipTable
end

function Library:OnUnload(Callback)
    table.insert(Library.UnloadSignals, Callback)
end

local CheckIcon = Library:GetIcon("check")
local ArrowIcon = Library:GetIcon("chevron-up")
local ResizeIcon = Library:GetIcon("move-diagonal-2")
local KeyIcon = Library:GetIcon("key")
local MoveIcon = Library:GetIcon("move")

function Library:SetIconModule(module: IconModule)
    FetchIcons = true
    Icons = module

    -- Top ten fixes 🚀
    CheckIcon = Library:GetIcon("check")
    ArrowIcon = Library:GetIcon("chevron-up")
    ResizeIcon = Library:GetIcon("move-diagonal-2")
    KeyIcon = Library:GetIcon("key")
    MoveIcon = Library:GetIcon("move")
end

local BaseAddons = {}
do
    local Funcs = {}

    function Funcs:AddKeyPicker(Idx, Info)
        if self.Destroyed then return nil end

        Info = Library:Validate(Info, Templates.KeyPicker)

        local ParentObj = self
        local ToggleLabel = ParentObj.TextLabel

        if ParentObj.Type == "Button" or ParentObj.Type == "SubButton" then
            assert(Info.Mode == "Press", "KeyPicker on Buttons can only be applied with the 'Press' mode.")

            ToggleLabel = ParentObj.Base
        end

        local KeyPicker = {
            Connections = {},

            Text = Info.Text,
            Value = Info.Default, -- Key
            Modifiers = Info.DefaultModifiers, -- Modifiers
            DisplayValue = Info.Default, -- Picker Text

            Blacklisted = Info.Blacklisted,
            BlacklistedModifiers = Info.BlacklistedModifiers,
            Whitelisted = Info.Whitelisted,
            WhitelistedModifiers = Info.WhitelistedModifiers,

            Toggled = false,
            Mode = Info.Mode,
            SyncToggleState = Info.SyncToggleState,

            Callback = Info.Callback,
            ChangedCallback = Info.ChangedCallback,
            Changed = Info.Changed,
            Clicked = Info.Clicked,

            Type = "KeyPicker",
        }

        if KeyPicker.Mode == "Press" then
            assert(ParentObj.Type == "Label" or ParentObj.Type == "Button" or ParentObj.Type == "SubButton", "KeyPicker with the mode 'Press' can be only applied on Labels and Buttons.")

            KeyPicker.SyncToggleState = false
            Info.Modes = { "Press" }
            Info.Mode = "Press"
        end

        if KeyPicker.SyncToggleState then
            Info.Modes = { "Toggle", "Hold" }

            if not table.find(Info.Modes, Info.Mode) then
                Info.Mode = "Toggle"
            end
        end

        local Picking = false
        local IsForButton = ParentObj.Type == "Button" or ParentObj.Type == "SubButton"

        -- Special Keys
        local SpecialKeys = {
            ["MB1"] = Enum.UserInputType.MouseButton1,
            ["MB2"] = Enum.UserInputType.MouseButton2,
            ["MB3"] = Enum.UserInputType.MouseButton3,
        }

        local SpecialKeysInput = {
            [Enum.UserInputType.MouseButton1] = "MB1",
            [Enum.UserInputType.MouseButton2] = "MB2",
            [Enum.UserInputType.MouseButton3] = "MB3",
        }

        -- Modifiers
        local Modifiers = {
            ["LAlt"] = Enum.KeyCode.LeftAlt,
            ["RAlt"] = Enum.KeyCode.RightAlt,

            ["LCtrl"] = Enum.KeyCode.LeftControl,
            ["RCtrl"] = Enum.KeyCode.RightControl,

            ["LShift"] = Enum.KeyCode.LeftShift,
            ["RShift"] = Enum.KeyCode.RightShift,

            ["Tab"] = Enum.KeyCode.Tab,
            ["CapsLock"] = Enum.KeyCode.CapsLock,
        }

        local ModifiersInput = {
            [Enum.KeyCode.LeftAlt] = "LAlt",
            [Enum.KeyCode.RightAlt] = "RAlt",

            [Enum.KeyCode.LeftControl] = "LCtrl",
            [Enum.KeyCode.RightControl] = "RCtrl",

            [Enum.KeyCode.LeftShift] = "LShift",
            [Enum.KeyCode.RightShift] = "RShift",

            [Enum.KeyCode.Tab] = "Tab",
            [Enum.KeyCode.CapsLock] = "CapsLock",
        }

        local IsModifierInput = function(Input)
            return Input.UserInputType == Enum.UserInputType.Keyboard and ModifiersInput[Input.KeyCode] ~= nil
        end

        local GetActiveModifiers = function()
            local ActiveModifiers = {}

            for Name, Input in Modifiers do
                if table.find(ActiveModifiers, Name) then
                    continue
                end
                if not UserInputService:IsKeyDown(Input) then
                    continue
                end

                table.insert(ActiveModifiers, Name)
            end

            return ActiveModifiers
        end

        local AreModifiersHeld = function(Required)
            if not (typeof(Required) == "table" and GetTableSize(Required) > 0) then
                return true
            end

            local ActiveModifiers = GetActiveModifiers()
            local Holding = true

            for _, Name in Required do
                if table.find(ActiveModifiers, Name) then
                    continue
                end

                Holding = false
                break
            end

            return Holding
        end

        local IsInputDown = function(Input)
            if not Input then
                return false
            end

            if SpecialKeysInput[Input.UserInputType] ~= nil then
                return UserInputService:IsMouseButtonPressed(Input.UserInputType)
                    and not UserInputService:GetFocusedTextBox()
            elseif Input.UserInputType == Enum.UserInputType.Keyboard then
                return UserInputService:IsKeyDown(Input.KeyCode) and not UserInputService:GetFocusedTextBox()
            else
                return false
            end
        end

        local ConvertToInputModifiers = function(CurrentModifiers)
            local InputModifiers = {}

            for _, name in CurrentModifiers do
                table.insert(InputModifiers, Modifiers[name])
            end

            return InputModifiers
        end

        local VerifyModifiers = function(CurrentModifiers)
            if typeof(CurrentModifiers) ~= "table" then
                return {}
            end

            local ValidModifiers = {}

            for _, name in CurrentModifiers do
                if not Modifiers[name] then
                    continue
                end

                table.insert(ValidModifiers, name)
            end

            return ValidModifiers
        end

        KeyPicker.Modifiers = VerifyModifiers(KeyPicker.Modifiers)

        local SlideOverflow = true
        local MaxPickerWidth = 75
        local SlidingLabel

        local LastPickerWidth = 0
        local SlideForwardTween
        local SlideBackTween
        local HandleForwardTween = function(State)
            if State ~= Enum.PlaybackState.Completed then
                return
            end

            task.wait(1.5)
            if SlideBackTween then
                SlideBackTween:Play()
            end
        end

        local HandleBackTween = function(State)
            if State ~= Enum.PlaybackState.Completed then
                return
            end

            task.wait(1.5)
            if SlideForwardTween then
                SlideForwardTween:Play()
            end
        end

        local CancelSlidingTweens = function()
            if SlideForwardTween then
                StopTween(SlideForwardTween, true)
                SlideForwardTween = nil
            end

            if SlideBackTween then
                SlideForwardTween(SlideBackTween, true)
                SlideBackTween = nil
            end
        end

        local Picker = New("TextButton", {
            BackgroundColor3 = "MainColor",
            Size = UDim2.fromOffset(18, 18),
            Text = (IsForButton and SlideOverflow) and "" or KeyPicker.Value,
            TextSize = 14,
            Parent = ToggleLabel,
        })

        if IsForButton and SlideOverflow then
            Picker.ClipsDescendants = true

            SlidingLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Position = UDim2.new(0, 0, 0, 0),
                Text = KeyPicker.Value,
                TextSize = 14,
                FontFace = Picker.FontFace,
                TextXAlignment = Enum.TextXAlignment.Center,
                Parent = Picker,
            })

            Library:AddToRegistry(SlidingLabel, {
                TextColor3 = "FontColor",
            })
        end

        New("UIStroke", {
            Color = "OutlineColor",
            Parent = Picker,
        })

        local PickerCorner = New("UICorner", {
            TopLeftRadius = UDim.new(0, Library.CornerRadius / 2),
            TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
            BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
            BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
            Parent = Picker,
        }); table.insert(Library.SpecificCorners, PickerCorner)

        if IsForButton then
            local Holder = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 21),
                Parent = ToggleLabel.Parent,
            })

            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                Padding = UDim.new(0, 9),
                Parent = Holder,
            })

            ToggleLabel.Parent = Holder
            Picker.Parent = Holder

            Picker.Size = UDim2.new(0, 18, 1, 0)
        end

        local KeybindsToggle = { Normal = KeyPicker.Mode ~= "Toggle" }
        do
            local Holder = New("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 16),
                Text = "",
                Visible = not Info.NoUI,
                Parent = Library.KeybindContainer,
            })

            local Label = New("TextLabel", {
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(0, 1),
                Text = "",
                TextSize = 14,
                TextTransparency = 0.5,
                Parent = Holder,
            })

            local Checkbox = New("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = "MainColor",
                Position = UDim2.fromScale(0, 0.5),
                Size = UDim2.fromOffset(14, 14),
                SizeConstraint = Enum.SizeConstraint.RelativeYY,
                Parent = Holder,
            })
            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                    Parent = Checkbox,
                })
            )
            New("UIStroke", {
                Color = "OutlineColor",
                Parent = Checkbox,
            })

            local CheckImage = New("ImageLabel", {
                Image = CheckIcon and CheckIcon.Url or "",
                ImageColor3 = "FontColor",
                ImageRectOffset = CheckIcon and CheckIcon.ImageRectOffset or Vector2.zero,
                ImageRectSize = CheckIcon and CheckIcon.ImageRectSize or Vector2.zero,
                ImageTransparency = 1,
                Position = UDim2.fromOffset(2, 2),
                Size = UDim2.new(1, -4, 1, -4),
                Parent = Checkbox,
            })

            function KeybindsToggle:Display(State)
                Label.TextTransparency = State and 0 or 0.5
                CheckImage.ImageTransparency = State and 0 or 1
            end

            function KeybindsToggle:SetText(Text)
                Label.Text = Text
            end

            function KeybindsToggle:SetVisibility(Visibility)
                Holder.Visible = Visibility
            end

            function KeybindsToggle:SetNormal(Normal)
                KeybindsToggle.Normal = Normal

                Holder.Active = not Normal
                Label.Position = Normal and UDim2.fromOffset(0, 0) or UDim2.fromOffset(22, 0)
                Checkbox.Visible = not Normal
            end

            KeyPicker.DoClick = function(...) end --// make luau lsp shut up
            Holder.MouseButton1Click:Connect(function()
                if KeybindsToggle.Normal then
                    return
                end

                KeyPicker.Toggled = not KeyPicker.Toggled
                KeyPicker:DoClick()
            end)

            KeybindsToggle.Holder = Holder
            KeybindsToggle.Label = Label
            KeybindsToggle.Checkbox = Checkbox
            KeybindsToggle.Loaded = true
            table.insert(Library.KeybindToggles, KeybindsToggle)
        end

        local ModeButtons = {}
        local TotalModeButtons = GetTableSize(Info.Modes)
        local MenuTable = Library:AddContextMenu(Picker, UDim2.fromOffset(62, 0), function()
            return { Picker.AbsoluteSize.X + 1.5, 0.5 }
        end, 1, function(Active: boolean)
            PickerCorner.TopRightRadius = Active and UDim.new(0, 0) or UDim.new(0, Library.CornerRadius / 2)
            PickerCorner.BottomRightRadius = Active and UDim.new(0, 0) or UDim.new(0, Library.CornerRadius / 2)
        end, false, if TotalModeButtons == 1 then "no_left" else "no_top_left", "KeyPicker")
        KeyPicker.Menu = MenuTable

        for Index, Mode in Info.Modes do
            local ModeButton = {}

            local Button = New("TextButton", {
                BackgroundColor3 = "MainColor",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, IsForButton and 21 or (TotalModeButtons == 1 and 18 or 19)),
                Text = Mode,
                TextSize = 14,
                TextTransparency = 0.5,
                Parent = MenuTable.Menu,
            })
            
            if Index == 1 and TotalModeButtons == 1 then
                table.insert(Library.SpecificCorners, New("UICorner", {
                    TopLeftRadius = UDim.new(0, 0),
                    TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
                    BottomLeftRadius = UDim.new(0, 0),
                    BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
                    Parent = Button,
                }))
            elseif Index == 1 then
                table.insert(Library.SpecificCorners, New("UICorner", {
                    TopLeftRadius = UDim.new(0, 0),
                    TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
                    BottomLeftRadius = UDim.new(0, 0),
                    BottomRightRadius = UDim.new(0, 0),
                    Parent = Button,
                }))
            elseif Index == TotalModeButtons then
                table.insert(Library.SpecificCorners, New("UICorner", {
                    TopLeftRadius = UDim.new(0, 0),
                    TopRightRadius = UDim.new(0, 0),
                    BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
                    BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
                    Parent = Button,
                }))
            end

            function ModeButton:Select()
                for _, Button in ModeButtons do
                    Button:Deselect()
                end

                KeyPicker.Mode = Mode

                Button.BackgroundTransparency = 0
                Button.TextTransparency = 0

                MenuTable:Close()
            end

            function ModeButton:Deselect()
                KeyPicker.Mode = nil

                Button.BackgroundTransparency = 1
                Button.TextTransparency = 0.5
            end

            Button.MouseButton1Click:Connect(function()
                ModeButton:Select()
            end)

            if KeyPicker.Mode == Mode then
                ModeButton:Select()
            end

            ModeButtons[Mode] = ModeButton
        end

        function KeyPicker:Display(PickerText)
            if Library.Unloaded then
                return
            end

            local DisplayText = PickerText or KeyPicker.DisplayValue
            if IsForButton and SlideOverflow then
                if LastPickerWidth == Picker.AbsoluteSize.X then
                    return
                end

                local X, _Y = Library:GetTextBounds(
                    DisplayText,
                    Picker.FontFace,
                    Picker.TextSize,
                    10000
                )

                SlidingLabel.Text = DisplayText

                local OffsetScale = X + 9
                local PickerWidth = math.min(OffsetScale, MaxPickerWidth)
                Picker.Size = UDim2.new(0, PickerWidth, 1, 0)

                if OffsetScale > PickerWidth then
                    SlidingLabel.TextXAlignment = Enum.TextXAlignment.Left
                    SlidingLabel.Size = UDim2.new(0, OffsetScale, 1, 0)
                    SlidingLabel.Position = UDim2.fromOffset(4.5, 0)

                    RunService.RenderStepped:Wait()

                    local RealPickerWidth = Picker.AbsoluteSize.X
                    if RealPickerWidth <= 0 then RealPickerWidth = PickerWidth end

                    LastPickerWidth = RealPickerWidth

                    local OverflowDistance = OffsetScale - RealPickerWidth - 4.5
                    if OverflowDistance > 0 then
                        CancelSlidingTweens()

                        local Duration = OverflowDistance / 25
                        local TweenInfo = TweenInfo.new(
                            Duration,
                            Enum.EasingStyle.Linear, Enum.EasingDirection.InOut
                        )

                        SlideForwardTween = TweenService:Create(SlidingLabel, TweenInfo, {
                            Position = UDim2.fromOffset(-OverflowDistance, 0)
                        })

                        SlideBackTween = TweenService:Create(SlidingLabel, TweenInfo, {
                            Position = UDim2.fromOffset(4.5, 0)
                        })

                        SlideForwardTween:Play()

                        SlideForwardTween.Completed:Connect(HandleForwardTween)
                        SlideBackTween.Completed:Connect(HandleBackTween)
                    else
                        CancelSlidingTweens()

                        SlidingLabel.TextXAlignment = Enum.TextXAlignment.Center
                        SlidingLabel.Size = UDim2.new(1, 0, 1, 0)
                        SlidingLabel.Position = UDim2.new(0, 0, 0, 0)
                    end
                else
                    CancelSlidingTweens()

                    SlidingLabel.TextXAlignment = Enum.TextXAlignment.Center
                    SlidingLabel.Size = UDim2.new(1, 0, 1, 0)
                    SlidingLabel.Position = UDim2.new(0, 0, 0, 0)
                end
            else
                local X, Y = Library:GetTextBounds(
                    DisplayText,
                    Picker.FontFace,
                    Picker.TextSize,
                    ToggleLabel.AbsoluteSize.X
                )
                Picker.Text = DisplayText
                Picker.Size = IsForButton and UDim2.new(0, X + 9, 1, 0) or UDim2.fromOffset((X + 9), (Y + 4))
            end
        end

        function KeyPicker:Update()
            KeyPicker:Display()

            if Info.NoUI then
                return
            end

            if KeyPicker.Mode == "Toggle" and ParentObj.Type == "Toggle" and ParentObj.Disabled then
                KeybindsToggle:SetVisibility(false)
                return
            end

            local State = KeyPicker:GetState()
            local ShowToggle = Library.ShowToggleFrameInKeybinds and KeyPicker.Mode == "Toggle"

            if KeyPicker.SyncToggleState and ParentObj.Value ~= State then
                ParentObj:SetValue(State)
            end

            if KeybindsToggle.Loaded then
                if ShowToggle then
                    KeybindsToggle:SetNormal(false)
                else
                    KeybindsToggle:SetNormal(true)
                end

                KeybindsToggle:SetText(("[%s] %s (%s)"):format(KeyPicker.DisplayValue, KeyPicker.Text, KeyPicker.Mode))
                KeybindsToggle:SetVisibility(true)
                KeybindsToggle:Display(State)
            end
        end

        function KeyPicker:GetState()
            if KeyPicker.Mode == "Always" then
                return true
            elseif KeyPicker.Mode == "Hold" then
                local Key = KeyPicker.Value
                if Key == "None" then
                    return false
                end

                if not AreModifiersHeld(KeyPicker.Modifiers) then
                    return false
                end

                if Picking then
                    return false
                end

                if SpecialKeys[Key] ~= nil then
                    if Library.Toggled then
                        return false
                    end

                    return UserInputService:IsMouseButtonPressed(SpecialKeys[Key])
                        and not UserInputService:GetFocusedTextBox()
                else
                    return UserInputService:IsKeyDown(Enum.KeyCode[Key] :: any) and not UserInputService:GetFocusedTextBox()
                end
            else
                return KeyPicker.Toggled
            end
        end

        function KeyPicker:OnChanged(Func)
            KeyPicker.Changed = Func
        end

        function KeyPicker:OnClick(Func)
            KeyPicker.Clicked = Func
        end

        function KeyPicker:DoClick()
            if Picking then
                return
            end

            if KeyPicker.Mode == "Press" then
                if KeyPicker.Toggled and Info.WaitForCallback == true then
                    return
                end

				KeyPicker.Toggled = true
            end

            Library:SafeCallback(KeyPicker.Callback, KeyPicker.Toggled)
            Library:SafeCallback(KeyPicker.Clicked, KeyPicker.Toggled)

            if IsForButton then
                Library:SafeCallback(ParentObj.Func, KeyPicker.Toggled)
			end
			
			if Library.ToggleKeybind == KeyPicker and Library.Toggle then
                Library:Toggle()
            end

			if KeyPicker.Mode == "Press" then
                KeyPicker.Toggled = false
            end
        end

        function KeyPicker:RunChanged(IsKeyValid, KeyCode)
            if IsKeyValid == nil or KeyCode == nil then
                IsKeyValid, KeyCode = pcall(function()
                    if KeyPicker.Value == "None" then
                        return nil
                    end

                    if SpecialKeys[KeyPicker.Value] == nil then
                        return Enum.KeyCode[KeyPicker.Value]
                    end

                    return SpecialKeys[KeyPicker.Value]
                end)
            end

            local NewModifiers = ConvertToInputModifiers(KeyPicker.Modifiers)
            Library:SafeCallback(KeyPicker.ChangedCallback, KeyCode, NewModifiers)
            Library:SafeCallback(KeyPicker.Changed, KeyCode, NewModifiers)
        end

        function KeyPicker:SetValue(Data)
            local Key, Mode, Modifiers = Data[1], Data[2], Data[3]

            local IsKeyValid, KeyCode = pcall(function()
                if Key == "None" then
                    Key = nil
                    return nil
                end

                if SpecialKeys[Key] == nil then
                    return Enum.KeyCode[Key]
                end

                return SpecialKeys[Key]
            end)

            if Key == nil then
                KeyPicker.Value = "None"
            elseif IsKeyValid then
                KeyPicker.Value = Key
            else
                KeyPicker.Value = "Unknown"
            end

            KeyPicker.Modifiers =
                VerifyModifiers(if typeof(Modifiers) == "table" then Modifiers else KeyPicker.Modifiers)
            KeyPicker.DisplayValue = if GetTableSize(KeyPicker.Modifiers) > 0
                then (table.concat(KeyPicker.Modifiers, " + ") .. " + " .. KeyPicker.Value)
                else KeyPicker.Value

            if ModeButtons[Mode] then
                ModeButtons[Mode]:Select()
            end

            KeyPicker:Update()
            KeyPicker:RunChanged(IsKeyValid, KeyCode)
        end

        function KeyPicker:SetText(Text)
            KeybindsToggle:SetText(Text)
            KeyPicker:Update()
        end

        local SetPickingState = function(State)
            Picking = State
            Library.IsPicking = State

            if ParentObj then
                ParentObj.AnyKeyPickerPicking = Picking
            end

            if IsForButton then
                ToggleLabel.Visible = not Picking
                RunService.RenderStepped:Wait()
            end

            KeyPicker:Update()
        end

        Picker.MouseButton1Click:Connect(function()
            if Picking or Library.IsPicking then
                return
            end

            SetPickingState(true)

            if IsForButton and SlideOverflow then
                KeyPicker:Display("...")
            else
                Picker.Text = "..."
                Picker.Size = IsForButton and UDim2.new(0, 29, 1, 0) or UDim2.fromOffset(29, 18)
            end

            -- Wait for any input --
            local ActiveModifiers = {}
            local CurrentInput = nil

            local IsValidInput = function(InputObj)
                if InputObj.KeyCode == Enum.KeyCode.Escape then
                    return true
                end

                local IsMod = IsModifierInput(InputObj)
                local KeyName
                if SpecialKeysInput[InputObj.UserInputType] ~= nil then
                    KeyName = SpecialKeysInput[InputObj.UserInputType]
                elseif InputObj.UserInputType == Enum.UserInputType.Keyboard then
                    if IsMod then
                        KeyName = ModifiersInput[InputObj.KeyCode]
                    else
                        KeyName = InputObj.KeyCode.Name
                    end
                end

                if KeyName then
                    if IsMod then
                        if KeyPicker.WhitelistedModifiers and #KeyPicker.WhitelistedModifiers > 0 and not table.find(KeyPicker.WhitelistedModifiers, KeyName) then
                            return false
                        end

                        if KeyPicker.BlacklistedModifiers and table.find(KeyPicker.BlacklistedModifiers, KeyName) then
                            return false
                        end
                    else
                        if KeyPicker.Whitelisted and #KeyPicker.Whitelisted > 0 and not table.find(KeyPicker.Whitelisted, KeyName) then
                            return false
                        end

                        if KeyPicker.Blacklisted and table.find(KeyPicker.Blacklisted, KeyName) then
                            return false
                        end
                    end
                end

                return true
            end

            -- Wait for the first valid InputBegan --
            while true do
                local InputObj = UserInputService.InputBegan:Wait()
                if UserInputService:GetFocusedTextBox() ~= nil then
                    SetPickingState(false)
                    return
                end

                if IsValidInput(InputObj) then
                    CurrentInput = InputObj
                    break
                end
            end

            -- If it's a modifier key, we wait for either its release or another input --
            while IsModifierInput(CurrentInput) do
                if CurrentInput.KeyCode == Enum.KeyCode.Escape then
                    break
                end

                -- Display the current state including the current modifier key --
                local ModName = ModifiersInput[CurrentInput.KeyCode]
                if ModName then
                    local text = if #ActiveModifiers > 0 then table.concat(ActiveModifiers, " + ") .. " + " .. ModName .. " + ..." else ModName .. " + ..."
                    KeyPicker:Display(text)
                end

                local NextInput = nil
                local Released = false

                local BeganConn
                local EndedConn

                BeganConn = UserInputService.InputBegan:Connect(function(InputObj)
                    if UserInputService:GetFocusedTextBox() ~= nil then
                        return
                    end
                    if IsValidInput(InputObj) then
                        NextInput = InputObj
                    end
                end)

                EndedConn = UserInputService.InputEnded:Connect(function(InputObj)
                    if InputObj.KeyCode == CurrentInput.KeyCode then
                        Released = true
                    end
                end)

                repeat
                    task.wait()
                until Released or NextInput or UserInputService:GetFocusedTextBox() ~= nil or Library.Unloaded

                if BeganConn then BeganConn:Disconnect() end
                if EndedConn then EndedConn:Disconnect() end

                if UserInputService:GetFocusedTextBox() ~= nil or Library.Unloaded then
                    SetPickingState(false)
                    return
                end

                if Released then
                    break -- Use modifier key as bind
                elseif NextInput then
                    -- Add another modifier or continue to normal key
                    local OldModName = ModifiersInput[CurrentInput.KeyCode]
                    if OldModName and not table.find(ActiveModifiers, OldModName) then
                        ActiveModifiers[#ActiveModifiers + 1] = OldModName
                    end

                    CurrentInput = NextInput
                    if CurrentInput.KeyCode == Enum.KeyCode.Escape then
                        break
                    end
                end
            end

            local Key = "Unknown"
            if SpecialKeysInput[CurrentInput.UserInputType] ~= nil then
                Key = SpecialKeysInput[CurrentInput.UserInputType]
            elseif CurrentInput.UserInputType == Enum.UserInputType.Keyboard then
                Key = CurrentInput.KeyCode == Enum.KeyCode.Escape and "None" or CurrentInput.KeyCode.Name
            end

            ActiveModifiers = if CurrentInput.KeyCode == Enum.KeyCode.Escape or Key == "Unknown" then {} else ActiveModifiers

            KeyPicker.Toggled = if ParentObj.Type == "Toggle" then ParentObj.Value else false
            KeyPicker:SetValue({ Key, KeyPicker.Mode, ActiveModifiers })

            repeat
                task.wait()
            until not IsInputDown(CurrentInput) or UserInputService:GetFocusedTextBox()

            SetPickingState(false)
        end)
        Picker.MouseButton2Click:Connect(MenuTable.Toggle)

        table.insert(KeyPicker.Connections, UserInputService.InputBegan:Connect(function(Input: InputObject)
            if Library.Unloaded then
                return
            end

            local IsMouse = IsMouseClickInput(Input)
            if
                KeyPicker.Mode == "Always"
                or KeyPicker.Value == "Unknown"
                or KeyPicker.Value == "None"
                or Picking
                or Library.IsPicking
                or UserInputService:GetFocusedTextBox()
                or (IsMouse and Library.Toggled)
            then
                return
            end

            local Key = KeyPicker.Value
            local HoldingModifiers = AreModifiersHeld(KeyPicker.Modifiers)
            local HoldingKey = false

            if
                Key
                and HoldingModifiers == true
                and (
                    SpecialKeysInput[Input.UserInputType] == Key
                    or (Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode.Name == Key)
                )
            then
                HoldingKey = true
            end

            if KeyPicker.Mode == "Toggle" then
                if HoldingKey then
                    KeyPicker.Toggled = not KeyPicker.Toggled
                    KeyPicker:DoClick()
                end
            elseif KeyPicker.Mode == "Press" then
                if HoldingKey then
                    KeyPicker:DoClick()
                end
            end

            KeyPicker:Update()
        end))

        table.insert(KeyPicker.Connections, UserInputService.InputEnded:Connect(function(Input: InputObject)
            if Library.Unloaded then
                return
            end

            local IsMouse = IsMouseClickInput(Input)
            if
                KeyPicker.Value == "Unknown"
                or KeyPicker.Value == "None"
                or Picking
                or Library.IsPicking
                or UserInputService:GetFocusedTextBox()
                or (IsMouse and Library.Toggled)
            then
                return
            end

            KeyPicker:Update()
        end))

        KeyPicker:Update()

        if ParentObj.Addons then
            table.insert(ParentObj.Addons, KeyPicker)
        end

        KeyPicker.Default = KeyPicker.Value
        KeyPicker.DefaultModifiers = table.clone(KeyPicker.Modifiers or {})

        function KeyPicker:Destroy()
            KeyPicker.Destroyed = true

            if KeyPicker.Connections then
                for _, Connection in KeyPicker.Connections do
                    Connection:Disconnect()
                end
            end

            if KeybindsToggle and KeybindsToggle.Loaded then
                if KeybindsToggle.Holder then 
                    KeybindsToggle.Holder:Destroy()
                end
                local KTIdx = table.find(Library.KeybindToggles, KeybindsToggle)
                if KTIdx then
                    table.remove(Library.KeybindToggles, KTIdx)
                end
            end

            if MenuTable then 
                MenuTable:Destroy() 
            end

            if IsForButton and SlideOverflow then
                if SlideForwardTween then 
                    SlideForwardTween:Destroy() 
                end

                if SlideBackTween then 
                    SlideBackTween:Destroy() 
                end
            end

            if Picker then
                Picker:Destroy()
            end

            if ParentObj and ParentObj.Addons then
                local AddonIdx = table.find(ParentObj.Addons, KeyPicker)
                
                if AddonIdx then 
                    table.remove(ParentObj.Addons, AddonIdx) 
                end
            end

            Options[Idx] = nil
        end

        Options[Idx] = KeyPicker

        return self
    end

    local HueSequenceTable = {}
    for Hue = 0, 1, 0.1 do
        table.insert(HueSequenceTable, ColorSequenceKeypoint.new(Hue, Color3.fromHSV(Hue, 1, 1)))
    end
    function Funcs:AddColorPicker(Idx, Info)
        if self.Destroyed then return nil end

        Info = Library:Validate(Info, Templates.ColorPicker)

        local ParentObj = self
        local ToggleLabel = ParentObj.TextLabel

        local ColorPicker = {
            Connections = {},
            Destroyed = false,

            Value = Info.Default,

            Transparency = Info.Transparency or 0,
            Title = Info.Title,

            Callback = Info.Callback,
            Changed = Info.Changed,

            Type = "ColorPicker",
        }
        ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = ColorPicker.Value:ToHSV()

        local Holder = New("TextButton", {
            BackgroundColor3 = ColorPicker.Value,
            Size = UDim2.fromOffset(18, 18),
            Text = "",
            Parent = ToggleLabel,
        })

        local HolderStroke = New("UIStroke", {
            Color = Library:GetDarkerColor(ColorPicker.Value),
            Parent = Holder,
        })

        local ColorPickerCorner = New("UICorner", {
            TopLeftRadius = UDim.new(0, Library.CornerRadius / 2),
            TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
            BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
            BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
            Parent = Holder,
        }); table.insert(Library.SpecificCorners, ColorPickerCorner)

        local HolderTransparency = New("ImageLabel", {
            Image = CustomImageManager.GetAsset("TransparencyTexture"),
            ImageTransparency = (1 - ColorPicker.Transparency),
            ScaleType = Enum.ScaleType.Tile,
            Position = UDim2.new(0, -1, 0, -1),
            Size = UDim2.new(1, 2, 1, 2),
            TileSize = UDim2.fromOffset(9, 9),
            Parent = Holder,
        })

        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = HolderTransparency,
            })
        )

        --// Color Menu \\--
        local ColorMenu = Library:AddContextMenu(
            Holder,
            UDim2.fromOffset(Info.Transparency and 256 or 234, 0),
            function()
                return { 0.5, Holder.AbsoluteSize.Y + 1.5 }
            end,
            1, function(Active: boolean)
                ColorPickerCorner.BottomRightRadius = Active and UDim.new(0, 0) or UDim.new(0, Library.CornerRadius / 2)
                ColorPickerCorner.BottomLeftRadius = Active and UDim.new(0, 0) or UDim.new(0, Library.CornerRadius / 2)
            end, false, "no_top_left")
        ColorMenu.List.Padding = UDim.new(0, 8)
        ColorPicker.ColorMenu = ColorMenu

        New("UIPadding", {
            PaddingBottom = UDim.new(0, 6),
            PaddingLeft = UDim.new(0, 6),
            PaddingRight = UDim.new(0, 6),
            PaddingTop = UDim.new(0, 6),
            Parent = ColorMenu.Menu,
        })

        if typeof(ColorPicker.Title) == "string" then
            New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 8),
                Text = ColorPicker.Title,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ColorMenu.Menu,
            })
        end

        local ColorHolder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 200),
            Parent = ColorMenu.Menu,
        })
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 6),
            Parent = ColorHolder,
        })

        --// Sat Map
        local SatVipMap = New("ImageButton", {
            BackgroundColor3 = ColorPicker.Value,
            Image = CustomImageManager.GetAsset("SaturationMap"),
            Size = UDim2.fromOffset(200, 200),
            Parent = ColorHolder,
        })

        local SatVibCursor = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = "WhiteColor",
            Size = UDim2.fromOffset(6, 6),
            Parent = SatVipMap,
        })
        New("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = SatVibCursor,
        })
        New("UIStroke", {
            Color = "DarkColor",
            Parent = SatVibCursor,
        })

        --// Hue
        local HueSelector = New("TextButton", {
            Size = UDim2.fromOffset(16, 200),
            Text = "",
            Parent = ColorHolder,
        })
        New("UIGradient", {
            Color = ColorSequence.new(HueSequenceTable),
            Rotation = 90,
            Parent = HueSelector,
        })

        local HueCursor = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = "WhiteColor",
            BorderColor3 = "DarkColor",
            BorderSizePixel = 1,
            Position = UDim2.fromScale(0.5, ColorPicker.Hue),
            Size = UDim2.new(1, 2, 0, 1),
            Parent = HueSelector,
        })

        --// Alpha
        local TransparencySelector, TransparencyColor, TransparencyCursor
        if Info.Transparency then
            TransparencySelector = New("ImageButton", {
                Image = CustomImageManager.GetAsset("TransparencyTexture"),
                ScaleType = Enum.ScaleType.Tile,
                Size = UDim2.fromOffset(16, 200),
                TileSize = UDim2.fromOffset(8, 8),
                Parent = ColorHolder,
            })

            TransparencyColor = New("Frame", {
                BackgroundColor3 = ColorPicker.Value,
                Size = UDim2.fromScale(1, 1),
                Parent = TransparencySelector,
            })
            New("UIGradient", {
                Rotation = 90,
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1),
                }),
                Parent = TransparencyColor,
            })

            TransparencyCursor = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = "WhiteColor",
                BorderColor3 = "DarkColor",
                BorderSizePixel = 1,
                Position = UDim2.fromScale(0.5, ColorPicker.Transparency),
                Size = UDim2.new(1, 2, 0, 1),
                Parent = TransparencySelector,
            })
        end

        local InfoHolder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20),
            Parent = ColorMenu.Menu,
        })
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            Padding = UDim.new(0, 8),
            Parent = InfoHolder,
        })

        local HueBox = New("TextBox", {
            BackgroundColor3 = "MainColor",
            ClearTextOnFocus = false,
            Size = UDim2.fromScale(1, 1),
            Text = "#??????",
            TextSize = 14,
            Parent = InfoHolder,
        })

        New("UIStroke", {
            Color = "OutlineColor",
            Parent = HueBox,
        })

        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = HueBox,
            })
        )

        local RgbBox = New("TextBox", {
            BackgroundColor3 = "MainColor",
            ClearTextOnFocus = false,
            Size = UDim2.fromScale(1, 1),
            Text = "?, ?, ?",
            TextSize = 14,
            Parent = InfoHolder,
        })

        New("UIStroke", {
            Color = "OutlineColor",
            Parent = RgbBox,
        })

        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = RgbBox,
            })
        )

        --// Context Menu \\--
        local ContextMenu = Library:AddContextMenu(Holder, UDim2.fromOffset(93, 0), function()
            return { Holder.AbsoluteSize.X + 1.5, 0.5 }
        end, 1, function(Active: boolean)
            ColorPickerCorner.TopRightRadius = Active and UDim.new(0, 0) or UDim.new(0, Library.CornerRadius / 2)
            ColorPickerCorner.BottomRightRadius = Active and UDim.new(0, 0) or UDim.new(0, Library.CornerRadius / 2)
        end, false, "no_top_left")
        ColorPicker.ContextMenu = ContextMenu
        ContextMenu.List.Padding = UDim.new(0, 6)
        do
            local function CreateButton(Text, Func)
                local Button = New("TextButton", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 21),
                    Text = Text,
                    TextSize = 14,
                    Parent = ContextMenu.Menu,
                })

                Button.MouseButton1Click:Connect(function()
                    Library:SafeCallback(Func)
                    ContextMenu:Close()
                end)
            end

            CreateButton("复制颜色", function()
                Library.CopiedColor = { ColorPicker.Value, ColorPicker.Transparency }
            end)

            ColorPicker.SetValueRGB = function(...) end --// make luau lsp shut up
            CreateButton("粘贴颜色", function()
                ColorPicker:SetValueRGB(Library.CopiedColor[1], Library.CopiedColor[2])
            end)

            if setclipboard then
                CreateButton("复制十六进制", function()
                    setclipboard(tostring(ColorPicker.Value:ToHex()))
                end)

                CreateButton("复制RGB", function()
                    setclipboard(table.concat({
                        math.floor(ColorPicker.Value.R * 255),
                        math.floor(ColorPicker.Value.G * 255),
                        math.floor(ColorPicker.Value.B * 255),
                    }, ", "))
                end)
            end
        end

        --// End \\--
        function ColorPicker:SetHSVFromRGB(Color)
            ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color:ToHSV()
        end

        function ColorPicker:Display()
            if Library.Unloaded then
                return
            end

            ColorPicker.Value = Color3.fromHSV(ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib)

            Holder.BackgroundColor3 = ColorPicker.Value
            HolderStroke.Color = Library:GetDarkerColor(ColorPicker.Value)
            HolderTransparency.ImageTransparency = (1 - ColorPicker.Transparency)

            SatVipMap.BackgroundColor3 = Color3.fromHSV(ColorPicker.Hue, 1, 1)
            if TransparencyColor then
                TransparencyColor.BackgroundColor3 = ColorPicker.Value
            end

            SatVibCursor.Position = UDim2.fromScale(ColorPicker.Sat, 1 - ColorPicker.Vib)
            HueCursor.Position = UDim2.fromScale(0.5, ColorPicker.Hue)
            if TransparencyCursor then
                TransparencyCursor.Position = UDim2.fromScale(0.5, ColorPicker.Transparency)
            end

            HueBox.Text = "#" .. ColorPicker.Value:ToHex()
            RgbBox.Text = table.concat({
                math.floor(ColorPicker.Value.R * 255),
                math.floor(ColorPicker.Value.G * 255),
                math.floor(ColorPicker.Value.B * 255),
            }, ", ")
        end

        function ColorPicker:RunChanged()
            Library:SafeCallback(ColorPicker.Callback, ColorPicker.Value)
            Library:SafeCallback(ColorPicker.Changed, ColorPicker.Value)
        end

        function ColorPicker:Update()
            ColorPicker:Display()
            ColorPicker:RunChanged()
        end

        function ColorPicker:OnChanged(Func)
            ColorPicker.Changed = Func
        end

        function ColorPicker:SetValue(HSV, Transparency)
            if typeof(HSV) == "Color3" then
                ColorPicker:SetValueRGB(HSV, Transparency)
                return
            end

            local Color = Color3.fromHSV(HSV[1], HSV[2], HSV[3])
            ColorPicker.Transparency = Info.Transparency and Transparency or 0
            ColorPicker:SetHSVFromRGB(Color)
            ColorPicker:Update()
        end

        function ColorPicker:SetValueRGB(Color, Transparency)
            ColorPicker.Transparency = Info.Transparency and Transparency or 0
            ColorPicker:SetHSVFromRGB(Color)
            ColorPicker:Update()
        end

        table.insert(ColorPicker.Connections, Holder.MouseButton1Click:Connect(ColorMenu.Toggle))
        table.insert(ColorPicker.Connections, Holder.MouseButton2Click:Connect(ContextMenu.Toggle))

        table.insert(ColorPicker.Connections, SatVipMap.InputBegan:Connect(function(Input: InputObject)
            while IsDragInput(Input) and not ColorPicker.Destroyed do
                local MinX = SatVipMap.AbsolutePosition.X
                local MaxX = MinX + SatVipMap.AbsoluteSize.X
                local LocationX = math.clamp(Mouse.X, MinX, MaxX)

                local MinY = SatVipMap.AbsolutePosition.Y
                local MaxY = MinY + SatVipMap.AbsoluteSize.Y
                local LocationY = math.clamp(Mouse.Y, MinY, MaxY)

                local OldSat = ColorPicker.Sat
                local OldVib = ColorPicker.Vib
                ColorPicker.Sat = (LocationX - MinX) / (MaxX - MinX)
                ColorPicker.Vib = 1 - ((LocationY - MinY) / (MaxY - MinY))

                if ColorPicker.Sat ~= OldSat or ColorPicker.Vib ~= OldVib then
                    ColorPicker:Update()
                end

                RunService.RenderStepped:Wait()
            end
        end))

        table.insert(ColorPicker.Connections, HueSelector.InputBegan:Connect(function(Input: InputObject)
            while IsDragInput(Input) and not ColorPicker.Destroyed do
                local Min = HueSelector.AbsolutePosition.Y
                local Max = Min + HueSelector.AbsoluteSize.Y
                local Location = math.clamp(Mouse.Y, Min, Max)

                local OldHue = ColorPicker.Hue
                ColorPicker.Hue = (Location - Min) / (Max - Min)

                if ColorPicker.Hue ~= OldHue then
                    ColorPicker:Update()
                end

                RunService.RenderStepped:Wait()
            end
        end))
        
        if TransparencySelector then
            table.insert(ColorPicker.Connections, TransparencySelector.InputBegan:Connect(function(Input: InputObject)
                while IsDragInput(Input) and not ColorPicker.Destroyed do
                    local Min = TransparencySelector.AbsolutePosition.Y
                    local Max = TransparencySelector.AbsolutePosition.Y + TransparencySelector.AbsoluteSize.Y
                    local Location = math.clamp(Mouse.Y, Min, Max)

                    local OldTransparency = ColorPicker.Transparency
                    ColorPicker.Transparency = (Location - Min) / (Max - Min)

                    if ColorPicker.Transparency ~= OldTransparency then
                        ColorPicker:Update()
                    end

                    RunService.RenderStepped:Wait()
                end
            end))
        end

        table.insert(ColorPicker.Connections, HueBox.FocusLost:Connect(function(Enter)
            if not Enter then
                return
            end

            local Success, Color = pcall(Color3.fromHex, HueBox.Text)
            if Success and typeof(Color) == "Color3" then
                ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color:ToHSV()
            end

            ColorPicker:Update()
        end))

        table.insert(ColorPicker.Connections, RgbBox.FocusLost:Connect(function(Enter)
            if not Enter then
                return
            end

            local R, G, B = RgbBox.Text:match("(%d+),%s*(%d+),%s*(%d+)")
            if R and G and B then
                ColorPicker:SetHSVFromRGB(Color3.fromRGB(R, G, B))
            end

            ColorPicker:Update()
        end))

        ColorPicker:Display()

        if ParentObj.Addons then
            table.insert(ParentObj.Addons, ColorPicker)
        end

        ColorPicker.Default = ColorPicker.Value

        function ColorPicker:Destroy()
            ColorPicker.Destroyed = true

            if ColorPicker.Connections then
                for _, Connection in ColorPicker.Connections do
                    Connection:Disconnect()
                end
            end

            if ColorMenu then 
                ColorMenu:Destroy() 
            end

            if ContextMenu then 
                ContextMenu:Destroy() 
            end

            if Holder then 
                Holder:Destroy() 
            end

            if ParentObj and ParentObj.Addons then
                local AddonIdx = table.find(ParentObj.Addons, ColorPicker)
                
                if AddonIdx then 
                    table.remove(ParentObj.Addons, AddonIdx) 
                end
            end

            Options[Idx] = nil
        end

        Options[Idx] = ColorPicker

        return self
    end

    BaseAddons.__index = Funcs
    BaseAddons.__namecall = function(_, Key, ...)
        return Funcs[Key](...)
    end
end

local BaseGroupbox = {}
do
    local Funcs = {}

    function Funcs:AddDivider(...)
        if self.Destroyed then return nil end

        local Params = select(1, ...)
        local Text
        local MarginTop = 0
        local MarginBottom = 0

        if typeof(Params) == "table" then
            Text = Params.Text
            MarginTop = Params.MarginTop or Params.Margin or 0
            MarginBottom = Params.MarginBottom or Params.Margin or 0
        elseif typeof(Params) == "string" then
            Text = Params
        end

        local Groupbox = self
        local Container = Groupbox.Container

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 6 + MarginTop + MarginBottom),
            Parent = Container,
        })

        local InnerHolder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Parent = Holder,
        })

        New("UIPadding", {
            PaddingTop = UDim.new(0, MarginTop),
            PaddingBottom = UDim.new(0, MarginBottom),
            Parent = Holder,
        })

        if Text then
            local TextLabel = New("TextLabel", {
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 0),
                Text = Text,
                TextSize = 14,
                TextTransparency = 0.5,
                TextXAlignment = Enum.TextXAlignment.Center,
                Parent = InnerHolder,
            })

            local X, _ = Library:GetTextBounds(Text, TextLabel.FontFace, TextLabel.TextSize, TextLabel.AbsoluteSize.X)
            local SizeX = X // 2 + 10

            New("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = "MainColor",
                BorderColor3 = "OutlineColor",
                BorderSizePixel = 1,
                Position = UDim2.fromScale(0, 0.5),
                Size = UDim2.new(0.5, -SizeX, 0, 2),
                Parent = InnerHolder,
            })
            New("Frame", {
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = "MainColor",
                BorderColor3 = "OutlineColor",
                BorderSizePixel = 1,
                Position = UDim2.fromScale(1, 0.5),
                Size = UDim2.new(0.5, -SizeX, 0, 2),
                Parent = InnerHolder,
            })
        else
            New("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = "MainColor",
                BorderColor3 = "OutlineColor",
                BorderSizePixel = 1,
                Position = UDim2.fromScale(0, 0.5),
                Size = UDim2.new(1, 0, 0, 2),
                Parent = InnerHolder,
            })
        end

        Groupbox:Resize()

        local Divider = {
            Connections = {},
            Destroyed = false,

            Holder = Holder,
            Text = Text,
            MarginTop = MarginTop,
            MarginBottom = MarginBottom,
            Type = "Divider",
        }

        function Divider:SetVisible(Value)
            Holder.Visible = Value == true
            Groupbox:Resize()
        end

        function Divider:Destroy()
            Divider.Destroyed = true

            if Divider.Connections then
                for _, Connection in Divider.Connections do
                    Connection:Disconnect()
                end
            end

            if Holder then 
                Holder:Destroy() 
            end

            local ElemIdx = table.find(Groupbox.Elements, Divider)
            if ElemIdx then 
                table.remove(Groupbox.Elements, ElemIdx) 
            end

            Groupbox:Resize()
        end

        table.insert(Groupbox.Elements, Divider)
        return Divider
    end

    function Funcs:AddLabel(...)
        if self.Destroyed then return nil end

        local Data = {}
        local Addons = {}

        local First = select(1, ...)
        local Second = select(2, ...)

        if typeof(First) == "table" or typeof(Second) == "table" then
            local Params = typeof(First) == "table" and First or Second

            Data.Text = Params.Text or ""
            Data.DoesWrap = Params.DoesWrap or false
            Data.Size = Params.Size or 14
            Data.Visible = Params.Visible or true
            Data.Idx = typeof(Second) == "table" and First or nil
        else
            Data.Text = First or ""
            Data.DoesWrap = Second or false
            Data.Size = 14
            Data.Visible = true
            Data.Idx = select(3, ...) or nil
        end

        local Groupbox = self
        local Container = Groupbox.Container

        local Label = {
            Connections = {},
            Destroyed = false,

            Text = Data.Text,
            DoesWrap = Data.DoesWrap,

            Addons = Addons,

            Visible = Data.Visible,
            Type = "Label",
        }

        local TextLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 18),
            Text = Label.Text,
            TextSize = Data.Size,
            TextWrapped = Label.DoesWrap,
            TextXAlignment = Groupbox.IsKeyTab and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left,
            Parent = Container,
        })

        function Label:Display()
            if not Label.DoesWrap then
                return
            end

            local Width = TextLabel.AbsoluteSize.X
            if Width <= 0 then return end

            local _, Y = Library:GetTextBounds(Label.Text, TextLabel.FontFace, TextLabel.TextSize, Width)
            TextLabel.Size = UDim2.new(1, 0, 0, Y + 4)
        end

        function Label:SetVisible(Visible: boolean)
            Label.Visible = Visible

            TextLabel.Visible = Label.Visible
            Groupbox:Resize()
        end

        function Label:SetText(Text: string)
            Label.Text = Text
            TextLabel.Text = Text

            Label:Display()
            Groupbox:Resize()
        end

        if Label.DoesWrap then
            Label:Display()

            local Last = TextLabel.AbsoluteSize
            TextLabel:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                if TextLabel.AbsoluteSize == Last then
                    return
                end

                Label:Display()
                Last = TextLabel.AbsoluteSize

                Groupbox:Resize()
            end)
        else
            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                Padding = UDim.new(0, 6),
                Parent = TextLabel,
            })
        end

        Groupbox:Resize()

        Label.TextLabel = TextLabel
        Label.Container = Container
        if not Data.DoesWrap then
            setmetatable(Label, BaseAddons)
        end

        Label.Holder = TextLabel
        table.insert(Groupbox.Elements, Label)

        if Data.Idx then
            Labels[Data.Idx] = Label
        else
            table.insert(Labels, Label)
        end

        function Label:Destroy()
            Label.Destroyed = true

            if Label.Connections then
                for _, Connection in Label.Connections do
                    Connection:Disconnect()
                end
            end

            if Label.Addons then
                for Index = #Label.Addons, 1, -1 do
                    local Addon = table.remove(Label.Addons, Index)
                    if Addon and Addon.Destroy then
                        Addon:Destroy()
                    end
                end
            end

            if TextLabel then 
                TextLabel:Destroy() 
            end

            local ElemIdx = table.find(Groupbox.Elements, Label)
            if ElemIdx then 
                table.remove(Groupbox.Elements, ElemIdx) 
            end

            Groupbox:Resize()

            if Data.Idx then
                Labels[Data.Idx] = nil
            else
                local LblIdx = table.find(Labels, Label)
                
                if LblIdx then 
                    table.remove(Labels, LblIdx) 
                end
            end
        end

        return Label
    end

    function Funcs:AddButton(...)
        if self.Destroyed then return nil end

        local function GetInfo(...)
            local Info = {}

            local First = select(1, ...)
            local Second = select(2, ...)

            if typeof(First) == "table" or typeof(Second) == "table" then
                local Params = typeof(First) == "table" and First or Second

                Info.Text = Params.Text or ""
                Info.Func = Params.Func or Params.Callback or function() end
                Info.DoubleClick = Params.DoubleClick

                Info.Tooltip = Params.Tooltip
                Info.DisabledTooltip = Params.DisabledTooltip

                Info.Risky = Params.Risky or false
                Info.Disabled = Params.Disabled or false
                Info.Visible = Params.Visible or true
                Info.Idx = typeof(Second) == "table" and First or nil
            else
                Info.Text = First or ""
                Info.Func = Second or function() end
                Info.DoubleClick = false

                Info.Tooltip = nil
                Info.DisabledTooltip = nil

                Info.Risky = false
                Info.Disabled = false
                Info.Visible = true
                Info.Idx = select(3, ...) or nil
            end

            return Info
        end
        local Info = GetInfo(...)

        local Groupbox = self
        local Container = Groupbox.Container

        local Button = {
            Connections = {},
            Destroyed = false,

            Text = Info.Text,
            Func = Info.Func,
            DoubleClick = Info.DoubleClick,

            Tooltip = Info.Tooltip,
            DisabledTooltip = Info.DisabledTooltip,
            TooltipTable = nil,

            Risky = Info.Risky,
            Disabled = Info.Disabled,
            Visible = Info.Visible,

            Tween = nil,
            Type = "Button",
        }

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 21),
            Parent = Container,
        })

        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            Padding = UDim.new(0, 9),
            Parent = Holder,
        })

        local function CreateButton(Button)
            local Base = New("TextButton", {
                Active = not Button.Disabled,
                BackgroundColor3 = Button.Disabled and "BackgroundColor" or "MainColor",
                Size = UDim2.fromScale(1, 1),
                Text = Button.Text,
                TextSize = 14,
                TextTransparency = 0.4,
                Visible = Button.Visible,
                Parent = Holder,
            })

            local Stroke = New("UIStroke", {
                Color = "OutlineColor",
                Transparency = Button.Disabled and 0.5 or 0,
                Parent = Base,
            })

            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                    Parent = Base,
                })
            )

            return Base, Stroke
        end

        local function InitEvents(Button)
            Button.Base.MouseEnter:Connect(function()
                if Button.Disabled then
                    return
                end

                Button.Tween = TweenService:Create(Button.Base, Library.TweenInfo, {
                    TextTransparency = 0,
                })
                Button.Tween:Play()
            end)
            Button.Base.MouseLeave:Connect(function()
                if Button.Disabled then
                    return
                end

                Button.Tween = TweenService:Create(Button.Base, Library.TweenInfo, {
                    TextTransparency = 0.4,
                })
                Button.Tween:Play()
            end)

            Button.Base.MouseButton1Click:Connect(function()
                if Button.Disabled or Button.Locked then
                    return
                end

                if Button.DoubleClick then
                    Button.Locked = true

                    Button.Base.Text = "你确定吗?"
                    Button.Base.TextColor3 = Library.Scheme.AccentColor
                    Library.Registry[Button.Base].TextColor3 = "AccentColor"

                    local Clicked = WaitForEvent(Button.Base.MouseButton1Click, 0.5)

                    Button.Base.Text = Button.Text
                    Button.Base.TextColor3 = Button.Risky and Library.Scheme.RedColor or Library.Scheme.FontColor
                    Library.Registry[Button.Base].TextColor3 = Button.Risky and "RedColor" or "FontColor"

                    if Clicked then
                        Library:SafeCallback(Button.Func)
                    end

                    RunService.RenderStepped:Wait() --// Mouse Button fires without waiting (i hate roblox)
                    Button.Locked = false
                    return
                end

                Library:SafeCallback(Button.Func)
            end)
        end

        Button.Base, Button.Stroke = CreateButton(Button)
        InitEvents(Button)

        function Button:AddButton(...)
            local Info = GetInfo(...)

            local SubButton = {
                Connections = {},
                Destroyed = false,

                Text = Info.Text,
                Func = Info.Func,
                DoubleClick = Info.DoubleClick,

                Tooltip = Info.Tooltip,
                DisabledTooltip = Info.DisabledTooltip,
                TooltipTable = nil,

                Risky = Info.Risky,
                Disabled = Info.Disabled,
                Visible = Info.Visible,

                Tween = nil,
                Type = "SubButton",
            }

            Button.SubButton = SubButton
            SubButton.Base, SubButton.Stroke = CreateButton(SubButton)
            InitEvents(SubButton)

            function SubButton:UpdateColors()
                if Library.Unloaded then
                    return
                end

                StopTween(SubButton.Tween)

                SubButton.Base.BackgroundColor3 = SubButton.Disabled and Library.Scheme.BackgroundColor
                    or Library.Scheme.MainColor
                SubButton.Base.TextTransparency = SubButton.Disabled and 0.8 or 0.4
                SubButton.Stroke.Transparency = SubButton.Disabled and 0.5 or 0

                Library.Registry[SubButton.Base].BackgroundColor3 = SubButton.Disabled and "BackgroundColor"
                    or "MainColor"
            end

            function SubButton:SetDisabled(Disabled: boolean)
                SubButton.Disabled = Disabled

                if SubButton.TooltipTable then
                    SubButton.TooltipTable.Disabled = SubButton.Disabled
                end

                SubButton.Base.Active = not SubButton.Disabled
                SubButton:UpdateColors()
            end

            function SubButton:SetVisible(Visible: boolean)
                SubButton.Visible = Visible

                SubButton.Base.Visible = SubButton.Visible
                Groupbox:Resize()
            end

            function SubButton:SetText(Text: string)
                SubButton.Text = Text
                SubButton.Base.Text = Text
            end

            if typeof(SubButton.Tooltip) == "string" or typeof(SubButton.DisabledTooltip) == "string" then
                SubButton.TooltipTable =
                    Library:AddTooltip(SubButton.Tooltip, SubButton.DisabledTooltip, SubButton.Base)
                SubButton.TooltipTable.Disabled = SubButton.Disabled
            end

            if SubButton.Risky then
                SubButton.Base.TextColor3 = Library.Scheme.RedColor
                Library.Registry[SubButton.Base].TextColor3 = "RedColor"
            end

            SubButton:UpdateColors()

            if Info.Idx then
                Buttons[Info.Idx] = SubButton
            else
                table.insert(Buttons, SubButton)
            end

            SubButton.AddKeyPicker = BaseAddons.__index.AddKeyPicker

            function SubButton:Destroy()
                SubButton.Destroyed = true

                if SubButton.TooltipTable then 
                    SubButton.TooltipTable:Destroy() 
                end

                if SubButton.Tween then 
                    SubButton.Tween:Destroy() 
                end

                if SubButton.Base then 
                    SubButton.Base:Destroy() 
                end

                if Info.Idx then
                    Buttons[Info.Idx] = nil
                else
                    local BIdx = table.find(Buttons, SubButton)
                    
                    if BIdx then 
                        table.remove(Buttons, BIdx) 
                    end
                end
            end

            return SubButton
        end

        function Button:UpdateColors()
            if Library.Unloaded then
                return
            end

            StopTween(Button.Tween)

            Button.Base.BackgroundColor3 = Button.Disabled and Library.Scheme.BackgroundColor
                or Library.Scheme.MainColor
            Button.Base.TextTransparency = Button.Disabled and 0.8 or 0.4
            Button.Stroke.Transparency = Button.Disabled and 0.5 or 0

            Library.Registry[Button.Base].BackgroundColor3 = Button.Disabled and "BackgroundColor" or "MainColor"
        end

        function Button:SetDisabled(Disabled: boolean)
            Button.Disabled = Disabled

            if Button.TooltipTable then
                Button.TooltipTable.Disabled = Button.Disabled
            end

            Button.Base.Active = not Button.Disabled
            Button:UpdateColors()
        end

        function Button:SetVisible(Visible: boolean)
            Button.Visible = Visible

            Holder.Visible = Button.Visible
            Groupbox:Resize()
        end

        function Button:SetText(Text: string)
            Button.Text = Text
            Button.Base.Text = Text
        end

        if typeof(Button.Tooltip) == "string" or typeof(Button.DisabledTooltip) == "string" then
            Button.TooltipTable = Library:AddTooltip(Button.Tooltip, Button.DisabledTooltip, Button.Base)
            Button.TooltipTable.Disabled = Button.Disabled
        end

        if Button.Risky then
            Button.Base.TextColor3 = Library.Scheme.RedColor
            Library.Registry[Button.Base].TextColor3 = "RedColor"
        end

        Button:UpdateColors()
        Groupbox:Resize()

        Button.Holder = Holder
        table.insert(Groupbox.Elements, Button)

        if Info.Idx then
            Buttons[Info.Idx] = Button
        else
            table.insert(Buttons, Button)
        end

        Button.AddKeyPicker = BaseAddons.__index.AddKeyPicker

        function Button:Destroy()
            Button.Destroyed = true

            if Button.TooltipTable then 
                Button.TooltipTable:Destroy() 
            end

            if Button.Tween then 
                Button.Tween:Destroy() 
            end

            if Button.SubButton then 
                Button.SubButton:Destroy() 
            end

            if Holder then 
                Holder:Destroy() 
            end

            local ElemIdx = table.find(Groupbox.Elements, Button)
            if ElemIdx then 
                table.remove(Groupbox.Elements, ElemIdx) 
            end

            Groupbox:Resize()

            if Info.Idx then
                Buttons[Info.Idx] = nil
            else
                local BIdx = table.find(Buttons, Button)
                
                if BIdx then 
                    table.remove(Buttons, BIdx) 
                end
            end
        end

        return Button
    end

    function Funcs:AddCheckbox(Idx, Info)
        if self.Destroyed then return nil end

        Info = Library:Validate(Info, Templates.Toggle)

        local Groupbox = self
        local Container = Groupbox.Container

        local Toggle = {
            Connections = {},
            Destroyed = false,

            Text = Info.Text,
            Value = Info.Default,

            Tooltip = Info.Tooltip,
            DisabledTooltip = Info.DisabledTooltip,
            TooltipTable = nil,

            Callback = Info.Callback,
            Changed = Info.Changed,

            Risky = Info.Risky,
            Disabled = Info.Disabled,
            Visible = Info.Visible,

            Addons = {},
            AnyKeyPickerPicking = false,

            Variant = "Checkbox",
            Type = "Toggle",
        }

        local Button = New("TextButton", {
            Active = not Toggle.Disabled,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 18),
            Text = "",
            Visible = Toggle.Visible,
            Parent = Container,
        })

        local Label = New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(26, 0),
            Size = UDim2.new(1, -26, 1, 0),
            Text = Toggle.Text,
            TextSize = 14,
            TextTransparency = 0.4,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Button,
        })

        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0, 6),
            Parent = Label,
        })

        local Checkbox = New("Frame", {
            BackgroundColor3 = "MainColor",
            Size = UDim2.fromScale(1, 1),
            SizeConstraint = Enum.SizeConstraint.RelativeYY,
            Parent = Button,
        })
        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Checkbox,
            })
        )

        local CheckboxStroke = New("UIStroke", {
            Color = "OutlineColor",
            Parent = Checkbox,
        })

        local CheckImage = New("ImageLabel", {
            Image = CheckIcon and CheckIcon.Url or "",
            ImageColor3 = "FontColor",
            ImageRectOffset = CheckIcon and CheckIcon.ImageRectOffset or Vector2.zero,
            ImageRectSize = CheckIcon and CheckIcon.ImageRectSize or Vector2.zero,
            ImageTransparency = 1,
            Position = UDim2.fromOffset(2, 2),
            Size = UDim2.new(1, -4, 1, -4),
            Parent = Checkbox,
        })

        function Toggle:UpdateColors()
            Toggle:Display()
        end

        function Toggle:Display()
            if Library.Unloaded then
                return
            end

            CheckboxStroke.Transparency = Toggle.Disabled and 0.5 or 0

            if Toggle.Disabled then
                Label.TextTransparency = 0.8
                CheckImage.ImageTransparency = Toggle.Value and 0.8 or 1

                Checkbox.BackgroundColor3 = Library.Scheme.BackgroundColor
                Library.Registry[Checkbox].BackgroundColor3 = "BackgroundColor"

                return
            end

            TweenService:Create(Label, Library.TweenInfo, {
                TextTransparency = Toggle.Value and 0 or 0.4,
            }):Play()
            TweenService:Create(CheckImage, Library.TweenInfo, {
                ImageTransparency = Toggle.Value and 0 or 1,
            }):Play()

            Checkbox.BackgroundColor3 = Library.Scheme.MainColor
            Library.Registry[Checkbox].BackgroundColor3 = "MainColor"
        end

        function Toggle:OnChanged(Func)
            Toggle.Changed = Func
        end

        function Toggle:RunChanged()
            Library:SafeCallback(Toggle.Callback, Toggle.Value)
            Library:SafeCallback(Toggle.Changed, Toggle.Value)
        end

        function Toggle:SetValue(Value)
            if Toggle.Disabled then
                return
            end

            Toggle.Value = Value
            Toggle:Display()

            for _, Addon in Toggle.Addons do
                if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
                    Addon.Toggled = Toggle.Value
                    Addon:Update()
                end
            end

            Library:UpdateDependencyBoxes()

            if not Toggle.AnyKeyPickerPicking then
                Toggle:RunChanged()
            end
        end

        function Toggle:SetDisabled(Disabled: boolean)
            Toggle.Disabled = Disabled

            if Toggle.TooltipTable then
                Toggle.TooltipTable.Disabled = Toggle.Disabled
            end

            for _, Addon in Toggle.Addons do
                if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
                    Addon:Update()
                end
            end

            Button.Active = not Toggle.Disabled
            Toggle:Display()
        end

        function Toggle:SetVisible(Visible: boolean)
            Toggle.Visible = Visible

            Button.Visible = Toggle.Visible
            Groupbox:Resize()
        end

        function Toggle:SetText(Text: string)
            Toggle.Text = Text
            Label.Text = Text
        end

        table.insert(Toggle.Connections, Button.MouseButton1Click:Connect(function()
            if Toggle.Disabled then
                return
            end

            Toggle:SetValue(not Toggle.Value)
        end))

        if typeof(Toggle.Tooltip) == "string" or typeof(Toggle.DisabledTooltip) == "string" then
            Toggle.TooltipTable = Library:AddTooltip(Toggle.Tooltip, Toggle.DisabledTooltip, Button)
            Toggle.TooltipTable.Disabled = Toggle.Disabled
        end

        if Toggle.Risky then
            Label.TextColor3 = Library.Scheme.RedColor
            Library.Registry[Label].TextColor3 = "RedColor"
        end

        Toggle:Display()
        Groupbox:Resize()

        Toggle.TextLabel = Label
        Toggle.Container = Container
        setmetatable(Toggle, BaseAddons)

        Toggle.Holder = Button
        table.insert(Groupbox.Elements, Toggle)

        Toggle.Default = Toggle.Value

        Toggles[Idx] = Toggle

        function Toggle:Destroy()
            Toggle.Destroyed = true

            if Toggle.Connections then
                for _, Connection in Toggle.Connections do
                    Connection:Disconnect()
                end
            end

            if Toggle.TooltipTable then 
                Toggle.TooltipTable:Destroy() 
            end

            if Button then 
                Button:Destroy() 
            end

            if Toggle.Addons then
                for Index = #Toggle.Addons, 1, -1 do
                    local Addon = table.remove(Toggle.Addons, Index)
                    if Addon and Addon.Destroy then
                        Addon:Destroy()
                    end
                end
            end

            local ElemIdx = table.find(Groupbox.Elements, Toggle)
            if ElemIdx then 
                table.remove(Groupbox.Elements, ElemIdx) 
            end

            Groupbox:Resize()
            Toggles[Idx] = nil
        end

        return Toggle
    end

    function Funcs:AddToggle(Idx, Info)
        if self.Destroyed then return nil end

        if Library.ForceCheckbox then
            return Funcs.AddCheckbox(self, Idx, Info)
        end

        Info = Library:Validate(Info, Templates.Toggle)

        local Groupbox = self
        local Container = Groupbox.Container

        local Toggle = {
            Connections = {},
            Destroyed = false,

            Text = Info.Text,
            Value = Info.Default,

            Tooltip = Info.Tooltip,
            DisabledTooltip = Info.DisabledTooltip,
            TooltipTable = nil,

            Callback = Info.Callback,
            Changed = Info.Changed,

            Risky = Info.Risky,
            Disabled = Info.Disabled,
            Visible = Info.Visible,

            Addons = {},
            AnyKeyPickerPicking = false,

            Variant = "Switch",
            Type = "Toggle",
        }

        local Button = New("TextButton", {
            Active = not Toggle.Disabled,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 18),
            Text = "",
            Visible = Toggle.Visible,
            Parent = Container,
        })

        local Label = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -40, 1, 0),
            Text = Toggle.Text,
            TextSize = 14,
            TextTransparency = 0.4,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Button,
        })

        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0, 6),
            Parent = Label,
        })

        local Switch = New("Frame", {
            AnchorPoint = Vector2.new(1, 0),
            BackgroundColor3 = "MainColor",
            Position = UDim2.fromScale(1, 0),
            Size = UDim2.fromOffset(32, 18),
            Parent = Button,
        })
        New("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = Switch,
        })
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 2),
            PaddingLeft = UDim.new(0, 2),
            PaddingRight = UDim.new(0, 2),
            PaddingTop = UDim.new(0, 2),
            Parent = Switch,
        })
        local SwitchStroke = New("UIStroke", {
            Color = "OutlineColor",
            Parent = Switch,
        })

        local Ball = New("Frame", {
            BackgroundColor3 = "FontColor",
            Size = UDim2.fromScale(1, 1),
            SizeConstraint = Enum.SizeConstraint.RelativeYY,
            Parent = Switch,
        })
        New("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = Ball,
        })

        function Toggle:UpdateColors()
            Toggle:Display()
        end

        function Toggle:Display()
            if Library.Unloaded then
                return
            end

            local Offset = Toggle.Value and 1 or 0

            Switch.BackgroundTransparency = Toggle.Disabled and 0.75 or 0
            SwitchStroke.Transparency = Toggle.Disabled and 0.75 or 0

            Switch.BackgroundColor3 = Toggle.Value and Library.Scheme.AccentColor or Library.Scheme.MainColor
            SwitchStroke.Color = Toggle.Value and Library.Scheme.AccentColor or Library.Scheme.OutlineColor

            Library.Registry[Switch].BackgroundColor3 = Toggle.Value and "AccentColor" or "MainColor"
            Library.Registry[SwitchStroke].Color = Toggle.Value and "AccentColor" or "OutlineColor"

            if Toggle.Disabled then
                Label.TextTransparency = 0.8
                Ball.AnchorPoint = Vector2.new(Offset, 0)
                Ball.Position = UDim2.fromScale(Offset, 0)

                Ball.BackgroundColor3 = Library:GetDarkerColor(Library.Scheme.FontColor)
                Library.Registry[Ball].BackgroundColor3 = function()
                    return Library:GetDarkerColor(Library.Scheme.FontColor)
                end

                return
            end

            TweenService:Create(Label, Library.TweenInfo, {
                TextTransparency = Toggle.Value and 0 or 0.4,
            }):Play()
            TweenService:Create(Ball, Library.TweenInfo, {
                AnchorPoint = Vector2.new(Offset, 0),
                Position = UDim2.fromScale(Offset, 0),
            }):Play()

            Ball.BackgroundColor3 = Library.Scheme.FontColor
            Library.Registry[Ball].BackgroundColor3 = "FontColor"
        end

        function Toggle:OnChanged(Func)
            Toggle.Changed = Func
        end

        function Toggle:RunChanged()
            Library:SafeCallback(Toggle.Callback, Toggle.Value)
            Library:SafeCallback(Toggle.Changed, Toggle.Value)
        end

        function Toggle:SetValue(Value)
            if Toggle.Disabled then
                return
            end

            Toggle.Value = Value
            Toggle:Display()

            for _, Addon in Toggle.Addons do
                if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
                    Addon.Toggled = Toggle.Value
                    Addon:Update()
                end
            end

            Library:UpdateDependencyBoxes()

            if not Toggle.AnyKeyPickerPicking then
                Toggle:RunChanged()
            end
        end

        function Toggle:SetDisabled(Disabled: boolean)
            Toggle.Disabled = Disabled

            if Toggle.TooltipTable then
                Toggle.TooltipTable.Disabled = Toggle.Disabled
            end

            for _, Addon in Toggle.Addons do
                if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
                    Addon:Update()
                end
            end

            Button.Active = not Toggle.Disabled
            Toggle:Display()
        end

        function Toggle:SetVisible(Visible: boolean)
            Toggle.Visible = Visible

            Button.Visible = Toggle.Visible
            Groupbox:Resize()
        end

        function Toggle:SetText(Text: string)
            Toggle.Text = Text
            Label.Text = Text
        end

        table.insert(Toggle.Connections, Button.MouseButton1Click:Connect(function()
            if Toggle.Disabled then
                return
            end

            Toggle:SetValue(not Toggle.Value)
        end))

        if typeof(Toggle.Tooltip) == "string" or typeof(Toggle.DisabledTooltip) == "string" then
            Toggle.TooltipTable = Library:AddTooltip(Toggle.Tooltip, Toggle.DisabledTooltip, Button)
            Toggle.TooltipTable.Disabled = Toggle.Disabled
        end

        if Toggle.Risky then
            Label.TextColor3 = Library.Scheme.RedColor
            Library.Registry[Label].TextColor3 = "RedColor"
        end

        Toggle:Display()
        Groupbox:Resize()

        Toggle.TextLabel = Label
        Toggle.Container = Container
        setmetatable(Toggle, BaseAddons)

        Toggle.Holder = Button
        table.insert(Groupbox.Elements, Toggle)

        Toggle.Default = Toggle.Value

        Toggles[Idx] = Toggle

        function Toggle:Destroy()
            Toggle.Destroyed = true

            if Toggle.Connections then
                for _, Connection in Toggle.Connections do
                    Connection:Disconnect()
                end
            end

            if Toggle.TooltipTable then 
                Toggle.TooltipTable:Destroy() 
            end

            if Button then 
                Button:Destroy() 
            end

            if Toggle.Addons then
                for Index = #Toggle.Addons, 1, -1 do
                    local Addon = table.remove(Toggle.Addons, Index)
                    if Addon and Addon.Destroy then
                        Addon:Destroy()
                    end
                end
            end

            local ElemIdx = table.find(Groupbox.Elements, Toggle)
            if ElemIdx then 
                table.remove(Groupbox.Elements, ElemIdx) 
            end

            Groupbox:Resize()
            Toggles[Idx] = nil
        end

        return Toggle
    end

    function Funcs:AddInput(Idx, Info)
        if self.Destroyed then return nil end

        if typeof(Info) == "table" and (typeof(Info.VerifyValue) == "function" and Info.Finished ~= true) then
            Info.Finished = true
        end

        Info = Library:Validate(Info, Templates.Input)

        local Groupbox = self
        local Container = Groupbox.Container

        local Input = {
            Connections = {},
            Destroyed = false,

            Text = Info.Text,
            Value = Info.Default,

            Finished = Info.Finished,
            Numeric = Info.Numeric,
            ClearTextOnFocus = Info.ClearTextOnFocus,
            ClearTextOnBlur = Info.ClearTextOnBlur,
            Placeholder = Info.Placeholder,
            AllowEmpty = Info.AllowEmpty,
            EmptyReset = Info.EmptyReset,

            Tooltip = Info.Tooltip,
            DisabledTooltip = Info.DisabledTooltip,
            TooltipTable = nil,

            Callback = Info.Callback,
            Changed = Info.Changed,
            VerifyValue = Info.VerifyValue,

            Disabled = Info.Disabled,
            Visible = Info.Visible,

            Type = "Input",
        }

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 39),
            Visible = Input.Visible,
            Parent = Container,
        })

        local Label = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 14),
            Text = Input.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Holder,
        })

        local Box = New("TextBox", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = "MainColor",
            ClearTextOnFocus = not Input.Disabled and Input.ClearTextOnFocus,
            PlaceholderText = Input.Placeholder,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.new(1, 0, 0, 21),
            Text = Input.Value,
            TextEditable = not Input.Disabled,
            TextScaled = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Holder,
        })

        New("UIPadding", {
            PaddingBottom = UDim.new(0, 3),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 4),
            Parent = Box,
        })

        New("UIStroke", {
            Color = "OutlineColor",
            Parent = Box,
        })

        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Box,
            })
        )

        function Input:UpdateColors()
            if Library.Unloaded then
                return
            end

            Label.TextTransparency = Input.Disabled and 0.8 or 0
            Box.TextTransparency = Input.Disabled and 0.8 or 0
        end

        function Input:OnChanged(Func)
            Input.Changed = Func
        end

        function Input:RunChanged()
            Library:SafeCallback(Input.Callback, Input.Value)
            Library:SafeCallback(Input.Changed, Input.Value)
        end

        function Input:SetValue(Text)
            if not Input.AllowEmpty and Trim(Text) == "" then
                Text = Input.EmptyReset
            end

            if Info.MaxLength and #Text > Info.MaxLength then
                Text = Text:sub(1, Info.MaxLength)
            end

            if Input.Numeric then
                if #tostring(Text) > 0 and not tonumber(Text) then
                    Text = Input.Value
                end
            end

            if typeof(Info.VerifyValue) == "function" and (Text ~= Input.EmptyReset and Info.VerifyValue(Text) ~= true) then
                Text = Input.EmptyReset
            end

            Input.Value = Text
            Box.Text = Text

            if not Input.Disabled then
                Input:RunChanged()
            end
        end

        function Input:SetDisabled(Disabled: boolean)
            Input.Disabled = Disabled

            if Input.TooltipTable then
                Input.TooltipTable.Disabled = Input.Disabled
            end

            Box.ClearTextOnFocus = not Input.Disabled and Input.ClearTextOnFocus
            Box.TextEditable = not Input.Disabled
            Input:UpdateColors()
        end

        function Input:SetVisible(Visible: boolean)
            Input.Visible = Visible

            Holder.Visible = Input.Visible
            Groupbox:Resize()
        end

        function Input:SetText(Text: string)
            Input.Text = Text
            Label.Text = Text
        end

        if Input.Finished then
            table.insert(Input.Connections, Box.FocusLost:Connect(function(Enter)
                if not Enter then
                    if Input.ClearTextOnBlur then
                        Box.Text = Input.Value
                    end

                    return
                end

                Input:SetValue(Box.Text)
            end))
        else
            table.insert(Input.Connections, Box:GetPropertyChangedSignal("Text"):Connect(function()
                if Box.Text == Input.Value then return end
                
                Input:SetValue(Box.Text)
            end))
        end

        if typeof(Input.Tooltip) == "string" or typeof(Input.DisabledTooltip) == "string" then
            Input.TooltipTable = Library:AddTooltip(Input.Tooltip, Input.DisabledTooltip, Box)
            Input.TooltipTable.Disabled = Input.Disabled
        end

        Groupbox:Resize()

        Input.Holder = Holder
        table.insert(Groupbox.Elements, Input)

        Input.Default = Input.Value
        if typeof(Info.VerifyValue) == "function" and (Input.Default ~= Input.EmptyReset and Info.VerifyValue(Input.Default) ~= true) then
            Input:SetValue(Input.EmptyReset)
            Input.Default = Input.EmptyReset
        end
        
        Options[Idx] = Input

        function Input:Destroy()
            Input.Destroyed = true

            if Input.Connections then
                for _, Connection in Input.Connections do
                    Connection:Disconnect()
                end
            end

            if Input.TooltipTable then 
                Input.TooltipTable:Destroy() 
            end

            if Holder then 
                Holder:Destroy() 
            end

            local ElemIdx = table.find(Groupbox.Elements, Input)
            if ElemIdx then 
                table.remove(Groupbox.Elements, ElemIdx) 
            end

            Groupbox:Resize()
            Options[Idx] = nil
        end

        return Input
    end

    function Funcs:AddSlider(Idx, Info)
        if self.Destroyed then return nil end

        Info = Library:Validate(Info, Templates.Slider)

        local Groupbox = self
        local Container = Groupbox.Container

        local Slider = {
            Connections = {},
            Destroyed = false,

            Text = Info.Text,
            Value = Info.Default,

            Min = Info.Min,
            Max = Info.Max,

            Prefix = Info.Pre,
            Suffix = Info.Suffix,
            Compact = Info.Compact,
            Rounding = Info.Rounding,
            HideMax = Info.HideMax,

            Tooltip = Info.Tooltip,
            DisabledTooltip = Info.DisabledTooltip,
            TooltipTable = nil,

            Callback = Info.Callback,
            Changed = Info.Changed,

            Disabled = Info.Disabled,
            Visible = Info.Visible,

            AllowRightClickInput = Info.AllowRightClickInput,

            Type = "Slider",
        }

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, Info.Compact and 15 or 33),
            Visible = Slider.Visible,
            Parent = Container,
        })

        local SliderLabel
        if not Info.Compact then
            SliderLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 14),
                Text = Slider.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Holder,
            })
        end

        local Bar = New("TextButton", {
            Active = not Slider.Disabled,
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = "MainColor",
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.new(1, 0, 0, 15),
            Text = "",
            Parent = Holder,
        })

        New("UIStroke", {
            Color = "OutlineColor",
            Parent = Bar,
        })

        local DisplayLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Text = "",
            TextSize = 14,
            ZIndex = Bar.ZIndex + 2,
            Parent = Bar,
        })
        New("UIStroke", {
            ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
            Color = "DarkColor",
            LineJoinMode = Enum.LineJoinMode.Miter,
            Parent = DisplayLabel,
        })

        local InputTextBox
        if Info.AllowRightClickInput then
            InputTextBox = New("TextBox", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Text = "",
                TextSize = 14,
                ZIndex = Bar.ZIndex + 3,
                Visible = false,
                ClearTextOnFocus = false,
                Parent = Bar,
            })
            New("UIStroke", {
                ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                Color = "DarkColor",
                LineJoinMode = Enum.LineJoinMode.Miter,
                Parent = InputTextBox,
            })
        end

        local Fill = New("Frame", {
            BackgroundColor3 = "AccentColor",
            Size = UDim2.fromScale(0.5, 1),
            ZIndex = Bar.ZIndex + 1,
            Parent = Bar,
        })

        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Bar,
            })
        )

        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Fill,
            })
        )

        function Slider:UpdateColors()
            if Library.Unloaded then
                return
            end

            if SliderLabel then
                SliderLabel.TextTransparency = Slider.Disabled and 0.8 or 0
            end
            DisplayLabel.TextTransparency = Slider.Disabled and 0.8 or 0
            
            if Info.AllowRightClickInput then
                InputTextBox.TextTransparency = Slider.Disabled and 0.8 or 0
            end

            Fill.BackgroundColor3 = Slider.Disabled and Library.Scheme.OutlineColor or Library.Scheme.AccentColor
            Library.Registry[Fill].BackgroundColor3 = Slider.Disabled and "OutlineColor" or "AccentColor"
        end

        function Slider:Display()
            if Library.Unloaded then
                return
            end

            local CustomDisplayText = nil
            if Info.FormatDisplayValue then
                CustomDisplayText = Info.FormatDisplayValue(Slider, Slider.Value)
            end

            if CustomDisplayText then
                DisplayLabel.Text = tostring(CustomDisplayText)
            else
                if Info.Compact then
                    DisplayLabel.Text =
                        string.format("%s: %s%s%s", Slider.Text, Slider.Prefix, Slider.Value, Slider.Suffix)
                elseif Info.HideMax then
                    DisplayLabel.Text = string.format("%s%s%s", Slider.Prefix, Slider.Value, Slider.Suffix)
                else
                    DisplayLabel.Text = string.format(
                        "%s%s%s/%s%s%s",
                        Slider.Prefix,
                        Slider.Value,
                        Slider.Suffix,
                        Slider.Prefix,
                        Slider.Max,
                        Slider.Suffix
                    )
                end
            end

            local X = (Slider.Value - Slider.Min) / (Slider.Max - Slider.Min)
            Fill.Size = UDim2.fromScale(X, 1)
        end

        function Slider:OnChanged(Func)
            Slider.Changed = Func
        end

        function Slider:SetMax(Value)
            assert(Value > Slider.Min, "Max value cannot be less than the current min value.")

            Slider:SetValue(math.clamp(Slider.Value, Slider.Min, Value))
            Slider.Max = Value
            Slider:Display()
        end

        function Slider:SetMin(Value)
            assert(Value < Slider.Max, "Min value cannot be greater than the current max value.")

            Slider:SetValue(math.clamp(Slider.Value, Value, Slider.Max))
            Slider.Min = Value
            Slider:Display()
        end

        function Slider:RunChanged()
            Library:SafeCallback(Slider.Callback, Slider.Value)
            Library:SafeCallback(Slider.Changed, Slider.Value)
        end

        function Slider:SetValue(Str)
            if Slider.Disabled then
                return
            end

            local Num = tonumber(Str)
            if not Num or Num == Slider.Value then
                return
            end

            Num = math.clamp(Num, Slider.Min, Slider.Max)

            Slider.Value = Num
            Slider:Display()

            Slider:RunChanged()
        end

        function Slider:SetDisabled(Disabled: boolean)
            Slider.Disabled = Disabled

            if Slider.TooltipTable then
                Slider.TooltipTable.Disabled = Slider.Disabled
            end

            Bar.Active = not Slider.Disabled
            Slider:UpdateColors()
        end

        function Slider:SetVisible(Visible: boolean)
            Slider.Visible = Visible

            Holder.Visible = Slider.Visible
            Groupbox:Resize()
        end

        function Slider:SetText(Text: string)
            Slider.Text = Text
            if SliderLabel then
                SliderLabel.Text = Text
                return
            end
            Slider:Display()
        end

        function Slider:SetPrefix(Prefix: string)
            Slider.Prefix = Prefix
            Slider:Display()
        end

        function Slider:SetSuffix(Suffix: string)
            Slider.Suffix = Suffix
            Slider:Display()
        end

        if Info.AllowRightClickInput then
            local LastValidText = ""
            table.insert(Slider.Connections, InputTextBox:GetPropertyChangedSignal("Text"):Connect(function()
                local Text = InputTextBox.Text
                local AsNum = tonumber(Text)

                if #tostring(Text) > 0 and not AsNum and Text ~= "-" then
                    InputTextBox.Text = LastValidText
                else
                    if Slider.Rounding == 0 and Text:find("%.") then
                        InputTextBox.Text = LastValidText
                        return
                    end

                    local DecimalPos = Text:find("%.")
                    if DecimalPos and Slider.Rounding > 0 then
                        local Decimals = #Text - DecimalPos
                        if Decimals > Slider.Rounding then
                            InputTextBox.Text = LastValidText
                            return
                        end
                    end

                    LastValidText = Text

                    if AsNum then
                        if AsNum > Slider.Max then
                            InputTextBox.Text = tostring(Slider.Max)
                        elseif AsNum < Slider.Min then
                            InputTextBox.Text = tostring(Slider.Min)
                        end
                    end
                end
            end))

            table.insert(Slider.Connections, InputTextBox.FocusLost:Connect(function()
                InputTextBox.Visible = false
                DisplayLabel.Visible = true

                local Num = tonumber(InputTextBox.Text)
                if not Num then
                    return
                end

                Num = Round(Num, Slider.Rounding)
                Slider:SetValue(Num)
            end))
        end

        local LastTap = 0
        table.insert(Slider.Connections, Bar.InputBegan:Connect(function(Input: InputObject)
            local ValidInput = IsClickInput(Input) or Input.UserInputType == Enum.UserInputType.MouseButton2
            if not ValidInput or Slider.Disabled then
                return
            end

            if Info.AllowRightClickInput then
                local IsRightClick = Input.UserInputType == Enum.UserInputType.MouseButton2
                local IsDoubleTap = false

                if Library.IsMobile and Input.UserInputType == Enum.UserInputType.Touch then
                    if tick() - LastTap < 0.3 then
                        IsDoubleTap = true
                    end
                    
                    LastTap = tick()
                end

                if IsRightClick or IsDoubleTap then
                    InputTextBox.Text = tostring(Slider.Value)
                    InputTextBox.Visible = true
                    DisplayLabel.Visible = false

                    task.spawn(InputTextBox.CaptureFocus, InputTextBox)
                    return
                end
            end

            if not IsClickInput(Input) then
                return
            end

            if Library.ActiveTab then
                for _, Side in Library.ActiveTab.Sides do
                    Side.ScrollingEnabled = false
                end
            end

            if Library.ActiveLoading and Library.ActiveLoading.Sidebar then
                Library.ActiveLoading.Sidebar.Container.ScrollingEnabled = false
            end

            while IsDragInput(Input) and not Slider.Destroyed do
                local Location = Mouse.X
                local Scale = math.clamp((Location - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)

                local OldValue = Slider.Value
                Slider.Value = Round(Slider.Min + ((Slider.Max - Slider.Min) * Scale), Slider.Rounding)

                Slider:Display()
                if Slider.Value ~= OldValue then
                    Slider:RunChanged()
                end

                RunService.RenderStepped:Wait()
            end

            if Library.ActiveTab then
                for _, Side in Library.ActiveTab.Sides do
                    Side.ScrollingEnabled = true
                end
            end

            if Library.ActiveLoading and Library.ActiveLoading.Sidebar then
                Library.ActiveLoading.Sidebar.Container.ScrollingEnabled = true
            end
        end))

        if typeof(Slider.Tooltip) == "string" or typeof(Slider.DisabledTooltip) == "string" then
            Slider.TooltipTable = Library:AddTooltip(Slider.Tooltip, Slider.DisabledTooltip, Bar)
            Slider.TooltipTable.Disabled = Slider.Disabled
        end

        Slider:UpdateColors()
        Slider:Display()
        Groupbox:Resize()

        Slider.Holder = Holder
        table.insert(Groupbox.Elements, Slider)

        Slider.Default = Slider.Value

        Options[Idx] = Slider

        function Slider:Destroy()
            Slider.Destroyed = true

            if Slider.Connections then
                for _, Connection in Slider.Connections do
                    Connection:Disconnect()
                end
            end

            if Slider.TooltipTable then 
                Slider.TooltipTable:Destroy() 
            end

            if Holder then 
                Holder:Destroy() 
            end

            local ElemIdx = table.find(Groupbox.Elements, Slider)
            if ElemIdx then 
                table.remove(Groupbox.Elements, ElemIdx) 
            end

            Groupbox:Resize()
            Options[Idx] = nil
        end

        return Slider
    end

    function Funcs:AddDropdown(Idx, Info)
        if self.Destroyed then return nil end

        Info = Library:Validate(Info, Templates.Dropdown)

        local Groupbox = self
        local Container = Groupbox.Container

        if Info.SpecialType == "Player" then
            Info.Values = GetPlayers(Info.ExcludeLocalPlayer)
            Info.AllowNull = true
        elseif Info.SpecialType == "Team" then
            Info.Values = GetTeams()
            Info.AllowNull = true
        end

        local Dropdown = {
            Connections = {},
            Destroyed = false,

            Text = typeof(Info.Text) == "string" and Info.Text or nil,

            Value = Info.Multi and {} or nil,
            Values = Info.Values,
            DisabledValues = Info.DisabledValues,
            ValueImages = Info.ValueImages,

            Multi = Info.Multi,
            DragSelect = Info.Multi and not Library.IsMobile and Info.DragSelect == true,

            SpecialType = Info.SpecialType,
            ExcludeLocalPlayer = Info.ExcludeLocalPlayer,
            EnablePlayerImages = Info.EnablePlayerImages,

            Tooltip = Info.Tooltip,
            DisabledTooltip = Info.DisabledTooltip,
            TooltipTable = nil,

            Callback = Info.Callback,
            Changed = Info.Changed,

            Disabled = Info.Disabled,
            Visible = Info.Visible,

            Type = "Dropdown",
        }

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, Dropdown.Text and 39 or 21),
            Visible = Dropdown.Visible,
            Parent = Container,
        })

        local Label = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 14),
            Text = Dropdown.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Visible = not not Info.Text,
            ZIndex = 3,
            Parent = Holder,
        })

        local DisplayContainer = New("TextButton", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = "MainColor",
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.new(1, 0, 0, 21),
            Text = "",
            TextTransparency = 1,
            ZIndex = 2,
            Parent = Holder,
        })

        New("UIPadding", {
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 4),
            Parent = DisplayContainer,
        })

        New("UIStroke", {
            Color = "OutlineColor",
            Parent = DisplayContainer,
        })

        local DropdownCorner = New("UICorner", {
            TopLeftRadius = UDim.new(0, Library.CornerRadius / 2),
            TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
            BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
            BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
            Parent = DisplayContainer,
        }); table.insert(Library.SpecificCorners, DropdownCorner)

        local DisplayImage = New("ImageLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(-4, 3),
            Size = UDim2.fromOffset(16, 16),
            Image = "",
            ImageTransparency = 1,
            ZIndex = 2,
            Parent = DisplayContainer,
        })

        local DisplayButton = New("TextButton", {
            Active = not Dropdown.Disabled,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 21),
            Text = "---",
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 2,
            Parent = DisplayContainer,
        })

        local ArrowImage = New("ImageLabel", {
            AnchorPoint = Vector2.new(1, 0.5),
            Image = ArrowIcon and ArrowIcon.Url or "",
            ImageColor3 = "FontColor",
            ImageRectOffset = ArrowIcon and ArrowIcon.ImageRectOffset or Vector2.zero,
            ImageRectSize = ArrowIcon and ArrowIcon.ImageRectSize or Vector2.zero,
            ImageTransparency = 0.5,
            Position = UDim2.fromScale(1, 0.5),
            Size = UDim2.fromOffset(16, 16),
            Parent = DisplayContainer,
        })

        local SearchBox
        if Info.Searchable then
            SearchBox = New("TextBox", {
                BackgroundTransparency = 1,
                PlaceholderText = "搜索...",
                Position = UDim2.fromOffset(-8, 0),
                Size = UDim2.new(1, -12, 1, 0),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Visible = false,
                Parent = DisplayButton,
            })
            New("UIPadding", {
                PaddingLeft = UDim.new(0, 8),
                Parent = SearchBox,
            })
        end

        local GetValueImage = function(Value)
            if not Value then
                return nil
            end

            local ValueImage = nil
            if Dropdown.SpecialType == "Player" and Dropdown.EnablePlayerImages == true then
                if typeof(Value) == "Instance" and Value:IsA("Player") then
                    ValueImage = { Url = string.format("rbxthumb://type=AvatarHeadShot&id=%s&w=48&h=48", tostring(Value.UserId)) }
                end
            else
                if Info.ValueImages and Info.ValueImages[Value] then
                    ValueImage = Library:GetCustomIcon(Info.ValueImages[Value])
                end
            end

            return ValueImage
        end

        local MenuTable = Library:AddContextMenu(
            DisplayContainer,
            function()
                return UDim2.fromOffset((DisplayContainer.AbsoluteSize.X / Library.DPIScale), 0)
            end,
            function()
                return { 0.5, DisplayContainer.AbsoluteSize.Y + 1.5 }
            end,
            2,
            function(Active: boolean)
                DisplayButton.TextTransparency = (Active and SearchBox) and 1 or 0

                ArrowImage.ImageTransparency = Active and 0 or 0.5
                ArrowImage.Rotation = Active and 180 or 0

                if SearchBox then
                    SearchBox.Text = ""
                    SearchBox.Visible = Active
                end

                DropdownCorner.BottomRightRadius = Active and UDim.new(0, 0) or UDim.new(0, Library.CornerRadius / 2)
                DropdownCorner.BottomLeftRadius = Active and UDim.new(0, 0) or UDim.new(0, Library.CornerRadius / 2)
            end,
            false,
            "bottom",
            "Dropdown"
        )
        Dropdown.Menu = MenuTable

        function Dropdown:RecalculateListSize(Count)
            local Y = math.clamp((Count or GetTableSize(Dropdown.Values)) * 21, 0, Info.MaxVisibleDropdownItems * 21)

            MenuTable:SetSize(function()
                return UDim2.fromOffset((DisplayContainer.AbsoluteSize.X / Library.DPIScale), Y)
            end)
        end

        function Dropdown:UpdateColors()
            if Library.Unloaded then
                return
            end

            Label.TextTransparency = Dropdown.Disabled and 0.8 or 0
            DisplayButton.TextTransparency = Dropdown.Disabled and 0.8 or 0
            DisplayImage.ImageTransparency = Dropdown.Disabled and 0.8 or 0
            ArrowImage.ImageTransparency = Dropdown.Disabled and 0.8 or MenuTable.Active and 0 or 0.5
        end

        function Dropdown:Display()
            if Library.Unloaded then
                return
            end

            local Str = ""
            local ValueImage = nil

            if Info.Multi then
                for _, Value in Dropdown.Values do
                    if Dropdown.Value[Value] then
                        if not ValueImage then
                            ValueImage = GetValueImage(Value)
                        end

                        Str = Str
                            .. (Info.FormatDisplayValue and tostring(Info.FormatDisplayValue(Value)) or tostring(Value))
                            .. ", "
                    end
                end

                Str = Str:sub(1, #Str - 2)
            else
                ValueImage = GetValueImage(Dropdown.Value)
                Str = Dropdown.Value and tostring(Dropdown.Value) or ""

                if Str ~= "" and Info.FormatDisplayValue then
                    Str = tostring(Info.FormatDisplayValue(Str))
                end
            end

            if #Str > 25 then
                Str = Str:sub(1, 22) .. "..."
            end

            DisplayButton.Text = (Str == "" and "---" or Str)
            
            if ValueImage then
                DisplayImage.Image = ValueImage.Url
                DisplayImage.ImageRectOffset = ValueImage.ImageRectOffset or Vector2.zero
                DisplayImage.ImageRectSize = ValueImage.ImageRectSize or Vector2.zero
                DisplayImage.ImageTransparency = 0
            else
                DisplayImage.Image = ""
                DisplayImage.ImageTransparency = 1
            end

            DisplayButton.Size = ValueImage and UDim2.new(1, -8, 0, 21) or UDim2.new(1, 0, 0, 21)
            DisplayButton.Position = ValueImage and UDim2.fromOffset(14, 0) or UDim2.fromOffset(0, 0)
        end

        function Dropdown:OnChanged(Func)
            Dropdown.Changed = Func
        end

        function Dropdown:GetActiveValues(ReturnCount)
            local Table = {}

            if Info.Multi then
                for Value, _ in Dropdown.Value do
                    table.insert(Table, Value)
                end
            else
                if Dropdown.Value then
                    table.insert(Table, Dropdown.Value)
                end
            end

            return ReturnCount == true and GetTableSize(Table) or Table
        end

        local Buttons = {}
        local DragSelecting = false
        local DragStartIndex = nil
        local DragInitialValues = {}
        local DragInputEndedConn = nil
        local DragInputChangedConn = nil

        local function StopDragSelect()
            DragSelecting = false
            DragStartIndex = nil
            table.clear(DragInitialValues)

            if DragInputEndedConn then
                DragInputEndedConn:Disconnect()
                DragInputEndedConn = nil
            end

            if DragInputChangedConn then
                DragInputChangedConn:Disconnect()
                DragInputChangedConn = nil
            end
        end

        local function UpdateDrag(CurrentIndex)
            local Min = math.min(DragStartIndex, CurrentIndex)
            local Max = math.max(DragStartIndex, CurrentIndex)

            for OtherButton, OtherTable in Buttons do
                local InRange = OtherTable.Index >= Min and OtherTable.Index <= Max
                local Try = DragInitialValues[OtherTable.Value]
                if InRange then
                    Try = not Try
                end

                if not (Dropdown:GetActiveValues(true) == 1 and not Try and not Info.AllowNull) then
                    Dropdown.Value[OtherTable.Value] = Try and true or nil
                end

                OtherTable:UpdateButton()
            end

            Dropdown:Display()
        end

        function Dropdown:BuildDropdownList()
            local Values = Dropdown.Values
            local DisabledValues = Dropdown.DisabledValues

            StopDragSelect()

            for Button, _ in Buttons do
                if not (Button and Button.Parent) then
                    continue
                end

                Button.Parent:Destroy()
            end
            table.clear(Buttons)

            local Count = 0
            local ProcessedCount = 0
            local TotalLen = GetTableSize(Values) + GetTableSize(DisabledValues)

            for _, Value in Values do
                ProcessedCount += 1

                local FormattedValue = tostring(Info.FormatListValue and Info.FormatListValue(Value) or Value)
                if SearchBox and not FormattedValue:lower():match(SearchBox.Text:lower()) then
                    continue
                end

                Count += 1

                local IsDisabled = table.find(DisabledValues, Value)
                local Table = {}
                local ValueImage = GetValueImage(Value)

                local Container = New("Frame", {
                    BackgroundColor3 = "MainColor",
                    BackgroundTransparency = 1,
                    LayoutOrder = IsDisabled and 1 or 0,
                    Size = UDim2.new(1, 0, 0, 21),
                    Parent = MenuTable.Menu,
                })

                if ProcessedCount == TotalLen then
                    local Corner = New("UICorner", {
                        TopLeftRadius = UDim.new(0, 0),
                        TopRightRadius = UDim.new(0, 0),
                        BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
                        BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
                        Parent = Container,
                    }); table.insert(Library.SpecificCorners, Corner)
                end

                local Image = ValueImage and New("ImageLabel", {
                    BackgroundTransparency = 1,
                    Image = ValueImage.Url,
                    ImageRectOffset = ValueImage.ImageRectOffset,
                    ImageRectSize = ValueImage.ImageRectSize,
                    ImageTransparency = 0.5,
                    Size = UDim2.fromOffset(16, 16),
                    Position = UDim2.fromOffset(4, 3),
                    Parent = Container,
                })

                local Button = New("TextButton", {
                    BackgroundTransparency = 1,
                    Size = ValueImage and UDim2.new(1, -18, 0, 21) or UDim2.new(1, 0, 0, 21),
                    Position = ValueImage and UDim2.fromOffset(18, 0) or UDim2.fromOffset(0, 0),
                    Text = FormattedValue,
                    TextSize = 14,
                    TextTransparency = 0.5,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Container,
                })
                New("UIPadding", {
                    PaddingLeft = UDim.new(0, 7),
                    PaddingRight = UDim.new(0, 7),
                    Parent = Button,
                })

                local Selected
                if Info.Multi then
                    Selected = Dropdown.Value[Value]
                else
                    Selected = Dropdown.Value == Value
                end

                function Table:UpdateButton()
                    if Info.Multi then
                        Selected = Dropdown.Value[Value]
                    else
                        Selected = Dropdown.Value == Value
                    end

                    Container.BackgroundTransparency = Selected and 0 or 1
                    Button.TextTransparency = IsDisabled and 0.8 or Selected and 0 or 0.5

                    if Image then
                        Image.ImageTransparency = IsDisabled and 0.8 or Selected and 0 or 0.5
                    end
                end

                Table.Index = Count
                Table.Value = Value

                if not IsDisabled then
                    Button.MouseButton1Click:Connect(function()
                        if DragSelecting then return end

                        local Try = not Selected
                        if not (Dropdown:GetActiveValues(true) == 1 and not Try and not Info.AllowNull) then
                            Selected = Try
                            if Info.Multi then
                                Dropdown.Value[Value] = Selected and true or nil
                            else
                                Dropdown.Value = Selected and Value or nil
                            end

                            for _, OtherButton in Buttons do
                                OtherButton:UpdateButton()
                            end
                        end

                        Table:UpdateButton()
                        Dropdown:Display()

                        Library:UpdateDependencyBoxes()
                        Dropdown:RunChanged()
                    end)

                    if Info.Multi and Dropdown.DragSelect and not Library.IsMobile then
                        Button.InputBegan:Connect(function(StartInput)
                            if not IsMouseInput(StartInput) then return end

                            DragSelecting = true
                            DragStartIndex = Table.Index
                            table.clear(DragInitialValues)

                            for OtherButton, OtherTable in Buttons do
                                DragInitialValues[OtherTable.Value] = Dropdown.Value[OtherTable.Value]
                            end

                            UpdateDrag(Table.Index)

                            if DragInputEndedConn then DragInputEndedConn:Disconnect() end
                            if DragInputChangedConn then DragInputChangedConn:Disconnect() end

                            DragInputChangedConn = Library:GiveSignal(UserInputService.InputChanged:Connect(function(ChangeInput)
                                if not IsMovementInput(ChangeInput) and ChangeInput ~= StartInput then
                                    return
                                end

                                local Pos = ChangeInput.Position
                                for OtherButton, OtherTable in Buttons do
                                    if Library:MouseIsOverFrame(OtherButton, Pos) then
                                        UpdateDrag(OtherTable.Index)
                                        break
                                    end
                                end
                            end))

                            DragInputEndedConn = Library:GiveSignal(UserInputService.InputEnded:Connect(function(EndInput)
                                if EndInput ~= StartInput and not (IsMouseInput(EndInput) and EndInput.UserInputType == StartInput.UserInputType) then
                                    return
                                end

                                Library:UpdateDependencyBoxes()
                                Dropdown:RunChanged()

                                StopDragSelect()
                            end))

                            table.insert(Dropdown.Connections, DragInputEndedConn)
                            table.insert(Dropdown.Connections, DragInputChangedConn)
                        end)
                    end
                end

                Table:UpdateButton()
                Dropdown:Display()

                Buttons[Button] = Table
            end

            Dropdown:RecalculateListSize(Count)
        end

        function Dropdown:RunChanged()
            Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
            Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
        end

        function Dropdown:SetValue(Value)
            if Info.Multi then
                local Table = {}
				
                for Val, Active in Value or {} do
                    if typeof(Active) ~= "boolean" then
                        Table[Active] = true
                    elseif Active and table.find(Dropdown.Values, Val) then
                        Table[Val] = true
                    end
                end

                Dropdown.Value = Table
            else
                if table.find(Dropdown.Values, Value) then
                    Dropdown.Value = Value
                elseif not Value then
                    Dropdown.Value = nil
                end
            end

            Dropdown:Display()
            for _, Button in Buttons do
                Button:UpdateButton()
            end

            if not Dropdown.Disabled then
                Library:UpdateDependencyBoxes()
                Dropdown:RunChanged()
            end
        end

        function Dropdown:SetValues(Values)
            Dropdown.Values = Values
            Dropdown:BuildDropdownList()
        end

        function Dropdown:AddValues(Values)
            if typeof(Values) == "table" then
                for _, val in Values do
                    table.insert(Dropdown.Values, val)
                end
            elseif typeof(Values) == "string" then
                table.insert(Dropdown.Values, Values)
            else
                return
            end

            Dropdown:BuildDropdownList()
        end

        function Dropdown:SetDisabledValues(DisabledValues)
            Dropdown.DisabledValues = DisabledValues
            Dropdown:BuildDropdownList()
        end

        function Dropdown:AddDisabledValues(DisabledValues)
            if typeof(DisabledValues) == "table" then
                for _, val in DisabledValues do
                    table.insert(Dropdown.DisabledValues, val)
                end
            elseif typeof(DisabledValues) == "string" then
                table.insert(Dropdown.DisabledValues, DisabledValues)
            else
                return
            end

            Dropdown:BuildDropdownList()
        end

        function Dropdown:SetValueImages(ValueImages)
            if typeof(ValueImages) ~= "table" then
                return
            end
            
            Dropdown.ValueImages = ValueImages
            Dropdown:BuildDropdownList()
        end

        function Dropdown:AddValueImages(ValueImages)
            if typeof(ValueImages) ~= "table" then
                return
            end
            
            for key, val in ValueImages do
                Dropdown.ValueImages[key] = val
            end
            
            Dropdown:BuildDropdownList()
        end

        function Dropdown:SetDisabled(Disabled: boolean)
            Dropdown.Disabled = Disabled

            if Dropdown.TooltipTable then
                Dropdown.TooltipTable.Disabled = Dropdown.Disabled
            end

            MenuTable:Close()
            DisplayButton.Active = not Dropdown.Disabled
            Dropdown:UpdateColors()
        end

        function Dropdown:SetVisible(Visible: boolean)
            Dropdown.Visible = Visible

            Holder.Visible = Dropdown.Visible
            Groupbox:Resize()
        end

        function Dropdown:SetText(Text: string)
            Dropdown.Text = Text
            Holder.Size = UDim2.new(1, 0, 0, Text and 39 or 21)

            Label.Text = Text and Text or ""
            Label.Visible = not not Text
        end

        function Dropdown:SetDragSelect(Value: boolean)
            if not Info.Multi or Library.IsMobile then 
                Value = false
            end

            Dropdown.DragSelect = Value == true
            Dropdown:BuildDropdownList()
        end

        local ToggleDropdown = function()
            if Dropdown.Disabled then
                return
            end

            MenuTable:Toggle()
        end

        table.insert(Dropdown.Connections, DisplayContainer.MouseButton1Click:Connect(ToggleDropdown))
        table.insert(Dropdown.Connections, DisplayButton.MouseButton1Click:Connect(ToggleDropdown))

        if SearchBox then
            table.insert(Dropdown.Connections, SearchBox:GetPropertyChangedSignal("Text"):Connect(Dropdown.BuildDropdownList))
        end

        local Defaults = {}
        if typeof(Info.Default) == "string" then
            local Index = table.find(Dropdown.Values, Info.Default)
            if Index then
                table.insert(Defaults, Index)
            end
        elseif typeof(Info.Default) == "table" then
            for _, Value in next, Info.Default do
                local Index = table.find(Dropdown.Values, Value)
                if Index then
                    table.insert(Defaults, Index)
                end
            end
        elseif Dropdown.Values[Info.Default] ~= nil then
            table.insert(Defaults, Info.Default)
        end

        if next(Defaults) then
            for i = 1, #Defaults do
                local Index = Defaults[i]
                if Info.Multi then
                    Dropdown.Value[Dropdown.Values[Index]] = true
                else
                    Dropdown.Value = Dropdown.Values[Index]
                end

                if not Info.Multi then
                    break
                end
            end
        end

        if typeof(Dropdown.Tooltip) == "string" or typeof(Dropdown.DisabledTooltip) == "string" then
            Dropdown.TooltipTable = Library:AddTooltip(Dropdown.Tooltip, Dropdown.DisabledTooltip, DisplayContainer)
            Dropdown.TooltipTable.Disabled = Dropdown.Disabled
        end

        Dropdown:UpdateColors()
        Dropdown:Display()
        Dropdown:BuildDropdownList()
        Groupbox:Resize()

        Dropdown.Holder = Holder
        table.insert(Groupbox.Elements, Dropdown)

        Dropdown.Default = Defaults
        Dropdown.DefaultValues = Dropdown.Values

        Options[Idx] = Dropdown

        function Dropdown:Destroy()
            Dropdown.Destroyed = true

            StopDragSelect()

            if Dropdown.Connections then
                for _, Connection in Dropdown.Connections do
                    Connection:Disconnect()
                end
            end

            if Dropdown.TooltipTable then 
                Dropdown.TooltipTable:Destroy() 
            end

            if MenuTable then 
                MenuTable:Destroy() 
            end

            if Holder then 
                Holder:Destroy() 
            end

            local ElemIdx = table.find(Groupbox.Elements, Dropdown)
            if ElemIdx then 
                table.remove(Groupbox.Elements, ElemIdx) 
            end

            Groupbox:Resize()
            Options[Idx] = nil
        end

        return Dropdown
    end

    function Funcs:AddViewport(Idx, Info)
        if self.Destroyed then return nil end

        Info = Library:Validate(Info, Templates.Viewport)

        local Groupbox = self
        local Container = Groupbox.Container

        local Dragging, Pinching = false, false
        local LastMousePos, LastPinchDist = nil, 0

        local ViewportObject = Info.Object
        if Info.Clone and typeof(Info.Object) == "Instance" then
            if Info.Object.Archivable then
                ViewportObject = ViewportObject:Clone()
            else
                Info.Object.Archivable = true
                ViewportObject = ViewportObject:Clone()
                Info.Object.Archivable = false
            end
        end

        local Viewport = {
            Connections = {},
            Destroyed = false,

            Object = ViewportObject :: PVInstance,
            Camera = if not Info.Camera then Instance.new("Camera") else Info.Camera,
            Interactive = Info.Interactive,
            AutoFocus = Info.AutoFocus,
            Visible = Info.Visible,
            Type = "Viewport",
        }

        assert(
            typeof(Viewport.Object) == "Instance" and (Viewport.Object:IsA("BasePart") or Viewport.Object:IsA("Model")),
            "Instance must be a BasePart or Model."
        )

        assert(
            typeof(Viewport.Camera) == "Instance" and Viewport.Camera:IsA("Camera"),
            "Camera must be a valid Camera instance."
        )

        local function GetModelSize(model)
            if model:IsA("BasePart") then
                return model.Size
            end

            return select(2, model:GetBoundingBox())
        end

        local function FocusCamera()
            local ModelSize = GetModelSize(Viewport.Object)
            local MaxExtent = math.max(ModelSize.X, ModelSize.Y, ModelSize.Z)
            local CameraDistance = MaxExtent * 2
            local ModelPosition = (Viewport.Object :: PVInstance):GetPivot().Position

            Viewport.Camera.CFrame = CFrame.new(ModelPosition + Vector3.new(0, MaxExtent / 2, CameraDistance), ModelPosition)
        end

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, Info.Height),
            Visible = Viewport.Visible,
            Parent = Container,
        })

        local Box = New("Frame", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = "MainColor",
            BorderColor3 = "OutlineColor",
            BorderSizePixel = 1,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.fromScale(1, 1),
            Parent = Holder,
        })

        New("UIPadding", {
            PaddingBottom = UDim.new(0, 3),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 4),
            Parent = Box,
        })

        local ViewportFrame = New("ViewportFrame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Parent = Box,
            CurrentCamera = Viewport.Camera,
            Active = Viewport.Interactive,
        })

        table.insert(Viewport.Connections, ViewportFrame.MouseEnter:Connect(function()
            if not Viewport.Interactive then
                return
            end

            for _, Side in Groupbox.Tab.Sides do
                Side.ScrollingEnabled = false
            end
        end))

        table.insert(Viewport.Connections, ViewportFrame.MouseLeave:Connect(function()
            if not Viewport.Interactive then
                return
            end

            for _, Side in Groupbox.Tab.Sides do
                Side.ScrollingEnabled = true
            end
        end))

        table.insert(Viewport.Connections, ViewportFrame.InputBegan:Connect(function(input)
            if not Viewport.Interactive then
                return
            end

            if input.UserInputType == Enum.UserInputType.MouseButton2 then
                Dragging = true
                LastMousePos = input.Position
            elseif input.UserInputType == Enum.UserInputType.Touch and not Pinching then
                Dragging = true
                LastMousePos = input.Position
            end
        end))

        table.insert(Viewport.Connections, UserInputService.InputEnded:Connect(function(input)
            if Library.Unloaded then
                return
            end

            if not Viewport.Interactive then
                return
            end

            if input.UserInputType == Enum.UserInputType.MouseButton2 then
                Dragging = false
            elseif input.UserInputType == Enum.UserInputType.Touch then
                Dragging = false
            end
        end))

        table.insert(Viewport.Connections, UserInputService.InputChanged:Connect(function(input)
            if Library.Unloaded then
                return
            end

            if not Viewport.Interactive or not Dragging or Pinching then
                return
            end

            if
                input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch
            then
                local MouseDelta = input.Position - LastMousePos
                LastMousePos = input.Position

                local Position = (Viewport.Object :: PVInstance):GetPivot().Position
                local Camera = Viewport.Camera

                local RotationY = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), -MouseDelta.X * 0.01)
                Camera.CFrame = CFrame.new(Position) * RotationY * CFrame.new(-Position) * Camera.CFrame

                local RotationX = CFrame.fromAxisAngle(Camera.CFrame.RightVector, -MouseDelta.Y * 0.01)
                local PitchedCFrame = CFrame.new(Position) * RotationX * CFrame.new(-Position) * Camera.CFrame

                if PitchedCFrame.UpVector.Y > 0.1 then
                    Camera.CFrame = PitchedCFrame
                end
            end
        end))

        table.insert(Viewport.Connections, ViewportFrame.InputChanged:Connect(function(input)
            if not Viewport.Interactive then
                return
            end

            if input.UserInputType == Enum.UserInputType.MouseWheel then
                local ZoomAmount = input.Position.Z * 2
                Viewport.Camera.CFrame += Viewport.Camera.CFrame.LookVector * ZoomAmount
            end
        end))

        table.insert(Viewport.Connections, UserInputService.TouchPinch:Connect(function(touchPositions, scale, velocity, state)
            if Library.Unloaded then
                return
            end

            if not Viewport.Interactive or not Library:MouseIsOverFrame(ViewportFrame, touchPositions[1]) then
                return
            end

            if state == Enum.UserInputState.Begin then
                Pinching = true
                Dragging = false
                LastPinchDist = (touchPositions[1] - touchPositions[2]).Magnitude
            elseif state == Enum.UserInputState.Change then
                local currentDist = (touchPositions[1] - touchPositions[2]).Magnitude
                local delta = (currentDist - LastPinchDist) * 0.1
                LastPinchDist = currentDist
                Viewport.Camera.CFrame += Viewport.Camera.CFrame.LookVector * delta
            elseif state == Enum.UserInputState.End or state == Enum.UserInputState.Cancel then
                Pinching = false
            end
        end))

        ;(Viewport.Object :: PVInstance).Parent = ViewportFrame
        if Viewport.AutoFocus then
            FocusCamera()
        end

        function Viewport:SetObject(Object: Instance, Clone: boolean?)
            assert(Object, "Object cannot be nil.")

            if Clone then
                Object = Object:Clone()
            end

            if Viewport.Object then
                Viewport.Object:Destroy()
            end

            Viewport.Object = Object
            ;(Viewport.Object :: PVInstance).Parent = ViewportFrame

            Groupbox:Resize()
        end

        function Viewport:SetHeight(Height: number)
            assert(Height > 0, "Height must be greater than 0.")

            Holder.Size = UDim2.new(1, 0, 0, Height)
            Groupbox:Resize()
        end

        function Viewport:Focus()
            if not Viewport.Object then
                return
            end

            FocusCamera()
        end

        function Viewport:SetCamera(Camera: Instance)
            assert(
                Camera and typeof(Camera) == "Instance" and Camera:IsA("Camera"),
                "Camera must be a valid Camera instance."
            )

            Viewport.Camera = Camera
            ViewportFrame.CurrentCamera = Camera
        end

        function Viewport:SetInteractive(Interactive: boolean)
            Viewport.Interactive = Interactive
            ViewportFrame.Active = Interactive
        end

        function Viewport:SetVisible(Visible: boolean)
            Viewport.Visible = Visible

            Holder.Visible = Viewport.Visible
            Groupbox:Resize()
        end

        Groupbox:Resize()

        Viewport.Holder = Holder
        table.insert(Groupbox.Elements, Viewport)

        Options[Idx] = Viewport

        function Viewport:Destroy()
            Viewport.Destroyed = true

            if Viewport.Connections then
                for _, Connection in Viewport.Connections do
                    Connection:Disconnect()
                end
            end

            if Holder then 
                Holder:Destroy() 
            end

            local ElemIdx = table.find(Groupbox.Elements, Viewport)
            if ElemIdx then 
                table.remove(Groupbox.Elements, ElemIdx) 
            end

            Groupbox:Resize()
            Options[Idx] = nil
        end

        return Viewport
    end

    function Funcs:AddImage(Idx, Info)
        if self.Destroyed then return nil end

        Info = Library:Validate(Info, Templates.Image)

        local Groupbox = self
        local Container = Groupbox.Container

        local Image = {
            Connections = {},
            Destroyed = false,

            Image = Info.Image,
            Color = Info.Color,
            RectOffset = Info.RectOffset,
            RectSize = Info.RectSize,
            Height = Info.Height,
            ScaleType = Info.ScaleType,
            Transparency = Info.Transparency,
            BackgroundTransparency = Info.BackgroundTransparency,

            Visible = Info.Visible,
            Type = "Image",
        }

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, Info.Height),
            Visible = Image.Visible,
            Parent = Container,
        })

        local Box = New("Frame", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = "MainColor",
            BorderColor3 = "OutlineColor",
            BorderSizePixel = 1,
            BackgroundTransparency = Image.BackgroundTransparency,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.fromScale(1, 1),
            Parent = Holder,
        })

        New("UIPadding", {
            PaddingBottom = UDim.new(0, 3),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 4),
            Parent = Box,
        })

        local ImageProperties = {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Image = Image.Image,
            ImageTransparency = Image.Transparency,
            ImageColor3 = Image.Color,
            ImageRectOffset = Image.RectOffset,
            ImageRectSize = Image.RectSize,
            ScaleType = Image.ScaleType,
            Parent = Box,
        }

        local Icon = Library:GetCustomIcon(ImageProperties.Image)
        assert(Icon, "Image must be a valid Roblox asset or a valid URL or a valid lucide icon.")

        ImageProperties.Image = Icon.Url
        ImageProperties.ImageRectOffset = Icon.ImageRectOffset
        ImageProperties.ImageRectSize = Icon.ImageRectSize

        local ImageLabel = New("ImageLabel", ImageProperties)

        function Image:SetHeight(Height: number)
            assert(Height > 0, "Height must be greater than 0.")

            Image.Height = Height
            Holder.Size = UDim2.new(1, 0, 0, Height)
            Groupbox:Resize()
        end

        function Image:SetImage(NewImage: string)
            assert(typeof(NewImage) == "string", "Image must be a string.")

            local Icon = Library:GetCustomIcon(NewImage)
            assert(Icon, "Image must be a valid Roblox asset or a valid URL or a valid lucide icon.")

            NewImage = Icon.Url
            Image.RectOffset = Icon.ImageRectOffset
            Image.RectSize = Icon.ImageRectSize

            ImageLabel.Image = NewImage
            Image.Image = NewImage
        end

        function Image:SetColor(Color: Color3)
            assert(typeof(Color) == "Color3", "Color must be a Color3 value.")

            ImageLabel.ImageColor3 = Color
            Image.Color = Color
        end

        function Image:SetRectOffset(RectOffset: Vector2)
            assert(typeof(RectOffset) == "Vector2", "RectOffset must be a Vector2 value.")

            ImageLabel.ImageRectOffset = RectOffset
            Image.RectOffset = RectOffset
        end

        function Image:SetRectSize(RectSize: Vector2)
            assert(typeof(RectSize) == "Vector2", "RectSize must be a Vector2 value.")

            ImageLabel.ImageRectSize = RectSize
            Image.RectSize = RectSize
        end

        function Image:SetScaleType(ScaleType: Enum.ScaleType)
            assert(
                typeof(ScaleType) == "EnumItem" and ScaleType:IsA("ScaleType"),
                "ScaleType must be a valid Enum.ScaleType."
            )

            ImageLabel.ScaleType = ScaleType
            Image.ScaleType = ScaleType
        end

        function Image:SetTransparency(Transparency: number)
            assert(typeof(Transparency) == "number", "Transparency must be a number between 0 and 1.")
            assert(Transparency >= 0 and Transparency <= 1, "Transparency must be between 0 and 1.")

            ImageLabel.ImageTransparency = Transparency
            Image.Transparency = Transparency
        end

        function Image:SetVisible(Visible: boolean)
            Image.Visible = Visible

            Holder.Visible = Image.Visible
            Groupbox:Resize()
        end

        Groupbox:Resize()

        Image.Holder = Holder
        table.insert(Groupbox.Elements, Image)

        Options[Idx] = Image

        function Image:Destroy()
            Image.Destroyed = true

            if Holder then 
                Holder:Destroy() 
            end

            local ElemIdx = table.find(Groupbox.Elements, Image)
            if ElemIdx then 
                table.remove(Groupbox.Elements, ElemIdx) 
            end

            Groupbox:Resize()
            Options[Idx] = nil
        end

        return Image
    end

    function Funcs:AddVideo(Idx, Info)
        if self.Destroyed then return nil end

        Info = Library:Validate(Info, Templates.Video)

        local Groupbox = self
        local Container = Groupbox.Container

        local Video = {
            Connections = {},
            Destroyed = false,

            Video = Info.Video,
            Looped = Info.Looped,
            Playing = Info.Playing,
            Volume = Info.Volume,
            Height = Info.Height,
            Visible = Info.Visible,

            Type = "Video",
        }

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, Info.Height),
            Visible = Video.Visible,
            Parent = Container,
        })

        local Box = New("Frame", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = "MainColor",
            BorderColor3 = "OutlineColor",
            BorderSizePixel = 1,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.fromScale(1, 1),
            Parent = Holder,
        })

        New("UIPadding", {
            PaddingBottom = UDim.new(0, 3),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 4),
            Parent = Box,
        })

        local VideoFrameInstance = New("VideoFrame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Video = Video.Video,
            Looped = Video.Looped,
            Volume = Video.Volume,
            Parent = Box,
        })

        VideoFrameInstance.Playing = Video.Playing

        function Video:SetHeight(Height: number)
            assert(Height > 0, "Height must be greater than 0.")

            Video.Height = Height
            Holder.Size = UDim2.new(1, 0, 0, Height)
            Groupbox:Resize()
        end

        function Video:SetVideo(NewVideo: string)
            assert(typeof(NewVideo) == "string", "Video must be a string.")

            VideoFrameInstance.Video = NewVideo
            Video.Video = NewVideo
        end

        function Video:SetLooped(Looped: boolean)
            assert(typeof(Looped) == "boolean", "Looped must be a boolean.")

            VideoFrameInstance.Looped = Looped
            Video.Looped = Looped
        end

        function Video:SetVolume(Volume: number)
            assert(typeof(Volume) == "number", "Volume must be a number between 0 and 10.")

            VideoFrameInstance.Volume = Volume
            Video.Volume = Volume
        end

        function Video:SetPlaying(Playing: boolean)
            assert(typeof(Playing) == "boolean", "Playing must be a boolean.")

            VideoFrameInstance.Playing = Playing
            Video.Playing = Playing
        end

        function Video:Play()
            VideoFrameInstance.Playing = true
            Video.Playing = true
        end

        function Video:Pause()
            VideoFrameInstance.Playing = false
            Video.Playing = false
        end

        function Video:SetVisible(Visible: boolean)
            Video.Visible = Visible

            Holder.Visible = Video.Visible
            Groupbox:Resize()
        end

        Groupbox:Resize()

        Video.Holder = Holder
        Video.VideoFrame = VideoFrameInstance
        table.insert(Groupbox.Elements, Video)

        Options[Idx] = Video

        function Video:Destroy()
            Video.Destroyed = true

            if Video.Connections then
                for _, Connection in Video.Connections do
                    Connection:Disconnect()
                end
            end

            if Holder then 
                Holder:Destroy() 
            end

            local ElemIdx = table.find(Groupbox.Elements, Video)
            if ElemIdx then 
                table.remove(Groupbox.Elements, ElemIdx) 
            end

            Groupbox:Resize()
            Options[Idx] = nil
        end

        return Video
    end

    function Funcs:AddUIPassthrough(Idx, Info)
        if self.Destroyed then return nil end

        Info = Library:Validate(Info, Templates.UIPassthrough)

        local Groupbox = self
        local Container = Groupbox.Container

        assert(Info.Instance, "Instance must be provided.")
        assert(
            typeof(Info.Instance) == "Instance" and Info.Instance:IsA("GuiBase2d"),
            "Instance must inherit from GuiBase2d."
        )
        assert(typeof(Info.Height) == "number" and Info.Height > 0, "Height must be a number greater than 0.")

        local Passthrough = {
            Connections = {},
            Destroyed = false,

            Instance = Info.Instance,
            Height = Info.Height,
            Visible = Info.Visible,

            Type = "UIPassthrough",
        }

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, Info.Height),
            Visible = Passthrough.Visible,
            Parent = Container,
        })

        Passthrough.Instance.Parent = Holder

        Groupbox:Resize()

        function Passthrough:SetHeight(Height: number)
            assert(typeof(Height) == "number" and Height > 0, "Height must be a number greater than 0.")

            Passthrough.Height = Height
            Holder.Size = UDim2.new(1, 0, 0, Height)
            Groupbox:Resize()
        end

        function Passthrough:SetInstance(Instance: Instance)
            assert(Instance, "Instance must be provided.")
            assert(
                typeof(Instance) == "Instance" and Instance:IsA("GuiBase2d"),
                "Instance must inherit from GuiBase2d."
            )

            if Passthrough.Instance then
                Passthrough.Instance.Parent = nil
            end

            Passthrough.Instance = Instance
            Passthrough.Instance.Parent = Holder
        end

        function Passthrough:SetVisible(Visible: boolean)
            Passthrough.Visible = Visible

            Holder.Visible = Passthrough.Visible
            Groupbox:Resize()
        end

        Passthrough.Holder = Holder
        table.insert(Groupbox.Elements, Passthrough)

        Options[Idx] = Passthrough

        function Passthrough:Destroy()
            Passthrough.Destroyed = true

            if Passthrough.Connections then
                for _, Connection in Passthrough.Connections do
                    Connection:Disconnect()
                end
            end

            if Holder then 
                Holder:Destroy() 
            end

            local ElemIdx = table.find(Groupbox.Elements, Passthrough)
            if ElemIdx then 
                table.remove(Groupbox.Elements, ElemIdx) 
            end

            Groupbox:Resize()
            Options[Idx] = nil
        end

        return Passthrough
    end

    function Funcs:AddDependencyBox()
        if self.Destroyed then return nil end

        local Groupbox = self
        local Container = Groupbox.Container

        local DepboxContainer
        local DepboxList

        do
            DepboxContainer = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Visible = false,
                Parent = Container,
            })

            DepboxList = New("UIListLayout", {
                Padding = UDim.new(0, 8),
                Parent = DepboxContainer,
            })
        end

        local Depbox = {
            Connections = {},
            Destroyed = false,

            Visible = false,
            Dependencies = {},

            Holder = DepboxContainer,
            Container = DepboxContainer,

            Elements = {},
            DependencyBoxes = {}
        }

        function Depbox:Resize()
            DepboxContainer.Size = UDim2.new(1, 0, 0, DepboxList.AbsoluteContentSize.Y / Library.DPIScale)
            Groupbox:Resize()
        end

        function Depbox:Update(CancelSearch)
            for _, Dependency in Depbox.Dependencies do
                local Element = Dependency[1]
                local Value = Dependency[2]

                if Element.Type == "Toggle" and Element.Value ~= Value then
                    DepboxContainer.Visible = false
                    Depbox.Visible = false
                    return
                elseif Element.Type == "Dropdown" then
                    if typeof(Element.Value) == "table" then
                        if not Element.Value[Value] then
                            DepboxContainer.Visible = false
                            Depbox.Visible = false
                            return
                        end
                    else
                        if Element.Value ~= Value then
                            DepboxContainer.Visible = false
                            Depbox.Visible = false
                            return
                        end
                    end
                end
            end

            Depbox.Visible = true
            DepboxContainer.Visible = true
            if not Library.Searching then
                task.defer(function()
                    Depbox:Resize()
                end)
            elseif not CancelSearch then
                Library:UpdateSearch(Library.SearchText)
            end
        end

        DepboxList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            if not Depbox.Visible then
                return
            end

            Depbox:Resize()
        end)

        function Depbox:SetupDependencies(Dependencies)
            for _, Dependency in Dependencies do
                assert(typeof(Dependency) == "table", "Dependency should be a table.")
                assert(Dependency[1] ~= nil, "Dependency is missing element.")
                assert(Dependency[2] ~= nil, "Dependency is missing expected value.")
            end

            Depbox.Dependencies = Dependencies
            Depbox:Update()
        end

        DepboxContainer:GetPropertyChangedSignal("Visible"):Connect(function()
            Depbox:Resize()
        end)

        setmetatable(Depbox, BaseGroupbox)

        table.insert(Groupbox.DependencyBoxes, Depbox)
        table.insert(Library.DependencyBoxes, Depbox)

        function Depbox:Destroy()
            Depbox.Destroyed = true

            if Depbox.Connections then
                for _, Connection in Depbox.Connections do
                    Connection:Disconnect()
                end
            end

            for _, Element in Depbox.Elements do
                if Element.Destroy then
                    Element:Destroy()
                end
            end

            for _, SubDepbox in Depbox.DependencyBoxes do
                if SubDepbox.Destroy then
                    SubDepbox:Destroy()
                end
            end

            if DepboxContainer then 
                DepboxContainer:Destroy() 
            end

            local ElemIdx = table.find(Groupbox.DependencyBoxes, Depbox)
            if ElemIdx then 
                table.remove(Groupbox.DependencyBoxes, ElemIdx)
            end

            local LibIdx = table.find(Library.DependencyBoxes, Depbox)
            if LibIdx then 
                table.remove(Library.DependencyBoxes, LibIdx) 
            end
        end

        return Depbox
    end

    function Funcs:AddDependencyGroupbox()
        if self.Destroyed then return nil end

        local Groupbox = self
        local Tab = Groupbox.Tab
        local BoxHolder = Groupbox.BoxHolder

        local DepGroupboxContainer
        local DepGroupboxList

        do
            DepGroupboxContainer = New("Frame", {
                BackgroundColor3 = "BackgroundColor",
                Size = UDim2.fromScale(1, 0),
                Visible = false,
                Parent = BoxHolder,
            })
            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius),
                    Parent = DepGroupboxContainer,
                })
            )
            Library:AddOutline(DepGroupboxContainer)

            DepGroupboxList = New("UIListLayout", {
                Padding = UDim.new(0, 8),
                Parent = DepGroupboxContainer,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 7),
                PaddingLeft = UDim.new(0, 7),
                PaddingRight = UDim.new(0, 7),
                PaddingTop = UDim.new(0, 7),
                Parent = DepGroupboxContainer,
            })
        end

        local DepGroupbox = {
            Connections = {},
            Destroyed = false,

            Visible = false,
            Dependencies = {},

            BoxHolder = BoxHolder,
            Holder = DepGroupboxContainer,
            Container = DepGroupboxContainer,

            Tab = Tab,
            Elements = {},
            DependencyBoxes = {},
        }

        function DepGroupbox:Resize()
            DepGroupboxContainer.Size = UDim2.new(1, 0, 0, (DepGroupboxList.AbsoluteContentSize.Y / Library.DPIScale) + 18)
        end

        function DepGroupbox:Update(CancelSearch)
            for _, Dependency in DepGroupbox.Dependencies do
                local Element = Dependency[1]
                local Value = Dependency[2]

                if Element.Type == "Toggle" and Element.Value ~= Value then
                    DepGroupboxContainer.Visible = false
                    DepGroupbox.Visible = false
                    return
                elseif Element.Type == "Dropdown" then
                    if typeof(Element.Value) == "table" then
                        if not Element.Value[Value] then
                            DepGroupboxContainer.Visible = false
                            DepGroupbox.Visible = false
                            return
                        end
                    else
                        if Element.Value ~= Value then
                            DepGroupboxContainer.Visible = false
                            DepGroupbox.Visible = false
                            return
                        end
                    end
                end
            end

            DepGroupbox.Visible = true
            if not Library.Searching then
                DepGroupboxContainer.Visible = true
                DepGroupbox:Resize()
            elseif not CancelSearch then
                Library:UpdateSearch(Library.SearchText)
            end
        end

        function DepGroupbox:SetupDependencies(Dependencies)
            for _, Dependency in Dependencies do
                assert(typeof(Dependency) == "table", "Dependency should be a table.")
                assert(Dependency[1] ~= nil, "Dependency is missing element.")
                assert(Dependency[2] ~= nil, "Dependency is missing expected value.")
            end

            DepGroupbox.Dependencies = Dependencies
            DepGroupbox:Update()
        end

        setmetatable(DepGroupbox, BaseGroupbox)

        table.insert(Tab.DependencyGroupboxes, DepGroupbox)
        table.insert(Library.DependencyBoxes, DepGroupbox :: any)

        function DepGroupbox:Destroy()
            DepGroupbox.Destroyed = true

            if DepGroupbox.Connections then
                for _, Connection in DepGroupbox.Connections do
                    Connection:Disconnect()
                end
            end

            for _, Element in DepGroupbox.Elements do
                if Element.Destroy then
                    Element:Destroy()
                end
            end

            for _, SubDepbox in DepGroupbox.DependencyBoxes do
                if SubDepbox.Destroy then
                    SubDepbox:Destroy()
                end
            end

            if DepGroupboxContainer then 
                DepGroupboxContainer:Destroy() 
            end

            local ElemIdx = table.find(Tab.DependencyGroupboxes, DepGroupbox)
            if ElemIdx then 
                table.remove(Tab.DependencyGroupboxes, ElemIdx) 
            end

            local LibIdx = table.find(Library.DependencyBoxes, DepGroupbox)
            if LibIdx then 
                table.remove(Library.DependencyBoxes, LibIdx) 
            end
        end

        return DepGroupbox
    end

    BaseGroupbox.__index = Funcs
    BaseGroupbox.__namecall = function(_, Key, ...)
        return Funcs[Key](...)
    end
end

function Library:SetFont(FontFace)
    if typeof(FontFace) == "EnumItem" then
        FontFace = Font.fromEnum(FontFace :: any)
    end

    Library.Scheme.Font = FontFace
    Library:UpdateColorsUsingRegistry()
end

function Library:SetBackgroundImage(Image: string | number)
    assert(typeof(Image) == "string" or typeof(Image) == "number", "Expected string/number got " .. typeof(Image))
    
    Library.Scheme.BackgroundImage = Image
    if Library.Window then
        Library.Window:SetBackgroundImage(Image)
    end

    Library:UpdateColorsUsingRegistry()
end

function Library:UpdateNotificationPositions(Snap: boolean?)
    local IsLeft = Library.NotifySide:lower() == "left"
    local XScale = IsLeft and 0 or 1
    local RunningY = 0

    for _, FakeBackground in NotifyOrder do
        local Data = Library.Notifications[FakeBackground]
        if not (Data and FakeBackground.Parent) then continue end

        local Target = UDim2.new(XScale, 0, 0, RunningY)
        if Snap or not Data.PositionInitialized then
            FakeBackground.Position = Target
            Data.PositionInitialized = true

        elseif FakeBackground.Position ~= Target then
            TweenService:Create(FakeBackground, Library.NotifyTweenInfo, {
                Position = Target,
            }):Play()
        end

        RunningY = RunningY + FakeBackground.AbsoluteSize.Y + 8
    end
end

function Library:SetNotifySide(Side: string)
    Library.NotifySide = Side

    local IsLeft = Side:lower() == "left"
    if IsLeft then
        NotificationArea.AnchorPoint = Vector2.new(0, 0)
        NotificationArea.Position = UDim2.fromOffset(6, 6)
    else
        NotificationArea.AnchorPoint = Vector2.new(1, 0)
        NotificationArea.Position = UDim2.new(1, -6, 0, 6)
    end

    for FakeBackground in Library.Notifications do
        if not (FakeBackground and FakeBackground.Parent) then continue end
        FakeBackground.AnchorPoint = if IsLeft then Vector2.new(0, 0) else Vector2.new(1, 0)
    end

    Library:UpdateNotificationPositions(true)
end

function Library:Notify(...)
    local Data = {}
    local Info = select(1, ...)

    if typeof(Info) == "table" then
        Data.Title = tostring(Info.Title)
        Data.TitleColor = Info.TitleColor

        Data.Description = tostring(Info.Description)
        Data.DescriptionColor = Info.DescriptionColor

        Data.Time = Info.Time or 5
        Data.SoundId = Info.SoundId
        Data.Steps = Info.Steps
        Data.Persist = Info.Persist

        Data.Icon = Info.Icon
        Data.BigIcon = Info.BigIcon
        Data.IconColor = Info.IconColor

        Data.Volume = tonumber(Info.Volume) or 3
    else
        Data.Description = tostring(Info)
        Data.Time = select(2, ...) or 5
        Data.SoundId = select(3, ...)
        Data.Volume = select(4, ...) or 3
    end
    Data.Destroyed = false

    local DeletedInstance = false
    local DeleteConnection = nil
    if typeof(Data.Time) == "Instance" then
        DeleteConnection = Data.Time.Destroying:Connect(function()
            DeletedInstance = true

            DeleteConnection:Disconnect()
            DeleteConnection = nil
        end)
    end

    local FakeBackground = New("Frame", {
        AnchorPoint = Library.NotifySide:lower() == "left" and Vector2.new(0, 0) or Vector2.new(1, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 0),
        Visible = false,
        Parent = NotificationArea,
    })

    local Holder = New("Frame", {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = "MainColor",
        Position = Library.NotifySide:lower() == "left" and UDim2.new(-1, -8, 0, -2) or UDim2.new(1, 8, 0, -2),
        Size = UDim2.fromScale(1, 1),
        ZIndex = 5,
        Parent = FakeBackground,
    })
    table.insert(
        Library.Corners,
        New("UICorner", {
            CornerRadius = UDim.new(0, Library.CornerRadius),
            Parent = Holder,
        })
    )
    New("UIListLayout", {
        Padding = UDim.new(0, 4),
        Parent = Holder,
    })
    New("UIPadding", {
        PaddingBottom = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingTop = UDim.new(0, 8),
        Parent = Holder,
    })
    Library:AddOutline(Holder)

    local ContentContainer = New("Frame", {
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.XY,
        Size = UDim2.fromScale(1, 0),
        Parent = Holder,
    })
    
    if Data.BigIcon then
        New("UIListLayout", {
            Padding = UDim.new(0, 8),
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Parent = ContentContainer,
        })
    end

    local BigIconLabel
    if Data.BigIcon then
        local ParsedIcon = Library:GetCustomIcon(Data.BigIcon)
        if ParsedIcon then
            BigIconLabel = New("ImageLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.fromOffset(24, 24),
                Image = ParsedIcon.Url,
                ImageColor3 = Data.IconColor or "AccentColor",
                ImageRectOffset = ParsedIcon.ImageRectOffset,
                ImageRectSize = ParsedIcon.ImageRectSize,
                Parent = ContentContainer,
            })
        end
    end

    local TextContainer = New("Frame", {
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.XY,
        Size = UDim2.fromScale(0, 0),
        Parent = ContentContainer,
    })
    New("UIListLayout", {
        Padding = UDim.new(0, 4),
        Parent = TextContainer,
    })
    
    local TitleContainer
    if Data.Title then
        TitleContainer = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(0, 0),
            Parent = TextContainer,
        })
    end

    local IconLabel
    if Data.Icon and TitleContainer then
        local ParsedIcon = Library:GetCustomIcon(Data.Icon)
        if ParsedIcon then
            IconLabel = New("ImageLabel", {
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, 0, 0.5, 1),
                Size = UDim2.fromOffset(15, 15),
                Image = ParsedIcon.Url,
                ImageColor3 = Data.IconColor or "FontColor",
                ImageRectOffset = ParsedIcon.ImageRectOffset,
                ImageRectSize = ParsedIcon.ImageRectSize,
                Parent = TitleContainer,
            })
        end
    end

    local Title
    local Desc
    local TitleX = 0
    local DescX = 0

    local TimerFill

    if Data.Title then
        Title = New("TextLabel", {
            AutomaticSize = Enum.AutomaticSize.None,
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, (Data.Icon and 21 or 0), 0.5, 0),
            Size = UDim2.fromScale(0, 0),
            Text = Data.Title,
            TextColor3 = Data.TitleColor or "FontColor",
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            TextWrapped = true,
            Parent = TitleContainer,
        })
    end

    if Data.Description then
        Desc = New("TextLabel", {
            AutomaticSize = Enum.AutomaticSize.None,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(0, 0),
            Text = Data.Description,
            TextColor3 = Data.DescriptionColor or "FontColor",
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = TextContainer,
        })
    end

    function Data:Resize()
        local ExtraWidth = BigIconLabel and 32 or 0
        local IconWidth = IconLabel and 21 or 0

        if Title then
            local X, Y =
                Library:GetTextBounds(Title.Text, Title.FontFace, Title.TextSize, (NotificationArea.AbsoluteSize.X / Library.DPIScale) - 24 - ExtraWidth - IconWidth)
            Title.Size = UDim2.fromOffset(X, Y)
            TitleX = X + IconWidth
            TitleContainer.Size = UDim2.fromOffset(TitleX, math.max(Y, IconLabel and 16 or 0))
        end

        if Desc then
            local X, Y =
                Library:GetTextBounds(Desc.Text, Desc.FontFace, Desc.TextSize, (NotificationArea.AbsoluteSize.X / Library.DPIScale) - 24 - ExtraWidth)
            Desc.Size = UDim2.fromOffset(X, Y)
            DescX = X
        end

        FakeBackground.Size = UDim2.fromOffset(math.max(TitleX, DescX) + 24 + ExtraWidth, 0)

        if Library.Notifications[FakeBackground] then
            Library:UpdateNotificationPositions()
        end
    end

    function Data:ChangeTitle(Text)
        if Title then
            Data.Title = tostring(Text)
            Title.Text = Data.Title
            Data:Resize()
        end
    end

    function Data:ChangeDescription(Text)
        if Desc then
            Data.Description = tostring(Text)
            Desc.Text = Data.Description
            Data:Resize()
        end
    end

    function Data:ChangeStep(NewStep)
        if TimerFill and Data.Steps then
            NewStep = math.clamp(NewStep or 0, 0, Data.Steps)
            TimerFill.Size = UDim2.fromScale(NewStep / Data.Steps, 1)
        end
    end

    function Data:Destroy()
        Data.Destroyed = true

        if typeof(Data.Time) == "Instance" then
            pcall(Data.Time.Destroy, Data.Time)
        end

        if DeleteConnection then
            DeleteConnection:Disconnect()
        end

        if FakeBackground then
            local Idx = table.find(NotifyOrder, FakeBackground)
            if Idx then
                table.remove(NotifyOrder, Idx)
            end
        end

        Library:UpdateNotificationPositions()

        TweenService
            :Create(Holder, Library.NotifyTweenInfo, {
                Position = Library.NotifySide:lower() == "left" and UDim2.new(-1, -8, 0, -2) or UDim2.new(1, 8, 0, -2),
            })
            :Play()

        task.delay(Library.NotifyTweenInfo.Time, function()
            Library.Notifications[FakeBackground] = nil
            FakeBackground:Destroy()
        end)
    end

    Data:Resize()

    local TimerHolder = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 7),
        Visible = (Data.Persist ~= true and typeof(Data.Time) ~= "Instance") or typeof(Data.Steps) == "number",
        Parent = Holder,
    })
    local TimerBar = New("Frame", {
        BackgroundColor3 = "BackgroundColor",
        BorderColor3 = "OutlineColor",
        BorderSizePixel = 1,
        Position = UDim2.fromOffset(0, 3),
        Size = UDim2.new(1, 0, 0, 2),
        Parent = TimerHolder,
    })
    TimerFill = New("Frame", {
        BackgroundColor3 = "AccentColor",
        Size = UDim2.fromScale(1, 1),
        Parent = TimerBar,
    })

    if typeof(Data.Time) == "Instance" then
        TimerFill.Size = UDim2.fromScale(0, 1)
    end
    if Data.SoundId then
        local SoundId = Data.SoundId
        if typeof(SoundId) == "number" then
            SoundId = string.format("rbxassetid://%d", SoundId)
        end

        New("Sound", {
            SoundId = SoundId,
            Volume = tonumber(Data.Volume) or 3,
            PlayOnRemove = true,
            Parent = SoundService,
        }):Destroy()
    end

    Data.Holder = Holder

    table.insert(NotifyOrder, FakeBackground)
    Library.Notifications[FakeBackground] = Data

    Library:UpdateNotificationPositions()

    FakeBackground.Visible = true
    TweenService:Create(Holder, Library.NotifyTweenInfo, {
        Position = UDim2.fromOffset(0, 0),
    }):Play()

    task.delay(Library.NotifyTweenInfo.Time, function()
        if Data.Persist then
            return
        elseif typeof(Data.Time) == "Instance" then
            repeat
                task.wait()
            until DeletedInstance or Data.Destroyed
        else
            TweenService
                :Create(TimerFill, TweenInfo.new(Data.Time, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                    Size = UDim2.fromScale(0, 1),
                })
                :Play()
            task.wait(Data.Time)
        end

        if not Data.Destroyed then
            Data:Destroy()
        end
    end)

    return Data
end

function Library:CreateWindow(WindowInfo)
    WindowInfo = Library:Validate(WindowInfo, Templates.Window)
    local ViewportSize: Vector2 = workspace.CurrentCamera.ViewportSize
    if RunService:IsStudio() and ViewportSize.X <= 5 and ViewportSize.Y <= 5 then
        repeat
            ViewportSize = workspace.CurrentCamera.ViewportSize
            task.wait()
        until ViewportSize.X > 5 and ViewportSize.Y > 5
    end

    local MaxX = ViewportSize.X - 64
    local MaxY = ViewportSize.Y - 64

    Library.OriginalMinSize =
        Vector2.new(math.min(Library.OriginalMinSize.X, MaxX), math.min(Library.OriginalMinSize.Y, MaxY))
    Library.MinSize = Library.OriginalMinSize

    WindowInfo.Size = UDim2.fromOffset(
        math.clamp(WindowInfo.Size.X.Offset, Library.MinSize.X, MaxX),
        math.clamp(WindowInfo.Size.Y.Offset, Library.MinSize.Y, MaxY)
    )
    if typeof(WindowInfo.Font) == "EnumItem" then
        WindowInfo.Font = Font.fromEnum(WindowInfo.Font :: any)
    end
    WindowInfo.CornerRadius = math.min(WindowInfo.CornerRadius, 20)
    
    --// Old Naming \\--
    if WindowInfo.Compact ~= nil then
        WindowInfo.SidebarCompacted = WindowInfo.Compact
    end
    if WindowInfo.SidebarMinWidth ~= nil then
        WindowInfo.MinSidebarWidth = WindowInfo.SidebarMinWidth
    end
    WindowInfo.MinSidebarWidth = math.max(64, WindowInfo.MinSidebarWidth)
    WindowInfo.SidebarCompactWidth = math.max(48, WindowInfo.SidebarCompactWidth)
    WindowInfo.SidebarCollapseThreshold = math.clamp(WindowInfo.SidebarCollapseThreshold, 0.1, 0.9)
    WindowInfo.CompactWidthActivation = math.max(48, WindowInfo.CompactWidthActivation)

    Library.CornerRadius = WindowInfo.CornerRadius
    Library:SetNotifySide(WindowInfo.NotifySide)
    Library.ShowCustomCursor = WindowInfo.ShowCustomCursor
    Library.Scheme.Font = WindowInfo.Font
    Library.ToggleKeybind = WindowInfo.ToggleKeybind
    Library.GlobalSearch = WindowInfo.GlobalSearch
    
    Library.Animations = WindowInfo.Animations
    Library.TabTransitionInfo = TweenInfo.new(
        math.max(0, WindowInfo.TabTransitionTime or 0.22),
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    Library.TabSwipeOffset = math.max(1, WindowInfo.TabSwipeOffset or 26)
    Library.TabSwipeFrom = WindowInfo.TabSwipeFrom or "right"

    local IsDefaultSearchbarSize = WindowInfo.SearchbarSize == UDim2.fromScale(1, 1)
    local MainFrame
    local DividerLine
    local TitleHolder
    local WindowTitle
    local WindowIcon
    local RightWrapper
    local SearchBox
    local CurrentTabInfo
    local CurrentTabLabel
    local CurrentTabDescription
    local ResizeButton
    local Tabs
    local Container
    local BackgroundImage
    local BottomBackground
    local FooterLabel
    local TopBar

    local InitialLeftWidth = math.ceil(WindowInfo.Size.X.Offset * 0.3)
    local IsCompact = WindowInfo.SidebarCompacted
    local LastExpandedWidth = InitialLeftWidth

    do
        Library.KeybindFrame, Library.KeybindContainer = Library:AddDraggableMenu("快捷键")
        Library.KeybindFrame.AnchorPoint = Vector2.new(0, 0.5)
        Library.KeybindFrame.Position = UDim2.new(0, 6, 0.5, 0)
        Library.KeybindFrame.Visible = false

        MainFrame = New("TextButton", {
            BackgroundColor3 = function()
                return Library:GetBetterColor(Library.Scheme.BackgroundColor, -1)
            end,
            Name = "Main",
            Text = "",
            Position = WindowInfo.Position,
            Size = WindowInfo.Size,
            Visible = false,
            Parent = ScreenGui,
        })
        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                Parent = MainFrame,
            })
        )
        table.insert(
            Library.Scales,
            New("UIScale", {
                Parent = MainFrame,
            })
        )
        Library:AddOutline(MainFrame)
        Library:MakeLine(MainFrame, {
            Position = UDim2.fromOffset(0, 48),
            Size = UDim2.new(1, 0, 0, 1),
        })

        DividerLine = New("Frame", {
            BackgroundColor3 = "OutlineColor",
            Position = UDim2.fromOffset(InitialLeftWidth, 0),
            Size = UDim2.new(0, 1, 1, -21),
            Parent = MainFrame,
            ZIndex = 2
        })

        local BackgroundIcon = Library:GetCustomIcon(WindowInfo.BackgroundImage)
        BackgroundImage = New("ImageLabel", {
            Image = BackgroundIcon and BackgroundIcon.Url or "",
            ImageRectOffset = BackgroundIcon and BackgroundIcon.ImageRectOffset or Vector2.zero,
            ImageRectSize = BackgroundIcon and BackgroundIcon.ImageRectSize or Vector2.zero,
            Position = UDim2.fromScale(0, 0),
            Size = UDim2.fromScale(1, 1),
            ScaleType = Enum.ScaleType.Stretch,
            ZIndex = 999,
            BackgroundTransparency = 1,
            ImageTransparency = 0.75,
            Visible = BackgroundIcon ~= nil,
            Parent = MainFrame,
        })

        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                Parent = BackgroundImage,
            })
        )

        if WindowInfo.Center then
            MainFrame.Position = UDim2.new(0.5, -MainFrame.Size.X.Offset / 2, 0.5, -MainFrame.Size.Y.Offset / 2)
        end

        --// Top Bar \\-
        TopBar = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 48),
            Parent = MainFrame,
        })
        Library:MakeDraggable(MainFrame, TopBar, false, true)

        --// Title \\--
        TitleHolder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, InitialLeftWidth, 1, 0),
            Parent = TopBar,
        })
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 6),
            Parent = TitleHolder,
        })

        if WindowInfo.Icon then
            local Icon = Library:GetCustomIcon(WindowInfo.Icon)
            WindowIcon = New("ImageLabel", {
                Image = Icon and Icon.Url or "",
                ImageRectOffset = Icon and Icon.ImageRectOffset or Vector2.zero,
                ImageRectSize = Icon and Icon.ImageRectSize or Vector2.zero,
                Size = WindowInfo.IconSize,
                Parent = TitleHolder,
            })
        else
            WindowIcon = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = WindowInfo.IconSize,
                Text = WindowInfo.Title:sub(1, 1),
                TextScaled = true,
                Visible = false,
                Parent = TitleHolder,
            })
        end

        local X = Library:GetTextBounds(
            WindowInfo.Title,
            Library.Scheme.Font,
            20,
            TitleHolder.AbsoluteSize.X - (WindowInfo.Icon and WindowInfo.IconSize.X.Offset + 6 or 0) - 12
        )
        WindowTitle = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, X, 1, 0),
            Text = WindowInfo.Title,
            TextSize = 20,
            Parent = TitleHolder,
        })

        --// Top Right Bar \\--
        RightWrapper = New("Frame", {
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -49, 0.5, 0),
            Size = UDim2.new(1, -InitialLeftWidth - 57 - 1, 1, -16),
            Parent = TopBar,
        })

        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 8),
            Parent = RightWrapper,
        })

        CurrentTabInfo = New("Frame", {
            Size = UDim2.fromScale(WindowInfo.DisableSearch and 1 or 0.5, 1),
            Visible = false,
            BackgroundTransparency = 1,
            Parent = RightWrapper,
        })

        New("UIFlexItem", {
            FlexMode = Enum.UIFlexMode.Grow,
            Parent = CurrentTabInfo,
        })

        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Parent = CurrentTabInfo,
        })

        New("UIPadding", {
            PaddingBottom = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 8),
            Parent = CurrentTabInfo,
        })

        CurrentTabLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Text = "",
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = CurrentTabInfo,
        })

        CurrentTabDescription = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Text = "",
            TextWrapped = true,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = 0.5,
            Parent = CurrentTabInfo,
        })

        SearchBox = New("TextBox", {
            BackgroundColor3 = "MainColor",
            PlaceholderText = "搜索",
            Size = WindowInfo.SearchbarSize,
            TextScaled = true,
            Visible = not (WindowInfo.DisableSearch or false),
            Parent = RightWrapper,
        })
        New("UIFlexItem", {
            FlexMode = Enum.UIFlexMode.Shrink,
            Parent = SearchBox,
        })
        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                Parent = SearchBox,
            })
        )
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 8),
            Parent = SearchBox,
        })
        New("UIStroke", {
            Color = "OutlineColor",
            Parent = SearchBox,
        })

        local SearchIcon = Library:GetIcon("search")
        if SearchIcon then
            New("ImageLabel", {
                Image = SearchIcon.Url,
                ImageColor3 = "FontColor",
                ImageRectOffset = SearchIcon.ImageRectOffset,
                ImageRectSize = SearchIcon.ImageRectSize,
                ImageTransparency = 0.5,
                Size = UDim2.fromScale(1, 1),
                SizeConstraint = Enum.SizeConstraint.RelativeYY,
                Parent = SearchBox,
            })
        end

        if MoveIcon then
            New("ImageLabel", {
                AnchorPoint = Vector2.new(1, 0.5),
                Image = MoveIcon.Url,
                ImageColor3 = "OutlineColor",
                ImageRectOffset = MoveIcon.ImageRectOffset,
                ImageRectSize = MoveIcon.ImageRectSize,
                Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.fromOffset(28, 28),
                SizeConstraint = Enum.SizeConstraint.RelativeYY,
                Parent = TopBar,
            })
        end

        --// Bottom Bar \\--
        BottomBackground = New("Frame", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = function()
                return Library:GetBetterColor(Library.Scheme.BackgroundColor, 4)
            end,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.new(1, 0, 0, 20 + WindowInfo.CornerRadius),
            Parent = MainFrame
        })
        Library:MakeLine(MainFrame, {
            AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.new(0, 0, 1, -20),
            Size = UDim2.new(1, 0, 0, 1),
        })

        local BottomBar = New("Frame", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.new(1, 0, 0, 20),
            Parent = MainFrame,
        })
        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                Parent = BottomBackground,
            })
        )

        --// Footer \\-
        FooterLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Text = WindowInfo.Footer,
            TextSize = 14,
            TextTransparency = 0.5,
            Parent = BottomBar,
        })

        --// Resize Button \\--
        if WindowInfo.Resizable then
            ResizeButton = New("TextButton", {
                AnchorPoint = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -WindowInfo.CornerRadius / 4, 0, 0),
                Size = UDim2.fromScale(1, 1),
                SizeConstraint = Enum.SizeConstraint.RelativeYY,
                Text = "",
                Parent = BottomBar,
            })

            Library:MakeResizable(MainFrame, ResizeButton, function()
                for _, Tab in Library.Tabs do
                    Tab:Resize(true)
                end
            end)
        end

        New("ImageLabel", {
            Image = ResizeIcon and ResizeIcon.Url or "",
            ImageColor3 = "FontColor",
            ImageRectOffset = ResizeIcon and ResizeIcon.ImageRectOffset or Vector2.zero,
            ImageRectSize = ResizeIcon and ResizeIcon.ImageRectSize or Vector2.zero,
            ImageTransparency = 0.5,
            Position = UDim2.fromOffset(2, 2),
            Size = UDim2.new(1, -4, 1, -4),
            Parent = ResizeButton,
        })

        --// Tabs \\--
        Tabs = New("ScrollingFrame", {
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = "BackgroundColor",
            CanvasSize = UDim2.fromScale(0, 0),
            Position = UDim2.fromOffset(0, 49),
            ScrollBarThickness = 0,
            Size = UDim2.new(0, InitialLeftWidth, 1, -70),
            Parent = MainFrame,
        })
        New("UIListLayout", {
            Parent = Tabs,
        })

        --// Container \\--
        Container = New("Frame", {
            AnchorPoint = Vector2.new(1, 0),
            BackgroundColor3 = function()
                return Library:GetBetterColor(Library.Scheme.BackgroundColor, 1)
            end,
            ClipsDescendants = true,
            Name = "Container",
            Position = UDim2.new(1, 0, 0, 49),
            Size = UDim2.new(1, -InitialLeftWidth - 1, 1, -70),
            Parent = MainFrame,
        })
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 0),
            PaddingLeft = UDim.new(0, 6),
            PaddingRight = UDim.new(0, 6),
            PaddingTop = UDim.new(0, 0),
            Parent = Container,
        })

        Library.WindowContainer = Container
    end

    --// Window Table \\--
    local Window = {}
    local Fading = false

    local function SetUICorner(UICorner, Corner, HalfCurrent, HalfValue, Value)
        local Current = UICorner[Corner]
        if Current.Offset == 0 and Current.Scale == 0 then
            return
        end

        UICorner[Corner] = Current.Offset == HalfCurrent and HalfValue or Value
    end

    function Window:ChangeTitle(title)
        assert(typeof(title) == "string", "Expected string for title got: " .. typeof(title))

        WindowTitle.Text = title
        WindowInfo.Title = title
    end

    function Window:SetBackgroundImage(Image: string)
        local ValidIcon = false

        if typeof(Image) == "string" then
            local BackgroundIcon = Library:GetCustomIcon(Image)

            if BackgroundIcon then
                ValidIcon = true

                BackgroundImage.Image = BackgroundIcon.Url
                BackgroundImage.ImageRectOffset = BackgroundIcon.ImageRectOffset
                BackgroundImage.ImageRectSize = BackgroundIcon.ImageRectSize
                BackgroundImage.Visible = true
            elseif Image:match("http://") or Image:match("https://") then
                local RawFileName = Image:match("(.+)%..+$")
                local _, Domain = Image:match("^(https?://)([^/]+)"); 

                if RawFileName and Domain then
                    local Extention = string.sub(Image, #RawFileName + 1, #Image)
                    local FileNamePos = RawFileName:gsub("\\", "/"):find("/[^/]*$")
                    local FileName = FileNamePos and Image:sub(FileNamePos + 1) or nil

                    if FileName then
                        ValidIcon = true

                        local AssetName = Domain .. FileName
                        if #AssetName > 255 then
                            local NewLength = 255 - #Domain - #Extention
                            if NewLength < 0 then
                                AssetName = Domain .. Extention
                            else
                                AssetName = Domain .. string.sub(FileName:sub(1, #FileName - #Extention), 1, NewLength) .. Extention
                            end
                        end

                        if CustomImageManagerAssets[FileName] == nil then
                            CustomImageManager.AddAsset(FileName, 0, Image)
                        else
                            CustomImageManager.DownloadAsset(FileName, true)
                        end

                        BackgroundImage.Image = CustomImageManager.GetAsset(FileName)
                        BackgroundImage.ImageRectOffset = Vector2.zero
                        BackgroundImage.ImageRectSize = Vector2.zero
                        BackgroundImage.Visible = true
                    end
                end
            end
        end

        if not ValidIcon then
            BackgroundImage.Image = ""
            BackgroundImage.ImageRectOffset = Vector2.zero
            BackgroundImage.ImageRectSize = Vector2.zero
            BackgroundImage.Visible = false
        end
    
        WindowInfo.BackgroundImage = Image
    end

    function Window:SetFooter(Footer: string)
        assert(typeof(Footer) == "string", "Expected string for footer got: " .. typeof(Footer))

        FooterLabel.Text = Footer
        WindowInfo.Footer = Footer
    end

    function Window:SetCornerRadius(Radius: number)
        assert(typeof(Radius) == "number", "Expected number for Radius got: " .. typeof(Radius))
        Radius = math.min(Radius, 20)

        local RadiusHalf = UDim.new(0, Radius / 2)
        local RadiusUDim = UDim.new(0, Radius)
        local HalfCurrent = Library.CornerRadius / 2

        for _, UICorner in Library.Corners do
            if UICorner.CornerRadius.Offset == HalfCurrent then
                UICorner.CornerRadius = RadiusHalf
            else
                UICorner.CornerRadius = RadiusUDim
            end
        end

        for _, UICorner in Library.SpecificCorners do
            SetUICorner(UICorner, "TopRightRadius", HalfCurrent, RadiusHalf, RadiusUDim)
            SetUICorner(UICorner, "TopLeftRadius", HalfCurrent, RadiusHalf, RadiusUDim)
            SetUICorner(UICorner, "BottomRightRadius", HalfCurrent, RadiusHalf, RadiusUDim)
            SetUICorner(UICorner, "BottomLeftRadius", HalfCurrent, RadiusHalf, RadiusUDim)
        end

        Library.CornerRadius = Radius
        WindowInfo.CornerRadius = Radius

        ResizeButton.Position = UDim2.new(1, -Radius / 4, 0, 0)
        BottomBackground.Size = UDim2.new(1, 0, 0, 20 + Radius)

        for _, Tab in Library.Tabs do
            if Tab.IsKeyTab then
                continue
            end

            for _, Tabbox in Tab.Tabboxes do
                Tabbox:UpdateCorners()
            end
        end
    end

    function Window:SetAnimations(Animations: { [string]: boolean }?, TabTransitionTime: number?, TabSwipeOffset: number?, TabSwipeFrom: ("left" | "right" | "top" | "bottom" | string)?)
        if typeof(Animations) == "table" then
            WindowInfo.Animations = Animations
            Library.Animations = Animations
        end

        if typeof(TabTransitionTime) == "number" then
            local TweenInfo = TweenInfo.new(
                math.max(0, TabTransitionTime or 0.22),
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            )

            WindowInfo.TabTransitionInfo = TweenInfo
            Library.TabTransitionInfo = TweenInfo
        end

        if typeof(TabSwipeOffset) == "number" then
            TabSwipeOffset = math.max(1, TabSwipeOffset)

            WindowInfo.TabSwipeOffset = TabSwipeOffset
            Library.TabSwipeOffset = TabSwipeOffset
        end

        if typeof(TabSwipeFrom) == "string" then
            TabSwipeFrom = string.lower(TabSwipeFrom)

            WindowInfo.TabSwipeFrom = TabSwipeFrom
            Library.TabSwipeFrom = TabSwipeFrom
        end
    end

    local function ApplyCompact()
        IsCompact = Window:GetSidebarWidth() == WindowInfo.SidebarCompactWidth
        if WindowInfo.DisableCompactingSnap then
            IsCompact = Window:GetSidebarWidth() <= WindowInfo.CompactWidthActivation
        end

        WindowTitle.Visible = not IsCompact
        if not WindowInfo.Icon then
            WindowIcon.Visible = IsCompact
        end

        for _, Button in Library.TabButtons do
            if not Button.Icon then
                continue
            end

            Button.Label.Visible = not IsCompact
            Button.Padding.PaddingBottom = UDim.new(0, IsCompact and 6 or 11)
            Button.Padding.PaddingLeft = UDim.new(0, IsCompact and 6 or 12)
            Button.Padding.PaddingRight = UDim.new(0, IsCompact and 6 or 12)
            Button.Padding.PaddingTop = UDim.new(0, IsCompact and 6 or 11)
            Button.Icon.SizeConstraint = IsCompact and Enum.SizeConstraint.RelativeXY or Enum.SizeConstraint.RelativeYY
        end
    end

    function Window:IsSidebarCompacted()
        return IsCompact
    end

    function Window:SetCompact(State)
        Window:SetSidebarWidth(State and WindowInfo.SidebarCompactWidth or LastExpandedWidth)
    end

    function Window:GetSidebarWidth()
        return Tabs.Size.X.Offset
    end

    function Window:SetSidebarWidth(Width)
        Width = math.clamp(Width, 48, MainFrame.Size.X.Offset - WindowInfo.MinContainerWidth - 1)

        DividerLine.Position = UDim2.fromOffset(Width, 0)

        TitleHolder.Size = UDim2.new(0, Width, 1, 0)
        RightWrapper.Size = UDim2.new(1, -Width - 57 - 1, 1, -16)
        Tabs.Size = UDim2.new(0, Width, 1, -70)
        Container.Size = UDim2.new(1, -Width - 1, 1, -70)

        if WindowInfo.EnableCompacting then
            ApplyCompact()
        end
        if not IsCompact then
            LastExpandedWidth = Width
        end
    end

    function Window:ShowTabInfo(Name, Description)
        CurrentTabLabel.Text = Name
        CurrentTabDescription.Text = Description

        if IsDefaultSearchbarSize then
            SearchBox.Size = UDim2.fromScale(0.5, 1)
        end
        CurrentTabInfo.Visible = true
    end

    function Window:HideTabInfo()
        CurrentTabInfo.Visible = false
        if IsDefaultSearchbarSize then
            SearchBox.Size = UDim2.fromScale(1, 1)
        end
    end

    function Window:AddTab(...)
        local Name = nil
        local Icon = nil
        local Description = nil
        local Order = nil

        if select("#", ...) == 1 and typeof(...) == "table" then
            local Info = select(1, ...)
            Name = Info.Name or "Tab"
            Icon = Info.Icon
            Description = Info.Description
            Order = Info.Order
        else
            Name = select(1, ...)
            Icon = select(2, ...)
            Description = select(3, ...)
            Order = select(4, ...)
        end

        local TabButton: TextButton
        local TabLabel
        local TabIcon

        local TabContainer
        local TabCanvas
        local TabLeft
        local TabRight

        Icon = Library:GetCustomIcon(Icon)
        do
            TabButton = New("TextButton", {
                BackgroundColor3 = "MainColor",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 40),
                Text = "",
                LayoutOrder = Order,
                Parent = Tabs,
            })
            local ButtonPadding = New("UIPadding", {
                PaddingBottom = UDim.new(0, IsCompact and 6 or 11),
                PaddingLeft = UDim.new(0, IsCompact and 6 or 12),
                PaddingRight = UDim.new(0, IsCompact and 6 or 12),
                PaddingTop = UDim.new(0, IsCompact and 6 or 11),
                Parent = TabButton,
            })

            TabLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(30, 0),
                Size = UDim2.new(1, -30, 1, 0),
                Text = Name,
                TextSize = 16,
                TextTransparency = 0.5,
                TextXAlignment = Enum.TextXAlignment.Left,
                Visible = not IsCompact,
                Parent = TabButton,
            })

            if Icon then
                TabIcon = New("ImageLabel", {
                    Image = Icon.Url,
                    ImageColor3 = Icon.Custom and "WhiteColor" or "AccentColor",
                    ImageRectOffset = Icon.ImageRectOffset,
                    ImageRectSize = Icon.ImageRectSize,
                    ImageTransparency = 0.5,
                    ScaleType = Enum.ScaleType.Fit,
                    Size = UDim2.fromScale(1, 1),
                    SizeConstraint = IsCompact and Enum.SizeConstraint.RelativeXY or Enum.SizeConstraint.RelativeYY,
                    Parent = TabButton,
                })
            end

            table.insert(Library.TabButtons, {
                Label = TabLabel,
                Padding = ButtonPadding,
                Icon = TabIcon,
            })

            --// Tab Canvas \\--
            TabCanvas = New("CanvasGroup", {
                BackgroundTransparency = 1,
                ClipsDescendants = true,
                GroupTransparency = 0,
                Size = UDim2.fromScale(1, 1),
                Visible = false,
                Parent = Container,
            })

            --// Tab Container \\--
            TabContainer = New("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0, 0),
                Size = UDim2.fromScale(1, 1),
                Visible = true,
                Parent = TabCanvas,
            })

            TabLeft = New("ScrollingFrame", {
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                CanvasSize = UDim2.fromScale(0, 0),
                ScrollBarImageTransparency = 1,
                ScrollBarThickness = 0,
                Size = UDim2.new(0.5, -3, 1, 0),
                Parent = TabContainer,
            })
            New("UIListLayout", {
                Padding = UDim.new(0, 2),
                Parent = TabLeft,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 2),
                PaddingLeft = UDim.new(0, 2),
                PaddingRight = UDim.new(0, 2),
                PaddingTop = UDim.new(0, 2),
                Parent = TabLeft,
            })
            do
                New("Frame", {
                    BackgroundTransparency = 1,
                    LayoutOrder = -1,
                    Parent = TabLeft,
                })
                New("Frame", {
                    BackgroundTransparency = 1,
                    LayoutOrder = 1,
                    Parent = TabLeft,
                })
            end

            TabRight = New("ScrollingFrame", {
                AnchorPoint = Vector2.new(1, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                CanvasSize = UDim2.fromScale(0, 0),
                Position = UDim2.fromScale(1, 0),
                ScrollBarImageTransparency = 1,
                ScrollBarThickness = 0,
                Size = UDim2.new(0.5, -3, 1, 0),
                Parent = TabContainer,
            })
            New("UIListLayout", {
                Padding = UDim.new(0, 2),
                Parent = TabRight,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 2),
                PaddingLeft = UDim.new(0, 2),
                PaddingRight = UDim.new(0, 2),
                PaddingTop = UDim.new(0, 2),
                Parent = TabRight,
            })
            do
                New("Frame", {
                    BackgroundTransparency = 1,
                    LayoutOrder = -1,
                    Parent = TabRight,
                })
                New("Frame", {
                    BackgroundTransparency = 1,
                    LayoutOrder = 1,
                    Parent = TabRight,
                })
            end
        end

        --// Warning Box \\--
        local WarningBoxHolder = New("Frame", {
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(0, 7),
            Size = UDim2.fromScale(1, 0),
            Visible = false,
            Parent = TabContainer,
        })

        local WarningBox
        local WarningBoxOutline
        local WarningBoxShadowOutline
        local WarningBoxScrollingFrame
        local WarningTitle
        local WarningStroke
        local WarningText
        do
            WarningBox = New("Frame", {
                BackgroundColor3 = "BackgroundColor",
                Position = UDim2.fromOffset(2, 0),
                Size = UDim2.new(1, -5, 0, 0),
                Parent = WarningBoxHolder,
            })
            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                    Parent = WarningBox,
                })
            )
            WarningBoxOutline, WarningBoxShadowOutline = Library:AddOutline(WarningBox)

            WarningBoxScrollingFrame = New("ScrollingFrame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2.fromScale(1, 1),
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ScrollBarThickness = 3,
                ScrollingDirection = Enum.ScrollingDirection.Y,
                Parent = WarningBox,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 4),
                PaddingLeft = UDim.new(0, 6),
                PaddingRight = UDim.new(0, 6),
                PaddingTop = UDim.new(0, 4),
                Parent = WarningBoxScrollingFrame,
            })

            WarningTitle = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -4, 0, 14),
                Text = "",
                TextColor3 = Color3.fromRGB(255, 50, 50),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = WarningBoxScrollingFrame,
            })

            WarningStroke = New("UIStroke", {
                ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                Color = Color3.fromRGB(169, 0, 0),
                LineJoinMode = Enum.LineJoinMode.Miter,
                Parent = WarningTitle,
            })

            WarningText = New("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(0, 16),
                Size = UDim2.new(1, -4, 0, 0),
                Text = "",
                TextSize = 14,
                TextWrapped = true,
                Parent = WarningBoxScrollingFrame,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
            })

            New("UIStroke", {
                ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                Color = "DarkColor",
                LineJoinMode = Enum.LineJoinMode.Miter,
                Parent = WarningText,
            })
        end

        --// Tab Table \\--
        local Tab = {
            Description = Description,

            Connections = {},
            Destroyed = false,

            Window = Window,
            Canvas = TabCanvas,
            Sides = {
                TabLeft,
                TabRight,
            },
            WarningBox = {
                IsNormal = false,
                LockSize = false,
                Visible = false,
                Title = "警告",
                Text = "",
            },

            Groupboxes = {},
            Tabboxes = {},
            DependencyGroupboxes = {},
        }

        function Tab:UpdateWarningBox(Info)
            if typeof(Info.IsNormal) == "boolean" then
                Tab.WarningBox.IsNormal = Info.IsNormal
            end
            if typeof(Info.LockSize) == "boolean" then
                Tab.WarningBox.LockSize = Info.LockSize
            end
            if typeof(Info.Visible) == "boolean" then
                Tab.WarningBox.Visible = Info.Visible
            end
            if typeof(Info.Title) == "string" then
                Tab.WarningBox.Title = Info.Title
            end
            if typeof(Info.Text) == "string" then
                Tab.WarningBox.Text = Info.Text
            end

            WarningBoxHolder.Visible = Tab.WarningBox.Visible
            WarningTitle.Text = Tab.WarningBox.Title
            WarningText.Text = Tab.WarningBox.Text
            Tab:Resize(true)

            WarningBox.BackgroundColor3 = Tab.WarningBox.IsNormal == true and Library.Scheme.BackgroundColor
                or Color3.fromRGB(127, 0, 0)

            WarningBoxShadowOutline.Color = Tab.WarningBox.IsNormal == true and Library.Scheme.DarkColor
                or Color3.fromRGB(85, 0, 0)
            WarningBoxOutline.Color = Tab.WarningBox.IsNormal == true and Library.Scheme.OutlineColor
                or Color3.fromRGB(255, 50, 50)

            WarningTitle.TextColor3 = Tab.WarningBox.IsNormal == true and Library.Scheme.FontColor
                or Color3.fromRGB(255, 50, 50)
            WarningStroke.Color = Tab.WarningBox.IsNormal == true and Library.Scheme.OutlineColor
                or Color3.fromRGB(169, 0, 0)

            if not Library.Registry[WarningBox] then
                Library:AddToRegistry(WarningBox, {})
            end
            if not Library.Registry[WarningBoxShadowOutline] then
                Library:AddToRegistry(WarningBoxShadowOutline, {})
            end
            if not Library.Registry[WarningBoxOutline] then
                Library:AddToRegistry(WarningBoxOutline, {})
            end
            if not Library.Registry[WarningTitle] then
                Library:AddToRegistry(WarningTitle, {})
            end
            if not Library.Registry[WarningStroke] then
                Library:AddToRegistry(WarningStroke, {})
            end

            Library.Registry[WarningBox].BackgroundColor3 = function()
                return Tab.WarningBox.IsNormal == true and Library.Scheme.BackgroundColor or Color3.fromRGB(127, 0, 0)
            end

            Library.Registry[WarningBoxShadowOutline].Color = function()
                return Tab.WarningBox.IsNormal == true and Library.Scheme.DarkColor or Color3.fromRGB(85, 0, 0)
            end

            Library.Registry[WarningBoxOutline].Color = function()
                return Tab.WarningBox.IsNormal == true and Library.Scheme.OutlineColor or Color3.fromRGB(255, 50, 50)
            end

            Library.Registry[WarningTitle].TextColor3 = function()
                return Tab.WarningBox.IsNormal == true and Library.Scheme.FontColor or Color3.fromRGB(255, 50, 50)
            end

            Library.Registry[WarningStroke].Color = function()
                return Tab.WarningBox.IsNormal == true and Library.Scheme.OutlineColor or Color3.fromRGB(169, 0, 0)
            end
        end

        function Tab:RefreshSides()
            local Offset = WarningBoxHolder.Visible and WarningBox.Size.Y.Offset + 8 or 0
            for _, Side in Tab.Sides do
                Side.Position = UDim2.new(Side.Position.X.Scale, 0, 0, Offset)
                Side.Size = UDim2.new(0.5, -3, 1, -Offset)
            end
        end

        function Tab:Resize(ResizeWarningBox: boolean?)
            if ResizeWarningBox then
                local MaximumSize = math.floor(TabContainer.AbsoluteSize.Y / 3.25)
                local _, YText = Library:GetTextBounds(
                    WarningText.Text,
                    Library.Scheme.Font,
                    WarningText.TextSize,
                    WarningText.AbsoluteSize.X
                )

                local YBox = 24 + YText
                if Tab.WarningBox.LockSize == true and YBox >= MaximumSize then
                    WarningBoxScrollingFrame.CanvasSize = UDim2.fromOffset(0, YBox)
                    YBox = MaximumSize
                else
                    WarningBoxScrollingFrame.CanvasSize = UDim2.fromOffset(0, 0)
                end

                WarningText.Size = UDim2.new(1, -4, 0, YText)
                WarningBox.Size = UDim2.new(1, -5, 0, YBox + 4)
            end

            Tab:RefreshSides()
        end

        local function AddTabbox(self, Info)
            local ParentObj = self

            local BoxHolder = New("Frame", {
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 0),
                Parent = if ParentObj.Type == "Groupbox" then ParentObj.Container else (Info.Side == 1 and TabLeft or TabRight),
            })
            New("UIListLayout", {
                Padding = UDim.new(0, 6),
                Parent = BoxHolder,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 4),
                PaddingTop = UDim.new(0, 4),
                Parent = BoxHolder,
            })

            local TabboxHolder
            local TabboxButtons

            do
                TabboxHolder = New("Frame", {
                    BackgroundColor3 = "BackgroundColor",
                    Size = UDim2.fromScale(1, 0),
                    Parent = BoxHolder,
                })
                table.insert(
                    Library.Corners,
                    New("UICorner", {
                        CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                        Parent = TabboxHolder,
                    })
                )
                Library:AddOutline(TabboxHolder)

                TabboxButtons = New("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 34),
                    Parent = TabboxHolder,
                })
                New("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Parent = TabboxButtons,
                })
            end

            local TotalTabs = 0
            local FirstTab
            local LastTab

            local Tabbox = {
                Connections = {},
                Destroyed = false,

                ActiveTab = nil,

                BoxHolder = BoxHolder,
                Holder = TabboxHolder,
                Tabs = {}
            }

            function Tabbox:UpdateCorners()
                for _, Tab in Tabbox.Tabs do
                    Tab:UpdateCorners()
                end
            end

            function Tabbox:AddTab(Name, IconName)
                TotalTabs = TotalTabs + 1
                local TabIndex = TotalTabs

                LastTab = TabIndex
                if not FirstTab then
                    FirstTab = TabIndex
                end

                local IsNameEmpty = Name == nil or Trim(tostring(Name)) == ""
                local TabStoringIndex = IsNameEmpty and tostring(TabIndex) or Name

                local Button = New("TextButton", {
                    BackgroundColor3 = "MainColor",
                    BackgroundTransparency = 0,
                    Size = UDim2.fromOffset(0, 34),
                    Text = "",
                    Parent = TabboxButtons,
                })

                local ButtonCorner = New("UICorner", {
                    TopLeftRadius = UDim.new(0, WindowInfo.CornerRadius),
                    TopRightRadius = UDim.new(0, WindowInfo.CornerRadius),
                    BottomRightRadius = UDim.new(0, 0),
                    BottomLeftRadius = UDim.new(0, 0),
                    Parent = Button,
                }); table.insert(Library.SpecificCorners, ButtonCorner)

                local ButtonContent = New("Frame", {
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = 1,
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromOffset(0, 16),
                    Parent = Button,
                })
                New("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDim.new(0, 8),
                    Parent = ButtonContent,
                })

                local ButtonIcon                
                local BoxIcon = Library:GetCustomIcon(IconName)
                if BoxIcon then
                    ButtonIcon = New("ImageLabel", {
                        Image = BoxIcon.Url,
                        ImageColor3 = BoxIcon.Custom and "WhiteColor" or "AccentColor",
                        ImageRectOffset = BoxIcon.ImageRectOffset,
                        ImageRectSize = BoxIcon.ImageRectSize,
                        ImageTransparency = 0.5,
                        Size = IsNameEmpty and UDim2.fromOffset(16, 16) or UDim2.fromOffset(18, 18),
                        Parent = ButtonContent,
                    })
                end

                local ButtonLabel
                if not IsNameEmpty then
                    ButtonLabel = New("TextLabel", {
                        AutomaticSize = Enum.AutomaticSize.X,
                        BackgroundTransparency = 1,
                        Size = UDim2.fromOffset(0, 16),
                        Text = Name,
                        TextSize = 15,
                        TextTransparency = 0.5,
                        Parent = ButtonContent,
                    })
                end

                local Line = Library:MakeLine(Button, {
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 1),
                    Size = UDim2.new(1, 0, 0, 1),
                })

                local Container = New("Frame", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(0, 35),
                    Size = UDim2.new(1, 0, 1, -35),
                    Visible = false,
                    Parent = TabboxHolder,
                })
                local List = New("UIListLayout", {
                    Padding = UDim.new(0, 8),
                    Parent = Container,
                })
                New("UIPadding", {
                    PaddingBottom = UDim.new(0, 7),
                    PaddingLeft = UDim.new(0, 7),
                    PaddingRight = UDim.new(0, 7),
                    PaddingTop = UDim.new(0, 7),
                    Parent = Container,
                })

                local Tab = {
                    Connections = {},
                    Destroyed = false,

                    ButtonHolder = Button,
                    Container = Container,
                    ButtonCorner = ButtonCorner,

                    Tab = Tab,
                    Elements = {},
                    DependencyBoxes = {},
                }

                function Tab:Show()
                    if Tabbox.ActiveTab then
                        Tabbox.ActiveTab:Hide()
                    end

                    Button.BackgroundTransparency = 1

                    if ButtonLabel then
                        ButtonLabel.TextTransparency = 0
                    end
                    if ButtonIcon then
                        ButtonIcon.ImageTransparency = 0
                    end

                    Line.Visible = false

                    Container.Visible = true

                    Tabbox.ActiveTab = Tab
                    Tab:Resize()
                end

                function Tab:Hide()
                    Button.BackgroundTransparency = 0

                    if ButtonLabel then
                        ButtonLabel.TextTransparency = 0.5
                    end
                    if ButtonIcon then
                        ButtonIcon.ImageTransparency = 0.5
                    end
                    Line.Visible = true
                    Container.Visible = false

                    Tabbox.ActiveTab = nil
                end

                function Tab:Resize()
                    if Tabbox.ActiveTab ~= Tab then
                        return
                    end

                    TabboxHolder.Size = UDim2.new(1, 0, 0, (List.AbsoluteContentSize.Y / Library.DPIScale) + 49)
                    if ParentObj.Type == "Groupbox" then
                        ParentObj:Resize()
                    end
                end

                function Tab:UpdateCorners()
                    local Radius = WindowInfo.CornerRadius

                    ButtonCorner.TopLeftRadius = UDim.new(0, TabIndex == FirstTab and Radius or 0)
                    ButtonCorner.TopRightRadius = UDim.new(0, TabIndex == LastTab and Radius or 0)
                end

                function Tab:Destroy()
                    Tab.Destroyed = true

                    if Tab.Connections then
                        for _, Connection in Tab.Connections do
                            Connection:Disconnect()
                        end
                    end

                    for _, Element in Tab.Elements do
                        if Element.Destroy then
                            Element:Destroy()
                        end
                    end

                    for _, SubDepbox in Tab.DependencyBoxes do
                        if SubDepbox.Destroy then
                            SubDepbox:Destroy()
                        end
                    end

                    if Container then
                        Container:Destroy()
                    end

                    if Button then
                        Button:Destroy()
                    end
                end

                --// Execution \\--
                if not Tabbox.ActiveTab then
                    Tab:Show()
                end

                Button.MouseButton1Click:Connect(Tab.Show)

                setmetatable(Tab, BaseGroupbox)

                Tabbox.Tabs[TabStoringIndex] = Tab
                Tabbox:UpdateCorners()

                return Tab, TabStoringIndex
            end

            function Tabbox:Destroy()
                Tabbox.Destroyed = true

                if Tabbox.Connections then
                    for _, Connection in Tabbox.Connections do
                        Connection:Disconnect()
                    end
                end

                for _, Tab in Tabbox.Tabs do
                    if Tab.Destroy then
                        Tab:Destroy()
                    end
                end

                if TabboxHolder then
                    TabboxHolder:Destroy()
                end

                if BoxHolder then
                    BoxHolder:Destroy()
                end
            end

            if Info.Name then
                Tab.Tabboxes[Info.Name] = Tabbox
            else
                table.insert(Tab.Tabboxes, Tabbox)
            end

            return Tabbox
        end

        Tab.AddTabbox = AddTabbox

        function Tab:AddLeftTabbox(Name)
            return Tab:AddTabbox({ Side = 1, Name = Name })
        end

        function Tab:AddRightTabbox(Name)
            return Tab:AddTabbox({ Side = 2, Name = Name })
        end

        function Tab:AddGroupbox(Info)
            local BoxHolder = New("Frame", {
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 0),
                Parent = Info.Side == 1 and TabLeft or TabRight,
            })
            New("UIListLayout", {
                Padding = UDim.new(0, 6),
                Parent = BoxHolder,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 4),
                PaddingTop = UDim.new(0, 4),
                Parent = BoxHolder,
            })

            local GroupboxHolder
            local GroupboxLabel

            local GroupboxContainer
            local GroupboxList

            local GroupboxCollapseArrow
            local GroupboxLine

            do
                GroupboxHolder = New("Frame", {
                    BackgroundColor3 = "BackgroundColor",
                    Size = UDim2.fromScale(1, 0),
                    Parent = BoxHolder,
                })
                table.insert(
                    Library.Corners,
                    New("UICorner", {
                        CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                        Parent = GroupboxHolder,
                    })
                )
                Library:AddOutline(GroupboxHolder)

                GroupboxLine = Library:MakeLine(GroupboxHolder, {
                    Position = UDim2.fromOffset(0, 34),
                    Size = UDim2.new(1, 0, 0, 1),
                })

                local BoxIcon = Library:GetCustomIcon(Info.IconName)
                if BoxIcon then
                    New("ImageLabel", {
                        Image = BoxIcon.Url,
                        ImageColor3 = BoxIcon.Custom and "WhiteColor" or "AccentColor",
                        ImageRectOffset = BoxIcon.ImageRectOffset,
                        ImageRectSize = BoxIcon.ImageRectSize,
                        Position = UDim2.fromOffset(6, 6),
                        Size = UDim2.fromOffset(22, 22),
                        Parent = GroupboxHolder,
                    })
                end

                GroupboxLabel = New("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(BoxIcon and 24 or 0, 0),
                    Size = UDim2.new(1, 0, 0, 34),
                    Text = Info.Name,
                    TextSize = 15,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = GroupboxHolder,
                })
                New("UIPadding", {
                    PaddingLeft = UDim.new(0, 12),
                    PaddingRight = UDim.new(0, 12),
                    Parent = GroupboxLabel,
                })

                if Info.DisableCollapsing ~= true then
                    GroupboxCollapseArrow = New("ImageButton", {
                        Image = ArrowIcon and ArrowIcon.Url or "",
                        ImageColor3 = "WhiteColor",
                        ImageRectOffset = ArrowIcon and ArrowIcon.ImageRectOffset or Vector2.zero,
                        ImageRectSize = ArrowIcon and ArrowIcon.ImageRectSize or Vector2.zero,
                        BackgroundTransparency = 1,
                        Rotation = 180,
                        Position = UDim2.new(1, -(22 + 6), 0, 6),
                        Size = UDim2.fromOffset(22, 22),
                        Parent = GroupboxHolder,
                    })
                end

                GroupboxContainer = New("Frame", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(0, 35),
                    Size = UDim2.new(1, 0, 1, -35),
                    Parent = GroupboxHolder,
                })

                GroupboxList = New("UIListLayout", {
                    Padding = UDim.new(0, 8),
                    Parent = GroupboxContainer,
                })
                New("UIPadding", {
                    PaddingBottom = UDim.new(0, 7),
                    PaddingLeft = UDim.new(0, 7),
                    PaddingRight = UDim.new(0, 7),
                    PaddingTop = UDim.new(0, 7),
                    Parent = GroupboxContainer,
                })
            end

            local Groupbox = {
                Type = "Groupbox",

                Connections = {},
                Destroyed = false,

                Visible = true,
                Collapsed = false,

                BoxHolder = BoxHolder,
                Holder = GroupboxHolder,
                Container = GroupboxContainer,

                Tab = Tab,
                DependencyBoxes = {},
                Elements = {}
            }

            local ResizeTween
            local CollapseArrowTween

            function Groupbox:Resize()
                if ResizeTween then
                    StopTween(ResizeTween, true)
                    ResizeTween = nil
                end

                local TargetSize = UDim2.new(1, 0, 0, if Groupbox.Collapsed then 34 else (GroupboxList.AbsoluteContentSize.Y / Library.DPIScale) + 49)

                GroupboxLine.Visible = not Groupbox.Collapsed
                if Library.Animations and Library.Animations.Groupbox then
                    local TweenInfo = Library.GroupboxTweenInfo or TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    local Tween = TweenService:Create(GroupboxHolder, TweenInfo, { Size = TargetSize })
                    ResizeTween = Tween

                    local Connection; Connection = Library:GiveSignal(Tween.Completed:Once(function()
                        if Connection then
                            Connection:Disconnect()
                        end

                        if ResizeTween == Tween then
                            StopTween(ResizeTween, true)
                            ResizeTween = nil
                        end
                    end))

                    Tween:Play()
                else
                    GroupboxHolder.Size = TargetSize
                end
            end

            function Groupbox:SetCollapsed(Collapsed: boolean)
                if Info.DisableCollapsing == true then return end
                Groupbox.Collapsed = Collapsed

                if CollapseArrowTween then
                    StopTween(CollapseArrowTween, true)
                    CollapseArrowTween = nil
                end

                local TargetRotation = if Collapsed then 0 else 180

                GroupboxContainer.Visible = not Collapsed
                if Library.Animations and Library.Animations.Groupbox then
                    local TweenInfo = Library.GroupboxTweenInfo or TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                    local Tween = TweenService:Create(GroupboxCollapseArrow, TweenInfo, { Rotation = TargetRotation })
                    CollapseArrowTween = Tween

                    local Connection; Connection = Library:GiveSignal(Tween.Completed:Connect(function()
                        if Connection then
                            Connection:Disconnect()
                        end

                        if CollapseArrowTween == Tween then
                            StopTween(CollapseArrowTween, true)
                            CollapseArrowTween = nil
                        end
                    end))

                    Tween:Play()
                else
                    GroupboxCollapseArrow.Rotation = TargetRotation
                end

                Groupbox:Resize()
            end

            function Groupbox:ToggleCollapsed()
                if Info.DisableCollapsing == true then return end
                Groupbox:SetCollapsed(not Groupbox.Collapsed)
            end

            function Groupbox:Destroy()
                Groupbox.Destroyed = true

                if ResizeTween then
                    StopTween(ResizeTween, true)
                    ResizeTween = nil
                end

                if CollapseArrowTween then
                    StopTween(CollapseArrowTween, true)
                    CollapseArrowTween = nil
                end

                if Groupbox.Connections then
                    for _, Connection in Groupbox.Connections do
                        Connection:Disconnect()
                    end
                end

                for _, Element in Groupbox.Elements do
                    if Element.Destroy then
                        Element:Destroy()
                    end
                end
                table.clear(Groupbox.Elements)

                for _, SubDepbox in Groupbox.DependencyBoxes do
                    if SubDepbox.Destroy then
                        SubDepbox:Destroy()
                    end
                end
                table.clear(Groupbox.DependencyBoxes)

                if GroupboxHolder then 
                    GroupboxHolder:Destroy() 
                end

                if BoxHolder then
                    BoxHolder:Destroy()
                end
            end

            function Groupbox:SetVisible(Visible: boolean)
                Groupbox.Visible = Visible
                BoxHolder.Visible = Visible

                if Visible == true and Library.Searching then
                    Library:UpdateSearch(Library.SearchText)
                end
            end

            function Groupbox:Show()
                Groupbox:SetVisible(true) 
            end

            function Groupbox:Hide()
                Groupbox:SetVisible(false) 
            end

            if Info.DisableCollapsing ~= true then
                GroupboxCollapseArrow.MouseButton1Click:Connect(function()
                    Groupbox:ToggleCollapsed()
                end)
            end

            Groupbox.AddTabbox = AddTabbox
            setmetatable(Groupbox, BaseGroupbox)

            Groupbox:Resize()
            Tab.Groupboxes[Info.Name] = Groupbox

            if Info.Visible == false then
                Groupbox:Hide()
            end

            if Info.DisableCollapsing ~= true and Info.Collapsed == true then
                Groupbox:SetCollapsed(true)
            end

            return Groupbox
        end

        function Tab:AddLeftGroupbox(Name, IconName, Visible, Collapsed, DisableCollapsing)
            return Tab:AddGroupbox({ Side = 1, Name = Name, IconName = IconName, Visible = Visible, Collapsed = Collapsed, DisableCollapsing = DisableCollapsing })
        end

        function Tab:AddRightGroupbox(Name, IconName, Visible, Collapsed, DisableCollapsing)
            return Tab:AddGroupbox({ Side = 2, Name = Name, IconName = IconName, Visible = Visible, Collapsed = Collapsed, DisableCollapsing = DisableCollapsing })
        end

        function Tab:Hover(Hovering)
            if Library.ActiveTab == Tab then
                return
            end

            TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = Hovering and 0.25 or 0.5,
            }):Play()
            if TabIcon then
                TweenService:Create(TabIcon, Library.TweenInfo, {
                    ImageTransparency = Hovering and 0.25 or 0.5,
                }):Play()
            end
        end

        function Tab:Show()
            if Library.ActiveTab == Tab then
                return
            end

            if Library.ActiveTab then
                Library.ActiveTab:Hide()
            end

            TweenService:Create(TabButton, Library.TweenInfo, {
                BackgroundTransparency = 0,
            }):Play()
            TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = 0,
            }):Play()
            if TabIcon then
                TweenService:Create(TabIcon, Library.TweenInfo, {
                    ImageTransparency = 0,
                }):Play()
            end

            if Description then
                Window:ShowTabInfo(Name, Description)
            end

            Library:PlayTabAnimation(TabCanvas, true)
            Tab:RefreshSides()

            Library.ActiveTab = Tab

            if Library.Searching then
                Library:UpdateSearch(Library.SearchText)
            end
        end

        function Tab:Hide()
            TweenService:Create(TabButton, Library.TweenInfo, {
                BackgroundTransparency = 1,
            }):Play()

            TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = 0.5,
            }):Play()

            if TabIcon then
                TweenService:Create(TabIcon, Library.TweenInfo, {
                    ImageTransparency = 0.5,
                }):Play()
            end

            Library:PlayTabAnimation(TabCanvas, false)
            Window:HideTabInfo()

            Library.ActiveTab = nil
        end

        function Tab:SetVisible(Visible: boolean)
            TabButton.Visible = Visible

            if not Visible and Library.ActiveTab == Tab then
                Tab:Hide()
            end
        end

        function Tab:SetOrder(Order: number)
            TabButton.LayoutOrder = Order
        end

        function Tab:Destroy()
            Tab.Destroyed = true

            if Tab.Connections then
                for _, Connection in Tab.Connections do
                    Connection:Disconnect()
                end
            end

            for _, Groupbox in Tab.Groupboxes do
                if Groupbox.Destroy then
                    Groupbox:Destroy()
                end
            end
            table.clear(Tab.Groupboxes)

            for _, Tabbox in Tab.Tabboxes do
                if Tabbox.Destroy then
                    Tabbox:Destroy()
                end
            end
            table.clear(Tab.Tabboxes)

            for _, DepGroupbox in Tab.DependencyGroupboxes do
                if DepGroupbox.Destroy then
                    DepGroupbox:Destroy()
                end
            end

            if TabCanvas then
                TabCanvas:Destroy()
            elseif TabContainer then
                TabContainer:Destroy()
            end

            if TabButton then
                for Index, Entry in Library.TabButtons do
                    if typeof(Entry) == "table" and Entry.Button == TabButton then
                        table.remove(Library.TabButtons, Index)
                        break
                    end
                end
                
                TabButton:Destroy()
            end
            
            Library.Tabs[Name] = nil
        end

        --// Execution \\--
        if not Library.ActiveTab then
            Tab:Show()
        end

        TabButton.MouseEnter:Connect(function()
            Tab:Hover(true)
        end)
        TabButton.MouseLeave:Connect(function()
            Tab:Hover(false)
        end)
        TabButton.MouseButton1Click:Connect(Tab.Show)

        Library.Tabs[Name] = Tab

        return Tab
    end

    function Window:AddKeyTab(...)
        local Name = nil
        local Icon = nil
        local Description = nil

        if select("#", ...) == 1 and typeof(...) == "table" then
            local Info = select(1, ...)
            Name = Info.Name or "Tab"
            Icon = Info.Icon
            Description = Info.Description
        else
            Name = select(1, ...) or "Tab"
            Icon = select(2, ...)
            Description = select(3, ...)
        end

        Icon = Icon or "key"

        local TabButton: TextButton
        local TabLabel
        local TabIcon

        local TabCanvas
        local TabContainer

        Icon = if Icon == "key" then KeyIcon else Library:GetCustomIcon(Icon)
        do
            TabButton = New("TextButton", {
                BackgroundColor3 = "MainColor",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 40),
                Text = "",
                Parent = Tabs,
            })
            local ButtonPadding = New("UIPadding", {
                PaddingBottom = UDim.new(0, IsCompact and 6 or 11),
                PaddingLeft = UDim.new(0, IsCompact and 6 or 12),
                PaddingRight = UDim.new(0, IsCompact and 6 or 12),
                PaddingTop = UDim.new(0, IsCompact and 6 or 11),
                Parent = TabButton,
            })

            TabLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(30, 0),
                Size = UDim2.new(1, -30, 1, 0),
                Text = Name,
                TextSize = 16,
                TextTransparency = 0.5,
                TextXAlignment = Enum.TextXAlignment.Left,
                Visible = not IsCompact,
                Parent = TabButton,
            })

            if Icon then
                TabIcon = New("ImageLabel", {
                    Image = Icon.Url,
                    ImageColor3 = Icon.Custom and "WhiteColor" or "AccentColor",
                    ImageRectOffset = Icon.ImageRectOffset,
                    ImageRectSize = Icon.ImageRectSize,
                    ImageTransparency = 0.5,
                    Size = UDim2.fromScale(1, 1),
                    SizeConstraint = IsCompact and Enum.SizeConstraint.RelativeXY or Enum.SizeConstraint.RelativeYY,
                    Parent = TabButton,
                })
            end

            table.insert(Library.TabButtons, {
                Label = TabLabel,
                Padding = ButtonPadding,
                Icon = TabIcon,
            })

            --// Tab Canvas \\--
            TabCanvas = New("CanvasGroup", {
                BackgroundTransparency = 1,
                ClipsDescendants = true,
                GroupTransparency = 0,
                Size = UDim2.fromScale(1, 1),
                Visible = false,
                Parent = Container,
            })

            --// Tab Container \\--
            TabContainer = New("ScrollingFrame", {
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                CanvasSize = UDim2.fromScale(0, 0),
                ScrollBarThickness = 0,
                Position = UDim2.fromScale(0, 0),
                Size = UDim2.fromScale(1, 1),
                Visible = true,
                Parent = TabCanvas,
            })
            New("UIListLayout", {
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Padding = UDim.new(0, 8),
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Parent = TabContainer,
            })
            New("UIPadding", {
                PaddingLeft = UDim.new(0, 1),
                PaddingRight = UDim.new(0, 1),
                Parent = TabContainer,
            })
        end

        --// Tab Table \\--
        local Tab = {
            Description = Description,
            IsKeyTab = true,

            Elements = {},

            Window = Window,
            Canvas = TabCanvas
        }

        function Tab:AddKeyBox(Callback)
            assert(typeof(Callback) == "function", "Callback must be a function")

            local Holder = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(0.75, 0, 0, 21),
                Parent = TabContainer,
            })

            local Box = New("TextBox", {
                BackgroundColor3 = "MainColor",
                PlaceholderText = "按键",
                Size = UDim2.new(1, -71, 1, 0),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Holder,
            })
            New("UIPadding", {
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 8),
                Parent = Box,
            })
            New("UIStroke", {
                Color = "OutlineColor",
                Parent = Box,
            })
            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                    Parent = Box,
                })
            )

            local Button = New("TextButton", {
                AnchorPoint = Vector2.new(1, 0),
                BackgroundColor3 = "MainColor",
                Position = UDim2.fromScale(1, 0),
                Size = UDim2.new(0, 63, 1, 0),
                Text = "执行",
                TextSize = 14,
                Parent = Holder,
            })
            New("UIStroke", {
                Color = "OutlineColor",
                Parent = Button,
            })
            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                    Parent = Button,
                })
            )

            Button.InputBegan:Connect(function(Input)
                if not IsClickInput(Input) then
                    return
                end

                if not Library:MouseIsOverFrame(Button, Input.Position) then
                    return
                end

                Callback(Box.Text)
            end)
        end
        
        function Tab:Destroy()
            if TabCanvas then
                TabCanvas:Destroy()
            elseif TabContainer then
                TabContainer:Destroy()
            end

            if TabButton then
                for Index, Entry in Library.TabButtons do
                    if typeof(Entry) == "table" and Entry.Button == TabButton then
                        table.remove(Library.TabButtons, Index)
                        break
                    end
                end
                
                TabButton:Destroy()
            end
            
            Library.Tabs[Name] = nil
        end

        function Tab:RefreshSides() end
        function Tab:Resize() end
        function Tab:UpdateCorners() end

        function Tab:Hover(Hovering)
            if Library.ActiveTab == Tab then
                return
            end

            TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = Hovering and 0.25 or 0.5,
            }):Play()
            if TabIcon then
                TweenService:Create(TabIcon, Library.TweenInfo, {
                    ImageTransparency = Hovering and 0.25 or 0.5,
                }):Play()
            end
        end

        function Tab:Show()
            if Library.ActiveTab == Tab then
                return
            end

            if Library.ActiveTab then
                Library.ActiveTab:Hide()
            end

            TweenService:Create(TabButton, Library.TweenInfo, {
                BackgroundTransparency = 0,
            }):Play()

            TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = 0,
            }):Play()

            if TabIcon then
                TweenService:Create(TabIcon, Library.TweenInfo, {
                    ImageTransparency = 0,
                }):Play()
            end

            Library:PlayTabAnimation(TabCanvas, true)

            if Description then
                Window:ShowTabInfo(Name, Description)
            end

            Tab:RefreshSides()

            Library.ActiveTab = Tab

            if Library.Searching then
                Library:UpdateSearch(Library.SearchText)
            end
        end

        function Tab:Hide()
            TweenService:Create(TabButton, Library.TweenInfo, {
                BackgroundTransparency = 1,
            }):Play()

            TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = 0.5,
            }):Play()

            if TabIcon then
                TweenService:Create(TabIcon, Library.TweenInfo, {
                    ImageTransparency = 0.5,
                }):Play()
            end

            Library:PlayTabAnimation(TabCanvas, false)
            Window:HideTabInfo()

            Library.ActiveTab = nil
        end

        function Tab:SetVisible(Visible: boolean)
            TabButton.Visible = Visible

            if not Visible and Library.ActiveTab == Tab then
                Tab:Hide()
            end
        end

        --// Execution \\--
        if not Library.ActiveTab then
            Tab:Show()
        end

        TabButton.MouseEnter:Connect(function()
            Tab:Hover(true)
        end)
        TabButton.MouseLeave:Connect(function()
            Tab:Hover(false)
        end)
        TabButton.MouseButton1Click:Connect(Tab.Show)

        Tab.Container = TabContainer
        setmetatable(Tab, BaseGroupbox)

        Library.Tabs[Name] = Tab

        return Tab
    end

    function Window:AddDialog(Idx, Info)
        Info = Library:Validate(Info, Templates.Dialog)

        local DialogFrame
        local DialogOverlay
        local DialogContainer
        local ButtonsHolder
        local FooterButtonsList = {}

        DialogOverlay = New("TextButton", {
            AutoButtonColor = false,
            BackgroundColor3 = "DarkColor",
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Text = "",
            Active = false,
            ZIndex = 9000,
            Visible = true,
            Parent = MainFrame,
        })
        TweenService:Create(DialogOverlay, Library.TweenInfo, {
            BackgroundTransparency = 0.5,
        }):Play()

        DialogFrame = New("TextButton", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = "BackgroundColor",
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(300, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 9001,
            Parent = DialogOverlay,
        })
        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                Parent = DialogFrame,
            })
        )
        Library:AddOutline(DialogFrame)

        local InnerContainer = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            ZIndex = 9002,
            Parent = DialogFrame,
        })
        local DialogScale = New("UIScale", {
            Scale = 0.95,
            Parent = DialogFrame,
        })
        TweenService:Create(DialogScale, Library.TweenInfo, {
            Scale = 1
        }):Play()
        local _InnerPadding = New("UIPadding", {
            PaddingBottom = UDim.new(0, 15),
            PaddingLeft = UDim.new(0, 15),
            PaddingRight = UDim.new(0, 15),
            PaddingTop = UDim.new(0, 15),
            Parent = InnerContainer,
        })
        local _InnerLayout = New("UIListLayout", {
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = InnerContainer,
        })

        local HeaderContainer = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            LayoutOrder = 1,
            ZIndex = 9002,
            Parent = InnerContainer,
        })
        New("UIListLayout", {
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = HeaderContainer,
        })
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 5),
            Parent = HeaderContainer,
        })

        local TitleRow = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20),
            AutomaticSize = Enum.AutomaticSize.Y,
            LayoutOrder = 1,
            ZIndex = 9002,
            Parent = HeaderContainer,
        })
        New("UIListLayout", {
            Padding = UDim.new(0, 6),
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = TitleRow,
        })

        if Info.Icon then
            local ParsedIcon = Library:GetCustomIcon(Info.Icon)
            if ParsedIcon then
                local _IconImg = New("ImageLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.fromOffset(16, 16),
                    Image = ParsedIcon.Url,
                    ImageColor3 = Info.TitleColor or "FontColor",
                    ImageRectOffset = ParsedIcon.ImageRectOffset,
                    ImageRectSize = ParsedIcon.ImageRectSize,
                    LayoutOrder = 1,
                    ZIndex = 9002,
                    Parent = TitleRow,
                })
            end
        end

        local TitleLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 18),
            AutomaticSize = Enum.AutomaticSize.Y,
            Text = Info.Title,
            TextSize = 18,
            TextColor3 = Info.TitleColor or "FontColor",
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = 2,
            ZIndex = 9002,
            Parent = TitleRow,
        })

        local DescriptionLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 14),
            AutomaticSize = Enum.AutomaticSize.Y,
            Text = Info.Description,
            TextSize = 14,
            TextTransparency = Info.DescriptionColor and 0 or 0.2,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextColor3 = Info.DescriptionColor or "FontColor",
            TextWrapped = true,
            LayoutOrder = 2,
            ZIndex = 9002,
            Parent = HeaderContainer,
        })

        DialogContainer = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            LayoutOrder = 4,
            ZIndex = 9002,
            Parent = InnerContainer,
        })
        local _DialogContainerLayout = New("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = DialogContainer,
        })
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 5),
            Parent = DialogContainer,
        })
        
        local _Sep2 = New("Frame", {
            BackgroundColor3 = "OutlineColor",
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 1),
            LayoutOrder = 5,
            ZIndex = 9002,
            Parent = InnerContainer,
        })

        ButtonsHolder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            LayoutOrder = 6,
            ZIndex = 9002,
            Parent = InnerContainer,
        })
        New("UIListLayout", {
            Padding = UDim.new(0, 8),
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Wraps = true,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = ButtonsHolder,
        })
        New("UIPadding", {
            PaddingTop = UDim.new(0, 5),
            Parent = ButtonsHolder,
        })

        local Dialog = {
            Destroyed = false,
            Elements = {},
            Container = DialogContainer,
        }

        function Dialog:Resize()
            local MaxWidth = MainFrame.AbsoluteSize.X * 0.75
            local MinWidth = 400

            local TotalButtonWidth = 0
            local ButtonCount = 0
            local HasButtons = false

            for _, BtnWrap in FooterButtonsList do
                HasButtons = true
                ButtonCount = ButtonCount + 1
                TotalButtonWidth = TotalButtonWidth + BtnWrap.Container.Size.X.Offset
            end

            local TargetWidth = MinWidth
            if HasButtons then
                local RequiredWidth = TotalButtonWidth + ((ButtonCount - 1) * 8) + 30
                TargetWidth = math.max(MinWidth, math.min(RequiredWidth, MaxWidth))
            end

            DialogFrame.Size = UDim2.fromOffset(TargetWidth, 0)

            local _DescX, DescY = Library:GetTextBounds(DescriptionLabel.Text, Library.Scheme.Font, 14, TargetWidth - 30)
            DescriptionLabel.Size = UDim2.new(1, 0, 0, DescY)

            local HasElements = false
            for _, v in DialogContainer:GetChildren() do
                if not v:IsA("UIListLayout") and not v:IsA("UIPadding") then
                    HasElements = true
                    break
                end
            end
            DialogContainer.Visible = HasElements

            ButtonsHolder.Visible = HasButtons
            _Sep2.Visible = HasButtons
        end

        function Dialog:SetTitle(Title)
            TitleLabel.Text = Title
            Dialog:Resize()
        end

        function Dialog:SetDescription(Description)
            DescriptionLabel.Text = Description
            Dialog:Resize()
        end

        function Dialog:Dismiss()
            if Dialog.Destroyed then
                return
            end

            Dialog.Destroyed = true

            if Library.ActiveDialog == Dialog then
                Library.ActiveDialog = nil
            end

            for Index = #Dialog.Elements, 1, -1 do
                local Element = Dialog.Elements[Index]
                if Element and Element.Destroy then
                    Element:Destroy()
                end
            end
            table.clear(Dialog.Elements)

            local CloseTween = TweenService:Create(DialogScale, Library.TweenInfo, { Scale = 0.95 })
            TweenService:Create(DialogOverlay, Library.TweenInfo, { BackgroundTransparency = 1 }):Play()
            CloseTween:Play()
            
            task.delay(Library.TweenInfo.Time, function()
                DialogOverlay:Destroy()
            end)
            Library.Dialogues[Idx] = nil
        end

        DialogOverlay.MouseButton1Click:Connect(function()
            if Info.OutsideClickDismiss then
                Dialog:Dismiss()
            end
        end)

        function Dialog:RemoveFooterButton(ButtonIdx)
            if FooterButtonsList[ButtonIdx] then
                FooterButtonsList[ButtonIdx].Container:Destroy()
                FooterButtonsList[ButtonIdx] = nil
            end
        end

        function Dialog:SetButtonDisabled(ButtonIdx, Disabled)
            if FooterButtonsList[ButtonIdx] and type(FooterButtonsList[ButtonIdx].SetDisabled) == "function" then
                FooterButtonsList[ButtonIdx]:SetDisabled(Disabled)
            end
        end

        function Dialog:SetButtonOrder(ButtonIdx, Order)
            if FooterButtonsList[ButtonIdx] and FooterButtonsList[ButtonIdx].Container then
                FooterButtonsList[ButtonIdx].Container.LayoutOrder = Order
            end
        end

        function Dialog:AddFooterButton(ButtonIdx, ButtonInfo)
            Dialog:RemoveFooterButton(ButtonIdx)

            local WaitTime = ButtonInfo.WaitTime or 0

            local ButtonContainer = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromOffset(0, 26),
                LayoutOrder = ButtonInfo.Order or 0,
                ZIndex = 9002,
                Parent = ButtonsHolder,
            })
            
            local BtnColor = "MainColor"
            local BtnOutline = "OutlineColor"
            local Variant = ButtonInfo.Variant or "Primary"
            
            if Variant == "Primary" then
                BtnColor = "FontColor"
                BtnOutline = "FontColor"
            elseif Variant == "Secondary" then
                BtnColor = "MainColor"
                BtnOutline = "OutlineColor"
            elseif Variant == "Destructive" then
                BtnColor = "DestructiveColor"
                BtnOutline = "DestructiveColor"
            elseif Variant == "Ghost" then
                BtnColor = "BackgroundColor"
                BtnOutline = "BackgroundColor"
            end

            local TextBtn = New("TextButton", {
                BackgroundColor3 = BtnColor,
                BorderColor3 = BtnOutline,
                BackgroundTransparency = WaitTime > 0 and 0.5 or 0,
                Size = UDim2.fromOffset(0, 26),
                Text = "",
                AutoButtonColor = false,
                ZIndex = 9002,
                Parent = ButtonContainer,
            })
            Library:AddOutline(TextBtn)
            table.insert(
                Library.Corners,
                New("UICorner", { 
                    CornerRadius = UDim.new(0, Library.CornerRadius), 
                    Parent = TextBtn 
                })
            )

            local _BtnPadding = New("UIPadding", {
                PaddingLeft = UDim.new(0, 15),
                PaddingRight = UDim.new(0, 15),
                Parent = TextBtn,
            })

            local TextColor = Library.Scheme.FontColor
            if Variant == "Primary" then
                TextColor = Library.Scheme.BackgroundColor
            elseif Variant == "Destructive" then
                TextColor = Color3.new(1, 1, 1)
            end
            
            local BtnLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Text = ButtonInfo.Title or ButtonIdx,
                TextColor3 = TextColor,
                TextTransparency = WaitTime > 0 and 0.5 or 0,
                TextSize = 14,
                ZIndex = 9002,
                Parent = TextBtn,
            })
            
            local LabelX, _ = Library:GetTextBounds(BtnLabel.Text, Library.Scheme.Font, 14, 250)
            ButtonContainer.Size = UDim2.fromOffset(LabelX + 30, 26)
            TextBtn.Size = UDim2.fromOffset(LabelX + 30, 26)

            local ProgressBar
            if WaitTime > 0 then
                ProgressBar = New("Frame", {
                    BackgroundColor3 = "AccentColor",
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 1, -2),
                    Size = UDim2.new(0, 0, 0, 2),
                    ZIndex = 2,
                    Parent = TextBtn,
                })
                table.insert(
                    Library.Corners,
                    New("UICorner", { 
                        CornerRadius = UDim.new(0, Library.CornerRadius), 
                        Parent = ProgressBar 
                    })
                )
            end

            local IsActive = WaitTime <= 0

            local ButtonWrap = {
                Container = ButtonContainer,
                SetDisabled = function(self, Disabled)
                    IsActive = not Disabled
                    if Disabled then
                        TweenService:Create(TextBtn, Library.TweenInfo, { BackgroundTransparency = 0.5 }):Play()
                        TweenService:Create(BtnLabel, Library.TweenInfo, { TextTransparency = 0.5 }):Play()
                    else
                        TweenService:Create(TextBtn, Library.TweenInfo, { BackgroundTransparency = 0 }):Play()
                        TweenService:Create(BtnLabel, Library.TweenInfo, { TextTransparency = 0 }):Play()
                    end
                end
            }

            local ActiveColor = typeof(BtnColor) == "Color3" and BtnColor or Library.Scheme[BtnColor]
            local HoverColor = Variant == "Ghost" and Library.Scheme.MainColor or Library:GetBetterColor(ActiveColor, 10)

            TextBtn.MouseEnter:Connect(function()
                if not IsActive then return end
                TweenService:Create(TextBtn, Library.TweenInfo, {
                    BackgroundColor3 = HoverColor
                }):Play()
            end)
            TextBtn.MouseLeave:Connect(function()
                if not IsActive then return end
                TweenService:Create(TextBtn, Library.TweenInfo, {
                    BackgroundColor3 = ActiveColor
                }):Play()
            end)

            TextBtn.MouseButton1Click:Connect(function()
                if not IsActive then return end
                if ButtonInfo.Callback then
                    ButtonInfo.Callback(Dialog)
                end
                if Info.AutoDismiss then
                    Dialog:Dismiss()
                end
            end)

            if WaitTime > 0 then
                TweenService:Create(ProgressBar, TweenInfo.new(WaitTime, Enum.EasingStyle.Linear), {
                    Size = UDim2.new(1, 0, 0, 2)
                }):Play()
                
                task.delay(WaitTime, function()
                    ButtonWrap:SetDisabled(false)
                    if ProgressBar then
                        TweenService:Create(ProgressBar, Library.TweenInfo, {
                            BackgroundTransparency = 1
                        }):Play()
                    end
                end)
            end

            FooterButtonsList[ButtonIdx] = ButtonWrap
        end

        for BIdx, BInfo in Info.FooterButtons do
            if type(BIdx) == "number" and BInfo.Id then BIdx = BInfo.Id end
            Dialog:AddFooterButton(BIdx, BInfo)
        end

        setmetatable(Dialog, BaseGroupbox)
        Library.Dialogues[Idx] = Dialog

        Dialog:Resize()
        
        Library.ActiveDialog = Dialog
        return Dialog
    end

    local GuiProperties = { "BackgroundTransparency" }
    local ImageProperties = { "BackgroundTransparency", "ImageTransparency" }
    local TextProperties = { "BackgroundTransparency", "TextTransparency" }
    local StrokeProperties = { "Transparency" }

    local function FadeInstance(Desc, Properties)
        local Cache = TransparencyCache[Desc]
        if not Cache then
            Cache = {}
            TransparencyCache[Desc] = Cache
        end

        for _, Prop in Properties do
            if not Library.Toggled then
                Cache[Prop] = Desc[Prop]
            end

            if Cache[Prop] ~= nil and Cache[Prop] ~= 1 then
                TweenService:Create(Desc, Library.WindowAnimationInfo, {
                    [Prop] = Library.Toggled and Cache[Prop] or 1,
                }):Play()
            end
        end
    end

    function Window:Toggle(Value: boolean?)
        if Fading then
            return
        end

        if Library.ActiveLoading then
            if Value == true then
                return
            end

            if not Library.Toggled then
                return
            end
        end

        if typeof(Value) == "boolean" then
            Library.Toggled = Value
        else
            Library.Toggled = not Library.Toggled
        end

        if Library.Animations and Library.Animations.ToggleWindow == true then
            local FadeTime = Library.WindowAnimationInfo.Time
            Fading = true

            if Library.Toggled then
                MainFrame.Visible = true
            end

            if Library.Toggled then 
				FadeInstance(MainFrame, { "BackgroundTransparency" })
				task.wait(FadeTime / 2)
			else
				task.delay(FadeTime / 2, FadeInstance, MainFrame, { "BackgroundTransparency" })
			end

            for _, Instance in MainFrame:GetDescendants() do
                if Instance == TopBar then
                    continue
                end

                if Instance:IsA("GuiObject") then
                    local ClassName = Instance.ClassName
                    if ClassName == "ImageLabel" or ClassName == "ImageButton" then
                        FadeInstance(Instance, ImageProperties)
                    elseif ClassName == "TextLabel" or ClassName == "TextBox" or ClassName == "TextButton" then
                        FadeInstance(Instance, TextProperties)
                    else
                        FadeInstance(Instance, GuiProperties)
                    end
                elseif Instance.ClassName == "UIStroke" then
                    FadeInstance(Instance, StrokeProperties)
                end
            end

            task.delay(FadeTime, function()
                MainFrame.Visible = Library.Toggled
                Fading = false
            end)
        else
            MainFrame.Visible = Library.Toggled
        end

        if WindowInfo.UnlockMouseWhileOpen then
            ModalElement.Modal = Library.Toggled
        end

        if Library.Toggled and not Library.IsMobile then
            local OldMouseIconEnabled = UserInputService.MouseIconEnabled
            local ShowCursorBinding = Library.ShowCursorBinding
            pcall(function()
                RunService:UnbindFromRenderStep(ShowCursorBinding)
            end)
            RunService:BindToRenderStep(ShowCursorBinding, Enum.RenderPriority.Last.Value, function()
                UserInputService.MouseIconEnabled = not Library.ShowCustomCursor

                Cursor.Position = UDim2.fromOffset(Mouse.X, Mouse.Y)
                Cursor.Visible = Library.ShowCustomCursor

                if not (Library.Toggled and ScreenGui and ScreenGui.Parent) then
                    UserInputService.MouseIconEnabled = OldMouseIconEnabled
                    Cursor.Visible = false
                    RunService:UnbindFromRenderStep(ShowCursorBinding)
                end
            end)
        elseif not Library.Toggled then
            TooltipLabel.Visible = false

            for _, Option in Library.Options do
                if Option.Type == "ColorPicker" then
                    Option.ColorMenu:Close()
                    Option.ContextMenu:Close()
                elseif Option.Type == "Dropdown" or Option.Type == "KeyPicker" then
                    Option.Menu:Close()
                end
            end
        end
    end

    function Library:Toggle(Value: boolean?)
        return Window:Toggle(Value)
    end

    if WindowInfo.EnableSidebarResize then
        local Threshold = (WindowInfo.MinSidebarWidth + WindowInfo.SidebarCompactWidth) * WindowInfo.SidebarCollapseThreshold
        local StartPos, StartWidth
        local Dragging = false
        local Changed

        local SidebarGrabber = New("TextButton", {
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(0.5, 0),
            Size = UDim2.new(0, 8, 1, 0),
            Text = "",
            Parent = DividerLine,
        })
        SidebarGrabber.MouseEnter:Connect(function()
            TweenService:Create(DividerLine, Library.TweenInfo, {
                BackgroundColor3 = Library:GetLighterColor(Library.Scheme.OutlineColor),
            }):Play()
        end)
        SidebarGrabber.MouseLeave:Connect(function()
            if Dragging then
                return
            end
            TweenService:Create(DividerLine, Library.TweenInfo, {
                BackgroundColor3 = Library.Scheme.OutlineColor,
            }):Play()
        end)

        SidebarGrabber.InputBegan:Connect(function(Input: InputObject)
            if not IsClickInput(Input) then
                return
            end

            Library.CantDragForced = true

            StartPos = Input.Position
            StartWidth = Window:GetSidebarWidth()
            Dragging = true

            Changed = Input.Changed:Connect(function()
                if Input.UserInputState ~= Enum.UserInputState.End then
                    return
                end

                Library.CantDragForced = false
                TweenService:Create(DividerLine, Library.TweenInfo, {
                    BackgroundColor3 = Library.Scheme.OutlineColor,
                }):Play()

                Dragging = false
                if Changed and Changed.Connected then
                    Changed:Disconnect()
                    Changed = nil
                end
            end)
        end)

        Library:GiveSignal(UserInputService.InputChanged:Connect(function(Input: InputObject)
            if not Library.Toggled or not (ScreenGui and ScreenGui.Parent) then
                Dragging = false
                if Changed and Changed.Connected then
                    Changed:Disconnect()
                    Changed = nil
                end

                return
            end

            if Dragging and IsHoverInput(Input) then
                local Delta = Input.Position - StartPos
                local Width = StartWidth + Delta.X

                if WindowInfo.DisableCompactingSnap then
                    Window:SetSidebarWidth(Width)
                    return
                end

                if Width > Threshold then
                    Window:SetSidebarWidth(math.max(Width, WindowInfo.MinSidebarWidth))
                else
                    Window:SetSidebarWidth(WindowInfo.SidebarCompactWidth)
                end
            end
        end))
    end
    if WindowInfo.EnableCompacting and WindowInfo.SidebarCompacted then
        Window:SetSidebarWidth(WindowInfo.SidebarCompactWidth)
    end
    if WindowInfo.AutoShow and not Library.ActiveLoading then
        task.spawn(Library.Toggle)
    end

    if Library.IsMobile then
        local ToggleButton = Library:AddDraggableButton("切换", function()
            Library:Toggle()
        end, true, true)

        local LockButton = Library:AddDraggableButton("锁定", function(self)
            Library.CantDragForced = not Library.CantDragForced
            self:SetText(Library.CantDragForced and "解锁" or "锁定")
        end, true, true)

        if WindowInfo.MobileButtonsSide == "Right" then
            ToggleButton.Button.AnchorPoint = Vector2.new(1, 0)
            ToggleButton.Button.Position = UDim2.new(1, -6, 0, 6)

            LockButton.Button.AnchorPoint = Vector2.new(1, 0)
            LockButton.Button.Position = UDim2.new(1, -(ToggleButton.Button.Size.X.Offset + 12), 0, 6)
        else
            ToggleButton.Button.AnchorPoint = Vector2.new(0, 0)
            ToggleButton.Button.Position = UDim2.fromOffset(6, 6)

            LockButton.Button.AnchorPoint = Vector2.new(0, 0)
            LockButton.Button.Position = UDim2.fromOffset(ToggleButton.Button.Size.X.Offset + 12, 6)
        end

        if WindowInfo.ShowMobileButtons == false then
            ToggleButton.Button.Visible = false
            LockButton.Button.Visible = false
        end
    end

    --// Execution \\--
    Library:GiveSignal(SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        Library:UpdateSearch(SearchBox.Text)
    end))

    Library:GiveSignal(UserInputService.InputBegan:Connect(function(Input: InputObject)
        if Library.Unloaded then
            return
        end

        if UserInputService:GetFocusedTextBox() then
            return
        end

        if Input.KeyCode == Library.ToggleKeybind then
            Library:Toggle()
        end
    end))

    Library:GiveSignal(UserInputService.WindowFocused:Connect(function()
        Library.IsRobloxFocused = true
    end))
    Library:GiveSignal(UserInputService.WindowFocusReleased:Connect(function()
        Library.IsRobloxFocused = false
    end))

    Library.Window = Window
    return Window
end

function Library:CreateLoading(LoadingInfo)
    if Library.ActiveLoading then
        warn("Loading GUI already exists, you cannot create multiple Loading GUIs.")
        return Library.ActiveLoading
    end

    LoadingInfo = Library:Validate(LoadingInfo, Templates.Loading)

    local Loading = {
        CurrentStep = LoadingInfo.CurrentStep,
        TotalSteps = LoadingInfo.TotalSteps,

        ShowSidebar = LoadingInfo.ShowSidebar,
        AutoResizeHeight = LoadingInfo.AutoResizeHeight,
        IsError = false,
        Destroyed = false,

        WindowWidth = LoadingInfo.WindowWidth,
        WindowHeight = LoadingInfo.WindowHeight,
        BaseWindowHeight = LoadingInfo.WindowHeight,
        WindowErrorHeight = LoadingInfo.WindowHeight,

        ContentWidth = LoadingInfo.ContentWidth,
        SidebarWidth = LoadingInfo.SidebarWidth,
    }

    --// ScreenGui \\--
    local ScreenGui = New("ScreenGui", {
        Name = "ObsidianLoading",
        DisplayOrder = 999,
        ResetOnSpawn = false
    })
    ParentUI(ScreenGui)
    Loading.ScreenGui = ScreenGui

    ScreenGui.DescendantRemoving:Connect(function(Instance)
        Library:RemoveFromRegistry(Instance)
    end)

    --// Main Frame \\--
    local MainFrame = New("TextButton", {
        Name = "Main",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = function()
            return Library:GetBetterColor(Library.Scheme.BackgroundColor, -1)
        end,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(Loading.ShowSidebar and (Loading.ContentWidth + Loading.SidebarWidth) or Loading.WindowWidth, Loading.WindowHeight),
        ClipsDescendants = true,
        Text = "",
        AutoButtonColor = false,
        Parent = ScreenGui,
    })
    Library:AddOutline(MainFrame)
    table.insert(Library.Corners, New("UICorner", { CornerRadius = UDim.new(0, Library.CornerRadius), Parent = MainFrame }))
    
	local MainScale = New("UIScale", {
		Scale = Library.IsMobile and 0.8 or 1,
		Parent = MainFrame
	})
	table.insert(Library.Scales, MainScale)
	Library.ScalesOffset[MainScale] = Library.IsMobile and 0.2 or 0

    --// Layout Containers \\--
    local Container = New("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.new(0, Loading.ContentWidth, 1, 0),
        Parent = MainFrame,
    })

    local SideBar = New("Frame", {
        Name = "SideBar",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(Loading.ContentWidth, 0),
        Size = UDim2.new(0, Loading.ShowSidebar and Loading.SidebarWidth or 0, 1, 0),
        ClipsDescendants = true,
        Visible = Loading.ShowSidebar,
        Parent = MainFrame,
    })
    local SidebarCorner = New("UICorner", { CornerRadius = UDim.new(0, Library.CornerRadius), Parent = SideBar })
    table.insert(Library.Corners, SidebarCorner)
    
    Library:AddOutline(SideBar)
    
    local SidebarDivider = New("Frame", {
        BackgroundColor3 = "OutlineColor",
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.new(0, 1, 1, 0),
        Visible = Loading.ShowSidebar,
        Parent = SideBar,
    })

    --// Top Bar \\--
    local TopBar = New("Frame", {
        Name = "TopBar",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 48),
        ZIndex = 2,
        Parent = Container,
    })
    Library:MakeDraggable(MainFrame, TopBar, true, true)

    local TitleHolder = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = TopBar,
    })
    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 6),
        Parent = TitleHolder,
    })
    New("UIPadding", {
        PaddingLeft = UDim.new(0, 12),
        Parent = TitleHolder,
    })

    if LoadingInfo.Icon then
        local Icon = Library:GetCustomIcon(LoadingInfo.Icon)
        local _WindowIcon = New("ImageLabel", {
            Image = Icon and Icon.Url or "",
            ImageRectOffset = Icon and Icon.ImageRectOffset or Vector2.zero,
            ImageRectSize = Icon and Icon.ImageRectSize or Vector2.zero,
            Size = LoadingInfo.IconSize,
            Parent = TitleHolder,
        })
    else
        local _WindowIcon = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = LoadingInfo.IconSize,
            Text = LoadingInfo.Title:sub(1, 1),
            TextScaled = true,
            Visible = false,
            Parent = TitleHolder,
        })
    end

    local TitleX = Library:GetTextBounds(
        LoadingInfo.Title,
        Library.Scheme.Font,
        20,
        TitleHolder.AbsoluteSize.X - (LoadingInfo.Icon and (LoadingInfo.IconSize.X.Offset + 6) or 0) - 12
    )
    local _WindowTitle = New("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, TitleX, 1, 0),
        Text = LoadingInfo.Title,
        TextSize = 20,
        Parent = TitleHolder,
    })

    Library:MakeLine(Container, {
        Position = UDim2.fromOffset(0, 48),
        Size = UDim2.new(1, 0, 0, 1),
    })

    --// Loading Content Elements \\--
    local InnerContent = New("Frame", {
        Name = "InnerContent",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 49),
        Size = UDim2.new(1, 0, 1, -49),
        Parent = Container,
    })

    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 12),
        Parent = InnerContent,
    })

    local IconHolder = New("Frame", {
        Name = "IconHolder",
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(64, 64),
        Parent = InnerContent,
    })

    local LoaderIcon = Library:GetCustomIcon(LoadingInfo.LoadingIcon)
    local LoadingIcon = New("ImageLabel", {
        Name = "LoaderIcon",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1),
        Image = LoaderIcon and LoaderIcon.Url or "",
        ImageRectOffset = LoaderIcon and LoaderIcon.ImageRectOffset or Vector2.zero,
        ImageRectSize = LoaderIcon and LoaderIcon.ImageRectSize or Vector2.zero,
        ImageColor3 = LoadingInfo.LoadingIconColor or ((LoadingInfo.LoadingIcon == Templates.Loading.LoadingIcon) and "AccentColor" or "WhiteColor"),
        Parent = IconHolder,
    })

    local RotationTween
    if LoadingInfo.LoadingIconTweenTime > 0 then
        RotationTween = TweenService:Create(
            LoadingIcon,
            TweenInfo.new(LoadingInfo.LoadingIconTweenTime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1),
            { Rotation = 360 }
        )
        RotationTween:Play()
    end

    local MessageLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        AutomaticSize = Loading.AutoResizeHeight and Enum.AutomaticSize.Y or Enum.AutomaticSize.XY,
        Size = Loading.AutoResizeHeight and UDim2.new(1, -60, 0, 0) or UDim2.fromOffset(0, 0),
        Text = "",
        TextSize = 18,
        TextWrapped = Loading.AutoResizeHeight,
        Parent = InnerContent,
    })

    local DescriptionLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        AutomaticSize = Loading.AutoResizeHeight and Enum.AutomaticSize.Y or Enum.AutomaticSize.XY,
        Size = Loading.AutoResizeHeight and UDim2.new(1, -60, 0, 0) or UDim2.fromOffset(0, 0),
        Text = "",
        TextSize = 14,
        TextTransparency = 0.5,
        TextWrapped = Loading.AutoResizeHeight,
        Parent = InnerContent,
    })

    --// Progress Bar \\--
    local SliderBar = New("Frame", {
        BackgroundColor3 = "MainColor",
        Size = UDim2.new(0.7, 0, 0, 15),
        Parent = InnerContent,
    })
    Library:AddOutline(SliderBar)
    table.insert(Library.Corners, New("UICorner", { CornerRadius = UDim.new(0, Library.CornerRadius / 2), Parent = SliderBar }))

    local SliderFill = New("Frame", {
        BackgroundColor3 = "AccentColor",
        BorderSizePixel = 0,
        Size = UDim2.fromScale(0, 1),
        Parent = SliderBar,
    })
    table.insert(Library.Corners, New("UICorner", { CornerRadius = UDim.new(0, Library.CornerRadius / 2), Parent = SliderFill }))

    local ProgressLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Text = "",
        TextSize = 14,
        ZIndex = 2,
        Parent = SliderBar,
    })
    New("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
        Color = "DarkColor",
        LineJoinMode = Enum.LineJoinMode.Miter,
        Parent = ProgressLabel,
    })

    --// Sidebar Object \\--
    local SidebarScrolling = New("ScrollingFrame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Size = UDim2.fromScale(1, 1),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = "OutlineColor",
        Parent = SideBar,
    })
    local SidebarList = New("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = SidebarScrolling,
    })
    New("UIPadding", {
        PaddingBottom = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        PaddingTop = UDim.new(0, 12),
        Parent = SidebarScrolling,
    })

    local SidebarObject = {
        Elements = {},
        DependencyBoxes = {},
        Tabboxes = {},
        
        BoxHolder = SidebarScrolling,
        Container = SidebarScrolling,
        
        Resize = function(self)
            SidebarScrolling.CanvasSize = UDim2.fromOffset(0, SidebarList.AbsoluteContentSize.Y + 24)
        end,
        Tab = {
            Elements = {},
            DependencyBoxes = {},
            DependencyGroupboxes = {},
            Tabboxes = {},
        },
    }

    SidebarList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SidebarObject:Resize()
    end)

    setmetatable(SidebarObject, BaseGroupbox)
    Loading.Sidebar = SidebarObject

    --// Error Frame \\--
    local ErrorFrame = New("Frame", {
        Name = "Error",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 49),
        Size = UDim2.new(1, 0, 1, -49),
        ClipsDescendants = true,
        Visible = false,
        Parent = Container,
    })

    local _ErrorTitle = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(15, 15),
        Size = UDim2.new(1, -30, 0, 18),
        Text = "错误",
        TextColor3 = "RedColor",
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = ErrorFrame,
    })

    local ErrorLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(15, 39),
        Size = UDim2.new(1, -30, 1, -90),
        Text = "错误信息",
        TextSize = 14,
        TextTransparency = 0.2,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        Parent = ErrorFrame,
    })

    local ErrorButtonsDivider = New("Frame", {
        BackgroundColor3 = "OutlineColor",
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 1, -48),
        Size = UDim2.new(1, -30, 0, 1),
        Visible = false,
        Parent = ErrorFrame,
    })

    local ErrorButtonsHolder = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 42),
        Visible = false,
        Parent = ErrorFrame,
    })
    New("UIListLayout", {
        Padding = UDim.new(0, 8),
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = ErrorButtonsHolder,
    })
    New("UIPadding", {
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 15),
        PaddingRight = UDim.new(0, 15),
        Parent = ErrorButtonsHolder,
    })

    function Loading:UpdateLayout()
        if Loading.IsError then
            Loading:RecalculateErrorHeight()
        end

        local ShowSidebar = Loading.ShowSidebar
        local FinalWidth = ShowSidebar and (Loading.ContentWidth + Loading.SidebarWidth) or Loading.WindowWidth
        local FinalHeight = Loading.IsError and Loading.WindowErrorHeight or Loading.WindowHeight
        
        if ShowSidebar then
            SideBar.Visible = true
            SidebarDivider.Visible = true
        end

        TweenService:Create(MainFrame, Library.TweenInfo, { Size = UDim2.fromOffset(FinalWidth, FinalHeight) }):Play()
        TweenService:Create(SideBar, Library.TweenInfo, { Position = UDim2.fromOffset(Loading.ContentWidth, 0), Size = UDim2.new(0, ShowSidebar and Loading.SidebarWidth or 0, 1, 0) }):Play()
        TweenService:Create(Container, Library.TweenInfo, { Size = UDim2.new(0, ShowSidebar and Loading.ContentWidth or Loading.WindowWidth, 1, 0) }):Play()

        if not ShowSidebar then
            task.delay(Library.TweenInfo.Time, function()
                if not Loading.ShowSidebar then
                    SideBar.Visible = false
                    SidebarDivider.Visible = false
                end
            end)
        end
    end

    --// Content Page \\--
    function Loading:RecalculateLoadingHeight()
        if not Loading.AutoResizeHeight then
            return
        end

        local RequiredHeight = 
              49 -- TopBar
            + 48 -- Padding
            + InnerContent.UIListLayout.AbsoluteContentSize.Y

        Loading.WindowHeight = math.max(Loading.BaseWindowHeight, RequiredHeight)
    end

    function Loading:SetMessage(Text)
        MessageLabel.Text = Text

        if Loading.AutoResizeHeight then
            Loading:RecalculateLoadingHeight()
            Loading:UpdateLayout()
        end
    end

    function Loading:SetDescription(Text)
        DescriptionLabel.Text = Text

        if Loading.AutoResizeHeight then
            Loading:RecalculateLoadingHeight()
            Loading:UpdateLayout()
        end
    end

    function Loading:SetLoadingIcon(Icon)
        local IconData = Library:GetCustomIcon(Icon)
        assert(IconData, "Image must be a valid Roblox asset or a valid URL or a valid lucide icon.")

        LoadingIcon.Image = IconData.Url
        LoadingIcon.ImageRectOffset = IconData.ImageRectOffset
        LoadingIcon.ImageRectSize = IconData.ImageRectSize
    end

    function Loading:SetLoadingIconTweenTime(TweenTime)
        if RotationTween then
            StopTween(RotationTween, true)
            RotationTween = nil
        end

        if TweenTime > 0 then
            RotationTween = TweenService:Create(
                LoadingIcon,
                TweenInfo.new(TweenTime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1),
                { Rotation = 360 }
            )
            RotationTween:Play()
        else
            LoadingIcon.Rotation = 0
        end
    end

    function Loading:SetLoadingIconColor(Color)
        LoadingIcon.ImageColor3 = Color
    end

    function Loading:SetCurrentStep(Step)
        Loading.CurrentStep = math.clamp(Step, 0, Loading.TotalSteps)

        local Progress = Loading.CurrentStep / Loading.TotalSteps
        TweenService:Create(SliderFill, Library.TweenInfo, { Size = UDim2.fromScale(Progress, 1) }):Play()

        ProgressLabel.Text = string.format("%d/%d", Loading.CurrentStep, Loading.TotalSteps)
    end

    function Loading:SetTotalSteps(Steps)
        Loading.TotalSteps = Steps
        Loading:SetCurrentStep(Loading.CurrentStep)
    end

    --// Size \\--
    function Loading:SetWindowHeight(Height)
        Loading.WindowHeight = Height
        Loading:UpdateLayout()
    end

    function Loading:SetWindowWidth(Width)
        Loading.WindowWidth = Width
        Loading:UpdateLayout()
    end

    function Loading:SetContentWidth(Width)
        Loading.ContentWidth = Width
        Loading:UpdateLayout()
    end

    function Loading:SetSidebarWidth(Width)
        Loading.SidebarWidth = Width
        Loading:UpdateLayout()
    end

    --// Sidebar \\--
    function Loading:ShowSidebarPage(Bool)
        Loading.ShowSidebar = Bool
        Loading:UpdateLayout()
    end

    --// Error Page \\--
    function Loading:ShowErrorPage(Enabled)
        Loading.IsError = Enabled
        InnerContent.Visible = not Enabled
        ErrorFrame.Visible = Enabled

        if Loading.ShowSidebar then
            Loading:ShowSidebarPage(not Enabled)
        else
            Loading:UpdateLayout()
        end
    end

    function Loading:RecalculateErrorHeight()
        local TargetWidth = (Loading.ShowSidebar and Loading.ContentWidth or Loading.WindowWidth) - 30
        local _, ErrorY = Library:GetTextBounds(ErrorLabel.Text, Library.Scheme.Font, 14, TargetWidth)

        ErrorLabel.Size = UDim2.new(1, -30, 0, ErrorY)

        local HasButtons = ErrorButtonsHolder.Visible
        local RequiredHeight =
              49                        -- TopBar
            + 15                        -- Padding Top
            + 18                        -- Title Height
            + 6                         -- Padding between Title and Label
            + ErrorY                    -- Label Height
            + 15                        -- Padding between Label and Buttons
            + (HasButtons and 48 or 0)  -- Buttons Area

        Loading.WindowErrorHeight = RequiredHeight -- math.max(Loading.WindowHeight, RequiredHeight)
    end

    function Loading:SetErrorMessage(Text)
        ErrorLabel.Text = Text
        Loading:UpdateLayout()
    end

    function Loading:SetErrorButtons(Buttons)
        assert(typeof(Buttons) == "table", "Buttons must be a table")

        for _, button in ErrorButtonsHolder:GetChildren() do
            if button:IsA("Frame") then 
                button:Destroy() 
            end
        end

        local HasButtons = GetTableSize(Buttons) > 0
        ErrorButtonsHolder.Visible = HasButtons
        ErrorButtonsDivider.Visible = HasButtons

        for Idx, ButtonInfo in Buttons do
            local ButtonContainer = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromOffset(0, 26),
                Parent = ErrorButtonsHolder,
            })
            
            local BtnColor = "MainColor"
            local BtnOutline = "OutlineColor"
            local Variant = ButtonInfo.Variant or "Primary"
            
            if Variant == "Primary" then
                BtnColor = "FontColor"
                BtnOutline = "FontColor"
            elseif Variant == "Secondary" then
                BtnColor = "MainColor"
                BtnOutline = "OutlineColor"
            elseif Variant == "Destructive" then
                BtnColor = "DestructiveColor"
                BtnOutline = "DestructiveColor"
            elseif Variant == "Ghost" then
                BtnColor = "BackgroundColor"
                BtnOutline = "BackgroundColor"
            end

            local TextBtn = New("TextButton", {
                BackgroundColor3 = BtnColor,
                BorderColor3 = BtnOutline,
                Size = UDim2.fromOffset(0, 26),
                Text = "",
                AutoButtonColor = false,
                Parent = ButtonContainer,
            })
            Library:AddOutline(TextBtn)
            table.insert(
                Library.Corners,
                New("UICorner", { 
                    CornerRadius = UDim.new(0, Library.CornerRadius), 
                    Parent = TextBtn 
                })
            )

            New("UIPadding", {
                PaddingLeft = UDim.new(0, 15),
                PaddingRight = UDim.new(0, 15),
                Parent = TextBtn,
            })

            local TextColor = Library.Scheme.FontColor
            if Variant == "Primary" then
                TextColor = Library.Scheme.BackgroundColor
            elseif Variant == "Destructive" then
                TextColor = Color3.new(1, 1, 1)
            end

            local BtnLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Text = ButtonInfo.Title or Idx,
                TextColor3 = TextColor,
                TextSize = 14,
                Parent = TextBtn,
            })
            
            local LabelX, _ = Library:GetTextBounds(BtnLabel.Text, Library.Scheme.Font, 14, 250)
            ButtonContainer.Size = UDim2.fromOffset(LabelX + 30, 26)
            TextBtn.Size = UDim2.fromOffset(LabelX + 30, 26)

            local ActiveColor = typeof(BtnColor) == "Color3" and BtnColor or Library.Scheme[BtnColor]
            local HoverColor = Variant == "Ghost" and Library.Scheme.MainColor or Library:GetBetterColor(ActiveColor, 10)

            TextBtn.MouseEnter:Connect(function()
                TweenService:Create(TextBtn, Library.TweenInfo, {
                    BackgroundColor3 = HoverColor
                }):Play()
            end)
            TextBtn.MouseLeave:Connect(function()
                TweenService:Create(TextBtn, Library.TweenInfo, {
                    BackgroundColor3 = ActiveColor
                }):Play()
            end)

            TextBtn.MouseButton1Click:Connect(function()
                if ButtonInfo.Callback then
                    ButtonInfo.Callback(Loading)
                end
            end)
        end

        Loading:UpdateLayout()
    end

    --// Destroy/Continue \\--
    function Loading:Destroy()
        if RotationTween then
            StopTween(RotationTween, true)
            RotationTween = nil
        end

        ScreenGui:Destroy()
        Loading.Destroyed = true
        Library.ActiveLoading = nil

        if Library.Toggle and Library.Toggled == false and Library.Unloaded ~= true then
            Library:Toggle(true)
        end
    end

    Loading.Continue = Loading.Destroy;

    if Library.Toggle and Library.Toggled and Library.Unloaded ~= true then
        Library:Toggle(false)
    end

    Loading:SetCurrentStep(Loading.CurrentStep)

    Library.ActiveLoading = Loading
    return Loading
end

local function OnPlayerChange()
    if Library.Unloaded then
        return
    end

    local PlayerList, ExcludedPlayerList = GetPlayers(), GetPlayers(true)
    for _, Dropdown in Options do
        if Dropdown.Type == "Dropdown" and Dropdown.SpecialType == "Player" then
            Dropdown:SetValues(Dropdown.ExcludeLocalPlayer and ExcludedPlayerList or PlayerList)
        end
    end
end

local function OnTeamChange()
    if Library.Unloaded then
        return
    end

    local TeamList = GetTeams()
    for _, Dropdown in Options do
        if Dropdown.Type == "Dropdown" and Dropdown.SpecialType == "Team" then
            Dropdown:SetValues(TeamList)
        end
    end
end

Library:GiveSignal(Players.PlayerAdded:Connect(OnPlayerChange))
Library:GiveSignal(Players.PlayerRemoving:Connect(OnPlayerChange))

Library:GiveSignal(Teams.ChildAdded:Connect(OnTeamChange))
Library:GiveSignal(Teams.ChildRemoved:Connect(OnTeamChange))

function Library:Unload()
    Library.Unloaded = true

    --// Disconnect connections
    for Index = #Library.Signals, 1, -1 do
        local Connection = table.remove(Library.Signals, Index)

        if Connection and Connection.Connected then
            Connection:Disconnect()
        end
    end

    --// Run Unload Callbacks
    for _ = 1, #Library.UnloadSignals do
        local Callback = table.remove(Library.UnloadSignals, 1)

        if Callback then
            Library:SafeCallback(Callback)
        end
    end

    --// Destroy elements
    for Index = #Library.Tabs, 1, -1 do
        local Tab = table.remove(Library.Tabs, Index)

        if Tab and Tab.Destroy then
            Library:SafeCallback(Tab.Destroy, Tab)
        end
    end

    for Index = #Tooltips, 1, -1 do
        local Tooltip = table.remove(Tooltips, Index)

        if Tooltip and Tooltip.Destroy then
            Library:SafeCallback(Tooltip.Destroy, Tooltip)
        end
    end

    if Library.ActiveLoading then
        Library.ActiveLoading:Destroy()
    end

    if ScreenGui then
        ScreenGui:Destroy()
    end

    --// Clear tables
    table.clear(Library.Registry)

    table.clear(Options)
    table.clear(Toggles)
    table.clear(Buttons)
    table.clear(Labels)
    table.clear(Tooltips)

    table.clear(Library.Tabs)
    table.clear(Library.TabButtons)

    table.clear(Library.Scales)
    table.clear(Library.ScalesOffset)

    table.clear(Library.Corners)
    table.clear(Library.SpecificCorners)

    table.clear(Library.Notifications)
    table.clear(Library.Dialogues)
    table.clear(Library.DraggableElements)
    table.clear(Library.KeybindToggles)
    table.clear(Library.DependencyBoxes)

    table.clear(TransparencyCache)
    table.clear(ActiveTabTweens)
    
    Library.Toggle = function(...) end
    Library.ScreenGui = nil
    Library.WindowContainer = nil
    Library.KeybindFrame = nil
    Library.KeybindContainer = nil

    getgenv().Library = nil
end

getgenv().Library = Library
return Library


local Lucide = {}

local IS_GETCUSTOMASSET_BROKEN = false

if writefile and isfolder and makefolder and getcustomasset then
	if not isfolder("lucide-icons") then
		makefolder("lucide-icons")
	end

	if not isfile("lucide-icons/version.txt") then
		writefile("lucide-icons/version.txt", "2026-08-03T17:46:40.608886867+00:00")
	end

	local ShouldUpdate = readfile("lucide-icons/version.txt") ~= "2026-08-03T17:46:40.608886867+00:00"

	if ShouldUpdate then
		writefile("lucide-icons/version.txt", "2026-08-03T17:46:40.608886867+00:00")
	end

	for spritesheet = 1, 2 do
		if isfile(`lucide-icons/{spritesheet}.png`) and not ShouldUpdate then
			continue
		end

		writefile(
			`lucide-icons/{spritesheet}.png`,
			game:HttpGet(
				`https://raw.githubusercontent.com/mstudio45/lucide-roblox-direct/refs/heads/main/spritesheets/{spritesheet}.png`
			)
		)
	end

	local Success, _Error = pcall(function()
		return getcustomasset("lucide-icons/1.png")
	end)

	IS_GETCUSTOMASSET_BROKEN = not Success
end

local icons = {{"align-vertical-distribute-center","chevron-down","list-restart","table-cells-split","gavel","dna-off","refresh-ccw-dot","venus","bean","circle-question-mark","folder-code","bolt","heater","feather","align-horizontal-distribute-center","grip-vertical","pill-bottle","person-standing","badge-swiss-franc","between-horizontal-end","file-braces-corner","rotate-cw","house-plus","bus-front","shield-ellipsis","between-vertical-end","globe-lock","tags","concierge-bell","bookmark-minus","file-down","picture-in-picture","messages-square","scissors","file-check-corner","phone-call","anchor","hand-helping","text-wrap","birdhouse","wifi-off","cloud-alert","message-square","cloud-download","folder-plus","cctv-off","mirror-round","user-round","pointer","between-horizontal-start","chevrons-up-down","brush","message-circle-more","parentheses","book-up-2","flame","chevrons-up","square-dashed","square-mouse-pointer","superscript","signal","wifi-cog","hexagon","navigation-2-off","eye-off","arrows-up-from-line","file-code-corner","square-centerline-dashed-horizontal","panels-right-bottom","scaling","hash","arrow-left-from-line","ship","ticket-percent","calendar-clock","x","non-binary","voicemail","presentation","tree-palm","badge","captions-off","align-vertical-justify-center","download","mouse-right","lens-convex","focus","diamond-percent","arrow-big-up","volume-x","mouse-pointer-click","origami","hard-drive","grid-2x2-x","package-minus","cloud","pipette","corner-left-down","badge-cent","cloud-lightning","user-round-pen","arrow-left-to-line","book-open-text","monitor-cloud","parking-meter","cat","heart-handshake","dam","trees","ham","circle-pause","chess-king","bean-off","rat","separator-horizontal","ambulance","signal-zero","citrus","phone-missed","calendar-off","chart-column","battery-medium","square-minus","star-check","decimals-arrow-left","folder-output","menu","image-down","terminal","angry","circle-dot-dashed","medal","cake-slice","git-graph","armchair","tickets","qr-code","copy","goal","trending-down","creative-commons","ev-charger","user-star","road","nfc","align-center-horizontal","car","notebook-tabs","ear","videotape","sun-moon","chart-scatter","podium","toolbox","calendar","calendar-cog","gallery-horizontal","clipboard-x","list-sort-ascending","book-open","circle-pile","rectangle-ellipsis","badge-plus","badge-info","file-headphone","bow-arrow","clipboard-pen-line","user-round-key","folder-search","utensils-crossed","arrow-up","arrow-up-from-dot","align-vertical-justify-start","layers-minus","pause","shrub","flag","biceps-flexed","align-horizontal-distribute-end","donut","calendar-plus-2","move-vertical","file-pen-line","badge-russian-ruble","radius","pilcrow","corner-left-up","georgian-lari","cable","book-user","square-arrow-down","circle-plus","view","cctv","circle-arrow-left","square-off","octagon-alert","panel-bottom-dashed","book-a","align-end-vertical","thumbs-up","globe","rabbit","layers-plus","banknote-arrow-down","message-square-off","dice-4","message-circle-x","folder-x","message-circle-warning","map","move","arrow-up-left","award","arrow-down-wide-narrow","unfold-horizontal","lens-concave","motorbike","music-4","shield-x","file-volume","disc-3","file-signal","columns-4","archive-x","square-dashed-kanban","mouse-pointer-2","clock-arrow-up","clock-fading","pencil-sparkles","vegan","star-plus","message-circle-plus","fast-forward","user-pen","chess-knight","wifi-pen","files","send-to-back","alarm-clock","shopping-basket","send","brush-cleaning","skip-back","book-audio","file-scan","message-square-dashed","chevrons-left","umbrella","skip-forward","clipboard-copy","map-pin-off","arrow-up-from-line","circle-chevron-up","circle-small","align-vertical-space-between","lamp-desk","circle-arrow-up","zap","beaker","paintbrush","broccoli","chevron-up","pen-tool","database-check","form","pencil-ruler","dna","arrow-big-down-dash","chart-area","bug-off","card-sim","map-pin-search","eye-dashed","ellipse","spell-check","popcorn","blocks","washing-machine","microchip","badge-minus","cloud-sun","circle","shield-alert","map-minus","separator-vertical","scan-square","ampersands","user-search","fence","square-user-round","sunrise","strikethrough","calendar-days","folder-bookmark","banknote-arrow-up","dollar-sign","message-square-quote","list-minus","cloud-hail","eye-closed","app-window-mac","ellipsis","copy-check","satellite","bookmark-plus","folder-key","coffee","circle-power","hourglass","tickets-plane","folder-git","bomb","layers-2","battery-full","user-minus","chart-gantt","folder-tree","command","badge-dollar-sign","align-start-vertical","briefcase-conveyor-belt","message-circle-question-mark","bluetooth-off","square-square","cannabis","book","grip-horizontal","circle-minus","audio-waveform","moon-star","arrow-down-narrow-wide","database-backup","wand","receipt-turkish-lira","calendar-minus-2","copy-minus","folder-input","book-image","mouse-left","tag-plus","shirt","server-off","move-up","plug-2","chess-rook","brackets","calendar-heart","list-ordered","star-x","mic-off","arrow-big-left","square-split-horizontal","clover","sun-snow","sofa","funnel-x","clock-2","calendar-fold","fish-off","baby","database-x","fold-vertical","hop","paperclip","cigarette","minus","smile-plus","diamond-plus","file-chart-column","triangle-dashed","git-pull-request-closed","badge-check","zoom-out","zoom-in","zodiac-virgo","plug-zap","heading-4","chess-queen","graduation-cap","grid-3x2","zodiac-sagittarius","list-music","square-dashed-bottom-code","clock-7","ethernet-port","scan-text","file-up","shower-head","equal-not","zodiac-pisces","move-down","clock-arrow-down","ticket-slash","ruler","tornado","zodiac-libra","circle-user-round","zodiac-leo","zodiac-gemini","list-filter","map-pin-check","egg-off","square-kanban","cog","dog","folder-closed","swords","spotlight","panel-right-dashed","zodiac-aries","paper-bag","truck-electric","zodiac-aquarius","check-line","save","bubbles","bot","chart-bar-increasing","x-line-top","trash-2","air-vent","swiss-franc","dot","sprout","worm","file-symlink","clipboard-paste","chevron-last","book-heart","workflow","circle-parking","globe-check","cloud-check","panel-left","circle-chevron-right","wine-off","wine","squares-unite","arrow-down-up","git-fork","forward","brain-circuit","between-vertical-start","database","panel-right","wind-arrow-down","message-square-diff","popsicle","log-out","git-branch-plus","clipboard-minus","file-text","wifi-sync","bell-off","wifi-high","table-rows-split","milk-off","tv-minimal","cloud-upload","banknote","wifi","webcam-off","drumstick","wheat-off","calendar-search","wheat","weight-tilde","bell-ring","circle-chevron-left","weight","arrow-down","arrow-up-down","folder-dot","fingerprint-pattern","folder-up","whole-word","monitor","disc-2","trending-up-down","webcam","user-shield","waypoints","tv-minimal-play","circle-stop","align-vertical-space-around","waves-vertical","waves-ladder","waves-horizontal","arrow-big-down","circle-parking-off","calendar-x-2","user-plus","move-diagonal-2","bandage","gallery-horizontal-end","panel-top-dashed","octagon-minus","waves-arrow-down","tram-front","watch","indian-rupee","wand-sparkles","audio-lines","wallpaper","wallet-minimal","wallet-cards","flip-vertical-2","rocket","wallet","ear-off","vote","save-check","volume-off","shield-half","printer","megaphone-off","volume-1","arrow-big-right","section","file-clock","volume","toy-brick","square-chevron-down","dice-1","drill","app-window","shield-check","hand-metal","volleyball","spell-check-2","umbrella-off","video","list-plus","sun-dim","rotate-ccw-key","vibrate","chart-pie","venus-and-mars","cloud-backup","copy-slash","wind","vault","layout-panel-left","badge-x","circle-percent","van","circle-arrow-out-down-right","square-x","italic","chart-column-increasing","utility-pole","step-forward","utensils","a-arrow-down","container","sticker","users-round","users","user-x","user-round-x","user-round-search","log-in","import","badge-turkish-lira","square-terminal","file-music","mic-vocal","beef","route-off","file-user","user-round-cog","square-radical","user-round-check","image-upscale","book-type","smile","signpost-big","user-round-arrow-left","cloudy","user-lock","square-percent","user-key","navigation-off","arrow-left","car-taxi-front","square-play","sparkle","chevrons-right-left","user","map-pin-plus","upload","unplug","square-code","unlink","university","square-pause","align-end-horizontal","ungroup","equal","megaphone","calendar-x","unfold-vertical","lamp-ceiling","egg","undo-2","undo","underline","circle-pound-sterling","video-off","japanese-yen","type-outline","fuel","file-search-corner","library","file-terminal","circle-chevron-down","accessibility","folder-lock","square-library","amphora","turntable","tally-2","turkish-lira","truck","trophy","gamepad-directional","sheet","circle-check-big","triangle-alert","triangle","map-pinned","corner-down-left","circuit-board","trending-up","train-front-tunnel","tree-deciduous","school","folder-open-dot","book-dashed","transgender","chevron-left","bluetooth","tree-pine","receipt-indian-rupee","monitor-stop","traffic-cone","tractor","tower-control","replace-all","touchpad-off","flask-conical","touchpad","funnel","square-star","folder-sync","torus","zodiac-ophiuchus","tool-case","toilet","arrow-up-narrow-wide","fishing-hook","text-quote","toggle-left","timer-reset","frame","calendar-arrow-down","clock-12","star-minus","radar","timer","images","lollipop","book-text","timeline","lamp-floor","file-plus-corner","image","ticket-x","badge-euro","bike","squares-exclude","list-checks","send-horizontal","dices","panel-left-dashed","thermometer-sun","thermometer-snowflake","option","banknote-check","scroll-text","server-plus","thermometer","theater","message-circle-off","toggle-right","pc-case","ferris-wheel","camera-off","text-cursor-input","text-cursor","info","text-align-justify","text-align-end","group","text-align-center","battery","test-tubes","tent-tree","test-tube-diagonal","rectangle-horizontal","bug","tent","telescope","bitcoin","lamp","battery-plus","database-search","tangent","file-diff","phone-off","link","tally-3","spline-pointer","circle-alert","axis-3d","shell","tag","binoculars","tablets","tablet-smartphone","screen-share","rose","table-properties","mail-minus","table-of-contents","table-columns-split","table-cells-merge","table-2","clipboard-pen","bottle-wine","alarm-clock-off","table","list","syringe","square-arrow-right","rotate-ccw-clock","badge-pound-sterling","bookmark-check","switch-camera","wrench-off","square-arrow-out-down-left","a-arrow-up","clock-check","sunset","sun-medium","vibrate-off","mail-check","zodiac-cancer","file-chart-column-increasing","file-code","subscript","chart-column-big","stretch-vertical","stretch-horizontal","cassette-tape","battery-low","monitor-pause","stone","signpost","image-plus","calendar-arrow-up","landmark","fish-symbol","sticky-note-x","loader","bold","dice-2","file-type","clipboard-clock","beer","lectern","chart-bar-stacked","file-check","git-pull-request-create","binary","move-diagonal","sticky-note-check","door-closed","sticky-note","layout-template","stethoscope","step-back","star-off","bookmark-off","hand-heart","scroll","scan-qr-code","message-square-check","star","stamp","squirrel","brain","folder","squircle","snail","key","clock-11","earth-lock","ticket-plus","arrow-up-0-1","bell-electric","square-user","heading","book-open-check","panel-top-close","lasso-select","move-left","square-stack","square-split-vertical","square-slash","bus","square-sigma","bed-single","chart-no-axes-gantt","file-spreadsheet","square-scissors","clipboard-list","square-round-corner","contact-round","leaf","keyboard-off","square-plus","file-badge","battery-warning","mail-question-mark","arrow-down-from-line","briefcase","biohazard","rectangle-circle","braces","scale-3d","panel-top-bottom-dashed","mail-x","square-dashed-mouse-pointer","user-cog","lock-open","square-pilcrow","pizza","list-indent-decrease","arrow-up-wide-narrow","square-pi","clock-5","mouse-pointer","rotate-ccw","align-horizontal-justify-center","database-arrow-down","antenna","memory-stick","scan-eye","square-parking","square-check","heart-plus","receipt-russian-ruble","map-pin-minus-inside","git-merge","gallery-vertical-end","square-m","hand-coins","zodiac-capricorn","wifi-low","square-equal","clock","file-pen","git-compare-arrows","cloud-sun-rain","align-horizontal-justify-start","square-dot","square-divide","square-arrow-right-enter","calendar-plus","square-bottom-dashed-scissors","arrow-down-z-a","bath","square-dashed-bottom","unlink-2","square-chevron-up","pin","folder-check","square-chevron-left","book-key","ribbon","microwave","saudi-riyal","gallery-vertical","square-chart-gantt","square-centerline-dashed-vertical","square-dashed-text","map-pin-pen","move-up-left","square-asterisk","folder-heart","square-arrow-up-right","shield-cog-corner","circle-play","arrow-up-a-z","square-arrow-right-exit","square-dashed-top-solid","square-arrow-out-up-right","square-arrow-out-up-left","circle-ellipsis","swatch-book","receipt-cent","spool","folder-archive","folder-symlink","columns-3","ban","message-square-x","paint-roller","soup","archive","square-arrow-down-right","construction","building-2","circle-slash-2","package","cake","cloud-rain","chart-bar","square","wrench","spray-can","sport-shoe","smartphone","flag-triangle-right","receipt-euro","speech","bell","speaker","sparkles","music-3","chart-bar-big","user-check","proportions","spade","plane","webhook-off","carrot","square-arrow-left","file-cog","circle-dashed","solar-panel","soap-dispenser-droplet","snowflake","mailbox","squares-subtract","smartphone-nfc","chevrons-left-right-ellipsis","split","list-sort-descending","sliders-vertical","forklift","sliders-horizontal","alarm-clock-minus","heart-x","eraser","book-marked","package-search","bluetooth-connected","rotate-ccw-square","chart-no-axes-column","cannabis-off","folder-kanban","message-square-plus","mars-stroke","skull","siren","signature","file-box","signal-medium","paint-bucket","glass-water","signal-low","glasses","piggy-bank","maximize-2","cuboid","cloud-off","check-check","activity","axe","plane-takeoff","sigma","cloud-rain-wind","flower","expand","copy-x","file-axis-3d","radical","chart-column-decreasing","shrimp","bug-play","align-vertical-distribute-start","highlighter","waves-arrow-up","tally-5","shopping-bag","ship-wheel","shield-user","circle-divide","shield-question-mark","shield-plus","shield-off","life-buoy","hard-hat","shield-keyhole","volume-2","battery-charging","russian-ruble","square-arrow-up-left","brick-wall-shield","footprints","shield-cog","building","shield-ban","shield","shelving-unit","tag-x","book-alert","link-2","astroid","bell-minus","image-up","closed-caption","drum","arrow-up-z-a","sun","share","shapes","file-key","settings-2","settings","scissors-line-dashed","server-crash","server-cog","server","ticket-check","combine","search-x","search-slash","mountain","mars","picture-in-picture-2","radio-off","flower-2","search-code","squares-intersect","search-alert","search","keyboard-music","star-half","screen-share-off","code-xml","pencil-line","mails","brain-cog","tablet","loader-circle","pi","trash","book-down","hdmi-port","scan-search","case-upper","circle-fading-arrow-up","redo","croissant","move-down-right","scan-face","barcode","scan-box","scan-barcode","bed","scan","divide","grape","remove-formatting","party-popper","file-chart-pie","save-plus","file-braces","dice-6","save-off","blender","image-minus","zap-off","square-check-big","satellite-dish","sandwich","salad","laptop-minimal","sailboat","monitor-check","map-pin-minus","file-minus-corner","chart-spline","message-square-more","rows-4","chart-candlestick","rows-3","arrow-down-a-z","rows-2","router","move-horizontal","file-sliders","frown","route","cup-soda","rewind","rotate-cw-fading-clock","sword","rotate-3d","roller-coaster","earth","slice","dice-3","milk","mouse-pointer-ban","crown","circle-slash","circle-star","rotate-cw-square","atom","package-x","bed-double","list-chevrons-up-down","circle-dot","file-exclamation-point","hand-fist","message-circle-code","folder-git-2","message-square-code","reply","towel-rack","replace","arrow-big-left-dash","repeat-off","dumbbell","repeat-2","repeat-1","repeat","scale","regex","flashlight","panel-top-open","refrigerator","refresh-cw-off","notebook","redo-2","refresh-cw","square-menu","brick-wall","monitor-smartphone","laptop","scan-line","clock-4","square-arrow-up","book-minus","file-question-mark","rectangle-vertical","rectangle-goggles","save-pen","arrow-down-to-line","receipt-swiss-franc","refresh-ccw","venetian-mask","calendar-check-2","receipt-japanese-yen","spline","banknote-x","git-pull-request-create-arrow","pound-sterling","circle-check","ratio","rainbow","phone","radio-receiver","radio","radiation","timer-off","arrow-big-right-dash","quote","pyramid","puzzle","backpack","projector","list-check","printer-check","power-off","mic-signal","arrow-down-right","power","receipt","wifi-zero","folder-minus","list-collapse","plus","plug","image-off","play-off","play","plane-landing","pin-off","square-chevron-right","mail-search","pill","bone-fracture","microscope","pilcrow-left","pickaxe","piano","tally-1","ampersand","ad","shopping-cart","align-vertical-justify-end","phone-incoming","alarm-smoke","phone-forwarded","file-input","clock-8","hand-grab","cloud-cog","blend","hd","radio-tower","list-tree","droplet","grid-2x2","eye","phi","percent","banana","gpu","pentagon","pencil-off","circle-equal","delete","pen-off","pen-line","headset","text-initial","arrow-up-right","move-right","leafy-green","message-square-dot","file-chart-line","columns-3-cog","parasol","calendar-minus","minimize-2","panels-left-bottom","panel-top","cone","panel-right-open","file-image","panel-right-close","palette","barrel","gallery-thumbnails","panel-left-right-dashed","cpu","panel-left-open","thumbs-down","merge","hamburger","bird","hat-glasses","code","helicopter","panel-bottom-close","panel-bottom","panda","file-video-camera","paintbrush-vertical","kanban","bone","apple","rocking-chair","bot-off","package-plus","package-open","diameter","circle-arrow-out-up-left","package-2","cable-car","arrow-down-left","square-activity","orbit","cigarette-off","omega","message-circle","circle-arrow-out-up-right","locate-fixed","octagon-pause","fold-horizontal","shovel","calendar-1","cloud-moon","square-arrow-out-down-right","nut-off","clock-plus","circle-euro","cloud-snow","anvil","arrow-big-up-dash","nut","notepad-text-dashed","notepad-text","list-video","monitor-off","newspaper","chevrons-down-up","clipboard-plus","circle-x","list-end","network","navigation-2","chevrons-right","navigation","message-square-reply","corner-down-right","music-2","summary","lamp-wall-down","move-up-right","paw-print","ellipsis-vertical","globe-off","square-stop","arrow-up-1-0","align-horizontal-justify-end","scan-heart","align-vertical-distribute-end","heart-crack","airplay","move-down-left","move-3d","message-square-share","monitor-x","bell-check","database-minus","square-pen","mouse-off","lasso","dice-5","octagon","ticket","moon","monitor-up","train-front","bookmark","monitor-speaker","album","monitor-play","chart-bar-decreasing","database-plus","calendar-sync","funnel-plus","store","circle-arrow-down","notebook-pen","egg-fried","message-circle-heart","monitor-dot","corner-right-up","monitor-cog","ruler-dimension-line","user-round-plus","panel-left-close","milestone","pilcrow-right","user-round-minus","mic-audio-lines","mic","mail-plus","case-sensitive","message-square-warning","message-square-text","mouse-pointer-2-off","drone","slash","message-square-lock","aperture","arrow-right-left","message-square-heart","vector-square","circle-gauge","gem","check","text-search","arrow-down-to-dot","monitor-down","message-circle-dashed","chef-hat","message-circle-check","meh","file-archive","signal-high","inbox","flip-horizontal-2","maximize","image-play","align-horizontal-space-between","kayak","calendar-check","database-zap","droplets","calendar-range","map-pin-x-inside","map-pin-x","layout-list","file-search","heart","alarm-clock-plus","circle-dollar-sign","usb","house","receipt-pound-sterling","file-digit","map-pin","id-card","mouse","minimize","mail","magnet","circle-arrow-right","logs","book-x","mirror-rectangular","lock-keyhole-open","lock-keyhole","lock","headphone-off","asterisk","calculator","octagon-x","languages","locate","alarm-clock-check","guitar","loader-pinwheel","beer-off","scooter","square-parking-off","notebook-text","arrow-right-to-line","ticket-minus","tally-4","zodiac-taurus","list-indent-increase","door-open","flag-triangle-left","grid-3x3","file","keyboard","pocket-knife","book-copy","castle","car-front","clock-alert","reply-all","cloud-moon-rain","clipboard-type","list-chevrons-down-up","list-todo","printer-x","link-2-off","list-start","line-style","a-large-small","line-squiggle","line-dot-right-horizontal","map-plus","lightbulb","ligature","library-big","database-arrow-up","arrow-right-from-line","flame-kindling","square-power","layout-panel-top","bring-to-front","layout-grid","layout-freeform","bell-plus","layout-dashboard","layers","laugh","folders","mail-warning","book-plus","land-plot","lamp-wall-up","chevrons-left-right","chart-line","file-lock","cast","circle-fading-plus","clock-10","undo-dot","target","list-filter-plus","key-square","drama","file-type-corner","baseline","martini","contrast","joystick","candy-off","iteration-cw","book-check","iteration-ccw","book-lock","inspection-panel","briefcase-medical","calendars","text-align-start","infinity","hop-off","warehouse","sticky-notes","drafting-compass","save-all","id-card-lanyard","ice-cream-cone","ice-cream-bowl","house-wifi","house-plug","fishing-rod","book-headphones","credit-card","house-heart","hotel","hospital","shredder","panel-bottom-open","heart-pulse","heart-off","heart-minus","balloon","map-pin-plus-inside","bookmark-x","badge-question-mark","pen","file-stack","candy-cane","heading-6","heading-5","gamepad-2","heading-3","heading-2","heading-1","haze","shield-minus","circle-off","dessert","eclipse","church","hard-drive-upload","cylinder","badge-japanese-yen","hard-drive-download","receipt-text","handbag","hand-platter","hand","hammer","file-output","disc-album","grip","arrow-down-0-1","captions","flashlight-off","grid-2x2-check","philippine-peso","badge-alert","globe-x","folder-pen","cross","git-pull-request-draft","chevron-right","sticky-note-minus","square-arrow-down-left","share-2","git-merge-conflict","git-compare","git-commit-vertical","git-commit-horizontal","clipboard","git-branch","chess-pawn","gift","briefcase-business","ghost","message-circle-reply","gauge","triangle-right","folder-clock","gamepad","fullscreen","type","webhook","folder-search-2","align-horizontal-distribute-start","folder-root","folder-open","pointer-off","turtle","camera","compass","folder-cog","git-pull-request","bluetooth-searching","arrow-up-to-line","squircle-dashed","clock-3","badge-percent","shuffle","flask-round","flask-conical-off","grid-2x2-plus","flag-off","box","fish","clock-1","file-heart","fire-extinguisher","space","film","file-x-corner","file-x","corner-up-left","clock-6","zodiac-scorpio","key-round","headphones","tv","contact","file-play","rss","file-minus","at-sign","map-pin-check-inside","sticky-note-off","music","handshake","fan","circle-user","copy-plus","factory","external-link","shrink","euro","equal-approximately","search-check","clipboard-check","columns-2","droplet-off","cloud-sync","align-center-vertical","dock","disc","diff","cloud-fog","mosque","diamond-minus","map-pin-house","package-check","chevron-first","pencil","component","list-x","currency","crosshair","corner-up-right","crop","clock-arrow-left","corner-right-down","copyright","badge-indian-rupee","copyleft","redo-dot","cookie","align-start-horizontal","chart-column-stacked","file-plus","git-pull-request-arrow","computer","decimals-arrow-right","bell-dot","folder-down","coins","club","align-horizontal-space-around","door-closed-locked","cloud-drizzle","diamond","blinds","clock-arrow-right","clock-9","book-search","git-branch-minus","clapperboard","recycle","mountain-snow","luggage","circle-arrow-out-down-left","bot-message-square","phone-outgoing","smartphone-charging","chevrons-down","train-track","chess-bishop","cherry","sticky-note-plus","chart-no-axes-column-increasing","chart-no-axes-column-decreasing","chart-network","chart-no-axes-combined","metronome","case-lower","arrow-down-1-0","caravan","candy","arrow-left-right","lightbulb-off","panels-top-left","beef-off","locate-off","annoyed","test-tube","brick-wall-fire","cooking-pot","boxes","boom-box","book-up","laptop-minimal-check","mail-open","square-function","baggage-claim","variable","arrow-right","archive-restore"},{if getcustomasset and not IS_GETCUSTOMASSET_BROKEN then getcustomasset("lucide-icons/1.png") else "rbxassetid://122605056588923",if getcustomasset and not IS_GETCUSTOMASSET_BROKEN then getcustomasset("lucide-icons/2.png") else "rbxassetid://87013611700945"},{[48]={{1,{24,24},{150,25}},{1,{24,24},{275,350}},{1,{24,24},{400,650}},{1,{24,24},{975,725}},{1,{24,24},{175,750}},{1,{24,24},{300,500}},{1,{24,24},{450,850}},{2,{24,24},{200,100}},{1,{24,24},{75,325}},{1,{24,24},{275,400}},{1,{24,24},{400,500}},{1,{24,24},{75,375}},{1,{24,24},{50,925}},{1,{24,24},{825,25}},{1,{24,24},{25,100}},{1,{24,24},{150,800}},{1,{24,24},{650,600}},{1,{24,24},{375,850}},{1,{24,24},{325,50}},{1,{24,24},{125,300}},{1,{24,24},{650,200}},{1,{24,24},{400,925}},{1,{24,24},{775,225}},{1,{24,24},{0,525}},{1,{24,24},{975,450}},{1,{24,24},{75,350}},{1,{24,24},{525,425}},{1,{24,24},{950,775}},{1,{24,24},{425,325}},{1,{24,24},{325,175}},{1,{24,24},{300,550}},{1,{24,24},{775,475}},{1,{24,24},{750,375}},{1,{24,24},{700,675}},{1,{24,24},{500,350}},{1,{24,24},{300,925}},{1,{24,24},{75,125}},{1,{24,24},{875,100}},{1,{24,24},{825,950}},{1,{24,24},{350,100}},{2,{24,24},{275,100}},{1,{24,24},{575,150}},{1,{24,24},{775,350}},{1,{24,24},{475,250}},{1,{24,24},{0,900}},{1,{24,24},{525,75}},{1,{24,24},{325,800}},{2,{24,24},{25,225}},{1,{24,24},{925,350}},{1,{24,24},{100,325}},{1,{24,24},{625,25}},{1,{24,24},{175,350}},{1,{24,24},{500,600}},{1,{24,24},{800,425}},{1,{24,24},{475,25}},{1,{24,24},{850,50}},{1,{24,24},{600,50}},{1,{24,24},{975,575}},{1,{24,24},{725,825}},{1,{24,24},{900,775}},{1,{24,24},{825,625}},{2,{24,24},{350,25}},{1,{24,24},{0,975}},{1,{24,24},{800,375}},{1,{24,24},{75,750}},{1,{24,24},{200,125}},{1,{24,24},{425,425}},{1,{24,24},{925,600}},{1,{24,24},{925,300}},{1,{24,24},{425,925}},{1,{24,24},{625,350}},{1,{24,24},{50,225}},{1,{24,24},{700,725}},{1,{24,24},{975,850}},{1,{24,24},{275,275}},{2,{24,24},{350,50}},{1,{24,24},{625,550}},{2,{24,24},{25,275}},{1,{24,24},{775,500}},{2,{24,24},{50,50}},{1,{24,24},{250,125}},{1,{24,24},{275,300}},{1,{24,24},{75,100}},{1,{24,24},{50,750}},{1,{24,24},{475,675}},{1,{24,24},{125,900}},{1,{24,24},{600,300}},{1,{24,24},{700,100}},{1,{24,24},{100,150}},{2,{24,24},{250,75}},{1,{24,24},{525,625}},{1,{24,24},{200,975}},{1,{24,24},{675,300}},{1,{24,24},{275,675}},{1,{24,24},{925,275}},{1,{24,24},{100,625}},{1,{24,24},{550,700}},{1,{24,24},{750,25}},{1,{24,24},{250,100}},{1,{24,24},{375,350}},{2,{24,24},{125,125}},{1,{24,24},{0,275}},{1,{24,24},{100,375}},{1,{24,24},{275,850}},{1,{24,24},{775,450}},{1,{24,24},{550,50}},{1,{24,24},{225,750}},{1,{24,24},{300,475}},{2,{24,24},{0,100}},{1,{24,24},{50,900}},{1,{24,24},{450,225}},{1,{24,24},{400,225}},{1,{24,24},{100,300}},{1,{24,24},{975,325}},{1,{24,24},{900,500}},{1,{24,24},{175,25}},{1,{24,24},{850,600}},{1,{24,24},{0,675}},{1,{24,24},{975,275}},{1,{24,24},{100,450}},{1,{24,24},{200,400}},{1,{24,24},{225,175}},{1,{24,24},{750,800}},{1,{24,24},{650,950}},{1,{24,24},{25,750}},{1,{24,24},{50,850}},{1,{24,24},{650,450}},{1,{24,24},{600,400}},{1,{24,24},{925,825}},{1,{24,24},{50,150}},{1,{24,24},{50,600}},{1,{24,24},{775,325}},{1,{24,24},{475,75}},{1,{24,24},{825,125}},{1,{24,24},{25,200}},{1,{24,24},{975,875}},{1,{24,24},{575,700}},{1,{24,24},{75,675}},{1,{24,24},{425,525}},{2,{24,24},{125,0}},{1,{24,24},{575,200}},{1,{24,24},{200,625}},{2,{24,24},{250,25}},{1,{24,24},{700,625}},{1,{24,24},{650,525}},{1,{24,24},{125,0}},{1,{24,24},{175,400}},{1,{24,24},{575,600}},{1,{24,24},{600,225}},{2,{24,24},{75,225}},{1,{24,24},{700,950}},{1,{24,24},{600,25}},{1,{24,24},{975,300}},{1,{24,24},{975,925}},{1,{24,24},{500,75}},{1,{24,24},{250,300}},{1,{24,24},{375,550}},{1,{24,24},{425,275}},{1,{24,24},{375,675}},{1,{24,24},{75,400}},{1,{24,24},{400,275}},{1,{24,24},{650,650}},{1,{24,24},{25,325}},{1,{24,24},{125,225}},{1,{24,24},{250,600}},{1,{24,24},{75,425}},{1,{24,24},{525,175}},{2,{24,24},{175,75}},{1,{24,24},{875,50}},{2,{24,24},{125,150}},{1,{24,24},{225,100}},{1,{24,24},{75,225}},{1,{24,24},{25,150}},{1,{24,24},{475,550}},{1,{24,24},{725,500}},{1,{24,24},{450,975}},{1,{24,24},{900,0}},{1,{24,24},{25,400}},{1,{24,24},{0,125}},{1,{24,24},{175,625}},{1,{24,24},{75,475}},{1,{24,24},{950,225}},{1,{24,24},{0,850}},{1,{24,24},{350,25}},{1,{24,24},{325,950}},{1,{24,24},{675,575}},{1,{24,24},{725,50}},{1,{24,24},{125,800}},{1,{24,24},{500,50}},{1,{24,24},{425,75}},{1,{24,24},{800,700}},{1,{24,24},{350,325}},{2,{24,24},{50,250}},{1,{24,24},{500,100}},{1,{24,24},{450,200}},{1,{24,24},{700,850}},{1,{24,24},{400,775}},{1,{24,24},{600,600}},{1,{24,24},{475,0}},{1,{24,24},{50,75}},{1,{24,24},{875,925}},{1,{24,24},{450,500}},{1,{24,24},{525,750}},{1,{24,24},{450,575}},{1,{24,24},{100,275}},{1,{24,24},{975,150}},{1,{24,24},{550,250}},{1,{24,24},{350,750}},{1,{24,24},{750,175}},{1,{24,24},{375,725}},{1,{24,24},{925,175}},{1,{24,24},{925,250}},{1,{24,24},{25,275}},{1,{24,24},{25,300}},{1,{24,24},{125,150}},{2,{24,24},{125,75}},{1,{24,24},{150,875}},{1,{24,24},{725,425}},{1,{24,24},{850,325}},{1,{24,24},{775,650}},{1,{24,24},{375,500}},{1,{24,24},{400,400}},{1,{24,24},{675,200}},{1,{24,24},{575,175}},{1,{24,24},{75,150}},{1,{24,24},{625,900}},{1,{24,24},{575,575}},{1,{24,24},{725,0}},{1,{24,24},{675,50}},{1,{24,24},{475,750}},{2,{24,24},{275,25}},{1,{24,24},{925,700}},{1,{24,24},{450,650}},{1,{24,24},{850,0}},{2,{24,24},{25,200}},{1,{24,24},{375,250}},{2,{24,24},{250,125}},{1,{24,24},{275,600}},{1,{24,24},{950,450}},{1,{24,24},{50,50}},{1,{24,24},{625,800}},{1,{24,24},{925,475}},{1,{24,24},{200,325}},{1,{24,24},{700,750}},{1,{24,24},{425,50}},{1,{24,24},{750,125}},{1,{24,24},{250,850}},{1,{24,24},{25,600}},{2,{24,24},{25,150}},{1,{24,24},{675,775}},{1,{24,24},{625,75}},{1,{24,24},{275,800}},{1,{24,24},{50,250}},{1,{24,24},{150,500}},{1,{24,24},{200,475}},{1,{24,24},{200,0}},{1,{24,24},{850,175}},{1,{24,24},{300,350}},{2,{24,24},{300,100}},{1,{24,24},{125,275}},{1,{24,24},{700,500}},{1,{24,24},{225,300}},{1,{24,24},{150,475}},{1,{24,24},{600,625}},{1,{24,24},{200,575}},{1,{24,24},{625,300}},{1,{24,24},{500,725}},{1,{24,24},{275,525}},{1,{24,24},{0,225}},{1,{24,24},{475,125}},{1,{24,24},{125,400}},{1,{24,24},{125,450}},{1,{24,24},{175,900}},{1,{24,24},{100,725}},{1,{24,24},{425,400}},{1,{24,24},{600,875}},{1,{24,24},{900,375}},{1,{24,24},{225,225}},{2,{24,24},{0,325}},{1,{24,24},{575,550}},{1,{24,24},{75,275}},{1,{24,24},{175,550}},{1,{24,24},{50,625}},{1,{24,24},{525,875}},{1,{24,24},{425,650}},{1,{24,24},{875,525}},{1,{24,24},{825,550}},{1,{24,24},{125,75}},{2,{24,24},{0,250}},{1,{24,24},{800,50}},{1,{24,24},{950,650}},{1,{24,24},{950,725}},{1,{24,24},{825,825}},{1,{24,24},{225,325}},{1,{24,24},{500,400}},{1,{24,24},{75,300}},{1,{24,24},{200,600}},{1,{24,24},{925,200}},{1,{24,24},{500,550}},{1,{24,24},{400,325}},{1,{24,24},{125,700}},{1,{24,24},{175,50}},{1,{24,24},{375,450}},{1,{24,24},{200,550}},{1,{24,24},{675,675}},{1,{24,24},{275,225}},{1,{24,24},{175,725}},{1,{24,24},{725,25}},{1,{24,24},{300,375}},{1,{24,24},{850,150}},{1,{24,24},{850,975}},{1,{24,24},{275,625}},{1,{24,24},{50,400}},{1,{24,24},{500,525}},{1,{24,24},{275,125}},{2,{24,24},{50,175}},{1,{24,24},{175,425}},{1,{24,24},{800,125}},{1,{24,24},{525,225}},{1,{24,24},{200,150}},{1,{24,24},{175,0}},{1,{24,24},{325,200}},{1,{24,24},{425,675}},{1,{24,24},{175,275}},{1,{24,24},{675,900}},{1,{24,24},{300,275}},{1,{24,24},{375,125}},{1,{24,24},{175,775}},{1,{24,24},{550,125}},{1,{24,24},{50,275}},{1,{24,24},{800,350}},{1,{24,24},{250,25}},{1,{24,24},{225,550}},{2,{24,24},{50,275}},{1,{24,24},{725,575}},{1,{24,24},{150,400}},{1,{24,24},{175,575}},{1,{24,24},{225,675}},{1,{24,24},{250,225}},{1,{24,24},{650,500}},{1,{24,24},{750,950}},{1,{24,24},{675,750}},{1,{24,24},{800,600}},{1,{24,24},{975,200}},{1,{24,24},{375,875}},{1,{24,24},{300,325}},{1,{24,24},{525,0}},{1,{24,24},{175,375}},{1,{24,24},{450,600}},{1,{24,24},{900,725}},{1,{24,24},{675,450}},{1,{24,24},{200,50}},{1,{24,24},{725,850}},{1,{24,24},{50,675}},{1,{24,24},{675,975}},{1,{24,24},{850,625}},{1,{24,24},{450,475}},{1,{24,24},{275,425}},{1,{24,24},{200,350}},{1,{24,24},{175,700}},{1,{24,24},{325,25}},{1,{24,24},{100,675}},{1,{24,24},{550,350}},{1,{24,24},{925,75}},{1,{24,24},{850,375}},{1,{24,24},{525,125}},{1,{24,24},{375,750}},{1,{24,24},{975,500}},{1,{24,24},{675,125}},{1,{24,24},{575,275}},{2,{24,24},{25,100}},{1,{24,24},{725,225}},{1,{24,24},{225,125}},{2,{24,24},{375,50}},{2,{24,24},{400,25}},{2,{24,24},{425,0}},{1,{24,24},{350,900}},{1,{24,24},{425,550}},{1,{24,24},{325,300}},{1,{24,24},{375,575}},{1,{24,24},{225,725}},{2,{24,24},{50,350}},{1,{24,24},{475,575}},{1,{24,24},{675,850}},{1,{24,24},{150,550}},{1,{24,24},{250,575}},{1,{24,24},{800,575}},{1,{24,24},{450,425}},{1,{24,24},{550,875}},{1,{24,24},{325,500}},{2,{24,24},{75,325}},{1,{24,24},{300,850}},{1,{24,24},{50,650}},{1,{24,24},{925,900}},{1,{24,24},{825,525}},{1,{24,24},{950,950}},{2,{24,24},{125,275}},{1,{24,24},{125,550}},{2,{24,24},{150,250}},{2,{24,24},{175,225}},{1,{24,24},{575,475}},{1,{24,24},{375,700}},{1,{24,24},{475,350}},{1,{24,24},{850,700}},{1,{24,24},{700,50}},{1,{24,24},{225,575}},{1,{24,24},{425,475}},{1,{24,24},{775,900}},{1,{24,24},{950,550}},{1,{24,24},{375,825}},{2,{24,24},{250,150}},{1,{24,24},{875,350}},{2,{24,24},{100,50}},{2,{24,24},{275,125}},{1,{24,24},{525,100}},{1,{24,24},{500,850}},{1,{24,24},{150,375}},{1,{24,24},{125,375}},{1,{24,24},{400,200}},{2,{24,24},{375,25}},{2,{24,24},{0,75}},{1,{24,24},{75,0}},{1,{24,24},{850,825}},{1,{24,24},{75,725}},{1,{24,24},{900,600}},{2,{24,24},{25,350}},{1,{24,24},{575,300}},{1,{24,24},{550,150}},{1,{24,24},{225,400}},{1,{24,24},{275,200}},{2,{24,24},{50,325}},{1,{24,24},{475,200}},{1,{24,24},{550,400}},{1,{24,24},{525,200}},{1,{24,24},{425,775}},{1,{24,24},{175,475}},{2,{24,24},{100,275}},{2,{24,24},{75,300}},{1,{24,24},{775,825}},{1,{24,24},{150,125}},{1,{24,24},{850,100}},{1,{24,24},{600,325}},{1,{24,24},{500,25}},{1,{24,24},{50,375}},{1,{24,24},{50,725}},{1,{24,24},{325,875}},{2,{24,24},{150,225}},{1,{24,24},{225,875}},{1,{24,24},{875,400}},{1,{24,24},{825,250}},{1,{24,24},{25,900}},{1,{24,24},{575,125}},{1,{24,24},{525,350}},{2,{24,24},{225,150}},{1,{24,24},{225,200}},{2,{24,24},{325,50}},{1,{24,24},{875,825}},{1,{24,24},{475,650}},{2,{24,24},{150,25}},{1,{24,24},{125,600}},{1,{24,24},{0,375}},{2,{24,24},{175,200}},{2,{24,24},{175,175}},{1,{24,24},{675,150}},{2,{24,24},{25,325}},{1,{24,24},{0,550}},{2,{24,24},{0,350}},{2,{24,24},{75,275}},{1,{24,24},{175,250}},{1,{24,24},{200,450}},{2,{24,24},{50,300}},{1,{24,24},{75,200}},{1,{24,24},{100,200}},{1,{24,24},{350,550}},{1,{24,24},{225,650}},{1,{24,24},{775,150}},{2,{24,24},{375,0}},{1,{24,24},{825,325}},{1,{24,24},{425,375}},{2,{24,24},{100,25}},{2,{24,24},{150,200}},{2,{24,24},{275,0}},{2,{24,24},{200,150}},{2,{24,24},{175,0}},{1,{24,24},{150,525}},{1,{24,24},{0,175}},{2,{24,24},{225,125}},{2,{24,24},{250,100}},{2,{24,24},{275,75}},{1,{24,24},{250,0}},{1,{24,24},{500,175}},{1,{24,24},{550,25}},{2,{24,24},{0,225}},{1,{24,24},{400,750}},{1,{24,24},{125,250}},{1,{24,24},{400,525}},{1,{24,24},{250,950}},{1,{24,24},{375,800}},{2,{24,24},{325,25}},{2,{24,24},{50,25}},{2,{24,24},{350,0}},{1,{24,24},{325,675}},{2,{24,24},{75,250}},{1,{24,24},{75,250}},{2,{24,24},{100,225}},{2,{24,24},{150,175}},{2,{24,24},{175,150}},{1,{24,24},{675,225}},{1,{24,24},{675,650}},{2,{24,24},{125,200}},{1,{24,24},{625,200}},{2,{24,24},{200,125}},{1,{24,24},{600,750}},{2,{24,24},{275,50}},{1,{24,24},{950,475}},{1,{24,24},{700,575}},{1,{24,24},{750,350}},{2,{24,24},{325,0}},{1,{24,24},{150,100}},{1,{24,24},{400,975}},{1,{24,24},{450,400}},{2,{24,24},{225,100}},{2,{24,24},{25,0}},{1,{24,24},{800,725}},{1,{24,24},{625,175}},{1,{24,24},{825,0}},{1,{24,24},{150,75}},{1,{24,24},{475,925}},{1,{24,24},{850,125}},{2,{24,24},{0,300}},{1,{24,24},{625,850}},{2,{24,24},{50,125}},{2,{24,24},{100,200}},{1,{24,24},{425,625}},{1,{24,24},{750,900}},{1,{24,24},{525,800}},{2,{24,24},{150,150}},{1,{24,24},{625,0}},{2,{24,24},{225,75}},{1,{24,24},{550,175}},{1,{24,24},{125,625}},{2,{24,24},{125,250}},{2,{24,24},{0,275}},{1,{24,24},{300,725}},{1,{24,24},{275,100}},{1,{24,24},{425,250}},{2,{24,24},{50,225}},{1,{24,24},{400,250}},{1,{24,24},{900,700}},{1,{24,24},{225,775}},{1,{24,24},{250,350}},{2,{24,24},{75,200}},{1,{24,24},{825,800}},{2,{24,24},{100,175}},{1,{24,24},{0,0}},{1,{24,24},{300,450}},{1,{24,24},{775,850}},{2,{24,24},{175,100}},{2,{24,24},{150,125}},{2,{24,24},{225,50}},{2,{24,24},{50,200}},{2,{24,24},{75,175}},{1,{24,24},{850,225}},{1,{24,24},{375,625}},{1,{24,24},{300,75}},{1,{24,24},{975,625}},{1,{24,24},{50,800}},{1,{24,24},{625,500}},{1,{24,24},{400,25}},{1,{24,24},{375,950}},{1,{24,24},{425,450}},{2,{24,24},{200,50}},{1,{24,24},{850,725}},{2,{24,24},{225,25}},{1,{24,24},{450,550}},{1,{24,24},{500,0}},{1,{24,24},{950,525}},{1,{24,24},{775,675}},{2,{24,24},{250,0}},{1,{24,24},{75,650}},{2,{24,24},{75,150}},{1,{24,24},{575,975}},{2,{24,24},{100,125}},{1,{24,24},{750,425}},{1,{24,24},{300,0}},{1,{24,24},{200,375}},{1,{24,24},{925,650}},{1,{24,24},{725,750}},{1,{24,24},{0,625}},{2,{24,24},{200,75}},{1,{24,24},{200,875}},{2,{24,24},{200,25}},{2,{24,24},{225,0}},{1,{24,24},{700,825}},{2,{24,24},{0,200}},{2,{24,24},{50,150}},{1,{24,24},{625,925}},{1,{24,24},{75,50}},{2,{24,24},{75,125}},{1,{24,24},{300,525}},{1,{24,24},{725,375}},{1,{24,24},{525,50}},{2,{24,24},{100,100}},{1,{24,24},{875,150}},{1,{24,24},{450,375}},{2,{24,24},{200,0}},{2,{24,24},{150,50}},{2,{24,24},{0,175}},{1,{24,24},{325,350}},{2,{24,24},{125,175}},{1,{24,24},{150,850}},{2,{24,24},{100,75}},{1,{24,24},{525,400}},{1,{24,24},{725,150}},{1,{24,24},{75,950}},{1,{24,24},{550,325}},{1,{24,24},{225,425}},{1,{24,24},{50,0}},{1,{24,24},{150,750}},{1,{24,24},{825,725}},{1,{24,24},{100,100}},{2,{24,24},{25,125}},{1,{24,24},{900,825}},{2,{24,24},{50,100}},{2,{24,24},{75,75}},{2,{24,24},{125,25}},{1,{24,24},{250,675}},{1,{24,24},{600,800}},{1,{24,24},{275,375}},{2,{24,24},{50,75}},{2,{24,24},{150,0}},{1,{24,24},{975,125}},{1,{24,24},{0,750}},{1,{24,24},{25,650}},{2,{24,24},{75,50}},{2,{24,24},{25,25}},{2,{24,24},{75,25}},{1,{24,24},{750,625}},{1,{24,24},{100,800}},{1,{24,24},{350,125}},{2,{24,24},{25,50}},{1,{24,24},{200,425}},{1,{24,24},{125,325}},{2,{24,24},{25,75}},{1,{24,24},{875,425}},{1,{24,24},{900,250}},{2,{24,24},{50,0}},{2,{24,24},{0,25}},{2,{24,24},{0,0}},{1,{24,24},{850,475}},{1,{24,24},{975,950}},{1,{24,24},{750,150}},{1,{24,24},{950,975}},{1,{24,24},{425,500}},{1,{24,24},{625,950}},{1,{24,24},{825,100}},{1,{24,24},{925,975}},{2,{24,24},{100,300}},{1,{24,24},{900,975}},{1,{24,24},{925,950}},{1,{24,24},{0,300}},{1,{24,24},{100,775}},{1,{24,24},{875,900}},{1,{24,24},{975,900}},{1,{24,24},{900,950}},{1,{24,24},{575,350}},{1,{24,24},{375,175}},{1,{24,24},{300,400}},{1,{24,24},{975,650}},{1,{24,24},{500,775}},{1,{24,24},{875,975}},{1,{24,24},{400,600}},{1,{24,24},{775,300}},{1,{24,24},{0,475}},{1,{24,24},{950,900}},{1,{24,24},{825,200}},{1,{24,24},{825,50}},{1,{24,24},{425,575}},{1,{24,24},{900,925}},{1,{24,24},{175,175}},{1,{24,24},{0,425}},{1,{24,24},{850,750}},{1,{24,24},{725,325}},{1,{24,24},{975,425}},{1,{24,24},{475,325}},{1,{24,24},{500,700}},{1,{24,24},{950,850}},{1,{24,24},{975,825}},{1,{24,24},{250,925}},{1,{24,24},{50,325}},{1,{24,24},{600,775}},{1,{24,24},{775,625}},{1,{24,24},{925,875}},{1,{24,24},{800,975}},{1,{24,24},{475,625}},{1,{24,24},{950,925}},{1,{24,24},{675,550}},{1,{24,24},{775,75}},{1,{24,24},{450,125}},{1,{24,24},{950,825}},{1,{24,24},{925,850}},{1,{24,24},{275,725}},{1,{24,24},{775,975}},{1,{24,24},{800,950}},{1,{24,24},{100,850}},{1,{24,24},{825,925}},{1,{24,24},{150,250}},{1,{24,24},{850,900}},{1,{24,24},{975,775}},{1,{24,24},{900,850}},{1,{24,24},{600,700}},{1,{24,24},{75,450}},{1,{24,24},{950,800}},{1,{24,24},{750,975}},{1,{24,24},{325,125}},{1,{24,24},{750,275}},{1,{24,24},{200,200}},{1,{24,24},{125,650}},{1,{24,24},{800,925}},{1,{24,24},{350,500}},{1,{24,24},{950,300}},{1,{24,24},{775,275}},{1,{24,24},{875,850}},{1,{24,24},{575,900}},{1,{24,24},{500,150}},{1,{24,24},{350,0}},{1,{24,24},{575,825}},{1,{24,24},{975,750}},{1,{24,24},{425,25}},{1,{24,24},{775,925}},{1,{24,24},{825,875}},{1,{24,24},{625,750}},{1,{24,24},{600,725}},{1,{24,24},{900,800}},{1,{24,24},{675,400}},{1,{24,24},{925,775}},{1,{24,24},{950,750}},{1,{24,24},{700,975}},{1,{24,24},{725,950}},{1,{24,24},{500,200}},{1,{24,24},{100,400}},{1,{24,24},{100,0}},{1,{24,24},{850,850}},{1,{24,24},{200,850}},{1,{24,24},{750,925}},{1,{24,24},{600,900}},{1,{24,24},{550,775}},{1,{24,24},{0,350}},{1,{24,24},{350,150}},{1,{24,24},{825,850}},{2,{24,24},{0,375}},{1,{24,24},{750,750}},{1,{24,24},{25,0}},{1,{24,24},{700,25}},{1,{24,24},{925,750}},{1,{24,24},{725,925}},{2,{24,24},{175,125}},{1,{24,24},{700,375}},{2,{24,24},{225,175}},{1,{24,24},{600,250}},{1,{24,24},{400,450}},{1,{24,24},{800,850}},{1,{24,24},{300,300}},{1,{24,24},{850,800}},{1,{24,24},{875,775}},{1,{24,24},{0,575}},{1,{24,24},{250,150}},{1,{24,24},{150,975}},{1,{24,24},{925,725}},{1,{24,24},{750,700}},{1,{24,24},{500,500}},{1,{24,24},{350,200}},{1,{24,24},{700,325}},{1,{24,24},{150,725}},{1,{24,24},{650,975}},{1,{24,24},{125,925}},{1,{24,24},{100,350}},{1,{24,24},{600,200}},{1,{24,24},{475,400}},{1,{24,24},{650,50}},{1,{24,24},{350,75}},{1,{24,24},{175,850}},{1,{24,24},{375,225}},{1,{24,24},{475,375}},{1,{24,24},{675,275}},{1,{24,24},{450,0}},{1,{24,24},{375,775}},{1,{24,24},{750,875}},{1,{24,24},{125,675}},{1,{24,24},{975,675}},{1,{24,24},{250,775}},{1,{24,24},{800,825}},{1,{24,24},{850,775}},{1,{24,24},{950,675}},{1,{24,24},{300,200}},{1,{24,24},{900,75}},{1,{24,24},{575,800}},{1,{24,24},{875,500}},{1,{24,24},{300,800}},{1,{24,24},{875,750}},{1,{24,24},{675,925}},{1,{24,24},{700,900}},{1,{24,24},{450,75}},{1,{24,24},{725,200}},{1,{24,24},{725,875}},{1,{24,24},{925,550}},{1,{24,24},{975,50}},{1,{24,24},{325,375}},{1,{24,24},{575,250}},{1,{24,24},{950,875}},{1,{24,24},{175,125}},{1,{24,24},{275,150}},{1,{24,24},{925,675}},{1,{24,24},{350,625}},{1,{24,24},{125,350}},{1,{24,24},{275,925}},{1,{24,24},{575,450}},{1,{24,24},{250,900}},{1,{24,24},{650,925}},{1,{24,24},{700,875}},{1,{24,24},{750,825}},{1,{24,24},{550,0}},{1,{24,24},{775,800}},{1,{24,24},{25,375}},{1,{24,24},{0,600}},{1,{24,24},{625,250}},{1,{24,24},{800,775}},{1,{24,24},{600,100}},{1,{24,24},{825,750}},{1,{24,24},{350,400}},{1,{24,24},{225,800}},{1,{24,24},{925,100}},{1,{24,24},{900,675}},{1,{24,24},{700,150}},{1,{24,24},{175,225}},{1,{24,24},{600,475}},{1,{24,24},{0,250}},{1,{24,24},{275,250}},{1,{24,24},{400,50}},{1,{24,24},{675,625}},{1,{24,24},{0,500}},{1,{24,24},{475,875}},{1,{24,24},{300,900}},{1,{24,24},{525,550}},{1,{24,24},{600,925}},{2,{24,24},{125,100}},{1,{24,24},{900,175}},{1,{24,24},{950,625}},{1,{24,24},{525,725}},{1,{24,24},{550,500}},{1,{24,24},{275,50}},{1,{24,24},{975,600}},{1,{24,24},{200,500}},{1,{24,24},{500,650}},{1,{24,24},{475,850}},{1,{24,24},{125,25}},{1,{24,24},{275,500}},{1,{24,24},{0,200}},{1,{24,24},{675,425}},{1,{24,24},{975,400}},{1,{24,24},{650,900}},{1,{24,24},{825,700}},{1,{24,24},{150,825}},{1,{24,24},{800,500}},{1,{24,24},{325,750}},{1,{24,24},{775,175}},{1,{24,24},{325,600}},{1,{24,24},{800,750}},{1,{24,24},{975,0}},{2,{24,24},{200,200}},{2,{24,24},{300,75}},{1,{24,24},{900,650}},{1,{24,24},{625,100}},{1,{24,24},{875,0}},{1,{24,24},{900,50}},{1,{24,24},{200,525}},{1,{24,24},{75,75}},{1,{24,24},{925,625}},{1,{24,24},{950,600}},{1,{24,24},{650,850}},{1,{24,24},{50,500}},{1,{24,24},{950,575}},{1,{24,24},{100,175}},{1,{24,24},{325,75}},{1,{24,24},{650,875}},{2,{24,24},{25,175}},{1,{24,24},{725,800}},{1,{24,24},{575,675}},{1,{24,24},{475,425}},{1,{24,24},{775,750}},{1,{24,24},{225,250}},{1,{24,24},{725,600}},{1,{24,24},{525,600}},{1,{24,24},{650,700}},{1,{24,24},{300,625}},{1,{24,24},{875,650}},{1,{24,24},{900,625}},{1,{24,24},{575,950}},{1,{24,24},{250,825}},{1,{24,24},{200,950}},{1,{24,24},{975,550}},{1,{24,24},{250,650}},{1,{24,24},{550,950}},{1,{24,24},{450,950}},{1,{24,24},{375,300}},{1,{24,24},{125,175}},{1,{24,24},{625,875}},{1,{24,24},{550,975}},{1,{24,24},{675,825}},{1,{24,24},{700,800}},{1,{24,24},{0,650}},{1,{24,24},{875,800}},{1,{24,24},{925,375}},{1,{24,24},{500,975}},{1,{24,24},{525,375}},{1,{24,24},{850,75}},{1,{24,24},{600,150}},{1,{24,24},{175,200}},{1,{24,24},{800,325}},{1,{24,24},{750,450}},{1,{24,24},{800,675}},{1,{24,24},{50,175}},{1,{24,24},{825,675}},{1,{24,24},{375,375}},{1,{24,24},{50,475}},{1,{24,24},{250,425}},{1,{24,24},{800,400}},{1,{24,24},{450,100}},{1,{24,24},{250,475}},{1,{24,24},{350,250}},{1,{24,24},{875,725}},{2,{24,24},{400,0}},{1,{24,24},{925,575}},{1,{24,24},{975,525}},{1,{24,24},{475,975}},{1,{24,24},{0,875}},{1,{24,24},{900,400}},{1,{24,24},{650,825}},{1,{24,24},{150,275}},{1,{24,24},{675,800}},{1,{24,24},{700,775}},{1,{24,24},{875,300}},{1,{24,24},{450,150}},{2,{24,24},{150,75}},{1,{24,24},{650,625}},{1,{24,24},{750,725}},{1,{24,24},{450,800}},{2,{24,24},{125,225}},{1,{24,24},{100,475}},{1,{24,24},{775,725}},{1,{24,24},{375,475}},{1,{24,24},{125,525}},{1,{24,24},{825,650}},{1,{24,24},{875,600}},{1,{24,24},{900,575}},{1,{24,24},{475,600}},{1,{24,24},{800,800}},{1,{24,24},{500,950}},{1,{24,24},{75,550}},{1,{24,24},{525,950}},{1,{24,24},{350,700}},{1,{24,24},{550,900}},{1,{24,24},{650,275}},{1,{24,24},{575,875}},{1,{24,24},{0,75}},{1,{24,24},{100,875}},{1,{24,24},{275,550}},{1,{24,24},{175,300}},{1,{24,24},{850,350}},{1,{24,24},{200,250}},{1,{24,24},{500,825}},{1,{24,24},{50,550}},{1,{24,24},{325,250}},{1,{24,24},{200,700}},{1,{24,24},{950,175}},{1,{24,24},{900,200}},{1,{24,24},{650,800}},{1,{24,24},{725,725}},{1,{24,24},{800,650}},{1,{24,24},{675,175}},{1,{24,24},{875,575}},{1,{24,24},{775,425}},{1,{24,24},{600,350}},{1,{24,24},{900,550}},{1,{24,24},{575,375}},{1,{24,24},{750,500}},{1,{24,24},{825,275}},{1,{24,24},{400,375}},{1,{24,24},{300,425}},{1,{24,24},{550,75}},{1,{24,24},{25,25}},{1,{24,24},{0,325}},{1,{24,24},{475,775}},{1,{24,24},{950,500}},{1,{24,24},{275,450}},{1,{24,24},{625,275}},{1,{24,24},{175,650}},{1,{24,24},{100,650}},{1,{24,24},{725,125}},{1,{24,24},{450,825}},{1,{24,24},{275,325}},{1,{24,24},{500,925}},{1,{24,24},{100,425}},{1,{24,24},{100,75}},{1,{24,24},{975,25}},{2,{24,24},{300,50}},{1,{24,24},{825,900}},{1,{24,24},{650,775}},{1,{24,24},{725,700}},{1,{24,24},{800,625}},{1,{24,24},{100,550}},{1,{24,24},{825,600}},{1,{24,24},{850,575}},{1,{24,24},{875,550}},{1,{24,24},{50,975}},{1,{24,24},{650,325}},{1,{24,24},{925,500}},{2,{24,24},{300,25}},{1,{24,24},{300,100}},{1,{24,24},{800,550}},{1,{24,24},{575,925}},{1,{24,24},{400,125}},{1,{24,24},{675,250}},{1,{24,24},{425,975}},{1,{24,24},{25,500}},{1,{24,24},{500,900}},{1,{24,24},{750,675}},{1,{24,24},{550,850}},{1,{24,24},{725,975}},{1,{24,24},{450,25}},{1,{24,24},{800,250}},{1,{24,24},{150,175}},{1,{24,24},{250,175}},{1,{24,24},{475,525}},{1,{24,24},{600,125}},{1,{24,24},{700,125}},{1,{24,24},{250,75}},{1,{24,24},{975,700}},{1,{24,24},{625,775}},{1,{24,24},{675,725}},{1,{24,24},{150,700}},{1,{24,24},{725,675}},{1,{24,24},{700,700}},{1,{24,24},{725,650}},{1,{24,24},{825,575}},{1,{24,24},{850,550}},{1,{24,24},{750,650}},{1,{24,24},{850,950}},{1,{24,24},{550,200}},{1,{24,24},{450,925}},{1,{24,24},{475,900}},{1,{24,24},{675,475}},{1,{24,24},{875,225}},{1,{24,24},{800,450}},{1,{24,24},{425,850}},{1,{24,24},{650,250}},{1,{24,24},{500,875}},{1,{24,24},{825,775}},{1,{24,24},{550,825}},{1,{24,24},{425,950}},{1,{24,24},{950,75}},{1,{24,24},{625,975}},{1,{24,24},{650,725}},{1,{24,24},{0,725}},{1,{24,24},{550,675}},{1,{24,24},{450,625}},{1,{24,24},{475,50}},{1,{24,24},{800,900}},{1,{24,24},{175,875}},{1,{24,24},{875,375}},{2,{24,24},{100,0}},{1,{24,24},{325,150}},{1,{24,24},{525,450}},{1,{24,24},{850,525}},{1,{24,24},{25,550}},{1,{24,24},{625,50}},{1,{24,24},{475,825}},{1,{24,24},{525,250}},{1,{24,24},{325,825}},{1,{24,24},{950,425}},{1,{24,24},{400,0}},{1,{24,24},{375,975}},{1,{24,24},{400,950}},{1,{24,24},{0,400}},{1,{24,24},{775,600}},{1,{24,24},{325,475}},{1,{24,24},{350,600}},{1,{24,24},{975,350}},{1,{24,24},{750,475}},{1,{24,24},{525,325}},{1,{24,24},{525,825}},{1,{24,24},{625,225}},{1,{24,24},{500,300}},{1,{24,24},{575,775}},{1,{24,24},{275,175}},{1,{24,24},{575,425}},{2,{24,24},{325,75}},{1,{24,24},{850,675}},{1,{24,24},{700,650}},{1,{24,24},{725,625}},{1,{24,24},{750,600}},{1,{24,24},{625,400}},{1,{24,24},{775,575}},{1,{24,24},{300,825}},{1,{24,24},{300,775}},{1,{24,24},{100,750}},{1,{24,24},{575,50}},{1,{24,24},{125,975}},{1,{24,24},{900,450}},{1,{24,24},{325,275}},{1,{24,24},{925,425}},{1,{24,24},{25,225}},{1,{24,24},{950,400}},{1,{24,24},{975,375}},{1,{24,24},{275,875}},{1,{24,24},{650,225}},{1,{24,24},{550,375}},{1,{24,24},{350,975}},{1,{24,24},{375,400}},{1,{24,24},{750,575}},{1,{24,24},{450,875}},{1,{24,24},{800,875}},{1,{24,24},{575,750}},{1,{24,24},{625,700}},{1,{24,24},{550,275}},{1,{24,24},{600,850}},{1,{24,24},{575,225}},{1,{24,24},{450,675}},{1,{24,24},{550,600}},{1,{24,24},{425,350}},{1,{24,24},{225,450}},{1,{24,24},{175,500}},{1,{24,24},{425,900}},{1,{24,24},{100,225}},{1,{24,24},{825,375}},{1,{24,24},{50,350}},{1,{24,24},{675,375}},{1,{24,24},{25,625}},{1,{24,24},{275,575}},{1,{24,24},{950,25}},{1,{24,24},{575,525}},{1,{24,24},{300,600}},{1,{24,24},{275,825}},{1,{24,24},{775,550}},{1,{24,24},{975,975}},{1,{24,24},{825,500}},{1,{24,24},{225,25}},{1,{24,24},{900,425}},{1,{24,24},{650,175}},{1,{24,24},{925,400}},{1,{24,24},{950,375}},{1,{24,24},{875,450}},{1,{24,24},{450,900}},{1,{24,24},{325,975}},{1,{24,24},{800,100}},{1,{24,24},{225,975}},{1,{24,24},{350,950}},{1,{24,24},{400,900}},{1,{24,24},{525,650}},{1,{24,24},{525,775}},{1,{24,24},{375,925}},{1,{24,24},{775,775}},{1,{24,24},{375,150}},{1,{24,24},{950,200}},{1,{24,24},{600,425}},{1,{24,24},{900,475}},{1,{24,24},{225,475}},{1,{24,24},{525,975}},{1,{24,24},{150,325}},{1,{24,24},{775,100}},{1,{24,24},{575,725}},{1,{24,24},{625,675}},{1,{24,24},{550,800}},{1,{24,24},{175,100}},{1,{24,24},{775,525}},{1,{24,24},{425,875}},{2,{24,24},{250,50}},{1,{24,24},{325,225}},{1,{24,24},{850,450}},{1,{24,24},{550,925}},{1,{24,24},{25,350}},{1,{24,24},{700,250}},{1,{24,24},{850,425}},{1,{24,24},{250,400}},{1,{24,24},{950,350}},{1,{24,24},{300,975}},{1,{24,24},{900,350}},{1,{24,24},{400,875}},{1,{24,24},{350,925}},{1,{24,24},{475,800}},{1,{24,24},{925,925}},{1,{24,24},{175,75}},{1,{24,24},{550,725}},{1,{24,24},{600,675}},{1,{24,24},{625,650}},{1,{24,24},{300,50}},{1,{24,24},{675,600}},{1,{24,24},{750,300}},{1,{24,24},{750,525}},{1,{24,24},{825,450}},{1,{24,24},{650,475}},{1,{24,24},{225,50}},{1,{24,24},{800,475}},{1,{24,24},{700,600}},{2,{24,24},{200,175}},{1,{24,24},{125,775}},{1,{24,24},{650,400}},{1,{24,24},{300,950}},{1,{24,24},{325,925}},{1,{24,24},{550,450}},{1,{24,24},{425,825}},{1,{24,24},{400,850}},{1,{24,24},{500,750}},{1,{24,24},{600,650}},{1,{24,24},{750,775}},{1,{24,24},{575,500}},{1,{24,24},{625,625}},{1,{24,24},{25,425}},{1,{24,24},{550,575}},{1,{24,24},{725,525}},{1,{24,24},{825,425}},{1,{24,24},{850,400}},{1,{24,24},{925,800}},{1,{24,24},{150,50}},{1,{24,24},{0,50}},{1,{24,24},{600,825}},{1,{24,24},{50,125}},{1,{24,24},{250,975}},{1,{24,24},{25,75}},{1,{24,24},{275,950}},{1,{24,24},{175,675}},{1,{24,24},{125,575}},{1,{24,24},{925,50}},{1,{24,24},{500,225}},{1,{24,24},{300,150}},{1,{24,24},{550,425}},{1,{24,24},{375,900}},{1,{24,24},{275,775}},{1,{24,24},{750,75}},{1,{24,24},{250,700}},{1,{24,24},{50,775}},{1,{24,24},{350,875}},{1,{24,24},{400,825}},{1,{24,24},{150,225}},{1,{24,24},{400,550}},{1,{24,24},{425,800}},{1,{24,24},{525,700}},{1,{24,24},{675,0}},{1,{24,24},{800,0}},{1,{24,24},{625,600}},{1,{24,24},{650,575}},{1,{24,24},{275,700}},{1,{24,24},{900,875}},{1,{24,24},{325,0}},{1,{24,24},{225,925}},{1,{24,24},{200,825}},{1,{24,24},{200,900}},{1,{24,24},{550,300}},{1,{24,24},{625,125}},{1,{24,24},{825,400}},{1,{24,24},{125,425}},{1,{24,24},{425,700}},{1,{24,24},{950,275}},{1,{24,24},{975,250}},{1,{24,24},{400,350}},{1,{24,24},{350,850}},{1,{24,24},{200,650}},{1,{24,24},{400,800}},{1,{24,24},{675,525}},{1,{24,24},{375,25}},{1,{24,24},{350,575}},{1,{24,24},{450,750}},{1,{24,24},{600,175}},{1,{24,24},{475,725}},{1,{24,24},{900,900}},{1,{24,24},{625,475}},{1,{24,24},{25,925}},{1,{24,24},{375,75}},{1,{24,24},{600,375}},{1,{24,24},{750,0}},{1,{24,24},{25,950}},{1,{24,24},{625,575}},{1,{24,24},{550,650}},{1,{24,24},{650,550}},{1,{24,24},{400,475}},{1,{24,24},{725,475}},{1,{24,24},{100,900}},{1,{24,24},{0,450}},{1,{24,24},{125,100}},{1,{24,24},{650,675}},{1,{24,24},{150,350}},{1,{24,24},{875,325}},{1,{24,24},{900,300}},{1,{24,24},{750,50}},{1,{24,24},{375,275}},{1,{24,24},{975,225}},{1,{24,24},{525,25}},{1,{24,24},{275,0}},{1,{24,24},{875,625}},{1,{24,24},{225,950}},{1,{24,24},{550,100}},{1,{24,24},{275,900}},{1,{24,24},{325,775}},{1,{24,24},{350,300}},{1,{24,24},{100,950}},{1,{24,24},{350,825}},{1,{24,24},{575,325}},{1,{24,24},{575,850}},{1,{24,24},{400,150}},{1,{24,24},{325,400}},{1,{24,24},{725,775}},{1,{24,24},{450,725}},{1,{24,24},{650,75}},{1,{24,24},{650,25}},{1,{24,24},{225,500}},{1,{24,24},{225,0}},{1,{24,24},{125,125}},{1,{24,24},{425,750}},{1,{24,24},{500,675}},{1,{24,24},{475,700}},{1,{24,24},{250,800}},{1,{24,24},{175,950}},{1,{24,24},{675,500}},{1,{24,24},{125,500}},{1,{24,24},{475,225}},{1,{24,24},{75,600}},{1,{24,24},{625,425}},{1,{24,24},{700,475}},{1,{24,24},{775,400}},{1,{24,24},{650,0}},{1,{24,24},{725,450}},{1,{24,24},{900,225}},{1,{24,24},{775,0}},{1,{24,24},{900,275}},{1,{24,24},{775,875}},{1,{24,24},{800,225}},{1,{24,24},{175,975}},{1,{24,24},{700,525}},{1,{24,24},{400,425}},{1,{24,24},{500,450}},{1,{24,24},{600,975}},{1,{24,24},{150,150}},{1,{24,24},{100,50}},{1,{24,24},{925,450}},{1,{24,24},{125,50}},{1,{24,24},{250,725}},{1,{24,24},{50,25}},{1,{24,24},{350,800}},{1,{24,24},{425,725}},{1,{24,24},{875,250}},{1,{24,24},{850,300}},{1,{24,24},{325,100}},{1,{24,24},{175,600}},{1,{24,24},{600,950}},{1,{24,24},{625,525}},{1,{24,24},{550,475}},{1,{24,24},{525,275}},{1,{24,24},{300,875}},{1,{24,24},{875,950}},{1,{24,24},{775,375}},{1,{24,24},{875,275}},{2,{24,24},{0,50}},{1,{24,24},{225,275}},{1,{24,24},{925,225}},{1,{24,24},{0,100}},{1,{24,24},{975,175}},{1,{24,24},{425,175}},{1,{24,24},{150,625}},{1,{24,24},{575,0}},{1,{24,24},{475,450}},{1,{24,24},{900,750}},{1,{24,24},{475,175}},{1,{24,24},{600,575}},{1,{24,24},{500,325}},{1,{24,24},{525,575}},{1,{24,24},{225,900}},{1,{24,24},{675,100}},{1,{24,24},{250,875}},{1,{24,24},{850,500}},{2,{24,24},{100,150}},{1,{24,24},{525,675}},{1,{24,24},{500,625}},{1,{24,24},{700,550}},{2,{24,24},{150,100}},{1,{24,24},{700,425}},{1,{24,24},{600,525}},{1,{24,24},{625,450}},{1,{24,24},{50,525}},{1,{24,24},{825,300}},{1,{24,24},{850,275}},{1,{24,24},{600,550}},{1,{24,24},{800,25}},{1,{24,24},{625,825}},{1,{24,24},{150,950}},{1,{24,24},{200,25}},{1,{24,24},{250,50}},{1,{24,24},{175,925}},{2,{24,24},{300,0}},{1,{24,24},{575,100}},{1,{24,24},{150,775}},{1,{24,24},{500,125}},{1,{24,24},{850,925}},{1,{24,24},{200,75}},{1,{24,24},{200,925}},{1,{24,24},{550,550}},{1,{24,24},{475,150}},{1,{24,24},{600,500}},{1,{24,24},{700,400}},{1,{24,24},{750,100}},{1,{24,24},{925,525}},{1,{24,24},{350,650}},{1,{24,24},{700,200}},{1,{24,24},{800,300}},{1,{24,24},{525,475}},{1,{24,24},{25,125}},{1,{24,24},{75,925}},{1,{24,24},{300,250}},{1,{24,24},{75,700}},{1,{24,24},{725,100}},{1,{24,24},{25,525}},{1,{24,24},{150,925}},{1,{24,24},{125,950}},{1,{24,24},{325,700}},{1,{24,24},{700,175}},{1,{24,24},{75,900}},{1,{24,24},{75,25}},{1,{24,24},{75,575}},{2,{24,24},{175,50}},{1,{24,24},{725,275}},{1,{24,24},{825,475}},{1,{24,24},{325,525}},{1,{24,24},{100,975}},{1,{24,24},{625,375}},{1,{24,24},{450,700}},{1,{24,24},{400,725}},{1,{24,24},{500,575}},{1,{24,24},{725,350}},{1,{24,24},{325,325}},{1,{24,24},{800,275}},{1,{24,24},{400,100}},{1,{24,24},{350,775}},{1,{24,24},{950,125}},{1,{24,24},{925,150}},{1,{24,24},{875,200}},{1,{24,24},{325,650}},{1,{24,24},{175,150}},{1,{24,24},{425,125}},{1,{24,24},{325,850}},{1,{24,24},{675,350}},{1,{24,24},{975,100}},{1,{24,24},{25,50}},{1,{24,24},{75,875}},{1,{24,24},{150,900}},{1,{24,24},{375,50}},{1,{24,24},{675,700}},{1,{24,24},{675,875}},{1,{24,24},{550,625}},{1,{24,24},{225,75}},{1,{24,24},{825,975}},{1,{24,24},{850,875}},{2,{24,24},{0,400}},{1,{24,24},{525,525}},{1,{24,24},{100,700}},{1,{24,24},{25,850}},{1,{24,24},{200,750}},{1,{24,24},{300,575}},{1,{24,24},{900,125}},{1,{24,24},{275,975}},{1,{24,24},{375,100}},{1,{24,24},{575,25}},{1,{24,24},{225,350}},{1,{24,24},{75,625}},{1,{24,24},{800,525}},{1,{24,24},{350,375}},{1,{24,24},{450,250}},{1,{24,24},{700,350}},{1,{24,24},{300,750}},{1,{24,24},{725,550}},{1,{24,24},{825,225}},{1,{24,24},{325,725}},{1,{24,24},{850,200}},{1,{24,24},{0,25}},{1,{24,24},{875,175}},{1,{24,24},{900,150}},{1,{24,24},{950,150}},{1,{24,24},{925,125}},{1,{24,24},{975,75}},{1,{24,24},{100,925}},{1,{24,24},{250,525}},{1,{24,24},{275,25}},{1,{24,24},{875,25}},{1,{24,24},{875,700}},{1,{24,24},{275,750}},{1,{24,24},{250,275}},{1,{24,24},{350,675}},{1,{24,24},{375,650}},{1,{24,24},{200,225}},{1,{24,24},{400,625}},{1,{24,24},{425,600}},{1,{24,24},{525,500}},{1,{24,24},{700,225}},{1,{24,24},{550,525}},{1,{24,24},{50,425}},{1,{24,24},{725,300}},{1,{24,24},{775,250}},{1,{24,24},{50,575}},{1,{24,24},{150,450}},{1,{24,24},{125,725}},{1,{24,24},{600,0}},{1,{24,24},{600,75}},{1,{24,24},{350,350}},{2,{24,24},{175,25}},{1,{24,24},{775,950}},{1,{24,24},{600,450}},{1,{24,24},{25,975}},{1,{24,24},{0,800}},{1,{24,24},{500,375}},{1,{24,24},{350,50}},{1,{24,24},{850,250}},{1,{24,24},{275,475}},{1,{24,24},{125,875}},{1,{24,24},{375,200}},{1,{24,24},{175,825}},{1,{24,24},{400,75}},{1,{24,24},{200,800}},{1,{24,24},{200,275}},{1,{24,24},{250,750}},{1,{24,24},{300,225}},{1,{24,24},{475,100}},{1,{24,24},{975,800}},{1,{24,24},{300,700}},{1,{24,24},{950,50}},{2,{24,24},{25,300}},{1,{24,24},{950,700}},{1,{24,24},{25,775}},{1,{24,24},{625,725}},{1,{24,24},{650,350}},{1,{24,24},{675,325}},{1,{24,24},{700,300}},{1,{24,24},{750,250}},{1,{24,24},{800,200}},{1,{24,24},{75,800}},{1,{24,24},{300,175}},{1,{24,24},{550,225}},{1,{24,24},{825,175}},{1,{24,24},{875,125}},{1,{24,24},{900,100}},{1,{24,24},{525,900}},{1,{24,24},{575,625}},{1,{24,24},{125,850}},{1,{24,24},{175,800}},{1,{24,24},{200,775}},{1,{24,24},{200,175}},{1,{24,24},{225,850}},{1,{24,24},{250,250}},{1,{24,24},{375,0}},{1,{24,24},{575,650}},{1,{24,24},{600,275}},{1,{24,24},{400,175}},{1,{24,24},{375,600}},{1,{24,24},{400,575}},{1,{24,24},{275,650}},{1,{24,24},{450,525}},{1,{24,24},{475,500}},{1,{24,24},{500,475}},{1,{24,24},{575,400}},{1,{24,24},{900,525}},{1,{24,24},{525,150}},{1,{24,24},{775,25}},{1,{24,24},{525,300}},{1,{24,24},{575,75}},{1,{24,24},{700,275}},{1,{24,24},{325,450}},{1,{24,24},{100,250}},{1,{24,24},{725,250}},{1,{24,24},{750,550}},{1,{24,24},{775,200}},{1,{24,24},{825,150}},{1,{24,24},{800,175}},{1,{24,24},{0,950}},{1,{24,24},{25,825}},{1,{24,24},{375,425}},{1,{24,24},{125,825}},{1,{24,24},{75,175}},{1,{24,24},{250,325}},{1,{24,24},{825,75}},{1,{24,24},{325,625}},{1,{24,24},{325,900}},{1,{24,24},{275,75}},{1,{24,24},{475,475}},{1,{24,24},{25,875}},{1,{24,24},{475,300}},{1,{24,24},{650,300}},{1,{24,24},{175,450}},{1,{24,24},{725,900}},{1,{24,24},{850,650}},{1,{24,24},{650,750}},{1,{24,24},{800,150}},{1,{24,24},{875,75}},{1,{24,24},{925,25}},{1,{24,24},{950,0}},{1,{24,24},{400,300}},{1,{24,24},{0,925}},{1,{24,24},{350,275}},{1,{24,24},{75,850}},{1,{24,24},{350,175}},{1,{24,24},{100,825}},{1,{24,24},{400,700}},{1,{24,24},{200,725}},{2,{24,24},{0,125}},{1,{24,24},{450,450}},{1,{24,24},{225,700}},{1,{24,24},{500,425}},{2,{24,24},{75,100}},{2,{24,24},{100,250}},{1,{24,24},{900,25}},{1,{24,24},{150,0}},{1,{24,24},{925,0}},{1,{24,24},{75,825}},{1,{24,24},{950,325}},{2,{24,24},{0,150}},{1,{24,24},{425,150}},{1,{24,24},{500,250}},{1,{24,24},{375,525}},{1,{24,24},{625,325}},{1,{24,24},{150,300}},{1,{24,24},{300,25}},{1,{24,24},{750,850}},{1,{24,24},{250,450}},{1,{24,24},{50,300}},{1,{24,24},{975,475}},{1,{24,24},{725,175}},{1,{24,24},{775,125}},{1,{24,24},{300,650}},{1,{24,24},{50,825}},{1,{24,24},{50,450}},{1,{24,24},{125,750}},{1,{24,24},{375,325}},{1,{24,24},{225,625}},{1,{24,24},{200,675}},{1,{24,24},{775,700}},{1,{24,24},{250,625}},{1,{24,24},{350,525}},{1,{24,24},{325,550}},{1,{24,24},{650,125}},{1,{24,24},{175,525}},{2,{24,24},{25,375}},{1,{24,24},{50,950}},{1,{24,24},{300,675}},{2,{24,24},{125,50}},{1,{24,24},{325,425}},{1,{24,24},{850,25}},{1,{24,24},{875,475}},{1,{24,24},{75,775}},{1,{24,24},{125,200}},{1,{24,24},{400,675}},{1,{24,24},{700,925}},{1,{24,24},{825,350}},{1,{24,24},{750,225}},{1,{24,24},{0,825}},{1,{24,24},{100,575}},{1,{24,24},{150,600}},{1,{24,24},{25,800}},{1,{24,24},{150,675}},{1,{24,24},{475,950}},{1,{24,24},{225,600}},{1,{24,24},{350,475}},{1,{24,24},{525,850}},{1,{24,24},{675,25}},{1,{24,24},{650,100}},{1,{24,24},{775,50}},{1,{24,24},{150,575}},{1,{24,24},{100,25}},{1,{24,24},{250,550}},{1,{24,24},{350,450}},{1,{24,24},{450,350}},{1,{24,24},{425,300}},{1,{24,24},{750,400}},{1,{24,24},{725,75}},{1,{24,24},{350,725}},{1,{24,24},{950,250}},{1,{24,24},{250,375}},{1,{24,24},{450,775}},{1,{24,24},{475,275}},{1,{24,24},{225,825}},{1,{24,24},{350,425}},{1,{24,24},{450,325}},{1,{24,24},{625,150}},{1,{24,24},{500,275}},{1,{24,24},{25,675}},{1,{24,24},{700,75}},{1,{24,24},{25,725}},{1,{24,24},{150,200}},{1,{24,24},{50,700}},{1,{24,24},{500,800}},{1,{24,24},{250,500}},{1,{24,24},{0,150}},{1,{24,24},{225,375}},{1,{24,24},{800,75}},{1,{24,24},{750,200}},{1,{24,24},{450,300}},{1,{24,24},{0,775}},{1,{24,24},{300,125}},{1,{24,24},{325,575}},{1,{24,24},{675,75}},{1,{24,24},{25,700}},{1,{24,24},{50,100}},{1,{24,24},{150,650}},{1,{24,24},{450,275}},{1,{24,24},{650,150}},{1,{24,24},{250,200}},{1,{24,24},{0,700}},{1,{24,24},{100,600}},{1,{24,24},{25,450}},{1,{24,24},{50,875}},{1,{24,24},{700,0}},{1,{24,24},{550,750}},{1,{24,24},{700,450}},{1,{24,24},{750,325}},{1,{24,24},{425,225}},{1,{24,24},{175,325}},{1,{24,24},{925,325}},{1,{24,24},{525,925}},{1,{24,24},{100,525}},{2,{24,24},{75,0}},{1,{24,24},{425,200}},{1,{24,24},{450,175}},{1,{24,24},{675,950}},{1,{24,24},{75,525}},{1,{24,24},{100,500}},{1,{24,24},{125,475}},{1,{24,24},{25,575}},{1,{24,24},{725,400}},{1,{24,24},{75,500}},{1,{24,24},{50,200}},{1,{24,24},{150,425}},{1,{24,24},{350,225}},{1,{24,24},{25,250}},{1,{24,24},{950,100}},{1,{24,24},{900,325}},{1,{24,24},{425,0}},{1,{24,24},{75,975}},{1,{24,24},{25,175}},{1,{24,24},{875,875}},{1,{24,24},{425,100}},{1,{24,24},{225,525}},{1,{24,24},{25,475}},{1,{24,24},{200,300}},{1,{24,24},{450,50}},{1,{24,24},{650,375}},{1,{24,24},{650,425}},{1,{24,24},{875,675}},{1,{24,24},{225,150}},{2,{24,24},{25,250}},{1,{24,24},{200,100}},{1,{24,24},{100,125}}}}}
local iconIndices: { string } = icons[1]
local idIndices: { string } = icons[2]
local iconRegistry: { [number]: { number | { number } } } = icons[3]

Lucide.Icons = iconIndices
function Lucide.GetAsset(name: string)
	local size = 48

	local iconIndex = table.find(iconIndices, name)

	if not iconIndex then
		return nil
	end

	local currentDifference = math.huge
	local currentSize = size

	for registrySize, _ in iconRegistry do
		local diff = math.abs(size - registrySize)

		if diff < currentDifference then
			currentDifference = diff
			currentSize = registrySize
		end
	end

	local icon = iconRegistry[currentSize][iconIndex]
	if icon then
		return {
			IconName = name,
			Url = idIndices[icon[1]],
			ImageRectSize = Vector2.new(icon[2][1], icon[2][2]),
			ImageRectOffset = Vector2.new(icon[3][1], icon[3][2]),
		}
	end

	return nil
end

return Lucide

--[[ 劫持内容]]--
local cloneref = (cloneref or clonereference or function(instance: any)
    return instance
end)
local clonefunction = (clonefunction or copyfunction or function(func) 
    return func 
end)

local HttpService: HttpService = cloneref(game:GetService("HttpService"))
local isfolder, isfile, listfiles = isfolder, isfile, listfiles

if typeof(clonefunction) == "function" then
    -- 修复 is_____ 函数，这些函数只应返回布尔值，不应报错。

    local
        isfolder_copy,
        isfile_copy,
        listfiles_copy = clonefunction(isfolder), clonefunction(isfile), clonefunction(listfiles)

    local isfolder_success, isfolder_error = pcall(function()
        return isfolder_copy("test" .. tostring(math.random(1000000, 9999999)))
    end)

    if isfolder_success == false or typeof(isfolder_error) ~= "boolean" then
        isfolder = function(folder)
            local success, data = pcall(isfolder_copy, folder)
            return (if success then data else false)
        end

        isfile = function(file)
            local success, data = pcall(isfile_copy, file)
            return (if success then data else false)
        end

        listfiles = function(folder)
            local success, data = pcall(listfiles_copy, folder)
            return (if success then data else {})
        end
    end
end

local SchemeIndexes = { "FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor" }
local ThemeManager = {
    Library = nil,

    Folder = "ObsidianLibSettings",

    AppliedToTab = false,
    DefaultThemeName = nil,

    BuiltInThemes = {
        ["默认"] = {
            1,
            { FontColor = "ffffff", MainColor = "191919", AccentColor = "7d55ff", BackgroundColor = "0f0f0f", OutlineColor = "282828", BackgroundImage = "" },
        },
        ["BBot"] = {
            2,
            { FontColor = "ffffff", MainColor = "1e1e1e", AccentColor = "7e48a3", BackgroundColor = "232323", OutlineColor = "141414", BackgroundImage = "" },
        },
        ["Fatality"] = {
            3,
            { FontColor = "ffffff", MainColor = "1e1842", AccentColor = "c50754", BackgroundColor = "191335", OutlineColor = "3c355d", BackgroundImage = "" },
        },
        ["Jester"] = {
            4,
            { FontColor = "ffffff", MainColor = "242424", AccentColor = "db4467", BackgroundColor = "1c1c1c", OutlineColor = "373737", BackgroundImage = "" },
        },
        ["Mint"] = {
            5,
            { FontColor = "ffffff", MainColor = "242424", AccentColor = "3db488", BackgroundColor = "1c1c1c", OutlineColor = "373737", BackgroundImage = "" },
        },
        ["Tokyo Night"] = {
            6,
            { FontColor = "ffffff", MainColor = "191925", AccentColor = "6759b3", BackgroundColor = "16161f", OutlineColor = "323232", BackgroundImage = "" },
        },
        ["Ubuntu"] = {
            7,
            { FontColor = "ffffff", MainColor = "3e3e3e", AccentColor = "e2581e", BackgroundColor = "323232", OutlineColor = "191919", BackgroundImage = "" },
        },
        ["Quartz"] = {
            8,
            { FontColor = "ffffff", MainColor = "232330", AccentColor = "426e87", BackgroundColor = "1d1b26", OutlineColor = "27232f", BackgroundImage = "" },
        },
        ["Nord"] = {
            9,
            { FontColor = "eceff4", MainColor = "3b4252", AccentColor = "88c0d0", BackgroundColor = "2e3440", OutlineColor = "4c566a", BackgroundImage = "" },
        },
        ["Dracula"] = {
            10,
            { FontColor = "f8f8f2", MainColor = "44475a", AccentColor = "ff79c6", BackgroundColor = "282a36", OutlineColor = "6272a4", BackgroundImage = "" },
        },
        ["Monokai"] = {
            11,
            { FontColor = "f8f8f2", MainColor = "272822", AccentColor = "f92672", BackgroundColor = "1e1f1c", OutlineColor = "49483e", BackgroundImage = "" },
        },
        ["Gruvbox"] = {
            12,
            { FontColor = "ebdbb2", MainColor = "3c3836", AccentColor = "fb4934", BackgroundColor = "282828", OutlineColor = "504945", BackgroundImage = "" },
        },
        ["Solarized"] = {
            13,
            { FontColor = "839496", MainColor = "073642", AccentColor = "cb4b16", BackgroundColor = "002b36", OutlineColor = "586e75", BackgroundImage = "" },
        },
        ["Catppuccin"] = {
            14,
            { FontColor = "d9e0ee", MainColor = "302d41", AccentColor = "f5c2e7", BackgroundColor = "1e1e2e", OutlineColor = "575268", BackgroundImage = "" },
        },
        ["One Dark"] = {
            15,
            { FontColor = "abb2bf", MainColor = "282c34", AccentColor = "c678dd", BackgroundColor = "21252b", OutlineColor = "5c6370", BackgroundImage = "" },
        },
        ["Cyberpunk"] = {
            16,
            { FontColor = "f9f9f9", MainColor = "262335", AccentColor = "00ff9f", BackgroundColor = "1a1a2e", OutlineColor = "413c5e", BackgroundImage = "" },
        },
        ["Oceanic Next"] = {
            17,
            { FontColor = "d8dee9", MainColor = "1b2b34", AccentColor = "6699cc", BackgroundColor = "16232a", OutlineColor = "343d46", BackgroundImage = "" },
        },
        ["Material"] = {
            18,
            { FontColor = "eeffff", MainColor = "212121", AccentColor = "82aaff", BackgroundColor = "151515", OutlineColor = "424242", BackgroundImage = "" },
        }
    }
}

function ThemeManager:SetLibrary(Library)
    ThemeManager.Library = Library
end

--// 辅助函数 \\--
local function Trim(Text: string)
    return Text:match("^%s*(.-)%s*$")
end

local function IsStringEmpty(String: string): boolean
    return if typeof(String) == "string" then Trim(String) == "" else true
end

local function IsValidFolderPath(Name: string): boolean
    return typeof(Name) == "string" and (
        Trim(Name) ~= "" and 
        not Name:match("^%s*$") and 
        not Name:find('[<>:"|%?%*%z]')
    )
end

--// 文件夹辅助函数 \\--
local function SplitPath(Path: string): {string}
	local Result = {}
	local Current = ""

	for Part in string.gmatch(Path, "[^/]+") do
		Current = if Current == "" then Part else (Current .. "/" .. Part)
		table.insert(Result, Current)
	end

	return Result
end

local function GetFolderPath(): false | string
    if IsStringEmpty(ThemeManager.Folder) then
        return false
    end

    return string.format("%s/themes", ThemeManager.Folder)
end

local GetCurrentThemesPath = GetFolderPath

--// 文件辅助函数 \\--
local function GetThemePath(ThemeName: string): false | string
    local CurrentThemesPath = GetCurrentThemesPath()
    return if CurrentThemesPath == false then false else string.format("%s/%s.json", CurrentThemesPath, ThemeName)
end

local function DoesThemeExist(ThemeName: string, IncludeBuiltIn: boolean): boolean
    if ThemeManager.BuiltInThemes[ThemeName] then
        return true
    end

    local ThemePath = GetThemePath(ThemeName)
    return if ThemePath == false then false else isfile(ThemePath)
end

local function GetDefaultThemePath(): false | string
    local CurrentThemesPath = GetCurrentThemesPath()
    return if CurrentThemesPath == false then false else string.format("%s/default.txt", CurrentThemesPath)
end

--// 文件夹 \\--
function ThemeManager:GetPaths(): {string}
    local FolderPath = GetFolderPath()
    return if FolderPath == false then {} else SplitPath(FolderPath)
end

function ThemeManager:BuildFolderTree(SkipWhenCreated: boolean?)
    local Paths = ThemeManager:GetPaths()
    if #Paths == 0 then
        return false
    end

    if SkipWhenCreated == true then
        if isfolder(Paths[1]) then
            return true
        end
    end

    for _, Path in Paths do
        if isfolder(Path) then continue end
        
        makefolder(Path)
    end

    return true
end

function ThemeManager:CheckFolderTree()
    return ThemeManager:BuildFolderTree(true)
end

function ThemeManager:SetFolder(Folder: string)
    assert(IsValidFolderPath(Folder), "无效路径")

    ThemeManager.Folder = Folder
    ThemeManager:BuildFolderTree()
end

--// 主题管理 \\--
function ThemeManager:ReloadCustomThemes()
    local SettingsPath = GetCurrentThemesPath()
    if SettingsPath == false then
        return {}
    end

    local SuccessList, Files = pcall(listfiles, SettingsPath)
    if not (SuccessList and typeof(Files) == "table") then
        ThemeManager.Library:Notify(string.format("加载主题列表失败: %s", tostring(Files)))
        return {}
    end

    local FileNames = {}
    for _, FilePath in Files do
        local RawFileName = FilePath:match("(.+)%..+$")
        if not RawFileName then continue end

        local Position = RawFileName:gsub("\\", "/"):find("/[^/]*$")
        local FileName = Position and RawFileName:sub(Position + 1) or RawFileName
        if not FileName or FileName == "default" then continue end

        table.insert(FileNames, FileName)
    end

    return FileNames
end

function ThemeManager:GetCustomTheme(ThemeName: string): any
    if IsStringEmpty(ThemeName) then
        return nil
    end

    local ThemePath = GetThemePath(ThemeName)
    if ThemePath == false or not isfile(ThemePath) then
        return nil
    end

    local SuccessRead, Content = pcall(readfile, ThemePath)
    if not SuccessRead then
        return nil
    end

    local SuccessDecode, Decoded = pcall(HttpService.JSONDecode, HttpService, Content)
    if not SuccessDecode or typeof(Decoded) ~= "table" then
        return nil
    end

    return Decoded
end

function ThemeManager:SaveCustomTheme(ThemeName: string): any
    if IsStringEmpty(ThemeName) then
        return false, "无效的主题名称"
    end

    if string.lower(ThemeName) == "default" then
        return false, "无效的主题名称"
    end

    local ThemePath = GetThemePath(ThemeName)
    if ThemePath == false then
        return false, "无效的主题名称"
    end

    ThemeManager:CheckFolderTree()

    local Library = ThemeManager.Library
    local ThemeData = {
        FontFace = Library.Options.FontFace.Value,
        BackgroundImage = Library.Options.BackgroundImage.Value
    }

    for _, SchemeIndex in SchemeIndexes do
        ThemeData[SchemeIndex] = Library.Options[SchemeIndex].Value:ToHex()
    end

    local SuccessEncode, EncodedData = pcall(HttpService.JSONEncode, HttpService, ThemeData)
    if not SuccessEncode then
        return false, "数据编码失败"
    end

    local SuccessWrite, ErrorMessage = pcall(writefile, ThemePath, EncodedData)
    if not SuccessWrite then
        return false, "写入主题文件失败: " .. tostring(ErrorMessage)
    end

    return true
end

function ThemeManager:Delete(ThemeName: string): (boolean | string?)
    if IsStringEmpty(ThemeName) then
        return false, "未选择主题"
    end

    local ThemePath = GetThemePath(ThemeName)
    if ThemePath == false or not isfile(ThemePath) then
        return false, "主题文件不存在"
    end

    local SuccessDelete, ErrorMessage = pcall(delfile, ThemePath)
    if not SuccessDelete then
        return false, "删除主题文件失败: " .. tostring(ErrorMessage)
    end

    if ThemeName == ThemeManager.DefaultThemeName then
        ThemeManager:DeleteDefaultTheme()
    end

    return true
end

--// 默认主题 \\--
function ThemeManager:GetDefaultTheme(): (string, boolean, string?)
    ThemeManager:CheckFolderTree()

    local DefaultThemePath = GetDefaultThemePath()
    if DefaultThemePath == false then
        return "none", false, "无效路径"
    end

    if not isfile(DefaultThemePath) then
        return "none", false, "未设置默认主题"
    end

    local SuccessRead, DefaultThemeName = pcall(readfile, DefaultThemePath)
    if not (SuccessRead and typeof(DefaultThemeName) == "string") then
        return "none", false, DefaultThemeName
    end

    local ConfigExists = DoesThemeExist(DefaultThemeName, true)
    if not ConfigExists then
        return "none", false, "主题文件未找到"
    end

    ThemeManager.DefaultThemeName = DefaultThemeName
    return DefaultThemeName, true
end

function ThemeManager:SetDefaultTheme(Theme: any)
    assert(ThemeManager.Library, "未设置Library，请先调用 ThemeManager:SetLibrary(Library)")
    assert(not ThemeManager.AppliedToTab, "在将ThemeManager应用到标签页后不能设置默认主题！")

    local Library = ThemeManager.Library
    local DefaultThemeData = ThemeManager.BuiltInThemes["默认"][2]

    local LibraryScheme = {}
    local FinalTheme = {}

    for _, SchemeIndex in SchemeIndexes do
        local IndexData = Theme[SchemeIndex]
        local IndexType = typeof(IndexData)
        
        if IndexType == "Color3" then
            LibraryScheme[SchemeIndex] = IndexData
            FinalTheme[SchemeIndex] = string.format("#%s", IndexData:ToHex())

        elseif IndexType == "string" then
            LibraryScheme[SchemeIndex] = Color3.fromHex(IndexData)
            FinalTheme[SchemeIndex] = if IndexData:sub(1, 1) == "#" then IndexData else string.format("#%s", IndexData)
        
        else
            local Value = DefaultThemeData[SchemeIndex]
            LibraryScheme[SchemeIndex] = Color3.fromHex(Value)
            FinalTheme[SchemeIndex] = Value
        end
    end

    --// 字体
    local FontFace = Theme["FontFace"]
    local FontFaceType = typeof(FontFace)
    
    if FontFaceType == "EnumItem" then
        LibraryScheme.Font = Font.fromEnum(FontFace)
        FinalTheme.FontFace = FontFace.Name

    elseif FontFaceType == "string" then
        LibraryScheme.Font = Font.fromEnum(Enum.Font[FontFace])
        FinalTheme.FontFace = FontFace
    
    else
        LibraryScheme.Font = Font.fromEnum(Enum.Font.Code)
        FinalTheme.FontFace = "Code"
    end

    --// 默认配色方案颜色
    for _, DefaultSchemeColor in { "RedColor", "DestructiveColor", "DarkColor", "WhiteColor" } do
        LibraryScheme[DefaultSchemeColor] = Library.Scheme[DefaultSchemeColor]
    end

    --// 应用
    Library.Scheme = LibraryScheme
    ThemeManager.BuiltInThemes["默认"] = { 1, FinalTheme }

    Library:UpdateColorsUsingRegistry()
end

function ThemeManager:SaveDefault(ThemeName: string): (boolean, string?)
    if IsStringEmpty(ThemeName) then
        return false, "未选择主题"
    end

    ThemeManager:CheckFolderTree()

    local DefaultThemePath = GetDefaultThemePath()
    if DefaultThemePath == false then
        return false, "无效路径"
    end

    if not DoesThemeExist(ThemeName, true) then
        return false, "主题不存在"
    end

    local SuccessWrite, ErrorMessage = pcall(writefile, DefaultThemePath, ThemeName)
    if not SuccessWrite then
        return false, ErrorMessage
    end

    ThemeManager.DefaultThemeName = ThemeName
    return true
end

function ThemeManager:LoadDefault()
    local ThemeName, Success, FetchErrorMessage = ThemeManager:GetDefaultTheme()
    if not Success or FetchErrorMessage then
        if FetchErrorMessage ~= "未设置默认主题" then
            ThemeManager.Library:Notify(string.format("应用默认主题失败: %s", FetchErrorMessage))
        end

        return
    end

    if not ThemeManager:GetCustomTheme(ThemeName) then
        ThemeManager.Library.Options.ThemeManager_ThemeList:SetValue(ThemeName)
        return
    end

    local SuccessLoad, LoadErrorMessage = ThemeManager:ApplyTheme(ThemeName)
    if not SuccessLoad then
        ThemeManager.Library:Notify(string.format("应用默认主题失败: %s", LoadErrorMessage))
        return
    end

    ThemeManager.Library:Notify(string.format("已成功应用默认主题 %q", ThemeName))
end

function ThemeManager:DeleteDefaultTheme(): (boolean, string?)
    ThemeManager:CheckFolderTree()

    local DefaultThemePath = GetDefaultThemePath()
    if DefaultThemePath == false then
        return false, "无效路径"
    end

    if not isfile(DefaultThemePath) then
        return false, "未设置默认主题"
    end

    local SuccessDelete, ErrorMessage = pcall(delfile, DefaultThemePath)
    if not SuccessDelete then
        return false, ErrorMessage
    end

    ThemeManager.DefaultThemeName = nil
    return true
end

--// 应用主题 \\--
function ThemeManager:ThemeUpdate()
    local Library = ThemeManager.Library

    for _, SchemeIndex in SchemeIndexes do
        local Element = Library.Options[SchemeIndex]
        if not Element then continue end

        Library.Scheme[SchemeIndex] = Element.Value
    end

    Library:UpdateColorsUsingRegistry()
end

function ThemeManager:ApplyTheme(ThemeName: string)
    if IsStringEmpty(ThemeName) then
        return false, "未选择主题"
    end

    local CustomThemeData = ThemeManager:GetCustomTheme(ThemeName)
    local Data = CustomThemeData or ThemeManager.BuiltInThemes[ThemeName]
    
    if not Data then
        return false, "主题未找到"
    end
    
    local Library = ThemeManager.Library
    local SchemeData = Data[2]
    local ThemeData = CustomThemeData or SchemeData

    for Index, Value in ThemeData do
        if Index == "VideoLink" then
            continue
        end

        local Element = Library.Options[Index]
        local FinalValue = Value

        if Index == "FontFace" then
            ThemeManager.Library:SetFont(Enum.Font[FinalValue])

        elseif Index == "BackgroundImage" then
            ThemeManager.Library:SetBackgroundImage(FinalValue)

        else
            FinalValue = Color3.fromHex(Value)
            Library.Scheme[Index] = FinalValue
        end

        if Element then
            Element:SetValue(FinalValue)
        end
    end

    ThemeManager:ThemeUpdate()
    return true
end

--// GUI \\--
local function ShowDialog(
    Condition: () -> boolean,

    Index: string, 
    Title: string, 
    Description: string,

    DestructiveText: string,
    DestructiveAction: () -> nil
)
    if Condition() == false then
        return DestructiveAction()
    end

    return ThemeManager.Library.Window:AddDialog(Index, {
        Title = Title,
        Description = Description,
        AutoDismiss = false,

        FooterButtons = {
            取消 = {
                Title = "取消",
                Variant = "Ghost",
                Order = 1,
                Callback = function(Dialog)
                    Dialog:Dismiss()
                end
            },

            确认 = {
                Title = DestructiveText,
                Variant = "Destructive",
                Order = 2,
                Callback = function(Dialog)
                    Dialog:Dismiss()
                    DestructiveAction()
                end
            }
        }
    })
end

function ThemeManager:CreateThemeManager(Themesbox: any)
    assert(ThemeManager.Library, "未设置Library，请先调用 ThemeManager:SetLibrary(Library)")

    local BuiltInThemesNames = {}
    for Name, _ThemeData in ThemeManager.BuiltInThemes do
        table.insert(BuiltInThemesNames, Name)
    end

    local CustomThemeList, CustomThemeName, ThemeList, FontFace, BackgroundImage, DefaultThemeLabel
    local function RefreshList()
        CustomThemeList:SetValues(ThemeManager:ReloadCustomThemes())
        CustomThemeList:SetValue(nil)

        ThemeList:SetValues(BuiltInThemesNames)
    end

    local function RefreshDefaultThemeLabel()
        local DefaultThemeName, _Success, _ErrorMessage = ThemeManager:GetDefaultTheme()

        DefaultThemeLabel:SetText(string.format("当前默认主题: %s", DefaultThemeName))
        if CustomThemeList then RefreshList() end
    end

    table.sort(BuiltInThemesNames, function(IndexA, IndexB)
        return ThemeManager.BuiltInThemes[IndexA][1] < ThemeManager.BuiltInThemes[IndexB][1]
    end)

    local function CreateColorOption(Text, SchemeIndex)
        Themesbox:AddLabel(Text):AddColorPicker(SchemeIndex, {
            Default = ThemeManager.Library.Scheme[SchemeIndex]
        })

        return ThemeManager.Library.Options[SchemeIndex]
    end

    local BackgroundColor = CreateColorOption("背景颜色", "BackgroundColor")
    local MainColor = CreateColorOption("主色", "MainColor")
    local AccentColor = CreateColorOption("强调色", "AccentColor")
    local OutlineColor = CreateColorOption("边框颜色", "OutlineColor")
    local FontColor = CreateColorOption("字体颜色", "FontColor")
    
    Themesbox:AddDropdown("FontFace", {
        Text = "字体",
        Default = "Code",
        
        Values = { "BuilderSans", "Code", "Fantasy", "Gotham", "Jura", "Roboto", "RobotoMono", "SourceSans" },
        AllowNull = false,
        Multi = false
    })
    
    Themesbox:AddInput("BackgroundImage", { 
        Text = "背景图片",

        Default = "",
        Finished = true,
        ClearTextOnFocus = false,
        ClearTextOnBlur = false
    })

    Themesbox:AddDivider()

    Themesbox:AddDropdown("ThemeManager_ThemeList", { 
        Text = "主题列表", 

        Values = BuiltInThemesNames,
        AllowNull = true,
        Multi = false,

        FormatDisplayValue = function(Value: any)
            if Value ~= "默认" and Value == ThemeManager.DefaultThemeName then
                return string.format("%s (默认)", Value)
            end

            return Value
        end,
        FormatListValue = function(Value: any)
            if Value ~= "默认" and Value == ThemeManager.DefaultThemeName then
                return string.format("%s (默认)", Value)
            end

            return Value
        end
    })

    Themesbox:AddButton("设为默认", function()
        local ThemeName = ThemeList.Value
        ThemeManager:SaveDefault(ThemeName)

        ThemeManager.Library:Notify(string.format("已将默认主题设置为 %q", ThemeName))
        RefreshDefaultThemeLabel()
    end)

    Themesbox:AddDivider()

    CustomThemeName = Themesbox:AddInput("ThemeManager_CustomThemeName", { 
        Text = "自定义主题名称" 
    })

    Themesbox:AddButton("创建主题", function()
        local Name = CustomThemeName.Value
        if IsStringEmpty(Name) then
            ThemeManager.Library:Notify("主题名称不能为空。")
            return
        end

        if string.lower(Name) == "default" then
            ThemeManager.Library:Notify("无效的主题名称。")
            return
        end

        ShowDialog(
            function(): boolean
                return ThemeManager:GetCustomTheme(Name) ~= nil
            end,

            "ThemeManager_CreateTheme",
            "主题已存在",
            string.format("名为 %q 的自定义主题已存在。覆盖它将会用您当前的颜色替换它。", Name),

            "覆盖",
            function()
                local Success, ErrorMessage = ThemeManager:SaveCustomTheme(Name)
                if not Success then
                    ThemeManager.Library:Notify(string.format("创建主题 %q 失败: %s", Name, ErrorMessage))
                    return
                end

                ThemeManager.Library:Notify(string.format("成功创建主题 %q", Name))
                RefreshList()
            end
        )
    end)

    Themesbox:AddDivider()

    CustomThemeList = Themesbox:AddDropdown("ThemeManager_CustomThemeList", { 
        Text = "自定义主题",

        Values = ThemeManager:ReloadCustomThemes(), 
        AllowNull = true,
        Multi = false,

        FormatDisplayValue = function(Value: any)
            if Value == ThemeManager.DefaultThemeName then
                return string.format("%s (默认)", Value)
            end

            return Value
        end,
        FormatListValue = function(Value: any)
            if Value == ThemeManager.DefaultThemeName then
                return string.format("%s (默认)", Value)
            end

            return Value
        end
    })

    Themesbox:AddButton("加载主题", function()
        local Name = CustomThemeList.Value
        if IsStringEmpty(Name) then
            ThemeManager.Library:Notify("请先选择一个主题。")
            return
        end

        ThemeManager:ApplyTheme(Name)
        ThemeManager.Library:Notify(string.format("成功加载主题 %q", Name))
    end)

    Themesbox:AddButton("覆盖主题", function()
        local Name = CustomThemeList.Value
        if IsStringEmpty(Name) then
            ThemeManager.Library:Notify("请先选择一个主题。")
            return
        end

        ShowDialog(
            function(): boolean
                return true
            end,

            "ThemeManager_OverwriteTheme",
            "覆盖主题",
            string.format("您确定要用您当前的颜色覆盖 %q 吗？此操作无法撤销。", Name),

            "覆盖",
            function()
                ThemeManager:SaveCustomTheme(Name)
                ThemeManager.Library:Notify(string.format("成功覆盖主题 %q", Name))
            end
        )
    end)

    Themesbox:AddButton("删除主题", function()
        local Name = CustomThemeList.Value
        if IsStringEmpty(Name) then
            ThemeManager.Library:Notify("请先选择一个主题。")
            return
        end

        ShowDialog(
            function(): boolean
                return true
            end,

            "ThemeManager_DeleteTheme",
            "删除主题",
            string.format("您确定要删除 %q 吗？此操作无法撤销。", Name),
            
            "删除",
            function()
                local Success, ErrorMessage = ThemeManager:Delete(Name)
                if not Success then
                    ThemeManager.Library:Notify(string.format("删除主题失败: %s", ErrorMessage))
                    return
                end

                ThemeManager.Library:Notify(string.format("成功删除主题 %q", Name))
                RefreshDefaultThemeLabel()
            end
        )
    end)

    Themesbox:AddButton("刷新列表", RefreshList)

    Themesbox:AddButton("设为默认", function()
        local Name = CustomThemeList.Value
        if IsStringEmpty(Name) then
            ThemeManager.Library:Notify("请先选择一个主题。")
            return
        end

        ThemeManager:SaveDefault(Name)
        ThemeManager.Library:Notify(string.format("已将默认主题设置为 %q", Name))
        RefreshDefaultThemeLabel()
    end)

    Themesbox:AddButton("重置默认", function()
        ShowDialog(
            function(): boolean
                return true
            end,

            "ThemeManager_ResetDefault",
            "重置默认主题",
            "您确定要清除默认主题吗？下次加载库将恢复为内置默认主题。",
            
            "重置",
            function()
                local Success, ErrorMessage = ThemeManager:DeleteDefaultTheme()
                if not Success then
                    ThemeManager.Library:Notify(string.format("重置默认主题失败: %s", ErrorMessage))
                    return
                end

                ThemeManager.Library:Notify("成功重置默认主题。")
                RefreshDefaultThemeLabel()
            end
        )
    end)

    DefaultThemeLabel = Themesbox:AddLabel("当前默认主题: ...", true);

    --// 设置变量
    CustomThemeList, CustomThemeName, ThemeList, FontFace, BackgroundImage =
        ThemeManager.Library.Options.ThemeManager_CustomThemeList,
        ThemeManager.Library.Options.ThemeManager_CustomThemeName,
        ThemeManager.Library.Options.ThemeManager_ThemeList,
        ThemeManager.Library.Options.FontFace,
        ThemeManager.Library.Options.BackgroundImage;

    --// 处理器
    ThemeList:OnChanged(function()
        ThemeManager:ApplyTheme(ThemeList.Value)
    end)

    local function UpdateTheme()
        ThemeManager:ThemeUpdate()
    end

    BackgroundColor:OnChanged(UpdateTheme)
    MainColor:OnChanged(UpdateTheme)
    AccentColor:OnChanged(UpdateTheme)
    OutlineColor:OnChanged(UpdateTheme)
    FontColor:OnChanged(UpdateTheme)
    FontFace:OnChanged(function(Value) ThemeManager.Library:SetFont(Enum.Font[Value]) end)
    BackgroundImage:OnChanged(function(Value) ThemeManager.Library:SetBackgroundImage(Value) end)

    --// 加载默认
    ThemeManager:LoadDefault()
    ThemeManager.AppliedToTab = true
    RefreshDefaultThemeLabel()

    return Themesbox
end

function ThemeManager:CreateGroupBox(Tab: any, IconName: string)
    return Tab:AddLeftGroupbox("主题", IconName or "paintbrush")
end

function ThemeManager:ApplyToTab(Tab: any, IconName: string)
    local Groupbox = ThemeManager:CreateGroupBox(Tab, IconName)
    return ThemeManager:CreateThemeManager(Groupbox)
end

function ThemeManager:ApplyToGroupbox(Groupbox: any)
    return ThemeManager:CreateThemeManager(Groupbox)
end

getgenv().ObsidianThemeManager = ThemeManager
return ThemeManager
local cloneref = (cloneref or clonereference or function(instance: any)
    return instance
end)
local clonefunction = (clonefunction or copyfunction or function(func) 
    return func 
end)

local HttpService: HttpService = cloneref(game:GetService("HttpService"))
local isfolder, isfile, listfiles = isfolder, isfile, listfiles

if typeof(clonefunction) == "function" then
    -- 修复 is_____ 函数，这些函数只应返回布尔值，不应报错。

    local
        isfolder_copy,
        isfile_copy,
        listfiles_copy = clonefunction(isfolder), clonefunction(isfile), clonefunction(listfiles)

    local isfolder_success, isfolder_error = pcall(function()
        return isfolder_copy("test" .. tostring(math.random(1000000, 9999999)))
    end)

    if isfolder_success == false or typeof(isfolder_error) ~= "boolean" then
        isfolder = function(folder)
            local success, data = pcall(isfolder_copy, folder)
            return (if success then data else false)
        end

        isfile = function(file)
            local success, data = pcall(isfile_copy, file)
            return (if success then data else false)
        end

        listfiles = function(folder)
            local success, data = pcall(listfiles_copy, folder)
            return (if success then data else {})
        end
    end
end

local SaveManager = {
    Library = nil,

    Folder = "ObsidianLibSettings",
    SubFolder = "",

    Ignore = {},
    LoadingOrder = {},
    UseLoadingOrder = false,

    AutoloadConfig = nil
}

function SaveManager:SetLibrary(Library)
    SaveManager.Library = Library
end

--// 元素解析器 \\--
local SpecialValueParser = {
    UDim2 = {
        Encode = function(Value: UDim2)
            return {
                X = { Scale = Value.X.Scale, Offset = Value.X.Offset },
                Y = { Scale = Value.Y.Scale, Offset = Value.Y.Offset }
            }
        end,

        Decode = function(Data: any)
            local DataType = typeof(Data)
            if DataType == "table" then
                return UDim2.new(Data.X.Scale, Data.X.Offset, Data.Y.Scale, Data.Y.Offset)
            elseif DataType == "UDim2" then
                return Data
            end

            return nil
        end
    }
}

local ElementParser = {}; do
    local function CreateParser(
        ElementType: string, 
        LibaryIndex: string, 
        
        Save: (string, any, ...any) -> any, 
        Load: (any?, any) -> any,
        CustomElementFetcher: boolean?
    )
        ElementParser[ElementType] = { 
            Save = function(Index: string, Element: any, ...)
                local Data = Save(Index, Element, ...)
                Data.type = ElementType
                Data.idx = Index

                return Data
            end, 

            Load = function(Index: string?, Data: any)
                if CustomElementFetcher == true then
                    return Load(nil, Data)
                end

                local Elements = SaveManager.Library and SaveManager.Library[LibaryIndex]
                local Element = Elements and Elements[Index]
                return Load(Element, Data)
            end
        }
    end

    CreateParser(
        "Toggle", "Toggles",
        function(Index: string, Toggle: any)
            return { value = Toggle.Value }
        end,
        function(Element: any?, Data: any)
            if not Element then return end
            if Element.Value == Data.value then
                Element:RunChanged()
                return
            end
            
            Element:SetValue(Data.value)
        end
    )

    CreateParser(
        "Slider", "Options",
        function(Index: string, Slider: any)
            return { value = tostring(Slider.Value) }
        end,
        function(Element: any?, Data: any)
            if not Element then return end
            if Element.Value == Data.value then
                Element:RunChanged()
                return
            end

            Element:SetValue(Data.value)
        end
    )

    CreateParser(
        "Dropdown", "Options",
        function(Index: string, Dropdown: any)
            return { value = Dropdown.Value, multi = Dropdown.Multi }
        end,
        function(Element: any?, Data: any)
            if not Element then return end
            if Element.Value == Data.value then
                Element:RunChanged()
                return
            end
            
            Element:SetValue(Data.value)
        end
    )

    CreateParser(
        "ColorPicker", "Options",
        function(Index: string, ColorPicker: any)
            return { value = ColorPicker.Value:ToHex(), transparency = ColorPicker.Transparency }
        end,
        function(Element: any?, Data: any)
            if not Element then return end
            
            Element:SetValueRGB(Color3.fromHex(Data.value), Data.transparency)
        end
    )

    CreateParser(
        "KeyPicker", "Options",
        function(Index: string, KeyPicker: any)
            return { mode = KeyPicker.Mode, key = KeyPicker.Value, modifiers = KeyPicker.Modifiers, toggled = KeyPicker.Toggled }
        end,
        function(Element: any?, Data: any)
            if not Element then return end
            
            Element:SetValue({ Data.key, Data.mode, Data.modifiers })
            if Data.mode == "Toggle" and Data.toggled ~= nil then
                Element.Toggled = Data.toggled
                Element:Update()
            end
        end
    )

    CreateParser(
        "Input", "Options",
        function(Index: string, Input: any)
            return { text = Input.Value }
        end,
        function(Element: any?, Data: any)
            if not Element then return end
            if typeof(Data.text) ~= "string" then return end

            if Element.Value == Data.text then
                Element:RunChanged()
                return
            end

            Element:SetValue(Data.text)
        end
    )

    CreateParser(
        "Groupbox", "Tabs",
        function(Index: string, Groupbox: any, TabIndex: string)
            return { collapsed = Groupbox.Collapsed, tabIdx = TabIndex }
        end,
        function(_, Data: any)
            local TabIndex, Index = Data.tabIdx, Data.idx
            if typeof(TabIndex) ~= "string" or typeof(Index) ~= "string" then return end

            local Tabs = SaveManager.Library and SaveManager.Library.Tabs
            local Tab = Tabs and Tabs[TabIndex]
            if not Tab then return end

            local Groupbox = Tab.Groupboxes[Index]
            if not Groupbox or Groupbox.Collapsed == Data.collapsed then return end

            Groupbox:SetCollapsed(Data.collapsed == true)
        end,
        true
    )
end

--// 辅助函数 \\--
local function Trim(Text: string)
    return Text:match("^%s*(.-)%s*$")
end

local function IsStringEmpty(String: string): boolean
    return if typeof(String) == "string" then Trim(String) == "" else true
end

local function IsValidFolderPath(Name: string): boolean
    return typeof(Name) == "string" and (
        Trim(Name) ~= "" and 
        not Name:match("^%s*$") and 
        not Name:find('[<>:"|%?%*%z]')
    )
end

--// 文件夹辅助函数 \\--
local function SplitPath(Path: string): {string}
	local Result = {}
	local Current = ""

	for Part in string.gmatch(Path, "[^/]+") do
		Current = if Current == "" then Part else (Current .. "/" .. Part)
		table.insert(Result, Current)
	end

	return Result
end

local function GetFolderPath(): false | string
    if IsStringEmpty(SaveManager.Folder) then
        return false
    end

    return string.format("%s/settings", SaveManager.Folder)
end

local function GetSubFolderPath(): false | string
    if IsStringEmpty(SaveManager.Folder) or IsStringEmpty(SaveManager.SubFolder) then
        return false
    end

    return string.format("%s/settings/%s", SaveManager.Folder, SaveManager.SubFolder)
end

local function GetCurrentSettingsPath(): false | string
    local SubFolderPath = GetSubFolderPath()
    return if SubFolderPath == false then GetFolderPath() else SubFolderPath
end

--// 文件辅助函数 \\--
local function GetConfigPath(ConfigName: string): false | string
    local CurrentSettingsPath = GetCurrentSettingsPath()
    return if CurrentSettingsPath == false then false else string.format("%s/%s.json", CurrentSettingsPath, ConfigName)
end

local function DoesConfigExist(ConfigName: string): boolean
    local ConfigPath = GetConfigPath(ConfigName)
    return if ConfigPath == false then false else isfile(ConfigPath)
end

local function GetAutoloadPath(): false | string
    local CurrentSettingsPath = GetCurrentSettingsPath()
    return if CurrentSettingsPath == false then false else string.format("%s/autoload.txt", CurrentSettingsPath)
end

--// 索引 \\--
function SaveManager:SetLoadingOrder(Enabled: boolean, Order: {string}?)
    SaveManager.UseLoadingOrder = Enabled == true
    SaveManager.LoadingOrder = typeof(Order) == "table" and Order or SaveManager.LoadingOrder
end

function SaveManager:SetIgnoreIndexes(Indexes: {string}?)
    assert(typeof(Indexes) == "table", "期望一个表，实际得到 " .. typeof(Indexes))

    for _, Index in Indexes do
        SaveManager.Ignore[Index] = true
    end
end

function SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({
        "BackgroundColor", "MainColor", "AccentColor", "OutlineColor", "FontColor", "FontFace", "BackgroundImage",
        "ThemeManager_ThemeList", "ThemeManager_CustomThemeList", "ThemeManager_CustomThemeName"
    })
end

--// 文件夹 \\--
function SaveManager:GetPaths(): {string}
    local SubFolderPath = GetSubFolderPath()
    if SubFolderPath == false then
        local FolderPath = GetFolderPath()
        return if FolderPath == false then {} else SplitPath(FolderPath)
    end

    return SplitPath(SubFolderPath)
end

function SaveManager:BuildFolderTree(SkipWhenCreated: boolean?)
    local Paths = SaveManager:GetPaths()
    if #Paths == 0 then
        return false
    end

    if SkipWhenCreated == true then
        if isfolder(Paths[1]) then
            return true
        end
    end

    for _, Path in Paths do
        if isfolder(Path) then continue end
        
        makefolder(Path)
    end

    return true
end

function SaveManager:CheckFolderTree()
    return SaveManager:BuildFolderTree(true)
end

function SaveManager:CheckSubFolder(CreateFolder: boolean)
    local SubFolderPath = GetSubFolderPath()
    if SubFolderPath == false then
        return false
    end

    local FolderExists = isfolder(SubFolderPath)
    if not CreateFolder then
        return FolderExists
    end

    makefolder(SubFolderPath)
    return true
end

function SaveManager:SetFolder(Folder: string)
    assert(IsValidFolderPath(Folder), "无效路径")

    SaveManager.Folder = Folder
    SaveManager:BuildFolderTree()
end

function SaveManager:SetSubFolder(SubFolder: string)
    assert(IsValidFolderPath(SubFolder), "无效路径")

    SaveManager.SubFolder = SubFolder
    SaveManager:BuildFolderTree()
end

--// 配置管理 \\--
function SaveManager:RefreshConfigList()
    local SettingsPath = GetCurrentSettingsPath()
    if SettingsPath == false then
        return {}
    end

    local SuccessList, Files = pcall(listfiles, SettingsPath)
    if not (SuccessList and typeof(Files) == "table") then
        SaveManager.Library:Notify(string.format("加载配置列表失败: %s", tostring(Files)))
        return {}
    end

    local FileNames = {}
    for _, FilePath in Files do
        local RawFileName = FilePath:match("(.+)%..+$")
        if not RawFileName then continue end

        local Position = RawFileName:gsub("\\", "/"):find("/[^/]*$")
        local FileName = Position and RawFileName:sub(Position + 1) or RawFileName
        if not FileName or FileName == "autoload" then continue end

        table.insert(FileNames, FileName)
    end

    return FileNames
end

function SaveManager:Save(ConfigName: string): (boolean, string?)
    if IsStringEmpty(ConfigName) then
        return false, "无效的配置名称"
    end

    if string.lower(ConfigName) == "autoload" then
        return false, "无效的配置名称"
    end

    local ConfigPath = GetConfigPath(ConfigName)
    if ConfigPath == false then
        return false, "无效的配置名称"
    end

    SaveManager:CheckFolderTree()

    local Library = SaveManager.Library
    local IgnoreIndexes = SaveManager.Ignore
    local CurrentData = {
        timestamp = os.date("%d.%m.%Y %H:%M:%S"),
        name = ConfigName,

        objects = {},
        keybindMenu = if Library.KeybindFrame then {
            visible = Library.KeybindFrame.Visible,
            position = SpecialValueParser.UDim2.Encode(Library.KeybindFrame.Position)
        } else nil
    }

    --// 开关
    for Index, Toggle in Library.Toggles do
        if not Toggle.Type then continue end
        if IgnoreIndexes[Index] then continue end

        local Parser = ElementParser[Toggle.Type]
        if not Parser then continue end

        table.insert(CurrentData.objects, Parser.Save(Index, Toggle))
    end

    --// 选项
    for Index, Option in Library.Options do
        if not Option.Type then continue end
        if IgnoreIndexes[Index] then continue end

        local Parser = ElementParser[Option.Type]
        if not Parser then continue end

        table.insert(CurrentData.objects, Parser.Save(Index, Option))
    end

    --// 组框
    for TabIndex, Tab in Library.Tabs do
        if not Tab.Groupboxes then continue end

        for Index, Groupbox in Tab.Groupboxes do
            if IgnoreIndexes[Index] then continue end

            local Parser = ElementParser.Groupbox
            if not Parser then continue end

            table.insert(CurrentData.objects, Parser.Save(Index, Groupbox, TabIndex))
        end
    end

    local SuccessEncode, EncodedData = pcall(HttpService.JSONEncode, HttpService, CurrentData)
    if not SuccessEncode then
        return false, "数据编码失败"
    end

    local SuccessWrite, ErrorMessage = pcall(writefile, ConfigPath, EncodedData)
    if not SuccessWrite then
        return false, "写入配置文件失败: " .. tostring(ErrorMessage)
    end

    return true
end

function SaveManager:Load(ConfigName: string): (boolean, string?)
    if IsStringEmpty(ConfigName) then
        return false, "未选择配置"
    end

    local ConfigPath = GetConfigPath(ConfigName)
    if ConfigPath == false or not isfile(ConfigPath) then
        return false, "配置文件不存在"
    end

    local SuccessRead, Content = pcall(readfile, ConfigPath)
    if not SuccessRead then
        return false, "读取配置文件失败"
    end

    local SuccessDecode, Decoded = pcall(HttpService.JSONDecode, HttpService, Content)
    if not SuccessDecode or typeof(Decoded) ~= "table" or typeof(Decoded.objects) ~= "table" then
        return false, "解析配置数据失败"
    end

    local Library = SaveManager.Library
    local LoadingOrder = SaveManager.LoadingOrder
    local IgnoreIndexes = SaveManager.Ignore

    if SaveManager.UseLoadingOrder == true and typeof(LoadingOrder) == "table" then
        table.sort(Decoded.objects, function(a, b)
            local aIndex = table.find(LoadingOrder, a.type) or math.huge
            local bIndex = table.find(LoadingOrder, b.type) or math.huge
            return aIndex < bIndex
        end)
    end

    --// 快捷键菜单
    if Library.KeybindFrame and typeof(Decoded.keybindMenu) == "table" then
        local KeybindFrameData = Decoded.keybindMenu
        local IsVisible = KeybindFrameData.visible == true
        local Position = SpecialValueParser.UDim2.Decode(KeybindFrameData.position)

        Library.KeybindFrame.Visible = IsVisible
        Library.KeybindFrame.Position = Position or Library.KeybindFrame.Position
        
        local KeybindMenuToggle = Library.Options and Library.Options.KeybindMenuOpen
        if KeybindMenuToggle then
            KeybindMenuToggle:SetValue(IsVisible)
        end
    end

    --// 元素
    for _, Option in Decoded.objects do
        if not Option.type then continue end
        if IgnoreIndexes[Option.idx] then continue end

        local Parser = ElementParser[Option.type]
        if not Parser then continue end

        task.defer(Parser.Load, Option.idx, Option)
    end

    return true
end

function SaveManager:Delete(ConfigName: string): (boolean | string?)
    if IsStringEmpty(ConfigName) then
        return false, "未选择配置"
    end

    local ConfigPath = GetConfigPath(ConfigName)
    if ConfigPath == false or not isfile(ConfigPath) then
        return false, "配置文件不存在"
    end

    local SuccessDelete, ErrorMessage = pcall(delfile, ConfigPath)
    if not SuccessDelete then
        return false, "删除配置文件失败: " .. tostring(ErrorMessage)
    end

    if ConfigName == SaveManager.AutoloadConfig then
        SaveManager:DeleteAutoLoadConfig()
    end

    return true
end

--// 自动加载配置 \\--
function SaveManager:GetAutoloadConfig(): (string, boolean, string?)
    SaveManager:CheckFolderTree()

    local AutoloadPath = GetAutoloadPath()
    if AutoloadPath == false then
        return "none", false, "无效路径"
    end

    if not isfile(AutoloadPath) then
        return "none", false, "未设置自动加载配置"
    end

    local SuccessRead, AutoloadConfigName = pcall(readfile, AutoloadPath)
    if not (SuccessRead and typeof(AutoloadConfigName) == "string") then
        return "none", false, AutoloadConfigName
    end

    local ConfigExists = DoesConfigExist(AutoloadConfigName)
    if not ConfigExists then
        return "none", false, "配置文件未找到"
    end

    SaveManager.AutoloadConfig = AutoloadConfigName
    return AutoloadConfigName, true
end

function SaveManager:SaveAutoloadConfig(ConfigName: string): (boolean, string?)
    if IsStringEmpty(ConfigName) then
        return false, "未选择配置"
    end

    SaveManager:CheckFolderTree()

    local AutoloadPath = GetAutoloadPath()
    if AutoloadPath == false then
        return false, "无效路径"
    end

    if not DoesConfigExist(ConfigName) then
        return false, "配置不存在"
    end

    local SuccessWrite, ErrorMessage = pcall(writefile, AutoloadPath, ConfigName)
    if not SuccessWrite then
        return false, ErrorMessage
    end

    SaveManager.AutoloadConfig = ConfigName
    return true
end

function SaveManager:LoadAutoloadConfig()
    local ConfigName, Success, FetchErrorMessage = SaveManager:GetAutoloadConfig()
    if not Success or FetchErrorMessage then
        if FetchErrorMessage ~= "未设置自动加载配置" then
            SaveManager.Library:Notify(string.format("加载自动加载配置失败: %s", FetchErrorMessage))
        end

        return
    end

    local SuccessLoad, LoadErrorMessage = SaveManager:Load(ConfigName)
    if not SuccessLoad then
        SaveManager.Library:Notify(string.format("加载自动加载配置 %q 失败: %s", ConfigName, LoadErrorMessage))
        return
    end

    SaveManager.Library:Notify(string.format("成功加载自动加载配置 %q", ConfigName))
end

function SaveManager:DeleteAutoLoadConfig(): (boolean, string?)
    SaveManager:CheckFolderTree()

    local AutoloadPath = GetAutoloadPath()
    if AutoloadPath == false then
        return false, "无效路径"
    end

    if not isfile(AutoloadPath) then
        return false, "未设置自动加载配置"
    end

    local SuccessDelete, ErrorMessage = pcall(delfile, AutoloadPath)
    if not SuccessDelete then
        return false, ErrorMessage
    end

    SaveManager.AutoloadConfig = nil
    return true
end

--// GUI \\--
local function ShowDialog(
    Condition: () -> boolean,

    Index: string, 
    Title: string, 
    Description: string,

    DestructiveText: string,
    DestructiveAction: () -> nil
)
    if Condition() == false then
        return DestructiveAction()
    end

    return SaveManager.Library.Window:AddDialog(Index, {
        Title = Title,
        Description = Description,
        AutoDismiss = false,

        FooterButtons = {
            取消 = {
                Title = "取消",
                Variant = "Ghost",
                Order = 1,
                Callback = function(Dialog)
                    Dialog:Dismiss()
                end
            },

            确认 = {
                Title = DestructiveText,
                Variant = "Destructive",
                Order = 2,
                Callback = function(Dialog)
                    Dialog:Dismiss()
                    DestructiveAction()
                end
            }
        }
    })
end

function SaveManager:BuildConfigSection(Tab: any, IconName: string)
    assert(SaveManager.Library, "未设置Library，请先调用 SaveManager:SetLibrary(Library)")
    local ConfigurationBox = Tab:AddRightGroupbox("配置", IconName or "folder-cog")
    
    local ConfigNameInput, ConfigList, AutoloadConfigLabel
    local function RefreshList()
        ConfigList:SetValues(SaveManager:RefreshConfigList())
        ConfigList:SetValue(nil)
    end

    local function RefreshAutoloadConfigLabel()
        local AutoloadConfigName, _Success, _ErrorMessage = SaveManager:GetAutoloadConfig()

        AutoloadConfigLabel:SetText(string.format("当前自动加载配置: %s", AutoloadConfigName))
        if ConfigList then RefreshList() end
    end

    --// 创建
    ConfigurationBox:AddInput("SaveManager_ConfigName", {
        Text = "配置名称"
    })

    ConfigurationBox:AddButton("创建配置", function()
        local ConfigName = ConfigNameInput.Value
        if IsStringEmpty(ConfigName) then
            SaveManager.Library:Notify("配置名称不能为空。")
            return
        end

        if string.lower(ConfigName) == "autoload" then
            SaveManager.Library:Notify("无效的配置名称。")
            return
        end
        
        ShowDialog(
            function(): boolean
                return DoesConfigExist(ConfigName)
            end,

            "SaveManager_CreateConfig",
            "配置已存在",
            string.format("名为 %q 的配置已存在。覆盖它将会用您当前的设置替换它。", ConfigName),

            "覆盖",
            function()
                local Success, ErrorMessage = SaveManager:Save(ConfigName)
                if not Success then
                    SaveManager.Library:Notify(string.format("创建配置 %q 失败: %s", ConfigName, ErrorMessage))
                    return
                end

                SaveManager.Library:Notify(string.format("成功创建配置 %q", ConfigName))
                RefreshList()
            end
        )
    end)

    ConfigurationBox:AddDivider()

    --// 管理
    ConfigurationBox:AddDropdown("SaveManager_ConfigList", {
        Text = "配置列表",

        Values = SaveManager:RefreshConfigList(),
        AllowNull = true,
        Multi = false,

        FormatDisplayValue = function(Value: any)
            if Value == SaveManager.AutoloadConfig then
                return string.format("%s (自动加载)", Value)
            end

            return Value
        end,
        FormatListValue = function(Value: any)
            if Value == SaveManager.AutoloadConfig then
                return string.format("%s (自动加载)", Value)
            end

            return Value
        end
    })

    ConfigurationBox:AddButton({
        Text = "加载配置",
        DoubleClick = false,

        Func = function()
            local ConfigName = ConfigList.Value
            if IsStringEmpty(ConfigName) then
                SaveManager.Library:Notify("请先选择一个配置。")
                return
            end

            local Success, ErrorMessage = SaveManager:Load(ConfigName)
            if not Success then
                SaveManager.Library:Notify(string.format("加载配置 %q 失败: %s", ConfigName, ErrorMessage))
                return
            end

            SaveManager.Library:Notify(string.format("成功加载配置 %q", ConfigName))
        end
    })
    
    ConfigurationBox:AddButton({
        Text = "覆盖配置",
        DoubleClick = false,

        Func = function()
            local ConfigName = ConfigList.Value
            if IsStringEmpty(ConfigName) then
                SaveManager.Library:Notify("请先选择一个配置。")
                return
            end

            ShowDialog(
                function(): boolean
                    return true --// 总是显示
                end,

                "SaveManager_OverwriteConfig",
                "覆盖配置",
                string.format("您确定要用您当前的设置覆盖 %q 吗？此操作无法撤销。", ConfigName),

                "覆盖",
                function()
                    local Success, ErrorMessage = SaveManager:Save(ConfigName)
                    if not Success then
                        SaveManager.Library:Notify(string.format("覆盖配置 %q 失败: %s", ConfigName, ErrorMessage))
                        return
                    end

                    SaveManager.Library:Notify(string.format("成功覆盖配置 %q", ConfigName))
                end
            )
        end
    })

    ConfigurationBox:AddButton({
        Text = "删除配置",
        DoubleClick = false,

        Func = function()
            local ConfigName = ConfigList.Value
            if IsStringEmpty(ConfigName) then
                SaveManager.Library:Notify("请先选择一个配置。")
                return
            end

            ShowDialog(
                function(): boolean
                    return true --// 总是显示
                end,

                "SaveManager_DeleteConfig",
                "删除配置",
                string.format("您确定要删除 %q 吗？此操作无法撤销。", ConfigName),
                
                "删除",
                function()
                    local Success, ErrorMessage = SaveManager:Delete(ConfigName)
                    if not Success then
                        SaveManager.Library:Notify(string.format("删除配置 %q 失败: %s", ConfigName, ErrorMessage))
                        return
                    end

                    SaveManager.Library:Notify(string.format("成功删除配置 %q", ConfigName))
                    RefreshAutoloadConfigLabel()
                end
            )
        end
    })

    ConfigurationBox:AddButton("刷新列表", RefreshList)

    --// 自动加载配置
    ConfigurationBox:AddButton({
        Text = "设为自动加载",
        DoubleClick = false,

        Func = function()
            local ConfigName = ConfigList.Value
            if IsStringEmpty(ConfigName) then
                SaveManager.Library:Notify("请先选择一个配置。")
                return
            end

            local Success, ErrorMessage = SaveManager:SaveAutoloadConfig(ConfigName)
            if not Success then
                SaveManager.Library:Notify(string.format("设置自动加载配置 %q 失败: %s", ConfigName, ErrorMessage))
                return
            end

            SaveManager.Library:Notify(string.format("成功将自动加载配置设置为 %q", ConfigName))
            RefreshAutoloadConfigLabel()
        end
    })

    ConfigurationBox:AddButton({
        Text = "重置自动加载",
        DoubleClick = false,

        Func = function()
            ShowDialog(
                function(): boolean
                    return true --// 总是显示
                end,

                "SaveManager_ResetAutoload",
                "重置自动加载配置",
                "您确定要清除自动加载配置吗？下次启动将不会自动加载任何配置。",
                
                "重置",
                function()
                    local Success, ErrorMessage = SaveManager:DeleteAutoLoadConfig()
                    if not Success then
                        SaveManager.Library:Notify(string.format("重置自动加载配置失败: %s", ErrorMessage))
                        return
                    end

                    SaveManager.Library:Notify("成功重置自动加载配置。")
                    RefreshAutoloadConfigLabel()
                end
            )
        end
    })

    AutoloadConfigLabel = ConfigurationBox:AddLabel("当前自动加载配置: ...", true);

    --// 设置变量
    ConfigNameInput, ConfigList = 
        SaveManager.Library.Options.SaveManager_ConfigName, 
        SaveManager.Library.Options.SaveManager_ConfigList;

    --// 刷新
    RefreshAutoloadConfigLabel()
    SaveManager:SetIgnoreIndexes({ "SaveManager_ConfigList", "SaveManager_ConfigName" })

    return ConfigurationBox
end

SaveManager:BuildFolderTree()
return SaveManager