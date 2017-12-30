--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Global variables and types for Combat++.
]]

-- Just a high number used to clamp xp to.
-- Even after the player reaches max rank we will allow then to gain xp.
-- The player will likely never reach this cap.
kMaxCombatXP = 1000000

-- the amount of xp to award the player for a successful kill
kEarnedXPPerKill = 250
-- the amount of xp to award the player for a successful assist
kEarnedXPPerAssist = 50

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

-- the highest rank the player can reach
kMaxRank = 12

-- Enumeration used to indicate the source of the xp award
kXPSourceType = enum(
{
    "kill",
    "assist",
    "damage"
})

-- Enumeration used to indicate the source of the skill point award
kSkillPointSourceType = enum(
{
    "LevelUp",
    "KillStreak",
    "AssistStreak",
    "DamageDealer"
})

kBuilderMode = enum(
{
    "Build",
    "Create"
})

kKillStreakValue = 5
kAssistStreakValue = 5
kDamageDealerValue = 2500

-- This table drives how many skill points are awarded for a particular action
kSkillPointTable = {}
kSkillPointTable[kSkillPointSourceType.LevelUp] = 1
kSkillPointTable[kSkillPointSourceType.KillStreak] = 1
kSkillPointTable[kSkillPointSourceType.AssistStreak] = 1
kSkillPointTable[kSkillPointSourceType.DamageDealer] = 1

kDamageXPIndicatorOffset = 50

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

-- This table contains the "common" name of each rank for the Marines
kMarineRankTitles =
{
    "Private",
    "Private First Class",
    "Lance Corporal",
    "Corporal",
    "Sergeant",
    "Staff Sergeant",
    "Gunnery Sergeant",
    "Master Sergeant",
    "First Sergeant",
    "Master Gunnery Sergeant",
    "Sergeant Major",
    "Elite"
}

-- This table contains the "common" name of each rank for the Aliens
kAlienRankTitles =
{
    "Bottom Feeder",
    "Underling",
    "Grunt",
    "Devourer",
    "Overlord",
    "Queen",
    "Hive Mind"
}
