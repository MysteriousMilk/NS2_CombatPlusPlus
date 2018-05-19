--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Overriden Functions:
 *  'Armory:GetCanBeUsedConstructed' - Override the 'GetCanBeUsedConstructed' function to prevent the player from 'using' the armory.
]]

function Armory:GetCanBeUsedConstructed()
    return false
end