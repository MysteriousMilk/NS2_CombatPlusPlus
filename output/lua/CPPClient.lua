--[[
 * Natural Selection 2 - Combat++ Mod
 * Created by: WhiteWizard
 *
 * Handles client functionality for Combat++.
]]

decoda_name = "Client"
Shared.Message("GameMode: Combat++")

Script.Load("lua/Combat/UpgradeData.lua")
Script.Load("lua/Combat/UpgradeNode.lua")
Script.Load("lua/Combat/UpgradeTree.lua")
Script.Load("lua/Combat/GUI/CombatUIHelper.lua")
Script.Load("lua/CPPCombatScoreDisplay.lua")
Script.Load("lua/Combat/CombatXpMessages.lua")
Script.Load("lua/Combat/GUI/CombatMessageUI.lua")
Script.Load("lua/Combat/GUI/MarineStatusHUD.lua")
Script.Load("lua/Combat/GUI/AlienStatusHUD.lua")
Script.Load("lua/Hud/CPPGUIInventory.lua")

-- precache the upgrade textures used on the buy menus
PrecacheUpgradeTextures()

local gUpgradeTree = UpgradeTree()
gUpgradeTree:Initialize()

function GetUpgradeTree()
    return gUpgradeTree
end

function ClearUpgradeTree()
    gUpgradeTree:Initialize()
    Print("Tree cleared")
end