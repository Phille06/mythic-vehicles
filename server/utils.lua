_trailerModels = {
    [`trailers`] = true,
    [`trailers2`] = true,
    [`trailers3`] = true,
    [`trailers4`] = true,
    [`trailers5`] = true,
    [`docktrailer`] = true,
    [`tvtrailer`] = true,
    [`boattrailer`] = true,
    [`trailersmall`] = true,
    [`tr2`] = true,
    [`tr3`] = true,
    [`tr4`] = true,
    [`tanker`] = true,
    [`tanker2`] = true,
    [`trflat`] = true,
    [`trailerlogs`] = true,
    [`trailerlarge`] = true,
    [`armytanker`] = true,
    [`armytrailer`] = true,
    [`proptrailer`] = true,
    [`freighttrailer`] = true,
    [`20fttrailer`] = true,
}

function CreateAutomobile(type, model, coords, heading, source, cb)
    if not heading then heading = 0.0 end
    if model == nil then -- skill issue, update other scripts you dummy
        if cb then cb(nil) end
        return nil
    end

    if _trailerModels[model] and source and source > 0 and cb then
        Callbacks:ClientCallback(source, 'Vehicles:Client:SpawnTrailerEntity', { -- fuck it maybe this works we ball
            model = model,
            coords = coords,
            heading = heading,
        }, function(netId)
            if not netId then return cb(nil) end
            local veh = NetworkGetEntityFromNetworkId(netId)
            local start = GetGameTimer()
            while not DoesEntityExist(veh) and GetGameTimer() - start < 5000 do -- skill issue if you don´t work
                Wait(0)
            end
            if DoesEntityExist(veh) then
                TriggerClientEvent('Vehicles:Client:SetDespawnStuff', -1, netId)
            end
            cb(DoesEntityExist(veh) and veh or nil)
        end)
        return
    end

    local veh
    if type then
        veh = CreateVehicleServerSetter(model, type, coords.x, coords.y, coords.z, heading) -- W new Native
        if not DoesEntityExist(veh) then veh = nil end
    else
        veh = CreateVehicle(model, coords.x, coords.y, coords.z, heading + 0.0, true, true) -- L old Native
        while not DoesEntityExist(veh) do Wait(10) end
    end

    if cb then cb(veh) else return veh end
end

function ParseImpoundData(fine, hold, impounder)
    if not fine then
        fine = 0
    end
    if type(hold) ~= 'number' or hold <= 0 then 
        hold = 0
    end

    return {
        Type = 0,
        Id = 0,
        Fine = fine,
        TimeHold = (hold > 0 and {
            ImpoundedAt = os.time(),
            ExpiresAt = os.time() + (hold * 3600),
            Length = (hold * 3600),
        } or false),
        Impounder = impounder,
    }
end

function GetVehicleTypeDefaultStorage(vehicleType)
    for k, v in pairs(_vehicleStorage) do
        if v.default and vehicleType == v.vehType then
            return {
                Type = 1,
                Id = k
            }
        end
    end

    return {
        Type = 0,
        Id = 0
    }
end

function DoesVehiclePassStorageRestrictions(source, restrictedData)
    for k,v in ipairs(restrictedData) do
        if Jobs.Permissions:HasJob(source, v.JobId, v.WorkplaceId) then
            return true
        end
    end
    return false
end