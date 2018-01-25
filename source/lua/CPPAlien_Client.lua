--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Toggles the Combat HUD on and off during the count down sequence.
 *
 * Wrapped Functions:
 *  'Alien:OnCountDown' - Turns the Combat HUD off while the count down sequence is executing.
 *  'Alien:OnCountDownEnd' - Turns the Combat HUD back on after the count down sequence is complete.
]]

local ns2_Alien_OnCountDown = Alien.OnCountDown
function Alien:OnCountDown()

    ns2_Alien_OnCountDown(self)

    ClientUI.SetScriptVisibility("CPPGUIAlienCombatHUD", "Countdown", false)

end

local ns2_Alien_OnCountDownEnd = Alien.OnCountDownEnd
function Alien:OnCountDownEnd()

    ns2_Alien_OnCountDownEnd(self)

    ClientUI.SetScriptVisibility("CPPGUIAlienCombatHUD", "Countdown", true)

end
