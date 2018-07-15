--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Balance variables for Combat++.  The first section contains values from
 * vanilla NS2 that have been tweaked.  The second section contains new values
 * for Combat++ that will likely need a lot of tweaking for balance purposes.
]]


-- ============= ALTERED NS2 VALUES ===================
kAlienEggsPerHive = 0
-- =========== END ALTERED NS2 VALUES =================

-- ======== COMBAT++ SPECIFIC BALANCE VALUES ==========

kXPTable = {}
kXPTable[1]  = { Rank = 1,   XP = 0,     MarineName = "Private",             AlienName = "Hatchling",   BaseXpOnKill = 200 }
kXPTable[2]  = { Rank = 2,   XP = 500,   MarineName = "Private First Class", AlienName = "Underling",   BaseXpOnKill = 220 }
kXPTable[3]  = { Rank = 3,   XP = 1000,  MarineName = "Corporal",            AlienName = "Zenoform",    BaseXpOnKill = 240 }
kXPTable[4]  = { Rank = 4,   XP = 2000,  MarineName = "Sergeant",            AlienName = "Minon",       BaseXpOnKill = 260 }
kXPTable[5]  = { Rank = 5,   XP = 3000,  MarineName = "Lieutenant",          AlienName = "Ambusher",    BaseXpOnKill = 280 }
kXPTable[6]  = { Rank = 6,   XP = 5000,  MarineName = "Captain",             AlienName = "Hunter",      BaseXpOnKill = 300 }
kXPTable[7]  = { Rank = 7,   XP = 7000,  MarineName = "Commander",           AlienName = "Stalker",     BaseXpOnKill = 320 }
kXPTable[8]  = { Rank = 8,   XP = 10000, MarineName = "Major",               AlienName = "Devourer",    BaseXpOnKill = 340 }
kXPTable[9]  = { Rank = 9,   XP = 13000, MarineName = "Field Marshal",       AlienName = "Slaughterer", BaseXpOnKill = 360 }
kXPTable[10] = { Rank = 10,  XP = 17000, MarineName = "General",             AlienName = "Eliminator",  BaseXpOnKill = 380 }
kXPTable[11] = { Rank = 11,  XP = 21000, MarineName = "Elite",               AlienName = "Behemoth",    BaseXpOnKill = 400 }
kXPTable[12] = { Rank = 12,  XP = 26000, MarineName = "Badass",              AlienName = "Overlord",    BaseXpOnKill = 420 }
kXPTable[13] = { Rank = 13,  XP = 31000, MarineName = "Rambo",               AlienName = "Hive Mind",   BaseXpOnKill = 440 }

-- the highest rank the player can reach
kMaxCombatRank = table.maxn(kXPTable)

-- the highest amount of xp the player can earn
kMaxCombatXP = kXPTable[kMaxCombatRank]["XP"]

-- gestate times
kGestateTime = {}
kGestateTime[kTechId.Skulk] = 1
kGestateTime[kTechId.Gorge] = 2
kGestateTime[kTechId.Lerk] = 2
kGestateTime[kTechId.Fade] = 3
kGestateTime[kTechId.Onos] = 6

-- the modifier applied to the 'BaseXpOnKill' to determine how much xp for assists
kXPAssistModifier = 0.33

-- The fraction of 'BaseXpOnKill' given for being near a kill and doing no damage
kNearbyKillXPModifier = 0.25

-- Kills within this distance to a player will grant xp
kNearbyKillXPDistance = 20

-- upper bound for modifier used to scale xp based on distance to enemy tech point
kDistanceXPModifierMaxUpperBound = 2

-- The required damage threshold required to be awarded xp.  Every time the
-- player reaches this threshold, xp will be reward for the amount of damage
-- multiplied by the damage xp modifier
kDamageRequiredXPReward = 25

-- Modifier used to determine how much xp to give per damage award
kDamageXPModifier = 0.2

-- The required welding threshold required to be awarded xp.  Every time the
-- player reaches this threshold, xp will be reward for the amount of welding
-- multiplied by the welding xp modifier
kWeldingRequiredXPReward = 10

-- Modifier used to determine how much xp to give per welding award
kWeldingXPModifier = 0.5

-- The required healding threshold required to be awarded xp.  Every time the
-- player reaches this threshold, xp will be awarded for the amount of healing
-- multiplied by the welding xp modifier
kHealingRequiredXPReward = 10

-- Modifier used to determine how much xp to give per healing award
kHealingXPModifier = 0.5

-- The amount multiplied by the construct fraction to determine how much xp given for
-- building/constructing
kCombatBuildRewardBase = 200

-- The modifier used for Gorges.  Gorges get more build xp as building is one of
-- their primary functions
kGorgeBuildRewardModifier = 1.5

-- This is the number of kills needed to achieve the "Rampage" reward
kKillsForRampageReward = 5

-- This is the number of assists needed to achieve the "Got Your Back" reward
kAssistsForAssistReward = 6

-- This is the number of assists needed to achieve the "DamageDealer" reward
kDamageForDamageDealerAward = 750

-- This table drives how much xp is awarded for special cases
kSpecialXpAwardTable = {}
kSpecialXpAwardTable[kXPSourceType.KillStreak] = 400
kSpecialXpAwardTable[kXPSourceType.AssistStreak] = 300
kSpecialXpAwardTable[kXPSourceType.DamageDealer] = 500

-- How long the player has to wait in between using the MedPackAbility (in sec)
kMedPackAbilityCooldown = 60

-- How long the player has to wait in between using the AmmoPackAbility (in sec)
kAmmoPackAbilityCooldown = 75

-- How long the player has to wait in between using the CatPackAbility (in sec)
kCatPackAbilityCooldown = 120

-- How log the player has to wait in between using the ScanAbility (in sec)
kScanAbilityCooldown = 90

-- Rate at which the Hive will 'Auto Cyst'
kHiveAutoCystFrequency = 40

-- team balance interval
kCombatXpBalanceInterval = 300

-- how much % from the avg xp can new player get
kAverageXpModifier = 0.75

-- respawn variables
kCombatRespawnTimer = 12
kCombatOvertimeRespawnTimer = 16
kSpawnMaxRetries = 50
kSpawnMinDistance = 2
kSpawnMaxDistance = 25
kSpawnMaxVertical = 30
kSpawnGestateTime = 0.5
kUpgradeGestateTime = 1.5

-- spawn protection
kCombatSpawnProtectDelay = 0.1
kCombatMarineSpawnProtectTime = 2
kNanoShieldDuration = kCombatMarineSpawnProtectTime 
kCombatAlienSpawnProtectTime = kSpawnGestateTime + kCombatMarineSpawnProtectTime