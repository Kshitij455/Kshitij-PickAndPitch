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
        local targetObject = GetClosestObjectOfType(coords, Config.PickupDistance, GetHashKey(Config.PickupObject))

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

            TaskPlayAnim(playerPed, Config.ThrowAnimDict, Config.ThrowAnimName, 8.0, -8.0, -1, 1, 0, false, false, false)

            TriggerServerEvent("throwable:applyDamage")
        end
    end
end)

-- Handle adding a throwable item to the player's inventory (for ESX framework)
if Config.Framework == "esx" then
    ESX.RegisterUsableItem(Config.ThrowableItem, function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        
        TriggerClientEvent("throwable:addObjectToList", source, Config.PickupObject)

        xPlayer.removeInventoryItem(Config.ThrowableItem, 1)
    end)
end

-- Handle adding a throwable item to the player's inventory (for QbCore framework)
if Config.Framework == "qbcore" then
    QBCore.Functions.CreateUseableItem(Config.ThrowableItem, function(source)
        local Player = QBCore.Functions.GetPlayer(source)
        
        TriggerClientEvent("throwable:addObjectToList", source, Config.PickupObject)

        Player.Functions.RemoveItem(Config.ThrowableItem, 1)
    end)
end
