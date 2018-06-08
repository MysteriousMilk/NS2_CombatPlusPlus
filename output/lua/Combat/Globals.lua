--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Global variables and types for Combat++.
]]

-- the max upgrade points a player can have at 1 time
kMaxCombatUpgradePoints = 100

-- Enumeration used to indicate the source of the xp award
kXPSourceType = enum(
{
    "Console",
    "Balance",
    "Kill",
    "Assist",
    "Damage",
    "Nearby",
    "Build",
    "Weld",
    "Heal",
    "KillStreak",
    "AssistStreak",
    "DamageDealer"
})

-- Enumeration used to indicate the source of the upgrade point award
kUpgradePointSourceType = enum(
{
    "LevelUp",
    "Refund"
})

-- Enumeration used to specify the two different operation modes for the builder ability
kBuilderMode = enum(
{
    "Build",
    "Create"
})

-- pixel radius used for randomizing damage xp numbers
kDamageXPIndicatorOffset = 30

-- Enumeration used to specify the type of upgrade for the UpgradeTree
kCombatUpgradeType = enum( 
{ 
	"Class", 
    "Upgrade",
    "Structure"
})

CombatSettings =
{
    -- Game time limit
    ["TimeLimit"] = 1500,

    -- Number of upgrade points the player starts with at the beginning of the round
    ["UpgradePointsAtStart"] = 1,

    -- Number of players that spawn each wave
    ["MaxSpawnersPerWave"] = 2,

    -- Number of levels to penalize a player for leaving and rejoining the same team
    ["PenaltyLevel"] = 1,

    -- Amount of time at the beginning of the game tha new players can join and instanly 
    -- respawn without getting stuck in the queue waiting on the next wave
    ["FreeSpawnTime"] = 60
}
