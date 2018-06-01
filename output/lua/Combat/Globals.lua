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
    ["TimeLimit"] = 1500,
    ["UpgradePointsAtStart"] = 1,
    ["MaxSpawnersPerWave"] = 2,
    ["PenaltyLevel"] = 1
}
