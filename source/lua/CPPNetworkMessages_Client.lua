--[[
 * Natural Selection 2 - Combat++ Mod
 * Created by: WhiteWizard
 *
 * Combat++ Client message hooks.
]]

local function OnCombatScoreUpdate(message)
    CombatScoreDisplayUI_SetNewXPAward(message.xp, message.source, message.targetId)
end
Client.HookNetworkMessage("CombatScoreUpdate", OnCombatScoreUpdate)

local function OnCombatSkillPointUpdate(message)
    CombatScoreDisplayUI_SkillPointEarned(message.source, message.kill, message.assists)
end
Client.HookNetworkMessage("CombatSkillPointUpdate", OnCombatSkillPointUpdate)

local function OnCommandClearUpgradeTree()
    Shared.Message("Clear message received")
    ClearUpgradeTree()
end
Client.HookNetworkMessage("ClearUpgradeTree", OnCommandClearUpgradeTree)

local function OnCommandUpgradeNodeBase(nodeBaseTable)
    GetUpgradeTree():CreateUpgradeNodeFromNetwork(nodeBaseTable)
end
Client.HookNetworkMessage("UpgradeNodeBase", OnCommandUpgradeNodeBase)

local function OnCommandUpgradeNodeUpdate(nodeUpgradeTable)
    GetUpgradeTree():UpdateUpgradeNodeFromNetwork(nodeUpgradeTable)
end
Client.HookNetworkMessage("UpgradeNodeUpdate", OnCommandUpgradeNodeUpdate)
