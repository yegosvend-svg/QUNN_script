local Key = "QUNN-RUSH"

local function CheckKey()
    local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KeySystem"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = playerGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 350, 0, 200)
    MainFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.BackgroundTransparency = 1
    Title.Text = "QUNN 脚本 - 卡密验证"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.Parent = MainFrame

    local InputBox = Instance.new("TextBox")
    InputBox.Size = UDim2.new(0.85, 0, 0, 45)
    InputBox.Position = UDim2.new(0.075, 0, 0.38, 0)
    InputBox.PlaceholderText = "请输入卡密..."
    InputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    InputBox.TextSize = 16
    InputBox.Font = Enum.Font.Gotham
    InputBox.Parent = MainFrame

    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Size = UDim2.new(0.85, 0, 0, 45)
    SubmitBtn.Position = UDim2.new(0.075, 0, 0.65, 0)
    SubmitBtn.Text = "验证并加载"
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitBtn.TextSize = 17
    SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.Parent = MainFrame

    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(1, 0, 0, 25)
    Status.Position = UDim2.new(0, 0, 0.88, 0)
    Status.BackgroundTransparency = 1
    Status.Text = ""
    Status.TextColor3 = Color3.fromRGB(255, 80, 80)
    Status.TextSize = 14
    Status.Font = Enum.Font.Gotham
    Status.Parent = MainFrame

    SubmitBtn.MouseButton1Click:Connect(function()
        if InputBox.Text == Key then
            Status.Text = "验证成功，正在加载脚本..."
            Status.TextColor3 = Color3.fromRGB(0, 255, 120)
            task.wait(1.2)
            ScreenGui:Destroy()
            LoadMainScript()   -- 加载主功能
        else
            Status.Text = "卡密错误，请重新输入"
        end
    end)
end

function LoadMainScript()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")
    local Camera = Workspace.CurrentCamera
    local VirtualInputManager = game:GetService("VirtualInputManager")

    local LocalPlayer = Players.LocalPlayer
  
    local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
  
    local ESPSettings = {
        PlayerBox = true, PlayerName = true, PlayerDistance = true, PlayerHealth = true,
        Tracer = true, ItemESP = true, TrapESP = true, KillerESP = true,
        InfiniteCombatStamina = false, InfiniteRunningStamina = false,
        AutoParry = false, AutoAttack = false, AutoDodgeChoke = false, AutoPickup = false,
        BoxColor = Color3.fromRGB(0, 255, 0), TextColor = Color3.fromRGB(255, 255, 255),
        HealthColor = Color3.fromRGB(0, 255, 0), TracerColor = Color3.fromRGB(255, 100, 0),
        ItemColor = Color3.fromRGB(255, 215, 0), TrapColor = Color3.fromRGB(255, 0, 255),
        ScrapColor = Color3.fromRGB(0, 170, 255), KillerColor = Color3.fromRGB(255, 0, 0),
    }

    local Drawings = {}
    local lastParry, lastAttack, lastDodge, lastPickup = 0, 0, 0, 0

    
    local Window = WindUI:CreateWindow({
        Title = "QUNN-CHAIN脚本加载成功",
        Folder = "CHAIN_Draw_Advanced",
        Icon = "solar:eye-bold",
    })

    Window:Tag({ Title = "v2.6 + 卡密保护", Icon = "github", Color = Color3.fromHex("#30FF6A") })

  local EspTab = Window:Tab({ Title = "ESP 绘制", Desc = "视觉辅助", Icon = "solar:eye-bold" })
    local EspSection = EspTab:Section({ Title = "核心 ESP 设置" })

    EspSection:Toggle({ Title = "玩家方框 ESP", Default = true, Callback = function(v) ESPSettings.PlayerBox = v end })
    EspSection:Toggle({ Title = "玩家名字 ESP", Default = true, Callback = function(v) ESPSettings.PlayerName = v end })
    EspSection:Toggle({ Title = "玩家距离 ESP", Default = true, Callback = function(v) ESPSettings.PlayerDistance = v end })
    EspSection:Toggle({ Title = "玩家血量 ESP", Default = true, Callback = function(v) ESPSettings.PlayerHealth = v end })
    EspSection:Toggle({ Title = "Tracer 连线", Default = true, Callback = function(v) ESPSettings.Tracer = v end })
    EspSection:Toggle({ Title = "物品 ESP", Default = true, Callback = function(v) ESPSettings.ItemESP = v end })
    EspSection:Toggle({ Title = "熊陷阱 ESP", Default = true, Callback = function(v) ESPSettings.TrapESP = v end })
    EspSection:Toggle({ Title = "Killer / CHAIN ESP", Default = true, Callback = function(v) ESPSettings.KillerESP = v end })

    EspSection:Space()
    EspSection:Colorpicker({ Title = "方框颜色", Default = Color3.fromRGB(0, 255, 0), Callback = function(c) ESPSettings.BoxColor = c end })
    EspSection:Colorpicker({ Title = "文字颜色", Default = Color3.fromRGB(255, 255, 255), Callback = function(c) ESPSettings.TextColor = c end })

    local CombatTab = Window:Tab({ Title = "战斗", Desc = "战斗辅助 & 自动拾取", Icon = "solar:swords-bold" })
    local CombatSection = CombatTab:Section({ Title = "辅助功能" })

    CombatSection:Toggle({ Title = "无限战斗体力（旁路优化）", Default = false, Callback = function(v) ESPSettings.InfiniteCombatStamina = v end })
    CombatSection:Toggle({ Title = "无限奔跑体力（旁路优化）", Default = false, Callback = function(v) ESPSettings.InfiniteRunningStamina = v end })
    CombatSection:Toggle({ Title = "Auto Parry（自动招架）", Default = false, Callback = function(v) ESPSettings.AutoParry = v end })
    CombatSection:Toggle({ Title = "自动挥刀滥用", Default = false, Callback = function(v) ESPSettings.AutoAttack = v end })
    CombatSection:Toggle({ Title = "自动闪避掐脖", Default = false, Callback = function(v) ESPSettings.AutoDodgeChoke = v end })
    CombatSection:Toggle({ Title = "自动拾取（Scrap & 道具）", Default = false, Callback = function(v) ESPSettings.AutoPickup = v end })

  local function CreateDrawing(class)
        local obj = Drawing.new(class)
        obj.Visible = false
        obj.Thickness = 1.5
        obj.Transparency = 1
        return obj
    end

    local function WorldToViewport(pos)
        local vp, onScreen = Camera:WorldToViewportPoint(pos)
        return Vector2.new(vp.X, vp.Y), onScreen
    end

    local function UpdateESP()
        for _, draw in pairs(Drawings) do if draw then draw.Visible = false end end

        local char = LocalPlayer.Character
        local myRoot = char and char:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end

        if char and (ESPSettings.InfiniteCombatStamina or ESPSettings.InfiniteRunningStamina) then
            pcall(function()
                for _, v in ipairs(char:GetDescendants()) do
                    if v:IsA("NumberValue") or v:IsA("IntValue") then
                        local nl = v.Name:lower()
                        if ESPSettings.InfiniteCombatStamina and (v.Name == "CombatStamina" or (nl:find("combat") and nl:find("stamina"))) then
                            if v.Value < 72 then v.Value = 100 end
                        end
                        if ESPSettings.InfiniteRunningStamina and (v.Name == "Stamina" or v.Name == "SprintStamina" or v.Name == "RunStamina" or (nl:find("run") and nl:find("stamina"))) then
                            if v.Value < 78 then v.Value = 100 end
                        end
                    end
                end
            end)
    end

    if ESPSettings.AutoParry and tick() - lastParry > 0.22 then
            pcall(function()
                for _, obj in ipairs(Workspace:GetChildren()) do
                    if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(obj) then
                        local tracks = obj.Humanoid:GetPlayingAnimationTracks()
                        for _, track in pairs(tracks) do
                            local n = track.Name:lower()
                            if n:find("attack") or n:find("swing") or n:find("slash") or n:find("hit") or n:find("chain") then
                                local root = obj:FindFirstChild("HumanoidRootPart")
                                if root and (root.Position - myRoot.Position).Magnitude < 14 then
                                    if root.CFrame.LookVector:Dot((myRoot.Position - root.Position).Unit) > 0.35 then
                                        lastParry = tick() + math.random(40,160)/1000
                                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                                        task.wait(0.025 + math.random(5,25)/1000)
                                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
            end)
    end

    if ESPSettings.AutoAttack and tick() - lastAttack > 0.08 then
            pcall(function()
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
                lastAttack = tick() + math.random(30,90)/1000
            end)
    end

    if ESPSettings.AutoDodgeChoke and tick() - lastDodge > 0.25 then
            pcall(function()
                for _, obj in ipairs(Workspace:GetChildren()) do
                    if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(obj) then
                        local tracks = obj.Humanoid:GetPlayingAnimationTracks()
                        for _, track in pairs(tracks) do
                            local n = track.Name:lower()
                            if n:find("choke") or n:find("grab") or n:find("neck") then
                                local root = obj:FindFirstChild("HumanoidRootPart")
                                if root and (root.Position - myRoot.Position).Magnitude < 12 then
                                    lastDodge = tick() + math.random(80,220)/1000
                                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                                    task.wait(0.04 + math.random(10,30)/1000)
                                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                                    break
                                end
                            end
                        end
                    end
                end
            end)
    end

    if ESPSettings.AutoPickup and tick() - lastPickup > 0.35 then
            pcall(function()
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    local nl = obj.Name:lower()
                    if nl:find("scrap") or nl:find("medkit") or nl:find("machete") or nl:find("tomahawk") then
                        local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart") or obj:FindFirstChild("Handle")
                        if part and myRoot and (part.Position - myRoot.Position).Magnitude < 12 then
                            lastPickup = tick() + math.random(100,300)/1000
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                            task.wait(0.03 + math.random(5,20)/1000)
                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                            break
                        end
                    end
                end
            end)
    end

    for _, player in ipairs(Players:GetPlayers()) do
            if player == LocalPlayer or not player.Character then continue end
            local pchar = player.Character
            local root = pchar:FindFirstChild("HumanoidRootPart")
            local hum = pchar:FindFirstChild("Humanoid")
            if not root or not hum or hum.Health <= 0 then continue end

            local pos2D, onScreen = WorldToViewport(root.Position)
            if not onScreen then continue end

            local key = "P_" .. player.Name
            if ESPSettings.PlayerBox then
                if not Drawings[key.."_B"] then Drawings[key.."_B"] = CreateDrawing("Square") end
                local b = Drawings[key.."_B"]
                b.Size = Vector2.new(60, 90)
                b.Position = Vector2.new(pos2D.X - 30, pos2D.Y - 80)
                b.Color = ESPSettings.BoxColor
                b.Visible = true
            end
        end
    end

    local conn = RunService.RenderStepped:Connect(UpdateESP)

    Window.Destroying:Connect(function()
        conn:Disconnect()
        for _, v in pairs(Drawings) do if v.Remove then v:Remove() end end
    end)

    WindUI:Notify({ Title = "加载成功", Content = "QUNN丨CHAIN脚本祝你玩得开心", Duration = 6 })
end

CheckKey()
