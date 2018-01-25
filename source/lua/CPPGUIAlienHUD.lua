local ns2_GUIAlienHUD_SetIsVisible = GUIAlienHUD.SetIsVisible
function GUIAlienHUD:SetIsVisible(isVisible)

    ns2_GUIAlienHUD_SetIsVisible(self, isVisible)

    self.resourceDisplay.background:SetIsVisible(false)
    self.resourceDisplay.teamText:SetIsVisible(false)

end
