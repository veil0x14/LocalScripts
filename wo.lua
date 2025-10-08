loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixeluted/adoniscries/refs/heads/main/Source.lua"))()

regui = loadstring(game:HttpGet('https://raw.githubusercontent.com/depthso/Dear-ReGui/main/ReGui.lua'))()

regui:DefineTheme("halloween", {
    Text = Color3.fromRGB(255, 140, 0),
    WindowBg = Color3.fromRGB(20, 10, 5),
    TitleBarBg = Color3.fromRGB(30, 15, 0),
    TitleBarBgActive = Color3.fromRGB(50, 25, 0),
    Border = Color3.fromRGB(139, 69, 19),
    ResizeGrab = Color3.fromRGB(255, 69, 0),
    Button = Color3.fromRGB(40, 20, 0),
    ButtonHovered = Color3.fromRGB(60, 30, 0),
    ButtonActive = Color3.fromRGB(80, 40, 0),
    FrameBg = Color3.fromRGB(25, 12, 5),
    CheckMark = Color3.fromRGB(255, 140, 0)
})

w = regui:Window({
    Title = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
    Theme = "halloween",
    Size = UDim2.fromOffset(450, 350)
})

w:Label({Text = "anti ragdoll"})
antiragdoll = false
w:Checkbox({Label = "enable", Value = false, Callback = function(_, v) antiragdoll = v end})

w:Separator()
w:Label({Text = "anti hitbox lag"})
antihitbox = false
w:Checkbox({Label = "enable", Value = false, Callback = function(_, v) antihitbox = v end})

w:Separator()
w:Label({Text = "hitbox expander"})
hitboxenabled = false
hitboxsize = 10
hitboxvisible = false
w:Checkbox({Label = "enable hitbox", Value = false, Callback = function(_, v) hitboxenabled = v end})
w:SliderFloat({Label = "hitbox size", Minimum = 1, Maximum = 35, Value = 10, Callback = function(_, v) hitboxsize = v end})
w:Checkbox({Label = "show hitbox", Value = false, Callback = function(_, v) hitboxvisible = v end})

w:Separator()
w:Label({Text = "hidden giver"})
w:Button({Text = "teleport to teapot giver", Callback = function()
    if workspace:FindFirstChild("givers") and workspace.givers:FindFirstChild("TeapotGiver") then
        giver = workspace.givers.TeapotGiver:FindFirstChild("Head")
        if giver and c and r then
            r.CFrame = giver.CFrame
        end
    end
end})

w:Separator()
w:Label({Text = "credits"})
w:Label({Text = "made by veil0x14"})
w:Button({Text = "copy discord username", Callback = function() setclipboard("veil0x14") end})
w:Button({Text = "copy discord id", Callback = function() setclipboard("1423268813402804244") end})

p = game:GetService("Players").LocalPlayer
c = p.Character or p.CharacterAdded:Wait()
h = c:WaitForChild("Humanoid")
r = c:WaitForChild("HumanoidRootPart")

p.CharacterAdded:Connect(function(char)
    c = char
    task.wait(0.5)
    h = c:FindFirstChild("Humanoid")
    r = c:FindFirstChild("HumanoidRootPart")
end)

oldnamecall = hookmetamethod(game, "__namecall", function(self, ...)
    args = {...}
    method = getnamecallmethod()
    if checkcaller() then
        return oldnamecall(self, ...)
    end
    if antiragdoll and (method == "FireServer" or method == "InvokeServer") then
        if string.find(tostring(self), "ragdoll") or string.find(tostring(self), "Ragdoll") then
            return
        end
    end
    return oldnamecall(self, ...)
end)

oldindex = hookmetamethod(game, "__index", function(self, key)
    if checkcaller() then
        return oldindex(self, key)
    end
    if antiragdoll and key == "PlatformStand" and self:IsA("Humanoid") then
        return false
    end
    return oldindex(self, key)
end)

oldnewindex = hookmetamethod(game, "__newindex", function(self, key, value)
    if checkcaller() then
        return oldnewindex(self, key, value)
    end
    if antiragdoll and key == "PlatformStand" and self:IsA("Humanoid") and value == true then
        return
    end
    return oldnewindex(self, key, value)
end)

task.spawn(function()
    while task.wait(0.1) do
        if antihitbox and workspace:FindFirstChild("debris") then
            for _, v in ipairs(workspace.debris:GetChildren()) do
                if v:IsA("Part") and v.Material == Enum.Material.ForceField then
                    v:Destroy()
                end
            end
        end
    end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if antiragdoll and c and h then
        rg = c:FindFirstChild("Ragdoll")
        if rg then
            rg:Destroy()
        end
        h.PlatformStand = false
        h.AutoRotate = true
        h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        h:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        h:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
        if h:GetState() == Enum.HumanoidStateType.Physics then
            h:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
        for _, v in ipairs(c:GetDescendants()) do
            if v.Name == "DeleteMe" or (v:IsA("BallSocketConstraint") and v.Name:lower():find("ragdoll")) then
                v:Destroy()
            end
        end
        t = c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso")
        if t then
            for _, m in ipairs(t:GetChildren()) do
                if m:IsA("Motor6D") and m.Part0 == nil then
                    m.Part0 = t
                end
            end
        end
    end
    if hitboxenabled then
        for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
            if plr ~= p and plr.Character then
                hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Size = Vector3.new(hitboxsize, hitboxsize, hitboxsize)
                    hrp.Transparency = hitboxvisible and 0.5 or 1
                    hrp.CanCollide = false
                    if hitboxvisible then
                        if not hrp:FindFirstChild("hitboxpart") then
                            vis = Instance.new("SelectionBox")
                            vis.Name = "hitboxpart"
                            vis.Adornee = hrp
                            vis.Color3 = Color3.fromRGB(255, 0, 0)
                            vis.LineThickness = 0.05
                            vis.Transparency = 0.5
                            vis.Parent = hrp
                        end
                    else
                        if hrp:FindFirstChild("hitboxpart") then
                            hrp.hitboxpart:Destroy()
                        end
                    end
                end
            end
        end
    else
        for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
            if plr ~= p and plr.Character then
                hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                    if hrp:FindFirstChild("hitboxpart") then
                        hrp.hitboxpart:Destroy()
                    end
                end
            end
        end
    end
end)
