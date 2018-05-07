--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * NS2 Utility Functions
 *
 * Overridden Functions:
 *  'GetIsCloseToMenuStructure' - Always return true so that the marine buy menu doesnt close (not used from the armory anymore)
]]


function GetIsCloseToMenuStructure(player)
    return true
end