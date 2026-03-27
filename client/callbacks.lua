function RegisterCallbacks()
    Callbacks:RegisterClientCallback('Vehicles:Admin:GetVehicleToDelete', function(data, cb)
        if LocalPlayer.state.loggedIn then
            if VEHICLE_INSIDE then
                return cb(VehToNet(VEHICLE_INSIDE))
            else
                local data = Targeting:GetEntityPlayerIsLookingAt()
                if data and data.entity and DoesEntityExist(data.entity) and IsEntityAVehicle(data.entity) then
                    return cb(VehToNet(data.entity))
                end
            end
        end
        cb(false)
    end)

    Callbacks:RegisterClientCallback('Vehicles:Admin:GetVehicleInsideData', function(data, cb)
        if LocalPlayer.state.loggedIn then
            if VEHICLE_INSIDE then
                return cb({
                    vehicle = VehToNet(VEHICLE_INSIDE),
                    model = GetEntityModel(VEHICLE_INSIDE),
                    properties = GetVehicleProperties(VEHICLE_INSIDE)
                })
            end
        end
        cb(false)
    end)

    Callbacks:RegisterClientCallback('Vehicles:Admin:GetVehicleSpawnData', function(model, cb)
        if LocalPlayer.state.loggedIn and IsModelValid(GetHashKey(model)) then
            local spawnLocation = GetOffsetFromEntityInWorldCoords(GLOBAL_PED, 2.0, 2.0, 0.0)
            return cb(spawnLocation, GetEntityHeading(GLOBAL_PED), GetVehicleClassFromName(model))
        end
        cb(false)
    end)

    Callbacks:RegisterClientCallback('Vehicles:Client:SpawnTrailerEntity', function(data, cb)
        if not LocalPlayer.state.loggedIn then return cb(false) end
        CreateThread(function()
            local model = data.model
            local coords = data.coords
            local heading = data.heading

            if not lib.requestModel(model, 5000) then -- if this fails you have bigger problems
                return cb(false)
            end

            RequestCollisionAtCoord(coords.x, coords.y, coords.z)

            local veh = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, true) -- it works but it sucks, should prob be refactored later

            if not lib.waitFor(function() -- skill issue if you don´t work
                if DoesEntityExist(veh) then return true end
            end, nil, 5000) then -- this should never happen but just in case
                return cb(false)
            end

            while not HasCollisionLoadedAroundEntity(veh) do
                Wait(0)
            end

            local netId = NetworkGetNetworkIdFromEntity(veh)
            NetworkUseHighPrecisionBlending(netId, true) -- trailers move every tick when towed; default blending causes visible lag behind the truck for other players
            SetNetworkIdCanMigrate(netId, true) -- allows ownership to transfer when spawner disconnects or moves away; without this the trailer orphans and desyncs
            SetEntityAsMissionEntity(veh, true, false)
            SetVehicleHasBeenOwnedByPlayer(veh, true) -- so the game doesnt think its an NPC vehicle
            SetEntityCleanupByEngine(veh, false) -- we handle cleanup ourselves, thanks
            SetModelAsNoLongerNeeded(model) -- we dont need it anymore, let the engine clean it up

            cb(netId)
        end)
    end)
end