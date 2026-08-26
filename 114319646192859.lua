-- Chargement de ta bibliothèque Neya UI depuis ton dépôt GitHub
local Neya = loadstring(game:HttpGet("https://raw.githubusercontent.com/spydergersdaoff/Neya-UI/refs/heads/main/loader.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Création de ta fenêtre personnalisée avec le style Windows, le logo et les boutons intégrés
local Window = Neya.CreateWindow("Spin For Free")

-- =============================================
-- SCRIPT 1 : INSTANT CLAIM SPIN (Converti en Toggle Neya)
-- =============================================

local flyEnabled = false
local flyLoop = nil
local player = Players.LocalPlayer
local TARGET_POS = Vector3.new(25.01, 4.86, -373.09)
local FLY_SPEED = 50
local hasReceivedSpins = false
local isArrived = false
local currentLockHeight = TARGET_POS.Y

local function stopFly()
    if flyLoop then flyLoop:Disconnect() flyLoop = nil end
    if _G.HorizontalFlyLoop then _G.HorizontalFlyLoop:Disconnect() _G.HorizontalFlyLoop = nil end
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end
    end
end

local function startHorizontalFly(character)
    local rootPart = character:WaitForChild("HumanoidRootPart", 5)
    local humanoid = character:WaitForChild("Humanoid", 5)
    if not rootPart or not humanoid then return end
    
    currentLockHeight = TARGET_POS.Y
    
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then part.Velocity = Vector3.zero end
    end
    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    
    flyLoop = RunService.Heartbeat:Connect(function(dt)
        if not flyEnabled then stopFly() return end
        if not character or not character.Parent or not rootPart then stopFly() return end
        
        local currentPos = rootPart.Position
        local flatCurrent = Vector3.new(currentPos.X, 0, currentPos.Z)
        local flatTarget = Vector3.new(TARGET_POS.X, 0, TARGET_POS.Z)
        local distanceToTarget = (flatTarget - flatCurrent).Magnitude
        
        if distanceToTarget > 10 then
            isArrived = false
            hasReceivedSpins = false
            currentLockHeight = TARGET_POS.Y
        end
        
        local velocity = Vector3.new(0, 0, 0)
        
        if not isArrived then
            if distanceToTarget > 2 then
                currentLockHeight = TARGET_POS.Y
                local autoDirection = (flatTarget - flatCurrent).Unit
                velocity = Vector3.new(autoDirection.X * FLY_SPEED, 0, autoDirection.Z * FLY_SPEED)
            else
                isArrived = true
                if not hasReceivedSpins then
                    hasReceivedSpins = true
                    print("[Neya Hub] Gain : Tu as reçu 5 Spins !")
                end
            end
        else
            currentLockHeight = currentLockHeight - (5 * dt)
            velocity = Vector3.new(0, 0, 0)
        end
        
        rootPart.Velocity = velocity
        rootPart.CFrame = CFrame.new(rootPart.Position.X, currentLockHeight, rootPart.Position.Z) * rootPart.CFrame.Rotation
    end)
    _G.HorizontalFlyLoop = flyLoop
end

Window:AddToggle("Instant Claim Spin", function(state)
    flyEnabled = state
    if flyEnabled then
        hasReceivedSpins = false
        isArrived = false
        currentLockHeight = TARGET_POS.Y
        if player.Character then startHorizontalFly(player.Character) end
        player.CharacterAdded:Connect(function(newCharacter)
            if flyEnabled then 
                task.wait(0.5) 
                isArrived = false
                currentLockHeight = TARGET_POS.Y
                startHorizontalFly(newCharacter) 
            end
        end)
    else
        stopFly()
    end
end)


-- =============================================
-- SCRIPT 2 : GLASS BRIDGE ESP
-- =============================================

local espEnabled = false
local espFolder = nil

local function clearESP()
    local oldGui = game.CoreGui:FindFirstChild("GlassBridgeESP")
    if oldGui then oldGui:Destroy() end
    espFolder = nil
end

local function createMarker(part, isSafe)
    if not part:IsA("BasePart") then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 50, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.ExtentsOffset = Vector3.new(0, 2, 0)
    billboard.Adornee = part
    billboard.Parent = espFolder
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextSize = 28
    label.Font = Enum.Font.SourceSansBold
    if isSafe then
        label.Text = "✅"
        part.Color = Color3.fromRGB(0, 255, 120)
        part.Transparency = 0.5
    else
        label.Text = "❌"
        part.Color = Color3.fromRGB(255, 50, 50)
        part.Transparency = 0.5
    end
    label.Parent = billboard
end

local function startESP()
    clearESP()
    espFolder = Instance.new("Folder")
    espFolder.Name = "GlassBridgeESP"
    espFolder.Parent = game.CoreGui
    local mainFolder = workspace:FindFirstChild("Obbies")
    if mainFolder then
        local count = 0
        for _, object in ipairs(mainFolder:GetDescendants()) do
            if object:IsA("BasePart") and (object.Name == "Glass1" or object.Name == "Glass2") then
                local hasTouchInterest = object:FindFirstChildWhichIsA("TouchTransmitter") or object:FindFirstChild("TouchInterest")
                local isSolid = object.CanCollide and not hasTouchInterest
                createMarker(object, isSolid)
                count = count + 1
            end
        end
        print("[Scanner] Terminé ! " .. tostring(count) .. " vitres marquées !")
    else
        warn("[Scanner] Impossible de trouver 'Obbies' dans le Workspace.")
    end
end

Window:AddToggle("Glass Bridge ESP", function(state)
    espEnabled = state
    if espEnabled then startESP() else clearESP() end
end)


-- =============================================
-- SCRIPT 3 : x2 FREE SPIN (TAILLE x25)
-- =============================================

local afkOriginalSizes = {}

Window:AddToggle("x2 Free Spin (x25 Size)", function(state)
    local spawnFolder = workspace:FindFirstChild("Spawn")
    if not spawnFolder then
        warn("Dossier 'Spawn' introuvable.")
        return
    end
    local afkArena = spawnFolder:FindFirstChild("AFKArena")
    if not afkArena then
        warn("'AFKArena' introuvable dans Workspace.Spawn.")
        return
    end

    local parts = {}
    if afkArena:IsA("BasePart") then table.insert(parts, afkArena) end
    for _, child in ipairs(afkArena:GetDescendants()) do
        if child:IsA("BasePart") then table.insert(parts, child) end
    end

    if state then
        afkOriginalSizes = {}
        for _, part in ipairs(parts) do
            afkOriginalSizes[part] = part.Size
            part.Size = part.Size * 25
        end
        print("x2 Free Spin activé : AFKArena agrandi x25.")
    else
        for _, part in ipairs(parts) do
            if afkOriginalSizes[part] then
                part.Size = afkOriginalSizes[part]
            end
        end
        afkOriginalSizes = {}
        print("x2 Free Spin désactivé.")
    end
end)

-- Crédits finaux
Window:AddCredit("YouTube: @NeyaScripte")
