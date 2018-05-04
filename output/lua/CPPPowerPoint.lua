--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Allows PowerPoints to be used in an 'Unsocketed' state.  Marines can use the 'Use' key
 * to socket PowerPoints now.
 *
 * Overriden Functions:
 *  'PowerPoint:GetCanBeUsed' - Removed the 'not socketed' check.
 *
 * Wrapped Functions
 *  'PowerPoint:OnUse' - Add additional logic for when the player uses the PowerPoint in the 'Unsocketed' state.
]]

function PowerPoint:GetCanBeUsed(player, useSuccessTable)

    if player:isa("Exo") then
        useSuccessTable.useSuccess = false
        return
    end

    useSuccessTable.useSuccess = not GetPowerPointRecentlyDestroyed(self) and (not self:GetIsBuilt() or (self:GetIsBuilt() and self:GetHealthScalar() < 1))
end

local ns2_PowerPoint_OnUse = PowerPoint.OnUse
function PowerPoint:OnUse(player, elapsedTime, useSuccessTable)

    if Client and player:isa("Marine") and self.powerState == PowerPoint.kPowerState.unsocketed then
        Client.SendNetworkMessage("RequestSocketPowerPoint", { powerPointId = self:GetId() }, true)
        useSuccessTable.useSuccess = true
    else
        ns2_PowerPoint_OnUse(self, player, elapsedTime, useSuccessTable)
    end

end
