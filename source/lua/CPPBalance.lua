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
---- SPAWN TIMES ----
kMarineRespawnTime = 9
kAlienSpawnTime = 10
-- changed from 13 to 10
kEggGenerationRate = 10
kAlienEggsPerHive = 2
-- =========== END ALTERED NS2 VALUES =================

-- ======== COMBAT++ SPECIFIC BALANCE VALUES ==========

kXPTable = {}
kXPTable[1]  = { Rank = 1,   XP = 0,     MarineName = "Private",             AlienName = "Hatchling",   BaseXpOnKill = 200 }
kXPTable[2]  = { Rank = 2,   XP = 1000,  MarineName = "Private First Class", AlienName = "Underling",   BaseXpOnKill = 220 }
kXPTable[3]  = { Rank = 3,   XP = 2500,  MarineName = "Corporal",            AlienName = "Zenoform",    BaseXpOnKill = 240 }
kXPTable[4]  = { Rank = 4,   XP = 5000,  MarineName = "Sergeant",            AlienName = "Minon",       BaseXpOnKill = 260 }
kXPTable[5]  = { Rank = 5,   XP = 8000,  MarineName = "Lieutenant",          AlienName = "Ambusher",    BaseXpOnKill = 280 }
kXPTable[6]  = { Rank = 6,   XP = 12000, MarineName = "Captain",             AlienName = "Hunter",      BaseXpOnKill = 300 }
kXPTable[7]  = { Rank = 7,   XP = 17000, MarineName = "Commander",           AlienName = "Stalker",     BaseXpOnKill = 320 }
kXPTable[8]  = { Rank = 8,   XP = 23000, MarineName = "Major",               AlienName = "Devourer",    BaseXpOnKill = 340 }
kXPTable[9]  = { Rank = 9,   XP = 30000, MarineName = "Field Marshal",       AlienName = "Slaughterer", BaseXpOnKill = 360 }
kXPTable[10] = { Rank = 10,  XP = 38000, MarineName = "General",             AlienName = "Eliminator",  BaseXpOnKill = 380 }
kXPTable[11] = { Rank = 11,  XP = 47000, MarineName = "Elite",               AlienName = "Behemoth",    BaseXpOnKill = 400 }
kXPTable[12] = { Rank = 12,  XP = 57000, MarineName = "Badass",              AlienName = "Overlord",    BaseXpOnKill = 420 }
kXPTable[13] = { Rank = 13,  XP = 68000, MarineName = "Rambo",               AlienName = "Hive Mind",   BaseXpOnKill = 440 }

-- the highest rank the player can reach
kMaxCombatRank = table.maxn(kXPTable)

-- the highest amount of xp the player can earn
kMaxCombatXP = kXPTable[kMaxCombatRank]["XP"]

-- Minimum Spawn Point count for marines
kMinMarineSpawnPoints = 2

-- Number of players needed on the the marine team to get an extra spawn point
kMarineSpawnAdjustmentThreshold = 9

-- Number of skill points a player starts with
kStartPoints = 1

-- the modifier applied to the 'BaseXpOnKill' to determine how much xp for assists
kXPAssistModifier = 0.33

-- upper bound for modifier used to scale xp based on distance to enemy tech point
kDistanceXPModifierMaxUpperBound = 2

-- The required damage threshold required to be awarded xp.  Every time the
-- player reaches this threshold, xp will be reward for the amount of damage
-- multiplied by the damage xp modifier
kDamageRequiredXPReward = 20

-- Modifier used to determine how much xp to give per damage award
kDamageXPModifier = 0.5

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
kCombatBuildRewardBase = 400

-- The modifier used for Gorges.  Gorges get more build xp as building is one of
-- their primary functions
kGorgeBuildRewardModifier = 1.5

-- This is the number of kills needed to achieve the "Rampage" reward
kKillsForRampageReward = 5

-- This is the number of assists needed to achieve the "Got Your Back" reward
kAssistsForAssistReward = 6

-- This is the number of assists needed to achieve the "DamageDealer" reward
kDamageForDamageDealerAward = 750

-- Number of kills needed for the "Rampage" kill streak award.
kKillStreakValue = 5

-- Number of assists needed for the "Got Your Back" assist streak award.
kAssistStreakValue = 5

-- Amount of damage needed for the "Damage Dealer" award.
kDamageDealerValue = 2500

-- This table drives how many skill points are awarded for a particular action
kSkillPointTable = {}
kSkillPointTable[kSkillPointSourceType.LevelUp] = 1
kSkillPointTable[kSkillPointSourceType.KillStreak] = 1
kSkillPointTable[kSkillPointSourceType.AssistStreak] = 1
kSkillPointTable[kSkillPointSourceType.DamageDealer] = 1

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
