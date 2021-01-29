--[[

	██╗░░░░░░█████╗░░█████╗░████████╗░░░██╗░██╗░██████╗░███████╗░█████╗░░█████╗░
	██║░░░░░██╔══██╗██╔══██╗╚══██╔══╝██████████╗╚════██╗██╔════╝██╔══██╗██╔══██╗
	██║░░░░░███████║██║░░██║░░░██║░░░╚═██╔═██╔═╝░░███╔═╝██████╗░╚██████║╚██████║
	██║░░░░░██╔══██║██║░░██║░░░██║░░░██████████╗██╔══╝░░╚════██╗░╚═══██║░╚═══██║
	███████╗██║░░██║╚█████╔╝░░░██║░░░╚██╔═██╔══╝███████╗██████╔╝░█████╔╝░█████╔╝
	╚══════╝╚═╝░░╚═╝░╚════╝░░░░╚═╝░░░░╚═╝░╚═╝░░░╚══════╝╚═════╝░░╚════╝░░╚════╝░
	
]]

local Keys = {["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118}

ESX = nil
PlayerData = {}

LAOT = nil

Peds = {}
LAOTDice = nil
Cam = nil

-- Geri kalan ayarlar
Playing = false
Stage = 0
Bet = C.MinimumBet
HerifinPuani = 0
GayOlanKisininPuani = 0
Game = 0
LastThrow = nil
GuyLastThrow = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
	while LAOT == nil do
		TriggerEvent('LAOTCore:getSharedObject', function(obj) LAOT = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('laot-gambling:client:RequestSync')
AddEventHandler('laot-gambling:client:RequestSync', function(data)
	LAOTDice = data
end)

-- Dice wait
Citizen.CreateThread(
	function()
		
		while ESX == nil do
			Citizen.Wait(10)
		end

		while LAOT == nil do
			Citizen.Wait(10)
		end

		TriggerServerEvent("laot-gambling:server:RequestSync")

		while LAOTDice == nil do
			Citizen.Wait(10)
		end

		for PedID, Ped in pairs(C.DiceSettings["Coords"]) do
			local lx = Ped["NPC"]
			local modelHash = LAOT.Streaming.LoadModel(C.DiceSettings["PedHash"])
			Peds[PedID] = CreatePed(0, modelHash, lx.x, lx.y, lx.z, lx.h, false, true)
			FreezeEntityPosition(Peds[PedID], true)
			SetBlockingOfNonTemporaryEvents(Peds[PedID], true)
			SetEntityInvincible(Peds[PedID], true)
			TaskStartScenarioInPlace(Peds[PedID], C.DiceSettings["Scenario"], 0, false)
		end

		while true do
			local yatismodu = 1350
			local ped = PlayerPedId()

			for PedID, Ped in pairs(C.DiceSettings["Coords"]) do 
				local dst = GetDistanceBetweenCoords(GetEntityCoords(ped), Ped.NPC["x"], Ped.NPC["y"], Ped.NPC["z"], true)
				local c = GetEntityCoords(ped)
				if isNight() then
					SetEntityAlpha(Peds[PedID], 255, 0)
					SetEntityCollision(Peds[PedID], true, true)
				else SetEntityAlpha(Peds[PedID], 0, 0) SetEntityCollision(Peds[PedID], false, true) end
				if not IsPedInAnyVehicle(ped, true) then
					if dst <= 3.7 then
						yatismodu = 1
						if isNight() and Stage == 0 then
							if not LAOTDice[PedID] then
								LAOT.DrawText3D(c.x, c.y, c.z, _U("LAOT_GLING_PLAYDICE"))
								if IsControlJustPressed(0, Keys["E"]) then
									PlayDice(PedID)
								end
							else
								LAOT.DrawText3D(c.x, c.y, c.z, _U("LAOT_GLING_CANTPLAY"))
							end
						else
							--
						end
					end
				end
			end

			Citizen.Wait(yatismodu)
		end

end)

isNight = function()
	local hour = GetClockHours()
	if hour > 19 or hour < 5 then
		return true
	end
end

Citizen.CreateThread(function() -- MS arttırıyor ancak bahisden sonra envanterdeki parayı yere atan aptal orospu çocukları için mecburen konulmuştur.
	while true do
		Citizen.Wait(10)
		if Playing then
			DisableControlAction(0, C.InventoryKey, true) -- Envanter
		end
	end
end)

CancelDice = function(PedID)
	Stage = 0
	Playing = false
	Bet = tonumber(C.MinimumBet)
	SetCamActive(Cam, false)
	RenderScriptCams(false, false, 1, true, true)
	FreezeEntityPosition(PlayerPedId(), false)
	SetEntityInvincible(PlayerPedId(), false)
	TriggerServerEvent("laot-gambling:server:ToggleDice", PedID)
end

PlayDice = function(PedID)
	ESX.TriggerServerCallback("laot-gambling:callback:CheckMoney", function(money) 
		if money >= tonumber(C.MinimumBet) then

			if not LAOTDice[PedID] then

				print("laot#2599")
				TriggerServerEvent("laot-gambling:server:ToggleDice", PedID)
				local v = C.DiceSettings["Coords"][PedID]["Camera"]
				local rl = C.DiceSettings["Coords"][PedID]["Player"]
				Cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", v[1], v[2], v[3], v[4], v[5], v[6], 70.0, false, 0)
				SetCamActive(Cam, true)
				RenderScriptCams(true, false, 1, true, true)
				TaskGoStraightToCoord(PlayerPedId(), rl.x, rl.y, rl.z, 50, 100, rl.h, 0)
				Citizen.Wait(800)
				SetEntityHeading(PlayerPedId(), rl.h)
				FreezeEntityPosition(PlayerPedId(), true)
				SetEntityInvincible(PlayerPedId(), true)

				Stage = 1
				Bet = tonumber(C.MinimumBet)

				HerifinPuani = 0
				GayOlanKisininPuani = 0
				Game = "throw"
				Playing = true

				while Stage == 1 do -- Bahis
					DisableControlAction(0, 24, true) -- Sol tık
					DisableControlAction(0, 25, true) -- Sağ tık
					DisableControlAction(0, 191, true) -- Enter
					DisableControlAction(0, 194, true) -- Backspace
					ESX.ShowHelpNotification("~g~~INPUT_ATTACK~ +25\n~b~Bahis: ~w~".. Bet .."\n~r~~INPUT_AIM~ -25\n\n~w~~INPUT_FRONTEND_RDOWN~ Başla!\n~w~~INPUT_FRONTEND_RRIGHT~ Ayrıl")
					if IsDisabledControlJustPressed(0, 24) then
						newBet = Bet + 25
						ESX.TriggerServerCallback("laot-gambling:callback:CheckMoney", function(money) 
							if money >= tonumber(newBet) then
								Bet = newBet
							end
						end)
					end
					if IsDisabledControlJustPressed(0, 25) then
						newBet = Bet - 25
						ESX.TriggerServerCallback("laot-gambling:callback:CheckMoney", function(money) 
							if newBet >= tonumber(C.MinimumBet) then
								if money >= tonumber(newBet) then
									Bet = newBet
								end
							end
						end)
					end
					if IsDisabledControlJustPressed(0, 194) then -- ayrılma
						CancelDice(PedID)
						return
					end
					if IsDisabledControlJustPressed(0, 191) then -- oyuna başlama
						Stage = 2
						-- oyun başladı hıamınaa
					end
					Citizen.Wait(10)
				end

				while Stage == 2 do -- Oyun
					DisableControlAction(0, 24, true) -- Sol tık
					DisableControlAction(0, 25, true) -- Sağ tık
					DisableControlAction(0, 191, true) -- Enter
					DisableControlAction(0, 194, true) -- Backspace
					if Game == 0 then
						-- yatış modu
					elseif Game == "guywins" then
						ESX.ShowHelpNotification("~r~Zar oyununu kaybettin! -".. Bet .."$\n\n~r~Herif: ~w~".. HerifinPuani .." puan\n~b~Sen: ~w~".. GayOlanKisininPuani .." puan")
					elseif Game == "playerwins" then
						ESX.ShowHelpNotification("~g~Zar oyununu kazandın! +".. Bet .."$\n\n~r~Herif: ~w~".. HerifinPuani .." puan\n~b~Sen: ~w~".. GayOlanKisininPuani .." puan")
					elseif Game == "throw" then
						ESX.ShowHelpNotification("Zar oyunu oynuyorsun.\nKazanırsan ".. Bet .."$ kazanacaksın!\n\n~r~Herif: ~w~".. HerifinPuani .." puan\n~b~Sen: ~w~".. GayOlanKisininPuani .." puan\n\n~b~~INPUT_FRONTEND_RDOWN~ Zar at.")
						if IsDisabledControlJustPressed(0, 191) then
							ThrowDice(PedID)
						end
					end
					Citizen.Wait(10)
				end	

			else
				LAOT.Notification("error", _U("LAOT_GLING_CANTPLAY"))
			end

		else
			LAOT.Notification("error", _U("LAOT_GLING_NOTENOUGHMONEY"))
		end
	end)
end

ThrowDice = function(id)

	ClearPedTasksImmediately(PlayerPedId())
	Game = "youthrowing"

	LAOT.Streaming.LoadAnimDict("anim@mp_player_intcelebrationmale@wank")
	TaskPlayAnim(PlayerPedId(), "anim@mp_player_intcelebrationmale@wank", "wank", 8.0, 1.0, 3.0, 0, 0, 0, 0, 0)
	Citizen.Wait(3000)
	ClearPedTasksImmediately(PlayerPedId())

	LastThrow = math.random(1, 6)
	print(LastThrow)

	ESX.ShowHelpNotification("Attığın zar: ~b~".. LastThrow)
	
	ClearPedTasksImmediately(Peds[id])
	LAOT.Streaming.LoadAnimDict("anim@mp_player_intcelebrationmale@wank")
	TaskPlayAnim(Peds[id], "anim@mp_player_intcelebrationmale@wank", "wank", 8.0, 1.0, 3.0, 0, 0, 0, 0, 0)
	Citizen.Wait(3000)

	GuyLastThrow = math.random(1, 6)
	print(GuyLastThrow)

	if LastThrow > GuyLastThrow then
		LAOT.Streaming.LoadAnimDict("gestures@m@standing@casual")
		TaskPlayAnim(Peds[id], "gestures@m@standing@casual", "gesture_damn", 8.0, 1.0, 3.0, 0, 0, 0, 0, 0)
		if math.random(1, 3) == 1 then
			LAOT.Streaming.LoadAnimDict("misscommon@response")
			TaskPlayAnim(PlayerPedId(), "misscommon@response", "screw_you", 8.0, 1.0, 3.0, 0, 0, 0, 0, 0)
		end

		ESX.ShowHelpNotification("Attığın zar: ~g~".. LastThrow.."\n~w~Onun attığı zar: ~r~".. GuyLastThrow.. "\n\n~w~Bir puan kazandın!", false, true, 2000)
		GayOlanKisininPuani = GayOlanKisininPuani + 1
	elseif LastThrow < GuyLastThrow then
		LAOT.Streaming.LoadAnimDict("gestures@m@standing@casual")
		TaskPlayAnim(PlayerPedId(), "gestures@m@standing@casual", "gesture_damn", 8.0, 1.0, 3.0, 0, 0, 0, 0, 0)
		if math.random(1, 3) == 1 then
			LAOT.Streaming.LoadAnimDict("misscommon@response")
			TaskPlayAnim(Peds[id], "misscommon@response", "screw_you", 8.0, 1.0, 3.0, 0, 0, 0, 0, 0)
		end

		HerifinPuani = HerifinPuani + 1 
		ESX.ShowHelpNotification("Attığın zar: ~r~".. LastThrow.."\n~w~Onun attığı zar: ~g~".. GuyLastThrow.. "\n\n~w~Herif bir puan aldı!", false, true, 2000) 
	elseif LastThrow == GuyLastThrow then
		ESX.ShowHelpNotification("İki zarda eşit, kimse puan almadı.", false, true, 2000)
	end

	Citizen.Wait(2000)
	TaskStartScenarioInPlace(Peds[id], C.DiceSettings["Scenario"], 0, false)
	if GayOlanKisininPuani >= C.WinPoint then
		ESX.TriggerServerCallback("laot-gambling:callback:AddMoney", function() 
			-- bir şey yapma.
		end, Bet)
		Game = "playerwins"
		CancelDice(id)
	elseif HerifinPuani >= C.WinPoint then
		ESX.TriggerServerCallback("laot-gambling:callback:RemoveMoney", function() 
			-- bir şey yapma.
		end, Bet)
		Game = "guywins"
		CancelDice(id)
	else
		Game = "throw"
	end


end