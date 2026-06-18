local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BotPetGifter"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local ok = pcall(function() screenGui.Parent = PlayerGui end)
if not ok then screenGui.Parent = game:GetService("CoreGui") end

local C_BG      = Color3.fromRGB(18,  18,  26)
local C_HEADER  = Color3.fromRGB(22,  22,  32)
local C_BLUE    = Color3.fromRGB(55,  125, 240)
local C_BLUE_H  = Color3.fromRGB(75,  145, 255)
local C_BLUE_P  = Color3.fromRGB(35,  95,  200)
local C_DIVIDER = Color3.fromRGB(40,  40,  60)
local C_TEXT    = Color3.fromRGB(220, 225, 245)
local C_MUTED   = Color3.fromRGB(80,  80,  110)

local W        = isMobile and 340 or 360
local H        = isMobile and 290 or 310
local HEADER_H = isMobile and 52  or 54

-- Horizontal loading panel dimensions
local LP_W = isMobile and 400 or 440
local LP_H = isMobile and 160 or 175

-- ── STEP PRESETS ─────────────────────────────────────────
local STARTUP_STEPS = {
	{pct=15,  msg="Initializing...",        wait=0.26},
	{pct=38,  msg="Loading assets...",      wait=0.28},
	{pct=60,  msg="Building interface...",  wait=0.25},
	{pct=82,  msg="Connecting...",          wait=0.24},
	{pct=100, msg="Ready!",                 wait=0.22},
}
local EXECUTE_STEPS = {
	{pct=40,  msg="Preparing script...",    wait=0.14},
	{pct=75,  msg="Executing...",           wait=0.13},
	{pct=100, msg="Done!",                  wait=0.11},
}

-- ════════════════════════════════════════════════════════
--  LOADING SCREEN (reusable — horizontal layout)
-- ════════════════════════════════════════════════════════
local function showLoading(steps, onDone)
	-- dim overlay
	local overlay = Instance.new("Frame", screenGui)
	overlay.Size = UDim2.new(1,0,1,0)
	overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
	overlay.BackgroundTransparency = 0.38
	overlay.BorderSizePixel = 0
	overlay.ZIndex = 20

	-- panel
	local panel = Instance.new("Frame", screenGui)
	panel.Size = UDim2.new(0,0,0,0)
	panel.Position = UDim2.new(0.5,0,0.5,0)
	panel.BackgroundColor3 = C_BG
	panel.BackgroundTransparency = 0.05
	panel.BorderSizePixel = 0
	panel.ZIndex = 21
	Instance.new("UICorner", panel).CornerRadius = UDim.new(0,16)

	local pSt = Instance.new("UIStroke", panel)
	pSt.Color = C_BLUE; pSt.Thickness = 1.8; pSt.Transparency = 0.15

	-- subtle inner glow gradient
	local panelGlow = Instance.new("Frame", panel)
	panelGlow.Size = UDim2.new(1,0,1,0)
	panelGlow.BackgroundColor3 = Color3.fromRGB(40,55,120)
	panelGlow.BackgroundTransparency = 0.88
	panelGlow.BorderSizePixel = 0; panelGlow.ZIndex = 21
	Instance.new("UICorner",panelGlow).CornerRadius = UDim.new(0,16)
	local pgGrad = Instance.new("UIGradient",panelGlow)
	pgGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(80,110,255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(10,10,30))
	})
	pgGrad.Rotation = 135

	-- pop in
	TweenService:Create(panel,
		TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{Size=UDim2.new(0,LP_W,0,LP_H),
		 Position=UDim2.new(0.5,-LP_W/2,0.5,-LP_H/2)}):Play()

	-- star dots
	for i = 1, 22 do
		local d = Instance.new("Frame", panel)
		d.Size = UDim2.new(0,math.random(2,3),0,math.random(2,3))
		d.Position = UDim2.new(math.random(),0,math.random(),0)
		d.BackgroundColor3 = Color3.fromRGB(255,255,255)
		d.BackgroundTransparency = math.random(65,85)/100
		d.BorderSizePixel = 0; d.ZIndex = 22
		Instance.new("UICorner",d).CornerRadius = UDim.new(1,0)
		task.delay(math.random()*1.5, function()
			if d.Parent then
				TweenService:Create(d,
					TweenInfo.new(math.random(12,28)/10,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),
					{BackgroundTransparency=math.random(8,35)/100}):Play()
			end
		end)
	end

	-- LEFT section width (square-ish to fit ring)
	local leftW = LP_H

	-- vertical separator between left & right
	local sep = Instance.new("Frame", panel)
	sep.Size = UDim2.new(0,1,0,LP_H-30)
	sep.Position = UDim2.new(0,leftW,0,15)
	sep.BackgroundColor3 = Color3.fromRGB(48,48,72)
	sep.BackgroundTransparency = 0.2
	sep.BorderSizePixel = 0; sep.ZIndex = 22

	-- ── LEFT: spinning ring ──────────────────────────────
	local ringSize = isMobile and 72 or 78
	local ring = Instance.new("Frame", panel)
	ring.Size = UDim2.new(0,ringSize,0,ringSize)
	ring.Position = UDim2.new(0, leftW/2-ringSize/2, 0.5, -ringSize/2)
	ring.BackgroundTransparency = 1; ring.ZIndex = 23
	Instance.new("UICorner",ring).CornerRadius = UDim.new(1,0)

	local rSt = Instance.new("UIStroke",ring)
	rSt.Color = Color3.fromRGB(42,42,65); rSt.Thickness = 2.5; rSt.Transparency = 0.05

	-- outer faint ring
	local ringOuter = Instance.new("Frame", panel)
	ringOuter.Size = UDim2.new(0,ringSize+14,0,ringSize+14)
	ringOuter.Position = UDim2.new(0, leftW/2-(ringSize+14)/2, 0.5, -(ringSize+14)/2)
	ringOuter.BackgroundTransparency = 1; ringOuter.ZIndex = 22
	Instance.new("UICorner",ringOuter).CornerRadius = UDim.new(1,0)
	local rOSt = Instance.new("UIStroke",ringOuter)
	rOSt.Color = Color3.fromRGB(35,35,55); rOSt.Thickness = 1; rOSt.Transparency = 0.3

	-- bright leading dot
	local sD1 = Instance.new("Frame", ring)
	sD1.Size = UDim2.new(0,11,0,11)
	sD1.AnchorPoint = Vector2.new(0.5,0.5)
	sD1.Position = UDim2.new(0.5,0,0,-4)
	sD1.BackgroundColor3 = Color3.fromRGB(110,170,255)
	sD1.BorderSizePixel = 0; sD1.ZIndex = 25
	Instance.new("UICorner",sD1).CornerRadius = UDim.new(1,0)

	-- trail dot
	local sD2 = Instance.new("Frame", ring)
	sD2.Size = UDim2.new(0,6,0,6)
	sD2.AnchorPoint = Vector2.new(0.5,0.5)
	sD2.Position = UDim2.new(0.5,0,0,-4)
	sD2.BackgroundColor3 = C_BLUE
	sD2.BackgroundTransparency = 0.28
	sD2.BorderSizePixel = 0; sD2.ZIndex = 24
	Instance.new("UICorner",sD2).CornerRadius = UDim.new(1,0)

	-- inner letter
	local innerLbl = Instance.new("TextLabel", ring)
	innerLbl.Size = UDim2.new(1,0,1,0)
	innerLbl.BackgroundTransparency = 1
	innerLbl.Text = "B"
	innerLbl.TextColor3 = Color3.fromRGB(170,198,242)
	innerLbl.TextSize = isMobile and 26 or 30
	innerLbl.Font = Enum.Font.GothamBold
	innerLbl.TextXAlignment = Enum.TextXAlignment.Center
	innerLbl.TextYAlignment = Enum.TextYAlignment.Center
	innerLbl.ZIndex = 24

	-- ── RIGHT: info section ──────────────────────────────
	local rX = leftW + 16
	local rW = LP_W - rX - 16

	-- title
	local titLbl = Instance.new("TextLabel", panel)
	titLbl.Size = UDim2.new(0,rW,0,28)
	titLbl.Position = UDim2.new(0,rX,0,14)
	titLbl.BackgroundTransparency = 1
	titLbl.Text = "BOT PET GIFTER"
	titLbl.TextColor3 = C_TEXT
	titLbl.TextSize = isMobile and 16 or 18
	titLbl.Font = Enum.Font.GothamBold
	titLbl.TextXAlignment = Enum.TextXAlignment.Left
	titLbl.ZIndex = 22

	-- accent underline (animates in)
	local acLine = Instance.new("Frame", panel)
	acLine.Size = UDim2.new(0,0,0,2)
	acLine.Position = UDim2.new(0,rX,0,46)
	acLine.BackgroundColor3 = C_BLUE
	acLine.BackgroundTransparency = 0.22
	acLine.BorderSizePixel = 0; acLine.ZIndex = 22
	Instance.new("UICorner",acLine).CornerRadius = UDim.new(1,0)
	local acGrad = Instance.new("UIGradient",acLine)
	acGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(80,80,255))
	})
	task.delay(0.22, function()
		if acLine.Parent then
			TweenService:Create(acLine,
				TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{Size=UDim2.new(0,rW*0.62,0,2)}):Play()
		end
	end)

	-- status
	local statusLbl = Instance.new("TextLabel", panel)
	statusLbl.Size = UDim2.new(0,rW,0,18)
	statusLbl.Position = UDim2.new(0,rX,0,58)
	statusLbl.BackgroundTransparency = 1
	statusLbl.Text = "Starting..."
	statusLbl.TextColor3 = C_MUTED
	statusLbl.TextSize = isMobile and 12 or 13
	statusLbl.Font = Enum.Font.Gotham
	statusLbl.TextXAlignment = Enum.TextXAlignment.Left
	statusLbl.ZIndex = 22

	-- percent
	local pctLbl = Instance.new("TextLabel", panel)
	pctLbl.Size = UDim2.new(0,rW,0,15)
	pctLbl.Position = UDim2.new(0,rX,0,80)
	pctLbl.BackgroundTransparency = 1
	pctLbl.Text = "0%"
	pctLbl.TextColor3 = Color3.fromRGB(130,165,225)
	pctLbl.TextSize = isMobile and 11 or 12
	pctLbl.Font = Enum.Font.GothamBold
	pctLbl.TextXAlignment = Enum.TextXAlignment.Left
	pctLbl.ZIndex = 22

	-- bar bg
	local barBg = Instance.new("Frame", panel)
	barBg.Size = UDim2.new(0,rW,0,6)
	barBg.Position = UDim2.new(0,rX,0,99)
	barBg.BackgroundColor3 = Color3.fromRGB(26,26,44)
	barBg.BorderSizePixel = 0; barBg.ZIndex = 22
	Instance.new("UICorner",barBg).CornerRadius = UDim.new(1,0)

	local barFill = Instance.new("Frame", barBg)
	barFill.Size = UDim2.new(0,0,1,0)
	barFill.BackgroundColor3 = C_BLUE
	barFill.BorderSizePixel = 0; barFill.ZIndex = 23
	Instance.new("UICorner",barFill).CornerRadius = UDim.new(1,0)

	-- bar glow
	local barGlow = Instance.new("Frame", barBg)
	barGlow.Size = UDim2.new(0,0,1,4)
	barGlow.Position = UDim2.new(0,0,0,-2)
	barGlow.BackgroundColor3 = C_BLUE
	barGlow.BackgroundTransparency = 0.7
	barGlow.BorderSizePixel = 0; barGlow.ZIndex = 21
	Instance.new("UICorner",barGlow).CornerRadius = UDim.new(1,0)

	-- shimmer
	local shimmer = Instance.new("Frame", barFill)
	shimmer.Size = UDim2.new(0,26,1,0)
	shimmer.Position = UDim2.new(-0.4,0,0,0)
	shimmer.BackgroundColor3 = Color3.fromRGB(255,255,255)
	shimmer.BackgroundTransparency = 0.66
	shimmer.BorderSizePixel = 0; shimmer.ZIndex = 24
	Instance.new("UICorner",shimmer).CornerRadius = UDim.new(1,0)

	local function loopShimmer()
		if not shimmer.Parent then return end
		shimmer.Position = UDim2.new(-0.4,0,0,0)
		local t = TweenService:Create(shimmer,
			TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
			{Position=UDim2.new(1.2,0,0,0)})
		t:Play()
		t.Completed:Connect(function() task.delay(0.22, loopShimmer) end)
	end
	task.delay(0.14, loopShimmer)

	-- spin + stroke pulse connections
	local angle = 0
	local spinConn = RunService.Heartbeat:Connect(function(dt)
		angle = angle + dt*230
		ring.Rotation = angle
		ringOuter.Rotation = -angle * 0.4
	end)
	local strokeConn = RunService.Heartbeat:Connect(function()
		local a = (math.sin(tick()*2.4)+1)/2
		pSt.Transparency = 0.04 + a*0.36
	end)

	-- run loading steps
	task.spawn(function()
		for _, step in ipairs(steps) do
			task.wait(step.wait)
			TweenService:Create(statusLbl,TweenInfo.new(0.1),{TextTransparency=1}):Play()
			task.wait(0.1)
			statusLbl.Text = step.msg
			TweenService:Create(statusLbl,TweenInfo.new(0.1),{TextTransparency=0}):Play()
			pctLbl.Text = step.pct.."%"
			TweenService:Create(barFill,
				TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{Size=UDim2.new(step.pct/100,0,1,0)}):Play()
			TweenService:Create(barGlow,
				TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{Size=UDim2.new(step.pct/100,0,1,4)}):Play()
		end

		task.wait(0.22)
		spinConn:Disconnect(); strokeConn:Disconnect()
		-- flash white on complete
		TweenService:Create(barFill,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(255,255,255)}):Play()
		TweenService:Create(pSt,TweenInfo.new(0.12),{Color=Color3.fromRGB(255,255,255)}):Play()
		task.wait(0.16)

		-- collapse
		TweenService:Create(panel,
			TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.In),
			{Size=UDim2.new(0,0,0,0), Position=UDim2.new(0.5,0,0.5,0)}):Play()
		TweenService:Create(overlay,TweenInfo.new(0.22),{BackgroundTransparency=1}):Play()
		task.wait(0.3)
		panel:Destroy(); overlay:Destroy()
		if onDone then onDone() end
	end)
end

-- ════════════════════════════════════════════════════════
--  MAIN GUI
-- ════════════════════════════════════════════════════════
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0,W,0,H)
mainFrame.Position = UDim2.new(0.5,-W/2,0.5,-H/2)
mainFrame.BackgroundColor3 = C_BG
mainFrame.BackgroundTransparency = 0.08
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Visible = false
Instance.new("UICorner",mainFrame).CornerRadius = UDim.new(0,18)

local mfSt = Instance.new("UIStroke",mainFrame)
mfSt.Color = C_BLUE; mfSt.Thickness = 1.8; mfSt.Transparency = 0.2

local bgG = Instance.new("Frame",mainFrame)
bgG.Size = UDim2.new(1,0,1,0)
bgG.BackgroundColor3 = Color3.fromRGB(30,30,50)
bgG.BackgroundTransparency = 0.85
bgG.BorderSizePixel = 0; bgG.ZIndex = 1
Instance.new("UICorner",bgG).CornerRadius = UDim.new(0,18)
local bgGG = Instance.new("UIGradient",bgG)
bgGG.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(60,80,180)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(10,10,20))
})
bgGG.Rotation = 135

-- header
local header = Instance.new("Frame",mainFrame)
header.Size = UDim2.new(1,0,0,HEADER_H)
header.BackgroundColor3 = C_HEADER
header.BackgroundTransparency = 0.1
header.BorderSizePixel = 0; header.ZIndex = 5
Instance.new("UICorner",header).CornerRadius = UDim.new(0,18)
local hSq = Instance.new("Frame",header)
hSq.Size = UDim2.new(1,0,0,18); hSq.Position = UDim2.new(0,0,1,-18)
hSq.BackgroundColor3 = C_HEADER; hSq.BackgroundTransparency = 0.1
hSq.BorderSizePixel = 0; hSq.ZIndex = 5

-- top glow line
local tG = Instance.new("Frame",mainFrame)
tG.Size = UDim2.new(0.55,0,0,2); tG.Position = UDim2.new(0.225,0,0,0)
tG.BackgroundColor3 = C_BLUE; tG.BackgroundTransparency = 0.3
tG.BorderSizePixel = 0; tG.ZIndex = 6
Instance.new("UICorner",tG).CornerRadius = UDim.new(1,0)
Instance.new("UIGradient",tG).Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0,Color3.fromRGB(0,0,0)),
	ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
	ColorSequenceKeypoint.new(1,Color3.fromRGB(0,0,0))
})

local hLine = Instance.new("Frame",mainFrame)
hLine.Size = UDim2.new(1,0,0,1); hLine.Position = UDim2.new(0,0,0,HEADER_H)
hLine.BackgroundColor3 = C_DIVIDER; hLine.BorderSizePixel = 0; hLine.ZIndex = 4

local titLbl2 = Instance.new("TextLabel",header)
titLbl2.Size = UDim2.new(1,-70,1,0); titLbl2.Position = UDim2.new(0,18,0,0)
titLbl2.BackgroundTransparency = 1; titLbl2.Text = "Bot Pet Gifter"
titLbl2.TextColor3 = C_TEXT; titLbl2.TextSize = isMobile and 18 or 19
titLbl2.Font = Enum.Font.GothamBold; titLbl2.TextXAlignment = Enum.TextXAlignment.Center
titLbl2.ZIndex = 6

local closeBtn = Instance.new("TextButton",header)
closeBtn.Size = UDim2.new(0,34,0,34); closeBtn.Position = UDim2.new(1,-44,0.5,-17)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,45,45); closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255); closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold; closeBtn.BorderSizePixel = 0; closeBtn.ZIndex = 6
Instance.new("UICorner",closeBtn).CornerRadius = UDim.new(0,8)
closeBtn.MouseEnter:Connect(function()
	TweenService:Create(closeBtn,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(230,60,60)}):Play()
end)
closeBtn.MouseLeave:Connect(function()
	TweenService:Create(closeBtn,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(200,45,45)}):Play()
end)
closeBtn.MouseButton1Click:Connect(function()
	TweenService:Create(mainFrame,
		TweenInfo.new(0.28,Enum.EasingStyle.Back,Enum.EasingDirection.In),
		{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)}):Play()
	task.delay(0.3, function() screenGui:Destroy() end)
end)

-- body
local body = Instance.new("Frame",mainFrame)
body.Size = UDim2.new(1,0,1,-HEADER_H); body.Position = UDim2.new(0,0,0,HEADER_H)
body.BackgroundTransparency = 1; body.BorderSizePixel = 0; body.ZIndex = 3

-- execute button
local btnW = isMobile and 220 or 240
local btnH = isMobile and 58  or 62

local execBtn = Instance.new("TextButton",body)
execBtn.Size = UDim2.new(0,btnW,0,btnH)
execBtn.Position = UDim2.new(0.5,-btnW/2,0.5,-btnH/2-10)
execBtn.BackgroundColor3 = C_BLUE; execBtn.Text = ""
execBtn.BorderSizePixel = 0; execBtn.ZIndex = 5
Instance.new("UICorner",execBtn).CornerRadius = UDim.new(0,14)

local btnGrad = Instance.new("UIGradient",execBtn)
btnGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(100,160,255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(55,125,240)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(35,95,200))
})
btnGrad.Rotation = 90

local btnSt = Instance.new("UIStroke",execBtn)
btnSt.Color = Color3.fromRGB(120,175,255); btnSt.Thickness = 1.2; btnSt.Transparency = 0.4

local btnLbl = Instance.new("TextLabel",execBtn)
btnLbl.Size = UDim2.new(1,0,1,0); btnLbl.BackgroundTransparency = 1
btnLbl.Text = "Execute"; btnLbl.TextColor3 = Color3.fromRGB(255,255,255)
btnLbl.TextSize = isMobile and 20 or 22; btnLbl.Font = Enum.Font.GothamBold
btnLbl.TextXAlignment = Enum.TextXAlignment.Center; btnLbl.ZIndex = 6

local shine = Instance.new("Frame",execBtn)
shine.Size = UDim2.new(0,btnW*0.4,1,0); shine.Position = UDim2.new(-0.5,0,0,0)
shine.BackgroundColor3 = Color3.fromRGB(255,255,255)
shine.BackgroundTransparency = 0.82
shine.BorderSizePixel = 0; shine.ZIndex = 7
Instance.new("UICorner",shine).CornerRadius = UDim.new(0,10)
local shineG = Instance.new("UIGradient",shine)
shineG.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0,Color3.fromRGB(0,0,0)),
	ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
	ColorSequenceKeypoint.new(1,Color3.fromRGB(0,0,0))
})
shineG.Rotation = 15
local function playShine()
	if not shine.Parent then return end
	shine.Position = UDim2.new(-0.5,0,0,0)
	local t = TweenService:Create(shine,
		TweenInfo.new(0.7,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),
		{Position=UDim2.new(1.1,0,0,0)})
	t:Play()
	t.Completed:Connect(function() task.delay(3.2, playShine) end)
end
task.delay(2.8, playShine)

execBtn.MouseEnter:Connect(function()
	TweenService:Create(execBtn,TweenInfo.new(0.15),{BackgroundColor3=C_BLUE_H}):Play()
	TweenService:Create(btnSt,TweenInfo.new(0.15),{Transparency=0.1}):Play()
end)
execBtn.MouseLeave:Connect(function()
	TweenService:Create(execBtn,TweenInfo.new(0.15),{BackgroundColor3=C_BLUE}):Play()
	TweenService:Create(btnSt,TweenInfo.new(0.15),{Transparency=0.4}):Play()
end)
execBtn.MouseButton1Down:Connect(function()
	TweenService:Create(execBtn,TweenInfo.new(0.08),
		{BackgroundColor3=C_BLUE_P, Size=UDim2.new(0,btnW-6,0,btnH-4)}):Play()
	execBtn.Position = UDim2.new(0.5,-(btnW-6)/2,0.5,-(btnH-4)/2-10)
end)
execBtn.MouseButton1Up:Connect(function()
	TweenService:Create(execBtn,
		TweenInfo.new(0.18,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
		{BackgroundColor3=C_BLUE_H,Size=UDim2.new(0,btnW,0,btnH)}):Play()
	execBtn.Position = UDim2.new(0.5,-btnW/2,0.5,-btnH/2-10)
end)

execBtn.MouseButton1Click:Connect(function()
	local rip = Instance.new("Frame",execBtn)
	rip.Size = UDim2.new(0,0,0,0); rip.Position = UDim2.new(0.5,0,0.5,0)
	rip.BackgroundColor3 = Color3.fromRGB(255,255,255)
	rip.BackgroundTransparency = 0.62
	rip.BorderSizePixel = 0; rip.ZIndex = 8
	Instance.new("UICorner",rip).CornerRadius = UDim.new(1,0)
	TweenService:Create(rip,
		TweenInfo.new(0.42,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
		{Size=UDim2.new(0,300,0,300),
		 Position=UDim2.new(0.5,-150,0.5,-150),
		 BackgroundTransparency=1}):Play()
	task.delay(0.42, function() rip:Destroy() end)

	-- ⚡ EXECUTE loading (fast ~1s)
	showLoading(EXECUTE_STEPS, function()
		-- 🔧 PUT YOUR SCRIPT HERE
	end)
end)

-- tiktok label
local tkLbl = Instance.new("TextLabel",body)
tkLbl.Size = UDim2.new(0,130,0,18); tkLbl.Position = UDim2.new(1,-138,1,-24)
tkLbl.BackgroundTransparency = 1; tkLbl.Text = "tiktok: @ioa.fan"
tkLbl.TextColor3 = Color3.fromRGB(62,62,92); tkLbl.TextSize = isMobile and 11 or 12
tkLbl.Font = Enum.Font.Gotham; tkLbl.TextXAlignment = Enum.TextXAlignment.Right
tkLbl.ZIndex = 4

-- drag
local dragging, dragStart, startPos = false, nil, nil
header.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1
	or inp.UserInputType == Enum.UserInputType.Touch then
		dragging=true; dragStart=inp.Position; startPos=mainFrame.Position
	end
end)
UserInputService.InputChanged:Connect(function(inp)
	if not dragging then return end
	if inp.UserInputType == Enum.UserInputType.MouseMovement
	or inp.UserInputType == Enum.UserInputType.Touch then
		local d = inp.Position - dragStart
		mainFrame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset+d.X,
			startPos.Y.Scale, startPos.Y.Offset+d.Y)
	end
end)
UserInputService.InputEnded:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1
	or inp.UserInputType == Enum.UserInputType.Touch then dragging=false end
end)

RunService.Heartbeat:Connect(function()
	local a = (math.sin(tick()*1.4)+1)/2
	mfSt.Transparency = 0.05 + a*0.45
end)

-- ════════════════════════════════════════════════════════
--  STARTUP: loading → reveal main GUI
-- ════════════════════════════════════════════════════════
showLoading(STARTUP_STEPS, function()
	mainFrame.Visible = true
	mainFrame.Size = UDim2.new(0,0,0,0)
	mainFrame.Position = UDim2.new(0.5,0,0.5,0)
	TweenService:Create(mainFrame,
		TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{Size=UDim2.new(0,W,0,H),
		 Position=UDim2.new(0.5,-W/2,0.5,-H/2)}):Play()
end)
