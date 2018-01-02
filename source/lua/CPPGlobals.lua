--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Global variables and types for Combat++.
]]

-- the minimum number of players needed to start a game
kMinPlayersGameStart = 4

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

-- Enumeration used to specify the two different operation modes for the builder ability
kBuilderMode = enum(
{
    "Build",
    "Create"
})

kDamageXPIndicatorOffset = 50

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
    "Hunter",
    "Stalker",
    "Devourer",
    "Overlord",
    "Matriarch",
    "Hive Mind"
}
