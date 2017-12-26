function CommandStructure:OnUpdateRender()

    local player = Client.GetLocalPlayer()
    local now = Shared.GetTime()

    self.lastTimeOccupied = self.lastTimeOccupied or now
    if self:GetIsOccupied() then
        self.lastTimeOccupied = now
    end

    local displayHelpArrows = Client.GetOptionInteger("hudmode", kHUDMode.Full) == kHUDMode.Full
    if player and displayHelpArrows then

        -- Display the help arrows (get into Comm structure) when the
        -- team does not have a commander and the Comm structure is built
        -- and some time has passed.
        displayHelpArrows = displayHelpArrows and player:GetTeamNumber() == self:GetTeamNumber()
        displayHelpArrows = displayHelpArrows and self:GetIsBuilt() and self:GetIsAlive()
        displayHelpArrows = displayHelpArrows and not ScoreboardUI_GetTeamHasCommander(self:GetTeamNumber())
        displayHelpArrows = displayHelpArrows and not self:GetIsOccupied() and (now - self.lastTimeOccupied) >= 8

    end

    --Disable the Arrow Cinematic so players don't think they can "use" the command structure
    --DisplayHelpArrows(self, displayHelpArrows)

end

-- Disable from player use
function CommandStructure:GetCanBeUsed(player, useSuccessTable)
    useSuccessTable.useSuccess = false
end

-- Disable from player use
function CommandStructure:GetCanBeUsedConstructed(byPlayer)
    return false
end

-- Disable from player use
function CommandStructure:GetUseAllowedBeforeGameStart()
    return false
end
