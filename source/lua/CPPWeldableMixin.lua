local ns2_WeldableMixin_OnWeld = WeldableMixin.OnWeld
function WeldableMixin:OnWeld(doer, elapsedTime, player)

    local healthBeforeWeld = self:GetHealth()
    local armorBeforeWeld = self:GetArmor()

    ns2_WeldableMixin_OnWeld(self, doer, elapsedTime, player)

    if self:GetCanBeWelded(doer) and player:isa("Marine") and HasMixin(player, "CombatScore") then
        local weldPoints = (self:GetHealth() - healthBeforeWeld) + (self:GetArmor() - armorBeforeWeld)
        player:AddCombatWeldPoints(weldPoints)
    end

end
