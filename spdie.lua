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
    Size = UDim2.fromOffset(450, 550)
})

mh = w:CollapsingHeader({Title = "main"})

mh:Label({Text = "money"})
ma = mh:InputText({Label = "amount", Value = ""})
mh:Button({Text = "add money", Callback = function()
    game:GetService("ReplicatedStorage").ShopBuy:FireServer("porno", -(tonumber(ma.Value) or 0))
end})

mh:Separator()

mh:Label({Text = "movement"})
mh:Checkbox({Label = "enable", Value = false, Callback = function(_, v)
    tpwalking = v
end})
mh:SliderFloat({Label = "tp walk speed", Minimum = 1, Maximum = 20, Value = 1, Callback = function(_, v)
    tpwalkspeed = v
end})

mh:Separator()

mh:Label({Text = "combat"})
mh:Checkbox({Label = "kill aura for npcs", Value = false, Callback = function(_, v)
    killnpcs = v
end})

mh:Separator()

mh:Label({Text = "music"})
si = mh:InputText({Label = "sound id", Value = ""})
vs = mh:SliderFloat({Label = "volume", Minimum = 0, Maximum = 10, Value = 0.5})
ps = mh:SliderFloat({Label = "pitch", Minimum = 0.1, Maximum = 10, Value = 1})
lc = mh:Checkbox({Label = "looped", Value = true})
mh:Checkbox({Label = "anti stop music", Value = false, Callback = function(_, v)
    antistomusic = v
end})
mh:Button({Text = "play sound", Callback = function()
    currentsoundid = si.Value
    currentvolume = vs.Value
    currentpitch = ps.Value
    currentlooped = lc.Value
    if game:GetService("ReplicatedStorage"):FindFirstChild("PlayEmoteMusic") then
        game:GetService("ReplicatedStorage").PlayEmoteMusic:FireServer("play", {
            Pitch = currentpitch,
            Volume = currentvolume,
            SoundId = "rbxassetid://" .. tostring(currentsoundid),
            Looped = currentlooped,
            TimePosition = 0
        })
    end
end})

ch = w:CollapsingHeader({Title = "credits"})
ch:Label({Text = "made by veil0x14"})
ch:Button({Text = "copy discord username", Callback = function()
    setclipboard("veil0x14")
end})
ch:Button({Text = "copy discord id", Callback = function()
    setclipboard("1423268813402804244")
end})

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
    if antistomusic and getnamecallmethod() == "FireServer" and self.Name == "PlayEmoteMusic" and ({...})[1] == "stop" then
        return
    end
    return oldnamecall(self, ...)
end)

game:GetService("RunService").Heartbeat:Connect(function(d)
    if tpwalking and c and h and r and h.MoveDirection.Magnitude > 0 then
        r.CFrame = r.CFrame + h.MoveDirection * tpwalkspeed * d * 10
    end
    
    if killnpcs and r then
        for _, v in pairs(game:GetService("Workspace"):GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                isnpc = true
                for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
                    if v.Name == plr.Name then
                        isnpc = false
                        break
                    end
                end
                if isnpc then
                    dist = (r.Position - v.HumanoidRootPart.Position).Magnitude
                    if dist <= 15 then
                        v.Humanoid.Health = 0
                    end
                end
            end
        end
    end
end)
