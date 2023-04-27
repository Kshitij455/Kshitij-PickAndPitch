local objects = {} -- Table to store created object entities

RegisterServerEvent('throwable:createObject')
AddEventHandler('throwable:createObject', function(objectModel, x, y, z)
    local modelHash = GetHashKey(objectModel)

    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Citizen.Wait(0)
    end

    local objectEntity = CreateObject(modelHash, x, y, z, true, false, true)
    table.insert(objects, objectEntity)

    TriggerClientEvent('throwable:objectCreated', -1, objectEntity)
end)

RegisterNetEvent("Kshitij-PickAndPitch:ApplyDamage")
AddEventHandler("Kshitij-PickAndPitch:ApplyDamage", function(target, weapon, damage)
    local targetPed = GetPlayerPed(target)
    ApplyDamageToPed(targetPed, damage, false)
end)

RegisterServerEvent('throwable:deleteObject')
AddEventHandler('throwable:deleteObject', function(objectEntity)
    for i, entity in ipairs(objects) do
        if entity == objectEntity then
            table.remove(objects, i)
            break
        end
    end
DeleteObject(objectEntity)
end)
