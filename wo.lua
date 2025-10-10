regui = loadstring(game:HttpGet('https://raw.githubusercontent.com/depthso/Dear-ReGui/main/ReGui.lua'))()

regui:DefineTheme("halloween", {
    Text = Color3.fromRGB(255, 140, 0),
    WindowBg = Color3.fromRGB(20, 10, 5),
    TitleBarBg = Color3.fromRGB(30, 15, 0),
    TitleBarBgActive = Color3.fromRGB(100, 25, 0),
    Border = Color3.fromRGB(160, 69, 19),
    ResizeGrab = Color3.fromRGB(255, 69, 0),
    Button = Color3.fromRGB(40, 20, 0),
    ButtonHovered = Color3.fromRGB(60, 30, 0),
    ButtonActive = Color3.fromRGB(80, 40, 0),
    FrameBg = Color3.fromRGB(25, 12, 5),
    CheckMark = Color3.fromRGB(50, 10, 0)
})

loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixeluted/adoniscries/refs/heads/main/Source.lua"))()

w = regui:Window({
    Title = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
    Theme = "halloween",
    Size = UDim2.fromOffset(450, 600)
})

self = {}

w:Label({Text = "anti ragdoll & anti stun & anti slowdown"})
w:Checkbox({Label = "enable", Value = false, Callback = function(_, v) self.antiragdoll = v end})

w:Separator()
w:Label({Text = "anti hitbox lag"})
w:Checkbox({Label = "enable", Value = false, Callback = function(_, v) self.antihitbox = v end})

w:Separator()
w:Label({Text = "hitbox expander"})
w:Checkbox({Label = "enable", Value = false, Callback = function(_, v) self.hitbox = v end})
w:SliderFloat({Label = "hitbox size", Minimum = 1, Maximum = 20, Value = 10, Callback = function(_, v) self.hitboxsize = v end})
w:Checkbox({Label = "show hitbox", Value = false, Callback = function(_, v) self.hitboxshow = v end})

w:Separator()
w:Label({Text = "auto click"})
w:Checkbox({Label = "enable", Value = false, Callback = function(_, v) self.autoclick = v end})

w:Separator()
w:Label({Text = "tp walk"})
w:Checkbox({Label = "enable", Value = false, Callback = function(_, v) self.tpwalk = v end})
w:SliderFloat({Label = "tp walk speed", Minimum = 0.1, Maximum = 10, Value = 1, Callback = function(_, v) self.tpwalkspeed = v end})

w:Separator()
w:Label({Text = "hidden giver"})
w:Button({Text = "teleport to teapot giver", Callback = function()
    givers = workspace:FindFirstChild("givers")
    if givers then
        teapotgiver = givers:FindFirstChild("TeapotGiver")
        if teapotgiver then
            head = teapotgiver:FindFirstChild("Head")
            plr = game:GetService("Players").LocalPlayer
            char = plr.Character
            if head and char then
                hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = head.CFrame
                end
            end
        end
    end
end})

w:Separator()
w:Label({Text = "credits"})
w:Label({Text = "made by veil0x14"})
w:Button({Text = "copy discord username", Callback = function() setclipboard("veil0x14") end})
w:Button({Text = "copy discord id", Callback = function() setclipboard("1423268813402804244") end})

task.spawn(function()
    while task.wait(0.1) do
        if self.antihitbox then
            debris = workspace:FindFirstChild("debris")
            if debris then
                for _, v in debris:GetChildren() do
                    if v:IsA("Part") and v.Material == Enum.Material.ForceField then
                        v:Destroy()
                    end
                end
            end
        end
    end
end)

game:GetService("RunService").Heartbeat:Connect(function(dt)
    plr = game:GetService("Players").LocalPlayer
    char = plr.Character
    if not char then return end
    hum = char:FindFirstChild("Humanoid")
    hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    
    if self.antiragdoll then
        ragdoll = char:FindFirstChild("Ragdoll")
        if ragdoll then
            ragdoll:Destroy()
        end
        
        for _, part in char:GetDescendants() do
            if part:IsA("BasePart") and part.Anchored then
                part.Anchored = false
            end
        end
        
        if hum.WalkSpeed < 16 then
            hum.WalkSpeed = 16
        end
        
        hum.PlatformStand = false
        hum.AutoRotate = true
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
        
        if hum:GetState() == Enum.HumanoidStateType.Physics then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
        
        for _, v in char:GetDescendants() do
            shoulddestroy = v.Name == "DeleteMe" or (v:IsA("BallSocketConstraint") and string.find(string.lower(v.Name), "ragdoll")) or (v.Name == "VFX" and v:IsDescendantOf(char))
            if shoulddestroy then
                v:Destroy()
            end
        end
        
        torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
        if torso then
            for _, m in torso:GetChildren() do
                if m:IsA("Motor6D") and not m.Part0 then
                    m.Part0 = torso
                end
            end
        end
    end
    
    if self.hitbox then
    for _, p in game:GetService("Players"):GetPlayers() do
        if p ~= plr and p.Character then
            hum = p.Character:FindFirstChildOfClass("Humanoid")
            hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hum and hrp then
                hitboxSize = Vector3.new(self.hitboxsize, self.hitboxsize, self.hitboxsize)

                params = OverlapParams.new()
                params.FilterType = Enum.RaycastFilterType.Blacklist
                params.FilterDescendantsInstances = {plr.Character}

                parts = workspace:GetPartBoundsInBox(hrp.CFrame, hitboxSize, params)

                for _, part in ipairs(parts) do
                    model = part:FindFirstAncestorOfClass("Model")
                    if model and model:FindFirstChildOfClass("Humanoid") and model ~= plr.Character then
                        if self.hitboxshow then
                            if not hrp:FindFirstChild("hitboxpart") then
                                box = Instance.new("SelectionBox")
                                box.Name = "hitboxpart"
                                box.Adornee = hrp
                                box.Color3 = Color3.fromRGB(255, 0, 0)
                                box.LineThickness = 0.05
                                box.Transparency = 0.5
                                box.Parent = hrp
                            end
                        else
                            hitboxpart = hrp:FindFirstChild("hitboxpart")
                            if hitboxpart then
                                hitboxpart:Destroy()
                            end
                        end
                    end
                end

                hrp.Size = hitboxSize
                hrp.CanCollide = false
                hrp.Transparency = self.hitboxshow and 0.5 or 1
            end
        end
    end
else
    for _, p in game:GetService("Players"):GetPlayers() do
        if p ~= plr and p.Character then
            hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Size = Vector3.new(2, 2, 1)
                hrp.Transparency = 1
                hitboxpart = hrp:FindFirstChild("hitboxpart")
                if hitboxpart then
                    hitboxpart:Destroy()
                end
            end
        end
    end
end

    if self.tpwalk and hum.MoveDirection.Magnitude > 0 then
        char:TranslateBy(hum.MoveDirection * self.tpwalkspeed * dt * 10)
    end
    
        if self.autoclick then
    local tool = plr.Character and plr.Character:FindFirstChildOfClass("Tool")
    if tool then
        tool:Activate()
        task.wait(0.1)  
        hum:UnequipTools()
    end
end
end)
