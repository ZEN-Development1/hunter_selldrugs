ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand('dealer', function(source, args, rawcommand)
    xPlayer = ESX.GetPlayerFromId(source)
    drugToSell = {
        type = '',
        label = '',
        count = 0,
        i = 0,
        price = 0,
    }
    for k, v in pairs(Config.drugs) do
        item = xPlayer.getInventoryItem(k)
            
        if item == nil then
            return        
        end
            
        count = item.count
        drugToSell.i = drugToSell.i + 1
        drugToSell.type = k
        drugToSell.label = item.label
        
        if count >= 5 then
            drugToSell.count = math.random(1, 5)
        elseif count > 0 then
            drugToSell.count = math.random(1, count)
        end

        if drugToSell.count ~= 0 then
            drugToSell.price = drugToSell.count * v + math.random(1, 300)
            TriggerClientEvent('hunter_selldrugs:findClient', source, drugToSell)
            break
        end
        
        if ESX.Table.SizeOf(Config.drugs) == drugToSell.i and drugToSell.count == 0 then
            xPlayer.showNotification(Config.notify.nodrugs, 6)
        end
    end
end, false)

RegisterServerEvent('hunter_selldrugs:pay')
AddEventHandler('hunter_selldrugs:pay', function(drugToSell)
    xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(drugToSell.type, drugToSell.count)
    if Config.account == 'money' then
        xPlayer.addMoney(drugToSell.price)
    else
        xPlayer.addAccountMoney(Config.account, drugToSell.price)
    end
end)

RegisterServerEvent('hunter_selldrugs:notifycops')
AddEventHandler('hunter_selldrugs:notifycops', function(drugToSell)
    TriggerClientEvent('hunter_selldrugs:notifyPolice', -1, drugToSell.coords)
end)

ESX.RegisterServerCallback('hunter_selldrugs:getPoliceCount', function(source, cb)
    count = 0

    for _, playerId in pairs(ESX.GetPlayers()) do
        xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer.job.name == 'police' then
            count = count + 1
        end
    end

    cb(count)
end)
