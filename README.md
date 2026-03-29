
```md
mythic-vehicles

🔧 Required Changes

To support `modelType` in `Vehicles:SpawnTemp`, update the following files:
````
---

### mythic-dealerships/server/rentals.lua (line 18)

**Before**
```lua
Vehicles:SpawnTemp(source, rentalVehicleData.vehicle, spaceCoords, spaceHeading, function(spawnedVehicle, VIN, plate)
````

**After**

```lua
Vehicles:SpawnTemp(source, rentalVehicleData.vehicle, rentalVehicleData.modelType, spaceCoords, spaceHeading, function(spawnedVehicle, VIN, plate)
```

---

### mythic-labor/server/jobs/garbage.lua (line 122)

**Before**

```lua
Vehicles:SpawnTemp(source, `trash2`, vector3(-334.989, -1562.966, 25.230), 57.510, function(veh, VIN)
```

**After**

```lua
Vehicles:SpawnTemp(source, `trash2`, 'automobile', vector3(-334.989, -1562.966, 25.230), 57.510, function(veh, VIN)
```

---

### mythic-laptop/server/apps/lsu/boosting.lua (line 965)

**Before**

```lua
Vehicles:SpawnTemp(source, GetHashKey(contract.vehicle.vehicle), pickUpLocation.coords.xyz, pickUpLocation.coords.w, function(spawnedVehicle, VIN, plate)
```

**After**

```lua
Vehicles:SpawnTemp(source, GetHashKey(contract.vehicle.vehicle), 'automobile', pickUpLocation.coords.xyz, pickUpLocation.coords.w, function(spawnedVehicle, VIN, plate)
```

---

### mythic-robbery/server/moneytruck/main.lua (line 93)

**Before**

```lua
Vehicles:SpawnTemp(-1, truckModel, vector3(coords[1], coords[2], coords[3]), coords[4], function(veh, VIN)
```

**After**

```lua
Vehicles:SpawnTemp(-1, truckModel, 'automobile', vector3(coords[1], coords[2], coords[3]), coords[4], function(veh, VIN)
```

---

### mythic-tow/server/server.lua (line 124)

**Before**

```lua
Vehicles:SpawnTemp(source, `flatbed`, spaceCoords.xyz, spaceCoords.w, function(spawnedVehicle, VIN, plate)
```

**After**

```lua
Vehicles:SpawnTemp(source, `flatbed`, 'automobile', spaceCoords.xyz, spaceCoords.w, function(spawnedVehicle, VIN, plate)
```

---
```
✅ Summary

* Added `modelType` as a required parameter to `Vehicles:SpawnTemp`
* Default value used: `'automobile'`
* Update all spawn calls to prevent errors

```
