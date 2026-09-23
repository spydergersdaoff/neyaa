-- [[ Neya Menu - Loader & Rayfield Integration ]] --
if game.CoreGui:FindFirstChild("OverwatchMainMenu") then
    game.CoreGui.OverwatchMainMenu:Destroy()
end
if game.CoreGui:FindFirstChild("NeyaDiscordBannerGui") then
    game.CoreGui.NeyaDiscordBannerGui:Destroy()
end
if game.CoreGui:FindFirstChild("Rayfield") then
    game.CoreGui.Rayfield:Destroy()
end

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Config = {
    AccentColor = Color3.fromRGB(255, 153, 0), -- Orange Overwatch 2
    SecondaryColor = Color3.fromRGB(18, 25, 36),
    DarkBg = Color3.fromRGB(11, 15, 22)
}

-- Son natif
local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://9114220405"
clickSound.Volume = 1
clickSound.Parent = CoreGui

-- ==========================================================
-- 1. MENU PRINCIPAL (STYLE OVERWATCH 2)
-- ==========================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OverwatchMainMenu"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Background = Instance.new("Frame")
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundColor3 = Config.DarkBg
Background.BackgroundTransparency = 0.35
Background.Parent = ScreenGui

local MenuContainer = Instance.new("Frame")
MenuContainer.Size = UDim2.new(0, 450, 0, 250)
MenuContainer.Position = UDim2.new(0, 100, 0, 180)
MenuContainer.BackgroundTransparency = 1
MenuContainer.Parent = Background

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = MenuContainer
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

local function createButton(text, size, isSmall, order)
    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Size = UDim2.new(1, 0, 0, size)
    ButtonFrame.BackgroundTransparency = 1
    ButtonFrame.LayoutOrder = order
    ButtonFrame.Parent = MenuContainer

    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 5, 0, size - 8)
    Indicator.Position = UDim2.new(0, 0, 0, 4)
    Indicator.BackgroundColor3 = Config.AccentColor
    Indicator.BorderSizePixel = 0
    Indicator.BackgroundTransparency = 1
    Indicator.Parent = ButtonFrame

    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    IndicatorCorner.Parent = Indicator

    local TextButton = Instance.new("TextButton")
    TextButton.Size = UDim2.new(1, -25, 1, 0)
    TextButton.Position = UDim2.new(0, 25, 0, 0)
    TextButton.BackgroundTransparency = 1
    TextButton.Font = Enum.Font.GothamBlack
    TextButton.Text = text
    TextButton.TextColor3 = isSmall and Color3.fromRGB(145, 160, 180) or Color3.fromRGB(235, 240, 250)
    TextButton.TextSize = size * 0.52
    TextButton.TextXAlignment = Enum.TextXAlignment.Left
    TextButton.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Heavy, Enum.FontStyle.Italic)
    TextButton.Parent = ButtonFrame

    TextButton.MouseEnter:Connect(function()
        TweenService:Create(TextButton, TweenInfo.new(0.15), {TextColor3 = Config.AccentColor, TextSize = (size * 0.52) + 2}):Play()
        TweenService:Create(Indicator, TweenInfo.new(0.15), {BackgroundTransparency = 0, BackgroundColor3 = Config.AccentColor}):Play()
        clickSound.TimePosition = 0; clickSound.Volume = 0.25; clickSound:Play()
    end)

    TextButton.MouseLeave:Connect(function()
        local normalColor = isSmall and Color3.fromRGB(145, 160, 180) or Color3.fromRGB(235, 240, 250)
        TweenService:Create(TextButton, TweenInfo.new(0.15), {TextColor3 = normalColor, TextSize = size * 0.52}):Play()
        TweenService:Create(Indicator, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
    end)

    TextButton.MouseButton1Click:Connect(function()
        clickSound.TimePosition = 0; clickSound.Volume = 0.8; clickSound:Play()
    end)

    return TextButton
end

local PlayBtn = createButton("PLAY", 55, false, 1)
local SocialBtn = createButton("SOCIAL", 35, true, 2)
local ExitBtn = createButton("EXIT GAME", 35, true, 3)

-- ==========================================================
-- 2. BANNIÈRE DISCORD FIXE (HAUT MILIEU)
-- ==========================================================
local BannerGui = Instance.new("ScreenGui")
BannerGui.Name = "NeyaDiscordBannerGui"
BannerGui.Parent = CoreGui
BannerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local PlayDiscordBanner = Instance.new("TextButton")
PlayDiscordBanner.Name = "PlayDiscordBanner"
PlayDiscordBanner.Size = UDim2.new(0, 320, 0, 45)
PlayDiscordBanner.Position = UDim2.new(0.5, -160, 0, -60)
PlayDiscordBanner.BackgroundColor3 = Config.SecondaryColor
PlayDiscordBanner.BackgroundTransparency = 0.25
PlayDiscordBanner.BorderSizePixel = 0
PlayDiscordBanner.AutoButtonColor = false
PlayDiscordBanner.Font = Enum.Font.GothamBold
PlayDiscordBanner.Text = "discord.gg/neyamenu"
PlayDiscordBanner.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayDiscordBanner.TextSize = 15
PlayDiscordBanner.ZIndex = 50
PlayDiscordBanner.Parent = BannerGui

local BannerCorner = Instance.new("UICorner")
BannerCorner.CornerRadius = UDim.new(0, 6)
BannerCorner.Parent = PlayDiscordBanner

local BannerStroke = Instance.new("UIStroke")
BannerStroke.Color = Config.AccentColor
BannerStroke.Thickness = 1.5
BannerStroke.Parent = PlayDiscordBanner

PlayDiscordBanner.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard("discord.gg/neyamenu")
    elseif toclipboard then toclipboard("discord.gg/neyamenu") end
    clickSound.TimePosition = 0; clickSound.Volume = 1; clickSound:Play()
    PlayDiscordBanner.TextColor3 = Color3.fromRGB(50, 255, 100)
    PlayDiscordBanner.Text = "✓ LIEN COPIÉ !"
    task.wait(1)
    PlayDiscordBanner.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayDiscordBanner.Text = "discord.gg/neyamenu"
end)

-- ==========================================================
-- 3. POPUP SOCIAL
-- ==========================================================
local SocialPopup = Instance.new("Frame")
SocialPopup.Size = UDim2.new(0, 360, 0, 90)
SocialPopup.Position = UDim2.new(0.5, -180, 0.5, -45)
SocialPopup.BackgroundColor3 = Config.SecondaryColor
SocialPopup.BorderSizePixel = 0
SocialPopup.Visible = false
SocialPopup.ZIndex = 10
SocialPopup.Parent = Background

local PopupCorner = Instance.new("UICorner")
PopupCorner.CornerRadius = UDim.new(0, 8)
PopupCorner.Parent = SocialPopup

local PopupStroke = Instance.new("UIStroke")
PopupStroke.Color = Config.AccentColor
PopupStroke.Thickness = 2
PopupStroke.Parent = SocialPopup

local DiscordTextBtn = Instance.new("TextButton")
DiscordTextBtn.Size = UDim2.new(1, 0, 1, 0)
DiscordTextBtn.BackgroundTransparency = 1
DiscordTextBtn.Font = Enum.Font.GothamBlack
DiscordTextBtn.Text = "discord.gg/neyamenu"
DiscordTextBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordTextBtn.TextSize = 22
DiscordTextBtn.ZIndex = 11
DiscordTextBtn.Parent = SocialPopup

DiscordTextBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard("discord.gg/neyamenu")
    elseif toclipboard then toclipboard("discord.gg/neyamenu") end
    clickSound.TimePosition = 0; clickSound.Volume = 1; clickSound:Play()
    DiscordTextBtn.TextColor3 = Color3.fromRGB(50, 255, 100)
    DiscordTextBtn.Text = "✓ LIEN COPIÉ !"
    task.wait(0.8)
    DiscordTextBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    DiscordTextBtn.Text = "discord.gg/neyamenu"
end)

-- ==========================================================
-- 4. ACTIONS DES BOUTONS & CHARGEMENT EXTERNE
-- ==========================================================
PlayBtn.MouseButton1Click:Connect(function()
    print("[Neya] PLAY / Lancement...")
    SocialPopup.Visible = false
    
    -- Animation du menu principal
    TweenService:Create(MenuContainer, TweenInfo.new(0.4), {Position = UDim2.new(0, -500, 0, 180)}):Play()
    TweenService:Create(Background, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()

    -- Fixe la bannière Discord en haut
    TweenService:Create(PlayDiscordBanner, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -160, 0, 15)
    }):Play()

    -- 1. Exécute ton loader distant (qui contient ton interface externe ou tes scripts)
    task.spawn(function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/spydergersdaoff/neyaa/refs/heads/main/loader.lua"))()
        end)
        if not success then
            warn("[Neya Loader] Erreur : " .. tostring(err))
        end
    end)

    -- 2. (Optionnel) Si tu veux charger Rayfield directement depuis son lien officiel à la place de l'UI interne :
    -- Décommente la ligne ci-dessous si ton loader ne le fait pas déjà :
    -- local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

    -- Nettoyage du menu principal de départ après l'animation
    task.delay(0.5, function()
        ScreenGui:Destroy()
    end)
end)

SocialBtn.MouseButton1Click:Connect(function()
    SocialPopup.Visible = not SocialPopup.Visible
end)

ExitBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    BannerGui:Destroy()
    clickSound:Destroy()
end)

print("[Neya Menu] Prêt ! Le menu gère proprement ton loader externe sans alourdir le code.")
