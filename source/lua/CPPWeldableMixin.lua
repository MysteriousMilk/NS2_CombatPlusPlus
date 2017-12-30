local ns2_WeldableMixin_OnWeld = WeldableMixin.OnWeld
function WeldableMixin:OnWeld(doer, elapsedTime, player)

    ns2_WeldableMixin_OnWeld(self, doer, elapsedTime, player)

    if self:GetCanBeWelded(doer) and not self.OnWeldOverride and doer:isa("Welder") then

        local weldAmount = doer:GetRepairRate(self) * elapsedTime
        if HasMixin(doer, "CombatScore") then
            doer:AddCombatWeldPoints(weldAmount)
        end

    end

end
