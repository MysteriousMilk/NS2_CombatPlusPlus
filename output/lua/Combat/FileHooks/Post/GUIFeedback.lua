
local ns2_GUIFeedback_Initialize = GUIFeedback.Initialize
function  GUIFeedback:Initialize()

	ns2_GUIFeedback_Initialize(self)

    self.buildText:SetText(self.buildText:GetText() .. " (Combat++ v"  .. kCombatVersion .. ")")
    
end