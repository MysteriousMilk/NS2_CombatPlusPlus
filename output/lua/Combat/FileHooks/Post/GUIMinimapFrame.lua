local ns2_GUIMinimapFrame_Update = GUIMinimapFrame.Update
function GUIMinimapFrame:Update(deltaTime)

    ns2_GUIMinimapFrame_Update(self, deltaTime)

    self.chooseSpawnText:SetText("")

end