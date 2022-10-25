local QBCore = exports['qb-core']:GetCoreObject()
local price = 0

-- Function to create the ped when you enter the zone
local CreateNPC = function()
    mechanicPed = CreatePed(5, "mp_m_freemode_01", 860.42, -2134.29,29.61, 270.07, false, true)
    FreezeEntityPosition(mechanicPed, true)
    SetEntityInvincible(mechanicPed, true)
    SetBlockingOfNonTemporaryEvents(mechanicPed, true)
    TaskStartScenarioInPlace(mechanicPed, 'WORLD_HUMAN_CLIPBOARD', 0, true)
    SetPedComponentVariation(mechanicPed, 0, 43, 0, 0)
    SetPedComponentVariation(mechanicPed, 2, 176, 0, 0)
    SetPedComponentVariation(mechanicPed, 8, 15, 0, 0)
    SetPedComponentVariation(mechanicPed, 11, 384, 0, 0)
    SetPedComponentVariation(mechanicPed, 4, 132, 0, 0)
    SetPedComponentVariation(mechanicPed, 6, 94, 6, 0)

end

local SpawnNPC = function()
    CreateThread(function()
        RequestModel("mp_m_freemode_01")
        while not HasModelLoaded("mp_m_freemode_01") do
            Wait(1)
        end
        CreateNPC()
    end)
end

AddEventHandler('onResourceStop', function(resource)
   if resource == GetCurrentResourceName() then
    DeletePed(created_ped)
   end
end)

RegisterNetEvent("sw-npcmechanic:client:talk:npc", function()
    local p = promise.new()	QBCore.Functions.TriggerCallback('sw-npcmechanic:mechCheck', function(cb) p:resolve(cb) end)
    vector3(860.6753, -2134.297, 31.16566)
    if Citizen.Await(p) == true then QBCore.Functions.Notify(Loc[Config.Lan].error["callmech"], 'error', 4500) return end
    local notifysent = false
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped)
    local inVehicle = IsPedInAnyVehicle(ped)
    local coords = vector3(862.28137, -2147.051, 29.858463)
    if inVehicle then
        local p = promise.new() QBCore.Functions.TriggerCallback('sw-npcmechanic:checkCash', function(cb) p:resolve(cb) end)
        local bank = Citizen.Await(p)
        local EngineHealth = GetVehicleEngineHealth(veh)
        local BodyHealth = GetVehicleBodyHealth(veh)
        if EngineHealth >= 500 and BodyHealth >= 500 then
            price = Config.MinPrice
        else
            price = Config.MaxPrice
        end
        if bank >= price then
            if Config.RenewedPhone then
            PlaySound(-1, "Click_Fail", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
            TriggerEvent('qb-phone:client:CustomNotification',
                Loc[Config.Lan].error["partoneTitle"],
                Loc[Config.Lan].error["partoneMessage"],
                "fas fa-wrench",
                "#FFD700",
                5500)
            end
            TriggerServerEvent("sw-npcmechanic:chargeCash", price)
            TaskLeaveVehicle(ped, veh, 0)
            Wait(3500)
            SetEntityCoords(veh, coords)
            SetEntityHeading(veh, 355.04)
            Wait(1500)
            SetVehicleEngineHealth(veh, 300.0)
            local created_ped = CreatePed(5, 'mp_m_freemode_01', 847.23, -2130.03, 30.54, 278.13, false, true)
            SetEntityInvincible(created_ped, true)
            SetBlockingOfNonTemporaryEvents(created_ped, true)
            TaskGoToCoordAnyMeans(created_ped, 862.41, -2144.36, 30.47, 2.0, 0, 0, 786603, 1.0)
            SetPedComponentVariation(created_ped, 0, 43, 0, 0)
            SetPedComponentVariation(created_ped, 2, 176, 0, 0)
            SetPedComponentVariation(created_ped, 8, 15, 0, 0)
            SetPedComponentVariation(created_ped, 11, 384, 0, 0)
            SetPedComponentVariation(created_ped, 4, 208, 0, 0)
            SetPedComponentVariation(created_ped, 6, 162, 6, 0)
            while true do
                local coords = GetEntityCoords(created_ped, true)
                local pos2 = vector3(862.52301, -2144.572, 30.476011)
                local dist = #(pos2 - coords)

                if (dist < 2.0) then
                    SetVehicleDoorOpen(veh, 4, false, true)
                    ClearPedTasks(created_ped)
                    Wait(1000)
                    TaskStartScenarioInPlace(created_ped, 'PROP_HUMAN_BUM_BIN', 0, true)
                    break
                end
                SetTimeout(20000, function()
                    if not notifysent then -- Stupid hacky way to get it not send several notifies
                        SetVehicleFixed(veh)
                        DeletePed(created_ped)

                        if Config.RenewedPhone then
                        PlaySound(-1, "Click_Fail", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
                        TriggerEvent('qb-phone:client:CustomNotification',
                            Loc[Config.Lan].error["readytitle"],
                            Loc[Config.Lan].error["readymessage"],
                            "fas fa-wrench",
                            "#FFD700",
                            5500)
                        end
                        notifysent = true
                    end
                end)
                Wait(1500)
            end
        else
        QBCore.Functions.Notify(Loc[Config.Lan].error["notenough"], 'error', 7500)
        end
    else
        QBCore.Functions.Notify(Loc[Config.Lan].error["needvehicle"], 'error', 7500)

    end
end)

CreateThread(function()
        exports["ps-zones"]:CreatePolyZone("npcmechanic", {
        vector2(847.42, -2092.22),
        vector2(919.83770751953, -2096.08),
        vector2(912.71, -2170.25),
        vector2(835.02, -2162.52)
    }, {
        debugPoly = false,
        minZ = 29.440420150757,
        maxZ = 34.495328903198
    })
end)

RegisterNetEvent("ps-zones:enter", function(ZoneName, ZoneData)
    if ZoneName == "npcmechanic" then
        SpawnNPC()
    end
end)

RegisterNetEvent("ps-zones:leave", function(ZoneName, ZoneData)
    if ZoneName == "npcmechanic" then
        DeletePed(mechanicPed)
    end
end)


CreateThread(function()
    exports['qb-target']:AddCircleZone("RepairPed", vector3(860.6695, -2134.306, 30.89199), 0.4, {
        name = "RepairPed",
        debugPoly = false,
        maxZ = 32.0,
      }, {
        options = {
            {
                type = "client",
                event = "sw-npcmechanic:client:talk:npc",
                icon = "fas fa-wrench",
                label =  Loc[Config.Lan].target["npctalk"] .. Config.MinPrice .. "$ - " ..Config.MaxPrice.."$",
            },
        },
        distance = 3.0
      })
end)