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

-- Minimum Spawn Point count for marines
kMinMarineSpawnPoints = 2

-- Number of players needed on the the marine team to get an extra spawn point
kMarineSpawnAdjustmentThreshold = 9

-- Just a high number used to clamp xp to.
-- Even after the player reaches max rank we will allow then to gain xp.
-- The player will likely never reach this cap.
kMaxCombatXP = 1000000

-- Number of skill points a player starts with
kStartPoints = 1

-- the amount of xp to award the player for a successful kill
kEarnedXPPerKill = 300
-- the amount of xp to award the player for a successful assist
kEarnedXPPerAssist = 100

-- The required damage threshold required to be awarded xp.  Every time the
-- player reaches this threshold, xp will be reward for the amount of damage
-- multiplied by the damage xp modifier
kDamageRequiredXPReward = 20
kDamageXPModifier = 0.5  -- XP award is half the amount of damage done

-- This is the number of kills needed to achieve the "Rampage" reward
kKillsForRampageReward = 5

-- This is the number of assists needed to achieve the "Got Your Back" reward
kAssistsForAssistReward = 6

-- This is the number of assists needed to achieve the "DamageDealer" reward
kDamageForDamageDealerAward = 2500

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

-- This table contains the required xp threshold to reach each rank
kXPLevelThresholds =
{
    0,
    1000,
    2500,
    5000,
    8000,
    12000,
    17000,
    23000,
    30000,
    38000,
    47000,
    57000
}
