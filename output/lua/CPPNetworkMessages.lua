--[[
 * Natural Selection 2 - Combat++ Mod
 * Created by: WhiteWizard
 *
 * Combat++ Network message registration.
]]

Script.Load("lua/CPPGlobals.lua")

local kCombatScoreUpdate =
{
    xp = "integer",
    source = "enum kXPSourceType",
    targetId = "integer"
}

Shared.RegisterNetworkMessage("CombatScoreUpdate", kCombatScoreUpdate)

local kCombatSkillPointUpdate =
{
    source = "enum kSkillPointSourceType",
    kills = "integer",
    assists = "integer"
}

Shared.RegisterNetworkMessage("CombatSkillPointUpdate", kCombatSkillPointUpdate)

local kPowerPointEntity =
{
    powerPointId = "integer"
}

Shared.RegisterNetworkMessage("RequestSocketPowerPoint", kPowerPointEntity)

local kUpgradeNodeBaseMessage =
{
    techId = string.format("integer (0 to %d)", kTechIdMax),
    type = "enum kCombatUpgradeType",
    prereqTechId = string.format("integer (0 to %d)", kTechIdMax),
    isUnlocked = "boolean",
    isPurchased = "boolean"
}

function BuildUpgradeNodeBaseMessage(node)

    local n = {}

    n.techId = node.techId
    n.type = node.type
    n.prereqTechId = node.prereqTechId
    n.isUnlocked = node.isUnlocked
    n.isPurchased = node.isPurchased

    return n

end

Shared.RegisterNetworkMessage( "UpgradeNodeBase", kUpgradeNodeBaseMessage )

local kUpgradeNodeUpdateMessage =
{
    techId = "enum kTechId",
    isUnlocked = "boolean",
    isPurchased = "boolean"
}

function BuildUpgradeNodeUpdateMessage(node)

    local n = {}

    n.techId = node.techId
    n.isUnlocked = node.isUnlocked
    n.isPurchased = node.isPurchased

    return n

end

Shared.RegisterNetworkMessage( "UpgradeNodeUpdate", kUpgradeNodeUpdateMessage )

function ParseUpgradeNodeBaseMessage(node, networkVars)

    node.techId = networkVars.techId
    node.type = networkVars.type
    node.prereqTechId = networkVars.prereqTechId
    node.isUnlocked = networkVars.isUnlocked
    node.isPurchased = networkVars.isPurchased

end

function ParseUpgradeNodeUpdateMessage(node, networkVars)

    node.isUnlocked = networkVars.isUnlocked
    node.isPurchased = networkVars.isPurchased

end

Shared.RegisterNetworkMessage( "ClearUpgradeTree", {} )
