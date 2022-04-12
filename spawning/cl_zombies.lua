local overlay = exports["mista-overlay"]

local ZOMBIE_IGNORE_COMBAT_TIMEOUT_DECOR = "_ZOMBIE_IGNORE_COMBAT_TIMEOUT"
DecorRegister(ZOMBIE_IGNORE_COMBAT_TIMEOUT_DECOR, 3)

local ZOMBIE_TARGET_DECOR = "_ZOMBIE_TARGET"
DecorRegister(ZOMBIE_TARGET_DECOR, 3)

local ZOMBIE_TIME_UNTIL_SOUND_DECOR = "_ZOMBIE_SOUND_TIMEOUT"
DecorRegister(ZOMBIE_TIME_UNTIL_SOUND_DECOR, 3)

local ZOMBIE_TASK_DECOR = "_ZOMBIE_TASK"
DecorRegister(ZOMBIE_TASK_DECOR, 3)

local ZOMBIE_MODEL = GetHashKey(Config.Spawning.Zombies.ZOMBIE_MODEL)

local function GetTierSlug(tier)
	return "tier" .. tier
end

local function GetRandomWeightedModelInTier(tier, ambiance)
	
	local sum = 0
	local zombies = Config.Spawning.Zombies.ZOMBIE_MODELS[GetTierSlug(tier)]
	local selectedZombies = {}
	
	for _, item in pairs(zombies) do
		if ambiance ~= nil and ambiance ~= "" then
			if item[3] == ambiance or item[3] == "" then
				sum = sum + item[2]
				table.insert(selectedZombies, item) 
			end
		else
			if item[3] == "" then
				sum = sum + item[2]
				table.insert(selectedZombies, item) 
			end	
		end	
	end
	
	local rand = math.random(sum)
	local winningKey
	local winningIndex
	
	for _, item in pairs(selectedZombies) do
		winningKey = item[1]	
		winningIndex = _
		rand = rand - item[2]
		if rand <= 0 then break end
	end
	
	local debugText = "tier: " .. tier .. " | ambiance: " .. ambiance .. " | Model: " .. selectedZombies[winningIndex][1] .. " | rarity: " .. selectedZombies[winningIndex][2] .. " | ambiance:" .. selectedZombies[winningIndex][3]	
	-- exports.ox_inventory:notify({text = debugText})
	-- print(debugText)
	
	return selectedZombies[winningIndex] ~= nil and selectedZombies[winningIndex][1] or "u_m_y_zombie_01"
end

local function AttrRollTheDice()
    return math.random(100) <= Config.Spawning.Zombies.ATTR_CHANCE
end

local function ZombifyPed(ped, tier, ambiance)
    SetPedRelationshipGroupHash(ped, ZOMBIE_GROUP)

    SetPedHearingRange(ped, 9999.0)
    SetPedSeeingRange(ped, 50.0)

    SetPedConfigFlag(ped, 224, true) -- PED_FLAG_MELEE_COMBAT 
    SetPedConfigFlag(ped, 281, true) -- PED_FLAG_NO_WRITHE
	
    -- SetPedConfigFlag(ped, 100, true) -- PED_FLAG_DRUNK 
    SetPedConfigFlag(ped, 166, true) -- PED_FLAG_INJURED_LIMP 
    SetPedConfigFlag(ped, 170, true) -- PED_FLAG_INJURED_LIMP_2 
    -- SetPedConfigFlag(ped, 187, true) -- PED_FLAG_INJURED_DOWN 
	
    SetPedCombatAttributes(ped, 46, true) -- BF_AlwaysFight
    SetPedCombatAttributes(ped, 5, true) -- BF_CanFightArmedPedsWhenNotArmed
    SetPedCombatAttributes(ped, 1, false) -- BF_CanUseVehicles
    SetPedCombatAttributes(ped, 0, false) -- BF_CanUseCover 
	
	-- 0: CA_Poor
	-- 1: CA_Average
	-- 2: CA_Professional
    SetPedCombatAbility(ped, 2)
    
	-- 0: CR_Near
	-- 1: CR_Medium
	-- 2: CR_Far
	SetPedCombatRange(ped, 2)

    SetAiMeleeWeaponDamageModifier(9999.0)
    SetPedRagdollBlockingFlags(ped, 4)
    SetPedCanRagdollFromPlayerImpact(ped, false)
    SetPedCanPlayAmbientAnims(ped, false)
    SetPedPathAvoidFire(ped, false)
    SetPedKeepTask(ped, true)
    TaskWanderStandard(ped, 10.0, 10)

    SetEntityHealth(ped, math.random(50, Config.Spawning.Zombies.MAX_HEALTH))
    
	ApplyPedDamagePack(ped,"BigHitByVehicle", 0.0, 9.0)
	ApplyPedDamagePack(ped,"SCR_Dumpster", 0.0, 9.0)
	ApplyPedDamagePack(ped,"SCR_Torture", 0.0, 9.0)
	
	if tier >= 3 then
		SetEntityHealth(ped, math.random(200, Config.Spawning.Zombies.MAX_HEALTH))
		SetPedArmour(ped, math.random(0, Config.Spawning.Zombies.MAX_ARMOR))
	end
    
	if AttrRollTheDice() then
        ApplyPedBlood(ped, 3, 0.0, 0.0, 0.0, "wound_sheet")
    end
	
    if AttrRollTheDice() then
        SetPedRagdollOnCollision(ped, true)
    end

    if AttrRollTheDice() then
        SetPedSuffersCriticalHits(ped, false)
    end
end

local function TrySpawnRandomZombie()
    local spawnPos = Utils.FindGoodSpawnPos(Config.Spawning.Zombies.MIN_SPAWN_DISTANCE)

    if spawnPos then
        local newZ = Utils.ZToGround(spawnPos)

        if not newZ then
            newZ = spawnPos.z - 1000.0
        end

		-- GET CURRENT TIER PLAYER IS IN
		x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
		local zone = GetNameOfZone(x, y, z)
		
		local tier = overlay:GetZoneTier(zone)
		local ambiance = overlay:GetZoneAmbiance(zone)

		ZOMBIE_MODEL = GetHashKey( GetRandomWeightedModelInTier(tier, ambiance) )
        local zombie = Utils.CreatePed(ZOMBIE_MODEL, 25, vector3(spawnPos.x, spawnPos.y, newZ), 0.0)
        ZombifyPed(zombie, tier, ambiance)
    end
end

local deadZombies = {}
local function HandleExistingZombies()
    local mPlayerPed = PlayerPedId()
    local currentCloudTime = GetCloudTimeAsInt()

    local untilPause = 10
    for ped, pedData in pairs(g_peds) do
        if pedData.IsZombie then
            local zombieCoords = GetEntityCoords(ped)

			if IsPedDeadOrDying(ped) then
				if GetPedSourceOfDeath(ped) == PlayerPedId() then
					if deadZombies[ped] == nil then
					
						deadZombies[ped] = GetEntityCoords(ped, false)
						
						x, y, z = table.unpack(deadZombies[ped])
						tier = overlay:GetZoneTier(GetNameOfZone(x, y, z))
						
						TriggerServerEvent("mo:OnZombieDeath", tier, deadZombies[ped])
						
						SetPedAsNoLongerNeeded(ped)
					end
				end
			end
			
            if Player.IsSpawnHost() and (IsPedDeadOrDying(ped) or not Utils.IsPosNearAPlayer(zombieCoords, Config.Spawning.Zombies.DESPAWN_DISTANCE)) then
                SetPedAsNoLongerNeeded(ped)
            else
                local zombieCombatTimeout = DecorGetInt(ped, ZOMBIE_IGNORE_COMBAT_TIMEOUT_DECOR)

                SetAmbientVoiceName(ped, "ALIENS")
                DisablePedPainAudio(ped, true)

                if not HasAnimSetLoaded("move_m@drunk@verydrunk") then
                    RequestAnimSet("move_m@drunk@verydrunk")
                end
                SetPedMovementClipset(ped, "move_m@drunk@verydrunk", 0.5)

                SetBlockingOfNonTemporaryEvents(ped, zombieCombatTimeout > currentCloudTime)

                if Config.Spawning.Zombies.ENABLE_SOUNDS and DecorGetInt(ped, ZOMBIE_TIME_UNTIL_SOUND_DECOR) <= currentCloudTime then
                    DisablePedPainAudio(ped, false)
                    PlayPain(ped, 27)
                    DecorSetInt(ped, ZOMBIE_TIME_UNTIL_SOUND_DECOR, currentCloudTime + math.random(5, 60))
                end

                local zombieGameTarget = pedData.ZombieCombatTarget

                if zombieGameTarget and zombieCombatTimeout <= currentCloudTime
                    and Utils.GetDistanceBetweenCoords(GetEntityCoords(zombieGameTarget), zombieCoords) > 2.0 then
                    DecorSetInt(ped, ZOMBIE_IGNORE_COMBAT_TIMEOUT_DECOR, currentCloudTime + 20)
                    DecorSetInt(ped, ZOMBIE_TARGET_DECOR, zombieGameTarget)
                    DecorSetInt(ped, ZOMBIE_TASK_DECOR, 0)

                    SetBlockingOfNonTemporaryEvents(ped, true)
                end

                local zombieDecorTarget = DecorGetInt(ped, ZOMBIE_TARGET_DECOR)

                if zombieDecorTarget ~= 0 then
                    local curTask = DecorGetInt(ped, ZOMBIE_TASK_DECOR)
                    local zombieDecorTargetPos = GetEntityCoords(zombieDecorTarget)

                    if Utils.GetDistanceBetweenCoords(zombieDecorTargetPos, zombieCoords) > 2.0 then
                        if IsPedOnVehicle(zombieDecorTarget) then
                            if curTask ~= 2 then
                                TaskCombatPed(ped, zombieDecorTarget, 0, 16)

                                DecorSetInt(ped, ZOMBIE_TASK_DECOR, 2)
                            end
                        elseif curTask ~= 1 then
                            TaskGoToEntity(ped, zombieDecorTarget, -1, 2.0, Config.Spawning.Zombies.WALK_SPEED)

                            DecorSetInt(ped, ZOMBIE_TASK_DECOR, 1)
                        end
                    else
                        DecorSetInt(ped, ZOMBIE_TASK_DECOR, 0)

                        if not IsPedOnVehicle(ped) and IsPedOnVehicle(zombieDecorTarget) then
                            TaskClimb(ped)
                        elseif not IsPedInCombat(ped, zombieDecorTarget) then
                            TaskCombatPed(ped, zombieDecorTarget, 0, 16)
                        end
                    end
                end
            end

            untilPause = untilPause - 1
            if untilPause == 0 then
                untilPause = 10

                Wait(0)
            end
        end
    end
end

Utils.CreateLoadedInThread(function()
    while true do
        Wait(250)

        if Player.IsSpawnHost() and g_zombieAmount <= Config.Spawning.Zombies.MAX_AMOUNT then
            TrySpawnRandomZombie()
        end

        HandleExistingZombies()
    end
end)

Utils.CreateLoadedInThread(function()
    while true do
        Wait(10000)

        local untilPause = 10
        for ped, pedData in pairs(g_peds) do
            if not pedData.IsZombie then
                local relationshipGroup = pedData.RelationshipGroup
                
                SetRelationshipBetweenGroups(5, ZOMBIE_GROUP, relationshipGroup)
                SetRelationshipBetweenGroups(5, relationshipGroup, ZOMBIE_GROUP)

                untilPause = untilPause - 1
                if untilPause == 0 then
                    untilPause = 10
        
                    Wait(0)
                end
            end
        end
    end
end)