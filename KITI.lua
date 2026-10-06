print("[PULSITI] boot start")
Players = game:GetService("Players")
RunService = game:GetService("RunService")
UserInputService = game:GetService("UserInputService")
Lighting = game:GetService("Lighting")
TeleportService = game:GetService("TeleportService")
StarterGui = game:GetService("StarterGui")
HttpService = game:GetService("HttpService")
LocalPlayer = Players.LocalPlayer
Camera = workspace.CurrentCamera
origLighting = {}
origAtmo = {}
pcall(function()
    origLighting = {
        ClockTime = Lighting.ClockTime,
        Brightness = Lighting.Brightness,
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        FogColor = Lighting.FogColor,
        FogStart = Lighting.FogStart,
        FogEnd = Lighting.FogEnd,
        ExposureCompensation = Lighting.ExposureCompensation,
        GlobalShadows = Lighting.GlobalShadows,
    }
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("Atmosphere") or v:IsA("Clouds") or v:IsA("Sky") then
            local c = v:Clone()
            table.insert(origAtmo, {class = v.ClassName, obj = c})
        end
    end
end)
function restoreLighting()
    pcall(function()
        for k, v in pairs(origLighting) do
            pcall(function() Lighting[k] = v end)
        end
        for _, e in ipairs(origAtmo) do
            local exists = false
            for _, cur in ipairs(Lighting:GetChildren()) do
                if cur.ClassName == e.class then exists = true break end
            end
            if not exists and e.obj then
                local c = e.obj:Clone()
                c.Parent = Lighting
            end
        end
    end)
end
BG_ASSET = "rbxassetid://0"
LOGO_ASSET = "rbxassetid://0"
GAME_ICON_ASSET = "rbxassetid://0"
GITHUB_SOUNDS_BASE = ""
MainFrameRef = nil
_flyArmed = false
targSingleOnly = false
toastGui = nil
function getUiParent()
    local par = nil
    if type(gethui) == "function" then pcall(function() par = gethui() end) end
    if type(par) ~= "Instance" then pcall(function() par = game:GetService("CoreGui") end) end
    if type(par) ~= "Instance" then par = LocalPlayer:FindFirstChild("PlayerGui") end
    return par
end
function notify(title, text, dur)
    task.spawn(function()
        pcall(function()
            if not toastGui or not toastGui.Parent then
                toastGui = Instance.new("ScreenGui")
                toastGui.Name = "PULSITIToasts"
                toastGui.ResetOnSpawn = false
                toastGui.Parent = getUiParent()
                local lay = Instance.new("UIListLayout")
                lay.HorizontalAlignment = Enum.HorizontalAlignment.Center
                lay.VerticalAlignment = Enum.VerticalAlignment.Top
                lay.Padding = UDim.new(0, 6)
                lay.Parent = toastGui
                local pad = Instance.new("UIPadding")
                pad.PaddingTop = UDim.new(0, 60)
                pad.Parent = toastGui
            end
            local f = Instance.new("Frame")
            f.Size = UDim2.new(0, 260, 0, 52)
            f.BackgroundColor3 = Color3.fromRGB(11, 15, 30)
            f.BackgroundTransparency = 0.1
            f.BorderSizePixel = 0
            f.Parent = toastGui
            local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 4) c.Parent = f
            local st = Instance.new("UIStroke") st.Color = Color3.fromRGB(44, 58, 102) st.Thickness = 1 st.Parent = f
            local t1 = Instance.new("TextLabel")
            t1.Size = UDim2.new(1, -16, 0, 18) t1.Position = UDim2.new(0, 8, 0, 5)
            t1.BackgroundTransparency = 1 t1.Text = tostring(title)
            t1.Font = Enum.Font.GothamBold t1.TextSize = 13
            t1.TextColor3 = Color3.fromRGB(110, 160, 255)
            t1.TextXAlignment = Enum.TextXAlignment.Left t1.Parent = f
            local t2 = Instance.new("TextLabel")
            t2.Size = UDim2.new(1, -16, 0, 24) t2.Position = UDim2.new(0, 8, 0, 23)
            t2.BackgroundTransparency = 1 t2.Text = tostring(text)
            t2.Font = Enum.Font.Gotham t2.TextSize = 12
            t2.TextColor3 = Color3.fromRGB(220, 224, 240)
            t2.TextXAlignment = Enum.TextXAlignment.Left t2.TextWrapped = true t2.Parent = f
            local kids = {}
            for _, ch in ipairs(toastGui:GetChildren()) do if ch:IsA("Frame") then table.insert(kids, ch) end end
            if #kids > 3 then kids[1]:Destroy() end
            task.wait(dur or 2.5)
            for i = 0, 10 do
                local a = i / 10
                f.BackgroundTransparency = 0.1 + a * 0.9
                for _, d in ipairs(f:GetDescendants()) do
                    if d:IsA("TextLabel") then d.TextTransparency = a
                    elseif d:IsA("UIStroke") then d.Transparency = a end
                end
                task.wait(0.03)
            end
            pcall(function() f:Destroy() end)
        end)
    end)
end
function notifyDev(title, text)
    task.spawn(function()
        pcall(function()
            if not toastGui or not toastGui.Parent then
                toastGui = Instance.new("ScreenGui")
                toastGui.Name = "PULSITIToasts"
                toastGui.ResetOnSpawn = false
                toastGui.Parent = getUiParent()
                local lay = Instance.new("UIListLayout")
                lay.HorizontalAlignment = Enum.HorizontalAlignment.Center
                lay.VerticalAlignment = Enum.VerticalAlignment.Top
                lay.Padding = UDim.new(0, 6)
                lay.Parent = toastGui
                local pad = Instance.new("UIPadding")
                pad.PaddingTop = UDim.new(0, 60)
                pad.Parent = toastGui
            end
            local f = Instance.new("Frame")
            f.Size = UDim2.new(0, 280, 0, 56)
            f.BackgroundColor3 = Color3.fromRGB(58, 16, 16)
            f.BackgroundTransparency = 0.08
            f.BorderSizePixel = 0
            f.Parent = toastGui
            local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 6) c.Parent = f
            local st = Instance.new("UIStroke") st.Color = Color3.fromRGB(120, 40, 40) st.Thickness = 1 st.Parent = f
            local t1 = Instance.new("TextLabel")
            t1.Size = UDim2.new(1, -16, 0, 20) t1.Position = UDim2.new(0, 8, 0, 6)
            t1.BackgroundTransparency = 1 t1.Text = tostring(title)
            t1.Font = Enum.Font.GothamBold t1.TextSize = 14
            t1.TextColor3 = Color3.fromRGB(255, 235, 235)
            t1.TextXAlignment = Enum.TextXAlignment.Center t1.Parent = f
            local t2 = Instance.new("TextLabel")
            t2.Size = UDim2.new(1, -16, 0, 22) t2.Position = UDim2.new(0, 8, 0, 28)
            t2.BackgroundTransparency = 1 t2.Text = tostring(text)
            t2.Font = Enum.Font.Gotham t2.TextSize = 12
            t2.TextColor3 = Color3.fromRGB(235, 200, 200)
            t2.TextXAlignment = Enum.TextXAlignment.Center t2.TextWrapped = true t2.Parent = f
            task.wait(2.5)
            pcall(function() f:Destroy() end)
        end)
    end)
end
function getPlayerRole(player)
    if not player or not player:IsA("Player") then return "Innocent" end
    local character = player.Character
    local backpack = nil
    pcall(function() backpack = player:FindFirstChildOfClass("Backpack") or player.Backpack end)
    local hasKnife, hasGun = false, false
    if backpack then
        if backpack:FindFirstChild("Knife") then hasKnife = true end
        if backpack:FindFirstChild("Gun") then hasGun = true end
    end
    if character then
        if character:FindFirstChild("Knife") then hasKnife = true end
        if character:FindFirstChild("Gun") then hasGun = true end
    end
    if hasKnife then return "Murderer" elseif hasGun then return "Sheriff" else return "Innocent" end
end
function getRoot(char)
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end
function getHumanoid(char)
    if not char then return nil end
    return char:FindFirstChildOfClass("Humanoid")
end
ESP_Enabled = false
Highlights = {}
gunEspEnabled = false
gunEspObjects = {}
gunEspTimer = 0
xrayEnabled = false
XRayHighlights = {}
espStyle = "Default"
tracersOn = false
tracerOrigin = "Bottom"
skelOn = false
skelOwnColor = false
skelColorName = "Белый"
skelSat = 100
skelBright = 100
showRole = true
showNick = true
showStuds = true
boxOn = false
boxStyle = "Corners"
boxOwnColor = false
boxColorName = "Белый"
boxSat = 0
boxBright = 100
EspDraw = {}
espAdvConn = nil
hasDrawing = false
pcall(function() local d = Drawing.new("Line") d:Remove() hasDrawing = true end)
EspColors = {
    ["Белый"] = Color3.fromRGB(255, 255, 255),
    ["Красный"] = Color3.fromRGB(255, 60, 60),
    ["Зелёный"] = Color3.fromRGB(60, 255, 90),
    ["Синий"] = Color3.fromRGB(80, 140, 255),
    ["Бирюзовый"] = Color3.fromRGB(64, 224, 208),
    ["Жёлтый"] = Color3.fromRGB(255, 220, 60),
    ["Оранжевый"] = Color3.fromRGB(255, 140, 40),
    ["Розовый"] = Color3.fromRGB(255, 120, 200),
    ["Фиолетовый"] = Color3.fromRGB(170, 90, 255),
    ["Чёрный"] = Color3.fromRGB(20, 20, 20),
    ["Серый"] = Color3.fromRGB(150, 150, 150),
    ["Лайм"] = Color3.fromRGB(150, 255, 50),
}
EspColorNames = {"Белый","Красный","Зелёный","Синий","Бирюзовый","Жёлтый","Оранжевый","Розовый","Фиолетовый","Чёрный","Серый","Лайм"}
noclipBind = Enum.KeyCode.N
bhopBind = nil
spinBind = nil
bombJumpKey = nil
invisBind = Enum.KeyCode.G
invisTgl = nil
bhopPower = 5
bhopSound = false
noclipTgl = nil
bhopTgl = nil
spinTgl = nil
noclipActive = false
noclipConn = nil
infJumpActive = false
infJumpConn = nil
infJumpDebounce = false
antiFlingActive = false
antiFlingConn = nil
bombJumpActive = false
bombJumpConn = nil
flyActive = false
flying = false
flyKeyDown, flyKeyUp = nil, nil
flySpeed = 48
flyBind = Enum.KeyCode.F
spinActive = false
spinSpeed = 50
spinInstance = nil
bhopActive = false
bhopConn = nil
bhopSpeed = 50
bhopLastJump = 0
invisibleActive = false
invisPlatform = nil
invisSavedCF = nil
invisSavedFPDH = nil
silentAimEnabled = false
autoGunEnabled = false
aimFov = 120
showFov = false
fovCircle = nil
shotButton = nil
SILENT_OFFSET = 2.8
killAuraActive = false
killAuraRadius = 18
knifeThrowAimbot = false
auraActive = false
auraParticles = {}
auraCache = {}
auraSelected = {}
auraColorValues = {R = 133, G = 220, B = 255}
aura_ids = {
    angel = "97658130917593", starlight = "134645216613107", heavenly = "139300897520961",
    ribbon = "132069507632161", sakura = "81755778619404", wind = "80694081850877",
    flow = "119913533725648", star = "73754563740680",
}
aura_order = {"angel","starlight","heavenly","ribbon","sakura","wind","flow","star"}
for _, n in ipairs(aura_order) do auraSelected[n] = false end
fpsBoostEnabled = false
fpsBoostConn = nil
shaderCurrent = "None"
shaderLoop = nil
clearAtmoActive = false
skyCurrent = "None"
jerkActive = false
jerkTool = nil
jerkTrack = nil
jerkJorking = false
touchFlingActive = false
clickFlingActive = false
clickHumpActive = false
orbitActive = false
orbitSpeed = 5
bangActive = false
bangTarget = nil
bangTrack = nil
bangConns = {}
emoteTrack = nil
autoEmoteActive = false
Farm_Enabled = false
IsFarming = false
FarmThread = nil
CoinContainer = nil
TouchedCoins = {}
IsResetting = false
farmSpeed = 21
farmVersion = "V2 (fast, prone)"
autoRespawnBag = true
farmSession = 0
farmTotal = 0
farmStatus = "Waiting"
avoidMurder = true
autoFlingRespawn = false
killAllFullBag = false
coinFails = {}
farmCycles = 0
FlingActive = false
FlingTargets = {}
menuBindKey = Enum.KeyCode.LeftControl
uiTheme = "Gray"
ACCENT = Color3.fromRGB(52, 199, 123)
function setupHighlight(player, character)
    if not ESP_Enabled then return end
    if player == LocalPlayer then return end
    if Highlights[player] then pcall(function() Highlights[player]:Destroy() end) end
    local hl = Instance.new("Highlight")
    hl.Adornee = character
    hl.Parent = character
    Highlights[player] = hl
end
function applyESP(player)
    if player == LocalPlayer then return end
    if player.Character then setupHighlight(player, player.Character) end
    player.CharacterAdded:Connect(function(char)
        if ESP_Enabled then task.wait(0.5) setupHighlight(player, char) end
    end)
end
function setESP(state)
    ESP_Enabled = state
    if state then
        for _, p in ipairs(Players:GetPlayers()) do applyESP(p) end
        notify("ESP", "Role ESP enabled")
    else
        for _, h in pairs(Highlights) do pcall(function() h:Destroy() end) end
        table.clear(Highlights)
        notify("ESP", "Disabled")
    end
    ensureAdvESP()
end
function espRoleColor(p)
    local r = getPlayerRole(p)
    if r == "Murderer" then return Color3.fromRGB(255, 0, 0)
    elseif r == "Sheriff" then return Color3.fromRGB(0, 80, 255)
    else return Color3.fromRGB(0, 255, 0) end
end
function espHSV(name, sat, bright)
    local base = EspColors[name] or Color3.fromRGB(255, 255, 255)
    local h, s, v = base:ToHSV()
    return Color3.fromHSV(h, math.clamp(s * sat / 100, 0, 1), math.clamp(v * bright / 100, 0, 1))
end
function espGetDraw(p)
    local d = EspDraw[p]
    if not d then
        d = {tracer = nil, skel = {}, box = {}, tag = nil}
        EspDraw[p] = d
    end
    return d
end
function espHideDraw(d)
    if d.tracer then d.tracer.Visible = false end
    for _, l in ipairs(d.skel) do l.Visible = false end
    for _, l in ipairs(d.box) do l.Visible = false end
    if d.tag then d.tag.Enabled = false end
end
function clearEspDraw()
    for _, d in pairs(EspDraw) do
        if d.tracer then pcall(function() d.tracer:Remove() end) end
        for _, l in ipairs(d.skel) do pcall(function() l:Remove() end) end
        for _, l in ipairs(d.box) do pcall(function() l:Remove() end) end
        if d.tag then pcall(function() d.tag:Destroy() end) end
    end
    table.clear(EspDraw)
end
Players.PlayerRemoving:Connect(function(p)
    local d = EspDraw[p]
    if d then
        if d.tracer then pcall(function() d.tracer:Remove() end) end
        for _, l in ipairs(d.skel) do pcall(function() l:Remove() end) end
        for _, l in ipairs(d.box) do pcall(function() l:Remove() end) end
        if d.tag then pcall(function() d.tag:Destroy() end) end
        EspDraw[p] = nil
    end
    if Highlights[p] then pcall(function() Highlights[p]:Destroy() end) Highlights[p] = nil end
end)
function espLine(d, bucket, i, from, to, color, width)
    local arr = d[bucket]
    local ln = arr[i]
    if not ln then
        local ok, res = pcall(function() return Drawing.new("Line") end)
        if not ok or not res then return nil end
        ln = res
        arr[i] = ln
    end
    ln.Visible = true
    ln.From = from
    ln.To = to
    ln.Color = color
    ln.Thickness = width or 1
    ln.Transparency = 1
    return ln
end
skelPairs = {
    {"Head","UpperTorso"},{"Head","Torso"},
    {"UpperTorso","LowerTorso"},
    {"UpperTorso","LeftUpperArm"},{"UpperTorso","RightUpperArm"},
    {"Torso","Left Arm"},{"Torso","Right Arm"},
    {"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
    {"LowerTorso","LeftUpperLeg"},{"LowerTorso","RightUpperLeg"},
    {"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
    {"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
    {"Torso","Left Leg"},{"Torso","Right Leg"},
}
function espAdvTick()
    if not ESP_Enabled then return end
    local cam = workspace.CurrentCamera
    local vs = cam.ViewportSize
    local pulse = (math.sin(tick() * 4) + 1) / 2
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local char = p.Character
            local root = char and getRoot(char)
            local hum = char and getHumanoid(char)
            local d = espGetDraw(p)
            if char and root and hum and hum.Health > 0 then
                local rc = espRoleColor(p)
                local hl = Highlights[p]
                if not hl or hl.Adornee ~= char then
                    if hl then pcall(function() hl:Destroy() end) end
                    hl = Instance.new("Highlight")
                    hl.Adornee = char
                    hl.Parent = char
                    Highlights[p] = hl
                end
                if espStyle == "Default" then
                    hl.FillColor = rc hl.OutlineColor = rc
                    hl.FillTransparency = 0.5 hl.OutlineTransparency = 0.1
                    hl.DepthMode = Enum.HighlightDepthMode.Occluded
                elseif espStyle == "Outline" then
                    hl.FillColor = rc hl.OutlineColor = rc
                    hl.FillTransparency = 1 hl.OutlineTransparency = 0
                    hl.DepthMode = Enum.HighlightDepthMode.Occluded
                elseif espStyle == "Filled" then
                    hl.FillColor = rc hl.OutlineColor = rc
                    hl.FillTransparency = 0.25 hl.OutlineTransparency = 1
                    hl.DepthMode = Enum.HighlightDepthMode.Occluded
                elseif espStyle == "Glow (animated)" then
                    hl.FillColor = rc hl.OutlineColor = rc
                    hl.FillTransparency = 0.3 + pulse * 0.4 hl.OutlineTransparency = 0.1
                    hl.DepthMode = Enum.HighlightDepthMode.Occluded
                elseif espStyle == "Pulse (animated)" then
                    hl.FillColor = rc hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.5 hl.OutlineTransparency = pulse * 0.8
                    hl.DepthMode = Enum.HighlightDepthMode.Occluded
                elseif espStyle == "Chams (through walls)" then
                    hl.FillColor = rc hl.OutlineColor = rc
                    hl.FillTransparency = 0.5 hl.OutlineTransparency = 0.1
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                elseif espStyle == "Ghost (animated)" then
                    hl.FillColor = rc hl.OutlineColor = rc
                    hl.FillTransparency = 0.85 + pulse * 0.15 hl.OutlineTransparency = 1
                    hl.DepthMode = Enum.HighlightDepthMode.Occluded
                else
                    hl.FillColor = rc hl.OutlineColor = rc
                    hl.FillTransparency = 0.85 hl.OutlineTransparency = 1
                    hl.DepthMode = Enum.HighlightDepthMode.Occluded
                end
                if hasDrawing then
                    if tracersOn then
                        local sp, onScr = cam:WorldToViewportPoint(root.Position)
                        local from = Vector2.new(vs.X / 2, vs.Y)
                        if tracerOrigin == "Top" then from = Vector2.new(vs.X / 2, 0)
                        elseif tracerOrigin == "Center" then from = UserInputService:GetMouseLocation() end
                        if onScr then espLine(d, "tracer", 1, from, Vector2.new(sp.X, sp.Y), rc, 1)
                        elseif d.tracer then d.tracer.Visible = false end
                    elseif d.tracer then d.tracer.Visible = false end
                    if skelOn then
                        local scol = skelOwnColor and espHSV(skelColorName, skelSat, skelBright) or rc
                        local li = 0
                        for _, pr in ipairs(skelPairs) do
                            local a = char:FindFirstChild(pr[1])
                            local b = char:FindFirstChild(pr[2])
                            if a and b and a:IsA("BasePart") and b:IsA("BasePart") then
                                local pa, va = cam:WorldToViewportPoint(a.Position)
                                local pb, vb = cam:WorldToViewportPoint(b.Position)
                                if va and vb then
                                    li = li + 1
                                    espLine(d, "skel", li, Vector2.new(pa.X, pa.Y), Vector2.new(pb.X, pb.Y), scol, 1)
                                end
                            end
                        end
                        for j = li + 1, #d.skel do d.skel[j].Visible = false end
                    else
                        for _, l in ipairs(d.skel) do l.Visible = false end
                    end
                    if boxOn then
                        local bcol = boxOwnColor and espHSV(boxColorName, boxSat, boxBright) or Color3.fromRGB(255, 255, 255)
                        local right = cam.CFrame.RightVector
                        local pts = {}
                        local allVis = true
                        local tops = root.Position + Vector3.new(0, 3.2, 0)
                        local bots = root.Position - Vector3.new(0, 3.5, 0)
                        for _, y in ipairs({tops, bots}) do
                            for _, s in ipairs({-1.6, 1.6}) do
                                local v, vis = cam:WorldToViewportPoint(y + right * s)
                                if not vis then allVis = false end
                                table.insert(pts, v)
                            end
                        end
                        if allVis then
                            local x1 = math.min(pts[1].X, pts[2].X, pts[3].X, pts[4].X)
                            local x2 = math.max(pts[1].X, pts[2].X, pts[3].X, pts[4].X)
                            local y1 = math.min(pts[1].Y, pts[2].Y, pts[3].Y, pts[4].Y)
                            local y2 = math.max(pts[1].Y, pts[2].Y, pts[3].Y, pts[4].Y)
                            if boxStyle == "Full" then
                                espLine(d, "box", 1, Vector2.new(x1, y1), Vector2.new(x2, y1), bcol, 1)
                                espLine(d, "box", 2, Vector2.new(x2, y1), Vector2.new(x2, y2), bcol, 1)
                                espLine(d, "box", 3, Vector2.new(x2, y2), Vector2.new(x1, y2), bcol, 1)
                                espLine(d, "box", 4, Vector2.new(x1, y2), Vector2.new(x1, y1), bcol, 1)
                                for j = 5, #d.box do d.box[j].Visible = false end
                            else
                                local lx = (x2 - x1) * 0.25
                                local ly = (y2 - y1) * 0.25
                                espLine(d, "box", 1, Vector2.new(x1, y1), Vector2.new(x1 + lx, y1), bcol, 1)
                                espLine(d, "box", 2, Vector2.new(x1, y1), Vector2.new(x1, y1 + ly), bcol, 1)
                                espLine(d, "box", 3, Vector2.new(x2, y1), Vector2.new(x2 - lx, y1), bcol, 1)
                                espLine(d, "box", 4, Vector2.new(x2, y1), Vector2.new(x2, y1 + ly), bcol, 1)
                                espLine(d, "box", 5, Vector2.new(x1, y2), Vector2.new(x1 + lx, y2), bcol, 1)
                                espLine(d, "box", 6, Vector2.new(x1, y2), Vector2.new(x1, y2 - ly), bcol, 1)
                                espLine(d, "box", 7, Vector2.new(x2, y2), Vector2.new(x2 - lx, y2), bcol, 1)
                                espLine(d, "box", 8, Vector2.new(x2, y2), Vector2.new(x2, y2 - ly), bcol, 1)
                            end
                        else
                            for _, l in ipairs(d.box) do l.Visible = false end
                        end
                    else
                        for _, l in ipairs(d.box) do l.Visible = false end
                    end
                end
                if showRole or showNick or showStuds then
                    local head = char:FindFirstChild("Head")
                    if head then
                        local tag = d.tag
                        if not tag or not tag.Parent then
                            local pg = LocalPlayer:FindFirstChild("PlayerGui")
                            tag = Instance.new("BillboardGui")
                            tag.Name = "PULSITITag"
                            tag.Adornee = head
                            tag.Size = UDim2.new(0, 140, 0, 46)
                            tag.StudsOffset = Vector3.new(0, 2.6, 0)
                            tag.AlwaysOnTop = true
                            tag.Parent = pg
                            local rl = Instance.new("TextLabel")
                            rl.Name = "R" rl.Size = UDim2.new(1, 0, 0, 14)
                            rl.BackgroundTransparency = 1 rl.Font = Enum.Font.GothamBold rl.TextSize = 12
                            rl.Parent = tag
                            local nl = Instance.new("TextLabel")
                            nl.Name = "N" nl.Size = UDim2.new(1, 0, 0, 15) nl.Position = UDim2.new(0, 0, 0, 14)
                            nl.BackgroundTransparency = 1 nl.Font = Enum.Font.GothamSemibold nl.TextSize = 13
                            nl.TextColor3 = Color3.fromRGB(255, 255, 255) nl.Parent = tag
                            local sl = Instance.new("TextLabel")
                            sl.Name = "S" sl.Size = UDim2.new(1, 0, 0, 13) sl.Position = UDim2.new(0, 0, 0, 29)
                            sl.BackgroundTransparency = 1 sl.Font = Enum.Font.Gotham sl.TextSize = 11
                            sl.TextColor3 = Color3.fromRGB(200, 200, 200) sl.Parent = tag
                            d.tag = tag
                        end
                        tag.Enabled = true
                        tag.Adornee = head
                        local dist = (root.Position - cam.CFrame.Position).Magnitude
                        tag:FindFirstChild("R").Text = showRole and getPlayerRole(p) or ""
                        tag:FindFirstChild("R").TextColor3 = rc
                        tag:FindFirstChild("N").Text = showNick and p.Name or ""
                        tag:FindFirstChild("S").Text = showStuds and (math.floor(dist) .. " studs") or ""
                    end
                elseif d.tag then d.tag.Enabled = false end
            else
                espHideDraw(d)
            end
        end
    end
end
function ensureAdvESP()
    if ESP_Enabled and not espAdvConn then
        espAdvConn = RunService.RenderStepped:Connect(function() pcall(espAdvTick) end)
    elseif (not ESP_Enabled) and espAdvConn then
        espAdvConn:Disconnect() espAdvConn = nil
        clearEspDraw()
    end
end
function updateGunESP()
    for _, o in pairs(gunEspObjects) do pcall(function() o:Destroy() end) end
    gunEspObjects = {}
    if not gunEspEnabled then return end
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return end
    local gunDrop = workspace:FindFirstChild("GunDrop", true)
    if gunDrop and gunDrop:IsA("BasePart") then
        local box = Instance.new("BoxHandleAdornment")
        box.Adornee = gunDrop box.AlwaysOnTop = true
        box.Color3 = Color3.fromRGB(255,255,255) box.Transparency = 0.5
        box.Size = gunDrop.Size box.ZIndex = 0 box.Parent = pg
        table.insert(gunEspObjects, box)
        local bb = Instance.new("BillboardGui")
        bb.Adornee = gunDrop bb.Size = UDim2.fromOffset(60,20)
        bb.StudsOffset = Vector3.new(0,2.5,0) bb.AlwaysOnTop = true bb.Parent = pg
        local lb = Instance.new("TextLabel")
        lb.Text = "GUN" lb.Font = Enum.Font.GothamBold lb.TextSize = 16
        lb.TextColor3 = Color3.fromRGB(255,255,255) lb.BackgroundTransparency = 1
        lb.Size = UDim2.fromScale(1,1) lb.Parent = bb
        table.insert(gunEspObjects, bb)
    end
end
xrayStrength = 0.5
xraySavedParts = {}
xrayConn = nil
function setXRay(state)
    xrayEnabled = state
    if xrayConn then pcall(function() xrayConn:Disconnect() end) xrayConn = nil end
    if state then
        xraySavedParts = {}
        local function applyPart(d)
            if d:IsA("BasePart") then
                local model = d:FindFirstAncestorOfClass("Model")
                if not (model and Players:GetPlayerFromCharacter(model)) then
                    if d.Transparency < xrayStrength and xraySavedParts[d] == nil then
                        xraySavedParts[d] = d.Transparency
                        d.Transparency = xrayStrength
                    end
                end
            end
        end
        for _, d in ipairs(workspace:GetDescendants()) do applyPart(d) end
        xrayConn = workspace.DescendantAdded:Connect(function(d) if xrayEnabled then applyPart(d) end end)
        notify("X-Ray", "Enabled (infinite)")
    else
        for part, t in pairs(xraySavedParts) do pcall(function() part.Transparency = t end) end
        table.clear(xraySavedParts)
        notify("X-Ray", "Disabled")
    end
end
function StartNoclip()
    if noclipActive then return end noclipActive = true
    if noclipConn then noclipConn:Disconnect() end
    noclipConn = RunService.Stepped:Connect(function()
        if not noclipActive then return end
        local char = LocalPlayer.Character
        if char then for _, c in pairs(char:GetDescendants()) do if c:IsA("BasePart") and c.CanCollide then c.CanCollide = false end end end
    end)
    notify("No Clip", "Enabled")
end
function StopNoclip()
    noclipActive = false
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    local char = LocalPlayer.Character
    if char then for _, c in pairs(char:GetDescendants()) do if c:IsA("BasePart") then pcall(function() c.CanCollide = true end) end end end
    notify("No Clip", "Disabled")
end
function StartInfJump()
    if infJumpActive then return end infJumpActive = true
    if infJumpConn then infJumpConn:Disconnect() end
    infJumpConn = UserInputService.JumpRequest:Connect(function()
        if not infJumpActive or infJumpDebounce then return end
        infJumpDebounce = true
        local char = LocalPlayer.Character
        local hum = char and getHumanoid(char)
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        task.wait(0.05) infJumpDebounce = false
    end)
    notify("Infinite Jumps", "Enabled")
end
function StopInfJump()
    infJumpActive = false
    if infJumpConn then infJumpConn:Disconnect() infJumpConn = nil end
    notify("Infinite Jumps", "Disabled")
end
function StartAntiFling()
    if antiFlingActive then return end antiFlingActive = true
    if antiFlingConn then antiFlingConn:Disconnect() end
    antiFlingConn = RunService.Heartbeat:Connect(function()
        if not antiFlingActive then return end
        local char = LocalPlayer.Character
        local root = char and getRoot(char)
        if root then
            local v = root.AssemblyLinearVelocity
            if v.Magnitude > 250 then
                for _, p in pairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then p.AssemblyLinearVelocity = Vector3.new(0,0,0) p.AssemblyAngularVelocity = Vector3.new(0,0,0) end
                end
            end
        end
    end)
    notify("Anti-Fling", "Enabled")
end
function StopAntiFling()
    antiFlingActive = false
    if antiFlingConn then antiFlingConn:Disconnect() antiFlingConn = nil end
    notify("Anti-Fling", "Disabled")
end
bombDoubleUsed = false
function doBombJump(loud)
    local char = LocalPlayer.Character
    local hum = char and getHumanoid(char)
    if not hum or hum.Health <= 0 then return end
    if hum.FloorMaterial == Enum.Material.Air and not bombDoubleUsed then
        bombDoubleUsed = true
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    elseif hum.FloorMaterial ~= Enum.Material.Air then
        bombDoubleUsed = false
        if loud then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    elseif loud then
        notify("Bomb Jump", "Already used mid-air")
    end
end
function StartBombJump()
    if bombJumpActive then return end bombJumpActive = true
    bombDoubleUsed = false
    if bombJumpConn then pcall(function() bombJumpConn:Disconnect() end) bombJumpConn = nil end
    bombJumpConn = UserInputService.JumpRequest:Connect(function()
        if not bombJumpActive then return end
        local char = LocalPlayer.Character
        local hum = char and getHumanoid(char)
        if not hum or hum.Health <= 0 then return end
        if hum.FloorMaterial == Enum.Material.Air then
            if not bombDoubleUsed then
                bombDoubleUsed = true
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        else
            bombDoubleUsed = false
        end
    end)
    notify("Bomb Jump", "Double jump ON")
end
function StopBombJump()
    bombJumpActive = false bombDoubleUsed = false
    if bombJumpConn then pcall(function() bombJumpConn:Disconnect() end) bombJumpConn = nil end
    notify("Bomb Jump", "Disabled")
end
function StartFly()
    if flyActive then return end
    flyActive = true flying = true
    local char = LocalPlayer.Character
    local hum = char and getHumanoid(char)
    local root = char and getRoot(char)
    if not hum or not root then flyActive = false flying = false return end
    if flyKeyDown then pcall(function() flyKeyDown:Disconnect() end) flyKeyDown = nil end
    if flyKeyUp then pcall(function() flyKeyUp:Disconnect() end) flyKeyUp = nil end
    local CONTROL = {F=0,B=0,L=0,R=0,Q=0,E=0}
    local lCONTROL = {F=0,B=0,L=0,R=0}
    local SPEED = 0
    local bg = Instance.new("BodyGyro") bg.P = 9e4 bg.MaxTorque = Vector3.new(9e9,9e9,9e9) bg.CFrame = root.CFrame bg.Parent = root
    local bv = Instance.new("BodyVelocity") bv.Velocity = Vector3.new() bv.MaxForce = Vector3.new(9e9,9e9,9e9) bv.Parent = root
    task.spawn(function()
        while flying and flyActive and root and root.Parent do
            task.wait()
            if hum and hum.Parent then hum.PlatformStand = true end
            local cam = workspace.CurrentCamera
            if CONTROL.L+CONTROL.R ~= 0 or CONTROL.F+CONTROL.B ~= 0 or CONTROL.Q+CONTROL.E ~= 0 then
                SPEED = flySpeed
            elseif SPEED ~= 0 then SPEED = 0 end
            if (CONTROL.L+CONTROL.R) ~= 0 or (CONTROL.F+CONTROL.B) ~= 0 or (CONTROL.Q+CONTROL.E) ~= 0 then
                bv.Velocity = ((cam.CFrame.LookVector * (CONTROL.F+CONTROL.B)) + ((cam.CFrame * CFrame.new(CONTROL.L+CONTROL.R, (CONTROL.F+CONTROL.B+CONTROL.Q+CONTROL.E)*0.2, 0).p) - cam.CFrame.p)) * SPEED
                lCONTROL = {F=CONTROL.F, B=CONTROL.B, L=CONTROL.L, R=CONTROL.R}
            elseif SPEED ~= 0 then
                bv.Velocity = ((cam.CFrame.LookVector * (lCONTROL.F+lCONTROL.B)) + ((cam.CFrame * CFrame.new(lCONTROL.L+lCONTROL.R, (lCONTROL.F+lCONTROL.B+CONTROL.Q+CONTROL.E)*0.2, 0).p) - cam.CFrame.p)) * SPEED
            else bv.Velocity = Vector3.new() end
            bg.CFrame = cam.CFrame
        end
        pcall(function() bg:Destroy() end) pcall(function() bv:Destroy() end)
        if hum and hum.Parent then hum.PlatformStand = false end
    end)
    flyKeyDown = UserInputService.InputBegan:Connect(function(input, gp)
        if gp or not flyActive then return end
        if input.KeyCode == Enum.KeyCode.W then CONTROL.F = flySpeed
        elseif input.KeyCode == Enum.KeyCode.S then CONTROL.B = -flySpeed
        elseif input.KeyCode == Enum.KeyCode.A then CONTROL.L = -flySpeed
        elseif input.KeyCode == Enum.KeyCode.D then CONTROL.R = flySpeed
        elseif input.KeyCode == Enum.KeyCode.E then CONTROL.Q = flySpeed*2
        elseif input.KeyCode == Enum.KeyCode.Q then CONTROL.E = -flySpeed*2 end
        pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Track end)
    end)
    flyKeyUp = UserInputService.InputEnded:Connect(function(input)
        if not flyActive then return end
        if input.KeyCode == Enum.KeyCode.W then CONTROL.F = 0
        elseif input.KeyCode == Enum.KeyCode.S then CONTROL.B = 0
        elseif input.KeyCode == Enum.KeyCode.A then CONTROL.L = 0
        elseif input.KeyCode == Enum.KeyCode.D then CONTROL.R = 0
        elseif input.KeyCode == Enum.KeyCode.E then CONTROL.Q = 0
        elseif input.KeyCode == Enum.KeyCode.Q then CONTROL.E = 0 end
    end)
    notify("Fly", "Enabled (WASD + Q/E)")
end
function StopFly()
    flyActive = false flying = false
    if flyKeyDown then pcall(function() flyKeyDown:Disconnect() end) flyKeyDown = nil end
    if flyKeyUp then pcall(function() flyKeyUp:Disconnect() end) flyKeyUp = nil end
    local char = LocalPlayer.Character
    local hum = char and getHumanoid(char)
    if hum then hum.PlatformStand = false end
    pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
    notify("Fly", "Disabled")
end
function ApplySpin(speed)
    if spinInstance then pcall(function() spinInstance:Destroy() end) spinInstance = nil end
    if speed == 0 then spinActive = false notify("Spin", "Disabled") return end
    spinActive = true spinSpeed = speed
    local char = LocalPlayer.Character
    local root = char and getRoot(char)
    if not root then return end
    spinInstance = Instance.new("BodyAngularVelocity")
    spinInstance.Name = "Spinning" spinInstance.MaxTorque = Vector3.new(0, math.huge, 0)
    spinInstance.AngularVelocity = Vector3.new(0, speed, 0) spinInstance.Parent = root
    notify("Spin", "Speed: " .. tostring(speed))
end
function StartBhop()
    if bhopActive then return end bhopActive = true
    bhopConn = RunService.RenderStepped:Connect(function()
        if not bhopActive then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = getHumanoid(char) local hrp = getRoot(char)
        if not hum or not hrp then return end
        local jumpPressed = UserInputService:IsKeyDown(Enum.KeyCode.Space)
        if hum.FloorMaterial ~= Enum.Material.Air and jumpPressed then
            if tick() - bhopLastJump > 0.08 then
                bhopLastJump = tick()
                if bhopSound then playBhopSound() end
                local md = hum.MoveDirection
                if md.Magnitude > 0 then
                    local boost = md.Unit * bhopSpeed
                    hrp.Velocity = Vector3.new(boost.X, hum.JumpPower * 1.2, boost.Z)
                else hrp.Velocity = Vector3.new(hrp.Velocity.X, hum.JumpPower * 1.2, hrp.Velocity.Z) end
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
    notify("Bhop", "Enabled")
end
function StopBhop()
    bhopActive = false
    if bhopConn then bhopConn:Disconnect() bhopConn = nil end
    notify("Bhop", "Disabled")
end
function playBhopSound()
    if #PulseSoundFiles > 0 then playCustomSound(PulseSoundFiles[1].path) end
end
function setInvisible(state)
    invisibleActive = state
    local char = LocalPlayer.Character
    local root = char and getRoot(char)
    if not char or not root then return end
    if state then
        invisSavedCF = root.CFrame
        invisSavedFPDH = workspace.FallenPartsDestroyHeight
        pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
        if not invisPlatform or not invisPlatform.Parent then
            invisPlatform = Instance.new("Part")
            invisPlatform.Name = "PULSITIHide"
            invisPlatform.Size = Vector3.new(30, 1, 30)
            invisPlatform.Position = Vector3.new(0, 10000, 0)
            invisPlatform.Anchored = true
            invisPlatform.Transparency = 1
            invisPlatform.CanCollide = true
            invisPlatform.Parent = workspace
        end
        root.CFrame = CFrame.new(0, 10003, 0)
        for _, d in pairs(char:GetDescendants()) do
            if d:IsA("BasePart") and d.Name ~= "HumanoidRootPart" then
                d.Transparency = 0.5
            elseif d:IsA("Decal") then
                d.Transparency = 0.5
            end
        end
        notify("Invisible", "Hidden far away")
    else
        if invisSavedCF then root.CFrame = invisSavedCF invisSavedCF = nil end
        if invisSavedFPDH then workspace.FallenPartsDestroyHeight = invisSavedFPDH invisSavedFPDH = nil end
        if invisPlatform then pcall(function() invisPlatform:Destroy() end) invisPlatform = nil end
        pcall(function()
            for _, d in pairs(char:GetDescendants()) do
                if d:IsA("BasePart") and d.Name ~= "HumanoidRootPart" then
                    d.Transparency = 0
                elseif d:IsA("Decal") then
                    d.Transparency = 0
                end
            end
        end)
        notify("Invisible", "Disabled")
    end
end
function GetMurderer()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local ch = p.Character
            if ch and (ch:FindFirstChild("Knife") or (p:FindFirstChildOfClass("Backpack") and p:FindFirstChildOfClass("Backpack"):FindFirstChild("Knife"))) then return p end
        end
    end
    return nil
end
function GetPredictedPosition(target)
    local ch = target.Character
    local root = ch and ch:FindFirstChild("HumanoidRootPart")
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return nil end
    return root.Position + (root.AssemblyLinearVelocity * Vector3.new(0.75,0.5,0.75)) * (SILENT_OFFSET/15) + (hum.MoveDirection * SILENT_OFFSET)
end
function EquipGun(char)
    if char:FindFirstChild("Gun") then return true end
    local gun = LocalPlayer:FindFirstChildOfClass("Backpack") and LocalPlayer:FindFirstChildOfClass("Backpack"):FindFirstChild("Gun")
    local hum = getHumanoid(char)
    if gun and hum then hum:EquipTool(gun) task.wait(0.1) return true end
    return false
end
function FireGun(gun, origin, targetPos)
    local shoot = gun:FindFirstChild("Shoot") or (gun:FindFirstChild("Events") and gun.Events:FindFirstChild("Shoot"))
    if shoot then pcall(function() shoot:FireServer(CFrame.new(origin), CFrame.new(targetPos)) end) return end
    local kl = gun:FindFirstChild("KnifeLocal")
    local cb = kl and kl:FindFirstChild("CreateBeam")
    if cb then pcall(function() cb:InvokeServer(1, targetPos, "AH2") end) end
end
function AttemptShoot()
    local char = LocalPlayer.Character
    if not char then return end
    local m = GetMurderer()
    if not m or not m.Character then return end
    local troot = m.Character:FindFirstChild("HumanoidRootPart")
    if not troot then return end
    task.spawn(function()
        if not EquipGun(char) then return end
        local gun = char:FindFirstChild("Gun")
        local hand = char:FindFirstChild("RightHand") or char:FindFirstChild("RightArm")
        if not gun or not hand then return end
        FireGun(gun, hand.Position, GetPredictedPosition(m) or troot.Position)
    end)
end
wallbangOn = false
autoShootMurder = false
flingMurderOn = false
autoFlingSheriff = false
aimVersion = "V1 (Pulse)"
resolverOn = false
aimbotType = "Classic"
flickSpeed = 10
flickWithMouse = false
flickReturn = 100
predictionMs = 0
shootMurderKey = Enum.KeyCode.E
fovTransp = 0
fovColorH = 0
soundVolume = 100
killSoundName = "Off"
sheriffFlungName = nil
murderFlingBusy = false
shotCooldown = 0
camLockConn = nil
camLockHeld = false
resolvHist = {}
lastMurderTrack = nil
function aimAlive(target)
    local ch = target and target.Character
    local hum = ch and getHumanoid(ch)
    return (hum and hum.Health > 0) and getRoot(ch) or nil
end
function aimVelocity(target)
    local troot = target.Character and getRoot(target.Character)
    if not troot then return Vector3.new() end
    local raw = troot.AssemblyLinearVelocity or Vector3.new()
    if not resolverOn and aimVersion ~= "V3 (Adaptive)" then return raw end
    local key = target.Name
    resolvHist[key] = resolvHist[key] or {}
    local hist = resolvHist[key]
    table.insert(hist, raw)
    if #hist > 8 then table.remove(hist, 1) end
    local sum = Vector3.new()
    for _, v in ipairs(hist) do sum = sum + v end
    return sum / math.max(1, #hist)
end
function aimPoint(target)
    local troot = aimAlive(target)
    if not troot then return nil end
    local ms = predictionMs
    if aimVersion == "V1 (Pulse)" then
        return troot.Position
    elseif aimVersion == "V3 (Adaptive)" then
        local pingMs = 0
        pcall(function() pingMs = LocalPlayer:GetNetworkPing() * 1000 end)
        ms = math.max(predictionMs, pingMs)
    end
    local vel = aimVelocity(target)
    return troot.Position + Vector3.new(vel.X, vel.Y * 0.5, vel.Z) * (ms / 1000)
end
function aimHasLos(target, pos)
    if wallbangOn then return true end
    local cam = workspace.CurrentCamera
    if not cam then return true end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {LocalPlayer.Character, target.Character}
    params.IgnoreWater = true
    local res = workspace:Raycast(cam.CFrame.Position, (pos - cam.CFrame.Position), params)
    return res == nil
end
function aimInFov(pos)
    local cam = workspace.CurrentCamera
    if not cam then return false end
    local sp, onScreen = cam:WorldToViewportPoint(pos)
    if not onScreen then return false end
    local m = UserInputService:GetMouseLocation()
    return (Vector2.new(sp.X, sp.Y) - m).Magnitude <= aimFov
end
function aimFireAt(pos)
    local char = LocalPlayer.Character
    if not char then return false end
    if not EquipGun(char) then return false end
    local gun = char:FindFirstChild("Gun")
    local hand = char:FindFirstChild("RightHand") or char:FindFirstChild("RightArm")
    if not gun or not hand then return false end
    FireGun(gun, hand.Position, pos)
    return true
end
function aimShootMurder()
    if tick() - shotCooldown < 0.35 then return false end
    local m = GetMurderer()
    if not m then return false end
    local pos = aimPoint(m)
    if not pos then return false end
    if not aimInFov(pos) then return false end
    if not aimHasLos(m, pos) then return false end
    if aimFireAt(pos) then shotCooldown = tick() return true end
    return false
end
function camLockStart()
    if camLockHeld then return end
    camLockHeld = true
    if camLockConn then pcall(function() camLockConn:Disconnect() end) camLockConn = nil end
    local lastShot = 0
    camLockConn = RunService.RenderStepped:Connect(function()
        if not camLockHeld then return end
        local m = GetMurderer()
        local pos = m and aimPoint(m)
        if not pos then return end
        local cam = workspace.CurrentCamera
        if cam then cam.CFrame = CFrame.new(cam.CFrame.Position, pos) end
        if tick() - lastShot >= 0.5 and aimInFov(pos) and aimHasLos(m, pos) then
            if aimFireAt(pos) then lastShot = tick() end
        end
    end)
end
function camLockStop()
    camLockHeld = false
    if camLockConn then pcall(function() camLockConn:Disconnect() end) camLockConn = nil end
end
function aimFlickFire()
    local m = GetMurderer()
    if not m then return end
    local pos = aimPoint(m)
    if not pos or not aimHasLos(m, pos) then return end
    local cam = workspace.CurrentCamera
    if not cam then return end
    local orig = cam.CFrame
    local look = CFrame.new(orig.Position, pos)
    local dur = math.clamp(0.35 - (flickSpeed / 100) * 0.32, 0.03, 0.35)
    if flickWithMouse then
        local steps = 8
        for i = 1, steps do
            cam.CFrame = orig:Lerp(look, i / steps)
            task.wait(dur / steps)
        end
    else
        cam.CFrame = look
    end
    aimFireAt(pos)
    task.wait(0.05)
    if math.random(100) <= flickReturn and cam and cam.Parent then
        if flickWithMouse then
            local back = cam.CFrame
            for i = 1, 6 do
                if not cam.Parent then break end
                cam.CFrame = back:Lerp(orig, i / 6)
                task.wait(dur / 6)
            end
        else
            cam.CFrame = orig
        end
    end
end
function shootKeyPressed()
    if aimbotType == "Universal (Cam Lock)" then camLockStart()
    elseif aimbotType == "Flick Shot" then task.spawn(aimFlickFire)
    else aimShootMurder() end
end
UserInputService.InputBegan:Connect(function(input, gp)
    if gp or PULSITI_UNLOADED then return end
    if shootMurderKey and input.KeyCode == shootMurderKey and silentAimEnabled then
        task.spawn(shootKeyPressed)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if shootMurderKey and input.KeyCode == shootMurderKey then camLockStop() end
end)
task.spawn(function()
    while task.wait(0.25) do
        if PULSITI_UNLOADED then break end
        if autoShootMurder and silentAimEnabled then pcall(aimShootMurder) end
    end
end)
task.spawn(function()
    while task.wait(1) do
        if PULSITI_UNLOADED then break end
        pcall(function()
            if flingMurderOn and not murderFlingBusy then
                local m = GetMurderer()
                if m and aimAlive(m) then
                    murderFlingBusy = true
                    task.spawn(function() pcall(function() FlingSingle(m) end) murderFlingBusy = false end)
                end
            end
            if autoFlingSheriff then
                local sh = nil
                for _, p in ipairs(Players:GetPlayers()) do
                    if getPlayerRole(p) == "Sheriff" and aimAlive(p) then sh = p break end
                end
                if sh then
                    if sheriffFlungName ~= sh.Name and not murderFlingBusy then
                        sheriffFlungName = sh.Name
                        murderFlingBusy = true
                        task.spawn(function() pcall(function() FlingSingle(sh) end) murderFlingBusy = false end)
                    end
                else sheriffFlungName = nil end
            else sheriffFlungName = nil end
        end)
    end
end)
task.spawn(function()
    while task.wait(0.5) do
        if PULSITI_UNLOADED then break end
        pcall(function()
            if killSoundName == nil or killSoundName == "Off" then lastMurderTrack = nil return end
            local m = GetMurderer()
            if m then
                local hum = m.Character and getHumanoid(m.Character)
                if lastMurderTrack == nil then lastMurderTrack = m.Name end
                if hum and hum.Health <= 0 and lastMurderTrack == m.Name then
                    lastMurderTrack = nil
                    playKillSound()
                end
            else lastMurderTrack = nil end
        end)
    end
end)
function getKnife()
    local char = LocalPlayer.Character
    if not char then return nil end
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    local knife = char:FindFirstChild("Knife") or (bp and bp:FindFirstChild("Knife"))
    if knife then knife.Parent = char return knife end
    return nil
end
function killTargetRemote(targetPlayer)
    local char = LocalPlayer.Character
    local tch = targetPlayer and targetPlayer.Character
    if not char or not tch then return end
    local myHrp = getRoot(char) local tHrp = getRoot(tch)
    local tHum = getHumanoid(tch)
    local knife = getKnife()
    if not (myHrp and tHrp and tHum and tHum.Health > 0 and knife) then return end
    local handle = knife:FindFirstChild("Handle") or knife:FindFirstChildWhichIsA("BasePart")
    if not handle then return end
    pcall(function() knife:Activate() end)
    if firetouchinterest then
        pcall(function()
            firetouchinterest(tHrp, handle, 0) task.wait() firetouchinterest(tHrp, handle, 1)
        end)
    else
        local prev = myHrp.CFrame
        pcall(function()
            myHrp.CFrame = tHrp.CFrame * CFrame.new(0,0,1) task.wait(0.03)
            pcall(function() knife:Activate() end)
        end)
        if myHrp and myHrp.Parent then myHrp.CFrame = prev end
    end
end
function KillAll()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and getHumanoid(p.Character) and getHumanoid(p.Character).Health > 0 then
            killTargetRemote(p) task.wait(0.1)
        end
    end
    notify("Murder", "Kill All executed")
end
function KillSheriff()
    for _, p in ipairs(Players:GetPlayers()) do
        if getPlayerRole(p) == "Sheriff" then killTargetRemote(p) notify("Murder", "Sheriff killed: "..p.Name) return end
    end
    notify("Murder", "Sheriff not found")
end
task.spawn(function()
    while task.wait(0.5) do
        if killAuraActive then
            local char = LocalPlayer.Character local root = char and getRoot(char)
            if root then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and getRoot(p.Character) then
                        if (getRoot(p.Character).Position - root.Position).Magnitude <= killAuraRadius then
                            if getHumanoid(p.Character) and getHumanoid(p.Character).Health > 0 then killTargetRemote(p) end
                        end
                    end
                end
            end
        end
        if knifeThrowAimbot then autoKnifeThrow() end
    end
end)
function predictThrowPos(targetPlayer)
    local tch = targetPlayer and targetPlayer.Character
    local troot = tch and getRoot(tch)
    if not troot then return nil end
    local my = LocalPlayer.Character and getRoot(LocalPlayer.Character)
    local dist = my and (troot.Position - my.Position).Magnitude or 50
    local t = math.clamp(dist / 120, 0.05, 1)
    return troot.Position + troot.AssemblyLinearVelocity * t
end
function findThrowRemote(knife)
    if knife then
        for _, d in ipairs(knife:GetDescendants()) do
            if d:IsA("RemoteEvent") and d.Name:lower():find("throw") then return d end
        end
    end
    for _, d in ipairs(game:GetDescendants()) do
        if d:IsA("RemoteEvent") then
            local n = d.Name:lower()
            if n:find("knifethrow") or n == "throwknife" or n == "throw" then return d end
        end
    end
    return nil
end
function KnifeThrow(targetPlayer)
    local char = LocalPlayer.Character
    local myRoot = char and getRoot(char)
    if not myRoot then return end
    local target = targetPlayer
    if not target then
        local best, bd = nil, 1e9
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and getRoot(p.Character) then
                local d = (getRoot(p.Character).Position - myRoot.Position).Magnitude
                if d < bd then bd = d target = p end
            end
        end
    end
    if not target or not target.Character then notify("Knife Throw", "No target") return end
    local aimPos = predictThrowPos(target)
    if not aimPos then return end
    task.spawn(function()
        local knife = getKnife()
        if not knife then notify("Knife Throw", "Need knife") return end
        local remote = findThrowRemote(knife)
        if remote then
            local ok = pcall(function() remote:FireServer(aimPos) end)
            if not ok then pcall(function() remote:FireServer(CFrame.new(myRoot.Position, aimPos)) end) end
            notify("Knife Throw", "Thrown at " .. target.Name)
        else
            local prev = myRoot.CFrame
            myRoot.CFrame = CFrame.new(myRoot.Position, aimPos)
            task.wait(0.05)
            pcall(function() knife:Activate() end)
            task.wait(0.15)
            if myRoot and myRoot.Parent then myRoot.CFrame = prev end
            notify("Knife Throw", "Thrown at " .. target.Name .. " (lead)")
        end
    end)
end
function autoKnifeThrow()
    local char = LocalPlayer.Character
    local myRoot = char and getRoot(char)
    if not myRoot then return end
    if not (char:FindFirstChild("Knife") or (LocalPlayer:FindFirstChildOfClass("Backpack") and LocalPlayer:FindFirstChildOfClass("Backpack"):FindFirstChild("Knife"))) then return end
    local best, bd = nil, 150
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and getRoot(p.Character) then
            local d = (getRoot(p.Character).Position - myRoot.Position).Magnitude
            if d < bd then bd = d best = p end
        end
    end
    if best then KnifeThrow(best) end
end
fovGuiCircle = nil
fovGuiStroke = nil
function renderFov()
    local ok, drawing = pcall(function() return Drawing.new("Circle") end)
    if ok and drawing then
        fovCircle = drawing
        fovCircle.Thickness = 1.5 fovCircle.Filled = false fovCircle.Transparency = 0
        fovCircle.Color = Color3.fromRGB(255, 0, 0)
    else
        pcall(function()
            local par = nil
            if type(gethui) == "function" then pcall(function() par = gethui() end) end
            if type(par) ~= "Instance" then pcall(function() par = game:GetService("CoreGui") end) end
            if type(par) ~= "Instance" then par = LocalPlayer:FindFirstChild("PlayerGui") end
            local g = Instance.new("ScreenGui") g.Name = "PULSE_FOV" g.ResetOnSpawn = false g.IgnoreGuiInset = true g.Parent = par
            fovGuiRoot = g
            local f = Instance.new("Frame") f.Name = "Circle" f.AnchorPoint = Vector2.new(0.5, 0.5)
            f.Size = UDim2.new(0, 240, 0, 240) f.Position = UDim2.new(0.5, 0, 0.5, 0)
            f.BackgroundTransparency = 1 f.Visible = false f.Parent = g
            local cn = Instance.new("UICorner") cn.CornerRadius = UDim.new(1, 0) cn.Parent = f
            local str = Instance.new("UIStroke") str.Thickness = 1.5 str.Color = Color3.fromRGB(255, 0, 0) str.Parent = f
            fovGuiCircle = f fovGuiStroke = str
        end)
    end
    if fovCircle or fovGuiCircle then
        RunService.RenderStepped:Connect(function()
            local col, tr
            pcall(function() col = Color3.fromHSV((fovColorH or 0) / 360, 0.9, 1) end)
            if not col then col = Color3.fromRGB(255, 0, 0) end
            tr = math.clamp((fovTransp or 0) / 100, 0, 1)
            if fovCircle then
                fovCircle.Visible = showFov
                fovCircle.Radius = aimFov
                fovCircle.Position = UserInputService:GetMouseLocation()
                pcall(function() fovCircle.Color = col end)
                pcall(function() fovCircle.Transparency = tr end)
            end
            if fovGuiCircle then
                local m = UserInputService:GetMouseLocation()
                pcall(function()
                    fovGuiCircle.Visible = showFov
                    fovGuiCircle.Size = UDim2.new(0, aimFov * 2, 0, aimFov * 2)
                    fovGuiCircle.Position = UDim2.new(0, m.X, 0, m.Y)
                    if fovGuiStroke then fovGuiStroke.Color = col fovGuiStroke.Transparency = tr end
                end)
            end
        end)
    end
end
pcall(renderFov)
function updateAuraColor()
    auraColorValues.R = math.clamp(auraColorValues.R,0,255)
    auraColorValues.G = math.clamp(auraColorValues.G,0,255)
    auraColorValues.B = math.clamp(auraColorValues.B,0,255)
    if auraActive then
        local was = auraActive auraActive = true
        pcall(function() applyAuraFn() end)
    end
end
function clearAura()
    for _, p in ipairs(auraParticles) do pcall(function() p:Destroy() end) end
    auraParticles = {}
end
function loadAura(name)
    if auraCache[name] then return auraCache[name] end
    local id = aura_ids[name]
    if not id then return nil end
    local ok, res = pcall(game.GetObjects, game, "rbxassetid://"..id)
    if ok and res and res[1] then auraCache[name] = res[1] return res[1] end
    return nil
end
function colorAura(model, color)
    local seq = ColorSequence.new(color)
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("PointLight") then d.Color = color
        elseif d:IsA("ParticleEmitter") or d:IsA("Beam") or d:IsA("Trail") then d.Color = seq end
    end
end
function applyAuraFn()
    clearAura()
    local char = LocalPlayer.Character
    if not char then return end
    local color = Color3.fromRGB(auraColorValues.R, auraColorValues.G, auraColorValues.B)
    for _, name in ipairs(aura_order) do
        if auraSelected[name] then
            local m = loadAura(name)
            if m then
                colorAura(m, color)
                local cl = m:Clone()
                for _, part in ipairs(cl:GetChildren()) do
                    local target = char:FindFirstChild(part.Name)
                    if target and target:IsA("BasePart") then
                        for _, ch in ipairs(part:GetChildren()) do table.insert(auraParticles, ch) ch.Parent = target end
                    end
                end
                cl:Destroy()
            end
        end
    end
end
function setAura(state)
    auraActive = state
    if state then applyAuraFn() notify("Aura", "Enabled") else clearAura() notify("Aura", "Disabled") end
end
function ApplyShader(theme)
    if shaderLoop then shaderLoop:Disconnect() shaderLoop = nil end
    shaderCurrent = theme
    if theme == "Morning" then
        Lighting.ClockTime = 8 Lighting.Brightness = 1.2 Lighting.Ambient = Color3.fromRGB(200,200,200)
        Lighting.OutdoorAmbient = Color3.fromRGB(180,180,180) Lighting.FogEnd = 100000 Lighting.FogColor = Color3.fromRGB(200,210,220)
    elseif theme == "Midday" then
        Lighting.ClockTime = 14 Lighting.Brightness = 1.4 Lighting.Ambient = Color3.fromRGB(160,160,160)
        Lighting.OutdoorAmbient = Color3.fromRGB(150,150,150) Lighting.FogEnd = 100000
    elseif theme == "Evening" then
        Lighting.ClockTime = 18 Lighting.Brightness = 0.8 Lighting.Ambient = Color3.fromRGB(255,180,100)
        Lighting.OutdoorAmbient = Color3.fromRGB(255,150,80) Lighting.FogEnd = 3000 Lighting.FogColor = Color3.fromRGB(255,180,120)
    elseif theme == "Night" then
        Lighting.ClockTime = 0 Lighting.Brightness = 0.2 Lighting.Ambient = Color3.fromRGB(20,20,50)
        Lighting.OutdoorAmbient = Color3.fromRGB(15,15,45) Lighting.FogEnd = 800 Lighting.FogColor = Color3.fromRGB(10,10,30)
    elseif theme == "Spirit Realm" then
        Lighting.ClockTime = 20 Lighting.Brightness = 0.6 Lighting.Ambient = Color3.fromRGB(150,80,255)
        Lighting.OutdoorAmbient = Color3.fromRGB(120,60,220) Lighting.FogColor = Color3.fromRGB(90,40,160) Lighting.FogEnd = 1500
    elseif theme == "Storm" then
        Lighting.ClockTime = 16 Lighting.Brightness = 0.4 Lighting.Ambient = Color3.fromRGB(80,80,90)
        Lighting.OutdoorAmbient = Color3.fromRGB(70,70,80) Lighting.FogColor = Color3.fromRGB(60,60,70) Lighting.FogEnd = 1200
    else
        Lighting.ClockTime = 14 Lighting.Brightness = 1 Lighting.Ambient = Color3.fromRGB(127,127,127)
        Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127) Lighting.FogEnd = 100000
    end
    if theme == "Evening" or theme == "Night" then
        shaderLoop = RunService.Heartbeat:Connect(function()
            if shaderCurrent == "Evening" and Lighting.ClockTime ~= 18 then Lighting.ClockTime = 18 end
            if shaderCurrent == "Night" and Lighting.ClockTime ~= 0 then Lighting.ClockTime = 0 end
        end)
    end
    notify("Shader", theme)
end
function EnableFPSBoost()
    if fpsBoostEnabled then return end fpsBoostEnabled = true
    local t = workspace:FindFirstChildWhichIsA("Terrain")
    if t then t.WaterWaveSize = 0 t.WaterWaveSpeed = 0 t.WaterReflectance = 0 t.WaterTransparency = 1 end
    Lighting.GlobalShadows = false Lighting.FogEnd = 9e9
    pcall(function() settings().Rendering.QualityLevel = 1 end)
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("BasePart") then v.CastShadow = false
        elseif v:IsA("Decal") then v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Lifetime = NumberRange.new(0) end
    end
    notify("FPS Boost", "Enabled")
end
function DisableFPSBoost()
    if not fpsBoostEnabled then return end fpsBoostEnabled = false
    Lighting.GlobalShadows = true Lighting.FogEnd = 100000
    pcall(function() settings().Rendering.QualityLevel = 10 end)
    notify("FPS Boost", "Disabled")
end
function setClearAtmo(state)
    clearAtmoActive = state
    if state then
        Lighting.FogEnd = 9e9 Lighting.FogStart = 9e9
        for _, v in pairs(Lighting:GetChildren()) do if v:IsA("Atmosphere") or v.Name:lower():find("cloud") then v:Destroy() end end
        notify("Atmosphere", "Cleared")
    else Lighting.FogEnd = 100000 Lighting.FogStart = 0 notify("Atmosphere", "Restored") end
end
function setSky(name, state)
    if state then
        skyCurrent = name
        if name == "Anime Sky" then Lighting.Ambient = Color3.fromRGB(180,220,255) Lighting.OutdoorAmbient = Color3.fromRGB(160,210,255)
        elseif name == "Pink Sky" then Lighting.Ambient = Color3.fromRGB(255,170,220) Lighting.OutdoorAmbient = Color3.fromRGB(255,150,200) Lighting.FogColor = Color3.fromRGB(255,190,230)
        elseif name == "Heavenly Clouds" then Lighting.Ambient = Color3.fromRGB(230,240,255) Lighting.Brightness = 1.5
        elseif name == "Realistic Sky" then Lighting.Ambient = Color3.fromRGB(150,170,200) Lighting.Brightness = 1.1
        elseif name == "Rain Sky" then Lighting.Ambient = Color3.fromRGB(90,100,115) Lighting.Brightness = 0.7 Lighting.FogColor = Color3.fromRGB(100,110,125) end
        notify("Sky", name)
    else if skyCurrent == name then skyCurrent = "None" ApplyShader("None") end end
end
function TeleportToPlayer(tp)
    if not tp or tp == LocalPlayer or not tp.Character then return end
    local root = getRoot(tp.Character) local my = LocalPlayer.Character and getRoot(LocalPlayer.Character)
    if root and my then my.CFrame = root.CFrame * CFrame.new(0,2,0) notify("Teleport", tp.Name) end
end
function GetRolePlayers(role)
    local res = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local r = getPlayerRole(p):lower()
            if (role == "murderer" and r == "murderer") or (role == "sheriff" and r == "sheriff") then table.insert(res, p) end
        end
    end
    return res
end
function TpLobby()
    local my = LocalPlayer.Character and getRoot(LocalPlayer.Character)
    local spawn = workspace:FindFirstChild("LobbySpawn") or workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChildWhichIsA("SpawnLocation")
    if spawn and my then my.CFrame = spawn.CFrame + Vector3.new(0,5,0)
    elseif my then my.CFrame = CFrame.new(0,20,0) end
    notify("Teleport", "Lobby")
end
function StealthGrabGun()
    local char = LocalPlayer.Character
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    if (char and char:FindFirstChild("Gun")) or (bp and bp:FindFirstChild("Gun")) then return end
    local gunDrop = workspace:FindFirstChild("GunDrop", true)
    if gunDrop and gunDrop:IsA("BasePart") then
        local root = char and getRoot(char)
        if not root then return end
        if firetouchinterest then
            pcall(function()
                firetouchinterest(root, gunDrop, 0) task.wait(0.05) firetouchinterest(root, gunDrop, 1)
            end)
        else
            local o = root.CFrame root.CFrame = gunDrop.CFrame task.wait(0.05)
            if root and root.Parent then root.CFrame = o end
        end
    end
end
task.spawn(function()
    while task.wait(0.25) do if autoGunEnabled then pcall(StealthGrabGun) end end
end)
function SkidFling(targetPlayer)
    local char = LocalPlayer.Character
    local hum = char and getHumanoid(char)
    local root = hum and hum.RootPart
    local tch = targetPlayer and targetPlayer.Character
    if not (char and hum and root and tch) then return end
    local tHum = getHumanoid(tch)
    local tRoot = tHum and tHum.RootPart
    local tHead = tch:FindFirstChild("Head")
    if not (tRoot or tHead) then return end
    if tHum and tHum.Sit then return end
    local oldPos = root.CFrame
    local savedFPDH = workspace.FallenPartsDestroyHeight
    workspace.FallenPartsDestroyHeight = 0/0
    local bv = Instance.new("BodyVelocity") bv.MaxForce = Vector3.new(9e9,9e9,9e9) bv.Velocity = Vector3.new() bv.Parent = root
    hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    local base = tRoot or tHead
    local t0 = tick()
    local ang = 0
    while tick() - t0 < 2 and FlingActive ~= false do
        ang = ang + 100
        root.CFrame = CFrame.new(base.Position) * CFrame.new(0,1.5,0) * CFrame.Angles(math.rad(ang),0,0)
        char:SetPrimaryPartCFrame(CFrame.new(base.Position) * CFrame.new(0,1.5,0) * CFrame.Angles(math.rad(ang),0,0))
        root.Velocity = Vector3.new(9e7, 9e8, 9e7) root.RotVelocity = Vector3.new(9e8,9e8,9e8)
        task.wait()
        if not FlingActive and FlingActive ~= nil then break end
        if targSingleOnly then break end
    end
    bv:Destroy()
    hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    local ok = true
    for _ = 1, 10 do
        root.CFrame = oldPos * CFrame.new(0,0.5,0)
        char:SetPrimaryPartCFrame(oldPos * CFrame.new(0,0.5,0))
        hum:ChangeState("GettingUp")
        for _, p in pairs(char:GetChildren()) do if p:IsA("BasePart") then p.Velocity, p.RotVelocity = Vector3.new(), Vector3.new() end end
        task.wait()
        if (root.Position - oldPos.p).Magnitude < 25 then break end
    end
    workspace.FallenPartsDestroyHeight = savedFPDH
end
function FlingSingle(targetPlayer)
    targSingleOnly = true
    local was = FlingActive FlingActive = true
    SkidFling(targetPlayer)
    FlingActive = was targSingleOnly = false
end
RunService.Heartbeat:Connect(function()
    if touchFlingActive then
        local char = LocalPlayer.Character local root = char and getRoot(char)
        if root then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and getRoot(p.Character) then
                    local tr = getRoot(p.Character)
                    if (tr.Position - root.Position).Magnitude < 6 then
                        tr.AssemblyLinearVelocity = Vector3.new(math.random(-9000,9000), 9000, math.random(-9000,9000))
                    end
                end
            end
        end
    end
end)
mouse = LocalPlayer:GetMouse()
mouse.Button1Down:Connect(function()
    if not clickFlingActive then return end
    local target = mouse.Target
    if target then
        local model = target:FindFirstAncestorOfClass("Model")
        local plr = model and Players:GetPlayerFromCharacter(model)
        if plr and plr ~= LocalPlayer and getRoot(plr.Character) then
            getRoot(plr.Character).AssemblyLinearVelocity = Vector3.new(0, 9000, 0)
            notify("Click Fling", plr.Name)
        end
    end
end)
function StartJerk()
    if jerkActive then return end
    local char = LocalPlayer.Character local hum = char and getHumanoid(char)
    if not char or not hum then notify("Jerk Off", "Character not found") return end
    jerkActive = true
    local isR15 = hum.RigType == Enum.HumanoidRigType.R15
    task.spawn(function()
        local ok = pcall(function()
            if isR15 then
                loadstring(game:HttpGet("https://pastefy.app/YZoglOyJ/raw"))()
            else
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Sakupenny/Universal-Jerk-Off/refs/heads/main/Main.lua"))()
            end
        end)
        if not ok then jerkActive = false notify("Jerk Off", "Load failed") end
    end)
    notify("Jerk Off", isR15 and "R15 mode loading..." or "R6 mode loading...")
end
function StopJerk()
    jerkActive = false jerkJorking = false
    if jerkTrack then pcall(function() jerkTrack:Stop() end) jerkTrack = nil end
    if jerkTool then pcall(function() jerkTool:Destroy() end) jerkTool = nil end
    pcall(function()
        local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
        local char = LocalPlayer.Character
        for _, cont in ipairs({bp, char}) do
            if cont then
                for _, t in ipairs(cont:GetChildren()) do
                    if t:IsA("Tool") and string.find(string.lower(t.Name), "jerk") then t:Destroy() end
                end
            end
        end
        local rs = game:GetService("ReplicatedStorage")
        local tpl = rs and rs:FindFirstChild("Jerk Off")
        if tpl then tpl:Destroy() end
    end)
    pcall(function() if getgenv then getgenv().JerkOffExecuted = false end end)
    pcall(function()
        local hum = LocalPlayer.Character and getHumanoid(LocalPlayer.Character)
        if hum then
            if walkSpeedEnabled then applyWalkSpeed() else hum.WalkSpeed = 16 end
            hum.JumpPower = 50
        end
    end)
    notify("Jerk Off", "Disabled")
end
function StartBang(targetName)
    if bangActive then StopBang() task.wait(0.1) end
    local target
    for _, p in ipairs(Players:GetPlayers()) do if p.Name:lower():find(targetName:lower()) then target = p break end end
    if not target or not target.Character then notify("GBang", "Player not found") return end
    local char = LocalPlayer.Character
    if not char then return end
    bangActive = true bangTarget = target
    local hum = getHumanoid(char)
    local anim = Instance.new("Animation") anim.AnimationId = "rbxassetid://591745936"
    bangTrack = hum and hum:LoadAnimation(anim)
    if bangTrack then bangTrack.Looped = true bangTrack:Play() end
    bangConns = {}
    table.insert(bangConns, RunService.Heartbeat:Connect(function()
        if not bangActive or not bangTarget or not bangTarget.Character then return end
        local tr = getRoot(bangTarget.Character) local my = getRoot(char)
        if tr and my then my.CFrame = tr.CFrame * CFrame.new(0, 0, 1.2) end
    end))
    if humpDuration > 0 then
        task.delay(humpDuration, function() if bangActive then StopBang() end end)
    end
    notify("GBang", "On " .. target.Name)
end
function StopBang()
    bangActive = false bangTarget = nil
    if bangTrack then pcall(function() bangTrack:Stop() end) bangTrack = nil end
    for _, c in pairs(bangConns) do pcall(function() c:Disconnect() end) end
    bangConns = {}
end
orbitConn = nil
function setOrbit(state)
    orbitActive = state
    if orbitConn then orbitConn:Disconnect() orbitConn = nil end
    if not state then notify("Orbit", "Disabled") return end
    local ang = 0
    orbitConn = RunService.Heartbeat:Connect(function()
        if not orbitActive then return end
        local char = LocalPlayer.Character local my = char and getRoot(char)
        if not my then return end
        local best, bd = nil, 1e9
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and getRoot(p.Character) then
                local d = (getRoot(p.Character).Position - my.Position).Magnitude
                if d < bd then bd = d best = p end
            end
        end
        if best and getRoot(best.Character) then
            ang = ang + math.rad(orbitSpeed)
            my.CFrame = getRoot(best.Character).CFrame * CFrame.new(math.cos(ang)*6, 2, math.sin(ang)*6)
        end
    end)
    notify("Orbit", "Enabled")
end
EMOTES = {zen = "rbxassetid://591745936", dance1 = "rbxassetid://591745936", dance2 = "rbxassetid://591745883", wave = "rbxassetid://591745523", laugh = "rbxassetid://591745640"}
function playEmote(name)
    local char = LocalPlayer.Character local hum = char and getHumanoid(char)
    if not hum then return end
    local id = EMOTES[name] or EMOTES.dance1
    if emoteTrack then pcall(function() emoteTrack:Stop() end) end
    local a = Instance.new("Animation") a.AnimationId = id
    emoteTrack = hum:LoadAnimation(a) emoteTrack.Looped = autoEmoteActive emoteTrack:Play()
    notify("Emote", name)
end
function equipToy(name)
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    local char = LocalPlayer.Character local hum = char and getHumanoid(char)
    local tool = bp and bp:FindFirstChild(name)
    if tool and hum then hum:EquipTool(tool) notify("Toy", "Equipped " .. name) else notify("Toy", "Not found") end
end
function unequipTools()
    local char = LocalPlayer.Character local hum = char and getHumanoid(char)
    if hum then hum:UnequipTools() end
end
function giveFake(name)
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    if not bp then return end
    local t = Instance.new("Tool") t.Name = name t.RequiresHandle = false t.Parent = bp
    notify("Fake Items", name .. " (client-side)")
end
ANIM_PACKS = {
    ["OLDSCHOOL ANIMATION PACK"] = {"rbxassetid://591745936","rbxassetid://591745883"},
    ["STYLISH ANIMATION PACK"] = {"rbxassetid://591745523","rbxassetid://591745640"},
    ["TOY ANIMATION PACK"] = {"rbxassetid://591745936"},
}
animTrack = nil
function playPack(name)
    local char = LocalPlayer.Character local hum = char and getHumanoid(char)
    if not hum then return end
    local list = ANIM_PACKS[name]
    if not list then notify("Anims", "No IDs for " .. name) return end
    if animTrack then pcall(function() animTrack:Stop() end) end
    local a = Instance.new("Animation") a.AnimationId = list[1]
    animTrack = hum:LoadAnimation(a) animTrack.Looped = true animTrack:Play()
    notify("Anims", name)
end
function GetCoinContainer()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v.Name == "CoinContainer" and (v:IsA("Folder") or v:IsA("Model")) then return v end
    end
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name == "Base" and v.Parent and v.Parent:IsA("Model") then
            local c = v.Parent:FindFirstChild("CoinContainer")
            if c then return c end
            return v.Parent
        end
    end
    return nil
end
function FindAllCoins()
    local res = {}
    local scope = CoinContainer
    if not scope or not scope.Parent then
        if tick() - (lastFullScan or 0) < 3 then return coinCache or {} end
        lastFullScan = tick()
        scope = workspace
    end
    for _, d in ipairs(scope:GetDescendants()) do
        if d:IsA("TouchTransmitter") then
            local coin = d.Parent
            if coin and coin:IsA("BasePart") and not TouchedCoins[coin] and (coinFails[coin] or 0) < 3 then
                local model = coin:FindFirstAncestorOfClass("Model")
                if not (model and Players:GetPlayerFromCharacter(model)) then
                    table.insert(res, coin)
                end
            end
        end
    end
    if scope == workspace then coinCache = res end
    return res
end
function IsCoinBagFull()
    local cap = 40
    pcall(function() if LocalPlayer:GetAttribute("Elite") then cap = 50 end end)
    local done, full = pcall(function()
        local pg = LocalPlayer.PlayerGui
        local mg = pg:FindFirstChild("MainGUI")
        if mg then
            local icon = mg:FindFirstChild("FullBagIcon", true)
            if icon and icon:IsA("GuiObject") and icon.Visible then return true end
            local coins = mg:FindFirstChild("Coins", true)
            if coins and coins:IsA("TextLabel") then
                local n = tonumber(string.match(coins.Text:gsub(",", ""), "%d+"))
                if n and n >= cap then return true end
            end
            return false
        end
        local gui = pg:FindFirstChild("CoinBags")
        if gui then
            local coins = gui:FindFirstChild("Coins", true)
            if coins and coins:IsA("TextLabel") then
                local n = tonumber(string.match(coins.Text:gsub(",", ""), "%d+"))
                if n and n >= cap then return true end
            end
        end
        return false
    end)
    if done then return full end
    return false
end
function CollectCoins()
    local prone = farmVersion:find("V2") ~= nil
    local repath = prone and 0.05 or 0.12
    while Farm_Enabled do
        if IsCoinBagFull() then
            if killAllFullBag and getPlayerRole(LocalPlayer) == "Murderer" then
                farmStatus = "Killing all"
                KillAll()
                task.wait(3)
                CoinContainer = GetCoinContainer() table.clear(TouchedCoins)
            elseif autoRespawnBag then
                local hum = LocalPlayer.Character and getHumanoid(LocalPlayer.Character)
                if hum then hum.Health = 0 end
                task.wait(4)
                CoinContainer = GetCoinContainer() table.clear(TouchedCoins)
            else farmStatus = "Bag full" task.wait(2) end
        end
        if not CoinContainer or not CoinContainer.Parent then CoinContainer = GetCoinContainer() table.clear(TouchedCoins) end
        if not CoinContainer then farmStatus = "No coins" task.wait(2) else
            farmStatus = "Farming"
            local coins = FindAllCoins()
            if #coins == 0 then farmStatus = "No coins" task.wait(1) else
                local char = LocalPlayer.Character local root = char and getRoot(char)
                local hum = char and getHumanoid(char)
                if root and hum then
                    local mRoot = nil
                    if avoidMurder then
                        local m = GetMurderer()
                        mRoot = m and m.Character and getRoot(m.Character) or nil
                        if mRoot and (mRoot.Position - root.Position).Magnitude < 20 then
                            hum:MoveTo(root.Position + (root.Position - mRoot.Position).Unit * 15)
                            task.wait(0.3)
                        end
                    end
                    local best, bd = nil, 1e9
                    for _, c in ipairs(coins) do
                        if c.Parent then
                            local d = (c.Position - root.Position).Magnitude
                            local dy = c.Position.Y - root.Position.Y
                            local nearM = avoidMurder and mRoot and (c.Position - mRoot.Position).Magnitude < 30
                            if dy > -35 and (not nearM) and d < bd then bd = d best = c end
                        end
                    end
                    if best then
                        hum:MoveTo(best.Position)
                        local t0 = tick()
                        while Farm_Enabled and best.Parent and (best.Position - root.Position).Magnitude > 3 and tick() - t0 < 8 do
                            hum:MoveTo(best.Position)
                            task.wait(repath)
                        end
                        task.wait(0.25)
                        if not best.Parent then
                            TouchedCoins[best] = true
                            coinFails[best] = nil
                            farmSession = farmSession + 1 farmTotal = farmTotal + 1
                        else
                            coinFails[best] = (coinFails[best] or 0) + 1
                        end
                    end
                else task.wait(0.5) end
            end
        end
        farmCycles = farmCycles + 1
        if farmCycles % 60 == 0 then table.clear(TouchedCoins) table.clear(coinFails) end
        task.wait(0.1)
    end
    IsFarming = false farmStatus = "Waiting"
end
function StartFarm()
    if IsFarming then return end
    CoinContainer = GetCoinContainer()
    if not CoinContainer then notify("Farm", "CoinContainer not found") return end
    IsFarming = true Farm_Enabled = true table.clear(TouchedCoins) IsResetting = false
    local hum = LocalPlayer.Character and getHumanoid(LocalPlayer.Character)
    if hum then
        hum.WalkSpeed = math.clamp(farmSpeed, 5, 40)
        if farmVersion:find("V2") then
            hum.HipHeight = -1.7
        else
            hum.HipHeight = 0
        end
    end
    if farmSpeed >= 23 then notify("Farm", "23+ kicks! 21 is safe", 4) end
    FarmThread = coroutine.create(CollectCoins) coroutine.resume(FarmThread)
    notify("Farm", farmVersion .. " started")
end
function restoreCharacter()
    local char = LocalPlayer and LocalPlayer.Character
    local hum = char and getHumanoid(char)
    local root = char and getRoot(char)
    if hum then
        pcall(function() hum:Move(Vector3.new()) end)
        pcall(function() hum.PlatformStand = false end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true) end)
        pcall(function() hum.HipHeight = 0 end)
        pcall(function()
            if walkSpeedEnabled then applyWalkSpeed() else hum.WalkSpeed = 16 end
        end)
        pcall(function() hum.JumpPower = 50 end)
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
    end
    if char and root then
        for _, d in pairs(char:GetDescendants()) do
            if d:IsA("BasePart") then
                pcall(function() d.CanCollide = true end)
                pcall(function() d.Velocity = Vector3.new() end)
                pcall(function() d.RotVelocity = Vector3.new() end)
                pcall(function() d.AssemblyLinearVelocity = Vector3.new() end)
                pcall(function() d.AssemblyAngularVelocity = Vector3.new() end)
                if d.Name ~= "HumanoidRootPart" then
                    pcall(function() d.Transparency = 0 end)
                end
            end
        end
    end
    pcall(function()
        local fpdh = workspace.FallenPartsDestroyHeight
        if fpdh ~= fpdh or fpdh < -100000 or fpdh > 100000 then
            workspace.FallenPartsDestroyHeight = -500
        end
    end)
end
function StopFarm()
    Farm_Enabled = false IsFarming = false
    if FarmThread then pcall(coroutine.close, FarmThread) FarmThread = nil end
    restoreCharacter()
    table.clear(TouchedCoins) farmStatus = "Waiting"
    notify("Farm", "Stopped")
end
RunService.Heartbeat:Connect(function(dt)
    gunEspTimer = gunEspTimer + dt
    if gunEspTimer >= 0.3 then gunEspTimer = 0 pcall(updateGunESP) end
end)
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == flyBind and flyActive == false and _flyArmed then StartFly() end
    if noclipBind and input.KeyCode == noclipBind and noclipTgl then noclipTgl.Set(not noclipTgl.Get()) end
    if bhopBind and input.KeyCode == bhopBind and bhopTgl then bhopTgl.Set(not bhopTgl.Get()) end
    if spinBind and input.KeyCode == spinBind and spinTgl then spinTgl.Set(not spinTgl.Get()) end
    if invisBind and input.KeyCode == invisBind and invisTgl then invisTgl.Set(not invisTgl.Get()) end
    if bombJumpKey and input.KeyCode == bombJumpKey then doBombJump(true) end
    if input.KeyCode == menuBindKey then
        if MainFrameRef then MainFrameRef.Visible = not MainFrameRef.Visible end
    end
end)
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if jerkActive then StopJerk() end
    StopBang()
    if flyActive then StopFly() end
    if auraActive then applyAuraFn() end
    if spinActive then ApplySpin(spinSpeed) end
    if walkSpeedEnabled then applyWalkSpeed() end
    if autoFlingRespawn and Farm_Enabled then
        task.spawn(function()
            task.wait(2.5)
            local m = GetMurderer()
            if m and Farm_Enabled then FlingSingle(m) end
        end)
    end
    if Farm_Enabled then task.wait(1) StartFarm() end
    if invisibleActive then
        task.spawn(function()
            task.wait(1)
            if invisibleActive and LocalPlayer.Character then
                invisibleActive = false
                setInvisible(true)
            end
        end)
    end
end)
do
    if type(makefolder) == "function" and type(isfolder) == "function" then
        pcall(function()
            if not isfolder("PULSITI") then makefolder("PULSITI") end
            if not isfolder("PULSITI/config") then makefolder("PULSITI/config") end
            if not isfolder("PULSITI/backgrounds") then makefolder("PULSITI/backgrounds") end
            if not isfolder("PULSITI/custom sounds") then makefolder("PULSITI/custom sounds") end
            if not isfolder("PULSITI/settings") then makefolder("PULSITI/settings") end
        end)
    end
end
PulseBGFiles = {}
PulseSoundFiles = {}
do
    if type(listfiles) == "function" then
        local ok, files = pcall(listfiles, "PULSITI/backgrounds")
        if ok and type(files) == "table" then
            for _, f in ipairs(files) do
                local n = string.lower(tostring(f))
                if n:match("%.png$") or n:match("%.jpg$") or n:match("%.jpeg$") then
                    if n:find("logo") then PulseLogoFile = tostring(f)
                    else table.insert(PulseBGFiles, tostring(f)) end
                end
            end
        end
        local ok2, files2 = pcall(listfiles, "PULSITI/custom sounds")
        if ok2 and type(files2) == "table" then
            for _, f in ipairs(files2) do
                local n = string.lower(tostring(f))
                if n:match("%.mp3$") or n:match("%.ogg$") or n:match("%.wav$") then
                    local short = tostring(f):match("([^\\/]+)$") or tostring(f)
                    table.insert(PulseSoundFiles, {name = short, path = tostring(f)})
                end
            end
        end
    end
    if BG_ASSET == "rbxassetid://0" and #PulseBGFiles > 0 and type(getcustomasset) == "function" then
        local ok, asset = pcall(getcustomasset, PulseBGFiles[1])
        if ok and asset then BG_ASSET = asset end
    end
    if LOGO_ASSET == "rbxassetid://0" and PulseLogoFile and type(getcustomasset) == "function" then
        local ok, asset = pcall(getcustomasset, PulseLogoFile)
        if ok and asset then LOGO_ASSET = asset end
    end
end
PulseGithubShots = {}
PulseGithubKills = {}
function fetchGithubSounds()
    if GITHUB_SOUNDS_BASE == nil or tostring(GITHUB_SOUNDS_BASE) == "" then return end
    if type(writefile) ~= "function" or type(isfile) ~= "function" then return end
    pcall(function() if type(makefolder) == "function" and type(isfolder) == "function" and not isfolder("PULSITI/sounds") then makefolder("PULSITI/sounds") end end)
    local reqFn = (request or http_request or (syn and syn.request) or (http and http.request))
    local base = tostring(GITHUB_SOUNDS_BASE)
    if string.sub(base, -1) == "/" then base = string.sub(base, 1, -2) end
    local ok, manifest = pcall(function()
        local body
        if reqFn then
            local r = reqFn({Url = base .. "/sounds.json", Method = "GET"})
            body = r.Body or r.body
        else
            body = game:HttpGet(base .. "/sounds.json")
        end
        return HttpService:JSONDecode(body)
    end)
    if not ok or type(manifest) ~= "table" then return end
    local function pull(list, store)
        if type(list) ~= "table" then return end
        for _, e in ipairs(list) do
            if type(e) == "table" and e.name and e.url then
                local safe = string.gsub(tostring(e.name), "[^%w%-%_ ]", "")
                local path = "PULSITI/sounds/" .. safe .. ".mp3"
                local have = false
                pcall(function() have = isfile(path) end)
                if not have then
                    pcall(function()
                        local data
                        if reqFn then
                            local r = reqFn({Url = tostring(e.url), Method = "GET"})
                            data = r.Body or r.body
                        else
                            data = game:HttpGet(tostring(e.url))
                        end
                        if data and #tostring(data) > 1000 then writefile(path, data) end
                    end)
                end
                local done = false
                pcall(function() done = isfile(path) end)
                if done then table.insert(store, {name = safe, path = path}) end
            end
        end
    end
    pull(manifest.shots, PulseGithubShots)
    pull(manifest.kills, PulseGithubKills)
    if type(manifest.backgrounds) == "table" then
        for _, e in ipairs(manifest.backgrounds) do
            if type(e) == "table" and e.name and e.url then
                local safe = string.gsub(tostring(e.name), "[^%w%-%_ ]", "")
                local path = "PULSITI/backgrounds/" .. safe .. ".png"
                local have = false
                pcall(function() have = isfile(path) end)
                if not have then
                    pcall(function()
                        local data
                        if reqFn then
                            local r = reqFn({Url = tostring(e.url), Method = "GET"})
                            data = r.Body or r.body
                        else
                            data = game:HttpGet(tostring(e.url))
                        end
                        if data and #tostring(data) > 1000 then writefile(path, data) end
                    end)
                end
            end
        end
    end
end
pcall(fetchGithubSounds)
function buildSoundLists()
    local shots, kills = {"Off"}, {"Off"}
    local seenS, seenK = {Off = true}, {Off = true}
    for _, f in ipairs(PulseGithubShots) do
        if not seenS[f.name] then table.insert(shots, f.name) seenS[f.name] = true end
    end
    for _, f in ipairs(PulseGithubKills) do
        if not seenK[f.name] then table.insert(kills, f.name) seenK[f.name] = true end
    end
    for _, f in ipairs(PulseSoundFiles) do
        if not seenS[f.name] then table.insert(shots, f.name) seenS[f.name] = true end
        if not seenK[f.name] then table.insert(kills, f.name) seenK[f.name] = true end
    end
    return shots, kills
end
function findSoundPath(listGithub, name)
    for _, f in ipairs(listGithub) do if f.name == name then return f.path end end
    for _, f in ipairs(PulseSoundFiles) do if f.name == name then return f.path end end
    return nil
end
function loadPulseConfig()
    if type(readfile) ~= "function" or type(isfile) ~= "function" then return end
    local ok, data = pcall(function()
        if not isfile("PULSITI/config/settings.json") then return nil end
        return HttpService:JSONDecode(readfile("PULSITI/config/settings.json"))
    end)
    if ok and type(data) == "table" then
        if tonumber(data.aimFov) then aimFov = math.clamp(tonumber(data.aimFov), 20, 400) end
        if tonumber(data.walkSpeed) then walkSpeedValue = math.clamp(tonumber(data.walkSpeed), 8, 100) end
    end
    local ok2, farm = pcall(function()
        if not isfile("PULSITI/settings/autofarm.json") then return nil end
        return HttpService:JSONDecode(readfile("PULSITI/settings/autofarm.json"))
    end)
    if ok2 and type(farm) == "table" then
        if tonumber(farm.farmSpeed) then farmSpeed = math.clamp(tonumber(farm.farmSpeed), 5, 40) end
        if type(farm.farmVersion) == "string" then farmVersion = farm.farmVersion end
        if farm.autoRespawn ~= nil then autoRespawnBag = (farm.autoRespawn == true) end
        if tonumber(farm.totalCoins) then farmTotal = tonumber(farm.totalCoins) end
        if farm.avoidMurder ~= nil then avoidMurder = (farm.avoidMurder == true) end
        if farm.autoFlingRespawn ~= nil then autoFlingRespawn = (farm.autoFlingRespawn == true) end
        if farm.killAllFullBag ~= nil then killAllFullBag = (farm.killAllFullBag == true) end
    end
end
function savePulseConfig()
    if type(writefile) ~= "function" then return end
    pcall(function()
        writefile("PULSITI/config/settings.json", HttpService:JSONEncode({
            aimFov = aimFov, walkSpeed = walkSpeedValue,
        }))
        writefile("PULSITI/settings/autofarm.json", HttpService:JSONEncode({
            farmSpeed = farmSpeed, farmVersion = farmVersion, autoRespawn = autoRespawnBag,
            totalCoins = farmTotal, avoidMurder = avoidMurder,
            autoFlingRespawn = autoFlingRespawn, killAllFullBag = killAllFullBag,
        }))
    end)
end
function resetPulseConfig()
    farmSpeed = 21 farmVersion = "V2 (fast, prone)" aimFov = 120
    walkSpeedValue = 16 autoRespawnBag = true
    if type(delfile) == "function" then
        pcall(function() delfile("PULSITI/config/settings.json") end)
        pcall(function() delfile("PULSITI/settings/autofarm.json") end)
    else savePulseConfig() end
    notify("Config", "Cleaned, defaults restored")
end
function playCustomSound(path, vol)
    if type(getcustomasset) ~= "function" then notify("Custom Sounds", "Executor can't load files") return end
    local ok, asset = pcall(getcustomasset, path)
    if not ok or not asset then notify("Custom Sounds", "Can't load file") return end
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    local s = Instance.new("Sound") s.SoundId = asset
    s.Volume = math.clamp((vol == nil and soundVolume or vol) / 100 * 2, 0, 3)
    s.Parent = pg or workspace
    s:Play() game:GetService("Debris"):AddItem(s, 6)
end
customShotName = "Off"
function playCustomShot()
    if customShotName == nil or customShotName == "Off" or customShotName == "(none)" or customShotName == "(no custom sounds)" then
        notify("Custom Sounds", "Pick a Shot Sound first")
        if GITHUB_SOUNDS_BASE == "" and #PulseSoundFiles == 0 then
            notify("Custom Sounds", "Drop .mp3/.ogg into PULSITI/custom sounds or set GITHUB_SOUNDS_BASE")
        end
        return
    end
    local path = findSoundPath(PulseGithubShots, customShotName)
    if path then playCustomSound(path) return end
    notify("Custom Sounds", "File not found")
end
function playKillSound()
    if killSoundName == nil or killSoundName == "Off" then return end
    local path = findSoundPath(PulseGithubKills, killSoundName)
    if path then playCustomSound(path) end
end
walkSpeedEnabled = false
walkSpeedValue = 16
function applyWalkSpeed()
    local hum = LocalPlayer.Character and getHumanoid(LocalPlayer.Character)
    if hum then hum.WalkSpeed = walkSpeedEnabled and walkSpeedValue or 16 end
end
fakeKorbloxOn = false
fakeHeadlessOn = false
function setFakeKorblox(state)
    fakeKorbloxOn = state
    local char = LocalPlayer.Character
    local leg = char and (char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg") or char:FindFirstChild("RightLeg"))
    if leg and leg:IsA("BasePart") then leg.Transparency = state and 1 or 0 end
    notify("Fake Korblox", state and "ON (client-side)" or "OFF")
end
function setFakeHeadless(state)
    fakeHeadlessOn = state
    local char = LocalPlayer.Character
    local head = char and char:FindFirstChild("Head")
    if head then
        head.Transparency = state and 1 or 0
        local face = head:FindFirstChildOfClass("Decal")
        if face then face.Transparency = state and 1 or 0 end
    end
    notify("Fake Headless", state and "ON (client-side)" or "OFF")
end
humpDuration = 0
playerMenuOpen = false
playerMenuPanel = nil
function setPlayerMenu(state)
    playerMenuOpen = state
    if playerMenuPanel then pcall(function() playerMenuPanel:Destroy() end) playerMenuPanel = nil end
    if not state then return end
    playerMenuPanel = Instance.new("Frame")
    playerMenuPanel.Size = UDim2.new(0, 200, 0, 260)
    playerMenuPanel.Position = UDim2.new(1, -210, 0.5, -130)
    playerMenuPanel.BackgroundColor3 = Color3.fromRGB(13, 18, 38)
    playerMenuPanel.BorderSizePixel = 0 playerMenuPanel.Parent = ScreenGui
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 6) c.Parent = playerMenuPanel
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, 0, 0, 28) t.BackgroundTransparency = 1 t.Text = "Player Menu"
    t.Font = Enum.Font.GothamBold t.TextSize = 13 t.TextColor3 = Color3.fromRGB(235, 238, 248) t.Parent = playerMenuPanel
    local list = Instance.new("ScrollingFrame")
    list.Size = UDim2.new(1, -10, 1, -34) list.Position = UDim2.new(0, 5, 0, 30)
    list.BackgroundTransparency = 1 list.BorderSizePixel = 0 list.ScrollBarThickness = 3 list.Parent = playerMenuPanel
    local l = Instance.new("UIListLayout") l.Padding = UDim.new(0, 3) l.Parent = list
    local n = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            n = n + 1
            local b = Instance.new("TextButton") b.Size = UDim2.new(1, -4, 0, 28)
            b.BackgroundColor3 = Color3.fromRGB(26, 34, 64) b.Text = p.Name
            b.Font = Enum.Font.Gotham b.TextSize = 12 b.TextColor3 = Color3.fromRGB(220, 224, 240) b.TextTruncate = Enum.TextTruncate.AtEnd b.Parent = list
            local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 4) bc.Parent = b
            b.MouseButton1Click:Connect(function() StartBang(p.Name) notify("Player Menu", "Humping " .. p.Name) end)
        end
    end
    list.CanvasSize = UDim2.new(0, 0, 0, n * 31 + 6)
end
loadPulseConfig()
function __buildUI()
print("[PULSITI] ui: build start")
ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PULSITI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
__parented = false
if gethui then pcall(function() ScreenGui.Parent = gethui() __parented = (ScreenGui.Parent ~= nil) end) end
if not __parented then pcall(function() ScreenGui.Parent = game:GetService("CoreGui") __parented = (ScreenGui.Parent ~= nil) end) end
if not __parented then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
print("[PULSITI] UI parent = " .. tostring(ScreenGui.Parent))
MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 750, 0, 460)
MainFrame.Position = UDim2.new(0.5, -375, 0.5, -230)
MainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
MainFrame.BackgroundTransparency = 0.12
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = false
MainFrame.Parent = ScreenGui
MainFrameRef = MainFrame
do
    if BG_ASSET ~= "rbxassetid://0" then
        local bg = Instance.new("ImageLabel")
        bg.Name = "BG" bg.Size = UDim2.new(1, 0, 1, 0) bg.BackgroundTransparency = 1
        bg.Image = BG_ASSET bg.ScaleType = Enum.ScaleType.Crop
        bg.ZIndex = 0 bg.Parent = MainFrame
        local dim = Instance.new("Frame")
        dim.Name = "Dim" dim.Size = UDim2.new(1, 0, 1, 0)
        dim.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
        dim.BackgroundTransparency = 0.35 dim.BorderSizePixel = 0
        dim.ZIndex = 0 dim.Parent = MainFrame
    end
end
MainCorner = Instance.new("UICorner") MainCorner.CornerRadius = UDim.new(0, 10) MainCorner.Parent = MainFrame
MainStroke = Instance.new("UIStroke") MainStroke.Color = Color3.fromRGB(60,60,72) MainStroke.Thickness = 1 MainStroke.Parent = MainFrame
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIScale = Instance.new("UIScale") UIScale.Scale = 1 UIScale.Parent = MainFrame
Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 188, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
Sidebar.BackgroundTransparency = 0.1
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 2
Sidebar.ClipsDescendants = true
Sidebar.Parent = MainFrame
SBCorner = Instance.new("UICorner") SBCorner.CornerRadius = UDim.new(0, 10) SBCorner.Parent = Sidebar
SBCover = Instance.new("Frame") SBCover.Size = UDim2.new(0, 10, 1, 0) SBCover.Position = UDim2.new(1, -10, 0, 0) SBCover.BackgroundColor3 = Color3.fromRGB(22, 22, 28) SBCover.BackgroundTransparency = 0.1 SBCover.BorderSizePixel = 0 SBCover.ZIndex = 2 SBCover.Parent = Sidebar
do
    local logoImg = Instance.new("ImageLabel")
    logoImg.Size = UDim2.new(0, 32, 0, 32) logoImg.Position = UDim2.new(0, 12, 0, 10)
    logoImg.BackgroundColor3 = Color3.fromRGB(40, 90, 200) logoImg.BorderSizePixel = 0
    logoImg.Image = LOGO_ASSET logoImg.ScaleType = Enum.ScaleType.Crop logoImg.ZIndex = 3 logoImg.Parent = Sidebar
    local lc = Instance.new("UICorner") lc.CornerRadius = UDim.new(1, 0) lc.Parent = logoImg
    local t1 = Instance.new("TextLabel")
    t1.Size = UDim2.new(1, -52, 0, 18) t1.Position = UDim2.new(0, 50, 0, 11)
    t1.BackgroundTransparency = 1 t1.Text = "PULSITI" t1.Font = Enum.Font.GothamBold t1.TextSize = 13
    t1.TextColor3 = Color3.fromRGB(90, 140, 255) t1.TextXAlignment = Enum.TextXAlignment.Left t1.ZIndex = 3 t1.Parent = Sidebar
    local t2 = Instance.new("TextLabel")
    t2.Size = UDim2.new(1, -52, 0, 14) t2.Position = UDim2.new(0, 50, 0, 29)
    t2.BackgroundTransparency = 1 t2.Text = "MM2 - v0.42" t2.Font = Enum.Font.Gotham t2.TextSize = 11
    t2.TextColor3 = Color3.fromRGB(150, 150, 160) t2.TextXAlignment = Enum.TextXAlignment.Left t2.ZIndex = 3 t2.Parent = Sidebar
end
NavList = Instance.new("Frame")
NavList.Name = "NavList"
NavList.Size = UDim2.new(1, 0, 1, -50) NavList.Position = UDim2.new(0, 0, 0, 50)
NavList.BackgroundTransparency = 1 NavList.BorderSizePixel = 0
NavList.ClipsDescendants = true
NavList.ZIndex = 3 NavList.Parent = Sidebar
NavLayout = Instance.new("UIListLayout") NavLayout.Padding = UDim.new(0, 0) NavLayout.SortOrder = Enum.SortOrder.LayoutOrder NavLayout.VerticalAlignment = Enum.VerticalAlignment.Top NavLayout.Parent = NavList
TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, -198, 0, 40) TopBar.Position = UDim2.new(0, 194, 0, 6)
TopBar.BackgroundTransparency = 1 TopBar.ZIndex = 2 TopBar.Parent = MainFrame
SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(0, 190, 0, 30) SearchBox.Position = UDim2.new(1, -230, 0, 0)
SearchBox.BackgroundColor3 = Color3.fromRGB(38, 38, 46) SearchBox.TextColor3 = Color3.fromRGB(220,220,225)
SearchBox.PlaceholderText = "Search..." SearchBox.PlaceholderColor3 = Color3.fromRGB(150,150,160)
SearchBox.Text = "" SearchBox.Font = Enum.Font.Gotham SearchBox.TextSize = 13
SearchBox.TextXAlignment = Enum.TextXAlignment.Center SearchBox.ClipsDescendants = true
SearchBox.ZIndex = 2
SearchBox.Parent = TopBar
SC = Instance.new("UICorner") SC.CornerRadius = UDim.new(0, 8) SC.Parent = SearchBox
CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30) CloseBtn.Position = UDim2.new(1, -32, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(38,38,46) CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(220,220,225) CloseBtn.Font = Enum.Font.GothamBold CloseBtn.TextSize = 14
CloseBtn.AutoButtonColor = true
CloseBtn.ZIndex = 2
CloseBtn.Parent = TopBar
CC = Instance.new("UICorner") CC.CornerRadius = UDim.new(0, 8) CC.Parent = CloseBtn
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)
SubTabs = Instance.new("Frame")
SubTabs.Size = UDim2.new(0, 210, 0, 30) SubTabs.Position = UDim2.new(0, 6, 0, 0)
SubTabs.BackgroundTransparency = 1 SubTabs.ZIndex = 2 SubTabs.Parent = TopBar
SubLayout = Instance.new("UIListLayout") SubLayout.FillDirection = Enum.FillDirection.Horizontal SubLayout.Padding = UDim.new(0, 6) SubLayout.VerticalAlignment = Enum.VerticalAlignment.Center SubLayout.Parent = SubTabs
Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -198, 1, -52) Content.Position = UDim2.new(0, 194, 0, 46)
Content.BackgroundTransparency = 1 Content.ZIndex = 2 Content.ClipsDescendants = true Content.Parent = MainFrame
Pages = {}
AllControls = {}
AdvBoxes = {}
function createPage(name)
    local f = Instance.new("ScrollingFrame")
    f.Name = name f.Size = UDim2.new(1, 0, 1, 0) f.BackgroundTransparency = 1
    f.BorderSizePixel = 0 f.ScrollBarThickness = 2 f.Visible = false f.Parent = Content
    f.AutomaticCanvasSize = Enum.AutomaticSize.Y f.CanvasSize = UDim2.new(0, 0, 0, 0)
    f.ScrollingDirection = Enum.ScrollingDirection.Y
    Pages[name] = f
    return f
end
isAdminUser = false
pcall(function()
    isAdminUser = (LocalPlayer ~= nil and string.lower(LocalPlayer.Name) == "remesec")
end)
pageNames = {"Main","Combat","Auto Farm","Teleport","Troll Fun","Free anims","Fling Players","Visuals","Settings","Server"}
if isAdminUser then table.insert(pageNames, "Admin") end
navCount = #pageNames
NAV_ICONS = {Main = "rbxassetid://81344910161871", Combat = "rbxassetid://81872698913435", ["Auto Farm"] = "rbxassetid://128420521375441", Teleport = "rbxassetid://127751956873796", ["Troll Fun"] = "rbxassetid://92483947987410", ["Free anims"] = "rbxassetid://125020872044147", ["Fling Players"] = "rbxassetid://108829540827529", Visuals = "rbxassetid://100033680381365", Settings = "rbxassetid://85538382643347", Server = "rbxassetid://92188766517878", Admin = "rbxassetid://85538382643347"}
for _, n in ipairs(pageNames) do createPage(n) end
PageSubIdx = PageSubIdx or {}
PageCards = PageCards or {}
function subPlaceholder(page, title, text)
    local c, l = card(page, title, 4, 520)
    label(l, text)
    c.Visible = false
    return c
end
function applySubFilter(pageName)
    local idx = PageSubIdx[pageName] or 1
    local g = PageCards[pageName]
    if not g then return end
    local function show(list, vis)
        if list then for _, cf in ipairs(list) do pcall(function() cf.Visible = vis end) end end
    end
    if pageName == "Main" then
        show(g.general, idx == 1)
        show(g.uis, idx == 2)
    elseif pageName == "Troll Fun" then
        show(g.troll, idx == 1)
        show(g.music, idx == 2)
    elseif pageName == "Free anims" then
        show(g.bundles, idx == 1)
        show(g.emotes, idx == 2)
        show(g.favs, idx == 3)
    elseif pageName == "Visuals" then
        show(g.shaders, idx == 1)
        show(g.extras, idx == 2)
    elseif pageName == "Settings" then
        if idx == 1 then
            show({g.c1}, true)
            pcall(function()
                local h = g.c1.AbsoluteSize.Y
                g.c2.Position = UDim2.new(0, 4, 0, (h > 50 and h or 300) + 8)
            end)
            show({g.c2}, true)
        else
            show({g.c1}, false)
            g.c2.Position = UDim2.new(0, 4, 0, 0)
            show({g.c2}, true)
        end
    end
end
function paintSubTabs()
    local active = PageSubIdx.__activeBtns
    for btn, isActive in pairs(active or {}) do
        if btn and btn.Parent then
            btn.BackgroundColor3 = isActive and Color3.fromRGB(165, 165, 175) or Color3.fromRGB(38, 38, 46)
            btn.TextColor3 = isActive and Color3.fromRGB(30,30,36) or Color3.fromRGB(180,180,190)
            local t = btn:GetAttribute("SubName") or ""
            btn.Text = (isActive and "●  " or "") .. t
        end
    end
end
function setSubTabs(list, pageName)
    for _, c in pairs(SubTabs:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    PageSubIdx.__activeBtns = {}
    if not pageName then
        if list then for idx, t in ipairs(list) do end end
        return
    end
    if PageSubIdx[pageName] == nil then PageSubIdx[pageName] = 1 end
    for idx, t in ipairs(list) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 96, 0, 30)
        b.Font = Enum.Font.GothamBold b.TextSize = 13
        b.AutoButtonColor = true
        b.TextTruncate = Enum.TextTruncate.AtEnd
        b.ZIndex = 2
        b:SetAttribute("SubName", t)
        b.Parent = SubTabs
        local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 8) c.Parent = b
        local myIdx = idx
        b.MouseButton1Click:Connect(function()
            PageSubIdx[pageName] = myIdx
            for btn2, _ in pairs(PageSubIdx.__activeBtns) do
                PageSubIdx.__activeBtns[btn2] = false
            end
            PageSubIdx.__activeBtns[b] = true
            paintSubTabs()
            applySubFilter(pageName)
        end)
        PageSubIdx.__activeBtns[b] = (idx == (PageSubIdx[pageName] or 1))
    end
    paintSubTabs()
end
function switchPage(name)
    for _, p in pairs(Pages) do p.Visible = false end
    if Pages[name] then Pages[name].Visible = true end
    for _, b in pairs(NavList:GetChildren()) do
        if b:IsA("TextButton") then
            local lbl = b:FindFirstChild("NavText")
            local ic = b:FindFirstChild("NavIcon")
            local ar = b:FindFirstChild("NavArrow")
            if b.Name == name then
                tween(b, {BackgroundColor3 = Color3.fromRGB(148, 148, 158)}, 0.15)
                if lbl then lbl.TextColor3 = Color3.fromRGB(28,28,34) end
                if ic then ic.ImageColor3 = Color3.fromRGB(40,40,48) end
                if ar then ar.Text = "v" ar.TextColor3 = Color3.fromRGB(40,40,48) end
            else
                tween(b, {BackgroundColor3 = Color3.fromRGB(22,22,28)}, 0.15)
                if lbl then lbl.TextColor3 = Color3.fromRGB(175,175,185) end
                if ic then ic.ImageColor3 = Color3.fromRGB(175,175,185) end
                if ar then ar.Text = ">" ar.TextColor3 = Color3.fromRGB(110,110,120) end
            end
        end
    end
    if name == "Main" then setSubTabs({"General","UIs"}, "Main")
    elseif name == "Troll Fun" then setSubTabs({"Troll","Music"}, "Troll Fun")
    elseif name == "Free anims" then setSubTabs({"Bundles","Emotes","Favs"}, "Free anims")
    elseif name == "Visuals" then setSubTabs({"Shaders","Extras"}, "Visuals")
    elseif name == "Settings" then setSubTabs({"UI","Configs"}, "Settings")
    else setSubTabs({}, name) end
    applySubFilter(name)
    task.spawn(function()
        local pg = Pages[name]
        if not pg then return end
        local i = 0
        for _, ch in ipairs(pg:GetChildren()) do
            if ch:IsA("Frame") and ch.Visible and ch.Name ~= "AdvBox" then
                i = i + 1
                local d = i * 0.03
                local baseT = ch.BackgroundTransparency
                task.spawn(function()
                    task.wait(d)
                    if not ch.Parent then return end
                    ch.BackgroundTransparency = math.clamp(baseT + 0.5, 0, 1)
                    tween(ch, {BackgroundTransparency = baseT}, 0.22)
                end)
            end
        end
    end)
end
for idx, n in ipairs(pageNames) do
    local b = Instance.new("TextButton")
    b.Name = n b.LayoutOrder = idx * 2 b.Size = UDim2.new(1, -10, 1 / navCount, -1) b.Position = UDim2.new(0, 5, 0, 0)
    b.BackgroundColor3 = Color3.fromRGB(22,22,28) b.Text = ""
    b.AutoButtonColor = false
    b.ClipsDescendants = true
    b.ZIndex = 3
    b.Parent = NavList
    local ico = Instance.new("ImageLabel")
    ico.Name = "NavIcon"
    ico.Size = UDim2.new(0, 16, 0, 16) ico.Position = UDim2.new(0, 12, 0.5, -8)
    ico.BackgroundTransparency = 1 ico.Image = NAV_ICONS[n] or "" ico.ScaleType = Enum.ScaleType.Fit
    ico.ImageColor3 = Color3.fromRGB(175,175,185)
    ico.ZIndex = 4
    ico.Parent = b
    local txt = Instance.new("TextLabel")
    txt.Name = "NavText"
    txt.Size = UDim2.new(1, -56, 1, 0) txt.Position = UDim2.new(0, 34, 0, 0)
    txt.BackgroundTransparency = 1 txt.Text = n
    txt.Font = Enum.Font.GothamSemibold txt.TextSize = 14 txt.TextColor3 = Color3.fromRGB(175,175,185)
    txt.TextXAlignment = Enum.TextXAlignment.Left txt.TextYAlignment = Enum.TextYAlignment.Center
    txt.TextTruncate = Enum.TextTruncate.AtEnd
    txt.ZIndex = 4
    txt.Parent = b
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 6) c.Parent = b
    local more = Instance.new("TextLabel") more.Name = "NavArrow" more.Size = UDim2.new(0, 16, 1, 0) more.Position = UDim2.new(1, -20, 0, 0)
    more.BackgroundTransparency = 1 more.Text = ">" more.Font = Enum.Font.GothamBold more.TextSize = 12
    more.TextColor3 = Color3.fromRGB(110, 110, 120) more.TextXAlignment = Enum.TextXAlignment.Center more.TextYAlignment = Enum.TextYAlignment.Center more.ZIndex = 4 more.Parent = b
    local sep = Instance.new("Frame") sep.Name = "Sep" sep.LayoutOrder = idx * 2 + 1
    sep.Size = UDim2.new(1, 0, 0, 1)
    sep.BackgroundColor3 = Color3.fromRGB(45, 45, 55) sep.BorderSizePixel = 0 sep.ZIndex = 3 sep.Parent = NavList
    b.MouseButton1Click:Connect(function() switchPage(n) end)
end
function card(parent, title, x, w)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0, w or 258, 0, 0) f.Position = UDim2.new(0, x or 0, 0, 0)
    f.AutomaticSize = Enum.AutomaticSize.Y
    f.BackgroundColor3 = Color3.fromRGB(150, 150, 160) f.BackgroundTransparency = 0.45
    f.BorderSizePixel = 0 f.ClipsDescendants = false f.ZIndex = 2 f.Parent = parent
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 10) c.Parent = f
    local st = Instance.new("UIStroke") st.Color = Color3.fromRGB(255, 255, 255) st.Transparency = 0.45 st.Thickness = 1 st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border st.Parent = f
    local fl = Instance.new("UIListLayout") fl.Padding = UDim.new(0, 4) fl.SortOrder = Enum.SortOrder.LayoutOrder fl.Parent = f
    local fp = Instance.new("UIPadding")
    fp.PaddingLeft = UDim.new(0, 12) fp.PaddingRight = UDim.new(0, 12)
    fp.PaddingTop = UDim.new(0, 8) fp.PaddingBottom = UDim.new(0, 8)
    fp.Parent = f
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, 0, 0, 26) t.LayoutOrder = 0
    t.BackgroundTransparency = 1 t.Text = title t.Font = Enum.Font.GothamBold t.TextSize = 14
    t.TextColor3 = Color3.fromRGB(45,45,55) t.TextXAlignment = Enum.TextXAlignment.Left t.TextTruncate = Enum.TextTruncate.AtEnd t.Parent = f
    txtPop(t)
    local list = Instance.new("Frame")
    list.Name = "List" list.Size = UDim2.new(1, 0, 0, 0) list.LayoutOrder = 1
    list.AutomaticSize = Enum.AutomaticSize.Y
    list.BackgroundTransparency = 1 list.ClipsDescendants = false list.Parent = f
    local l = Instance.new("UIListLayout") l.Padding = UDim.new(0, 4) l.SortOrder = Enum.SortOrder.LayoutOrder l.Parent = list
    return f, list
end
function keyRow(parent, text, initial, cb)
    local row = Instance.new("Frame") row.Size = UDim2.new(1, 0, 0, 32) row.BackgroundTransparency = 1 row.ClipsDescendants = true row.Parent = parent
    local lb = Instance.new("TextLabel") lb.Size = UDim2.new(1, -60, 1, 0) lb.BackgroundTransparency = 1
    lb.Text = text lb.Font = Enum.Font.Gotham lb.TextSize = 13 lb.TextColor3 = Color3.fromRGB(45,45,55)
    lb.TextXAlignment = Enum.TextXAlignment.Left lb.TextTruncate = Enum.TextTruncate.AtEnd lb.Parent = row
    txtPop(lb)
    local bb = Instance.new("TextButton") bb.Size = UDim2.new(0, 52, 0, 22) bb.Position = UDim2.new(1, -54, 0.5, -11)
    bb.BackgroundColor3 = Color3.fromRGB(28,28,34) bb.Text = initial bb.Font = Enum.Font.GothamBold bb.TextSize = 12
    bb.TextColor3 = Color3.fromRGB(235,235,240) bb.TextTruncate = Enum.TextTruncate.AtEnd bb.Parent = row
    local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 6) bc.Parent = bb
    bb.MouseButton1Click:Connect(function() waitBind(bb, cb) end)
    reg(row, text)
end
function reg(control, text)
    table.insert(AllControls, {f = control, t = string.lower(text)})
end
function toggle(parent, text, default, cb, bindText, onBind)
    local clean = string.gsub(tostring(text), " ⚙", "")
    local hasGear = (clean ~= tostring(text))
    local hasBind = (bindText ~= nil)
    local rightW = 50 + (hasGear and 22 or 0) + (hasBind and 50 or 0)
    local row = Instance.new("Frame") row.Size = UDim2.new(1, 0, 0, 30) row.BackgroundTransparency = 1 row.ClipsDescendants = true row.Parent = parent
    local lb = Instance.new("TextLabel") lb.Size = UDim2.new(1, -rightW, 1, 0) lb.BackgroundTransparency = 1
    lb.Text = clean lb.Font = Enum.Font.Gotham lb.TextSize = 13 lb.TextColor3 = Color3.fromRGB(45,45,55)
    lb.TextXAlignment = Enum.TextXAlignment.Left lb.TextTruncate = Enum.TextTruncate.AtEnd lb.Parent = row
    txtPop(lb)
    local state = default
    local btn = Instance.new("TextButton") btn.Size = UDim2.new(0, 42, 0, 22) btn.Position = UDim2.new(1, -44, 0.5, -11)
    btn.BackgroundColor3 = default and ACCENT or Color3.fromRGB(105,105,118) btn.Text = "" btn.AutoButtonColor = true btn.Parent = row
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(1, 0) c.Parent = btn
    local dot = Instance.new("Frame") dot.Size = UDim2.new(0, 18, 0, 18)
    dot.Position = default and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    dot.BackgroundColor3 = Color3.fromRGB(255,255,255) dot.BorderSizePixel = 0 dot.Parent = btn
    local dc = Instance.new("UICorner") dc.CornerRadius = UDim.new(1, 0) dc.Parent = dot
    local function set(s)
        state = s
        tween(btn, {BackgroundColor3 = s and ACCENT or Color3.fromRGB(105,105,118)}, 0.14)
        tween(dot, {Position = s and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}, 0.14)
        pcall(cb, s)
    end
    btn.MouseButton1Click:Connect(function() set(not state) end)
    local rx = 44
    if hasGear then
        local g = Instance.new("TextLabel") g.Size = UDim2.new(0, 18, 0, 18) g.Position = UDim2.new(1, -44 - 20, 0.5, -9)
        g.BackgroundTransparency = 1 g.Text = "⚙" g.Font = Enum.Font.GothamBold g.TextSize = 13
        g.TextColor3 = Color3.fromRGB(120,120,130) g.TextXAlignment = Enum.TextXAlignment.Center g.Parent = row
        rx = rx + 22
    end
    if hasBind then
        local bb = Instance.new("TextButton") bb.Size = UDim2.new(0, 42, 0, 20) bb.Position = UDim2.new(1, -rx - 44, 0.5, -10)
        bb.BackgroundColor3 = Color3.fromRGB(28,28,34) bb.Text = bindText bb.Font = Enum.Font.GothamBold bb.TextSize = 11
        bb.TextColor3 = Color3.fromRGB(235,235,240) bb.TextTruncate = Enum.TextTruncate.AtEnd bb.Parent = row
        local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 6) bc.Parent = bb
        if onBind then bb.MouseButton1Click:Connect(function() onBind(bb) end) end
    end
    reg(row, text)
    return {Set = set, Get = function() return state end}
end
function advBox(parent)
    local box = Instance.new("Frame")
    box.Name = "AdvBox"
    box.Size = UDim2.new(1, 0, 0, 0)
    box.AutomaticSize = Enum.AutomaticSize.Y
    box.BackgroundTransparency = 1
    box.Visible = false
    box.ClipsDescendants = false
    box.Parent = parent
    local lay = Instance.new("UIListLayout") lay.Padding = UDim.new(0, 4) lay.SortOrder = Enum.SortOrder.LayoutOrder lay.Parent = box
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 10) pad.PaddingRight = UDim.new(0, 0)
    pad.PaddingTop = UDim.new(0, 0) pad.PaddingBottom = UDim.new(0, 2)
    pad.Parent = box
    table.insert(AdvBoxes, box)
    return box
end
function toggleGear(parent, text, default, cb, bindText, onBind)
    local hasBind = (bindText ~= nil)
    local rightW = 50 + 22 + (hasBind and 50 or 0)
    local row = Instance.new("Frame") row.Size = UDim2.new(1, 0, 0, 30) row.BackgroundTransparency = 1 row.ClipsDescendants = true row.Parent = parent
    local lb = Instance.new("TextLabel") lb.Size = UDim2.new(1, -rightW, 1, 0) lb.BackgroundTransparency = 1
    lb.Text = tostring(text) lb.Font = Enum.Font.Gotham lb.TextSize = 13 lb.TextColor3 = Color3.fromRGB(45,45,55)
    lb.TextXAlignment = Enum.TextXAlignment.Left lb.TextTruncate = Enum.TextTruncate.AtEnd lb.Parent = row
    txtPop(lb)
    local state = default
    local btn = Instance.new("TextButton") btn.Size = UDim2.new(0, 42, 0, 22) btn.Position = UDim2.new(1, -44, 0.5, -11)
    btn.BackgroundColor3 = default and ACCENT or Color3.fromRGB(105,105,118) btn.Text = "" btn.AutoButtonColor = true btn.Parent = row
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(1, 0) c.Parent = btn
    local dot = Instance.new("Frame") dot.Size = UDim2.new(0, 18, 0, 18)
    dot.Position = default and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    dot.BackgroundColor3 = Color3.fromRGB(255,255,255) dot.BorderSizePixel = 0 dot.Parent = btn
    local dc = Instance.new("UICorner") dc.CornerRadius = UDim.new(1, 0) dc.Parent = dot
    local function set(s)
        state = s
        tween(btn, {BackgroundColor3 = s and ACCENT or Color3.fromRGB(105,105,118)}, 0.14)
        tween(dot, {Position = s and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}, 0.14)
        pcall(cb, s)
    end
    btn.MouseButton1Click:Connect(function() set(not state) end)
    local rx = 44
    local gb = Instance.new("TextButton") gb.Size = UDim2.new(0, 18, 0, 18) gb.Position = UDim2.new(1, -44 - 20, 0.5, -9)
    gb.BackgroundTransparency = 1 gb.Text = "⚙" gb.Font = Enum.Font.GothamBold gb.TextSize = 14
    gb.TextColor3 = Color3.fromRGB(120,120,130) gb.AutoButtonColor = true gb.Parent = row
    rx = rx + 22
    if hasBind then
        local bb = Instance.new("TextButton") bb.Size = UDim2.new(0, 42, 0, 20) bb.Position = UDim2.new(1, -rx - 44, 0.5, -10)
        bb.BackgroundColor3 = Color3.fromRGB(28,28,34) bb.Text = bindText bb.Font = Enum.Font.GothamBold bb.TextSize = 11
        bb.TextColor3 = Color3.fromRGB(235,235,240) bb.TextTruncate = Enum.TextTruncate.AtEnd bb.Parent = row
        local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 6) bc.Parent = bb
        if onBind then bb.MouseButton1Click:Connect(function() onBind(bb) end) end
    end
    local box = advBox(parent)
    gb.MouseButton1Click:Connect(function()
        box.Visible = not box.Visible
        gb.TextColor3 = box.Visible and Color3.fromRGB(55,55,65) or Color3.fromRGB(120,120,130)
        tween(gb, {Rotation = box.Visible and 90 or 0}, 0.18)
    end)
    reg(row, text)
    return {Set = set, Get = function() return state end, box = box, gear = gb}
end
function button(parent, text, cb)
    local b = Instance.new("TextButton") b.Size = UDim2.new(1, 0, 0, 34)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 38) b.Text = text
    b.Font = Enum.Font.GothamSemibold b.TextSize = 13 b.TextColor3 = Color3.fromRGB(235,235,240)
    b.AutoButtonColor = true b.TextTruncate = Enum.TextTruncate.AtEnd
    b.ClipsDescendants = true
    b.Parent = parent
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 8) c.Parent = b
    pressFx(b, Color3.fromRGB(30, 30, 38))
    b.MouseButton1Click:Connect(function() pcall(cb) end)
    reg(b, text)
    return b
end
function betaRow(parent, text)
    local b = Instance.new("TextButton") b.Size = UDim2.new(1, 0, 0, 34)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 38) b.Text = ""
    b.AutoButtonColor = true b.ClipsDescendants = true b.Parent = parent
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 8) c.Parent = b
    local lb = Instance.new("TextLabel") lb.Size = UDim2.new(1, -90, 1, 0) lb.Position = UDim2.new(0, 12, 0, 0)
    lb.BackgroundTransparency = 1 lb.Text = tostring(text)
    lb.Font = Enum.Font.Gotham lb.TextSize = 13 lb.TextColor3 = Color3.fromRGB(210,210,220)
    lb.TextXAlignment = Enum.TextXAlignment.Left lb.TextTruncate = Enum.TextTruncate.AtEnd lb.Parent = b
    local g = Instance.new("TextLabel") g.Size = UDim2.new(0, 18, 0, 18) g.Position = UDim2.new(1, -70, 0.5, -9)
    g.BackgroundTransparency = 1 g.Text = "⚙" g.Font = Enum.Font.GothamBold g.TextSize = 13
    g.TextColor3 = Color3.fromRGB(120,120,130) g.TextXAlignment = Enum.TextXAlignment.Center g.Parent = b
    local beta = Instance.new("TextLabel") beta.Size = UDim2.new(0, 44, 0, 20) beta.Position = UDim2.new(1, -48, 0.5, -10)
    beta.BackgroundColor3 = Color3.fromRGB(200, 120, 30) beta.Text = "BETA"
    beta.Font = Enum.Font.GothamBold beta.TextSize = 10 beta.TextColor3 = Color3.fromRGB(30, 20, 10)
    beta.Parent = b
    local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 6) bc.Parent = beta
    pressFx(b, Color3.fromRGB(30, 30, 38))
    b.MouseButton1Click:Connect(function()
        notifyDev("In development", "This function is not finished yet.")
    end)
    reg(b, text)
    return b
end
function slider(parent, text, default, min, max, cb)
    local row = Instance.new("Frame") row.Size = UDim2.new(1, 0, 0, 46) row.BackgroundTransparency = 1 row.ClipsDescendants = false row.Parent = parent
    local lb = Instance.new("TextLabel") lb.Size = UDim2.new(1, -44, 0, 16) lb.BackgroundTransparency = 1
    lb.Text = text lb.Font = Enum.Font.Gotham lb.TextSize = 13 lb.TextColor3 = Color3.fromRGB(45,45,55)
    lb.TextXAlignment = Enum.TextXAlignment.Left lb.TextTruncate = Enum.TextTruncate.AtEnd lb.Parent = row
    txtPop(lb)
    local val = Instance.new("TextLabel") val.Size = UDim2.new(0, 44, 0, 16) val.Position = UDim2.new(1, -44, 0, 0)
    val.BackgroundTransparency = 1 val.Text = tostring(default) val.Font = Enum.Font.GothamBold val.TextSize = 13
    val.TextColor3 = Color3.fromRGB(50,50,60) val.TextXAlignment = Enum.TextXAlignment.Right val.Parent = row
    txtPop(val)
    local bg = Instance.new("Frame") bg.Size = UDim2.new(1, -12, 0, 6) bg.Position = UDim2.new(0, 6, 0, 26)
    bg.BackgroundColor3 = Color3.fromRGB(120,120,132) bg.BackgroundTransparency = 0.25 bg.BorderSizePixel = 0 bg.ClipsDescendants = false bg.Parent = row
    local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(1, 0) bc.Parent = bg
    local span = math.max(1, (max - min))
    local pct0 = math.clamp((default - min) / span, 0, 1)
    local fill = Instance.new("Frame") fill.Size = UDim2.new(pct0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(70,70,82) fill.BorderSizePixel = 0 fill.Parent = bg
    local fc = Instance.new("UICorner") fc.CornerRadius = UDim.new(1, 0) fc.Parent = fill
    local knob = Instance.new("Frame") knob.Size = UDim2.new(0, 12, 0, 12) knob.Position = UDim2.new(pct0, -6, 0.5, -6)
    knob.BackgroundColor3 = Color3.fromRGB(255,255,255) knob.BorderSizePixel = 0 knob.ZIndex = 2 knob.Parent = bg
    local kc = Instance.new("UICorner") kc.CornerRadius = UDim.new(1, 0) kc.Parent = knob
    local cur = default
    local dragging = false
    local mvConn, endConn
    local function apply(pct, instant)
        pct = math.clamp(pct, 0, 1)
        cur = math.floor(min + (max - min) * pct + 0.5)
        if instant then
            fill.Size = UDim2.new(pct, 0, 1, 0)
            knob.Position = UDim2.new(pct, -6, 0.5, -6)
        else
            tween(fill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.1)
            tween(knob, {Position = UDim2.new(pct, -6, 0.5, -6)}, 0.1)
        end
        val.Text = tostring(cur)
        pcall(cb, cur)
    end
    local function pctAt(x)
        return (x - bg.AbsolutePosition.X) / math.max(1, bg.AbsoluteSize.X)
    end
    local function stopDrag()
        dragging = false
        if mvConn then pcall(function() mvConn:Disconnect() end) mvConn = nil end
        if endConn then pcall(function() endConn:Disconnect() end) endConn = nil end
    end
    local function startDrag(input)
        stopDrag()
        dragging = true
        apply(pctAt(input.Position.X), true)
        mvConn = UserInputService.InputChanged:Connect(function(j)
            if not dragging then return end
            if j.UserInputType == Enum.UserInputType.MouseMovement or j.UserInputType == Enum.UserInputType.Touch then
                apply(pctAt(j.Position.X), true)
            end
        end)
        endConn = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End or input.UserInputState == Enum.UserInputState.Cancel then
                stopDrag()
            end
        end)
    end
    local function hookPress(obj)
        obj.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                startDrag(i)
            end
        end)
    end
    hookPress(bg) hookPress(fill) hookPress(knob)
    reg(row, text)
end
function dropdown(parent, text, options, default, cb)
    local row = Instance.new("Frame") row.Size = UDim2.new(1, 0, 0, 32) row.BackgroundTransparency = 1 row.ClipsDescendants = false row.Parent = parent
    local lb = Instance.new("TextLabel") lb.Size = UDim2.new(0.55, 0, 1, 0) lb.BackgroundTransparency = 1
    lb.Text = text lb.Font = Enum.Font.Gotham lb.TextSize = 13 lb.TextColor3 = Color3.fromRGB(45,45,55)
    lb.TextXAlignment = Enum.TextXAlignment.Left lb.TextTruncate = Enum.TextTruncate.AtEnd lb.Parent = row
    txtPop(lb)
    local b = Instance.new("TextButton") b.Size = UDim2.new(0.45, 0, 0, 26) b.Position = UDim2.new(0.55, 0, 0.5, -13)
    b.BackgroundColor3 = Color3.fromRGB(30,30,38) b.Text = tostring(default or options[1] or "") .. "  v"
    b.Font = Enum.Font.Gotham b.TextSize = 12 b.TextColor3 = Color3.fromRGB(230,230,235) b.TextTruncate = Enum.TextTruncate.AtEnd b.AutoButtonColor = true b.ClipsDescendants = true b.Parent = row
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 6) c.Parent = b
    local open = false local listF = nil local veil = nil
    local function close()
        open = false
        if listF then pcall(function() listF:Destroy() end) listF = nil end
        if veil then pcall(function() veil:Destroy() end) veil = nil end
    end
    if _G.__PULSE_DROPS == nil then _G.__PULSE_DROPS = {} end
    table.insert(_G.__PULSE_DROPS, close)
    pressFx(b, Color3.fromRGB(30, 30, 38))
    b.MouseButton1Click:Connect(function()
        if open then close() return end
        for _, fn in ipairs(_G.__PULSE_DROPS) do if fn ~= close then pcall(fn) end end
        open = true
        local layer = ScreenGui
        if type(layer) ~= "Instance" then open = false return end
        veil = Instance.new("TextButton")
        veil.Name = "DropVeil" veil.Size = UDim2.new(1, 0, 1, 0) veil.Position = UDim2.new(0, 0, 0, 0)
        veil.BackgroundTransparency = 1 veil.Text = "" veil.AutoButtonColor = false veil.ZIndex = 90
        veil.Parent = layer
        veil.MouseButton1Click:Connect(function() close() end)
        local fullH = #options * 26 + 8
        local targetH = math.min(fullH, 180)
        local bp = b.AbsolutePosition
        local bw = math.max(150, b.AbsoluteSize.X)
        local flip = false
        pcall(function()
            local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
            if vp and (bp.Y + b.AbsoluteSize.Y + 2 + targetH) > (vp.Y - 8) then flip = true end
        end)
        listF = Instance.new("ScrollingFrame")
        listF.Size = UDim2.new(0, bw, 0, 0)
        if flip then
            listF.Position = UDim2.new(0, bp.X + b.AbsoluteSize.X - bw, 0, bp.Y - 2)
            listF.AnchorPoint = Vector2.new(0, 1)
        else
            listF.Position = UDim2.new(0, bp.X + b.AbsoluteSize.X - bw, 0, bp.Y + b.AbsoluteSize.Y + 2)
        end
        listF.BackgroundColor3 = Color3.fromRGB(32,32,40)
        listF.BorderSizePixel = 0 listF.ZIndex = 91 listF.ClipsDescendants = true
        listF.ScrollBarThickness = 3 listF.ScrollingDirection = Enum.ScrollingDirection.Y
        listF.CanvasSize = UDim2.new(0, 0, 0, fullH) listF.AutomaticCanvasSize = Enum.AutomaticSize.None
        listF.Parent = layer
        local lc = Instance.new("UICorner") lc.CornerRadius = UDim.new(0, 6) lc.Parent = listF
        local pad = Instance.new("UIPadding")
        pad.PaddingLeft = UDim.new(0, 4) pad.PaddingRight = UDim.new(0, 4)
        pad.PaddingTop = UDim.new(0, 4) pad.PaddingBottom = UDim.new(0, 4)
        pad.Parent = listF
        local lay = Instance.new("UIListLayout") lay.Padding = UDim.new(0, 0) lay.SortOrder = Enum.SortOrder.LayoutOrder lay.Parent = listF
        for oidx, opt in ipairs(options) do
            local isSel = (b.Text == tostring(opt) .. "  v")
            local ob = Instance.new("TextButton") ob.LayoutOrder = oidx ob.Size = UDim2.new(1, 0, 0, 26) ob.BackgroundTransparency = 1
            ob.Text = (isSel and "✓ " or "") .. tostring(opt) ob.Font = Enum.Font.Gotham ob.TextSize = 12
            ob.TextColor3 = isSel and Color3.fromRGB(52, 199, 123) or Color3.fromRGB(235,235,240)
            ob.TextXAlignment = Enum.TextXAlignment.Left
            ob.TextTruncate = Enum.TextTruncate.AtEnd ob.AutoButtonColor = true
            ob.ZIndex = 92 ob.Parent = listF
            local op = Instance.new("UIPadding") op.PaddingLeft = UDim.new(0, 6) op.Parent = ob
            ob.MouseButton1Click:Connect(function() b.Text = tostring(opt) .. "  v" close() pcall(cb, opt) end)
        end
        tween(listF, {Size = UDim2.new(0, bw, 0, targetH)}, 0.15)
    end)
    reg(row, text)
    return b
end
function label(parent, text, size)
    local lb = Instance.new("TextLabel") lb.Size = UDim2.new(1, 0, 0, size or 22) lb.BackgroundTransparency = 1
    lb.Text = text lb.Font = Enum.Font.Gotham lb.TextSize = 13 lb.TextColor3 = Color3.fromRGB(70,70,82)
    lb.TextXAlignment = Enum.TextXAlignment.Left lb.TextWrapped = true lb.Parent = parent
    txtPop(lb)
    return lb
end
function playerList(parent, onTap, h)
    local f = Instance.new("ScrollingFrame") f.Size = UDim2.new(1, 0, 0, h or 140)
    f.BackgroundColor3 = Color3.fromRGB(35,35,43) f.BackgroundTransparency = 0.15 f.BorderSizePixel = 0 f.ScrollBarThickness = 2 f.AutomaticCanvasSize = Enum.AutomaticSize.Y f.CanvasSize = UDim2.new(0,0,0,0) f.Parent = parent
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 8) c.Parent = f
    local pad = Instance.new("UIPadding") pad.PaddingLeft = UDim.new(0,4) pad.PaddingRight = UDim.new(0,4) pad.PaddingTop = UDim.new(0,4) pad.PaddingBottom = UDim.new(0,4) pad.Parent = f
    local l = Instance.new("UIListLayout") l.Padding = UDim.new(0, 3) l.SortOrder = Enum.SortOrder.LayoutOrder l.Parent = f
    local empty = Instance.new("TextLabel") empty.Size = UDim2.new(1, 0, 0, 30) empty.BackgroundTransparency = 1
    empty.Text = "No players in the server" empty.Font = Enum.Font.Gotham empty.TextSize = 13
    empty.TextColor3 = Color3.fromRGB(80,80,92) empty.Parent = f
    txtPop(empty)
    local function refresh()
        for _, ch in pairs(f:GetChildren()) do if ch:IsA("TextButton") then ch:Destroy() end end
        local n = 0
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                n = n + 1 empty.Visible = false
                local b = Instance.new("TextButton") b.Size = UDim2.new(1, -6, 0, 30)
                b.BackgroundColor3 = Color3.fromRGB(50,50,60) b.Text = p.Name .. " (" .. getPlayerRole(p) .. ")"
                b.Font = Enum.Font.Gotham b.TextSize = 13 b.TextColor3 = Color3.fromRGB(235,235,240) b.TextTruncate = Enum.TextTruncate.AtEnd b.Parent = f
                local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 6) bc.Parent = b
                b.MouseButton1Click:Connect(function() pcall(onTap, p) end)
            end
        end
        if n == 0 then empty.Visible = true end
        f.CanvasSize = UDim2.new(0, 0, 0, n * 31 + 10)
    end
    Players.PlayerAdded:Connect(refresh) Players.PlayerRemoving:Connect(refresh)
    refresh()
    return {Refresh = refresh, Frame = f}
end
function waitBind(btn, cb)
    btn.Text = "..."
    local conn; conn = UserInputService.InputBegan:Connect(function(i, gp)
        if gp then return end
        if i.KeyCode ~= Enum.KeyCode.Unknown then
            conn:Disconnect() btn.Text = i.KeyCode.Name pcall(cb, i.KeyCode)
        end
    end)
end
PulseTweenSvc = PulseTweenSvc or game:GetService("TweenService")
function tween(obj, props, secs, style)
    pcall(function()
        PulseTweenSvc:Create(obj, TweenInfo.new(secs or 0.14, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
    end)
end
function makeDrag(frame, handle)
    local drag = handle or frame
    local dragging = false
    local startPos, startInput
    local connMove, connEnd
    drag.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startPos = frame.Position
            startInput = input.Position
            if connMove then pcall(function() connMove:Disconnect() end) connMove = nil end
            if connEnd then pcall(function() connEnd:Disconnect() end) connEnd = nil end
            connMove = UserInputService.InputChanged:Connect(function(inp)
                if not dragging then return end
                if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                    local d = inp.Position - startInput
                    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
                end
            end)
            connEnd = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    if connMove then pcall(function() connMove:Disconnect() end) connMove = nil end
                    if connEnd then pcall(function() connEnd:Disconnect() end) connEnd = nil end
                end
            end)
        end
    end)
end
function pressFx(btn, base)
    btn.MouseButton1Down:Connect(function()
        tween(btn, {BackgroundColor3 = Color3.fromRGB(18, 18, 24)}, 0.08)
    end)
    btn.MouseButton1Up:Connect(function()
        tween(btn, {BackgroundColor3 = base}, 0.12)
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, {BackgroundColor3 = base}, 0.15)
    end)
end
function txtPop(lb)
    pcall(function()
        lb.TextStrokeTransparency = 0.85
        lb.TextStrokeColor3 = Color3.fromRGB(240, 240, 245)
    end)
    return lb
end
uisStyle = "Glow"
mobBtns = {}
mobBtnPos = {}
function loadMobUis()
    pcall(function()
        if type(readfile) == "function" and type(isfile) == "function" and isfile("PULSITI/settings/mobuis.json") then
            local data = HttpService:JSONDecode(readfile("PULSITI/settings/mobuis.json"))
            if type(data) == "table" then
                for k, v in pairs(data) do
                    if type(v) == "table" then
                        mobBtnPos[k] = UDim2.new(tonumber(v[1]) or 0, tonumber(v[2]) or 0, tonumber(v[3]) or 0, tonumber(v[4]) or 0)
                    end
                end
            end
        end
    end)
end
pcall(loadMobUis)
function saveMobUis()
    pcall(function()
        if type(writefile) ~= "function" then return end
        local data = {}
        for k, e in pairs(mobBtns) do
            local p = e.frame.Position
            data[k] = {p.X.Scale, p.X.Offset, p.Y.Scale, p.Y.Offset}
        end
        writefile("PULSITI/settings/mobuis.json", HttpService:JSONEncode(data))
    end)
end
function applyUisStyleOne(e)
    pcall(function()
        if not e or not e.stroke then return end
        e.stroke.Parent = (uisStyle == "Glow") and e.frame or nil
    end)
end
function applyUisStyle()
    for _, e in pairs(mobBtns) do applyUisStyleOne(e) end
end
function getMobBtn(key, text, action, defPos)
    if mobBtns[key] then return mobBtns[key] end
    local f = Instance.new("Frame") f.Name = "Mob_" .. tostring(key)
    f.Size = UDim2.new(0, 62, 0, 62)
    f.Position = mobBtnPos[key] or defPos
    f.BackgroundColor3 = Color3.fromRGB(25, 25, 32) f.BackgroundTransparency = 0.15
    f.BorderSizePixel = 0 f.Visible = false f.Active = true f.Parent = ScreenGui
    local cn = Instance.new("UICorner") cn.CornerRadius = UDim.new(1, 0) cn.Parent = f
    local st = Instance.new("UIStroke") st.Color = Color3.fromRGB(255, 255, 255) st.Transparency = 0.55 st.Thickness = 1 st.Parent = f
    local b = Instance.new("TextButton") b.Size = UDim2.new(1, 0, 1, 0)
    b.BackgroundTransparency = 1 b.Text = tostring(text)
    b.Font = Enum.Font.GothamBold b.TextSize = 11 b.TextColor3 = Color3.fromRGB(235,235,240)
    b.TextTruncate = Enum.TextTruncate.AtEnd b.AutoButtonColor = false b.Parent = f
    local down, moved, startP, startI, mvC, endC
    local function stop()
        down = false
        if mvC then pcall(function() mvC:Disconnect() end) mvC = nil end
        if endC then pcall(function() endC:Disconnect() end) endC = nil end
    end
    b.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            stop()
            down = true moved = false startP = f.Position startI = inp.Position
            mvC = UserInputService.InputChanged:Connect(function(j)
                if not down then return end
                if j.UserInputType == Enum.UserInputType.MouseMovement or j.UserInputType == Enum.UserInputType.Touch then
                    local d = j.Position - startI
                    if d.Magnitude > 10 then moved = true end
                    if moved then
                        f.Position = UDim2.new(startP.X.Scale, startP.X.Offset + d.X, startP.Y.Scale, startP.Y.Offset + d.Y)
                    end
                end
            end)
            endC = inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End or inp.UserInputState == Enum.UserInputState.Cancel then
                    local wasMoved = moved
                    stop()
                    if wasMoved then saveMobUis()
                    else task.spawn(function() pcall(action) end) end
                end
            end)
        end
    end)
    local e = {frame = f, btn = b, stroke = st, key = key, def = defPos, visible = false}
    mobBtns[key] = e
    applyUisStyleOne(e)
    return e
end
function setMobBtn(key, vis)
    local e = mobBtns[key]
    if e then e.visible = (vis == true) e.frame.Visible = e.visible end
end
function mobBtnVisible(key)
    local e = mobBtns[key]
    return (e and e.visible) or false
end
function resetMobBtn(key)
    local e = mobBtns[key]
    if e then e.frame.Position = e.def saveMobUis() end
end
function resetMobUis()
    for _, e in pairs(mobBtns) do e.frame.Position = e.def end
    pcall(function()
        if type(delfile) == "function" then delfile("PULSITI/settings/mobuis.json") end
    end)
    mobBtnPos = {}
    notify("UIs", "Positions reset")
end
function mobRow(parent, key, title, text, action, defPos)
    getMobBtn(key, text, action, defPos)
    local g = toggleGear(parent, title, mobBtnVisible(key), function(s) setMobBtn(key, s) end)
    button(g.box, "Reset position", function() resetMobBtn(key) end)
    return g
end
kbPanel = nil
kbRows = {}
function bindName(k)
    if k and typeof(k) == "EnumItem" then
        local ok, n = pcall(function() return k.Name end)
        if ok and n then return tostring(n) end
    end
    return "None"
end
function refreshKeybinds()
    pcall(function()
        if not kbPanel or not kbPanel.Parent then return end
        local map = {
            noclip = noclipBind, bomb = bombJumpKey, fly = flyBind, spin = spinBind,
            bhop = bhopBind, invis = invisBind, shot = shootMurderKey, menu = menuBindKey,
        }
        for k, lb in pairs(kbRows) do
            if lb and lb.Parent and lb.Text ~= "..." then lb.Text = bindName(map[k]) end
        end
    end)
end
function setKeybindsVisible(vis)
    if vis and (not kbPanel or not kbPanel.Parent) then
        local p = Instance.new("Frame") p.Name = "Keybinds"
        p.Size = UDim2.new(0, 220, 0, 320) p.Position = UDim2.new(1, -232, 0.5, -160)
        p.BackgroundColor3 = Color3.fromRGB(38, 34, 28) p.BackgroundTransparency = 0.08
        p.BorderSizePixel = 0 p.Visible = false p.Active = true p.Parent = ScreenGui
        local cn = Instance.new("UICorner") cn.CornerRadius = UDim.new(0, 10) cn.Parent = p
        local hd = Instance.new("TextLabel") hd.Size = UDim2.new(1, 0, 0, 30)
        hd.BackgroundTransparency = 1 hd.Text = "⌨  Keybinds"
        hd.Font = Enum.Font.GothamBold hd.TextSize = 14 hd.TextColor3 = Color3.fromRGB(235,235,240)
        hd.TextXAlignment = Enum.TextXAlignment.Center hd.Parent = p
        local sep = Instance.new("Frame") sep.Size = UDim2.new(1, -24, 0, 1) sep.Position = UDim2.new(0, 12, 0, 32)
        sep.BackgroundColor3 = Color3.fromRGB(90, 80, 65) sep.BorderSizePixel = 0 sep.Parent = p
        local setters = {
            noclip = function(k) noclipBind = k end,
            bomb = function(k) bombJumpKey = k end,
            fly = function(k) flyBind = k end,
            spin = function(k) spinBind = k end,
            bhop = function(k) bhopBind = k end,
            invis = function(k) invisBind = k end,
            shot = function(k) shootMurderKey = k end,
            menu = function(k) menuBindKey = k end,
        }
        local defs = {
            {"noclip", "No Clip Key"}, {"bomb", "Auto Bomb Jump"}, {"fly", "Fly"},
            {"spin", "Spin Key"}, {"bhop", "Bhop Key"}, {"invis", "Invisible"},
            {"shot", "Shot Murder"}, {"menu", "Toggle Menu"},
        }
        local y = 38
        kbRows = {}
        for _, d in ipairs(defs) do
            local r = Instance.new("Frame") r.Size = UDim2.new(1, -24, 0, 30) r.Position = UDim2.new(0, 12, 0, y)
            r.BackgroundTransparency = 1 r.Parent = p
            local lb = Instance.new("TextLabel") lb.Size = UDim2.new(1, -70, 1, 0)
            lb.BackgroundTransparency = 1 lb.Text = d[2]
            lb.Font = Enum.Font.Gotham lb.TextSize = 12 lb.TextColor3 = Color3.fromRGB(210,205,195)
            lb.TextXAlignment = Enum.TextXAlignment.Left lb.TextTruncate = Enum.TextTruncate.AtEnd lb.Parent = r
            local pill = Instance.new("TextButton") pill.Size = UDim2.new(0, 64, 0, 22) pill.Position = UDim2.new(1, -64, 0.5, -11)
            pill.BackgroundColor3 = Color3.fromRGB(28, 26, 22) pill.Text = "None"
            pill.Font = Enum.Font.GothamBold pill.TextSize = 11 pill.TextColor3 = Color3.fromRGB(235,235,240)
            pill.TextTruncate = Enum.TextTruncate.AtEnd pill.AutoButtonColor = true pill.Parent = r
            local pc2 = Instance.new("UICorner") pc2.CornerRadius = UDim.new(0, 6) pc2.Parent = pill
            local key = d[1]
            pill.MouseButton1Click:Connect(function()
                waitBind(pill, function(k)
                    pcall(setters[key], k)
                    refreshKeybinds()
                end)
            end)
            kbRows[d[1]] = pill
            y = y + 32
        end
        p.Size = UDim2.new(0, 220, 0, y + 8)
        makeDrag(p)
        kbPanel = p
    end
    if kbPanel then kbPanel.Visible = (vis == true) end
    refreshKeybinds()
end
do
    local page = Pages["Main"]
    local c1, l1 = card(page, "ESP", 4, 258)
    local gEsp = toggleGear(l1, "Enable Role ESP", false, setESP)
    dropdown(gEsp.box, "Style ESP", {"Default","Outline","Filled","Glow (animated)","Pulse (animated)","Chams (through walls)","Ghost (animated)","Minimal"}, espStyle, function(v) espStyle = v end)
    local gTr = toggleGear(l1, "Tracers", tracersOn, function(s) tracersOn = s end)
    dropdown(gTr.box, "Origin", {"Bottom","Top","Center"}, tracerOrigin, function(v) tracerOrigin = v end)
    local gSk = toggleGear(l1, "Skeleton ESP", skelOn, function(s) skelOn = s end)
    toggle(gSk.box, "Skeleton Own Color", skelOwnColor, function(s) skelOwnColor = s end)
    dropdown(gSk.box, "Skeleton Color", EspColorNames, skelColorName, function(v) skelColorName = v end)
    slider(gSk.box, "Skeleton Saturation", skelSat, 0, 100, function(v) skelSat = v end)
    slider(gSk.box, "Skeleton Brightness", skelBright, 0, 100, function(v) skelBright = v end)
    toggle(l1, "Show Role Text", showRole, function(s) showRole = s end)
    toggle(l1, "Show Nickname", showNick, function(s) showNick = s end)
    toggle(l1, "Show Studs", showStuds, function(s) showStuds = s end)
    local gBx = toggleGear(l1, "Box ESP", boxOn, function(s) boxOn = s end)
    dropdown(gBx.box, "Style", {"Full","Corners"}, boxStyle, function(v) boxStyle = v end)
    toggle(gBx.box, "Box Own Color", boxOwnColor, function(s) boxOwnColor = s end)
    dropdown(gBx.box, "Box Color", EspColorNames, boxColorName, function(v) boxColorName = v end)
    slider(gBx.box, "Box Saturation", boxSat, 0, 100, function(v) boxSat = v end)
    slider(gBx.box, "Box Brightness", boxBright, 0, 100, function(v) boxBright = v end)
    toggle(l1, "Gun ESP", false, function(s) gunEspEnabled = s if not s then for _, o in pairs(gunEspObjects) do pcall(function() o:Destroy() end) end gunEspObjects = {} end end)
    local gXr = toggleGear(l1, "X-Ray", false, setXRay)
    slider(gXr.box, "X-Ray Strength", 50, 0, 100, function(v) xrayStrength = v / 100 if xrayEnabled then setXRay(false) setXRay(true) end end)
    local c2, l2 = card(page, "Movement", 270, 258)
    noclipTgl = toggle(l2, "No Clip", false, function(s) if s then StartNoclip() else StopNoclip() end end, "N", function(bb) waitBind(bb, function(k) noclipBind = k end) end)
    toggle(l2, "Infinite Jumps", false, function(s) if s then StartInfJump() else StopInfJump() end end)
    toggle(l2, "Anti-Fling", false, function(s) if s then StartAntiFling() else StopAntiFling() end end)
    local gBj = toggleGear(l2, "Bomb Jump", false, function(s) if s then StartBombJump() else StopBombJump() end end)
    keyRow(gBj.box, "Auto BombJump", "None", function(k) bombJumpKey = k end)
    local gFly = toggleGear(l2, "Fly", false, function(s) _flyArmed = s if s then notify("Fly", "Fly armed - press your bind") else if flyActive then StopFly() end end end, "F", function(bb) waitBind(bb, function(k) flyBind = k end) end)
    slider(gFly.box, "Fly Speed", 48, 10, 300, function(v) flySpeed = v end)
    label(gFly.box, "Fly Animation: under maintenance")
    local gSp = toggleGear(l2, "Spin", false, function(s) if s then ApplySpin(spinSpeed) else ApplySpin(0) end end, "None", function(bb) waitBind(bb, function(k) spinBind = k end) end)
    spinTgl = gSp
    slider(gSp.box, "Spin Speed", 50, 1, 100, function(v) spinSpeed = v if spinActive then ApplySpin(v) end end)
    local gBh = toggleGear(l2, "Bhop", false, function(s) if s then StartBhop() else StopBhop() end end, "None", function(bb) waitBind(bb, function(k) bhopBind = k end) end)
    bhopTgl = gBh
    slider(gBh.box, "Bhop Power", 5, 1, 15, function(v) bhopPower = v bhopSpeed = v * 10 end)
    toggle(gBh.box, "Bhop Sound", false, function(s) bhopSound = s if s and #PulseSoundFiles == 0 then notify("Bhop Sound", "Drop a sound in PULSITI/custom sounds") end end)
    invisTgl = toggle(l2, "Invisible", false, setInvisible, "G", function(bb) waitBind(bb, function(k) invisBind = k end) end)
    PageCards = PageCards or {}
    local cU, lU = card(page, "UIs / Mobile", 4, 520)
    label(lU, "On-screen buttons (mobile). Hold & drag a button to move it, tap to use.")
    label(lU, "Buttons Style")
    dropdown(lU, "UIS Style", {"Glow", "Flat"}, uisStyle, function(v) uisStyle = v applyUisStyle() end)
    mobRow(lU, "fly", "Fly Button", "Fly", function()
        if flyActive then StopFly() else StartFly() end
    end, UDim2.new(1, -84, 0.32, -31))
    mobRow(lU, "bhop", "Bhop Button", "Bhop", function()
        if bhopActive then StopBhop() else StartBhop() end
    end, UDim2.new(1, -84, 0.44, -31))
    mobRow(lU, "flingsheriff", "Fling Sheriff Button", "F Sher", function()
        for _, p in ipairs(Players:GetPlayers()) do
            if getPlayerRole(p) == "Sheriff" and aimAlive(p) then FlingSingle(p) notify("UIs", "Fling: " .. p.Name) return end
        end
        notify("UIs", "No sheriff")
    end, UDim2.new(1, -84, 0.56, -31))
    mobRow(lU, "flingmurder", "Fling Murderer Button", "F Murd", function()
        local m = GetMurderer()
        if m and aimAlive(m) then FlingSingle(m) notify("UIs", "Fling: " .. m.Name) else notify("UIs", "No murderer") end
    end, UDim2.new(1, -84, 0.68, -31))
    mobRow(lU, "shot", "Shot Murder Button", "Shot", function()
        shootKeyPressed()
    end, UDim2.new(1, -84, 0.80, -31))
    mobRow(lU, "killmurder", "Kill All Murder Button", "Kill", function()
        local n = 0
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and getPlayerRole(p) == "Murderer" and aimAlive(p) then killTargetRemote(p) n = n + 1 task.wait(0.1) end
        end
        notify("UIs", n > 0 and ("Murder killed: " .. tostring(n)) or "No murderer")
    end, UDim2.new(1, -162, 0.32, -31))
    mobRow(lU, "invis", "Invisible Button", "Invis", function()
        setInvisible(not invisibleActive)
    end, UDim2.new(1, -162, 0.44, -31))
    mobRow(lU, "knife", "Knife Throw Button", "Knife", function()
        KnifeThrow(nil)
    end, UDim2.new(1, -162, 0.56, -31))
    mobRow(lU, "bomb", "Auto Bomb Jump Button", "Bomb", function()
        if bombJumpActive then StopBombJump() else StartBombJump() end
    end, UDim2.new(1, -162, 0.68, -31))
    button(lU, "Reset UIS Position", resetMobUis)
    toggle(lU, "Show Ping/Fps UI", true, function(s) if hudStats then hudStats.Visible = s end end)
    toggle(lU, "Show Round Timer", true, function(s) if hudRound then hudRound.Visible = s end end)
    toggle(lU, "Show Keybinds", false, function(s) setKeybindsVisible(s) end)
    PageCards["Main"] = {general = {c1, c2}, uis = {cU}}
end
killSelected = nil
do
    local page = Pages["Combat"]
    local c1, l1 = card(page, "Sheriff", 4, 258)
    toggle(l1, "Auto Pickup Gun", false, function(s) autoGunEnabled = s notify("Stealth TP", s and "Auto gun ON (remote)" or "Auto gun OFF") end)
    local gSilent = toggleGear(l1, "Silent Aim", false, function(s) silentAimEnabled = s notify("Silent Aim", s and "Press E / Shot" or "OFF") end)
    toggle(gSilent.box, "Wallbang", false, function(s) wallbangOn = s notify("Wallbang", s and "Shoot through walls ON" or "OFF") end)
    toggle(gSilent.box, "Auto Shoot Murder", false, function(s) autoShootMurder = s end)
    toggle(gSilent.box, "Fling Murder", false, function(s) flingMurderOn = s end)
    toggle(gSilent.box, "Auto Fling Sheriff", false, function(s) autoFlingSheriff = s if s then sheriffFlungName = nil end end)
    label(gSilent.box, "Tip: enable Auto Pickup Gun with Auto Fling Sheriff.")
    label(gSilent.box, "AimBot")
    dropdown(gSilent.box, "Aim Version", {"V1 (Pulse)", "V2 (Silent)", "V3 (Adaptive)"}, aimVersion, function(v) aimVersion = v end)
    toggle(gSilent.box, "Resolver", false, function(s) resolverOn = s end)
    label(gSilent.box, "Resolver smooths target jitter (anti-aim / spin) for better prediction.")
    dropdown(gSilent.box, "Aimbot Type", {"Classic", "Universal (Cam Lock)", "Flick Shot"}, aimbotType, function(v) aimbotType = v end)
    label(gSilent.box, "Classic: silent shot. Universal: hold key = cam lock. Flick: snap, shoot, return.")
    slider(gSilent.box, "Flick Speed", flickSpeed, 1, 100, function(v) flickSpeed = v end)
    toggle(gSilent.box, "Flick With Mouse", false, function(s) flickWithMouse = s end)
    slider(gSilent.box, "Flick Return %", flickReturn, 0, 100, function(v) flickReturn = v end)
    slider(gSilent.box, "Prediction (ms)", predictionMs, 0, 200, function(v) predictionMs = v end)
    keyRow(gSilent.box, "Shoot Murder", "E", function(k) shootMurderKey = k end)
    label(l1, "AimBot FOV")
    local gFovC = toggleGear(l1, "Show FOV Circle", false, function(s) showFov = s end)
    slider(gFovC.box, "FOV Size", aimFov, 20, 400, function(v) aimFov = v savePulseConfig() end)
    slider(gFovC.box, "FOV Transparency", fovTransp, 0, 100, function(v) fovTransp = v end)
    slider(gFovC.box, "FOV Color", fovColorH, 0, 360, function(v) fovColorH = v end)
    label(l1, "Custom Sounds")
    do
        local shotOpts, killOpts = buildSoundLists()
        customShotName = shotOpts[1]
        killSoundName = killOpts[1]
        dropdown(l1, "Shot Sound", shotOpts, shotOpts[1], function(v) customShotName = v end)
    end
    button(l1, "Preview Shot", playCustomShot)
    do
        local _, killOpts = buildSoundLists()
        dropdown(l1, "Kill Sound", killOpts, killOpts[1], function(v) killSoundName = v end)
    end
    button(l1, "Preview Kill", playKillSound)
    slider(l1, "Sound Volume", soundVolume, 0, 100, function(v) soundVolume = v end)
    label(l1, "Anti-Aim")
    betaRow(l1, "Fake Position")
    toggle(l1, "Shot Button (UIs tab)", mobBtnVisible("shot"), function(s) setMobBtn("shot", s) end)
    local c2, l2 = card(page, "Murder", 270, 258)
    toggle(l2, "Kill Aura", false, function(s) killAuraActive = s end)
    slider(l2, "Aura Radius", 18, 5, 60, function(v) killAuraRadius = v end)
    button(l2, "Kill All", KillAll)
    button(l2, "Kill Only Sheriff", KillSheriff)
    button(l2, "Knife Throw", function() KnifeThrow(killSelected) end)
    toggle(l2, "Knife Throw Aimbot", false, function(s) knifeThrowAimbot = s end)
    label(l2, "Kill Player (tap to select)")
    local selLbl = label(l2, "Selected: none")
    playerList(l2, function(p)
        killSelected = p
        selLbl.Text = "Selected: " .. p.Name
        notify("Kill", "Selected " .. p.Name)
    end, 150)
    button(l2, "Kill Selected", function()
        if killSelected and killSelected.Parent then killTargetRemote(killSelected)
        else killSelected = nil selLbl.Text = "Selected: none" notify("Kill", "Select player") end
    end)
end
statSession, statCoinsDay, statTotal, statStatus = nil, nil, nil, nil
do
    local page = Pages["Auto Farm"]
    local stats = Instance.new("Frame") stats.Size = UDim2.new(1, -8, 0, 112) stats.Position = UDim2.new(0, 4, 0, 0)
    stats.BackgroundColor3 = Color3.fromRGB(150,150,160) stats.BackgroundTransparency = 0.45 stats.BorderSizePixel = 0 stats.ClipsDescendants = true stats.ZIndex = 2 stats.Parent = page
    local sc = Instance.new("UICorner") sc.CornerRadius = UDim.new(0, 10) sc.Parent = stats
    local sst = Instance.new("UIStroke") sst.Color = Color3.fromRGB(255, 255, 255) sst.Transparency = 0.45 sst.Thickness = 1 sst.Parent = stats
    local st = Instance.new("TextLabel") st.Size = UDim2.new(1, -16, 0, 24) st.Position = UDim2.new(0, 12, 0, 4)
    st.BackgroundTransparency = 1 st.Text = "Stats" st.Font = Enum.Font.GothamBold st.TextSize = 14
    st.TextColor3 = Color3.fromRGB(45,45,55) st.TextXAlignment = Enum.TextXAlignment.Left st.TextTruncate = Enum.TextTruncate.AtEnd st.Parent = stats
    txtPop(st)
    local function statCell(px, py)
        local v = Instance.new("TextLabel") v.Size = UDim2.new(0.5, -14, 0, 20) v.Position = UDim2.new(px, px == 0 and 12 or 0, 0, py)
        v.BackgroundTransparency = 1 v.Text = "0" v.Font = Enum.Font.GothamBold v.TextSize = 16
        v.TextColor3 = Color3.fromRGB(40,40,50) v.TextXAlignment = Enum.TextXAlignment.Left
        v.TextTruncate = Enum.TextTruncate.AtEnd v.Parent = stats
        txtPop(v)
        local c = Instance.new("TextLabel") c.Size = UDim2.new(0.5, -14, 0, 14) c.Position = UDim2.new(px, px == 0 and 12 or 0, 0, py + 20)
        c.BackgroundTransparency = 1 c.Text = "" c.Font = Enum.Font.Gotham c.TextSize = 11
        c.TextColor3 = Color3.fromRGB(75,75,88) c.TextXAlignment = Enum.TextXAlignment.Left
        c.TextTruncate = Enum.TextTruncate.AtEnd c.Parent = stats
        txtPop(c)
        return v, c
    end
    statSession, statSessionC = statCell(0, 30)
    statSessionC.Text = "Session"
    statCoinsDay, statCoinsDayC = statCell(0.5, 30)
    statCoinsDayC.Text = "Coins / day"
    statTotal, statTotalC = statCell(0, 68)
    statTotalC.Text = "Total"
    statStatus, statStatusC = statCell(0.5, 68)
    statStatusC.Text = "Status"
    task.spawn(function()
        while task.wait(0.5) do
            if PULSITI_UNLOADED then break end
            pcall(function()
                if statSession then statSession.Text = tostring(farmSession) end
                if statCoinsDay then statCoinsDay.Text = tostring(farmSession) end
                if statTotal then statTotal.Text = tostring(farmTotal) end
                if statStatus then statStatus.Text = tostring(farmStatus) end
            end)
        end
    end)
    local c2, l2 = card(page, "Farm", 4, 520)
    c2.Position = UDim2.new(0, 4, 0, 120)
    dropdown(l2, "Farm Version", {"V1 (classic)","V2 (fast, prone)"}, farmVersion, function(v) farmVersion = v savePulseConfig() end)
    label(l2, "23 and above is detected by the game and gets you kicked. 21 is the safe sweet spot.")
    slider(l2, "Farm Speed", farmSpeed, 5, 40, function(v) farmSpeed = v savePulseConfig() if v >= 23 then notify("Farm", "23+ kicks! 21 is safe", 3) end end)
    toggle(l2, "Auto Farm", false, function(s) if s then StartFarm() else StopFarm() end end)
    toggle(l2, "Auto-Respawn on full bag", autoRespawnBag, function(s) autoRespawnBag = s savePulseConfig() end)
    toggle(l2, "Avoid Murderer", avoidMurder, function(s) avoidMurder = s savePulseConfig() end)
    toggle(l2, "Auto-Fling Murder after respawn", autoFlingRespawn, function(s) autoFlingRespawn = s savePulseConfig() end)
    toggle(l2, "Kill all on full bag (murder role)", killAllFullBag, function(s) killAllFullBag = s savePulseConfig() end)
end
do
    local page = Pages["Teleport"]
    local c1, l1 = card(page, "TP Role", 4, 258)
    button(l1, "Tp Lobby", TpLobby)
    button(l1, "Tp Murderer", function() local m = GetRolePlayers("murderer") if #m > 0 then TeleportToPlayer(m[1]) else notify("TP", "No murderer") end end)
    button(l1, "Tp Sheriff", function() local m = GetRolePlayers("sheriff") if #m > 0 then TeleportToPlayer(m[1]) else notify("TP", "No sheriff") end end)
    button(l1, "Teleport Tool", function()
        if tpToolRef and tpToolRef.Parent then notify("TP Tool", "Already in backpack") return end
        if tpToolConn then pcall(function() tpToolConn:Disconnect() end) tpToolConn = nil end
        local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
        if not bp then notify("TP Tool", "No backpack") return end
        local t = Instance.new("Tool") t.Name = "Teleport Tool" t.RequiresHandle = false t.CanBeDropped = false
        tpToolRef = t
        t.Equipped:Connect(function()
            local mm = LocalPlayer:GetMouse()
            if tpToolConn then pcall(function() tpToolConn:Disconnect() end) end
            tpToolConn = mm.Button1Down:Connect(function()
                if not t:IsDescendantOf(LocalPlayer.Character) then return end
                pcall(function()
                    local char = LocalPlayer.Character
                    local hum = char and getHumanoid(char)
                    if hum and hum.SeatPart then hum.Sit = false task.wait(0.1) end
                    local hip = (hum and hum.HipHeight > 0) and (hum.HipHeight + 1) or 4
                    local root = char and getRoot(char)
                    if not root then return end
                    local hit = mm.Hit
                    root.CFrame = CFrame.new(hit.Position, Vector3.new(root.Position.X, hit.Position.Y, root.Position.Z)) * CFrame.Angles(0, math.pi, 0) + Vector3.new(0, hip, 0)
                    root.Velocity = Vector3.new()
                    root.AssemblyLinearVelocity = Vector3.new()
                end)
            end)
        end)
        t.Unequipped:Connect(function()
            if tpToolConn then pcall(function() tpToolConn:Disconnect() end) tpToolConn = nil end
        end)
        t.Destroying:Connect(function()
            if tpToolConn then pcall(function() tpToolConn:Disconnect() end) tpToolConn = nil end
            if tpToolRef == t then tpToolRef = nil end
        end)
        t.Parent = bp
        notify("TP Tool", "Equip tool and click to teleport")
    end)
    local c2, l2 = card(page, "TP Player", 270, 258)
    playerList(l2, TeleportToPlayer, 220)
end
gbangName = ""
do
    local page = Pages["Troll Fun"]
    local c1, l1 = card(page, "Troll", 4, 258)
    toggle(l1, "Jerk Off", false, function(s) if s then StartJerk() else StopJerk() end end)
    toggle(l1, "Touch Fling", false, function(s) touchFlingActive = s end)
    toggle(l1, "Click Fling", false, function(s) clickFlingActive = s end)
    toggle(l1, "Click Hump", false, function(s)
        clickHumpActive = s
        if s then notify("Hump", "Click a player: tab Fling Players -> tap") else StopBang() end
    end)
    slider(l1, "Hump Duration (0 = hold)", 0, 0, 30, function(v) humpDuration = v end)
    toggle(l1, "Orbit", false, setOrbit)
    slider(l1, "Orbit Speed", 5, 1, 20, function(v) orbitSpeed = v end)
    local gb = Instance.new("TextBox") gb.Size = UDim2.new(1, 0, 0, 28) gb.BackgroundColor3 = Color3.fromRGB(30,30,38)
    gb.TextColor3 = Color3.fromRGB(235,235,240) gb.PlaceholderText = "GBang: player name..." gb.PlaceholderColor3 = Color3.fromRGB(170,170,180) gb.Text = "" gb.Font = Enum.Font.Gotham gb.TextSize = 12 gb.ClipsDescendants = true gb.Parent = l1
    local gc = Instance.new("UICorner") gc.CornerRadius = UDim.new(0, 8) gc.Parent = gb
    gb:GetPropertyChangedSignal("Text"):Connect(function() gbangName = gb.Text end)
    toggle(l1, "GBang / Hump Player", false, function(s) if s then if gbangName ~= "" then StartBang(gbangName) else notify("GBang", "Enter name") end else StopBang() end end)
    toggle(l1, "Player Menu", false, setPlayerMenu)
    local c2, l2 = card(page, "Fun", 270, 258)
    label(l2, "Auto Emote: 🔧 under maintenance")
    label(l2, "Equip Toy")
    button(l2, "Equip Selected", function()
        local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
        if bp then
            for _, t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then equipToy(t.Name) return end end
        end
        notify("Toy", "Backpack empty")
    end)
    button(l2, "Unequip", unequipTools)
    label(l2, "Fake Items")
    toggle(l2, "Fake Korblox", false, setFakeKorblox)
    toggle(l2, "Fake Headless", false, setFakeHeadless)
    label(l2, "Movement")
    toggle(l2, "Walk Speed", false, function(s) walkSpeedEnabled = s applyWalkSpeed() savePulseConfig() end)
    slider(l2, "Walk Speed", walkSpeedValue, 8, 100, function(v) walkSpeedValue = v if walkSpeedEnabled then applyWalkSpeed() end savePulseConfig() end)
    PageCards = PageCards or {}
    local phM = subPlaceholder(page, "Music", "Music - soon.")
    PageCards["Troll Fun"] = {troll = {c1, c2}, music = {phM}}
end
do
    local page = Pages["Free anims"]
    local c2, l2 = card(page, "Bundles / Animation options", 4, 520)
    label(l2, "🔧 Under maintenance")
    label(l2, "OLDSCHOOL / STYLISH / TOY packs - soon.")
    button(l2, "Stop Animation", function() if animTrack then pcall(function() animTrack:Stop() end) end if emoteTrack then pcall(function() emoteTrack:Stop() end) end end)
    PageCards = PageCards or {}
    local phE = subPlaceholder(page, "Emotes", "Emotes - soon.")
    local phF = subPlaceholder(page, "Favs", "Favs - soon.")
    PageCards["Free anims"] = {bundles = {c2}, emotes = {phE}, favs = {phF}}
end
do
    local page = Pages["Fling Players"]
    local c0, l0 = card(page, "Fling Players", 4, 520)
    label(l0, "Tap a player to fling them")
    toggle(l0, "Multi Fling Mode (all tapped)", false, function(s) FlingActive = s if not s then FlingTargets = {} end end)
    playerList(l0, function(p)
        if FlingActive then
            FlingTargets[p.Name] = p
            task.spawn(function() while FlingActive and FlingTargets[p.Name] do SkidFling(p) task.wait(0.5) end end)
            notify("Fling", "Flinging " .. p.Name)
        else FlingSingle(p) notify("Fling", p.Name) end
    end, 300)
end
do
    local page = Pages["Visuals"]
    local c1, l1 = card(page, "Shaders", 4, 258)
    toggle(l1, "Shader Pack", false, function(s) if s then ApplyShader("Evening") else ApplyShader("None") end end)
    for _, sh in ipairs({"Morning","Midday","Evening","Night"}) do
        toggle(l1, sh, false, function(s) if s then ApplyShader(sh) else ApplyShader("None") end end)
    end
    label(l1, "Spirit Realm / Storm: 🔧 under maintenance")
    toggle(l1, "FPS Boost", false, function(s) if s then EnableFPSBoost() else DisableFPSBoost() end end)
    local c2, l2 = card(page, "Atmosphere", 270, 258)
    toggle(l2, "Clear Atmosphere", false, setClearAtmo)
    label(l2, "Custom Skies")
    label(l2, "🔧 Under maintenance")
    label(l2, "Anime / Pink / Heavenly / Realistic / Rain - soon.")
    local c3, l3 = card(page, "Aura", 4, 258)
    c3.Position = UDim2.new(0, 4, 0, 320)
    task.defer(function()
        pcall(function()
            local h1 = c1.AbsoluteSize.Y
            if h1 > 50 then
                c3.Position = UDim2.new(0, 4, 0, h1 + 8)
            end
        end)
    end)
    toggle(l3, "Aura Enabled", false, setAura)
    for _, n in ipairs(aura_order) do
        toggle(l3, "Aura: " .. n:upper(), false, function(s) auraSelected[n] = s if auraActive then applyAuraFn() end end)
    end
    slider(l3, "Aura R", 133, 0, 255, function(v) auraColorValues.R = v if auraActive then applyAuraFn() end end)
    slider(l3, "Aura G", 220, 0, 255, function(v) auraColorValues.G = v if auraActive then applyAuraFn() end end)
    slider(l3, "Aura B", 255, 0, 255, function(v) auraColorValues.B = v if auraActive then applyAuraFn() end end)
    PageCards = PageCards or {}
    PageCards["Visuals"] = {shaders = {c1, c2}, extras = {c3}}
end
function showUnloadMessage()
    pcall(function()
        local g = Instance.new("ScreenGui") g.Name = "PULSE_Bye" g.ResetOnSpawn = false g.Parent = getUiParent()
        local f = Instance.new("Frame")
        f.Size = UDim2.new(0, 300, 0, 110) f.Position = UDim2.new(0.5, -150, 0.5, -55)
        f.BackgroundColor3 = Color3.fromRGB(20, 20, 26) f.BackgroundTransparency = 0.06
        f.BorderSizePixel = 0 f.Parent = g
        local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 12) c.Parent = f
        local st = Instance.new("UIStroke") st.Color = Color3.fromRGB(85, 85, 100) st.Transparency = 0.3 st.Thickness = 1 st.Parent = f
        local gr = Instance.new("UIGradient") gr.Color = ColorSequence.new(Color3.fromRGB(38, 38, 48), Color3.fromRGB(20, 20, 26)) gr.Rotation = 90 gr.Parent = f
        local t1 = Instance.new("TextLabel")
        t1.Size = UDim2.new(1, 0, 0, 30) t1.Position = UDim2.new(0, 0, 0, 12)
        t1.BackgroundTransparency = 1 t1.Text = "PULSITI"
        t1.Font = Enum.Font.GothamBold t1.TextSize = 17 t1.TextColor3 = Color3.fromRGB(90, 140, 255)
        t1.Parent = f
        local t2 = Instance.new("TextLabel")
        t2.Size = UDim2.new(1, -32, 0, 44) t2.Position = UDim2.new(0, 16, 0, 44)
        t2.BackgroundTransparency = 1 t2.Text = "Unloaded clean. Character and atmosphere restored. See you soon!"
        t2.Font = Enum.Font.Gotham t2.TextSize = 12 t2.TextColor3 = Color3.fromRGB(200, 200, 210)
        t2.TextWrapped = true t2.Parent = f
        task.spawn(function()
            task.wait(3)
            tween(f, {BackgroundTransparency = 1}, 0.4)
            tween(t1, {TextTransparency = 1}, 0.4)
            tween(t2, {TextTransparency = 1}, 0.4)
            tween(st, {Transparency = 1}, 0.4)
            task.wait(0.45)
            pcall(function() g:Destroy() end)
        end)
    end)
end
function fullUnloadPulse()
    if _G.__PULSITI_UNLOADED then return end
    _G.__PULSITI_UNLOADED = true
    PULSITI_UNLOADED = true
    print("[PULSITI] unload start")
    pcall(StopFarm)
    pcall(StopNoclip)
    pcall(StopInfJump)
    pcall(StopAntiFling)
    pcall(StopBombJump)
    pcall(StopFly)
    pcall(function() ApplySpin(0) end)
    pcall(StopBhop)
    pcall(StopJerk)
    pcall(StopBang)
    pcall(function() setOrbit(false) end)
    pcall(function() setPlayerMenu(false) end)
    pcall(function() setInvisible(false) end)
    pcall(function() setAura(false) end)
    pcall(function() clearAura() end)
    pcall(function() ApplyShader("None") end)
    pcall(DisableFPSBoost)
    pcall(function() setClearAtmo(false) end)
    pcall(function() setESP(false) end)
    pcall(function() setXRay(false) end)
    pcall(clearEspDraw)
    pcall(function() if tpToolConn then tpToolConn:Disconnect() tpToolConn = nil end end)
    pcall(function() if tpToolRef then tpToolRef:Destroy() tpToolRef = nil end end)
    pcall(function() setFakeKorblox(false) end)
    pcall(function() setFakeHeadless(false) end)
    pcall(function() camLockStop() end)
    pcall(function() if camLockConn then camLockConn:Disconnect() camLockConn = nil end camLockHeld = false end)
    pcall(function()
        silentAimEnabled = false autoGunEnabled = false showFov = false
        killAuraActive = false knifeThrowAimbot = false
        wallbangOn = false autoShootMurder = false flingMurderOn = false autoFlingSheriff = false
        murderFlingBusy = false sheriffFlungName = nil lastMurderTrack = nil
        touchFlingActive = false clickFlingActive = false clickHumpActive = false
        FlingActive = false FlingTargets = {}
        tracersOn = false skelOn = false boxOn = false
        gunEspEnabled = false
        walkSpeedEnabled = false
        autoEmoteActive = false
        _flyArmed = false
        noclipTgl = nil bhopTgl = nil spinTgl = nil
    end)
    pcall(function()
        restoreCharacter()
        restoreLighting()
        if invisPlatform then pcall(function() invisPlatform:Destroy() end) invisPlatform = nil end
        if spinInstance then pcall(function() spinInstance:Destroy() end) spinInstance = nil end
        if jerkTool then pcall(function() jerkTool:Destroy() end) jerkTool = nil end
        if jerkTrack then pcall(function() jerkTrack:Stop() end) jerkTrack = nil end
        if bangTrack then pcall(function() bangTrack:Stop() end) bangTrack = nil end
        if emoteTrack then pcall(function() emoteTrack:Stop() end) emoteTrack = nil end
        if typeof(animTrack) == "Instance" then pcall(function() animTrack:Stop() end) end
    end)
    pcall(function()
        for _, h in pairs(Highlights) do pcall(function() h:Destroy() end) end
        table.clear(Highlights)
        for _, o in pairs(gunEspObjects) do pcall(function() o:Destroy() end) end
        gunEspObjects = {}
        for _, h in pairs(XRayHighlights) do pcall(function() h:Destroy() end) end
        table.clear(XRayHighlights)
        if espAdvConn then pcall(function() espAdvConn:Disconnect() end) espAdvConn = nil end
        if xrayConn then pcall(function() xrayConn:Disconnect() end) xrayConn = nil end
        if noclipConn then pcall(function() noclipConn:Disconnect() end) noclipConn = nil end
        if infJumpConn then pcall(function() infJumpConn:Disconnect() end) infJumpConn = nil end
        if antiFlingConn then pcall(function() antiFlingConn:Disconnect() end) antiFlingConn = nil end
        if bombJumpConn then pcall(function() bombJumpConn:Disconnect() end) bombJumpConn = nil end
        if flyKeyDown then pcall(function() flyKeyDown:Disconnect() end) flyKeyDown = nil end
        if flyKeyUp then pcall(function() flyKeyUp:Disconnect() end) flyKeyUp = nil end
        if bhopConn then pcall(function() bhopConn:Disconnect() end) bhopConn = nil end
        if fpsBoostConn then pcall(function() fpsBoostConn:Disconnect() end) fpsBoostConn = nil end
        if orbitConn then pcall(function() orbitConn:Disconnect() end) orbitConn = nil end
        if shaderLoop then pcall(function() shaderLoop:Disconnect() end) shaderLoop = nil end
        for _, c in pairs(bangConns) do pcall(function() c:Disconnect() end) end
        bangConns = {}
        if fovCircle then
            pcall(function()
                if typeof(fovCircle) == "Instance" then fovCircle:Destroy()
                else fovCircle:Remove() end
            end)
            fovCircle = nil
        end
        if FarmThread then pcall(coroutine.close, FarmThread) FarmThread = nil end
    end)
    pcall(function() if playerMenuPanel then playerMenuPanel:Destroy() playerMenuPanel = nil end end)
    pcall(function() if kbPanel then kbPanel:Destroy() kbPanel = nil end end)
    pcall(function() if toastGui then toastGui:Destroy() toastGui = nil end end)
    pcall(function()
        if fovCircle then fovCircle.Visible = false fovCircle:Remove() fovCircle = nil end
    end)
    pcall(function() if fovGuiRoot then fovGuiRoot:Destroy() fovGuiRoot = nil end fovGuiCircle = nil fovGuiStroke = nil end)
    pcall(function() if hudFpsConn then hudFpsConn:Disconnect() hudFpsConn = nil end end)
    pcall(function() if hudGui then hudGui:Destroy() hudGui = nil end end)
    pcall(function() if ScreenGui then ScreenGui:Destroy() ScreenGui = nil end end)
    MainFrameRef = nil
    showUnloadMessage()
    print("[PULSITI] unload done")
end
do
    local page = Pages["Settings"]
    local c1, l1 = card(page, "UI", 4, 520)
    dropdown(l1, "UI Theme", {"Gray","Dark","Blue"}, "Gray", function(v)
        uiTheme = v
        if v == "Dark" then ACCENT = Color3.fromRGB(120,120,255)
        elseif v == "Blue" then ACCENT = Color3.fromRGB(80,160,255)
        else ACCENT = Color3.fromRGB(52,199,123) end
    end)
    slider(l1, "UI Size", 100, 70, 130, function(v) UIScale.Scale = v/100 end)
    slider(l1, "Screen Stretch", 100, 50, 150, function(v) MainFrame.Size = UDim2.new(0, 750*v/100, 0, 460*v/100) end)
    dropdown(l1, "Menu Font", {"Gotham","Code","Legacy"}, "Gotham", function() end)
    slider(l1, "Menu Text Size", 100, 80, 130, function() end)
    local bindRow = Instance.new("Frame") bindRow.Size = UDim2.new(1, 0, 0, 30) bindRow.BackgroundTransparency = 1 bindRow.ClipsDescendants = true bindRow.Parent = l1
    local bl = Instance.new("TextLabel") bl.Size = UDim2.new(0.6, 0, 1, 0) bl.BackgroundTransparency = 1 bl.Text = "Toggle Menu"
    bl.Font = Enum.Font.Gotham bl.TextSize = 12 bl.TextColor3 = Color3.fromRGB(60,60,70) bl.TextXAlignment = Enum.TextXAlignment.Left bl.TextTruncate = Enum.TextTruncate.AtEnd bl.Parent = bindRow
    local bb = Instance.new("TextButton") bb.Size = UDim2.new(0, 110, 0, 24) bb.Position = UDim2.new(1, -110, 0.5, -12)
    bb.BackgroundColor3 = Color3.fromRGB(28,28,34) bb.Text = "LeftControl" bb.Font = Enum.Font.GothamBold bb.TextSize = 11
    bb.TextColor3 = Color3.fromRGB(235,235,240) bb.TextTruncate = Enum.TextTruncate.AtEnd bb.Parent = bindRow
    local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 6) bc.Parent = bb
    bb.MouseButton1Click:Connect(function() waitBind(bb, function(k) menuBindKey = k end) end)
    dropdown(l1, "Language", {"English"}, "English", function() end)
    button(l1, "Reset Config (clean)", resetPulseConfig)
    local c2, l2 = card(page, "Unload", 4, 520)
    c2.Position = UDim2.new(0, 4, 0, 420)
    task.defer(function()
        pcall(function()
            local h1 = c1.AbsoluteSize.Y
            if h1 > 50 then c2.Position = UDim2.new(0, 4, 0, h1 + 8) end
        end)
    end)
    label(l2, "Полностью выгружает скрипт: стоп всех функций, чистка ESP/аур и снос меню.")
    button(l2, "Unload Script (full)", function() fullUnloadPulse() end)
    PageCards = PageCards or {}
    PageCards["Settings"] = {c1 = c1, c2 = c2}
end
do
    local page = Pages["Server"]
    local c1, l1 = card(page, "Server", 4, 258)
    local srvStatus = label(l1, "Ready")
    button(l1, "Rejoin Server", function()
        srvStatus.Text = "Rejoining..."
        pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
    end)
    button(l1, "Server Hop", function()
        srvStatus.Text = "Hopping..."
        pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
    end)
    button(l1, "Join Small Server", function()
        srvStatus.Text = "Searching..."
        task.spawn(function()
            local ok, servers = pcall(function()
                local reqFn = (request or http_request or (syn and syn.request) or (http and http.request))
                local url = "https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?limit=100"
                local body
                if reqFn then
                    local r = reqFn({Url = url, Method = "GET"})
                    body = r.Body or r.body
                else
                    body = HttpService:GetAsync(url)
                end
                return HttpService:JSONDecode(body).data
            end)
            if not ok or type(servers) ~= "table" then
                srvStatus.Text = "Failed (http blocked)"
                notify("Server", "Could not fetch server list")
                return
            end
            local best = nil
            for _, s in ipairs(servers) do
                if tostring(s.id or "") ~= tostring(game.JobId) and (tonumber(s.playing) or 0) < (tonumber(s.maxPlayers) or 50) then
                    if not best or (tonumber(s.playing) or 0) < (tonumber(best.playing) or 0) then best = s end
                end
            end
            if best then
                srvStatus.Text = "Joining (" .. tostring(best.playing) .. " players)..."
                pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, best.id, LocalPlayer) end)
            else
                srvStatus.Text = "No server found"
                notify("Server", "No smaller server found")
            end
        end)
    end)
    local c2, l2 = card(page, "Job ID", 270, 258)
    button(l2, "Copy Job ID", function()
        local ok = pcall(function() setclipboard(tostring(game.JobId)) end)
        notify("Server", ok and "Job ID copied" or "setclipboard unavailable")
    end)
    do
        local jrow = Instance.new("Frame") jrow.Size = UDim2.new(1, 0, 0, 28) jrow.BackgroundTransparency = 1 jrow.Parent = l2
        local jbox = Instance.new("TextBox") jbox.Size = UDim2.new(1, -66, 1, 0)
        jbox.BackgroundColor3 = Color3.fromRGB(30,30,38) jbox.TextColor3 = Color3.fromRGB(235,235,240)
        jbox.PlaceholderText = "Job ID..." jbox.PlaceholderColor3 = Color3.fromRGB(170,170,180)
        jbox.Text = "" jbox.Font = Enum.Font.Gotham jbox.TextSize = 12 jbox.ClipsDescendants = true jbox.Parent = jrow
        local jc = Instance.new("UICorner") jc.CornerRadius = UDim.new(0, 8) jc.Parent = jbox
        local jbtn = Instance.new("TextButton") jbtn.Size = UDim2.new(0, 60, 1, 0) jbtn.Position = UDim2.new(1, -60, 0, 0)
        jbtn.BackgroundColor3 = Color3.fromRGB(30,30,38) jbtn.Text = "Join"
        jbtn.Font = Enum.Font.GothamSemibold jbtn.TextSize = 12 jbtn.TextColor3 = Color3.fromRGB(235,235,240)
        jbtn.AutoButtonColor = true jbtn.Parent = jrow
        local jbc = Instance.new("UICorner") jbc.CornerRadius = UDim.new(0, 8) jbc.Parent = jbtn
        jbtn.MouseButton1Click:Connect(function()
            local id = string.gsub(jbox.Text, "%s+", "")
            if id == "" then notify("Server", "Paste a Job ID first") return end
            pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, id, LocalPlayer) end)
        end)
        reg(jrow, "join by job id")
    end
    local c3, l3 = card(page, "Server Info", 270, 258)
    c3.Position = UDim2.new(0, 270, 0, 200)
    task.defer(function()
        pcall(function()
            local h2 = c2.AbsoluteSize.Y
            if h2 > 50 then c3.Position = UDim2.new(0, 270, 0, h2 + 8) end
        end)
    end)
    local infoMain = label(l3, "Players: ...")
    local infoJob = label(l3, "Job: ...", 28)
    infoJob.TextSize = 10
    srvInfoMain = infoMain
    pcall(function() infoJob.Text = "Job: " .. tostring(game.JobId) end)
end
if isAdminUser then
do
    local page = Pages["Admin"]
    local cA, lA = card(page, "ADMIN • owner only", 4, 520)
    label(lA, "Empty.")
end
end
do
    local hudPar = nil
    if type(gethui) == "function" then pcall(function() hudPar = gethui() end) end
    if type(hudPar) ~= "Instance" then pcall(function() hudPar = game:GetService("CoreGui") end) end
    if type(hudPar) ~= "Instance" then hudPar = LocalPlayer:FindFirstChild("PlayerGui") end
    hudGui = Instance.new("ScreenGui")
    hudGui.Name = "PULSE_HUD" hudGui.ResetOnSpawn = false hudGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    hudGui.Parent = hudPar
    local execName = "Executor"
    pcall(function()
        if type(identifyexecutor) == "function" then
            local n = identifyexecutor()
            if type(n) == "string" and n ~= "" then execName = n end
        end
        if execName == "Executor" and type(getexecutorname) == "function" then
            local n = getexecutorname()
            if type(n) == "string" and n ~= "" then execName = n end
        end
    end)
    execName = string.gsub(tostring(execName), "[<>&%%]", "")
    if #execName > 14 then execName = string.sub(execName, 1, 14) end
    if execName == "" then execName = "Executor" end
    hudStats = Instance.new("Frame")
    hudStats.Name = "HudStats" hudStats.Size = UDim2.new(0, 310, 0, 0) hudStats.Position = UDim2.new(0.5, -155, 0, 8)
    hudStats.AutomaticSize = Enum.AutomaticSize.Y
    hudStats.BackgroundColor3 = Color3.fromRGB(24, 24, 31) hudStats.BackgroundTransparency = 0.06
    hudStats.BorderSizePixel = 0 hudStats.Active = true hudStats.Parent = hudGui
    local sc = Instance.new("UICorner") sc.CornerRadius = UDim.new(0, 14) sc.Parent = hudStats
    local ss = Instance.new("UIStroke") ss.Color = Color3.fromRGB(85, 85, 100) ss.Transparency = 0.3 ss.Thickness = 1 ss.Parent = hudStats
    local sgrad = Instance.new("UIGradient") sgrad.Color = ColorSequence.new(Color3.fromRGB(38, 38, 48), Color3.fromRGB(20, 20, 26)) sgrad.Rotation = 90 sgrad.Parent = hudStats
    local slay = Instance.new("UIListLayout") slay.Padding = UDim.new(0, 2) slay.SortOrder = Enum.SortOrder.LayoutOrder slay.HorizontalAlignment = Enum.HorizontalAlignment.Center slay.Parent = hudStats
    local spad = Instance.new("UIPadding")
    spad.PaddingLeft = UDim.new(0, 8) spad.PaddingRight = UDim.new(0, 8)
    spad.PaddingTop = UDim.new(0, 6) spad.PaddingBottom = UDim.new(0, 6)
    spad.Parent = hudStats
    local st = Instance.new("TextLabel")
    st.LayoutOrder = 1 st.Size = UDim2.new(1, 0, 0, 20)
    st.BackgroundTransparency = 1 st.RichText = true
    st.Text = "..." st.Font = Enum.Font.GothamSemibold st.TextSize = 12 st.TextColor3 = Color3.fromRGB(235,235,240)
    st.TextXAlignment = Enum.TextXAlignment.Center st.TextTruncate = Enum.TextTruncate.AtEnd st.Parent = hudStats
    hudRound = Instance.new("TextLabel")
    hudRound.LayoutOrder = 2 hudRound.Size = UDim2.new(1, 0, 0, 18)
    hudRound.BackgroundTransparency = 1
    hudRound.Text = "Round end in: --:--" hudRound.Font = Enum.Font.GothamBold hudRound.TextSize = 12
    hudRound.TextColor3 = Color3.fromRGB(235,235,240)
    hudRound.TextXAlignment = Enum.TextXAlignment.Center hudRound.TextTruncate = Enum.TextTruncate.AtEnd hudRound.Parent = hudStats
    makeDrag(hudStats)
    hudToggle = Instance.new("Frame")
    hudToggle.Name = "HudToggle" hudToggle.Size = UDim2.new(0, 180, 0, 32) hudToggle.Position = UDim2.new(0.5, -90, 0, 70)
    hudToggle.BackgroundColor3 = Color3.fromRGB(24, 24, 31) hudToggle.BackgroundTransparency = 0.06
    hudToggle.BorderSizePixel = 0 hudToggle.Active = true hudToggle.Parent = hudGui
    local tc = Instance.new("UICorner") tc.CornerRadius = UDim.new(1, 0) tc.Parent = hudToggle
    local ts = Instance.new("UIStroke") ts.Color = Color3.fromRGB(85, 85, 100) ts.Transparency = 0.3 ts.Thickness = 1 ts.Parent = hudToggle
    local tgrad = Instance.new("UIGradient") tgrad.Color = ColorSequence.new(Color3.fromRGB(38, 38, 48), Color3.fromRGB(20, 20, 26)) tgrad.Rotation = 90 tgrad.Parent = hudToggle
    local tshd = Instance.new("Frame")
    tshd.Size = UDim2.new(1, 8, 1, 8) tshd.Position = UDim2.new(0, -4, 0, -1)
    tshd.BackgroundColor3 = Color3.fromRGB(0, 0, 0) tshd.BackgroundTransparency = 0.78
    tshd.BorderSizePixel = 0 tshd.Parent = hudToggle
    local tshc = Instance.new("UICorner") tshc.CornerRadius = UDim.new(1, 0) tshc.Parent = tshd
    local dot = Instance.new("TextLabel") dot.Name = "HudDot"
    dot.Size = UDim2.new(0, 26, 1, 0) dot.Position = UDim2.new(0, 8, 0, 0)
    dot.BackgroundTransparency = 1 dot.Text = "●" dot.Font = Enum.Font.GothamBold dot.TextSize = 12
    dot.TextColor3 = Color3.fromRGB(52, 199, 123) dot.TextXAlignment = Enum.TextXAlignment.Center dot.Parent = hudToggle
    local menuBtn = Instance.new("TextButton")
    menuBtn.Size = UDim2.new(1, -40, 1, 0) menuBtn.Position = UDim2.new(0, 32, 0, 0)
    menuBtn.BackgroundTransparency = 1 menuBtn.Text = "PULSITI"
    menuBtn.Font = Enum.Font.GothamBold menuBtn.TextSize = 13 menuBtn.TextColor3 = Color3.fromRGB(235,235,240)
    menuBtn.TextXAlignment = Enum.TextXAlignment.Left menuBtn.AutoButtonColor = true menuBtn.Parent = hudToggle
    makeDrag(hudToggle)
    makeDrag(hudToggle, menuBtn)
    menuBtn.MouseButton1Click:Connect(function()
        if MainFrameRef then
            MainFrameRef.Visible = not MainFrameRef.Visible
            dot.TextColor3 = MainFrameRef.Visible and Color3.fromRGB(52, 199, 123) or Color3.fromRGB(110,110,120)
            tween(dot, {Rotation = MainFrameRef.Visible and 0 or 90}, 0.18)
        end
    end)
    hudToggle.MouseEnter:Connect(function()
        tween(hudToggle, {BackgroundColor3 = Color3.fromRGB(40, 40, 52)}, 0.12)
    end)
    hudToggle.MouseLeave:Connect(function()
        tween(hudToggle, {BackgroundColor3 = Color3.fromRGB(24, 24, 31)}, 0.18)
    end)
    local frames, last, roundLast, roundTxt = 0, tick(), 0, "--:--"
    local lastSt, lastRound = "", ""
    local function dip(lb)
        lb.TextTransparency = 0.55
        tween(lb, {TextTransparency = 0}, 0.18)
    end
    hudFpsConn = RunService.RenderStepped:Connect(function()
        frames = frames + 1
        local now = tick()
        if now - last >= 0.25 then
            local fps = math.floor(frames / math.max(0.01, now - last) + 0.5)
            frames = 0 last = now
            local ping = 0
            pcall(function() ping = math.floor(LocalPlayer:GetNetworkPing() * 1000 + 0.5) end)
            if now - roundLast >= 1 then
                roundLast = now
                pcall(function()
                    local pg = LocalPlayer:FindFirstChild("PlayerGui")
                    roundTxt = "--:--"
                    if pg then
                        for _, d in ipairs(pg:GetDescendants()) do
                            if d:IsA("TextLabel") and d.Visible and d.TextTransparency < 0.5 then
                                local m = string.match(d.Text, "^%s*(%d+:%d+)%s*$")
                                if m then roundTxt = m break end
                            end
                        end
                    end
                end)
            end
            pcall(function()
                local fc = fps >= 50 and "52,199,123" or (fps >= 25 and "230,190,60" or "230,80,80")
                local pc = ping < 100 and "52,199,123" or (ping < 200 and "230,190,60" or "230,80,80")
                local ns = string.format('<font color="rgb(235,235,240)">⚙ %s</font>  <font color="rgb(120,120,130)">|</font>  <font color="rgb(%s)">%d</font> <font color="rgb(120,120,130)">FPS</font>  <font color="rgb(120,120,130)">|</font>  <font color="rgb(%s)">%d</font> <font color="rgb(120,120,130)">ms</font>', execName, fc, fps, pc, ping)
                if ns ~= lastSt then lastSt = ns st.Text = ns dip(st) end
            end)
            pcall(function()
                local nr = "Round end in: " .. tostring(roundTxt)
                if nr ~= lastRound then lastRound = nr hudRound.Text = nr dip(hudRound) end
            end)
            pcall(function()
                if srvInfoMain then
                    local n = #Players:GetPlayers()
                    local max = tonumber(Players.MaxPlayers) or 50
                    srvInfoMain.Text = "Players: " .. tostring(n) .. "/" .. tostring(max) .. ", Ping: " .. tostring(ping) .. " ms"
                end
            end)
            pcall(function()
                if kbPanel and kbPanel.Visible then refreshKeybinds() end
            end)
        end
    end)
end
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local q = string.lower(SearchBox.Text)
    if q == "" then
        for _, c in pairs(AllControls) do c.f.Visible = true end
        for _, bx in ipairs(AdvBoxes) do pcall(function() bx.Visible = false end) end
        return
    end
    for _, c in pairs(AllControls) do
        local hit = (string.find(c.t, q, 1, true) ~= nil)
        c.f.Visible = hit
        if hit then
            local p = c.f.Parent
            if p and p.Name == "AdvBox" then pcall(function() p.Visible = true end) end
        end
    end
end)
pcall(function() makeDrag(MainFrame, TopBar) end)
pcall(function() makeDrag(MainFrame, Sidebar) end)
MainFrame:GetPropertyChangedSignal("Visible"):Connect(function()
    if MainFrame.Visible and UIScale then
        local s = UIScale.Scale
        UIScale.Scale = s * 0.96
        tween(UIScale, {Scale = s}, 0.16, Enum.EasingStyle.Back)
    end
end)
switchPage("Main")
notify("PULSITI", "MM2 v0.42 loaded - PULSE X KITI")
print("[PULSITI] ui: build done")
end
__uiOk, __uiErr = xpcall(__buildUI, function(e)
    local ok, tb = pcall(debug.traceback, tostring(e), 2)
    return (ok and tb) or tostring(e)
end)
if __uiOk then
    print("[PULSITI] boot done")
else
    __uiErrText = tostring(__uiErr)
    print("[PULSITI] FATAL: " .. __uiErrText)
    pcall(function()
        local p = game:GetService("Players").LocalPlayer
        local pg = p and p:FindFirstChild("PlayerGui")
        if pg then
            local g = Instance.new("ScreenGui") g.Name = "PULSITIError" g.ResetOnSpawn = false g.Parent = pg
            local f = Instance.new("Frame") f.Size = UDim2.new(0, 480, 0, 220) f.Position = UDim2.new(0.5, -240, 0.5, -110)
            f.BackgroundColor3 = Color3.fromRGB(40, 10, 10) f.BorderSizePixel = 0 f.Parent = g
            local t = Instance.new("TextLabel") t.Size = UDim2.new(1, -20, 1, -20) t.Position = UDim2.new(0, 10, 0, 10)
            t.BackgroundTransparency = 1 t.TextWrapped = true t.TextXAlignment = Enum.TextXAlignment.Left t.TextYAlignment = Enum.TextYAlignment.Top
            t.Font = Enum.Font.Code t.TextSize = 12 t.TextColor3 = Color3.fromRGB(255, 180, 180)
            t.Text = "PULSITI error (скинь этот текст):\n" .. __uiErrText:sub(1, 1500) t.Parent = f
        end
    end)
end
