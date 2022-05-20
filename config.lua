Config = {
    -- Time and weather sync (disable if you have your own solution)
    ENV_SYNC = true,
    -- Hide Radar
    HIDE_RADAR = true,
    -- First person only
    FIRST_PERSON_LOCK = true,
    -- Enable blackout
    ENABLE_BLACKOUT = false,
    -- Enable or disable AI peds.
    ENABLE_PEDS = false,
    -- Enable or disable AI traffic.
    ENABLE_TRAFFIC = false,
}

function Config.jprint(value)
	print(json.encode(value, {indent=true}))
end

Config.Spawning = {
    -- Min distance between players to decide one "host"
    HOST_DECIDE_DIST = 200.0
}

-- ZOMBIES
Config.Spawning.Zombies = {
    -- Max amount of spawned zombies at once by you
    MAX_AMOUNT = 1,
    -- Chance a zombie receives a special attributes (per attribute, 0 - 100)
    ATTR_CHANCE = 25,
    -- Max Health
    MAX_HEALTH = 300,
    -- Max Armor
    MAX_ARMOR = 200,
    -- The speed at which zombies are walking towards enemies
    WALK_SPEED = 1.0,
    -- Enable zombie sounds
    ENABLE_SOUNDS = true,
    -- Min spawn distance
    MIN_SPAWN_DISTANCE = 100.0,
    -- Despawn distance (should always be at least 2x min spawn distance)
    DESPAWN_DISTANCE = 200.0,
    -- Model of zombies
    ZOMBIE_MODELS = {
		["tier1"] = {
			{"a_m_m_tranvest_01", 4, ""},
			{"csb_maude", 1, ""},
			{"a_f_m_trampbeac_01", 50, ""},
			{"a_f_y_eastsa_01", 20, ""},
			{"a_f_y_indian_01", 50, ""},
			{"ig_cletus", 2, ""},
			{"mp_f_deadhooker", 3, ""},
		},
		["tier2"] = {		
			{"a_m_m_hillbilly_01", 50, ""},
			{"a_m_o_salton_01", 50, ""},
			{"a_f_m_downtown_01", 50, ""},
			{"a_f_m_eastsa_01", 50, ""},
			{"a_f_m_fatbla_01", 5, ""},
			{"a_f_m_fatcult_01", 10, ""},
			{"ig_hunter", 10, ""},
			{"a_f_m_skidrow_01", 50, ""},
		},
		["tier3"] = {
			{"mp_m_cocaine_01", 15, ""},
			{"s_m_y_clown_01", 10, ""},
			{"csb_rashcosvki", 50, ""},
			{"a_f_y_juggalo_01", 50, ""},
			{"a_m_y_musclbeac_01", 50, ""},
			{"mp_m_weed_01", 50, ""},
			{"u_m_y_zombie_01", 15, ""},
			{"s_m_y_mime", 15, ""},
		},
		["tier4"] = {
			{"a_m_y_acult_01", 55, ""},
			{"a_m_o_acult_01", 35, ""},
			{"a_m_o_acult_02", 40, ""},
			{"a_m_m_acult_01", 30, ""},
			{"a_m_y_acult_02", 50, ""},
			{"a_f_m_fatcult_01", 50, ""},
			{"s_m_m_marine_01", 40, "military"},
			{"s_m_y_marine_01", 30, "military"},
			{"s_m_y_marine_02", 20, "military"},
			{"s_m_y_marine_03", 15, "military"},
			{"s_m_y_blackops_01", 25, "military"},
			{"s_m_y_blackops_02", 20, "military"},
			{"s_m_y_blackops_03", 10, "military"},
			{"s_m_m_prisguard_01", 40, "police2"},
			{"s_m_m_security_01", 15, "police2"},
			{"s_m_y_sheriff_01", 20, "police2"},
			{"s_m_y_prisoner_01", 10, "police2"},
			{"s_m_y_prismuscl_01", 15, "police2"},
			{"u_m_y_prisoner_01", 50, "police2"},
		}
	},
	ZOMBIES_WALKS = {
		"move_m@drunk@verydrunk",
		"move_m@drunk@moderatedrunk",
		"move_m@drunk@a",
		"anim_group_move_ballistic",
		"move_lester_CaneUp",
	},
}

-- ZOMBIES STATIC ZONE
Config.Spawning.Staticzones = {
	{
		Core = vector2(1690.3005, 2593.8862), -- Prison
		Radius = 150,
		Tier = 4,
		Ambiance = "police2",
		Max_amount = 75,
		Wave = {
			duration = 120000,
			Timeout = 180000
		}		
	},
	{
		Core = vector2(-2092.5942, 3057.4155), -- Zancudo
		Radius = 300,
		Tier = 4,
		Ambiance = "military",
		Max_amount = 75,
		Wave = {
			duration = 120000,
			Timeout = 180000
		}		
	},
	{
		Core = vector2(3530.2852, 3728.6631), -- Labo
		Radius = 100,
		Tier = 4,
		Ambiance = "military",
		Max_amount = 75,
		Wave = {
			duration = 120000,
			Timeout = 180000
		}		
	}
}

-- SAFEZONE
Config.Spawning.Safezones = {
    -- Safezones
    SAFEZONES = {
        {
            -- Sandy Shores Police Station
            Core = vector2( 1853.61, 3686.79 ),
			Radius = 20
        },
    }
}