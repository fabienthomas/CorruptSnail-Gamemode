AddTextEntry("SAFEZONE_BLIP_NAME", "Safezone")
Citizen.CreateThread(function()

    for _, safezone in ipairs(Config.Spawning.Safezones.SAFEZONES) do
        local blipCoords = safezone.Core
        local blip = AddBlipForCoord(safezone.Core.x, safezone.Core.y, 0.0)

        SetBlipSprite(blip, 487)
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, 0.9)
        EndTextCommandSetBlipName(blip)
        SetBlipNameFromTextFile(blip, "SAFEZONE_BLIP_NAME")
    end
end)