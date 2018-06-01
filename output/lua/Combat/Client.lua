--[[
 * Natural Selection 2 - Combat++ Mod
 * Created by: WhiteWizard
 *
 * Handles client functionality for Combat++.
]]

decoda_name = "Client"
Print("----------------------------------------------------------------------------------")
Print("Combat++ v%s loaded.", kCombatVersion)
Print("----------------------------------------------------------------------------------")
Print("This server is running the game mode Combat++.")
Print("This mod removes RTS elements and gives you experience for doing things in game.")
Print("As you gain more experience, you gain new levels.")
Print("With each new level, you receive Upgrade Points to spend on upgrades.")
Print("Score = XP and Resources = Upgrade Points to use.")
Print("Objective: Kill the Hive or Command Station.")
Print("----------------------------------------------------------------------------------")

Script.Load("lua/Combat/CombatXpMessages.lua")
Script.Load("lua/Combat/GUI/CombatMessageUI.lua")
Script.Load("lua/Combat/GUI/CombatScoreDisplayUI.lua")
Script.Load("lua/Combat/GUI/CombatUIHelper.lua")
Script.Load("lua/Combat/GUI/MarineStatusHUD.lua")
Script.Load("lua/Combat/GUI/AlienStatusHUD.lua")
--Script.Load("lua/Hud/CPPGUIInventory.lua")

-- precache the upgrade textures used on the buy menus
PrecacheUpgradeTextures()

-- load new GUI scripts
AddClientUIScriptForClass("Marine", "Combat/GUI/MarineStatusHUD")
AddClientUIScriptForClass("Exo", "Combat/GUI/MarineStatusHUD")
AddClientUIScriptForClass("Alien", "Combat/GUI/AlienStatusHUD")
AddClientUIScriptForClass("Marine", "Combat/GUI/CombatMessageUI")
AddClientUIScriptForClass("Exo", "Combat/GUI/CombatMessageUI")
AddClientUIScriptForClass("Alien", "Combat/GUI/CombatMessageUI")
AddClientUIScriptForTeam(kTeam1Index, "Combat/GUI/GameStatusHUD")
AddClientUIScriptForTeam(kTeam2Index, "Combat/GUI/GameStatusHUD")

local gUpgradeTree = UpgradeTree()
gUpgradeTree:Initialize()

function GetUpgradeTree()
    return gUpgradeTree
end

function ClearUpgradeTree()
    gUpgradeTree:Initialize()
    Print("Tree cleared")
end