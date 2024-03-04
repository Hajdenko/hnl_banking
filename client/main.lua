local HnL_banking = {
    Data = {}
}

local activeBlips, bankPoints, atmPoints = {}, {}, {}
local playerLoaded, inMenu = false

function DebugPrint(...)
    if HnL.Debug then print("^7[^3DEBUG^7] ^2".. ...) end
end

function ShowNotification(message, notifyType)
    lib.notify({
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
    })
end

RegisterNetEvent('hajden_garage:showNotification')
AddEventHandler('hajden_garage:showNotification', ShowNotification)

function ShowTextUI(text, icon)
    if icon == 0 then
        lib.showTextUI(text, {
            position = "right-center",
            style = {
                borderRadius = 7,
                padding = 8,
                userSelect = 'none',
                color = 'white',
                backgroundColor = '#212529',
            }
        })
    else
        lib.showTextUI(text, {
            position = "right-center",
            icon = icon,
            style = {
                borderRadius = 7,
                padding = 8,
                userSelect = 'none',
                color = 'white',
                backgroundColor = '#212529',
            }
        })
    end;
end

function HideTextUI()
    lib.hideTextUI()
end






















-- DO not change anything bellow if you don't know what are you doing.


function HnL_banking:GetData()
	local data = self.Data
    self:CreateBlips()
    data.ped = PlayerPedId()
    data.coord = GetEntityCoords(data.Ped)
    playerLoaded = true

    CreateThread(function()
        while playerLoaded do
            local resourceName = GetCurrentResourceName()
            if resourceName ~= 'hnl_banking' then
            print('^3 What are you doing?.. Can you just keep the name as it is? :/ Did you created the script? No.. Then please keep it as it it. ' .. resourceName.. ' needs to be named hnl_banking :(')
            break end
            data.coord = GetEntityCoords(data.ped)
            data.ped = PlayerPedId()
            bankPoints, atmPoints = {}, {}

            if (IsPedOnFoot(data.ped) and not IsPedDeadOrDying(data.ped)) and not inMenu then
                for i = 1, #HnL.ATMModels do
                    local atm = GetClosestObjectOfType(data.coord.x, data.coord.y, data.coord.z, 0.7, HnL.ATMModels[i], false, false, false)
                    if atm ~= 0 then
                        atmPoints[#atmPoints+1] = GetEntityCoords(atm)
                    end
                end

                for i = 1, #HnL.BankLocs do
                    local bankDistance = #(data.coord - HnL.BankLocs[i].Position.xyz)
                    if bankDistance <= 1.0 then
                        bankPoints[#bankPoints+1] = HnL.BankLocs[i].Position.xyz
                    end
                    if bankDistance <= 7 then
                        if HnL.DeleteBankDoor then
                            HnL_banking:RemoveBankDoor()
                        end
                    end
                end
            end

            if next(bankPoints) and not contextActive then
                self:TextUi(true)
            end

            if next(atmPoints) and not contextActive then
                self:TextUi(true, true)
            end

            if not next(bankPoints) and not next(atmPoints) and contextActive then
                self:TextUi(false)
            end

            Wait(1000)
        end
    end)
end
local dpst = 'deposit'
function HnL_banking:RemoveBankDoor()
    local removeprops = {
        -131754413
    }
    for i = 1, #removeprops do
        local player = PlayerId()
        local plyPed = GetPlayerPed(player)
        local plyPos = GetEntityCoords(plyPed, false)
     
        local prop = GetClosestObjectOfType(plyPos.x, plyPos.y, plyPos.z, 200.0, GetHashKey(removeprops[i]), false, 0, 0)
        if prop ~= 0 then
            SetEntityAsMissionEntity(prop, true, true)
            DeleteObject(prop)
            SetEntityAsNoLongerNeeded(prop)
            DebugPrint("^1"..prop .. " ^0Prop deleted")
        end
        local prophash = GetClosestObjectOfType(plyPos.x, plyPos.y, plyPos.z, 200.0, removeprops[i], false, 0, 0)
        if prophash ~= 0 then
            SetEntityAsMissionEntity(prophash, true, true)
            DeleteObject(prophash)
            DeleteEntity(prophash)
            DeletePed(prophash)
            RemoveForcedObject(prophash)
            SetEntityAsNoLongerNeeded(prophash)
            DebugPrint("^1"..prophash .. " ^0Prop deleted")
        end
    end
    Wait(10000)
end

if lib.getOpenContextMenu() == 'bank:open' or lib.getOpenContextMenu() == 'bank:deposit' or lib.getOpenContextMenu() == 'bank:withdraw' then
    lib.hideContext()
    ClearPedTasksImmediately(ped)
    ShowNotification(Locale.Context.CloseContextOnRestart, 'warning')
end
local wdrw = 'withdraw'
function HnL_banking:formatNumber(number)
    local formattedNumber = tostring(number):reverse():gsub("(%d%d%d)", "%1."):reverse():gsub("^%.", "")
    return formattedNumber
end

function HnL_banking:RegisterContext(data, atm)
    local Woptions = {
        {
            title = Locale.Context.MoneyInBank..HnL_banking:formatNumber(data.bankMoney)..Locale.Currency..
                    '\n'..Locale.Context.MoneyInWallet..HnL_banking:formatNumber(data.money)..Locale.Currency,
            icon = Locale.Context.MoneyIcon,
            iconColor = Locale.Context.MoneyIconColor,
            disabled = true,
        },
        {
            title = Locale.Context.Withdraw,
            icon = Locale.Context.WithdrawIcon,
            iconColor = Locale.Context.WithdrawIconColor,
            onSelect = function()
                DebugPrint('selected withdraw')
                local input = lib.inputDialog(Locale.Context.Withdraw, {
                    {type = 'number', label = Locale.Context.WithdrawHowMuch, description = Locale.Context.OnlyNumbers, required = true, min = 1},
                })
                if input ~= nil then
                    TriggerServerEvent('hnl_banking:doingType', wdrw, tonumber(input[1]))
                    lib.callback('hnl_banking:getPlayerData', false, function(data)
                        self:RegisterContext(data, false)
                        lib.showContext('bank:open')
                    end)
                end
            end
        },
    }
    local Doptions = {
        {
            title = Locale.Context.MoneyInBank..HnL_banking:formatNumber(data.bankMoney)..Locale.Currency..
                    '\n'..Locale.Context.MoneyInWallet..HnL_banking:formatNumber(data.money)..Locale.Currency,
            icon = Locale.Context.MoneyIcon,
            iconColor = Locale.Context.MoneyIconColor,
            disabled = true,
        },
        {
            title = Locale.Context.Deposit,
            icon = Locale.Context.DepositIcon,
            iconColor = Locale.Context.DepositIconColor,
            onSelect = function()
                DebugPrint('selected deposit')
                local input = lib.inputDialog(Locale.Context.Deposit, {
                    {type = 'number', label = Locale.Context.DepositHowMuch, description = Locale.Context.OnlyNumbers, required = true, min = 1},
                })
                if input ~= nil then
                    TriggerServerEvent('hnl_banking:doingType', dpst, tonumber(input[1]))
                    lib.callback('hnl_banking:getPlayerData', false, function(data)
                        self:RegisterContext(data, false)
                        lib.showContext('bank:open')
                    end)
                end
            end
        }
    }
    
    for _, v in ipairs(HnL.fastWithdrawOptions) do
        table.insert(Woptions, {
            title = Locale.Context.Withdraw.. ' ' .. HnL_banking:formatNumber(v.hmch) .. Locale.Currency,
            description = Locale.Context.FastWithdraw_desc,
            icon = Locale.Context.WithdrawIcon,
            iconColor = Locale.Context.WithdrawIconColor,
            onSelect = function()
                DebugPrint('selected fast withdraw ' .. v.hmch)
                TriggerServerEvent('hnl_banking:doingType', wdrw, v.hmch)
                lib.callback('hnl_banking:getPlayerData', false, function(data)
                    self:RegisterContext(data, false)
                    lib.showContext('bank:open')
                end)
            end
        })
    end
    for _, k in ipairs(HnL.fastDepositOptions) do
        table.insert(Doptions, {
            title = Locale.Context.Deposit.. ' ' .. HnL_banking:formatNumber(k.hmch) .. Locale.Currency,
            description = Locale.Context.FastDeposit_desc,
            icon = Locale.Context.DepositIcon,
            iconColor = Locale.Context.DepositIconColor,
            onSelect = function()
                DebugPrint('selected fast deposit ' .. k.hmch)
                TriggerServerEvent('hnl_banking:doingType', dpst, k.hmch)
                lib.callback('hnl_banking:getPlayerData', false, function(data)
                    self:RegisterContext(data, false)
                    lib.showContext('bank:open')
                end)
            end
        })
    end
	if HnL.Context.WelcomeMessage and not atm then
		lib.registerContext({
			id = 'bank:open',
			title = Locale.Context.Title,
			options = {
				{
					title = Locale.Context.WelcomeMessage.Hello ..data.playerName,
					disabled = true,
				},
				{
					title = Locale.Context.MoneyInBank..HnL_banking:formatNumber(data.bankMoney)..Locale.Currency..
							'\n'..Locale.Context.MoneyInWallet..HnL_banking:formatNumber(data.money)..Locale.Currency,
					icon = Locale.Context.MoneyIcon,
					iconColor = Locale.Context.MoneyIconColor,
					disabled = true,
				},
				{
					title = Locale.Context.Withdraw,
					arrow = true,
					menu = 'bank:withdraw',
					description = Locale.Context.Withdraw_desc,
					icon = Locale.Context.WithdrawIcon,
					iconColor = Locale.Context.WithdrawIconColor,
				},
				{
					title = Locale.Context.Deposit,
					arrow = true,
					menu = 'bank:deposit',
					description = Locale.Context.Deposit_desc,
					icon = Locale.Context.DepositIcon,
					iconColor = Locale.Context.DepositIconColor,
				},
			},
		})
        lib.registerContext({
            id = 'bank:withdraw',
            title = Locale.Context.Withdraw,
            menu = 'bank:open',
            options = Woptions
        })
	else
		lib.registerContext({
			id = 'bank:open',
			title = Locale.Context.Title,
			options = {
				{
					title = Locale.Context.MoneyInBank..HnL_banking:formatNumber(data.bankMoney)..Locale.Currency..
							'\n'..Locale.Context.MoneyInWallet..HnL_banking:formatNumber(data.money)..Locale.Currency,
                    icon = Locale.Context.MoneyIcon,
                    iconColor = Locale.Context.MoneyIconColor,
					disabled = true,
				},
				{
					title = Locale.Context.Withdraw,
					arrow = true,
					menu = 'bank:withdraw',
					description = Locale.Context.Withdraw_desc,
					icon = Locale.Context.WithdrawIcon,
					iconColor = Locale.Context.WithdrawIconColor,
				},
				{
					title = Locale.Context.Deposit,
					arrow = true,
					menu = 'bank:deposit',
					description = Locale.Context.Deposit_desc,
					icon = Locale.Context.DepositIcon,
					iconColor = Locale.Context.DepositIconColor,
				},
			},
		})
        lib.registerContext({
            id = 'bank:withdraw',
            title = Locale.Context.Withdraw,
            menu = 'bank:open',
            options = Woptions
        })
	end
    if HnL.Context.WelcomeMessage and atm then
		lib.registerContext({
			id = 'bank:open',
			title = Locale.Context.TitleATM,
			options = {
				{
					title = Locale.Context.WelcomeMessage.Hello .. data.playerName,
					disabled = true,
				},
				{
					title = Locale.Context.MoneyInBank..HnL_banking:formatNumber(data.bankMoney)..Locale.Currency..
							'\n'..Locale.Context.MoneyInWallet..HnL_banking:formatNumber(data.money)..Locale.Currency,
                    icon = Locale.Context.MoneyIcon,
                    iconColor = Locale.Context.MoneyIconColor,
					disabled = true,
				},
				{
					title = Locale.Context.Withdraw,
					arrow = true,
					menu = 'bank:withdraw',
					description = Locale.Context.Withdraw_desc,
					icon = Locale.Context.WithdrawIcon,
					iconColor = Locale.Context.WithdrawIconColor,
				},
                {
					title = Locale.Context.Deposit,
					arrow = true,
					menu = 'bank:deposit',
					description = Locale.Context.Deposit_desc,
					icon = Locale.Context.DepositIcon,
					iconColor = Locale.Context.DepositIconColor,
				},
			},
		})
        lib.registerContext({
            id = 'bank:withdraw',
            title = Locale.Context.Withdraw,
            menu = 'bank:open',
            options = Woptions
        })
	elseif not HnL.Context.WelcomeMessage and atm then
		lib.registerContext({
			id = 'bank:open',
			title = Locale.Context.TitleATM,
			options = {
				{
					title = Locale.Context.MoneyInBank..HnL_banking:formatNumber(data.bankMoney)..Locale.Currency..
							'\n'..Locale.Context.MoneyInWallet..HnL_banking:formatNumber(data.money)..Locale.Currency,
                    icon = Locale.Context.MoneyIcon,
                    iconColor = Locale.Context.MoneyIconColor,
					disabled = true,
				},
				{
					title = Locale.Context.Withdraw,
					arrow = true,
					menu = 'bank:withdraw',
					description = Locale.Withdraw_desc,
					icon = Locale.Context.WithdrawIcon,
					iconColor = Locale.Context.WithdrawIconColor,
				},
			},
		})
        lib.registerContext({
            id = 'bank:withdraw',
            title = Locale.Context.Withdraw,
            menu = 'bank:open',
            options = {
                {
					title = Locale.Context.MoneyInBank..HnL_banking:formatNumber(data.bankMoney)..Locale.Currency..
							'\n'..Locale.Context.MoneyInWallet..HnL_banking:formatNumber(data.money)..Locale.Currency,
					icon = Locale.Context.MoneyIcon,
					iconColor = Locale.Context.MoneyIconColor,
					disabled = true,
				},
                {
                    title = Locale.Context.Withdraw,
                    icon = Locale.Context.WithdrawIcon,
					iconColor = Locale.Context.WithdrawIconColor,
                    onSelect = function()
                        DebugPrint('selected withdraw')
                        local input = lib.inputDialog(wdrw, {
                            {type = 'number', label = Locale.Context.WithdrawHowMuch, description = Locale.Context.OnlyNumbers, required = true, min = 1},
                        })
                        if input ~= nil then
                            TriggerServerEvent('hnl_banking:doingType', wdrw, tonumber(input[1]))
                            lib.callback('hnl_banking:getPlayerData', false, function(data)
                                self:RegisterContext(data, true)
                                lib.showContext('bank:open')
                            end)
                        end
                    end
                }
            }
        })
	end
	lib.registerContext({
		id = 'bank:deposit',
		title = Locale.Context.Deposit,
		menu = 'bank:open',
		options = Doptions
	})
end

-- Handle text ui / Keypress
function HnL_banking:TextUi(state, atm)
    contextActive = state
    if not state then
        return HideTextUI()
    end
    CreateThread(function()
        while contextActive do
            ShowTextUI(Locale.TextUi.text, Locale.TextUi.icon)
            Wait(25)
        end
    end)
    CreateThread(function()
        while contextActive do
            if IsControlJustReleased(0, 38) then
				lib.callback('hnl_banking:getPlayerData', false, function(data)
					if not atm then
					    self:RegisterContext(data, false)
                    else
                        self:RegisterContext(data, true)
                    end
                    lib.showContext('bank:open')
				end)
            end
            Wait(0)
        end
    end)
end

-- Create Blips
function HnL_banking:CreateBlips()
    local tmpActiveBlips = {}
    for i = 1, #HnL.BankLocs do
        if type(HnL.BankLocs[i].Blip) == 'table' and HnL.BankLocs[i].Blip.Enabled then
            if HnL.SpecialBlipFont.Enabled then
                local position = HnL.BankLocs[i].Position
                local bInfo = HnL.BankLocs[i].Blip
                local blip = AddBlipForCoord(position.x, position.y, position.z)
                SetBlipSprite(blip, bInfo.Sprite)
                SetBlipScale(blip, bInfo.Scale)
                SetBlipColour(blip, bInfo.Color)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentSubstringPlayerName(HnL.SpecialBlipFont.BlipFontCode..bInfo.Label)
                EndTextCommandSetBlipName(blip)
                tmpActiveBlips[#tmpActiveBlips + 1] = blip
            else
                local position = HnL.BankLocs[i].Position
                local bInfo = HnL.BankLocs[i].Blip
                local blip = AddBlipForCoord(position.x, position.y, position.z)
                SetBlipSprite(blip, bInfo.Sprite)
                SetBlipScale(blip, bInfo.Scale)
                SetBlipColour(blip, bInfo.Color)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentSubstringPlayerName(bInfo.Label)
                EndTextCommandSetBlipName(blip)
                tmpActiveBlips[#tmpActiveBlips + 1] = blip
            end
        end
    end

    activeBlips = tmpActiveBlips
end

-- Remove blips
function HnL_banking:RemoveBlips()
    for i = 1, #activeBlips do
        if DoesBlipExist(activeBlips[i]) then
            RemoveBlip(activeBlips[i])
        end
    end
    activeBlips = {}
end

-- Load NPC
function HnL_banking:LoadNpc(index, netID)
    CreateThread(function()
        while not NetworkDoesEntityExistWithNetworkId(netID) do
            Wait(200)
        end
        local npc = NetworkGetEntityFromNetworkId(netID)
        SetEntityProofs(npc, true, true, true, true, true, true, true, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
        FreezeEntityPosition(npc, true)
        SetPedCanRagdollFromPlayerImpact(npc, false)
        SetPedCanRagdoll(npc, false)
        SetEntityAsMissionEntity(npc, true, true)
        SetEntityDynamic(npc, false)
    end)
end

-- Events

RegisterNetEvent('hnl_banking:pedHandler', function(netIdTable)
    for i = 1, #netIdTable do
        HnL_banking:LoadNpc(i, netIdTable[i])
    end
end)

-- Handlers
-- Resource starting
AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    HnL_banking:GetData()
end)

-- Enable the script on player loaded 
RegisterNetEvent(HnL.Events.PlayerLoaded, function()
    HnL_banking:GetData()
end)

-- Disable the script on player logout
RegisterNetEvent(HnL.Events.PlayerLogout, function()
    playerLoaded = false
end)

-- Resource stopping
AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    HnL_banking:RemoveBlips()
    if contextActive then HnL_banking:TextUi(false) end
end)
RegisterNetEvent(HnL.Events.PlayerDeath, function() HnL_banking:TextUi(false) end)
