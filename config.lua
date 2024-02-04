
--------------------------------------------------------------------------------
-- Hi, If you want to change the TextUi, Notifications etc. go to client.lua. --
--------------------------------------------------------------------------------

HnL = {
	-- [ Framework ] --

	Debug = false, -- enable debug prints in console (F8) Mostly for development

	Events = {
		PlayerLoaded = 'esx:playerLoaded',
		PlayerLogout = 'esx:onPlayerLogout',
		PlayerDeath = 'esx:onPlayerDeath',
	},
	GetPlayerFromId = function(src) -- make your own function for your server
        ESX = exports["es_extended"]:getSharedObject() -- esx default
        ESX.GetPlayerFromId(src)

		-- QBCore = exports['qb-core']:GetSharedObject() -- QBCore
        -- QBCore.Functions.GetPlayer(src)
	end,

	-- [ Framework ] --


	-- [ Server Settings ] --
	SpecialBlipFont = { -- relisoft_core or some other script for font streaming. ->  If you don't know what is this, just leave it as it is.  <-
		Enabled = true,
		BlipFontCode = '<font face="Fire Sans">', -- .. will be added before text automatically.
	},


	DeleteBankDoor = false, -- deletes the fleeca bank door to npc. If you have it on true you will have *HIGHER RESMON* by 0.01ms.

	EnablePeds = true, -- want to have ped in banks?

	-- [ Server Settings ] --


	-- [ Script Settings ] --
	Context = { -- Context = the menu that opens as a bank
		WelcomeMessage = true, -- Basicly just says Hello, playername
	},

	fastWithdrawOptions = {
		{hmch = 50000},
		{hmch = 100000},
		{hmch = 250000},
		{hmch = 500000},
		{hmch = 1000000},
		-- add more
	},
	fastDepositOptions = {
		{hmch = 50000},
		{hmch = 100000},
		{hmch = 250000},
		{hmch = 500000},
		{hmch = 1000000},
		-- add more
	},

	-- this site will help you with bellow -> https://gta-objects.xyz
	ATMModels = {-- models of atms (when you get near the model it will show text ui that can open bank)
		`prop_fleeca_atm`, 
		`prop_atm_01`,
		`prop_atm_02`,
		`prop_atm_03`
	 -- `add_more_:)`
	},
	BankLocs = {
		{
			Position = vector4(149.91, -1040.74, 29.374, 160),
			Target = vector3(149.91, -1040.74, 29.374),
			Blip = {
				Enabled = true,
				Color = 69,
				Label = 'Bank',
				Sprite = 108,
				Scale = 0.7
			}
		},
		{
			Position = vector4(-1212.63, -330.78, 37.59, 210),
			Target = vector3(-1212.63, -330.78, 37.59),
			Blip = {
				Enabled = true,
				Color = 69,
				Label = 'Bank',
				Sprite = 108,
				Scale = 0.7
			}
		},
		{
			Position = vector4(-2962.47, 482.93, 15.5, 270),
			Target = vector3(-2962.47, 482.93, 15.5),
			Blip = {
				Enabled = true,
				Color = 69,
				Label = 'Bank',
				Sprite = 108,
				Scale = 0.7
			}
		},
		{
			Position = vector4(-113.01, 6470.24, 31.43, 315),
			Target = vector3(-113.01, 6470.24, 31.43),
			Blip = {
				Enabled = true,
				Color = 69,
				Label = 'Bank',
				Sprite = 108,
				Scale = 0.7
			}
		},
		{
			Position = vector4(314.16, -279.09, 53.97, 160),
			Target = vector3(314.16, -279.09, 53.97),
			Blip = {
				Enabled = true,
				Color = 69,
				Label = 'Bank',
				Sprite = 108,
				Scale = 0.7
			}
		},
		{
			Position = vector4(-350.99, -49.99, 48.84, 160),
			Target = vector3(-350.99, -49.99, 48.84),
			Blip = {
				Enabled = true,
				Color = 69,
				Label = 'Bank',
				Sprite = 108,
				Scale = 0.7
			}
		},
		{
			Position = vector4(1175.02, 2706.87, 37.89, 0),
			Target = vector3(1175.02, 2706.87, 37.89),
			Blip = {
				Enabled = true,
				Color = 69,
				Label = 'Bank',
				Sprite = 108,
				Scale = 0.7
			}
		},
		{
			Position = vector4(246.63, 223.62, 106.0, 160),
			Target = vector3(246.63, 223.62, 106.0),
			Blip = {
				Enabled = true,
				Color = 69,
				Label = 'Bank',
				Sprite = 108,
				Scale = 0.7
			}
		},
	},
	NPCs = {
		{
			Position = vector4(149.5513, -1042.1570, 29.3680, 341.6520),
			Model = `U_M_M_BankMan`,
		},
		{
			Position = vector4(-1211.8585, -331.9854, 37.7809, 28.5983),
			Model = `U_M_M_BankMan`,
		},
		{
			Position = vector4(-2961.0720, 483.1107, 15.6970, 88.1986),
			Model = `U_M_M_BankMan`,
		},
		{
			Position = vector4(-112.2223, 6471.1128, 31.6267, 132.7517),
			Model = `U_M_M_BankMan`,
		},
		{
			Position = vector4(313.8176, -280.5338, 54.1647, 339.1609),
			Model = `U_M_M_BankMan`,
		},
		{
			Position = vector4(-351.3247, -51.3466, 49.0365, 339.3305),
			Model = `U_M_M_BankMan`,
		},
		{
			Position = vector4(1174.9718, 2708.2034, 38.0879, 178.2974),
			Model = `U_M_M_BankMan`,
		},
		{
			Position = vector4(247.0348, 225.1851, 106.2875, 158.7528),
			Model = `U_M_M_BankMan`,
		}
	},
}

