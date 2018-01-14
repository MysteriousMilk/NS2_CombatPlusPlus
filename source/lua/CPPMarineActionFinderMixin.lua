--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Show the text 'Socket Power Node' when the user looks at an 'Unsocketed' node.
 *
 * Overriden Functions:
 *  'MarineActionFinderMixin:OnProcessMove' - Added hint text for PowerPoints in the 'Unsocketed' state.
 *  Had to override the whole damn thing because the code needed to go right smack dab in the middle.
]]

local kIconUpdateRate = 0.25

if Client then

    function MarineActionFinderMixin:OnProcessMove()

        PROFILE("MarineActionFinderMixin:OnProcessMove")

        local prediction = Shared.GetIsRunningPrediction()
        if prediction then
            return
        end

        local now = Shared.GetTime()
        local enoughTimePassed = (now - self.lastMarineActionFindTime) >= kIconUpdateRate
        if not enoughTimePassed then
            return
        end

        self.lastMarineActionFindTime = now

        local success = false

        local gameStarted = self:GetGameStarted()

        if self:GetIsAlive() then

            local manualPickupWeapon = self:GetNearbyPickupableWeapon()

            if gameStarted and manualPickupWeapon then

                self.actionIconGUI:ShowIcon(BindingsUI_GetInputValue("Drop"), manualPickupWeapon:GetClassName(), nil)
                success = true

            else

                local ent = self:PerformUseTrace()
                if ent and (gameStarted or (ent.GetUseAllowedBeforeGameStart and ent:GetUseAllowedBeforeGameStart())) and GetPlayerCanUseEntity(self, ent) and not self:GetIsUsing() then

                    local hintText

                    if ent:isa("CommandStation") and ent:GetIsBuilt() then
                        hintText = gameStarted and "START_COMMANDING" or "START_GAME"
                    elseif ent:isa("PowerPoint") and ent:GetPowerState() == PowerPoint.kPowerState.unsocketed then
                        hintText = "SOCKET_POWER_NODE"
                    end

                    self.actionIconGUI:ShowIcon(BindingsUI_GetInputValue("Use"), nil, hintText, nil)
                    success = true

                end

            end
        end

        if not success then
            self.actionIconGUI:Hide()
        end

    end

end
