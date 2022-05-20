Player = {}

function Player.IsSpawnHost()
    local mPlayerId = PlayerId()
    local mServerId = GetPlayerServerId(mPlayerId)
    local mPlayerPedPos = GetEntityCoords(PlayerPedId())

    for _, playerId in ipairs(GetActivePlayers()) do
        if playerId ~= mPlayerId then
            if GetPlayerServerId(playerId) > mServerId and Utils.GetDistanceBetweenCoords(mPlayerPedPos,
                GetEntityCoords(GetPlayerPed(playerId))) <= Config.Spawning.HOST_DECIDE_DIST then
                return false
            end
        end
    end

    return true
end

function Player.IsInStaticZone()
	local mPlayerId = PlayerId()
    local mPlayerPedPos = GetEntityCoords(PlayerPedId())
	
	local isInStaticzone, zone = false, nil
	for _, staticzone in ipairs(Config.Spawning.Staticzones) do	
		if not isInStaticzone then
			local dist = #(mPlayerPedPos.xy - staticzone.Core.xy)
			if dist < staticzone.Radius then
				isInStaticzone = true
				zone = staticzone
				break
			end
		end
	end
	
	return isInStaticzone, zone
end

local wasInSafeZone = false
function Player.IsInSafeZone()
	local mPlayerId = PlayerId()
    local mPlayerPedPos = GetEntityCoords(PlayerPedId())
	
	local isInSafezone = false
	for _, safezone in ipairs(Config.Spawning.Safezones.SAFEZONES) do	
		if not isInSafezone then
			local dist = #(mPlayerPedPos.xy - safezone.Core.xy)
			if dist < safezone.Radius then
				isInSafezone = true
				break
			end
		end
	end
	
	return isInSafezone
end

Utils.CreateLoadedInThread(function()
	local wasInSafeZone = false
    while true do
        Wait(250)
		local isInSafezone = Player.IsInSafeZone()
		if not wasInSafeZone and isInSafezone then
			exports.mista_overlay:Notify({description = 'Ok, tu peux relâcher un peu ton attention...'})
			wasInSafeZone = true
		end
		
		if not isInSafezone and wasInSafeZone then
			exports.mista_overlay:Notify({description = 'Attention, c\'est dangereux à partir d\'ici !'})
			wasInSafeZone = false
		end
	end
end)