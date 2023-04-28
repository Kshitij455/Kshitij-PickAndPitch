Config = {}

-- Framework (choose one): "qbcore" or "esx"
Config.Framework = "qbcore"

-- The distance at which the player can pick up objects
Config.PickupDistance = 2.0

-- The control used to pick up objects (see https://docs.fivem.net/docs/game-references/controls/)
Config.PickupControl = 38

-- The name(s) of the object(s) that can be picked up
Config.PickupObjects = {
    "prop_box_ammo01a",
    "prop_box_ammo07a",
    "prop_box_ammo07b",
    "prop_box_ammo08b",
    "prop_box_guncase_02a",
    "prop_box_tea01a"
}

-- The bone index of the player where the object will be attached
Config.PickupBoneIndex = 57005

-- The offset from the bone where the object will be attached
Config.PickupOffset = { x = 0.5, y = -0.2, z = -0.5 }

-- The rotation of the object when it is attached to the player
Config.PickupRotation = { x = 0.0, y = 0.0, z = 0.0 }

-- The animation played when the player picks up an object
Config.PickupAnimDict = "anim@heists@box_carry@"
Config.PickupAnimName = "idle"

-- The control used to throw objects (see https://docs.fivem.net/docs/game-references/controls/)
Config.ThrowControl = 24

-- The force multiplier applied to the object when thrown
Config.ThrowForceMultiplier = 10.0

-- The animation played when the player throws an object
Config.ThrowAnimDict = "missfbi_s4mop"
Config.ThrowAnimName = "throw_mop_ger"

-- The item ID of the throwable item (for ESX framework)
Config.ThrowableItem = "throwable_item"

-- The amount of damage dealt to NPCs or players hit by thrown objects
Config.DamageAmount = 10
