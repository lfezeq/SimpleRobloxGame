game.Players.PlayerAdded:Connect(function(player)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player
    local eggs = Instance.new("IntValue")
    eggs.Name = "Eggs"
    eggs.Value = 0
    eggs.Parent = leaderstats
end)
