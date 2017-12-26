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

kKillStreakValue = 5
kAssistStreakValue = 5
kDamageDealerValue = 2500

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
    3000,
    6000,
    10000,
    15000,
    22000,
    30000,
    40000,
    52000,
    66000,
    84000
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
