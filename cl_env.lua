local isInVehicle = false
Utils.CreateLoadedInThread(function()
	DisplayRadar(not Config.HIDE_RADAR)
	Citizen.InvokeNative(0xE2B187C0939B3D32, 0)
	SetArtificialLightsState(true)
	
    SetAudioFlag("DisableFlightMusic", true)
    SetAudioFlag("PoliceScannerDisabled", true)
    StartAudioScene("FBI_HEIST_H5_MUTE_AMBIENCE_SCENE")

    if Config.FIRST_PERSON_LOCK then
        SetFollowPedCamViewMode(4)
        SetFollowVehicleCamViewMode(4)
    end

    for i = 1, 15 do
        EnableDispatchService(i, false)
    end
    
    while true do
        Wait(0)

        local playerId = PlayerId()

        HideHudComponentThisFrame(1)
        HideHudComponentThisFrame(3)
        HideHudComponentThisFrame(4)
		HideHudComponentThisFrame(6)
		HideHudComponentThisFrame(7)
		HideHudComponentThisFrame(8)
		HideHudComponentThisFrame(9)
        HideHudComponentThisFrame(13)
        
        if not Config.ENABLE_PEDS then
            SetPedDensityMultiplierThisFrame(0.0)
            SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
        end

        if not Config.ENABLE_TRAFFIC then
            SetVehicleDensityMultiplierThisFrame(0.0)
            SetParkedVehicleDensityMultiplierThisFrame(0.0)
            SetRandomVehicleDensityMultiplierThisFrame(0.0)
        end
        
        if IsPlayerWantedLevelGreater(playerId, 0) then
            ClearPlayerWantedLevel(playerId)
        end        

        if Config.FIRST_PERSON_LOCK then
			local ped = PlayerPedId()
			if not isInVehicle then
				if DoesEntityExist(GetVehiclePedIsTryingToEnter(ped)) and not isEnteringVehicle then
					isEnteringVehicle = true
				elseif not DoesEntityExist(GetVehiclePedIsTryingToEnter(ped)) and not IsPedInAnyVehicle(ped, true) and isEnteringVehicle then
					isEnteringVehicle = false
				elseif IsPedInAnyVehicle(ped, false) then
					isEnteringVehicle = false
					isInVehicle = true
				end
				DisableControlAction(0, 0, true)
			elseif isInVehicle then
				if not IsPedInAnyVehicle(ped, false) or IsPlayerDead(PlayerId()) then
					isInVehicle = false
					SetFollowPedCamViewMode(4)
					SetFollowVehicleCamViewMode(4)
				end
			end
        end
    end
end)

Citizen.CreateThread(function()
    if Config.ENV_SYNC then
        while true do
            Wait(10000)

            if Config.ENV_SYNC then
                NetworkOverrideClockTime(NetworkGetServerTime()) -- Simple time sync
                SetWeatherTypeNowPersist("FOGGY") -- TODO: Weather system!!!
            end
        end
    end
end)