--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Turn on Combat HUD, trigger new buy menu, provide support for placing structures, and
 * override ArmsLab check.
]]

local ns2_Marine_UpdateClientEffects = Marine.UpdateClientEffects
function Marine:UpdateClientEffects(deltaTime, isLocal)

    if isLocal and self.lastAliveClient ~= self:GetIsAlive() then
        ClientUI.SetScriptVisibility("Combat/GUI/MarineStatusHUD", "Alive", self:GetIsAlive())
    end

    ns2_Marine_UpdateClientEffects(self, deltaTime, isLocal)

end

local ns2_Marine_OnCountDown = Marine.OnCountDown
function Marine:OnCountDown()

    ns2_Marine_OnCountDown(self)
    ClientUI.SetScriptVisibility("Combat/GUI/MarineStatusHUD", "Countdown", false)

end

local ns2_Marine_OnCountDownEnd = Marine.OnCountDownEnd
function Marine:OnCountDownEnd()

    ns2_Marine_OnCountDownEnd(self)
    ClientUI.SetScriptVisibility("Combat/GUI/MarineStatusHUD", "Countdown", true)

end

function Marine:Buy()

  -- Don't allow display in the ready room
  if self:GetTeamNumber() ~= 0 and Client.GetLocalPlayer() == self and not HelpScreen_GetHelpScreen():GetIsBeingDisplayed() then

      if not self.buyMenu then

          self.buyMenu = GetGUIManager():CreateGUIScript("Combat/GUI/MarineBuyMenu")
          self:TriggerEffects("marine_buy_menu_open")

      else

        self:CloseMenu()

      end

  end

end

local ns2_Marine_UpdateGhostModel = Marine.UpdateGhostModel
function Marine:UpdateGhostModel()

    ns2_Marine_UpdateGhostModel(self)

    local weapon = self:GetActiveWeapon()

    if weapon and weapon:isa("Builder") and weapon:GetBuilderMode() == kBuilderMode.Create then

        self.currentTechId = self:GetCreateStructureTechId()
        self.ghostStructureCoords = weapon:GetGhostModelCoords()
        self.ghostStructureValid = weapon:GetIsPlacementValid()
        self.showGhostModel = weapon:GetShowGhostModel()

    end

end

function MarineUI_GetHasArmsLab()

    local player = Client.GetLocalPlayer()
    
    if player then
        return true
    end
    
    return false
    
end
