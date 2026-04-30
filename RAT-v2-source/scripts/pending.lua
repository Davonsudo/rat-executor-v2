local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Settings = {
    HoldKey = Enum.KeyCode.Q,
    TeamCheck = true,
    TweenTime = 0.08,
    RefreshRate = 0.05,
    TweenStyle = Enum.EasingStyle.Quad,
    TweenDirection = Enum.EasingDirection.Out,
}

local isHolding = false
local updateConnection
local activeTween
local cachedCameraType
local refreshClock = 0

local function getHeadFromCharacter(character)
    if not character or character.Name ~= "Character" then
        return nil
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local head = character:FindFirstChild("Head")

    if not humanoid or humanoid.Health <= 0 or not head then
        return nil
    end

    return head
end

local function isValidTarget(target)
    if not target or target == Player then
        return false
    end

    if Settings.TeamCheck and Player.Team == target.Team then
        return false
    end

    return getHeadFromCharacter(target.Character) ~= nil
end

local function getNearestHeadCFrame()
    local currentCamera = workspace.CurrentCamera
    if not currentCamera then
        return nil, nil
    end

    local cameraPosition = currentCamera.CFrame.Position
    local closestDistance = math.huge
    local closestTarget
    local closestHead

    for _, target in ipairs(Players:GetPlayers()) do
        if isValidTarget(target) then
            local head = getHeadFromCharacter(target.Character)
            local distance = (head.Position - cameraPosition).Magnitude

            if distance < closestDistance then
                closestDistance = distance
                closestTarget = target
                closestHead = head
            end
        end
    end

    if not closestHead then
        return nil, nil
    end

    return closestHead.CFrame, closestTarget
end

local function aimCameraAt(targetCFrame)
    local currentCamera = workspace.CurrentCamera
    if not currentCamera or not targetCFrame then
        return
    end

    local cameraPosition = currentCamera.CFrame.Position
    local goalCFrame = CFrame.lookAt(cameraPosition, targetCFrame.Position)

    if activeTween then
        activeTween:Cancel()
    end

    activeTween = TweenService:Create(
        currentCamera,
        TweenInfo.new(
            Settings.TweenTime,
            Settings.TweenStyle,
            Settings.TweenDirection
        ),
        { CFrame = goalCFrame }
    )

    activeTween:Play()
end

local function startCameraLock()
    if updateConnection then
        return
    end

    Camera = workspace.CurrentCamera
    if not Camera then
        return
    end

    cachedCameraType = Camera.CameraType
    Camera.CameraType = Enum.CameraType.Scriptable
    refreshClock = 0

    updateConnection = RunService.RenderStepped:Connect(function(deltaTime)
        refreshClock += deltaTime
        if refreshClock < Settings.RefreshRate then
            return
        end

        refreshClock = 0

        local targetCFrame = getNearestHeadCFrame()
        if targetCFrame then
            aimCameraAt(targetCFrame)
        end
    end)
end

local function stopCameraLock()
    if updateConnection then
        updateConnection:Disconnect()
        updateConnection = nil
    end

    if activeTween then
        activeTween:Cancel()
        activeTween = nil
    end

    Camera = workspace.CurrentCamera
    if Camera then
        Camera.CameraType = cachedCameraType or Enum.CameraType.Custom
    end
end

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = workspace.CurrentCamera

    if isHolding and Camera then
        cachedCameraType = Camera.CameraType
        Camera.CameraType = Enum.CameraType.Scriptable
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or isHolding then
        return
    end

    if input.KeyCode == Settings.HoldKey then
        isHolding = true
        startCameraLock()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode ~= Settings.HoldKey then
        return
    end

    isHolding = false
    stopCameraLock()
end)
