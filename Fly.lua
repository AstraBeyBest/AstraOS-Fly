-- AstraOS Ultimate Client - Gelişmiş Kesintisiz Spinbot ve Sürüklenebilir Arayüz Sürümü
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local playerName = game.Players.LocalPlayer.Name
local LocalPlayer = Players.LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera
local Workspace = game:GetService("Workspace")

-- Önceki GUI varsa temizle
if CoreGui:FindFirstChild("AstraOS_GUI") then
    CoreGui.AstraOS_GUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AstraOS_GUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ================= AÇMA / KAPAMA (TOGGLE) BUTONU (Sürüklenebilir) =================
local ToggleMenuButton = Instance.new("TextButton", ScreenGui)
ToggleMenuButton.Name = "ToggleMenuButton"
ToggleMenuButton.Size = UDim2.new(0, 0, 0, 0)
ToggleMenuButton.Position = UDim2.new(0, 18, 0, 125)
ToggleMenuButton.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
ToggleMenuButton.Font = Enum.Font.GothamBold
ToggleMenuButton.Text = "ASTRA"
ToggleMenuButton.TextSize = 20
ToggleMenuButton.AutoButtonColor = false
ToggleMenuButton.Visible = false

Instance.new("UICorner", ToggleMenuButton).CornerRadius = UDim.new(0, 16)

local ToggleStroke = Instance.new("UIStroke", ToggleMenuButton)
ToggleStroke.Color = Color3.fromRGB(0, 240, 255)
ToggleStroke.Thickness = 2.5

local BtnGlow = Instance.new("UIStroke", ToggleMenuButton)
BtnGlow.Color = Color3.fromRGB(0, 240, 255)
BtnGlow.Thickness = 5
BtnGlow.Transparency = 0.5

-- Sürükleme Mantığı (Toggle Buton)
local draggingToggle, dragInputToggle, toggleStartPos, startPosToggle
ToggleMenuButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingToggle = true
        toggleStartPos = input.Position
        startPosToggle = ToggleMenuButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingToggle = false
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

-- ================= RP NAME CHANGER ===================
local args = {
    [1] = "RolePlayName",
    [2] = "💠 AstraOS User 💠"
}

-- ================= ANA KONTROL PANELİ =================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 340, 0, 335)
MainFrame.Position = UDim2.new(0, 110, 0, 125)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 20)

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

local TitleLabel = Instance.new("TextLabel", MainFrame)
TitleLabel.Size = UDim2.new(1, 0, 0, 45)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.Text = "  ⚡ AstraOS // ULTIMATE PANEL"
TitleLabel.TextColor3 = Color3.fromRGB(0, 240, 255)
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local TitleLine = Instance.new("Frame", MainFrame)
TitleLine.Size = UDim2.new(0.9, 0, 0, 2)
TitleLine.Position = UDim2.new(0.05, 0, 0, 45)
TitleLine.BackgroundColor3 = Color3.fromRGB(0, 240, 255)
TitleLine.BackgroundTransparency = 0.3
TitleLine.BorderSizePixel = 0

-- Fly Butonu
local FlyButton = Instance.new("TextButton", MainFrame)
FlyButton.Size = UDim2.new(0.9, 0, 0, 42)
FlyButton.Position = UDim2.new(0.05, 0, 0, 55)
FlyButton.BackgroundColor3 = Color3.fromRGB(15, 35, 50)
FlyButton.Font = Enum.Font.GothamBold
FlyButton.Text = "UÇUŞ MODU [ KAPALI ]"
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.TextSize = 14
FlyButton.AutoButtonColor = false
Instance.new("UICorner", FlyButton).CornerRadius = UDim.new(0, 12)
local FlyBtnStroke = Instance.new("UIStroke", FlyButton)
FlyBtnStroke.Color = Color3.fromRGB(0, 240, 255)
FlyBtnStroke.Thickness = 2

-- Spinbot Butonu
local SpinButton = Instance.new("TextButton", MainFrame)
SpinButton.Size = UDim2.new(0.9, 0, 0, 42)
SpinButton.Position = UDim2.new(0.05, 0, 0, 103)
SpinButton.BackgroundColor3 = Color3.fromRGB(15, 35, 50)
SpinButton.Font = Enum.Font.GothamBold
SpinButton.Text = "SPINBOT [ KAPALI ]"
SpinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpinButton.TextSize = 14
SpinButton.AutoButtonColor = false
Instance.new("UICorner", SpinButton).CornerRadius = UDim.new(0, 12)
local SpinBtnStroke = Instance.new("UIStroke", SpinButton)
SpinBtnStroke.Color = Color3.fromRGB(0, 240, 255)
SpinBtnStroke.Thickness = 2

-- Spin Hızı Kontrolü
local SpinSpeedContainer = Instance.new("Frame", MainFrame)
SpinSpeedContainer.Size = UDim2.new(0.9, 0, 0, 38)
SpinSpeedContainer.Position = UDim2.new(0.05, 0, 0, 151)
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

-- Velocity Kontrolü (1 - 2000 aralığı)
local SpeedContainer = Instance.new("Frame", MainFrame)
SpeedContainer.Size = UDim2.new(0.9, 0, 0, 38)
SpeedContainer.Position = UDim2.new(0.05, 0, 0, 195)
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
RGBToggleBtn.Position = UDim2.new(0.05, 0, 0, 240)
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
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Name = "LoadingFrame"
LoadingFrame.Parent = ScreenGui
LoadingFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
LoadingFrame.BorderSizePixel = 0
LoadingFrame.Position = UDim2.new(0.5, -160, 0.5, -80)
LoadingFrame.Size = UDim2.new(0, 320, 0, 160)
LoadingFrame.BackgroundTransparency = 1
LoadingFrame.Visible = true

local LoadingCorner = Instance.new("UICorner")
LoadingCorner.CornerRadius = UDim.new(0, 16)
LoadingCorner.Parent = LoadingFrame

local LoadingStroke = Instance.new("UIStroke")
LoadingStroke.Parent = LoadingFrame
LoadingStroke.Thickness = 2
LoadingStroke.Transparency = 1

local LoadingText = Instance.new("TextLabel")
LoadingText.Parent = LoadingFrame
LoadingText.BackgroundTransparency = 1
LoadingText.Position = UDim2.new(0, 0, 0.25, 0)
LoadingText.Size = UDim2.new(1, 0, 0, 40)
LoadingText.Font = Enum.Font.GothamBlack
LoadingText.Text = "⚡ AstraOS Başlatılıyor..."
LoadingText.TextColor3 = Color3.fromRGB(0, 240, 255)
LoadingText.TextSize = 18
LoadingText.TextTransparency = 1

local BarBackground = Instance.new("Frame")
BarBackground.Parent = LoadingFrame
BarBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
BarBackground.BorderSizePixel = 0
BarBackground.Position = UDim2.new(0.1, 0, 0.65, 0)
BarBackground.Size = UDim2.new(0.8, 0, 0, 10)
BarBackground.BackgroundTransparency = 1

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(1, 0)
BarCorner.Parent = BarBackground

local BarFill = Instance.new("Frame")
BarFill.Parent = BarBackground
BarFill.BackgroundColor3 = Color3.fromRGB(0, 240, 255)
BarFill.BorderSizePixel = 0
BarFill.Size = UDim2.new(0, 0, 1, 0)

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(1, 0)
FillCorner.Parent = BarFill

TweenService:Create(LoadingFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.15}):Play()
TweenService:Create(LoadingStroke, TweenInfo.new(0.5), {Transparency = 0.2}):Play()
TweenService:Create(LoadingText, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
TweenService:Create(BarBackground, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()

task.spawn(function()
    local tween = TweenService:Create(BarFill, TweenInfo.new(1.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)})
    tween:Play()
    tween.Completed:Wait()
    
    TweenService:Create(LoadingFrame, TweenInfo.new(0.4), {BackgroundTransparency = 1, Position = UDim2.new(0.5, -160, 0.5, -110)}):Play()
    TweenService:Create(LoadingStroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
    TweenService:Create(LoadingText, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(BarBackground, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    TweenService:Create(BarFill, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    task.wait(0.4)
    LoadingFrame:Destroy()
    
    ToggleMenuButton.Visible = true
    TweenService:Create(ToggleMenuButton, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 85, 0, 85)}):Play()
end)

-- ================= RGB & NEFES ALMA =================
local rgbEnabled = true

RunService.RenderStepped:Connect(function()
    if rgbEnabled then
        local hue = (tick() % 5) / 5
        local rgbColor = Color3.fromHSV(hue, 1, 1)
        
        MainStroke.Color = rgbColor
        TitleLine.BackgroundColor3 = rgbColor
        TitleLabel.TextColor3 = rgbColor
        ToggleStroke.Color = rgbColor
        BtnGlow.Color = rgbColor
        RGBToggleBtn.TextColor3 = rgbColor
        RGBToggleStroke.Color = rgbColor
    end
end)

task.spawn(function()
    while true do
        TweenService:Create(BtnGlow, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.1}):Play()
        TweenService:Create(ToggleMenuButton, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 90, 0, 90)}):Play()
        task.wait(1.2)
        TweenService:Create(BtnGlow, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.7}):Play()
        TweenService:Create(ToggleMenuButton, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 85, 0, 85)}):Play()
        task.wait(1.2)
    end
end)

local menuOpen = false
ToggleMenuButton.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    TweenService:Create(ToggleMenuButton, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 75, 0, 75), Rotation = -20}):Play()
    task.wait(0.1)
    TweenService:Create(ToggleMenuButton, TweenInfo.new(0.2, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Size = UDim2.new(0, 85, 0, 85), Rotation = 0}):Play()

    if menuOpen then
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 10, 0, 335)
        TweenService:Create(MainFrame, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 340, 0, 335)
        }):Play()
    else
        local closeTween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 335)
        })
        closeTween:Play()
        closeTween.Completed:Wait()
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
        RGBToggleBtn.TextColor3 = staticColor
        RGBToggleStroke.Color = staticColor
    end
end)

-- ================= GELİŞTİRİLMİŞ KESİNTİSİZ SPINBOT MANTIĞI =================
local spinEnabled = false
local spinSpeed = 35
local currentSpinAngle = 0

-- RenderStepped yerine deltaTime (dt) bazlı açı biriktirme sistemi kullanılarak kare hızından (FPS) etkilenmeme sorunu giderildi
RunService.RenderStepped:Connect(function(dt)
    if spinEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = LocalPlayer.Character.HumanoidRootPart
        currentSpinAngle = (currentSpinAngle + (spinSpeed * dt * 60)) % 360
        rootPart.CFrame = CFrame.new(rootPart.Position) * CFrame.Angles(0, math.rad(currentSpinAngle), 0)
    end
end)

SpinButton.MouseButton1Click:Connect(function()
    spinEnabled = not spinEnabled
    if spinEnabled then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            currentSpinAngle = math.deg(math.atan2(-LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector.Z, LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector.X))
        end
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

-- ================= FLY MANTIĞI & AKILLI ANİMASYON YAKALAYICI =================
local flying = false
local flySpeed = 50
local currentVelocity = Vector3.new(0, 0, 0)
local bodyVelocity = nil
local bodyGyro = nil
local activeAnimTrack = nil

local FLY_SOUND_ID = "rbxassetid://139095330035399"

local function getCharacterParts()
    local char = LocalPlayer.Character
    if not char then return nil, nil, nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    return char, hrp, hum
end

local function playCurrentCharacterAnimation()
    local _, _, hum = getCharacterParts()
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end
    
    pcall(function()
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            track:Stop(0.2)
        end
        
        local candidateTracks = animator:GetPlayingAnimationTracks()
        if #candidateTracks > 0 then
            activeAnimTrack = candidateTracks[1]
            activeAnimTrack:Play(0.2)
        else
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://507765000"
            activeAnimTrack = animator:LoadAnimation(anim)
            activeAnimTrack.Looped = true
            activeAnimTrack:Play(0.2)
        end
    end)
end

local keys = {W = false, A = false, S = false, D = false, Space = false, LeftShift = false}

local function applyGlideSound(state)
    local _, hrp, _ = getCharacterParts()
    if not hrp then return end
    
    local runningSound = hrp:FindFirstChild("Running")
    if state then
        if runningSound then
            runningSound.SoundId = FLY_SOUND_ID
            runningSound.Looped = true
            local pitchEffect = runningSound:FindFirstChild("GlidePitch")
            if not pitchEffect then
                pitchEffect = Instance.new("PitchShiftSoundEffect", runningSound)
                pitchEffect.Name = "GlidePitch"
                pitchEffect.Octave = 0.85
            end
            if not runningSound.IsPlaying then
                runningSound:Play()
            end
        end
    else
        if runningSound then
            runningSound.SoundId = "rbxassetid://911447043"
            local pitchEffect = runningSound:FindFirstChild("GlidePitch")
            if pitchEffect then pitchEffect:Destroy() end
        end
    end
end

local function startFly()
    if flying then return end
    local char, hrp, hum = getCharacterParts()
    if not char or not hrp or not hum then return end
    
    flying = true
    
    FlyButton.Text = "UÇUŞ MODU [ AKTİF ]"
    TweenService:Create(FlyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 150, 180)}):Play()
    TweenService:Create(FlyBtnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 255, 255)}):Play()

    local animateScript = char:FindFirstChild("Animate")
    if animateScript then animateScript.Disabled = true end

    local camera = workspace.CurrentCamera
    
    bodyVelocity = Instance.new("BodyVelocity", hrp)
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)

    bodyGyro = Instance.new("BodyGyro", hrp)
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.CFrame = camera.CFrame

    hum.PlatformStand = true
    currentVelocity = Vector3.new(0, 0, 0)

    playCurrentCharacterAnimation()
    applyGlideSound(true)

    RunService.RenderStepped:Connect(function(dt)
        if not flying then return end
        local _, currentHrp, currentHum = getCharacterParts()
        if not currentHrp or not currentHum then return end
        
        camera = workspace.CurrentCamera

        local targetDirection = Vector3.new(0, 0, 0)
        if keys.W then targetDirection = targetDirection + camera.CFrame.LookVector end
        if keys.S then targetDirection = targetDirection - camera.CFrame.LookVector end
        if keys.D then targetDirection = targetDirection + camera.CFrame.RightVector end
        if keys.A then targetDirection = targetDirection - camera.CFrame.RightVector end
        if keys.Space then targetDirection = targetDirection + Vector3.new(0, 1, 0) end
        if keys.LeftShift then targetDirection = targetDirection - Vector3.new(0, 1, 0) end

        local targetVelocity = targetDirection * flySpeed
        currentVelocity = currentVelocity:Lerp(targetVelocity, math.clamp(dt * 16, 0, 1))
        if bodyVelocity and bodyVelocity.Parent then
            bodyVelocity.Velocity = currentVelocity
        end

        local speedMagnitude = currentVelocity.Magnitude
        if speedMagnitude > 2.0 then
            local forwardFactor = currentVelocity.Unit:Dot(camera.CFrame.LookVector)
            local tiltAngle = math.clamp(forwardFactor * 0.35, -0.5, 0.5)
            local adjustedCFrame = camera.CFrame * CFrame.Angles(-tiltAngle, 0, 0)
            if bodyGyro and bodyGyro.Parent then
                bodyGyro.CFrame = bodyGyro.CFrame:Lerp(adjustedCFrame, math.clamp(dt * 12, 0, 1))
            end
            currentHum:Move(Vector3.new(0, 0, -1), true)
        else
            if bodyGyro and bodyGyro.Parent then
                bodyGyro.CFrame = bodyGyro.CFrame:Lerp(camera.CFrame, math.clamp(dt * 12, 0, 1))
            end
            currentHum:Move(Vector3.new(0, 0, 0), false)
        end
    end)
end

local function stopFly()
    if not flying then return end
    flying = false

    FlyButton.Text = "UÇUŞ MODU [ KAPALI ]"
    TweenService:Create(FlyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(15, 35, 50)}):Play()
    TweenService:Create(FlyBtnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(0, 240, 255)}):Play()

    local char, _, hum = getCharacterParts()
    if char then
        local animateScript = char:FindFirstChild("Animate")
        if animateScript then animateScript.Disabled = false end
    end

    applyGlideSound(false)

    pcall(function()
        if activeAnimTrack then activeAnimTrack:Stop(0.2) end
    end)

    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    
    if hum then
        hum.PlatformStand = false
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.W then keys.W = true
    elseif input.KeyCode == Enum.KeyCode.S then keys.S = true
    elseif input.KeyCode == Enum.KeyCode.A then keys.A = true
    elseif input.KeyCode == Enum.KeyCode.D then keys.D = true
    elseif input.KeyCode == Enum.KeyCode.Space then keys.Space = true
    elseif input.KeyCode == Enum.KeyCode.LeftShift then keys.LeftShift = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then keys.W = false
    elseif input.KeyCode == Enum.KeyCode.S then keys.S = false
    elseif input.KeyCode == Enum.KeyCode.A then keys.A = false
    elseif input.KeyCode == Enum.KeyCode.D then keys.D = false
    elseif input.KeyCode == Enum.KeyCode.Space then keys.Space = false
    elseif input.KeyCode == Enum.KeyCode.LeftShift then keys.LeftShift = false
    end
end)

FlyButton.MouseButton1Click:Connect(function()
    if flying then stopFly() else startFly() end
end)

PlusBtn.MouseButton1ListClick = nil
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
end)
