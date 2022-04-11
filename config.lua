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

Config.Spawning = {
    -- Min distance between players to decide one "host"
    HOST_DECIDE_DIST = 200.0
}

Config.Spawning.Zombies = {
    -- Max amount of spawned zombies at once by you
    MAX_AMOUNT = 75,
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
    -- TODO: List of models
    ZOMBIE_MODEL = "u_m_y_zombie_01"
}

Config.Spawning.Safezones = {
    -- Safezones
    SAFEZONES = {
        {
            -- Sandy Shores Police Station
            Core = { 1853.61, 3686.79 },
        },
    }
}