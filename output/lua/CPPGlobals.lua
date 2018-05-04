--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Global variables and types for Combat++.
]]

-- the max skill points a player can have at 1 time
kMaxCombatSkillPoints = 100

-- Enumeration used to indicate the source of the xp award
kXPSourceType = enum(
{
    "Console",
    "Kill",
    "Assist",
    "Damage",
    "Nearby",
    "Build",
    "Weld",
    "Heal"
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

-- pixel radius used for randomizing damage xp numbers
kDamageXPIndicatorOffset = 30

-- Enumeration used to specify the type of upgrade for the UpgradeTree
kCombatUpgradeType = enum( 
{ 
	"Class", 
	"Upgrade" 
}) 
