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

-- Mobile-first sizing
local W = isMobile and 340 or 360
local H = isMobile and 290 or 310
local HEADER_H = isMobile and 52 or 54

-- Colors
local C_BG      = Color3.fromRGB(18, 18, 26)
local C_HEADER  = Color3.fromRGB(22, 22, 32)
local C_BLUE    = Color3.fromRGB(55, 125, 240)
local C_BLUE_H  = Color3.fromRGB(75, 145, 255)
local C_BLUE_P  = Color3.fromRGB(35, 95, 200)
local C_DIVIDER = Color3.fromRGB(40, 40, 60)
local C_TEXT    = Color3.fromRGB(220, 225, 245)
local C_MUTED   = Color3.fromRGB(80, 80, 110)

-- ── MAIN FRAME ───────────────────────────────────────────
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, W, 0, H)
mainFrame.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
mainFrame.BackgroundColor3 = C_BG
mainFrame.BackgroundTransparency = 0.08
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 18)

local mfStroke = Instance.new("UIStroke", mainFrame)
mfStroke.Color = C_BLUE
mfStroke.Thickness = 1.8
mfStroke.Transparency = 0.2

-- subtle inner gradient overlay
local bgGrad = Instance.new("Frame", mainFrame)
bgGrad.Size = UDim2.new(1,0,1,0)
bgGrad.BackgroundColor3 = Color3.fromRGB(30,30,50)
bgGrad.BackgroundTransparency = 0.85
bgGrad.BorderSizePixel = 0
bgGrad.ZIndex = 1
local bgGradCorner = Instance.new("UICorner", bgGrad)
bgGradCorner.CornerRadius = UDim.new(0,18)
local bgGradGrad = Instance.new("UIGradient", bgGrad)
bgGradGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(60,80,180)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(10,10,20))
})
bgGradGrad.Rotation = 135

-- pop in
mainFrame.Size = UDim2.new(0,0,0,0)
mainFrame.Position = UDim2.new(0.5,0,0.5,0)
TweenService:Create(mainFrame,
	TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
	{Size=UDim2.new(0,W,0,H),
	 Position=UDim2.new(0.5,-W/2,0.5,-H/2)}):Play()

-- ── HEADER ───────────────────────────────────────────────
local header = Instance.new("Frame", mainFrame)
header.Size = UDim2.new(1, 0, 0, HEADER_H)
header.BackgroundColor3 = C_HEADER
header.BackgroundTransparency = 0.1
header.BorderSizePixel = 0
header.ZIndex = 4
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 18)

-- square off header bottom
local hSq = Instance.new("Frame", header)
hSq.Size = UDim2.new(1,0,0,18)
hSq.Position = UDim2.new(0,0,1,-18)
hSq.BackgroundColor3 = C_HEADER
hSq.BackgroundTransparency = 0.1
hSq.BorderSizePixel = 0; hSq.ZIndex = 4

-- header bottom line
local headerLine = Instance.new("Frame", mainFrame)
headerLine.Size = UDim2.new(1,0,0,1)
headerLine.Position = UDim2.new(0,0,0,HEADER_H)
headerLine.BackgroundColor3 = C_DIVIDER
headerLine.BackgroundTransparency = 0
headerLine.BorderSizePixel = 0; headerLine.ZIndex = 4

-- glowing top accent line
local topGlow = Instance.new("Frame", mainFrame)
topGlow.Size = UDim2.new(0.55,0,0,2)
topGlow.Position = UDim2.new(0.225,0,0,0)
topGlow.BackgroundColor3 = C_BLUE
topGlow.BackgroundTransparency = 0.3
topGlow.BorderSizePixel = 0; topGlow.ZIndex = 6
local tgCorner = Instance.new("UICorner", topGlow)
tgCorner.CornerRadius = UDim.new(1,0)
local tgGrad = Instance.new("UIGradient", topGlow)
tgGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0,0,0)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0))
})

-- title
local titleLbl = Instance.new("TextLabel", header)
titleLbl.Size = UDim2.new(1,-70,1,0)
titleLbl.Position = UDim2.new(0,18,0,0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "Bot Pet Gifter"
titleLbl.TextColor3 = C_TEXT
titleLbl.TextSize = isMobile and 18 or 19
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextXAlignment = Enum.TextXAlignment.Center
titleLbl.ZIndex = 5

-- close button — big enough for mobile tap
local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 34, 0, 34)
closeBtn.Position = UDim2.new(1, -44, 0.5, -17)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 45, 45)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.TextSize = isMobile and 14 or 15
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0; closeBtn.ZIndex = 6
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

closeBtn.MouseEnter:Connect(function()
	TweenService:Create(closeBtn,TweenInfo.new(0.12),
		{BackgroundColor3=Color3.fromRGB(230,60,60)}):Play()
end)
closeBtn.MouseLeave:Connect(function()
	TweenService:Create(closeBtn,TweenInfo.new(0.12),
		{BackgroundColor3=Color3.fromRGB(200,45,45)}):Play()
end)
closeBtn.MouseButton1Click:Connect(function()
	TweenService:Create(mainFrame,
		TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.In),
		{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)}):Play()
	task.delay(0.3, function() screenGui:Destroy() end)
end)

-- ── BODY ─────────────────────────────────────────────────
local body = Instance.new("Frame", mainFrame)
body.Size = UDim2.new(1,0,1,-HEADER_H)
body.Position = UDim2.new(0,0,0,HEADER_H)
body.BackgroundTransparency = 1
body.BorderSizePixel = 0; body.ZIndex = 3

-- ── EXECUTE BUTTON ───────────────────────────────────────
local btnW = isMobile and 220 or 240
local btnH = isMobile and 58  or 62

local execBtn = Instance.new("TextButton", body)
execBtn.Size = UDim2.new(0, btnW, 0, btnH)
execBtn.Position = UDim2.new(0.5, -btnW/2, 0.5, -btnH/2 - 10)
execBtn.BackgroundColor3 = C_BLUE
execBtn.Text = ""
execBtn.BorderSizePixel = 0
execBtn.ZIndex = 5
Instance.new("UICorner", execBtn).CornerRadius = UDim.new(0, 14)

-- button gradient (top highlight)
local btnGrad = Instance.new("UIGradient", execBtn)
btnGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(100,160,255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(55,125,240)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(35,95,200))
})
btnGrad.Rotation = 90

local btnStroke = Instance.new("UIStroke", execBtn)
btnStroke.Color = Color3.fromRGB(120,175,255)
btnStroke.Thickness = 1.2
btnStroke.Transparency = 0.4

-- button label
local btnLbl = Instance.new("TextLabel", execBtn)
btnLbl.Size = UDim2.new(1,0,1,0)
btnLbl.BackgroundTransparency = 1
btnLbl.Text = "Execute"
btnLbl.TextColor3 = Color3.fromRGB(255,255,255)
btnLbl.TextSize = isMobile and 20 or 22
btnLbl.Font = Enum.Font.GothamBold
btnLbl.TextXAlignment = Enum.TextXAlignment.Center
btnLbl.ZIndex = 6

-- button shine sweep
local shine = Instance.new("Frame", execBtn)
shine.Size = UDim2.new(0, btnW*0.4, 1, 0)
shine.Position = UDim2.new(-0.5, 0, 0, 0)
shine.BackgroundColor3 = Color3.fromRGB(255,255,255)
shine.BackgroundTransparency = 0.82
shine.BorderSizePixel = 0; shine.ZIndex = 7
Instance.new("UICorner", shine).CornerRadius = UDim.new(0,10)
local shineGrad = Instance.new("UIGradient", shine)
shineGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0,0,0)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0))
})
shineGrad.Rotation = 15

local function playShine()
	shine.Position = UDim2.new(-0.5,0,0,0)
	local t = TweenService:Create(shine,
		TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
		{Position=UDim2.new(1.1,0,0,0)})
	t:Play()
	t.Completed:Connect(function() task.delay(3, playShine) end)
end
task.delay(1.2, playShine)

-- hover / press
execBtn.MouseEnter:Connect(function()
	TweenService:Create(execBtn,TweenInfo.new(0.15),
		{BackgroundColor3=C_BLUE_H}):Play()
	TweenService:Create(btnStroke,TweenInfo.new(0.15),
		{Transparency=0.1}):Play()
end)
execBtn.MouseLeave:Connect(function()
	TweenService:Create(execBtn,TweenInfo.new(0.15),
		{BackgroundColor3=C_BLUE}):Play()
	TweenService:Create(btnStroke,TweenInfo.new(0.15),
		{Transparency=0.4}):Play()
end)
execBtn.MouseButton1Down:Connect(function()
	TweenService:Create(execBtn,TweenInfo.new(0.08),
		{BackgroundColor3=C_BLUE_P,
		 Size=UDim2.new(0,btnW-6,0,btnH-4)}):Play()
	execBtn.Position = UDim2.new(0.5,-(btnW-6)/2,0.5,-(btnH-4)/2-10)
end)
execBtn.MouseButton1Up:Connect(function()
	TweenService:Create(execBtn,
		TweenInfo.new(0.18,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
		{BackgroundColor3=C_BLUE_H,
		 Size=UDim2.new(0,btnW,0,btnH)}):Play()
	execBtn.Position = UDim2.new(0.5,-btnW/2,0.5,-btnH/2-10)
end)

-- ripple on click
execBtn.MouseButton1Click:Connect(function()
	local rip = Instance.new("Frame", execBtn)
	rip.Size = UDim2.new(0,0,0,0)
	rip.Position = UDim2.new(0.5,0,0.5,0)
	rip.BackgroundColor3 = Color3.fromRGB(255,255,255)
	rip.BackgroundTransparency = 0.65
	rip.BorderSizePixel = 0; rip.ZIndex = 8
	Instance.new("UICorner",rip).CornerRadius = UDim.new(1,0)
	TweenService:Create(rip,
		TweenInfo.new(0.45,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
		{Size=UDim2.new(0,300,0,300),
		 Position=UDim2.new(0.5,-150,0.5,-150),
		 BackgroundTransparency=1}):Play()
	task.delay(0.45, function() rip:Destroy() end)

	-- 🔧 PUT YOUR SCRIPT HERE

end)

-- ── TIKTOK LABEL ─────────────────────────────────────────
local tiktokLbl = Instance.new("TextLabel", body)
tiktokLbl.Size = UDim2.new(0, 130, 0, 18)
tiktokLbl.Position = UDim2.new(1,-138,1,-24)
tiktokLbl.BackgroundTransparency = 1
tiktokLbl.Text = "tiktok: @ioa.fan"
tiktokLbl.TextColor3 = Color3.fromRGB(65,65,95)
tiktokLbl.TextSize = isMobile and 11 or 12
tiktokLbl.Font = Enum.Font.Gotham
tiktokLbl.TextXAlignment = Enum.TextXAlignment.Right
tiktokLbl.ZIndex = 4

-- ── DRAG ─────────────────────────────────────────────────
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

-- ── STROKE PULSE ─────────────────────────────────────────
RunService.Heartbeat:Connect
