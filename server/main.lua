ESX = nil
LAOT = nil

TriggerEvent('LAOTCore:GetObject', function(obj) LAOT = obj end)
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

LAOTDice = {
    [1] = false, -- false == oynanmıyor, true == oynanıyor
    [2] = false, -- false == oynanmıyor, true == oynanıyor
    [3] = false, -- false == oynanmıyor, true == oynanıyor
    [4] = false, -- false == oynanmıyor, true == oynanıyor
}

RegisterNetEvent('laot-gambling:server:RequestSync')
AddEventHandler('laot-gambling:server:RequestSync', function()
    TriggerClientEvent("laot-gambling:client:RequestSync", -1, LAOTDice)
end)

RegisterNetEvent('laot-gambling:server:ToggleDice')
AddEventHandler('laot-gambling:server:ToggleDice', function(diceid)
    LAOTDice[diceid] = not LAOTDice[diceid]
    TriggerEvent("laot-gambling:server:RequestSync")
end)

ESX.RegisterServerCallback("laot-gambling:callback:CheckItem", function(source, cb, item)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local amount = Player.getInventoryItem(item).count

    cb(amount)
end)

ESX.RegisterServerCallback("laot-gambling:callback:CheckMoney", function(source, cb)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    
    cb(Player.getMoney())
end)

ESX.RegisterServerCallback("laot-gambling:callback:AddMoney", function(source, cb, bet)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    
    cb(Player.addMoney(bet))
end)

ESX.RegisterServerCallback("laot-gambling:callback:RemoveMoney", function(source, cb, bet)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    
    cb(Player.removeMoney(bet))
end)