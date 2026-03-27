function CreateAutomobile(type, model, coords, heading)
    if not heading then heading = 0.0 end
    if model ~= nil then
        if type then
            local veh = CreateVehicleServerSetter(model, type, coords.x, coords.y, coords.z, heading)
            print("Created Vehicle with model: " .. tostring(model) .. " at coords: " .. tostring(coords) .. " with heading: " .. tostring(heading) .. " and modeltype: " .. tostring(type))
            if DoesEntityExist(veh) then
                return veh
            end
        else
            local veh = CreateVehicle(model, coords.x, coords.y, coords.z, heading + 0.0, true, true)
            while not DoesEntityExist(veh) do Wait(10) end
            return veh
        end
    end
    return nil
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