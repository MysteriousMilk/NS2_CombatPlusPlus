CombatDataMixin = CreateMixin(CombatDataMixin)
CombatDataMixin.type = "CombatData"

function CombatDataMixin:__initmixin()

    if Server then

        self.CombatData =
        {
            LastTeamNumber = kTeamReadyRoom,
            EligibleForLateJoinXp = true,
            IsInitialSpawn = true
        }

    end

end

if Server then

    function CombatDataMixin:SetLastTeam(lastTeamNumber)

        self.CombatData.LastTeamNumber = lastTeamNumber

    end

    function CombatDataMixin:CheckRejoinPenalty(newTeamNumber, oldRank)

        if newTeamNumber == self.CombatData.LastTeamNumber and oldRank >= CombatSettings["PenaltyLevel"] + 1 then

            -- enact penalty for leaving and rejoining the same team
            self:ResetCombatScores()

            local newRank = oldRank - CombatSettings["PenaltyLevel"]
            self:GiveCombatRank(newRank)

        end

    end

    function CombatDataMixin:MakeIneligibleForLateJoinXp()

        self.CombatData.EligibleForLateJoinXp = false

    end

    function CombatDataMixin:CheckLateJoinXp()

        -- check for late join xp eligibility
        if GetGamerules():GetGameStarted() and self.CombatData.EligibleForLateJoinXp then
            local averageXp = CombatPlusPlus_GetTeamAverageXp(self:GetTeamNumber(), self)
            self:BalanceXp(averageXp)
        end

        if GetIsPlayingTeam(self:GetTeamNumber()) then
            self.CombatData.EligibleForLateJoinXp = false
        end

    end

    function CombatDataMixin:IsInitialSpawn()

        return self.CombatData.IsInitialSpawn

    end

    function CombatDataMixin:CopyPlayerDataFrom(player)

        self.CombatData.LastTeamNumber = player.CombatData.LastTeamNumber
        self.CombatData.EligibleForLateJoinXp = player.CombatData.EligibleForLateJoinXp
        self.CombatData.IsInitialSpawn = player.CombatData.IsInitialSpawn

    end

end