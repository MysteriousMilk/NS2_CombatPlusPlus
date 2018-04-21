--[[
 * Natural Selection 2 - Combat++ Mod
 * Created by: WhiteWizard
 *
 * Handles client functionality for Combat++.
]]

decoda_name = "Client"
Shared.Message("GameMode: Combat++")

Script.Load("lua/CPPCombatScoreDisplay.lua")
Script.Load("lua/Combat/GUI/MarineStatusHUD.lua")
Script.Load("lua/CPPGUIAlienCombatHUD.lua")
Script.Load("lua/Hud/CPPGUIInventory.lua")
Script.Load("lua/Combat/UpgradeData.lua")
Script.Load("lua/Combat/UpgradeNode.lua")
Script.Load("lua/Combat/UpgradeTree.lua")

local gUpgradeTree = UpgradeTree()
gUpgradeTree:Initialize()

function GetUpgradeTree()
    return gUpgradeTree
end

function ClearUpgradeTree()
    gUpgradeTree:Initialize()
    Shared.Message("Tree cleared")
end