AddTextEntry("STATICZONE_BLIP_NAME", "Zone d'intérêt")
Citizen.CreateThread(function()
    for _, staticzone in ipairs(Config.Spawning.Staticzones) do
		
        local blipCoords = staticzone.Core
        local blip = AddBlipForCoord(blipCoords[1], blipCoords[2], 0)

        SetBlipSprite(blip, 303)
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, 0.75)
        EndTextCommandSetBlipName(blip)
        SetBlipNameFromTextFile(blip, "STATICZONE_BLIP_NAME")
    end
end)