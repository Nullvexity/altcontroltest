local drop = false
local moneydropped = 0
local plr = game.Players.LocalPlayer
local Character = plr.Character

local function Teleport(_CFrame, Status)
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    if Status then
        for i = 0, 1, 0.1 do
            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame:lerp(_CFrame, i)
            wait()
        end
    else
        HumanoidRootPart.CFrame = _CFrame
    end
end

mt.__namecall = newcclosure(function(...)
    local method = getnamecallmethod()
    local args = {...}
    if method == "FireServer" then
        local remoteName = tostring(args[1])
        if remoteName == "MainEvent" then
            if args[2] == "TeleportDetect" or args[2] == 'TeleportDetect' or args[2] == 'CHECKER' or args[2] == 'OneMoreTime' then
                return nil
            end
        end
    end
    
    return backupnamecall(...)
end)


if getgenv().SOLOISASS == "solo i run you (if u delete this nono work XDDD)" then
    print("sexy solo")
    print("im from oblock")

    workspace.Ignored.Drop.ChildAdded:Connect(function(drop)
        if drop:IsA("Part") then
            wait(1)
            local cashPart = drop:FindFirstChildWhichIsA("BillboardGui")
            if cashPart then
                local cashText = cashPart.TextLabel.Text  
                local cleanedCash = string.gsub(cashText, "[^%d]", "") 
                local cashValue = tonumber(cleanedCash) or 0  
                moneydropped = moneydropped + cashValue
                print("dhc: $" .. moneydropped)  
            end
        end
    end)

    game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("loaded.","All")

    game.Players:WaitForChild(getgenv().owner).Chatted:Connect(function(msg)
        if string.sub(msg, 1, 5) == ".drop" then
            local amount = tonumber(string.sub(msg, 6)) or 0
            if amount > 0 then
                game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("dropping "..amount.." dhc","All")
                drop = true
                moneydropped = 0 
                while drop do   
                    if moneydropped >= amount then
                        game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("reached "..amount.." dhc dropped, stopping." dhc","All")
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
                            Teleport(ownerPosition + Vector3.new(positionOffset, 0, 0), true)
                            positionOffset = positionOffset + 5 
                        end
                    end
                end
            else
                print("Owner not found")
            end
        end
    end)
end
