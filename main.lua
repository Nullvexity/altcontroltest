local drop = false
local moneydropped = 0

local function updateTotalCash(drop, isAdding)
    if drop.Name == "MoneyDrop" then
        local cashPart = drop:WaitForChild("BillboardGui"):WaitForChild("TextLabel")
        if cashPart then
            local cashText = cashPart.Text
            local cashValue = tonumber(cashText:match("%d+")) 
            if cashValue and isAdding then
                moneydropped = moneydropped + cashValue
                print("dropped: " .. moneydropped)
            end
        end
    end
end

workspace.Ignored.Drop.ChildAdded:Connect(function(drop)
    updateTotalCash(drop, true)
end)

game.Players:WaitForChild(getgenv().owner).Chatted:Connect(function(msg)
    if string.sub(msg, 1, 5) == ".drop" then
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
        local plr = game.Players:WaitForChild(string.sub(msg, 7))
        game:GetService("ReplicatedStorage").MainEvent:FireServer("VIP_CMD","Summon",plr)

    elseif msg == ".airlock" then
        game.Players.LocalPlayer.Character.Humanoid.HipHeight = 15

    elseif msg == ".setup" then
        local owner = game.Players:FindFirstChild(getgenv().owner)
        if owner then
            local positionOffset = 0
            for i = 1, 10 do
                local altName = getgenv()["alt"..i]
                if altName then
                    local alt = game.Players:FindFirstChild(altName)
                    if alt then
                        local ownerPosition = owner.Character.HumanoidRootPart.Position
                        alt.Character.HumanoidRootPart.CFrame = CFrame.new(ownerPosition + Vector3.new(positionOffset, 0, 0))
                        positionOffset = positionOffset + 5 
                    end
                end
            end
        else
            print("Owner not found")
        end
    end
end)
