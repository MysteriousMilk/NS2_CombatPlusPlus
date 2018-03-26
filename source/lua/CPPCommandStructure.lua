--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Prevent command structures from showing the text "Start Commanding".
 *
 * Overridden Functions:
 *  'CommandStructure:GetCanBeUsed' - Prevent command structures from showing the text "Start Commanding".
]]

function CommandStructure:GetCanBeUsed(player, useSuccessTable)
    useSuccessTable.useSuccess = false
end
