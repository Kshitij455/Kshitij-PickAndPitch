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
