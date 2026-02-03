---- APEX DEVELOPMENT 
-- DISCORD.GG/K3YnEJzzDA

local QBCore = exports['qb-core']:GetCoreObject()

local hashFarming = false
local hashShouldStop = false

local cokeFarming = false
local cokeShouldStop = false

local hashFarmZone = vec3(-12.79, -2526.14, -9.94)
local hashRadius = 6.0
local hashSeedsPerTick = 5
local hashFarmingDuration = 8

local cokeFarmZone = vec3(1860.2660, 315.9622, 163.6862) 
local cokeRadius = 6.0
local cokeLeavesPerTick = 5
local cokeFarmingDuration = 8

local drawMarker = {
    type = 25,
    size = vector3(7.0,7.0,0.0),
    color = { r = 255, g = 255, b = 0, a = 150 }
}

local controls = { start = 38, stop = 47 } 
local animDictFarm = "amb@world_human_gardener_plant@male@idle_a"
local animNameFarm = "idle_a"

local function startHashFarming()
    hashFarming = true
    hashShouldStop = false
    lib.showTextUI('[G] Stop farming')

    while hashFarming do
        local ped = cache.ped
        if #(GetEntityCoords(ped) - hashFarmZone) > hashRadius then
            lib.notify({ title = "Du forlod området", description = "Farming stoppet", type = "error" })
            break
        end

        lib.requestAnimDict(animDictFarm)
        TaskPlayAnim(ped, animDictFarm, animNameFarm, 8.0, -8.0, -1, 1, 0, false,false,false)

        local success = lib.progressBar({
            duration = hashFarmingDuration*1000,
            label = "Høster hashblade...",
            useWhileDead = false,
            canCancel = false,
            disable = { car=true, move=true, combat=true }
        })

        ClearPedTasks(ped)
        if success then
            TriggerServerEvent("weed_process:giveSeeds", hashSeedsPerTick)
        else
            lib.notify({ title = "Farming annulleret", type = "error" })
            break
        end

        if hashShouldStop then
            hashFarming = false
            break
        end
        Wait(200)
    end
    hashFarming = false
    lib.hideTextUI()
end

local function startCokeFarming()
    cokeFarming = true
    cokeShouldStop = false
    lib.showTextUI('[G] Stop farming')

    while cokeFarming do
        local ped = cache.ped
        if #(GetEntityCoords(ped) - cokeFarmZone) > cokeRadius then
            lib.notify({ title = "Du forlod området", description = "Farming stoppet", type = "error" })
            break
        end

        lib.requestAnimDict(animDictFarm)
        TaskPlayAnim(ped, animDictFarm, animNameFarm, 8.0, -8.0, -1, 1, 0, false,false,false)

        local success = lib.progressBar({
            duration = cokeFarmingDuration*1000,
            label = "Høster kokainblade...",
            useWhileDead = false,
            canCancel = false,
            disable = { car=true, move=true, combat=true }
        })

        ClearPedTasks(ped)
        if success then
            TriggerServerEvent("coke_process:giveLeaves", cokeLeavesPerTick)
        else
            lib.notify({ title = "Farming annulleret", type = "error" })
            break
        end

        if cokeShouldStop then
            cokeFarming = false
            break
        end
        Wait(200)
    end
    cokeFarming = false
    lib.hideTextUI()
end

CreateThread(function()
    while true do
        Wait(0)
        if hashFarming and IsControlJustReleased(0, controls.stop) then
            hashShouldStop = true
            lib.notify({ title = "Farming", description = "Du stoppede hash farming.", type = "info" })
        end
        if cokeFarming and IsControlJustReleased(0, controls.stop) then
            cokeShouldStop = true
            lib.notify({ title = "Farming", description = "Du stoppede kokain farming.", type = "info" })
        end
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        local ped = cache.ped
        local coords = GetEntityCoords(ped)

        local distanceHash = #(coords - hashFarmZone)
        if distanceHash < hashRadius and not hashFarming then
            DrawMarker(drawMarker.type, hashFarmZone.x, hashFarmZone.y, hashFarmZone.z-0.95, 0,0,0,0,0,0,
                drawMarker.size.x, drawMarker.size.y, drawMarker.size.z,
                drawMarker.color.r, drawMarker.color.g, drawMarker.color.b, drawMarker.color.a,
                false,true,2,false,nil,nil,false)
            lib.showTextUI('[E] Start hash farming')
            if IsControlJustReleased(0, controls.start) then
                startHashFarming()
                Wait(500)
            end
        else
            lib.hideTextUI()
        end

        local distanceCoke = #(coords - cokeFarmZone)
        if distanceCoke < cokeRadius and not cokeFarming then
            DrawMarker(drawMarker.type, cokeFarmZone.x, cokeFarmZone.y, cokeFarmZone.z-0.95, 0,0,0,0,0,0,
                drawMarker.size.x, drawMarker.size.y, drawMarker.size.z,
                drawMarker.color.r, drawMarker.color.g, drawMarker.color.b, drawMarker.color.a,
                false,true,2,false,nil,nil,false)
            lib.showTextUI('[E] Start kokain farming')
            if IsControlJustReleased(0, controls.start) then
                startCokeFarming()
                Wait(500)
            end
        else
            lib.hideTextUI()
        end
    end
end)

RegisterNetEvent('weed_process:doSkillCheck', function(step)
    local ped = PlayerPedId()
    lib.requestAnimDict("amb@prop_human_bum_bin@idle_b")
    TaskPlayAnim(ped, "amb@prop_human_bum_bin@idle_b", "idle_d", 8.0, -8.0, -1, 1, 0, false,false,false)

    local success = lib.skillCheck({'easy','easy','easy'}, {'w','a','d'})
    local progress = lib.progressBar({
        duration = 5000,
        label = "Bearbejder hash...",
        useWhileDead = false,
        canCancel = true,
        disable = { car=true, move=true, combat=true }
    })
    ClearPedTasks(ped)

    if success and progress then
        TriggerServerEvent('weed_process:completeProcess', step)
    else
        TriggerServerEvent('weed_process:failedProcess', step)
        TriggerEvent('QBCore:Notify', "Du fejlede processen!", "error")
    end
end)

RegisterNetEvent('coke_process:doSkillCheck', function(step)
    local ped = PlayerPedId()
    lib.requestAnimDict("amb@prop_human_bum_bin@idle_b")
    TaskPlayAnim(ped, "amb@prop_human_bum_bin@idle_b", "idle_d", 8.0, -8.0, -1, 1, 0, false,false,false)

    local success = lib.skillCheck({'easy','easy','easy'}, {'a','s','d'})
    local progress = lib.progressBar({
        duration = 5000,
        label = "Bearbejder kokain...",
        useWhileDead = false,
        canCancel = true,
        disable = { car=true, move=true, combat=true }
    })
    ClearPedTasks(ped)

    if success and progress then
        TriggerServerEvent('coke_process:completeProcess', step)
    else
        TriggerServerEvent('coke_process:failedProcess', step)
        TriggerEvent('QBCore:Notify', "Du fejlede processen!", "error")
    end
end)

CreateThread(function()
    for _, location in pairs(Config.ProcessLocations) do
        exports.ox_target:addBoxZone({
            coords = location.coords,
            size = vec3(2.0,2.0,2.0),
            rotation = 45,
            debug = false,
            options = {
                {
                    name = location.processType,
                    icon = (location.processType == "hashToKlump") and 'fa-solid fa-seedling' or
                           (location.processType == "klumpToPose") and 'fa-solid fa-box' or
                           'fa-solid fa-hand',
                    label = (location.processType == "hashToKlump") and 'Omdan Hash' or
                            (location.processType == "klumpToPose") and 'Pak Hash' or
                            'Rul Joint',
                    onSelect = function()
                        TriggerServerEvent('weed_process:startProcessing', location.processType)
                    end,
                    canInteract = function()
                        return true
                    end
                }
            }
        })
    end

    for _, location in pairs(Config.CokeProcessLocations) do
        exports.ox_target:addBoxZone({
            coords = location.coords,
            size = vec3(2.0,2.0,2.0),
            rotation = 45,
            debug = false,
            options = {
                {
                    name = location.processType,
                    icon = 'fa-solid fa-box',
                    label = (location.processType == "kokainToPulver") and 'Omdan Kokain' or
                            'Lav Kokain Pose',
                    onSelect = function()
                        TriggerServerEvent('coke_process:startProcessing', location.processType)
                    end,
                    canInteract = function()
                        return true
                    end
                }
            }
        })
    end
end)
