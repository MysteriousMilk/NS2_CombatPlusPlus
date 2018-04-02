--[[
 * Natural Selection 2 - Combat++ Mod
 * Created by: WhiteWizard
 *
 * Combat++ Network message registration.
]]

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

-- used for updating the upgrade tree
function BuildUpgradeNodeMessage(node)

    local n = {}

    n.techId = node.techId
    n.type = node.type
    n.isUnlocked = node.isUnlocked

    return n

end
