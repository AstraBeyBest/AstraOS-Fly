-- AstraOS Ultimate Client - Optimize Edilmiş Sürüm
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Önceki GUI varsa temizle
if CoreGui:FindFirstChild("AstraOS_GUI") then
    CoreGui.AstraOS_GUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "AstraOS_GUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local keys = {W = false, A = false, S = false, D = false, Space = false, LeftShift = false}

-- ================= AÇMA / KAPAMA (TOGGLE) BUTONU =================
local ToggleMenuButton = Instance.new("TextButton", ScreenGui)
ToggleMenuButton.Name = "ToggleMenuButton"
ToggleMenuButton.Size = UDim2.new(0, 0, 0, 0)
ToggleMenuButton.Position = UDim2.new(0, 18, 0, 125)
ToggleMenuButton.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
ToggleMenuButton.Font = Enum.Font.GothamBold
ToggleMenuButton.Text = "ASTRA"
ToggleMenuButton.TextColor3 = Color3.fromRGB(0, 240, 255)
ToggleMenuButton.TextSize = 18
ToggleMenuButton.AutoButtonColor = false
ToggleMenuButton.Visible = false
ToggleMenuButton.ClipsDescendants = false

Instance.new("UICorner", ToggleMenuButton).CornerRadius = UDim.new(1, 0)

local ToggleStroke = Instance.new("UIStroke", ToggleMenuButton)
ToggleStroke.Color = Color3.fromRGB(0, 240, 255)
ToggleStroke.Thickness = 2.5

local BtnGlow = Instance.new("UIStroke", ToggleMenuButton)
BtnGlow.Color = Color3.fromRGB(0, 240, 255)
BtnGlow.Thickness = 6
BtnGlow.Transparency = 0.4

local PulseRing = Instance.new("Frame", ToggleMenuButton)
PulseRing.Size = UDim2.new(1, 10, 1, 10)
PulseRing.Position = UDim2.new(0, -5, 0, -5)
PulseRing.BackgroundTransparency = 1
PulseRing.ZIndex = ToggleMenuButton.ZIndex - 1
Instance.new("UICorner", PulseRing).CornerRadius = UDim.new(1, 0)

local PulseStroke = Instance.new("UIStroke", PulseRing)
PulseStroke.Color = Color3.fromRGB(0, 240, 255)
PulseStroke.Thickness = 1.5
PulseStroke.Transparency = 0.5

ToggleMenuButton.MouseEnter:Connect(function()
    TweenService:Create(ToggleMenuButton, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {BackgroundColor3 = Color3.fromRGB(20, 25, 35)}):Play()
    TweenService:Create(ToggleStroke, TweenInfo.new(0.2), {Thickness = 3.5}):Play()
end)

ToggleMenuButton.MouseLeave:Connect(function()
    TweenService:Create(ToggleMenuButton, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {BackgroundColor3 = Color3.fromRGB(12, 12, 18)}):Play()
    TweenService:Create(ToggleStroke, TweenInfo.new(0.2), {Thickness = 2.5}):Play()
end)

local draggingToggle, dragInputToggle, toggleStartPos, startPosToggle
ToggleMenuButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingToggle = true
        toggleStartPos = input.Position
        startPosToggle = ToggleMenuButton.Position
        TweenService:Create(ToggleMenuButton, TweenInfo.new(0.15), {Size = UDim2.new(0, 75, 0, 75)}):Play()
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingToggle = false
                TweenService:Create(ToggleMenuButton, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Size = UDim2.new(0, 85, 0, 85)}):Play()
            end
        end)
    end
end)

ToggleMenuButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInputToggle = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInputToggle and draggingToggle then
        local delta = input.Position - toggleStartPos
        ToggleMenuButton.Position = UDim2.new(startPosToggle.X.Scale, startPosToggle.X.Offset + delta.X, startPosToggle.Y.Scale, startPosToggle.Y.Offset + delta.Y)
    end
end)

-- ================= ANA KONTROL PANELİ =================
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 340, 0, 508)
MainFrame.Position = UDim2.new(0, 110, 0, 125)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.Active = true

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 20)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(0, 240, 255)
MainStroke.Thickness = 2.5
MainStroke.Transparency = 0.1

local MainGradient = Instance.new("UIGradient", MainFrame)
MainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 25, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 12))
})
MainGradient.Rotation = 135

local draggingMain, dragInputMain, mainStartPos, startPosMain
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingMain = true
        mainStartPos = input.Position
        startPosMain = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingMain = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInputMain = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInputMain and draggingMain then
        local delta = input.Position - mainStartPos
        MainFrame.Position = UDim2.new(startPosMain.X.Scale, startPosMain.X.Offset + delta.X, startPosMain.Y.Scale, startPosMain.Y.Offset + delta.Y)
    end
end)

local TitleLabel = Instance.new("TextLabel", MainFrame)
TitleLabel.Size = UDim2.new(1, 0, 0, 45)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.Text = "  ⚡ AstraOS // MISC Script"
TitleLabel.TextColor3 = Color3.fromRGB(0, 240, 255)
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local TitleLine = Instance.new("Frame", MainFrame)
TitleLine.Size = UDim2.new(0.9, 0, 0, 2)
TitleLine.Position = UDim2.new(0.05, 0, 0, 45)
TitleLine.BackgroundColor3 = Color3.fromRGB(0, 240, 255)
TitleLine.BackgroundTransparency = 0.3
TitleLine.BorderSizePixel = 0

local function createButton(posY, text)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 42)
    btn.Position = UDim2.new(0.05, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(15, 35, 50)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.AutoButtonColor = false
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(0, 240, 255)
    stroke.Thickness = 2

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 55, 75)}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Thickness = 2.5}):Play()
    end)
    btn.MouseLeave:Connect(function()
        if not btn:GetAttribute("ActiveState") then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(15, 35, 50)}):Play()
        end
        TweenService:Create(stroke, TweenInfo.new(0.2), {Thickness = 2}):Play()
    end)
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(0.86, 0, 0, 38)}):Play()
    end)
    btn.MouseButton1Up:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(0.9, 0, 0, 42)}):Play()
    end)

    return btn, stroke
end

local FlyButton, FlyBtnStroke = createButton(55, "UÇUŞ MODU [ KAPALI ]")
local NoclipButton, NoclipBtnStroke = createButton(103, "NOCLIP [ KAPALI ]")
local ResolutionButton, ResBtnStroke = createButton(151, "FOV CHANGER: [ KAPALI ]")
local TrailButton, TrailBtnStroke = createButton(199, "RGB TRAIL: [ KAPALI ]")
local SpinButton, SpinBtnStroke = createButton(247, "SPINBOT [ KAPALI ]")

-- Spin Hızı Kontrolü
local SpinSpeedContainer = Instance.new("Frame", MainFrame)
SpinSpeedContainer.Size = UDim2.new(0.9, 0, 0, 38)
SpinSpeedContainer.Position = UDim2.new(0.05, 0, 0, 295)
SpinSpeedContainer.BackgroundTransparency = 1

local SpinSpeedLabel = Instance.new("TextLabel", SpinSpeedContainer)
SpinSpeedLabel.Size = UDim2.new(1, 0, 1, 0)
SpinSpeedLabel.BackgroundTransparency = 1
SpinSpeedLabel.Font = Enum.Font.GothamBold
SpinSpeedLabel.Text = "SPIN SPEED: 35"
SpinSpeedLabel.TextColor3 = Color3.fromRGB(220, 180, 255)
SpinSpeedLabel.TextSize = 13

local SpinMinusBtn = Instance.new("TextButton", SpinSpeedContainer)
SpinMinusBtn.Size = UDim2.new(0, 35, 0, 35)
SpinMinusBtn.Position = UDim2.new(0, 0, 0.5, -17.5)
SpinMinusBtn.BackgroundColor3 = Color3.fromRGB(40, 15, 20)
SpinMinusBtn.Font = Enum.Font.GothamBold
SpinMinusBtn.Text = "-"
SpinMinusBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
SpinMinusBtn.TextSize = 16
SpinMinusBtn.AutoButtonColor = false
Instance.new("UICorner", SpinMinusBtn).CornerRadius = UDim.new(0, 10)

local SpinPlusBtn = Instance.new("TextButton", SpinSpeedContainer)
SpinPlusBtn.Size = UDim2.new(0, 35, 0, 35)
SpinPlusBtn.Position = UDim2.new(1, -35, 0.5, -17.5)
SpinPlusBtn.BackgroundColor3 = Color3.fromRGB(15, 40, 25)
SpinPlusBtn.Font = Enum.Font.GothamBold
SpinPlusBtn.Text = "+"
SpinPlusBtn.TextColor3 = Color3.fromRGB(90, 255, 150)
SpinPlusBtn.TextSize = 16
SpinPlusBtn.AutoButtonColor = false
Instance.new("UICorner", SpinPlusBtn).CornerRadius = UDim.new(0, 10)

-- Velocity Kontrolü
local SpeedContainer = Instance.new("Frame", MainFrame)
SpeedContainer.Size = UDim2.new(0.9, 0, 0, 38)
SpeedContainer.Position = UDim2.new(0.05, 0, 0, 339)
SpeedContainer.BackgroundTransparency = 1

local SpeedLabel = Instance.new("TextLabel", SpeedContainer)
SpeedLabel.Size = UDim2.new(1, 0, 1, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.Text = "VELOCITY: 50"
SpeedLabel.TextColor3 = Color3.fromRGB(180, 220, 255)
SpeedLabel.TextSize = 13

local MinusBtn = Instance.new("TextButton", SpeedContainer)
MinusBtn.Size = UDim2.new(0, 35, 0, 35)
MinusBtn.Position = UDim2.new(0, 0, 0.5, -17.5)
MinusBtn.BackgroundColor3 = Color3.fromRGB(40, 15, 20)
MinusBtn.Font = Enum.Font.GothamBold
MinusBtn.Text = "-"
MinusBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
MinusBtn.TextSize = 16
MinusBtn.AutoButtonColor = false
Instance.new("UICorner", MinusBtn).CornerRadius = UDim.new(0, 10)

local PlusBtn = Instance.new("TextButton", SpeedContainer)
PlusBtn.Size = UDim2.new(0, 35, 0, 35)
PlusBtn.Position = UDim2.new(1, -35, 0.5, -17.5)
PlusBtn.BackgroundColor3 = Color3.fromRGB(15, 40, 25)
PlusBtn.Font = Enum.Font.GothamBold
PlusBtn.Text = "+"
PlusBtn.TextColor3 = Color3.fromRGB(90, 255, 150)
PlusBtn.TextSize = 16
PlusBtn.AutoButtonColor = false
Instance.new("UICorner", PlusBtn).CornerRadius = UDim.new(0, 10)

-- RGB Tema Toggle Butonu
local RGBToggleBtn = Instance.new("TextButton", MainFrame)
RGBToggleBtn.Size = UDim2.new(0.9, 0, 0, 35)
RGBToggleBtn.Position = UDim2.new(0.05, 0, 0, 384)
RGBToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
RGBToggleBtn.Font = Enum.Font.GothamBold
RGBToggleBtn.Text = "RGB TEMA: [ AÇIK ]"
RGBToggleBtn.TextColor3 = Color3.fromRGB(0, 240, 255)
RGBToggleBtn.TextSize = 13
RGBToggleBtn.AutoButtonColor = false
Instance.new("UICorner", RGBToggleBtn).CornerRadius = UDim.new(0, 10)
local RGBToggleStroke = Instance.new("UIStroke", RGBToggleBtn)
RGBToggleStroke.Color = Color3.fromRGB(0, 240, 255)
RGBToggleStroke.Thickness = 1.5

-- ================= YÜKLEME EKRANI =================
local LoadingFrame = Instance.new("Frame", ScreenGui)
LoadingFrame.Name = "LoadingFrame"
LoadingFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
LoadingFrame.BorderSizePixel = 0
LoadingFrame.Position = UDim2.new(0.5, -160, 0.5, -80)
LoadingFrame.Size = UDim2.new(0, 320, 0, 160)
LoadingFrame.BackgroundTransparency = 1

Instance.new("UICorner", LoadingFrame).CornerRadius = UDim.new(0, 16)
local LoadingStroke = Instance.new("UIStroke", LoadingFrame)
LoadingStroke.Thickness = 2
LoadingStroke.Transparency = 1

local LoadingText = Instance.new("TextLabel", LoadingFrame)
LoadingText.BackgroundTransparency = 1
LoadingText.Position = UDim2.new(0, 0, 0.25, 0)
LoadingText.Size = UDim2.new(1, 0, 0, 40)
LoadingText.Font = Enum.Font.GothamBlack
LoadingText.Text = "⚡ AstraOS Yükleniyor..."
LoadingText.TextColor3 = Color3.fromRGB(0, 240, 255)
LoadingText.TextSize = 18
LoadingText.TextTransparency = 1

local BarBackground = Instance.new("Frame", LoadingFrame)
BarBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
BarBackground.BorderSizePixel = 0
BarBackground.Position = UDim2.new(0.1, 0, 0.65, 0)
BarBackground.Size = UDim2.new(0.8, 0, 0, 10)
BarBackground.BackgroundTransparency = 1
Instance.new("UICorner", BarBackground).CornerRadius = UDim.new(1, 0)

local BarFill = Instance.new("Frame", BarBackground)
BarFill.BackgroundColor3 = Color3.fromRGB(0, 240, 255)
BarFill.BorderSizePixel = 0
BarFill.Size = UDim2.new(0, 0, 1, 0)
Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

TweenService:Create(LoadingFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {BackgroundTransparency = 0.15}):Play()
TweenService:Create(LoadingStroke, TweenInfo.new(0.5), {Transparency = 0.2}):Play()
TweenService:Create(LoadingText, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
TweenService:Create(BarBackground, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()

task.spawn(function()
    local tween = TweenService:Create(BarFill, TweenInfo.new(1.2, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 1, 0)})
    tween:Play()
    tween.Completed:Wait()
    
    TweenService:Create(LoadingFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {BackgroundTransparency = 1, Size = UDim2.new(0, 280, 0, 140)}):Play()
    TweenService:Create(LoadingStroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
    TweenService:Create(LoadingText, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(BarBackground, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    TweenService:Create(BarFill, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    task.wait(0.4)
    LoadingFrame:Destroy()
    
    ToggleMenuButton.Visible = true
    TweenService:Create(ToggleMenuButton, TweenInfo.new(0.6, Enum.EasingStyle.Back), {Size = UDim2.new(0, 85, 0, 85)}):Play()
end)

-- ================= RGB & NEFES ALMA DÖNGÜSÜ =================
local rgbEnabled = true
local rgbCounter = 0
local currentGlobalRgb = Color3.fromRGB(0, 240, 255)

RunService.RenderStepped:Connect(function(dt)
    if rgbEnabled then
        rgbCounter = rgbCounter + (dt * 0.2)
        currentGlobalRgb = Color3.fromHSV(rgbCounter % 1, 1, 1)
        
        MainStroke.Color = currentGlobalRgb
        TitleLine.BackgroundColor3 = currentGlobalRgb
        TitleLabel.TextColor3 = currentGlobalRgb
        ToggleStroke.Color = currentGlobalRgb
        BtnGlow.Color = currentGlobalRgb
        PulseStroke.Color = currentGlobalRgb
        RGBToggleBtn.TextColor3 = currentGlobalRgb
        RGBToggleStroke.Color = currentGlobalRgb
    end
end)

task.spawn(function()
    while true do
        TweenService:Create(BtnGlow, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {Transparency = 0.1, Thickness = 8}):Play()
        TweenService:Create(PulseRing, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {Size = UDim2.new(1, 20, 1, 20), Position = UDim2.new(0, -10, 0, -10)}):Play()
        task.wait(1.2)
        TweenService:Create(BtnGlow, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {Transparency = 0.6, Thickness = 4}):Play()
        TweenService:Create(PulseRing, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {Size = UDim2.new(1, 5, 1, 5), Position = UDim2.new(0, -2.5, 0, -2.5)}):Play()
        task.wait(1.2)
    end
end)

local menuOpen = false
ToggleMenuButton.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    TweenService:Create(ToggleMenuButton, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Rotation = menuOpen and 180 or 0}):Play()
    if menuOpen then
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 10, 0, 10)
        TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back), {Size = UDim2.new(0, 340, 0, 508)}):Play()
    else
        local t = TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {Size = UDim2.new(0, 0, 0, 0)})
        t:Play()
        t.Completed:Wait()
        MainFrame.Visible = false
    end
end)

RGBToggleBtn.MouseButton1Click:Connect(function()
    rgbEnabled = not rgbEnabled
    if rgbEnabled then
        RGBToggleBtn.Text = "RGB TEMA: [ AÇIK ]"
    else
        RGBToggleBtn.Text = "RGB TEMA: [ KAPALI ]"
        local staticColor = Color3.fromRGB(0, 240, 255)
        MainStroke.Color = staticColor
        TitleLine.BackgroundColor3 = staticColor
        TitleLabel.TextColor3 = staticColor
        ToggleStroke.Color = staticColor
        BtnGlow.Color = staticColor
        PulseStroke.Color = staticColor
        RGBToggleBtn.TextColor3 = staticColor
        RGBToggleStroke.Color = staticColor
    end
end)

-- ================= BASIK EKRAN (STRETCHED RESOLUTION) =================
local resolutionEnabled = false
ResolutionButton.MouseButton1Click:Connect(function()
    resolutionEnabled = not resolutionEnabled
    ResolutionButton:SetAttribute("ActiveState", resolutionEnabled)
    if resolutionEnabled then
        ResolutionButton.Text = "BASIK EKRAN (STRETCH): [ AKTİF ]"
        TweenService:Create(ResolutionButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 150, 180)}):Play()
        TweenService:Create(ResBtnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 255, 255)}):Play()
        pcall(function() Camera.FieldOfView = 90 end)
    else
        ResolutionButton.Text = "BASIK EKRAN (STRETCH): [ KAPALI ]"
        TweenService:Create(ResolutionButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(15, 35, 50)}):Play()
        TweenService:Create(ResBtnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(0, 240, 255)}):Play()
        pcall(function() Camera.FieldOfView = 70 end)
    end
end)

-- ================= RGB TORSO TRAIL (İP ŞEKLİNDE GERÇEK TRAIL) =================
local trailEnabled = false
local trailConnection = nil

local function getTorso(char)
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

local function applyTrail(char)
    local torso = getTorso(char)
    if not torso then return end
    
    local att0 = Instance.new("Attachment", torso)
    att0.Name = "AstraOS_TrailAtt0"
    att0.Position = Vector3.new(0, 1, 0)
    
    local att1 = Instance.new("Attachment", torso)
    att1.Name = "AstraOS_TrailAtt1"
    att1.Position = Vector3.new(0, -1, 0)
    
    local trail = Instance.new("Trail", torso)
    trail.Name = "AstraOS_RgbTrail"
    trail.Attachment0 = att0
    trail.Attachment1 = att1
    trail.Color = ColorSequence.new(currentGlobalRgb)
    trail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    trail.Lifetime = 0.5
    trail.MinLength = 0.1
    trail.WidthScale = NumberSequence.new(0.2)
end

TrailButton.MouseButton1Click:Connect(function()
    trailEnabled = not trailEnabled
    TrailButton:SetAttribute("ActiveState", trailEnabled)
    
    if trailEnabled then
        TrailButton.Text = "RGB TORSO TRAIL (İP): [ AKTİF ]"
        TweenService:Create(TrailButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 150, 180)}):Play()
        TweenService:Create(TrailBtnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 255, 255)}):Play()
        
        applyTrail(LocalPlayer.Character)

        trailConnection = RunService.RenderStepped:Connect(function()
            local torso = getTorso(LocalPlayer.Character)
            if torso then
                local tr = torso:FindFirstChild("AstraOS_RgbTrail")
                if tr then
                    tr.Color = ColorSequence.new(currentGlobalRgb)
                end
            end
        end)
    else
        TrailButton.Text = "RGB TORSO TRAIL (İP): [ KAPALI ]"
        TweenService:Create(TrailButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(15, 35, 50)}):Play()
        TweenService:Create(TrailBtnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(0, 240, 255)}):Play()
        
        if trailConnection then
            trailConnection:Disconnect()
            trailConnection = nil
        end
        
        local torso = getTorso(LocalPlayer.Character)
        if torso then
            for _, child in ipairs(torso:GetChildren()) do
                if child.Name == "AstraOS_RgbTrail" or child.Name == "AstraOS_TrailAtt0" or child.Name == "AstraOS_TrailAtt1" then
                    child:Destroy()
                end
            end
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(newChar)
    if trailEnabled then
        task.wait(0.6)
        applyTrail(newChar)
    end
end)

-- ================= SPINBOT MANTIĞI =================
local spinEnabled = false
local spinSpeed = 35
local currentSpinAngle = 0

RunService.RenderStepped:Connect(function(dt)
    if spinEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = LocalPlayer.Character.HumanoidRootPart
        currentSpinAngle = (currentSpinAngle + (spinSpeed * dt * 60)) % 360
        rootPart.CFrame = CFrame.new(rootPart.Position) * CFrame.Angles(0, math.rad(currentSpinAngle), 0)
    end
end)

SpinButton.MouseButton1Click:Connect(function()
    spinEnabled = not spinEnabled
    SpinButton:SetAttribute("ActiveState", spinEnabled)
    if spinEnabled then
        SpinButton.Text = "SPINBOT [ AKTİF ]"
        TweenService:Create(SpinButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 150, 180)}):Play()
        TweenService:Create(SpinBtnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 255, 255)}):Play()
    else
        SpinButton.Text = "SPINBOT [ KAPALI ]"
        TweenService:Create(SpinButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(15, 35, 50)}):Play()
        TweenService:Create(SpinBtnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(0, 240, 255)}):Play()
    end
end)

SpinPlusBtn.MouseButton1Click:Connect(function()
    spinSpeed = math.clamp(spinSpeed + 25, 1, 2000)
    SpinSpeedLabel.Text = "SPIN SPEED: " .. spinSpeed
end)

SpinMinusBtn.MouseButton1Click:Connect(function()
    spinSpeed = math.clamp(spinSpeed - 25, 1, 2000)
    SpinSpeedLabel.Text = "SPIN SPEED: " .. spinSpeed
end)

-- ================= NOCLIP MANTIĞI =================
local noclipEnabled = false
local noclipConnection = nil

local function setNoclipState(state)
    noclipEnabled = state
    NoclipButton:SetAttribute("ActiveState", noclipEnabled)
    if noclipEnabled then
        NoclipButton.Text = "NOCLIP [ AKTİF ]"
        TweenService:Create(NoclipButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 150, 180)}):Play()
        TweenService:Create(NoclipBtnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 255, 255)}):Play()
        
        noclipConnection = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        NoclipButton.Text = "NOCLIP [ KAPALI ]"
        TweenService:Create(NoclipButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(15, 35, 50)}):Play()
        TweenService:Create(NoclipBtnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(0, 240, 255)}):Play()
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

NoclipButton.MouseButton1Click:Connect(function()
    setNoclipState(not noclipEnabled)
end)

-- ================= UÇUŞ MANTIĞI (FLY) =================
local flying = false
local flySpeed = 50
local currentVelocity = Vector3.zero
local flyAttachment, linearVelocity, alignOrientation, activeIdleTrack, flyConnection
local FLY_SOUND_ID = "rbxassetid://139095330035399"

local function getCharacterParts()
    local char = LocalPlayer.Character
    if not char then return nil, nil, nil end
    return char, char:FindFirstChild("HumanoidRootPart"), char:FindFirstChild("Humanoid")
end

local function playCurrentIdleAnimation()
    local char, _, hum = getCharacterParts()
    if not char or not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator") or hum:WaitForChild("Animator", 1)
    if not animator then return end
    pcall(function()
        if activeIdleTrack then activeIdleTrack:Stop(0.2) end
        local animateScript = char:FindFirstChild("Animate")
        local targetAnimId = "rbxassetid://507765000"
        if animateScript then
            local idleVal = animateScript:FindFirstChild("idle")
            if idleVal and idleVal:FindFirstChildOfClass("Animation") then
                targetAnimId = idleVal:FindFirstChildOfClass("Animation").AnimationId
            end
        end
        local anim = Instance.new("Animation")
        anim.AnimationId = targetAnimId
        activeIdleTrack = animator:LoadAnimation(anim)
        activeIdleTrack.Looped = true
        activeIdleTrack:Play(0.2)
    end)
end

local function applyGlideSound(state)
    local _, hrp = getCharacterParts()
    if not hrp then return end
    local sound = hrp:FindFirstChild("AstraOS_FlySound")
    if state then
        if not sound then
            sound = Instance.new("Sound", hrp)
            sound.Name = "AstraOS_FlySound"
            sound.SoundId = FLY_SOUND_ID
            sound.Looped = true
            sound.Volume = 0.5
        end
        if not sound.IsPlaying then sound:Play() end
    else
        if sound then sound:Stop(); sound:Destroy() end
    end
end

local stopFly

local function startFly()
    if flying then return end
    local char, hrp, hum = getCharacterParts()
    if not char or not hrp or not hum then return end
    flying = true
    FlyButton:SetAttribute("ActiveState", true)
    
    FlyButton.Text = "UÇUŞ MODU [ AKTİF ]"
    TweenService:Create(FlyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 150, 180)}):Play()
    TweenService:Create(FlyBtnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 255, 255)}):Play()

    if not noclipEnabled then setNoclipState(true) end

    local animateScript = char:FindFirstChild("Animate")
    if animateScript then animateScript.Disabled = true end

    flyAttachment = Instance.new("Attachment", hrp)
    flyAttachment.Name = "AstraOS_FlyAttachment"

    linearVelocity = Instance.new("LinearVelocity", hrp)
    linearVelocity.Name = "AstraOS_LinearVelocity"
    linearVelocity.Attachment0 = flyAttachment
    linearVelocity.MaxForce = math.huge
    linearVelocity.VectorVelocity = Vector3.zero
    linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World

    alignOrientation = Instance.new("AlignOrientation", hrp)
    alignOrientation.Name = "AstraOS_AlignOrientation"
    alignOrientation.Attachment0 = flyAttachment
    alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
    alignOrientation.MaxTorque = math.huge
    alignOrientation.Responsiveness = 200
    alignOrientation.CFrame = Camera.CFrame

    hum.PlatformStand = true
    currentVelocity = Vector3.zero
    playCurrentIdleAnimation()
    applyGlideSound(true)

    flyConnection = RunService.RenderStepped:Connect(function(dt)
        if not flying then return end
        local _, curHrp, curHum = getCharacterParts()
        if not curHrp or not curHum then stopFly(); return end
        
        local targetDir = Vector3.zero
        if keys.W then targetDir = targetDir + Camera.CFrame.LookVector end
        if keys.S then targetDir = targetDir - Camera.CFrame.LookVector end
        if keys.D then targetDir = targetDir + Camera.CFrame.RightVector end
        if keys.A then targetDir = targetDir - Camera.CFrame.RightVector end
        if keys.Space then targetDir = targetDir + Vector3.yAxis end
        if keys.LeftShift then targetDir = targetDir - Vector3.yAxis end

        currentVelocity = currentVelocity:Lerp(targetDir * flySpeed, math.clamp(dt * 16, 0, 1))
        if linearVelocity then linearVelocity.VectorVelocity = currentVelocity end

        local fwdFactor = currentVelocity.Magnitude > 0.1 and currentVelocity.Unit:Dot(Camera.CFrame.LookVector) or 0
        local tilt = math.clamp(fwdFactor * 0.35, -0.5, 0.5)
        if alignOrientation then alignOrientation.CFrame = alignOrientation.CFrame:Lerp(Camera.CFrame * CFrame.Angles(-tilt, 0, 0), math.clamp(dt * 12, 0, 1)) end
        curHum:Move(Vector3.new(0, 0, -1), true)
    end)
end

stopFly = function()
    if not flying then return end
    flying = false
    FlyButton:SetAttribute("ActiveState", false)
    if flyConnection then flyConnection:Disconnect(); flyConnection = nil end

    FlyButton.Text = "UÇUŞ MODU [ KAPALI ]"
    TweenService:Create(FlyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(15, 35, 50)}):Play()
    TweenService:Create(FlyBtnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(0, 240, 255)}):Play()

    if noclipEnabled then setNoclipState(false) end

    local char, _, hum = getCharacterParts()
    if char and char:FindFirstChild("Animate") then char.Animate.Disabled = false end

    applyGlideSound(false)
    pcall(function() if activeIdleTrack then activeIdleTrack:Stop(0.2) end end)

    if linearVelocity then linearVelocity:Destroy(); linearVelocity = nil end
    if alignOrientation then alignOrientation:Destroy(); alignOrientation = nil end
    if flyAttachment then flyAttachment:Destroy(); flyAttachment = nil end
    if hum then hum.PlatformStand = false end
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    local code = input.KeyCode
    if code == Enum.KeyCode.W then keys.W = true
    elseif code == Enum.KeyCode.S then keys.S = true
    elseif code == Enum.KeyCode.A then keys.A = true
    elseif code == Enum.KeyCode.D then keys.D = true
    elseif code == Enum.KeyCode.Space then keys.Space = true
    elseif code == Enum.KeyCode.LeftShift then keys.LeftShift = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    local code = input.KeyCode
    if code == Enum.KeyCode.W then keys.W = false
    elseif code == Enum.KeyCode.S then keys.S = false
    elseif code == Enum.KeyCode.A then keys.A = false
    elseif code == Enum.KeyCode.D then keys.D = false
    elseif code == Enum.KeyCode.Space then keys.Space = false
    elseif code == Enum.KeyCode.LeftShift then keys.LeftShift = false
    end
end)

FlyButton.MouseButton1Click:Connect(function()
    if flying then stopFly() else startFly() end
end)

PlusBtn.MouseButton1Click:Connect(function()
    flySpeed = math.clamp(flySpeed + 50, 1, 2000)
    SpeedLabel.Text = "VELOCITY: " .. flySpeed
end)

MinusBtn.MouseButton1Click:Connect(function()
    flySpeed = math.clamp(flySpeed - 50, 1, 2000)
    SpeedLabel.Text = "VELOCITY: " .. flySpeed
end)

LocalPlayer.CharacterAdded:Connect(function(_)
    stopFly()
    setNoclipState(false)
end)
