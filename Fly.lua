--// Servisler
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
if not player then return end

local playerGui = player:WaitForChild("PlayerGui")

-- Güvenli ScreenGui Oluşturma
local screenGui = playerGui:FindFirstChild("AstaOS Fly")
if not screenGui then
	screenGui = Instance.new("ScreenGui", playerGui)
	screenGui.Name = "AstraOS Fly"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
end

local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:WaitForChild("Animator")

--// Uçuş & Matematiksel Açı Parametreleri
local flying = false
local flySpeed = 50
local currentVelocity = Vector3.new(0, 0, 0)
local bodyVelocity = nil
local bodyGyro = nil

local ANIM_IDLE_ID = "rbxassetid://130326830016882"
local ANIM_TRANS_ID = "rbxassetid://92064667624841"
local ANIM_RUN_ID = "rbxassetid://130326830016882"

--// Süzülme / Yürüme Sesi ID'si
local FLY_SOUND_ID = "rbxassetid://139095330035399"
local originalRunningId = ""

local idleTrack, transTrack, runTrack = nil, nil, nil
local currentAnimState = "IDLE"

local function loadAnimations()
	if not animator then return end
	pcall(function()
		local function createTrack(id, looped)
			local anim = Instance.new("Animation")
			anim.AnimationId = id
			local track = animator:LoadAnimation(anim)
			track.Looped = looped
			track.Priority = Enum.AnimationPriority.Action
			return track
		end
		idleTrack = createTrack(ANIM_IDLE_ID, true)
		transTrack = createTrack(ANIM_TRANS_ID, false)
		runTrack = createTrack(ANIM_RUN_ID, true)
	end)
end

loadAnimations()
local keys = {W = false, A = false, S = false, D = false, Space = false, LeftShift = false}

--// Ana Kontrol Paneli
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 340, 0, 250)
mainFrame.Position = UDim2.new(0, 130, 0, 25)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Visible = false

local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 20)

-- RGB Olacak Dış Çerçeve
local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = Color3.fromRGB(0, 240, 255)
mainStroke.Thickness = 2.5
mainStroke.Transparency = 0.1

local mainGradient = Instance.new("UIGradient", mainFrame)
mainGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 25, 45)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 12))
})
mainGradient.Rotation = 135

local titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.Size = UDim2.new(1, 0, 0, 55)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.Text = "  ⚡ AstraOS // FLIGHT SYSTEM"
titleLabel.TextColor3 = Color3.fromRGB(0, 240, 255)
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local titleLine = Instance.new("Frame", mainFrame)
titleLine.Size = UDim2.new(0.9, 0, 0, 2)
titleLine.Position = UDim2.new(0.05, 0, 0, 55)
titleLine.BackgroundColor3 = Color3.fromRGB(0, 240, 255)
titleLine.BackgroundTransparency = 0.3
titleLine.BorderSizePixel = 0

local flyButton = Instance.new("TextButton", mainFrame)
flyButton.Size = UDim2.new(0.9, 0, 0, 58)
flyButton.Position = UDim2.new(0.05, 0, 0, 72)
flyButton.BackgroundColor3 = Color3.fromRGB(15, 35, 50)
flyButton.Font = Enum.Font.GothamBold
flyButton.Text = "UÇUŞ MODU [ KAPALI ]"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextSize = 14
flyButton.AutoButtonColor = false

Instance.new("UICorner", flyButton).CornerRadius = UDim.new(0, 14)
local flyBtnStroke = Instance.new("UIStroke", flyButton)
flyBtnStroke.Color = Color3.fromRGB(0, 240, 255)
flyBtnStroke.Thickness = 2

local speedContainer = Instance.new("Frame", mainFrame)
speedContainer.Size = UDim2.new(0.9, 0, 0, 55)
speedContainer.Position = UDim2.new(0.05, 0, 0, 145)
speedContainer.BackgroundTransparency = 1

local speedLabel = Instance.new("TextLabel", speedContainer)
speedLabel.Size = UDim2.new(1, 0, 1, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Font = Enum.Font.GothamBold
speedLabel.Text = "VELOCITY: 50"
speedLabel.TextColor3 = Color3.fromRGB(180, 220, 255)
speedLabel.TextSize = 14

local minusBtn = Instance.new("TextButton", speedContainer)
minusBtn.Size = UDim2.new(0, 48, 0, 48)
minusBtn.Position = UDim2.new(0, 0, 0.5, -24)
minusBtn.BackgroundColor3 = Color3.fromRGB(40, 15, 20)
minusBtn.Font = Enum.Font.GothamBold
minusBtn.Text = "-"
minusBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
minusBtn.TextSize = 20
minusBtn.AutoButtonColor = false
Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 12)

local plusBtn = Instance.new("TextButton", speedContainer)
plusBtn.Size = UDim2.new(0, 48, 0, 48)
plusBtn.Position = UDim2.new(1, -48, 0.5, -24)
plusBtn.BackgroundColor3 = Color3.fromRGB(15, 40, 25)
plusBtn.Font = Enum.Font.GothamBold
plusBtn.Text = "+"
plusBtn.TextColor3 = Color3.fromRGB(90, 255, 150)
plusBtn.TextSize = 20
plusBtn.AutoButtonColor = false
Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 12)

--// Açma/Kapama Butonu
local toggleMenuBtn = Instance.new("TextButton", screenGui)
toggleMenuBtn.Name = "ToggleMenuButton"
toggleMenuBtn.Size = UDim2.new(0, 70, 0, 70)
toggleMenuBtn.Position = UDim2.new(0, 35, 0, 25)
toggleMenuBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
toggleMenuBtn.Font = Enum.Font.GothamBold
toggleMenuBtn.Text = "FLY"
toggleMenuBtn.TextSize = 32
toggleMenuBtn.AutoButtonColor = false

Instance.new("UICorner", toggleMenuBtn).CornerRadius = UDim.new(0, 18)

-- RGB Olacak Buton Çerçevesi
local toggleStroke = Instance.new("UIStroke", toggleMenuBtn)
toggleStroke.Color = Color3.fromRGB(0, 240, 255)
toggleStroke.Thickness = 2.5

-- RGB Olacak Buton Parlaması (Glow)
local btnGlow = Instance.new("UIStroke", toggleMenuBtn)
btnGlow.Color = Color3.fromRGB(0, 240, 255)
btnGlow.Thickness = 5
btnGlow.Transparency = 0.5

--// RGB Renk Döngüsü Motoru (Tüm dış çizgileri ve parlamaları dinamik renklendirir)
RunService.RenderStepped:Connect(function()
	local hue = (tick() % 5) / 5 -- 5 saniyede bir tam renk döngüsü
	local rgbColor = Color3.fromHSV(hue, 1, 1)
	
	mainStroke.Color = rgbColor
	titleLine.BackgroundColor3 = rgbColor
	titleLabel.TextColor3 = rgbColor
	toggleStroke.Color = rgbColor
	btnGlow.Color = rgbColor
end)

-- Sürekli çalışan nefes alma (pulsing) animasyonu
task.spawn(function()
	while true do
		TweenService:Create(btnGlow, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.1}):Play()
		TweenService:Create(toggleMenuBtn, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 74, 0, 74), Position = UDim2.new(0, 33, 0, 23)}):Play()
		task.wait(1.2)
		TweenService:Create(btnGlow, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.7}):Play()
		TweenService:Create(toggleMenuBtn, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 70, 0, 70), Position = UDim2.new(0, 35, 0, 25)}):Play()
		task.wait(1.2)
	end
end)

--// Akıcı Menü Açılış / Kapanış Animasyonları
local menuOpen = false
toggleMenuBtn.MouseButton1Click:Connect(function()
	menuOpen = not menuOpen
	
	-- Tıklama Efekti (Bounce)
	TweenService:Create(toggleMenuBtn, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 60, 0, 60), Rotation = -20}):Play()
	task.wait(0.1)
	TweenService:Create(toggleMenuBtn, TweenInfo.new(0.2, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Size = UDim2.new(0, 70, 0, 70), Rotation = 0}):Play()

	if menuOpen then
		mainFrame.Visible = true
		mainFrame.Size = UDim2.new(0, 10, 0, 250)
		mainFrame.Position = UDim2.new(0, 110, 0, 25)
		
		-- Esnek yaylı açılış animasyonu
		TweenService:Create(mainFrame, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 340, 0, 250),
			Position = UDim2.new(0, 130, 0, 25)
		}):Play()
	else
		-- Kapanış animasyonu
		local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 0, 0, 250),
			Position = UDim2.new(0, 110, 0, 25)
		})
		closeTween:Play()
		closeTween.Completed:Wait()
		mainFrame.Visible = false
	end
end)

--// Butonlar İçin Hover (Üzerine Gelme) Animasyonları
local function setupInteractiveButton(btn, normalColor, hoverColor)
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			BackgroundColor3 = hoverColor,
			Size = btn.Size + UDim2.new(0, 6, 0, 4)
		}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			BackgroundColor3 = normalColor,
			Size = btn.Size - UDim2.new(0, 6, 0, 4)
		}):Play()
	end)
end

setupInteractiveButton(flyButton, Color3.fromRGB(15, 35, 50), Color3.fromRGB(25, 55, 80))
setupInteractiveButton(minusBtn, Color3.fromRGB(40, 15, 20), Color3.fromRGB(65, 25, 35))
setupInteractiveButton(plusBtn, Color3.fromRGB(15, 40, 25), Color3.fromRGB(25, 65, 40))

--// Matematik Tabanlı Animasyon Tetikleyici
local function updateAnimationState(speedMagnitude)
	local isMoving = speedMagnitude > 2.0
	
	if isMoving and currentAnimState == "IDLE" then
		currentAnimState = "TRANS"
		pcall(function()
			if idleTrack then idleTrack:Stop(0.15) end
			if transTrack then transTrack:Play(0.1) end
		end)
		
		task.delay(0.15, function()
			if currentAnimState == "TRANS" then
				currentAnimState = "RUN"
				pcall(function()
					if runTrack and not runTrack.IsPlaying then runTrack:Play(0.15) end
				end)
			end
		end)
		
	elseif not isMoving and (currentAnimState == "RUN" or currentAnimState == "TRANS") then
		currentAnimState = "IDLE"
		pcall(function()
			if runTrack then runTrack:Stop(0.2) end
			if transTrack then transTrack:Stop(0.1) end
			if idleTrack and not idleTrack.IsPlaying then idleTrack:Play(0.2) end
		end)
	end
end

--// Ses Efektini Ayarlama Fonksiyonu
local function applyGlideSound(state)
	local soundP = character:FindFirstChild("HumanoidRootPart")
	if not soundP then return end
	
	local runningSound = soundP:FindFirstChild("Running")
	if state then
		if runningSound then
			originalRunningId = runningSound.SoundId
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
		if runningSound and originalRunningId ~= "" then
			runningSound.SoundId = originalRunningId
			local pitchEffect = runningSound:FindFirstChild("GlidePitch")
			if pitchEffect then pitchEffect:Destroy() end
		end
	end
end

--// Uçuş ve Matematiksel Eğilme Motoru
local function startFly()
	if flying then return end
	flying = true
	
	flyButton.Text = "UÇUŞ MODU [ AKTİF ]"
	TweenService:Create(flyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 150, 180)}):Play()
	TweenService:Create(flyBtnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 255, 255)}):Play()

	local animateScript = character:FindFirstChild("Animate")
	if animateScript then animateScript.Disabled = true end

	local camera = workspace.CurrentCamera
	
	bodyVelocity = Instance.new("BodyVelocity", humanoidRootPart)
	bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	bodyVelocity.Velocity = Vector3.new(0, 0, 0)

	bodyGyro = Instance.new("BodyGyro", humanoidRootPart)
	bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	bodyGyro.CFrame = camera.CFrame

	humanoid.PlatformStand = true
	currentVelocity = Vector3.new(0, 0, 0)

	currentAnimState = "IDLE"
	if idleTrack then pcall(function() idleTrack:Play(0.2) end) end

	applyGlideSound(true)

	RunService.RenderStepped:Connect(function(dt)
		if not flying then return end
		
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
		bodyVelocity.Velocity = currentVelocity

		local speedMagnitude = currentVelocity.Magnitude
		
		if speedMagnitude > 2.0 then
			local forwardFactor = currentVelocity.Unit:Dot(camera.CFrame.LookVector)
			local tiltAngle = math.clamp(forwardFactor * 0.35, -0.5, 0.5)
			local adjustedCFrame = camera.CFrame * CFrame.Angles(-tiltAngle, 0, 0)
			bodyGyro.CFrame = bodyGyro.CFrame:Lerp(adjustedCFrame, math.clamp(dt * 12, 0, 1))
			
			humanoid:Move(Vector3.new(0, 0, -1), true)
		else
			bodyGyro.CFrame = bodyGyro.CFrame:Lerp(camera.CFrame, math.clamp(dt * 12, 0, 1))
			humanoid:Move(Vector3.new(0, 0, 0), false)
		end

		updateAnimationState(speedMagnitude)
	end)
end

local function stopFly()
	if not flying then return end
	flying = false

	flyButton.Text = "UÇUŞ MODU [ KAPALI ]"
	TweenService:Create(flyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(15, 35, 50)}):Play()
	TweenService:Create(flyBtnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(0, 240, 255)}):Play()

	local animateScript = character:FindFirstChild("Animate")
	if animateScript then animateScript.Disabled = false end

	applyGlideSound(false)

	pcall(function()
		if idleTrack then idleTrack:Stop(0.2) end
		if transTrack then transTrack:Stop(0.2) end
		if runTrack then runTrack:Stop(0.2) end
	end)
	currentAnimState = "IDLE"

	if bodyVelocity then bodyVelocity:Destroy() end
	if bodyGyro then bodyGyro:Destroy() end
	
	humanoid.PlatformStand = false
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

flyButton.MouseButton1Click:Connect(function()
	if flying then stopFly() else startFly() end
end)

plusBtn.MouseButton1Click:Connect(function()
	flySpeed = math.clamp(flySpeed + 10, 10, 400)
	speedLabel.Text = "VELOCITY: " .. flySpeed
end)

minusBtn.MouseButton1Click:Connect(function()
	flySpeed = math.clamp(flySpeed - 10, 10, 400)
	speedLabel.Text = "VELOCITY: " .. flySpeed
end)

player.CharacterAdded:Connect(function(newChar)
	character = newChar
	humanoidRootPart = character:WaitForChild("HumanoidRootPart")
	humanoid = character:WaitForChild("Humanoid")
	animator = humanoid:WaitForChild("Animator")
	loadAnimations()
	stopFly()
end)
