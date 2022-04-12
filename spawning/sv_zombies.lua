-- if not lib then return end

local ox_inventory = exports.ox_inventory
local overlay = exports["mista-overlay"]
-- local table = lib.table

RegisterNetEvent("mo:OnZombieDeath")
AddEventHandler("mo:OnZombieDeath", function(tier, coords)
	local count = math.random(0, tier)
	if(count > 0) then		
		exports.ox_inventory:CustomDrop('Zombie', overlay:GetLoot(tier, count), coords)	
	end
end)