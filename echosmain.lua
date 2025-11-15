getgenv().hiiz = {
    antihurt = true;
    autorj = true;
};

saveconfig = function()
    writefile("hiiz_config.json", game:GetService("HttpService"):JSONEncode(getgenv().hiiz));
end;

loadconfig = function()
    if isfile("hiiz_config.json") then
        getgenv().hiiz = game:GetService("HttpService"):JSONDecode(readfile("hiiz_config.json"));
        print("config loaded");
    end;
end;

loadconfig();

old2 = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod();
    local args = {...};
    if getgenv().hiiz.antihurt == false then
        setnamecallmethod(method);
        return old2(self, ...);
    end;
    if method == "FireServer" and self.Name == "Pls_Dont_Hack_Plssssssssss" and args[2] == "Main_Damger_OC_R" then
        return;
    end;
    return old2(self, ...);
end);

game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid").HealthChanged:Connect(function(hp)
    if getgenv().hiiz.autorj and hp <= 0 then
        saveconfig();
        script_code = [[loadstring(game:HttpGet("YOUR_GITHUB_RAW_URL_HERE"))()]];
        if syn and syn.queue_on_teleport then
            syn.queue_on_teleport(script_code);
        elseif queue_on_teleport then
            queue_on_teleport(script_code);
        elseif queueonteleport then
            queueonteleport(script_code);
        end;
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game:GetService("Players").LocalPlayer);
    end;
end);

print("yayyyz");
