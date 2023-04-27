local pickedUpObject = nil

RegisterNetEvent('throwable:objectCreated')
AddEventHandler('throwable:objectCreated', function(objectEntity)
    SetEntityAsMissionEntity(objectEntity, true, true)
end)

function PickUpObject()
    local playerPed = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(playerPed))
    local object = GetClosestObjectOfType(x, y, z, 2.5, GetHashKey('prop_cs_rub_binbag_01'), false, false, false)

    if DoesEntityExist(object) then
        pickedUpObject = object
        AttachEntityToEntity(pickedUpObject, playerPed, GetPedBoneIndex(playerPed, 57005), 0.5, 0.0, 0.1, 0.0, 0.0, 180.0, false, false, true, false, 1, true)
    end
end

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
