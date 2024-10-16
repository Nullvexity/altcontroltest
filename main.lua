local drop = false
local moneydropped = 0

workspace.Ignored.Drop.ChildAdded:Connect(function(drop)
    if drop:IsA("Part") then
        wait(1)
        local cashPart = drop:FindFirstChildWhichIsA("BillboardGui")
        if cashPart then
            local cashText = cashPart.TextLabel.Text  -- Get the cash amount as a string
            local cleanedCash = string.gsub(cashText, "[^%d]", "") 
            local cashValue = tonumber(cleanedCash) or 0  -- Convert to a number
            moneydropped = moneydropped + cashValue
            print("Total Cash Dropped: $" .. moneydropped)  -- Corrected this line
        end
    end
end)


game.Players:WaitForChild(getgenv().owner).Chatted:Connect(function(msg)
    if string.sub(msg, 1, 5) == ".drop2" then
        local amount = tonumber(string.sub(msg, 7)) or 0
        if amount > 0 then
            drop = true
            moneydropped = 0 
            while drop do
                if moneydropped >= amount then
                    print("stopping now")
                    drop = false
                    break
                end
                game.ReplicatedStorage.MainEvent:FireServer("DropMoney", 15000)
                wait(0.5)
            end
        end
    elseif msg == ".stop" then
        drop = false

    elseif string.sub(msg, 1, 6) == ".bring" then
        local playerName = string.sub(msg, 7)
        local targetPlayer = game.Players:FindFirstChild(playerName)
    
        if targetPlayer then
            game:GetService("ReplicatedStorage").MainEvent:FireServer("VIP_CMD", "Summon", targetPlayer)
        else
            print("Player not found: " .. playerName)
        end

    elseif msg == ".airlock" then
        game.Players.LocalPlayer.Character.Humanoid.HipHeight = 10

    elseif msg == ".setup" then
        local owner = game.Players:FindFirstChild(getgenv().owner)
        if owner then
            local positionOffset = 0
            for i = 1, 10 do
                local altName = getgenv()["alt"..i]
                if altName then
                    local alt = game.Players:FindFirstChild(altName)
                    if alt then
                        local anim = Instance.new("Animation")
                        anim.Parent = alt.Character
                        anim.AnimationId = "rbxassetid://13850660986"

                        local animload = alt.Character.Humanoid:LoadAnimation(anim)
                        animload:Play()
                            
                        local ownerPosition = owner.Character.Head.Position
                        alt.Character:SetPrimaryPartCFrame(CFrame.new(ownerPosition + Vector3.new(positionOffset, 0, 0)))
                        positionOffset = positionOffset + 5 
                    end
                end
            end
        else
            print("Owner not found")
        end
    end
end)
