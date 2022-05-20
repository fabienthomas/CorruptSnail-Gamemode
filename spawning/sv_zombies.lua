-- local ox_inventory = exports.ox_inventory
-- local overlay = exports["mista_overlay"]

-- RegisterNetEvent("mo:OnZombieDeath")
-- AddEventHandler("mo:OnZombieDeath", function(tier, coords)
	-- local count = math.random(0, 3)
	-- if(count > 0) then		
		-- ox_inventory:CustomDrop('Zombie', overlay:GetLoot(tier, nil, count), coords, 5, 10000)	
	-- end
-- end)

AddEventHandler('entityRemoved', function(entity)
	-- print("entity removed", entity)
end)