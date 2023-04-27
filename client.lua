local pickedUpObject = nil

RegisterNetEvent('throwable:objectCreated')
AddEventHandler('throwable:objectCreated', function(objectEntity)
    SetEntityAsMissionEntity(objectEntity, true, true)
end)

function PickupObject(object)
    TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, 1)
    Wait(1000)
    DeleteEntity(object)
    ClearPedTasksImmediately(PlayerPedId())
    
    -- Define the pickup animation
    local animDict = "anim@heists@box_carry@"
    local animName = "idle"
    local flags = 49 -- Play the animation normally without repeating

    -- Play the pickup animation
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(0)
    end
    TaskPlayAnim(PlayerPedId(), animDict, animName, 8.0, -8.0, -1, flags, 0, false, false, false)
    
    TriggerServerEvent("Kshitij-PickAndPitch:GiveItem", object)
end

function AimAndShoot()
    local target, distance = GetClosestPlayerInArea(2.0)
    if target ~= nil and distance < 50.0 then -- Only allow shooting within 50 meters
        local weapon = GetSelectedPedWeapon(PlayerPedId())
        local damage = 30.0 -- Adjust the damage as needed
        TriggerServerEvent("Kshitij-PickAndPitch:ApplyDamage", GetPlayerServerId(target), weapon, damage)
    end
end

function GetClosestPlayerInArea(radius)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local closestPlayer, closestDistance = nil, -1
    for _, player in ipairs(GetActivePlayers()) do
        local targetPed = GetPlayerPed(player)
        if targetPed ~= playerPed then
            local targetCoords = GetEntityCoords(targetPed)
            local distance = Vdist(playerCoords, targetCoords)
            if closestDistance == -1 or distance < closestDistance then
                closestPlayer, closestDistance = player, distance
            end
        end
    end
    return closestPlayer, closestDistance
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, Keys[Config.ThrowKey]) then
            ThrowObject()
        elseif IsControlJustReleased(0, Keys[Config.PickupKey]) then
            PickUpObject()
        elseif IsControlPressed(0, 25) then -- Left mouse button
            AimAndShoot()
        end
    end
end)

function ThrowObject()
    if pickedUpObject ~= nil then
        local playerPed = PlayerPedId()
        local x, y, z = table.unpack(GetEntityCoords(playerPed))
        local forwardX, forwardY = GetEntityForwardVector(playerPed)
        local throwForce = 100.0
        
        DetachEntity(pickedUpObject, true, false)
        ApplyForceToEntity(pickedUpObject, 1, forwardX * throwForce, forwardY * throwForce, 1.0, 0.0, 0.0, 0.0, true, true, true, true, true, true)
        pickedUpObject = nil
    end
end

RegisterCommand('pickup', function()
    PickUpObject()
end)

RegisterCommand('throw', function()
    ThrowObject()
end)
