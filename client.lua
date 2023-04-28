-- Load the necessary dependencies
if Config.Framework == "qbcore" then
    QBCore = exports['qb-core']:GetCoreObject()
elseif Config.Framework == "esx" then
    ESX = nil
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
end

local pickedUpObject = nil

-- Handle picking up objects
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local targetObject = GetClosestObjectOfType(coords, Config.PickupDistance, GetHashKey(table.unpack(Config.PickupObjects)))

        if IsControlJustPressed(0, Config.PickupControl) and not IsEntityDead(playerPed) and not IsPedInAnyVehicle(playerPed, true) then
            if targetObject ~= 0 then
                pickedUpObject = targetObject
                
                TaskPlayAnim(playerPed, Config.PickupAnimDict, Config.PickupAnimName, 8.0, -8.0, -1, 1, 0, false, false, false)

                AttachEntityToEntity(pickedUpObject, playerPed, GetPedBoneIndex(playerPed, Config.PickupBoneIndex), Config.PickupOffset.x, Config.PickupOffset.y, Config.PickupOffset.z, Config.PickupRotation.x, Config.PickupRotation.y, Config.PickupRotation.z, true, false, false, true, 1, true)
            end
        end

        -- Handle throwing objects
        if pickedUpObject ~= nil and IsControlJustPressed(0, Config.ThrowControl) then
            local forwardVector = GetEntityForwardVector(playerPed)

            DetachEntity(pickedUpObject, true, false)

            SetEntityCoords(pickedUpObject, coords.x + forwardVector.x, coords.y + forwardVector.y, coords.z + forwardVector.z, true, true, true, false)
            ApplyForceToEntity(pickedUpObject, 1, forwardVector.x * Config.ThrowForceMultiplier, forwardVector.y * Config.ThrowForceMultiplier, forwardVector.z * Config.ThrowForceMultiplier, 0.0, 0.0, 0.0, true, true, true, true, true)
            
            pickedUpObject = nil

            TaskPlayAnim(playerPed, Config.ThrowAnimDict, Config.ThrowAnimName, 8.0, -8.0, -1, 0, 0, false, false, false)

            if Config.Framework == "qbcore" then
                TriggerServerEvent("throwable:applyDamage")
            elseif Config.Framework == "esx" then
                local playerCoords = GetEntityCoords(playerPed)
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer(playerCoords)
    
                if closestPlayer ~= -1 and closestDistance <= 3.0 then
                    TriggerServerEvent('esx:applyDamageToPlayer', closestPlayer, Config.DamageAmount)
                end
            end
        end
    end
end)

-- Handle drawing the reticle for aiming
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if pickedUpObject ~= nil then
            local playerPed = PlayerPedId()
            local forwardVector = GetEntityForwardVector(playerPed)
            local targetCoords = GetOffsetFromEntityInWorldCoords(playerPed, forwardVector.x * 10.0, forwardVector.y * 10.0, forwardVector.z * 10.0)
            local hit, hitCoords = GetPedLastWeaponImpact(playerPed)

            if not hit then
                hitCoords = targetCoords
            end

            DrawLine(coords.x, coords.y, coords.z, hitCoords.x, hitCoords.y, hitCoords.z, 255, 0, 0, 255)

            if IsControlPressed(0, Config.ThrowControl) then
                DrawMarker(28, hitCoords.x, hitCoords.y, hitCoords.z + 0.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)
            else
                DrawMarker(28, hitCoords.x, hitCoords.y, hitCoords.z + 0.25, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 255, 255, 255, 100, false, true, 2, false, false, false, false)
end
end
end
end)
