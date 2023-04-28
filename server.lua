-- Handle applying damage to hit entities
RegisterServerEvent("throwable:applyDamage")
AddEventHandler("throwable:applyDamage", function()
    local playerPed = source
    local coords = GetEntityCoords(playerPed)
    local targetEntityType, targetEntity = GetEntityType(GetClosestPed(coords.x, coords.y, coords.z, 3.0, 1, 0))
    
    if targetEntityType == 1 or targetEntityType == 2 then
        ApplyDamageToPed(targetEntity, Config.DamageAmount, false)
    end
end)

-- Register the throwable item (for QBCore framework)
if Config.Framework == "qbcore" then
    QBCore.Functions.CreateUseableItem(Config.ThrowableItem, function(source)
        TriggerClientEvent("throwable:throwObject", source)
        QBCore.Functions.RemoveItem(source, Config.ThrowableItem, 1)
    end)
end

-- Register the throwable item (for ESX framework)
if Config.Framework == "esx" then
    ESX.RegisterUsableItem(Config.ThrowableItem, function(source)
        TriggerClientEvent("throwable:throwObject", source)
        ESX.RemoveInventoryItem(source, Config.ThrowableItem, 1)
    end)
end
