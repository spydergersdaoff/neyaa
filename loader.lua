--[[
    Neya Game Hub - Dynamic Loader (From URL)
    Auteur: @NeyaScripte
]]

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- Nettoyage de l'ancien UI si besoin
if CoreGui:FindFirstChild("NeyaGameHub") then
    CoreGui.NeyaGameHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local TopBar = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local SearchBox = Instance.new("TextBox")
local SearchCorner = Instance.new("UICorner")
local Container = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local CloseBtn = Instance.new("TextButton")
local CloseCorner = Instance.new("UICorner")

ScreenGui.Name = "NeyaGameHub"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -150)
MainFrame.Size = UDim2.new(0, 260, 0, 300)
MainFrame.ClipsDescendants = true

UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = MainFrame

-- Barre du haut
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 30)

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 6)
TopBarCorner.Parent = TopBar

TitleLabel.Parent = TopBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.Size = UDim2.new(1, -35, 1, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "Neya Hub"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 11
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Bouton de fermeture (Rouge)
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = TopBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
CloseBtn.Position = UDim2.new(1, -22, 0.5, -5)
CloseBtn.Size = UDim2.new(0, 10, 0, 10)
CloseBtn.Text = ""
CloseBtn.AutoButtonColor = false

CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Barre de recherche (Anglais uniquement)
SearchBox.Name = "SearchBox"
SearchBox.Parent = MainFrame
SearchBox.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
SearchBox.BorderSizePixel = 0
SearchBox.Position = UDim2.new(0, 8, 0, 38)
SearchBox.Size = UDim2.new(1, -16, 0, 26)
SearchBox.Font = Enum.Font.GothamMedium
SearchBox.PlaceholderText = "Search scripts..."
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
SearchBox.TextSize = 11

SearchCorner.CornerRadius = UDim.new(0, 4)
SearchCorner.Parent = SearchBox

-- Conteneur de la liste
Container.Name = "Container"
Container.Parent = MainFrame
Container.Active = true
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 8, 0, 70)
Container.Size = UDim2.new(1, -16, 1, -78)
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.ScrollBarThickness = 3

UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

local gameItems = {}

local function AddGameCard(gameName, gameId, scriptUrl)
    local GameCard = Instance.new("Frame")
    local CardCorner = Instance.new("UICorner")
    local InfoContainer = Instance.new("Frame")
    local NameLabel = Instance.new("TextLabel")
    local IdLabel = Instance.new("TextLabel")
    local SelectBtn = Instance.new("TextButton")
    local BtnCorner = Instance.new("UICorner")

    GameCard.Parent = Container
    GameCard.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    GameCard.BorderSizePixel = 0
    GameCard.Size = UDim2.new(1, 0, 0, 42)

    CardCorner.CornerRadius = UDim.new(0, 4)
    CardCorner.Parent = GameCard

    InfoContainer.Parent = GameCard
    InfoContainer.BackgroundTransparency = 1
    InfoContainer.Position = UDim2.new(0, 8, 0, 0)
    InfoContainer.Size = UDim2.new(1, -75, 1, 0)

    NameLabel.Parent = InfoContainer
    NameLabel.BackgroundTransparency = 1
    NameLabel.Position = UDim2.new(0, 0, 0, 4)
    NameLabel.Size = UDim2.new(1, 0, 0, 16)
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.Text = gameName
    NameLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    NameLabel.TextSize = 11
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left

    IdLabel.Parent = InfoContainer
    IdLabel.BackgroundTransparency = 1
    IdLabel.Position = UDim2.new(0, 0, 0, 20)
    IdLabel.Size = UDim2.new(1, 0, 0, 14)
    IdLabel.Font = Enum.Font.Gotham
    IdLabel.Text = "ID: " .. tostring(gameId)
    IdLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    IdLabel.TextSize = 10
    IdLabel.TextXAlignment = Enum.TextXAlignment.Left

    SelectBtn.Parent = GameCard
    SelectBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    SelectBtn.Position = UDim2.new(1, -62, 0.5, -11)
    SelectBtn.Size = UDim2.new(0, 54, 0, 22)
    SelectBtn.Font = Enum.Font.GothamBold
    SelectBtn.Text = "Select"
    SelectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SelectBtn.TextSize = 10
    SelectBtn.AutoButtonColor = true

    BtnCorner.CornerRadius = UDim.new(0, 3)
    BtnCorner.Parent = SelectBtn

    SelectBtn.MouseButton1Click:Connect(function()
        SelectBtn.Text = "Launch"
        SelectBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 80)
        
        task.wait(0.2)
        ScreenGui:Destroy()
        
        -- Télécharge et exécute le script distant récupéré depuis le fichier texte
        local success, err = pcall(function()
            loadstring(game:HttpGet(scriptUrl))()
        end)
        if not success then
            warn("Erreur de chargement du script : " .. tostring(err))
        end
    end)

    table.insert(gameItems, {Frame = GameCard, Name = gameName:lower(), Id = tostring(gameId)})
    Container.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end

-- Chargement automatique depuis ton site Vercel
task.spawn(function()
    local success, response = pcall(function()
        return game:HttpGet("neyaa.vercel.app/liste.txt")
    end)

    if success and response then
        for line in response:gmatch("[^\r\n]+") do
            -- On sépare les éléments par le caractère |
            local name, id, url = line:match("^%s*(.-)%s*|%s*(.-)%s*|%s*(.-)%s*$")
            if name and id and url then
                AddGameCard(name, id, url)
            end
        end
    else
        warn("Impossible de charger la liste des scripts depuis Vercel.")
    end
end)

-- Filtrage de la recherche en direct
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local searchText = SearchBox.Text:lower()
    for _, item in ipairs(gameItems) do
        if item.Name:find(searchText) or item.Id:find(searchText) then
            item.Frame.Visible = true
        else
            item.Frame.Visible = false
        end
    end
    Container.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end)
