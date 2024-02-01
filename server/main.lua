local spawnedPeds, netIdTable = {}, {}

-- get keys utils
local function get_key(t)
    local key
    for k, _ in pairs(t) do
        key = k
    end
    return key
end

function formatNumber(number)
    local formattedNumber = tostring(number):reverse():gsub("(%d%d%d)", "%1."):reverse():gsub("^%.", "")
    return formattedNumber
end

function ShowNotification(message, notifyType)
    local data = {
        title = Locale.Context.Title,
        description = message,
        type = notifyType,
        duration = 5000,
        position = 'top',
        style = {
            borderRadius = 7,
            padding = 8,
            userSelect = 'none',
            color = 'white',
            backgroundColor = '#212529',
        },
    }
    TriggerClientEvent('ox_lib:notify', source, data)
end

-- Resource starting
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    if HnL.EnablePeds then HnL_banking.CreatePeds() end
    local twoMonthMs = (os.time() - 5259487) * 1000
    MySQL.Sync.fetchScalar('DELETE FROM banking WHERE time < ? ', {twoMonthMs})
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    if HnL.EnablePeds then HnL_banking.DeletePeds() end
end)

if HnL.EnablePeds then
    AddEventHandler(HnL.Events.PlayerLoaded, function(playerId)
        TriggerClientEvent('hnl_banking:pedHandler', playerId, netIdTable)
    end)
end

-- event
RegisterServerEvent('hnl_banking:doingType')
AddEventHandler('hnl_banking:doingType', function(typ, input)
    if source == nil then return end

    local source = source

    if (typ == nil) or not typ then print(GetPlayerName(source).." is a cheater (triggered an event, but type was nil)") return end
    if typ ~= 'withdraw' or typ ~= 'deposit' then print(GetPlayerName(source).." is a cheater (triggered an event, but type was not 'withdraw' or 'deposit')") return end
    local xPlayer = HnL.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    local money = xPlayer.getAccount('money').money
    local bankMoney = xPlayer.getAccount('bank').money
    local amount

    if typ == 'withdraw' then
        money = xPlayer.getAccount('money').money
        bankMoney = xPlayer.getAccount('bank').money
        if bankMoney < input then
            ShowNotification(Locale.NotEnoughMoney.Bank, Locale.NotEnoughMoney.Type)
        else
            HnL_banking.Withdraw(input, xPlayer)
            ShowNotification(Locale.Context.Withdrawn..formatNumber(input)..Locale.Currency, 'success')
        end
    end
    if typ == 'deposit' then
        money = xPlayer.getAccount('money').money
        bankMoney = xPlayer.getAccount('bank').money
        if money < input then
            ShowNotification(Locale.NotEnoughMoney.Wallet, Locale.NotEnoughMoney.Type)
        else
            HnL_banking.Deposit(input, xPlayer)
            ShowNotification(Locale.Context.Deposited..formatNumber(input)..Locale.Currency, 'success')
        end
    end
end)

-- register callbacks
lib.callback.register("hnl_banking:getPlayerData", function(source)
    local xPlayer = HnL.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    local weekAgo = (os.time() - 604800) * 1000
    local transactionHistory = MySQL.Sync.fetchAll(
        'SELECT * FROM banking WHERE identifier = ? AND time > ? ORDER BY time DESC LIMIT 10', {identifier, weekAgo})
    local playerData = {
        playerName = xPlayer.getName(),
        money = xPlayer.getAccount('money').money,
        bankMoney = xPlayer.getAccount('bank').money,
        transactionHistory = transactionHistory
    }

    return playerData
end)

function logTransaction(targetSource,label, key,amount)
    if targetSource == nil then
        print("~w~[~r~ERROR~w~] TargetSource nil!")
        return
    end

    if key == nil then
        print("~w~[~r~ERROR~w~] Do you need use these: WITHDRAW,DEPOSIT,TRANSFER_RECEIVE")
        return
    end
    
    if type(key) ~= "string" or key == '' then
        print("~w~[~r~ERROR~w~] Do you need use these: WITHDRAW,DEPOSIT,TRANSFER_RECEIVE and can only be string type!")
        return
    end

    if amount == nil then
        print("~w~[~r~ERROR~w~] Amount value is nil! Add some numeric value to the amount!")
        return
    end

    if label == nil then
        label = "UNKNOWN LABEL"
    end

    local xPlayer = HnL.GetPlayerFromId(tonumber(targetSource))

    if xPlayer ~= nil then
        local bankCurrentMoney = xPlayer.getAccount('bank').money
        HnL_banking.LogTransaction(targetSource, label, string.upper(key), amount, bankCurrentMoney)  
    else
        print("ERROR: xPlayer is nil!") 
    end
end
exports("logTransaction", logTransaction)

RegisterServerEvent('hnl_banking:logTransaction')
AddEventHandler('hnl_banking:logTransaction', function(label,key,amount)
    logTransaction(source,label,key,amount)
end)

-- bank functions
HnL_banking = {
    CreatePeds = function()
        for i = 1, #HnL.NPCs do
            local model = HnL.NPCs[i].Model
            local coords = HnL.NPCs[i].Position
            spawnedPeds[i] = CreatePed(0, model, coords.x, coords.y, coords.z, coords.w, true, true)
            netIdTable[i] = NetworkGetNetworkIdFromEntity(spawnedPeds[i])
            while not DoesEntityExist(spawnedPeds[i]) do Wait(50) end
        end

        Wait(100)
        TriggerClientEvent('hnl_banking:pedHandler', -1, netIdTable)
    end,
    DeletePeds = function()
        for i = 1, #spawnedPeds do
            DeleteEntity(spawnedPeds[i])
            spawnedPeds[i] = nil
        end
    end,
    Withdraw = function(amount, xPlayer, name)
        xPlayer.addAccountMoney('money', amount)
        xPlayer.removeAccountMoney('bank', amount)
    end,
    Deposit = function(amount, xPlayer)
        xPlayer.removeAccountMoney('money', amount)
        xPlayer.addAccountMoney('bank', amount)
    end,
    LogTransaction = function(playerId, label, logType, amount, bankMoney)
        if playerId == nil then
            return
        end

        if label == nil then
            label = logType
        end

        local xPlayer = HnL.GetPlayerFromId(playerId)
        local identifier = xPlayer.getIdentifier()
    
        MySQL.insert('INSERT INTO banking (identifier, label, type, amount, time, balance) VALUES (?, ?, ?, ?, ?, ?)',
            {identifier,label,logType,amount, os.time() * 1000, bankMoney})
    end   
}