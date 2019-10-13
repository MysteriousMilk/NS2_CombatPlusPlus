--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Controls the flow of the game state.
 *
 * Wrapped Functions:
 *  'NS2Gamerules:SetGameState' - Added logic to reset persist data when going from WarmUp to PreGame.  Added
 *  logic to socket all power points on game start.
 *
 * Overriden Functions:
 *  'NS2Gamerules:ResetGame' - Removes most of the command structure stuff.  Create the Game Master.
 *  Removes all Resource Towers.
 *  'NS2Gamerules:CheckForNoCommander' - Prevent the 'No Commander' message from appearing on screen.
 *  'NS2Gamerules:ResetPlayerScores' - Overriden  to add call to 'CombatScoreMixin.ResetCombatScores'.
 *  'NS2Gamerules:CheckGameStart' - Overriden to remove 'No Commander' and 'No IP' checks from game start conditions.
 *  'NS2Gamerules:UpdateWarmUp' - Modified to allow bots to trigger the pregame mode.
]]

if Server then

    function NS2Gamerules:GetIsOvertime()

        if self:GetGameStarted() then
            return Shared.GetTime() - self:GetGameStartTime() >= CombatSettings["TimeLimit"]
        end

        return false

    end

    function NS2Gamerules:GetIsFreeSpawnTime()

        if self:GetGameStarted() then
            return Shared.GetTime() - self:GetGameStartTime() <= CombatSettings["FreeSpawnTime"]
        end

        return false

    end

    local ns2_NS2Gamerules_OnClientDisconnect = NS2Gamerules.OnClientDisconnect
    function NS2Gamerules:OnClientDisconnect(client)

        local player = client:GetControllingPlayer()

        if player then
            
            -- Kill any structures the player owns
            player:KillOwnedStructures()

            -- If the disconnecting player is a marine, they may own a exosuit that
            -- they are not currently in.  If so, destroy it.
            if player:isa("Marine") and player.DestroyExosuit then
                player:DestroyExosuit()
            end

        end

    end

    local ns2_NS2Gamerules_OnEntityKilled = NS2Gamerules.OnEntityKilled
    function NS2Gamerules:OnEntityKilled(targetEntity, attacker, doer, point, direction)

        -- refund upgrade points for any structure that was destroyed
        local mapName = targetEntity:GetMapName()
        local techId = LookupTechId(mapName, kTechDataMapName, kTechId.None)

        if CombatPlusPlus_GetIsStructureTechId(techId) then

            local owner = targetEntity:GetOwner()

            if owner and owner:isa("Player") then
                owner:Refund(techId, true)
            end

        end

        ns2_NS2Gamerules_OnEntityKilled(self, targetEntity, attacker, doer, point, direction)

    end

    local ns2_NS2Gamerules_ResetGame = NS2Gamerules.ResetGame
    function NS2Gamerules:ResetGame()

        ns2_NS2Gamerules_ResetGame(self)

        -- kill all resource towers.. not used in combat mode
        for index, entity in ientitylist(Shared.GetEntitiesWithClassname("ResourceTower")) do
            DestroyEntity(entity);
        end

    end

    function NS2Gamerules:CheckForNoCommander(onTeam, commanderType)

    end
    
    function NS2Gamerules:UpdateCombatMode()

        if self.nextTimeXpBalance == nil then
            self.nextTimeXpBalance = kCombatXpBalanceInterval
        end

        -- calculate the current game time
        local gameTime = math.floor(Shared.GetTime() - self.gameInfo:GetStartTime())

        -- check to see if it's time to rebalance xp
        if gameTime >= self.nextTimeXpBalance then
            
            local marineXpAvg = CombatPlusPlus_GetTeamAverageXp(kTeam1Index)
            local alienXpAvg = CombatPlusPlus_GetTeamAverageXp(kTeam2Index)
            
            -- balance xp
            for i, player in ientitylist(Shared.GetEntitiesWithClassname("Player")) do

                if player:GetIsPlaying() then

                    if player:GetTeamNumber() == kTeam1Index then
                        player:BalanceXp(marineXpAvg, player)
                    elseif player:GetTeamNumber() == kTeam2Index then
                        player:BalanceXp(alienXpAvg, player)
                    end

                end

            end
            
            self.nextTimeXpBalance = self.nextTimeXpBalance + kCombatXpBalanceInterval
            
        end
        
    end
    
    local ns2_NS2Gamerules_OnUpdate = NS2Gamerules.OnUpdate
    function NS2Gamerules:OnUpdate(timePassed)
        
        ns2_NS2Gamerules_OnUpdate(self, timePassed)
        
        if self:GetGameStarted() then
            self:UpdateCombatMode()
        end
        
    end

    function NS2Gamerules:GetCanSpawnImmediately()
        return not self:GetGameStarted() or Shared.GetCheatsEnabled()
    end

    local ns2_NS2GameRules_JoinTeam = NS2Gamerules.JoinTeam
    function NS2Gamerules:JoinTeam(player, newTeamNumber, force)

        local oldTeamNumber = player:GetTeamNumber()
        local success = false
        local newPlayer = nil

        success, newPlayer = ns2_NS2GameRules_JoinTeam(self, player, newTeamNumber, force)

        if success then

            -- Rejoin penalty only applies to a playing team.
            -- Only update last team if it is a playing team that the player is joining.
            if GetIsPlayingTeam(newTeamNumber) then

                local oldRank = newPlayer:GetCombatRank()

                -- reset xp
                newPlayer:ResetCombatScores()

                if oldTeamNumber ~= newTeamNumber then

                    -- kill any structures the player owned on their old team
                    player:KillOwnedStructures()

                end

                newPlayer:ClearUpgrades()
                newPlayer:CheckRejoinPenalty(newTeamNumber, oldRank)
                newPlayer:SetLastTeam(newTeamNumber)

            end

        end

        return success, newPlayer

    end

    function NS2Gamerules:ResetPlayerScores()

        for _, player in ientitylist(Shared.GetEntitiesWithClassname("Player")) do
            if player.ResetScores and player.client then
                player:ResetScores()
                player:ResetCombatScores()
                self.playerRanking:SetEntranceTime( player, player:GetTeamNumber() )
            end
        end

    end

--     local ns2_SetGameState = NS2Gamerules.SetGameState
--     function NS2Gamerules:SetGameState(state)


--         -- Reset player upgrade trees
--         if state ~= self.gameState and state == kGameState.Started then
            
--             local function MakeIneligibleForLateJoinXp(player)
--                 player.eligibleForLateJoinXp = false
--             end

--             self:GetTeam1():ForEachPlayer(MakeIneligibleForLateJoinXp)
--             self:GetTeam2():ForEachPlayer(MakeIneligibleForLateJoinXp)

--         end

--         ns2_SetGameState(self, state)

-- end

    function NS2Gamerules:CheckGameStart()

        local team1players, _, team1bots = self.team1:GetNumPlayers()
        local team2players, _, team2bots = self.team2:GetNumPlayers()
        local numPlayers = team1players + team1bots + team2players + team2bots

        if self:GetGameState() <= kGameState.NotStarted and numPlayers >= self:GetWarmUpPlayerLimit() then
            self:SetGameState(kGameState.PreGame)
        end

    end

    --[[
     * Combat++ - Make sure we go straight to pregame from warmup.
     * Allow bots to trigger pregame as well
    ]]
    function NS2Gamerules:UpdateWarmUp()

        local gameState = self:GetGameState()

        if gameState < kGameState.PreGame then

            local team1players, _, team1bots = self.team1:GetNumPlayers()
            local team2players, _, team2bots = self.team2:GetNumPlayers()
            local numPlayers = team1players + team1bots + team2players + team2bots

            if gameState == kGameState.NotStarted and numPlayers < self:GetWarmUpPlayerLimit() then

                self.team1:SpawnWarmUpStructures()
                self.team2:SpawnWarmUpStructures()

                self:SetGameState(kGameState.WarmUp)

                if GetSeason() == Seasons.kFall then
                    self:DestroyUnusedPowerNodes()
                end

            elseif gameState == kGameState.WarmUp and numPlayers >= self:GetWarmUpPlayerLimit() then

                self:SetGameState(kGameState.PreGame)

            end

        end

    end

end
