local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BotPetGifter"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local ok = pcall(function() screenGui.Parent = PlayerGui end)
if not ok then screenGui.Parent = game:GetService("CoreGui") end

local W = isMobile and 280 or 320
local H = isMobile and 200 or 220

-- ── MAIN FRAME ───────────────────────────────────────────
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, W, 0, H)
mainFrame.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
mainFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
mainFrame.BackgroundTransparency = 0.12
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)

local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(60, 130, 240)
stroke.Thickness = 1.5
stroke.Transparency = 0.2

-- ── TOP BAR (drag handle) ────────────────────────────────
local topBar = Instance.new("Frame", mainFrame)
topBar.Size = UDim2.new(1, 0, 0, 38)
topBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
topBar.BackgroundTransparency = 0.15
topBar.BorderSizePixel = 0
topBar.ZIndex = 3
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 14)

-- square off bottom of topbar
local tSq = Instance.new("Frame", topBar)
tSq.Size = UDim2.new(1,0,0,14); tSq.Position = UDim2.new(0,0,1,-14)
tSq.BackgroundColor3 = Color3.fromRGB(20,20,28)
tSq.BackgroundTransparency = 0.15
tSq.BorderSizePixel = 0; tSq.ZIndex = 3

-- top divider line
local topLine = Instance.new("Frame", mainFrame)
topLine.Size = UDim2.new(1,0,0,1)
topLine.Position = UDim2.new(0,0,0,38)
topLine.BackgroundColor3 = Color3.fromRGB(50,110,220)
topLine.BackgroundTransparency = 0.5
topLine.BorderSizePixel = 0; topLine.ZIndex = 3

-- ── TITLE ────────────────────────────────────────────────
local titleLbl = Instance.new("TextLabel", topBar)
titleLbl.Size = UDim2.new(1, -60, 1, 0)
titleLbl.Position = UDim2.new(0, 0, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "Bot Pet Gifter"
titleLbl.TextColor3 = Color3.fromRGB(210, 225, 255)
titleLbl.TextSize = isMobile and 14 or 15
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextXAlignment = Enum.TextXAlignment.Center
titleLbl.ZIndex = 4

-- ── CLOSE BTN ────────────────────────────────────────────
local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(1, -28, 0.5, -11)
closeBtn.BackgroundColor3 = Color3.fromRGB(185, 45, 45)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.TextSize = 11
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0; closeBtn.ZIndex = 5
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)

closeBtn.MouseButton1Click:Connect(function()
	TweenService:Create(mainFrame,
		TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In),
		{Size=UDim2.new(0,0,0,0), Position=UDim2.new(0.5,0,0.5,0)}):Play()
	task.delay(0.27, function() screenGui:Destroy() end)
end)

-- ── EXECUTE BUTTON (center) ──────────────────────────────
local execBtn = Instance.new("TextButton", mainFrame)
execBtn.Size = UDim2.new(0, isMobile and 120 or 140, 0, isMobile and 42 or 46)
execBtn.Position = UDim2.new(0.5, -(isMobile and 60 or 70), 0.5, isMobile and -4 or -6)
execBtn.BackgroundColor3 = Color3.fromRGB(45, 110, 225)
execBtn.Text = "Execute"
execBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
execBtn.TextSize = isMobile and 14 or 15
execBtn.Font = Enum.Font.GothamBold
execBtn.BorderSizePixel = 0
execBtn.ZIndex = 4
Instance.new("UICorner", execBtn).CornerRadius = UDim.new(0, 10)

local execStroke = Instance.new("UIStroke", execBtn)
execStroke.Color = Color3.fromRGB(100, 160, 255)
execStroke.Thickness = 1.2
execStroke.Transparency = 0.3

-- hover / click effects
execBtn.MouseEnter:Connect(function()
	TweenService:Create(execBtn, TweenInfo.new(0.15),
		{BackgroundColor3 = Color3.fromRGB(60, 130, 245)}):Play()
	TweenService:Create(execStroke, TweenInfo.new(0.15),
		{Transparency = 0}):Play()
end)
execBtn.MouseLeave:Connect(function()
	TweenService:Create(execBtn, TweenInfo.new(0.15),
		{BackgroundColor3 = Color3.fromRGB(45, 110, 225)}):Play()
	TweenService:Create(execStroke, TweenInfo.new(0.15),
		{Transparency = 0.3}):Play()
end)
execBtn.MouseButton1Down:Connect(function()
	TweenService:Create(execBtn, TweenInfo.new(0.08),
		{BackgroundColor3 = Color3.fromRGB(30, 85, 190),
		 Size = UDim2.new(0, isMobile and 116 or 136, 0, isMobile and 40 or 44)}):Play()
	execBtn.Position = UDim2.new(0.5, -(isMobile and 58 or 68), 0.5, isMobile and -2 or -4)
end)
execBtn.MouseButton1Up:Connect(function()
	TweenService:Create(execBtn, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{BackgroundColor3 = Color3.fromRGB(60, 130, 245),
		 Size = UDim2.new(0, isMobile and 120 or 140, 0, isMobile and 42 or 46)}):Play()
	execBtn.Position = UDim2.new(0.5, -(isMobile and 60 or 70), 0.5, isMobile and -4 or -6)
end)

execBtn.MouseButton1Click:Connect(function()
	-- 🔧 PUT YOUR SCRIPT HERE
end)

-- ── TIKTOK LABEL (bottom right) ─────────────────────────
local tiktokLbl = Instance.new("TextLabel", mainFrame)
tiktokLbl.Size = UDim2.new(0, 110, 0, 16)
tiktokLbl.Position = UDim2.new(1, -116, 1, -20)
tiktokLbl.BackgroundTransparency = 1
tiktokLbl.Text = "tiktok: @ioa.fan"
tiktokLbl.TextColor3 = Color3.fromRGB(70, 70, 95)
tiktokLbl.TextSize = isMobile and 9 or 10
tiktokLbl.Font = Enum.Font.Gotham
tiktokLbl.TextXAlignment = Enum.TextXAlignment.Right
tiktokLbl.ZIndex = 4

-- ── DRAG ─────────────────────────────────────────────────
local dragging, dragStart, startPos = false, nil, nil
topBar.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1
	or inp.UserInputType == Enum.UserInputType.Touch then
		dragging = true; dragStart = inp.Position; startPos = mainFrame.Position
	end
end)
UserInputService.InputChanged:Connect(function(inp)
	if not dragging then return end
	if inp.UserInputType == Enum.UserInputType.MouseMovement
	or inp.UserInputType == Enum.UserInputType.Touch then
		local d = inp.Position - dragStart
		mainFrame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + d.X,
			startPos.Y.Scale, startPos.Y.Offset + d.Y)
	end
end)
UserInputService.InputEnded:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1
	or inp.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

-- ── POP IN ───────────────────────────────────────────────
mainFrame.Size = UDim2.new(0,0,0,0)
mainFrame.Position = UDim2.new(0.5,0,0.5,0)
TweenService:Create(mainFrame,
	TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
	{Size = UDim2.new(0,W,0,H),
	 Position = UDim2.new(0.5,-W/2,0.5,-H/2)}):Play()

-- ── STROKE PULSE ─────────────────────────────────────────
game:GetService("RunService").Heartbeat:Connect(function()
	local a = (math.sin(tick()*1.4)+1)/2
	stroke.Transparency = 0.05 + a*0.5
end)
