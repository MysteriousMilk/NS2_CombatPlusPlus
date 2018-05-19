--[[
 * Natural Selection 2 - Combat++ Mod
 * Created by: WhiteWizard
 *
 * Combat++ Client message hooks.
]]

local function OnCombatScoreUpdate(message)
    CombatXpMsgUI_AddMessage(message)
end
Client.HookNetworkMessage("CombatScoreUpdate", OnCombatScoreUpdate)

local function OnCombatUpgradePointUpdate(message)
    CombatScoreDisplayUI_UpgradePointEarned(message.source, message.kill, message.assists)
end
Client.HookNetworkMessage("CombatUpgradePointUpdate", OnCombatUpgradePointUpdate)

local function OnCommandClearUpgradeTree()
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
