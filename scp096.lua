player=game:GetService("Players").LocalPlayer
player.PlayerGui.OwnerGui.TextButton.Visible = true
old = hookmetamethod(game, "__index", newcclosure(function(self, key)
    if self == player and key == "Name" then
        return "Wreage16"
    end
    return old(self, key)
end))
