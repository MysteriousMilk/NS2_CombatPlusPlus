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

-- Bring up evolve menu
function Alien:Buy()

    -- Don't allow display in the ready room, or as phantom
    -- Don't allow buy menu to be opened while help screen is displayed.
    if self:GetIsLocalPlayer() and not HelpScreen_GetHelpScreen():GetIsBeingDisplayed() then

        -- The Embryo cannot use the buy menu in any case.
        if self:GetTeamNumber() ~= 0 and not self:isa("Embryo") then

            if not self.buyMenu then

                -- new Combat Alien Buy Menu (WhiteWizard)
                self.buyMenu = GetGUIManager():CreateGUIScript("CPPGUICombatAlienBuyMenu")

            else
                self:CloseMenu()
            end

        else
            self:PlayEvolveErrorSound()
        end

    end

end
