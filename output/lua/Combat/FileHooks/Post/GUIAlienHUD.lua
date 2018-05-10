-- local ns2_GUIAlienHUD_SetIsVisible = GUIAlienHUD.SetIsVisible
-- function GUIAlienHUD:SetIsVisible(isVisible)

--     ns2_GUIAlienHUD_SetIsVisible(self, isVisible)

--     self.resourceDisplay.background:SetIsVisible(false)
--     self.resourceDisplay.teamText:SetIsVisible(false)

-- end

local ns2_GUIAlienHUD_Update = GUIAlienHUD.Update
function GUIAlienHUD:Update(deltaTime)

    ns2_GUIAlienHUD_Update(self, deltaTime)

    self.resourceDisplay.pResDescription:SetText(ConditionalValue(PlayerUI_GetPersonalResources() == 1, "Upgrade Point", "Upgrade Points"))

end
