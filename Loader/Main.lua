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

-- Sizes
local LW = isMobile and 370 or 420    -- loading panel width (horizontal)
local LH = isMobile and 148 or 162    -- loading panel height
local MW = isMobile and 340 or 360    -- main ui width
local MH = isMobile and 290 or 310    -- main ui height
local HEADER_H = isMobile and 52 or 54
local BTN_W = isMobile and 220 or 240
local BTN_H = isMobile and 58 or 62
local ELW = isMobile and 330 or 370   -- execute loading width
local ELH = isMobile and 126 or 138   -- execute loading height

-- Colors
local C_BG     = Color3.fromRGB(16, 16, 22)
local C_HEADER = Color3.fromRGB(20, 20, 28)
local C_BLUE   = Color3.fromRGB(55, 125, 240)
local C_BLUE_H = Color3.fromRGB(75, 145, 255)
local C_BLUE_P = Color3.fromRGB(35, 95, 200)
local C_DIV    = Color3.fromRGB(38, 38, 55)
local C_TEXT   = Color3.fromRGB(220, 225, 245)
local C_MUTED  = Color3.fromRGB(85, 85, 110)
local BG_T     = 0.1

-- ── HELPERS ──────────────────────────────────────────────
local function spawnDots(parent, count)
	for i = 1, count do
		local dot = Instance.new("Frame", parent)
		dot.Size = UDim2.new(0,math.random(2,3),0,math.random(2,3))
		dot.Position = UDim2.new(math.random(),0,math.random(),0)
		dot.BackgroundColor3 = Color3.fromRGB(255,255,255)
		dot.BackgroundTransparency = math.random(62,82)/100
		dot.BorderSizePixel = 0; dot.ZIndex = 2
		Instance.new("UICorner",dot).CornerRadius = UDim.new(1,0)
		task.delay(math.random()*2, function()
			TweenService:Create(dot,
				TweenInfo.new(math.random(15,32)/10,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),
				{BackgroundTransparency=math.random(8,28)/100}):Play()
		end)
	end
end

local function makeRing(parent, size, zBase, letter, letterColor)
	local ring = Instance.new("Frame", parent)
	ring.Size = UDim2.new(0,size,0,size)
	ring.BackgroundTransparency = 1; ring.ZIndex = zBase
	Instance.new("UICorner",ring).CornerRadius = UDim.new(1,0)
	local rst = Instance.new("UIStroke",ring)
	rst.Color = Color3.fromRGB(50,50,70); rst.Thickness = 2.5; rst.Transparency = 0.15

	local sd = Instance.new("Frame",ring)
	sd.Size = UDim2.new(0,9,0,9); sd.AnchorPoint = Vector2.new(0.5,0.5)
	sd.Position = UDim2.new(0.5,0,0,-3)
	sd.BackgroundColor3 = Color3.fromRGB(215,215,238)
	sd.BorderSizePixel = 0; sd.ZIndex = zBase+2
	Instance.new("UICorner",sd).CornerRadius = UDim.new(1,0)

	local td = Instance.new("Frame",ring)
	td.Size = UDim2.new(0,5,0,5); td.AnchorPoint = Vector2.new(0.5,0.5)
	td.Position = UDim2.new(0.5,0,0,-3)
	td.BackgroundColor3 = C_BLUE; td.BackgroundTransparency = 0.45
	td.BorderSizePixel = 0; td.ZIndex = zBase+1
	Instance.new("UICorner",td).CornerRadius = UDim.new(1,0)

	local lbl = Instance.new("TextLabel",ring)
	lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1
	lbl.Text = letter; lbl.TextColor3 = letterColor or Color3.fromRGB(175,185,215)
	lbl.TextSize = math.floor(size*0.34); lbl.Font = Enum.Font.GothamBold
	lbl.TextXAlignment = Enum.TextXAlignment.Center
	lbl.TextYAlignment = Enum.TextYAlignment.Center; lbl.ZIndex = zBase+1
	return ring
end

local function makeHorizLoadPanel(w, h, zIdx)
	local panel = Instance.new("Frame", screenGui)
	panel.Size = UDim2.new(0,w,0,h)
	panel.Position = UDim2.new(0.5,-w/2,0.5,-h/2)
	panel.BackgroundColor3 = C_BG; panel.BackgroundTransparency = BG_T
	panel.BorderSizePixel = 0; panel.ClipsDescendants = true; panel.ZIndex = zIdx
	Instance.new("UICorner",panel).CornerRadius = UDim.new(0,16)
	local st = Instance.new("UIStroke",panel)
	st.Color = C_BLUE; st.Thickness = 1.5; st.Transparency = 0.18
	spawnDots(panel, 18)
	return panel, st
end

-- ══════════════════════════════════════════════════════════
--  1) INITIAL LOADING PANEL (horizontal)
-- ══════════════════════════════════════════════════════════
local dimBg = Instance.new("Frame", screenGui)
dimBg.Size = UDim2.new(1,0,1,0); dimBg.BackgroundColor3 = Color3.fromRGB(0,0,0)
dimBg.BackgroundTransparency = 0.38; dimBg.BorderSizePixel = 0; dimBg.ZIndex = 1

local loadPanel, lpSt = makeHorizLoadPanel(LW, LH, 3)
-- start collapsed, pop in
loadPanel.Size = UDim2.new(0,0,0,0); loadPanel.Position = UDim2.new(0.5,0,0.5,0)
TweenService:Create(loadPanel, TweenInfo.new(0.42,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
	{Size=UDim2.new(0,LW,0,LH),Position=UDim2.new(0.5,-LW/2,0.5,-LH/2)}):Play()

-- left ring area
local lRingArea = Instance.new("Frame",loadPanel)
lRingArea.Size = UDim2.new(0,math.floor(LW*0.36),1,0)
lRingArea.BackgroundTransparency = 1; lRingArea.ZIndex = 4

local lRing = makeRing(lRingArea, 66, 5, "B")
lRing.Position = UDim2.new(0.5,-33,0.5,-33)

-- vertical divider
local lVDiv = Instance.new("Frame",loadPanel)
lVDiv.Size = UDim2.new(0,1,0,math.floor(LH*0.6))
lVDiv.Position = UDim2.new(0,math.floor(LW*0.36),0.5,-math.floor(LH*0.3))
lVDiv.BackgroundColor3 = C_DIV; lVDiv.BackgroundTransparency = 0.2; lVDiv.BorderSizePixel = 0; lVDiv.ZIndex = 4

-- right text area
local rX = math.floor(LW*0.36)+14
local lTextArea = Instance.new("Frame",loadPanel)
lTextArea.Size = UDim2.new(0,LW-rX-12,1,0); lTextArea.Position = UDim2.new(0,rX,0,0)
lTextArea.BackgroundTransparency = 1; lTextArea.ZIndex = 4

local lTitle = Instance.new("TextLabel",lTextArea)
lTitle.Size = UDim2.new(1,0,0,26); lTitle.Position = UDim2.new(0,0,0,isMobile and 24 or 28)
lTitle.BackgroundTransparency = 1; lTitle.Text = "BOT PET GIFTER"
lTitle.TextColor3 = C_TEXT; lTitle.TextSize = isMobile and 17 or 19
lTitle.Font = Enum.Font.GothamBold; lTitle.TextXAlignment = Enum.TextXAlignment.Left; lTitle.ZIndex = 5

local lTitleLine = Instance.new("Frame",lTextArea)
lTitleLine.Size = UDim2.new(0,0,0,1.5); lTitleLine.Position = UDim2.new(0,0,0,isMobile and 53 or 58)
lTitleLine.BackgroundColor3 = C_BLUE; lTitleLine.BackgroundTransparency = 0.4
lTitleLine.BorderSizePixel = 0; lTitleLine.ZIndex = 5

local lStatus = Instance.new("TextLabel",lTextArea)
lStatus.Size = UDim2.new(1,0,0,16); lStatus.Position = UDim2.new(0,0,0,isMobile and 62 or 68)
lStatus.BackgroundTransparency = 1; lStatus.Text = "Initializing..."
lStatus.TextColor3 = C_MUTED; lStatus.TextSize = isMobile and 11 or 12
lStatus.Font = Enum.Font.Gotham; lStatus.TextXAlignment = Enum.TextXAlignment.Left; lStatus.ZIndex = 5

local lPct = Instance.new("TextLabel",lTextArea)
lPct.Size = UDim2.new(1,0,0,14); lPct.Position = UDim2.new(0,0,0,isMobile and 80 or 86)
lPct.BackgroundTransparency = 1; lPct.Text = "0%"
lPct.TextColor3 = Color3.fromRGB(165,170,210); lPct.TextSize = isMobile and 10 or 11
lPct.Font = Enum.Font.GothamBold; lPct.TextXAlignment = Enum.TextXAlignment.Left; lPct.ZIndex = 5

local lBarBg = Instance.new("Frame",lTextArea)
lBarBg.Size = UDim2.new(0.9,0,0,5); lBarBg.Position = UDim2.new(0,0,0,isMobile and 98 or 104)
lBarBg.BackgroundColor3 = Color3.fromRGB(30,30,46); lBarBg.BorderSizePixel = 0; lBarBg.ZIndex = 5
Instance.new("UICorner",lBarBg).CornerRadius = UDim.new(1,0)

local lBarFill = Instance.new("Frame",lBarBg)
lBarFill.Size = UDim2.new(0,0,1,0); lBarFill.BackgroundColor3 = C_BLUE
lBarFill.BorderSizePixel = 0; lBarFill.ZIndex = 6
Instance.new("UICorner",lBarFill).CornerRadius = UDim.new(1,0)

local lShimmer = Instance.new("Frame",lBarFill)
lShimmer.Size = UDim2.new(0,36,1,0); lShimmer.Position = UDim2.new(-0.3,0,0,0)
lShimmer.BackgroundColor3 = Color3.fromRGB(255,255,255); lShimmer.BackgroundTransparency = 0.65
lShimmer.BorderSizePixel = 0; lShimmer.ZIndex = 7
Instance.new("UICorner",lShimmer).CornerRadius = UDim.new(1,0)

local function shimLoop(shim)
	shim.Position = UDim2.new(-0.3,0,0,0)
	local t = TweenService:Create(shim, TweenInfo.new(0.65,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),
		{Position=UDim2.new(1.1,0,0,0)})
	t:Play()
	t.Completed:Connect(function() task.delay(0.3, function() shimLoop(shim) end) end)
end
task.delay(0.2, function() shimLoop(lShimmer) end)

-- ══════════════════════════════════════════════════════════
--  2) MAIN UI (hidden until loading done)
-- ══════════════════════════════════════════════════════════
local mainFrame = Instance.new("Frame",screenGui)
mainFrame.Size = UDim2.new(0,MW,0,MH)
mainFrame.Position = UDim2.new(0.5,-MW/2,0.5,-MH/2)
mainFrame.BackgroundColor3 = C_BG; mainFrame.BackgroundTransparency = BG_T
mainFrame.BorderSizePixel = 0; mainFrame.ClipsDescendants = true; mainFrame.Visible = false
Instance.new("UICorner",mainFrame).CornerRadius = UDim.new(0,18)

local mfStroke = Instance.new("UIStroke",mainFrame)
mfStroke.Color = C_BLUE; mfStroke.Thickness = 1.8; mfStroke.Transparency = 0.2

-- subtle gradient overlay
local bgG = Instance.new("Frame",mainFrame)
bgG.Size = UDim2.new(1,0,1,0); bgG.BackgroundColor3 = Color3.fromRGB(30,30,55)
bgG.BackgroundTransparency = 0.85; bgG.BorderSizePixel = 0; bgG.ZIndex = 1
Instance.new("UICorner",bgG).CornerRadius = UDim.new(0,18)
local bgGGrad = Instance.new("UIGradient",bgG)
bgGGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0,Color3.fromRGB(55,75,180)),
	ColorSequenceKeypoint.new(1,Color3.fromRGB(8,8,18))
}); bgGGrad.Rotation = 140

-- top glow line
local topGlow = Instance.new("Frame",mainFrame)
topGlow.Size = UDim2.new(0.55,0,0,2); topGlow.Position = UDim2.new(0.225,0,0,0)
topGlow.BackgroundColor3 = C_BLUE; topGlow.BackgroundTransparency = 0.3
topGlow.BorderSizePixel = 0; topGlow.ZIndex = 6
Instance.new("UICorner",topGlow).CornerRadius = UDim.new(1,0)
local tgGrad = Instance.new("UIGradient",topGlow)
tgGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0,Color3.fromRGB(0,0,0)),
	ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
	ColorSequenceKeypoint.new(1,Color3.fromRGB(0,0,0))
})

-- header
local header = Instance.new("Frame",mainFrame)
header.Size = UDim2.new(1,0,0,HEADER_H)
header.BackgroundColor3 = C_HEADER; header.BackgroundTransparency = 0.1
header.BorderSizePixel = 0; header.ZIndex = 4
Instance.new("UICorner",header).CornerRadius = UDim.new(0,18)
local hSq = Instance.new("Frame",header)
hSq.Size = UDim2.new(1,0,0,18); hSq.Position = UDim2.new(0,0,1,-18)
hSq.BackgroundColor3 = C_HEADER; hSq.BackgroundTransparency = 0.1
hSq.BorderSizePixel = 0; hSq.ZIndex = 4
local hLine = Instance.new("Frame",mainFrame)
hLine.Size = UDim2.new(1,0,0,1); hLine.Position = UDim2.new(0,0,0,HEADER_H)
hLine.BackgroundColor3 = C_DIV; hLine.BorderSizePixel = 0; hLine.ZIndex = 4

local titleLbl = Instance.new("TextLabel",header)
titleLbl.Size = UDim2.new(1,-70,1,0); titleLbl.Position = UDim2.new(0,14,0,0)
titleLbl.BackgroundTransparency = 1; titleLbl.Text = "Bot Pet Gifter"
titleLbl.TextColor3 = C_TEXT; titleLbl.TextSize = isMobile and 17 or 18
titleLbl.Font = Enum.Font.GothamBold; titleLbl.TextXAlignment = Enum.TextXAlignment.Center; titleLbl.ZIndex = 5

local closeBtn = Instance.new("TextButton",header)
closeBtn.Size = UDim2.new(0,34,0,34); closeBtn.Position = UDim2.new(1,-44,0.5,-17)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,45,45); closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255); closeBtn.TextSize = isMobile and 13 or 14
closeBtn.Font = Enum.Font.GothamBold; closeBtn.BorderSizePixel = 0; closeBtn.ZIndex = 6
Instance.new("UICorner",closeBtn).CornerRadius = UDim.new(0,8)

closeBtn.MouseEnter:Connect(function() TweenService:Create(closeBtn,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(230,60,60)}):Play() end)
closeBtn.MouseLeave:Connect(function() TweenService:Create(closeBtn,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(200,45,45)}):Play() end)
closeBtn.MouseButton1Click:Connect(function()
	TweenService:Create(mainFrame,TweenInfo.new(0.28,Enum.EasingStyle.Back,Enum.EasingDirection.In),
		{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)}):Play()
	task.delay(0.3, function() screenGui:Destroy() end)
end)

-- body
local body = Instance.new("Frame",mainFrame)
body.Size = UDim2.new(1,0,1,-HEADER_H); body.Position = UDim2.new(0,0,0,HEADER_H)
body.BackgroundTransparency = 1; body.BorderSizePixel = 0; body.ZIndex = 3

-- execute button
local execBtn = Instance.new("TextButton",body)
execBtn.Size = UDim2.new(0,BTN_W,0,BTN_H)
execBtn.Position = UDim2.new(0.5,-BTN_W/2,0.5,-BTN_H/2-10)
execBtn.BackgroundColor3 = C_BLUE; execBtn.Text = ""; execBtn.BorderSizePixel = 0; execBtn.ZIndex = 5
Instance.new("UICorner",execBtn).CornerRadius = UDim.new(0,14)

local btnGrad = Instance.new("UIGradient",execBtn)
btnGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0,Color3.fromRGB(100,160,255)),
	ColorSequenceKeypoint.new(0.5,Color3.fromRGB(55,125,240)),
	ColorSequenceKeypoint.new(1,Color3.fromRGB(35,95,200))
}); btnGrad.Rotation = 90

local btnStroke = Instance.new("UIStroke",execBtn)
btnStroke.Color = Color3.fromRGB(120,175,255); btnStroke.Thickness = 1.2; btnStroke.Transparency = 0.4

local btnLbl = Instance.new("TextLabel",execBtn)
btnLbl.Size = UDim2.new(1,0,1,0); btnLbl.BackgroundTransparency = 1
btnLbl.Text = "Execute"; btnLbl.TextColor3 = Color3.fromRGB(255,255,255)
btnLbl.TextSize = isMobile and 20 or 22; btnLbl.Font = Enum.Font.GothamBold
btnLbl.TextXAlignment = Enum.TextXAlignment.Center; btnLbl.ZIndex = 6

local shine = Instance.new("Frame",execBtn)
shine.Size = UDim2.new(0,BTN_W*0.4,1,0); shine.Position = UDim2.new(-0.5,0,0,0)
shine.BackgroundColor3 = Color3.fromRGB(255,255,255); shine.BackgroundTransparency = 0.82
shine.BorderSizePixel = 0; shine.ZIndex = 7
Instance.new("UICorner",shine).CornerRadius = UDim.new(0,10)
local shineG = Instance.new("UIGradient",shine)
shineG.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0,Color3.fromRGB(0,0,0)),
	ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
	ColorSequenceKeypoint.new(1,Color3.fromRGB(0,0,0))
}); shineG.Rotation = 15

local function playShine()
	shine.Position = UDim2.new(-0.5,0,0,0)
	local t = TweenService:Create(shine,TweenInfo.new(0.7,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),
		{Position=UDim2.new(1.1,0,0,0)})
	t:Play()
	t.Completed:Connect(function() task.delay(3,playShine) end)
end

execBtn.MouseEnter:Connect(function()
	TweenService:Create(execBtn,TweenInfo.new(0.15),{BackgroundColor3=C_BLUE_H}):Play()
	TweenService:Create(btnStroke,TweenInfo.new(0.15),{Transparency=0.1}):Play()
end)
execBtn.MouseLeave:Connect(function()
	TweenService:Create(execBtn,TweenInfo.new(0.15),{BackgroundColor3=C_BLUE}):Play()
	TweenService:Create(btnStroke,TweenInfo.new(0.15),{Transparency=0.4}):Play()
end)
execBtn.MouseButton1Down:Connect(function()
	TweenService:Create(execBtn,TweenInfo.new(0.08),
		{BackgroundColor3=C_BLUE_P,Size=UDim2.new(0,BTN_W-6,0,BTN_H-4)}):Play()
	execBtn.Position = UDim2.new(0.5,-(BTN_W-6)/2,0.5,-(BTN_H-4)/2-10)
end)
execBtn.MouseButton1Up:Connect(function()
	TweenService:Create(execBtn,TweenInfo.new(0.18,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
		{BackgroundColor3=C_BLUE_H,Size=UDim2.new(0,BTN_W,0,BTN_H)}):Play()
	execBtn.Position = UDim2.new(0.5,-BTN_W/2,0.5,-BTN_H/2-10)
end)

-- tiktok label
local tiktokLbl = Instance.new("TextLabel",body)
tiktokLbl.Size = UDim2.new(0,130,0,18); tiktokLbl.Position = UDim2.new(1,-138,1,-22)
tiktokLbl.BackgroundTransparency = 1; tiktokLbl.Text = "tiktok: @ioa.fan"
tiktokLbl.TextColor3 = Color3.fromRGB(60,60,90); tiktokLbl.TextSize = isMobile and 11 or 12
tiktokLbl.Font = Enum.Font.Gotham; tiktokLbl.TextXAlignment = Enum.TextXAlignment.Right; tiktokLbl.ZIndex = 4

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
		mainFrame.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,
			startPos.Y.Scale,startPos.Y.Offset+d.Y)
	end
end)
UserInputService.InputEnded:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1
	or inp.UserInputType == Enum.UserInputType.Touch then dragging=false end
end)

-- ══════════════════════════════════════════════════════════
--  3) EXECUTE LOADING PANEL (horizontal, fast)
-- ══════════════════════════════════════════════════════════
local execDim = Instance.new("Frame",screenGui)
execDim.Size = UDim2.new(1,0,1,0); execDim.BackgroundColor3 = Color3.fromRGB(0,0,0)
execDim.BackgroundTransparency = 1; execDim.BorderSizePixel = 0; execDim.ZIndex = 8; execDim.Visible = false

local execPanel, elpSt = makeHorizLoadPanel(ELW, ELH, 10)
execPanel.Visible = false

-- exec ring
local eRingArea = Instance.new("Frame",execPanel)
eRingArea.Size = UDim2.new(0,math.floor(ELW*0.34),1,0)
eRingArea.BackgroundTransparency = 1; eRingArea.ZIndex = 11

local eRing = makeRing(eRingArea, 54, 12, "⚡", C_BLUE)
eRing.Position = UDim2.new(0.5,-27,0.5,-27)

-- exec vert divider
local eVDiv = Instance.new("Frame",execPanel)
eVDiv.Size = UDim2.new(0,1,0,math.floor(ELH*0.6))
eVDiv.Position = UDim2.new(0,math.floor(ELW*0.34),0.5,-math.floor(ELH*0.3))
eVDiv.BackgroundColor3 = C_DIV; eVDiv.BackgroundTransparency = 0.2; eVDiv.BorderSizePixel = 0; eVDiv.ZIndex = 11

-- exec text area
local eX = math.floor(ELW*0.34)+14
local eTextArea = Instance.new("Frame",execPanel)
eTextArea.Size = UDim2.new(0,ELW-eX-12,1,0); eTextArea.Position = UDim2.new(0,eX,0,0)
eTextArea.BackgroundTransparency = 1; eTextArea.ZIndex = 11

local eTitle = Instance.new("TextLabel",eTextArea)
eTitle.Size = UDim2.new(1,0,0,24); eTitle.Position = UDim2.new(0,0,0,isMobile and 20 or 24)
eTitle.BackgroundTransparency = 1; eTitle.Text = "BOT PET GIFTER"
eTitle.TextColor3 = C_TEXT; eTitle.TextSize = isMobile and 15 or 17
eTitle.Font = Enum.Font.GothamBold; eTitle.TextXAlignment = Enum.TextXAlignment.Left; eTitle.ZIndex = 12

local eTitleLine = Instance.new("Frame",eTextArea)
eTitleLine.Size = UDim2.new(0.82,0,0,1.5); eTitleLine.Position = UDim2.new(0,0,0,isMobile and 47 or 52)
eTitleLine.BackgroundColor3 = C_BLUE; eTitleLine.BackgroundTransparency = 0.4
eTitleLine.BorderSizePixel = 0; eTitleLine.ZIndex = 12

local eStatus = Instance.new("TextLabel",eTextArea)
eStatus.Size = UDim2.new(1,0,0,16); eStatus.Position = UDim2.new(0,0,0,isMobile and 55 or 61)
eStatus.BackgroundTransparency = 1; eStatus.Text = "Executing script..."
eStatus.TextColor3 = C_MUTED; eStatus.TextSize = isMobile and 11 or 12
eStatus.Font = Enum.Font.Gotham; eStatus.TextXAlignment = Enum.TextXAlignment.Left; eStatus.ZIndex = 12

local ePct = Instance.new("TextLabel",eTextArea)
ePct.Size = UDim2.new(1,0,0,14); ePct.Position = UDim2.new(0,0,0,isMobile and 73 or 79)
ePct.BackgroundTransparency = 1; ePct.Text = "0%"
ePct.TextColor3 = Color3.fromRGB(165,170,210); ePct.TextSize = isMobile and 10 or 11
ePct.Font = Enum.Font.GothamBold; ePct.TextXAlignment = Enum.TextXAlignment.Left; ePct.ZIndex = 12

local eBarBg = Instance.new("Frame",eTextArea)
eBarBg.Size = UDim2.new(0.88,0,0,4); eBarBg.Position = UDim2.new(0,0,0,isMobile and 90 or 96)
eBarBg.BackgroundColor3 = Color3.fromRGB(28,28,44); eBarBg.BorderSizePixel = 0; eBarBg.ZIndex = 12
Instance.new("UICorner",eBarBg).CornerRadius = UDim.new(1,0)

local eBarFill = Instance.new("Frame",eBarBg)
eBarFill.Size = UDim2.new(0,0,1,0); eBarFill.BackgroundColor3 = C_BLUE
eBarFill.BorderSizePixel = 0; eBarFill.ZIndex = 13
Instance.new("UICorner",eBarFill).CornerRadius = UDim.new(1,0)

local eShimmer = Instance.new("Frame",eBarFill)
eShimmer.Size = UDim2.new(0,30,1,0); eShimmer.Position = UDim2.new(-0.3,0,0,0)
eShimmer.BackgroundColor3 = Color3.fromRGB(255,255,255); eShimmer.BackgroundTransparency = 0.65
eShimmer.BorderSizePixel = 0; eShimmer.ZIndex = 14
Instance.new("UICorner",eShimmer).CornerRadius = UDim.new(1,0)

-- ══════════════════════════════════════════════════════════
--  EXECUTE CLICK → run execute loading
-- ══════════════════════════════════════════════════════════
local executing = false

execBtn.MouseButton1Click:Connect(function()
	if executing then return end
	executing = true

	-- ripple
	local rip = Instance.new("Frame",execBtn)
	rip.Size = UDim2.new(0,0,0,0); rip.Position = UDim2.new(0.5,0,0.5,0)
	rip.BackgroundColor3 = Color3.fromRGB(255,255,255); rip.BackgroundTransparency = 0.65
	rip.BorderSizePixel = 0; rip.ZIndex = 8
	Instance.new("UICorner",rip).CornerRadius = UDim.new(1,0)
	TweenService:Create(rip,TweenInfo.new(0.4,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
		{Size=UDim2.new(0,300,0,300),Position=UDim2.new(0.5,-150,0.5,-150),BackgroundTransparency=1}):Play()
	task.delay(0.4, function() rip:Destroy() end)

	task.delay(0.14, function()
		-- show execute loading
		execDim.Visible = true
		TweenService:Create(execDim,TweenInfo.new(0.2),{BackgroundTransparency=0.52}):Play()
		execPanel.Visible = true
		execPanel.Size = UDim2.new(0,0,0,0); execPanel.Position = UDim2.new(0.5,0,0.5,0)
		TweenService:Create(execPanel,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
			{Size=UDim2.new(0,ELW,0,ELH),Position=UDim2.new(0.5,-ELW/2,0.5,-ELH/2)}):Play()

		task.delay(0.2, function() shimLoop(eShimmer) end)

		-- spin exec ring
		local eAngle = 0
		local eConn = RunService.Heartbeat:Connect(function(dt)
			eAngle = eAngle + dt*260
			eRing.Rotation = eAngle
		end)

		local eSteps = {
			{pct=25, msg="Executing script..."},
			{pct=55, msg="Sending requests..."},
			{pct=80, msg="Gifting pets..."},
			{pct=100,msg="Done!"},
		}

		task.spawn(function()
			for _, step in ipairs(eSteps) do
				task.wait(math.random(16,24)/100)  -- super fast: ~0.2s each
				TweenService:Create(eStatus,TweenInfo.new(0.08),{TextTransparency=1}):Play()
				task.wait(0.08)
				eStatus.Text = step.msg
				TweenService:Create(eStatus,TweenInfo.new(0.08),{TextTransparency=0}):Play()
				ePct.Text = step.pct.."%"
				TweenService:Create(eBarFill,TweenInfo.new(0.22,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
					{Size=UDim2.new(step.pct/100,0,1,0)}):Play()
			end

			task.wait(0.22)
			eConn:Disconnect()
			TweenService:Create(eBarFill,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(255,255,255)}):Play()
			task.wait(0.18)

			-- collapse exec panel
			TweenService:Create(execPanel,TweenInfo.new(0.25,Enum.EasingStyle.Back,Enum.EasingDirection.In),
				{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)}):Play()
			TweenService:Create(execDim,TweenInfo.new(0.2),{BackgroundTransparency=1}):Play()
			task.wait(0.28)
			execPanel.Visible = false; execDim.Visible = false
			eBarFill.Size = UDim2.new(0,0,1,0); eBarFill.BackgroundColor3 = C_BLUE
			executing = false

			-- 🔧 PUT YOUR SCRIPT HERE
			-- loadstring(game:HttpGet("your url"))()
		end)
	end)
end)

-- ══════════════════════════════════════════════════════════
--  INITIAL LOADING SEQUENCE
-- ══════════════════════════════════════════════════════════
local angle = 0
local spinConn = RunService.Heartbeat:Connect(function(dt)
	angle = angle + dt*225
	lRing.Rotation = angle
end)

task.delay(0.22, function()
	TweenService:Create(lTitleLine,TweenInfo.new(0.45,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
		{Size=UDim2.new(0.72,0,0,1.5)}):Play()
end)

local loadSteps = {
	{pct=20,  msg="Initializing..."},
	{pct=42,  msg="Loading assets..."},
	{pct=68,  msg="Building GUI..."},
	{pct=88,  msg="Almost ready..."},
	{pct=100, msg="Done!"},
}

task.spawn(function()
	for _, step in ipairs(loadSteps) do
		task.wait(math.random(28,42)/100)
		TweenService:Create(lStatus,TweenInfo.new(0.12),{TextTransparency=1}):Play()
		task.wait(0.12)
		lStatus.Text = step.msg
		TweenService:Create(lStatus,TweenInfo.new(0.12),{TextTransparency=0}):Play()
		lPct.Text = step.pct.."%"
		TweenService:Create(lBarFill,TweenInfo.new(0.32,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
			{Size=UDim2.new(step.pct/100,0,1,0)}):Play()
	end

	task.wait(0.28)
	spinConn:Disconnect()
	TweenService:Create(lBarFill,TweenInfo.new(0.14),{BackgroundColor3=Color3.fromRGB(255,255,255)}):Play()
	task.wait(0.2)

	TweenService:Create(loadPanel,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.In),
		{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)}):Play()
	TweenService:Create(dimBg,TweenInfo.new(0.25),{BackgroundTransparency=1}):Play()
	task.wait(0.32)
	loadPanel:Destroy(); dimBg:Destroy()

	-- pop in main ui
	mainFrame.Visible = true
	mainFrame.Size = UDim2.new(0,0,0,0); mainFrame.Position = UDim2.new(0.5,0,0.5,0)
	TweenService:Create(mainFrame,TweenInfo.new(0.42,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
		{Size=UDim2.new(0,MW,0,MH),Position=UDim2.new(0.5,-MW/2,0.5,-MH/2)}):Play()
	task.delay(1.2, playShine)
end)

-- stroke pulse
RunService.Heartbeat:Connect(function()
	local a = (math.sin(tick()*1.4)+1)/2
	mfStroke.Transparency = 0.05 + a*0.45
	if execPanel.Visible then
		elpSt.Transparency = 0.05 + a*0.4
	end
end)
