local ns2_GUIMarineHUD_Update = GUIMarineHUD.Update
function GUIMarineHUD:Update(deltaTime)

    ns2_GUIMarineHUD_Update(self, deltaTime)

    self.commanderName:SetIsVisible(false)
    self.resourceDisplay.teamText:SetIsVisible(false)
    self.resourceDisplay.background:SetIsVisible(false)

end
