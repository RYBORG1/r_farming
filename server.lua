---- APEX DEVELOPMENT 
-- DISCORD.GG/K3YnEJzzDA

local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('weed_process:startProcessing', function(step)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local config = Config.ProcessAmounts[step]

    local hasAllItems = true
    for _, itemData in ipairs(config.give) do
        local item = Player.Functions.GetItemByName(itemData.item)
        if not item or item.amount < itemData.amount then
            hasAllItems = false
            break
        end
    end

    if hasAllItems then
        TriggerClientEvent('weed_process:doSkillCheck', src, step)
    else
        TriggerClientEvent('QBCore:Notify', src, "Du mangler nødvendige materialer!", "error")
    end
end)

RegisterServerEvent('coke_process:startProcessing', function(step)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local config = Config.ProcessAmounts[step]

    local hasAllItems = true
    for _, itemData in ipairs(config.give) do
        local item = Player.Functions.GetItemByName(itemData.item)
        if not item or item.amount < itemData.amount then
            hasAllItems = false
            break
        end
    end

    if hasAllItems then
        TriggerClientEvent('coke_process:doSkillCheck', src, step)
    else
        TriggerClientEvent('QBCore:Notify', src, "Du mangler nødvendige materialer!", "error")
    end
end)

RegisterServerEvent('weed_process:completeProcess', function(step)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local config = Config.ProcessAmounts[step]

    for _, itemData in ipairs(config.give) do
        Player.Functions.RemoveItem(itemData.item, itemData.amount)
    end
    Player.Functions.AddItem(config.receive.item, config.receive.amount)
    TriggerClientEvent('QBCore:Notify', src, "Du producerede "..config.receive.item.."!", "success")
end)

RegisterServerEvent('coke_process:completeProcess', function(step)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local config = Config.ProcessAmounts[step]

    for _, itemData in ipairs(config.give) do
        Player.Functions.RemoveItem(itemData.item, itemData.amount)
    end
    Player.Functions.AddItem(config.receive.item, config.receive.amount)
    TriggerClientEvent('QBCore:Notify', src, "Du producerede "..config.receive.item.."!", "success")
end)

RegisterServerEvent('weed_process:failedProcess', function(step)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local config = Config.ProcessAmounts[step]

    for _, itemData in ipairs(config.give) do
        Player.Functions.RemoveItem(itemData.item, itemData.amount)
    end
    TriggerClientEvent('QBCore:Notify', src, "Du mistede materialerne!", "error")
end)

RegisterServerEvent('coke_process:failedProcess', function(step)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local config = Config.ProcessAmounts[step]

    for _, itemData in ipairs(config.give) do
        Player.Functions.RemoveItem(itemData.item, itemData.amount)
    end
    TriggerClientEvent('QBCore:Notify', src, "Du mistede materialerne!", "error")
end)

RegisterServerEvent('weed_process:giveSeeds', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem("hashblade", amount)
end)

RegisterServerEvent('coke_process:giveLeaves', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem("kokainblade", amount)
end)
