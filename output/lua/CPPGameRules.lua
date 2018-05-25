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

    local ns2_NS2Gamerules_OnClientDisconnect = NS2Gamerules.OnClientDisconnect
    function NS2Gamerules:OnClientDisconnect(client)

        local player = client:GetControllingPlayer()

        if player then
            player:KillOwnedStructures()
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

                local cost = LookupUpgradeData(techId, kUpDataCostIndex)
                owner:GiveCombatUpgradePoints(cost, kUpgradePointSourceType.Refund)

            end

        end

        ns2_NS2Gamerules_OnEntityKilled(self, targetEntity, attacker, doer, point, direction)

    end

    -- Starts a new game by resetting the map and all of the players. Keep everyone on current teams (readyroom, playing teams, etc.) but
    -- respawn playing players.
    -- Combat++ - Removed refrences to the commmand (relogin of previous commander.. etc)
    function NS2Gamerules:ResetGame()

        self:SetGameState(kGameState.NotStarted)

        TournamentModeOnReset()

        -- save commanders for later re-login
        --local team1CommanderClient = self.team1:GetCommander() and self.team1:GetCommander():GetClient()
        --local team2CommanderClient = self.team2:GetCommander() and self.team2:GetCommander():GetClient()

        -- Cleanup any peeps currently in the commander seat by logging them out
        -- have to do this before we start destroying stuff.
        self:LogoutCommanders()

        -- Destroy any map entities that are still around
        DestroyLiveMapEntities()

        -- Reset all players, delete other not map entities that were created during
        -- the game (hives, command structures, initial resource towers, etc)
        -- We need to convert the EntityList to a table since we are destroying entities
        -- within the EntityList here.
        for index, entity in ientitylist(Shared.GetEntitiesWithClassname("Entity")) do

            -- Don't reset/delete NS2Gamerules or TeamInfo.
            -- NOTE!!!
            -- MapBlips are destroyed by their owner which has the MapBlipMixin.
            -- There is a problem with how this reset code works currently. A map entity such as a Hive creates
            -- it's MapBlip when it is first created. Before the entity:isa("MapBlip") condition was added, all MapBlips
            -- would be destroyed on map reset including those owned by map entities. The map entity Hive would still reference
            -- it's original MapBlip and this would cause problems as that MapBlip was long destroyed. The right solution
            -- is to destroy ALL entities when a game ends and then recreate the map entities fresh from the map data
            -- at the start of the next game, including the NS2Gamerules. This is how a map transition would have to work anyway.
            -- Do not destroy any entity that has a parent. The entity will be destroyed when the parent is destroyed or
            -- when the owner manually destroyes the entity.
            local shieldTypes = { "GameInfo", "MapBlip", "NS2Gamerules", "PlayerInfoEntity" }
            local allowDestruction = true
            for i = 1, #shieldTypes do
                allowDestruction = allowDestruction and not entity:isa(shieldTypes[i])
            end

            if allowDestruction and entity:GetParent() == nil then

                -- Reset all map entities and all player's that have a valid Client (not ragdolled players for example).
                local resetEntity = entity:isa("TeamInfo") or entity:GetIsMapEntity() or (entity:isa("Player") and entity:GetClient() ~= nil)
                if resetEntity then

                    if entity.Reset then
                        entity:Reset()
                    end

                else
                    DestroyEntity(entity)
                end

            end

        end

        -- Clear out obstacles from the navmesh before we start repopualating the scene
        RemoveAllObstacles()

        -- Build list of tech points
        local techPoints = EntityListToTable(Shared.GetEntitiesWithClassname("TechPoint"))
        if table.maxn(techPoints) < 2 then
            Print("Warning -- Found only %d %s entities.", table.maxn(techPoints), TechPoint.kMapName)
        end

        local resourcePoints = Shared.GetEntitiesWithClassname("ResourcePoint")
        if resourcePoints:GetSize() < 2 then
            Print("Warning -- Found only %d %s entities.", resourcePoints:GetSize(), ResourcePoint.kPointMapName)
        end

        -- add obstacles for resource points back in
        for index, resourcePoint in ientitylist(resourcePoints) do
            resourcePoint:AddToMesh()
        end

        local team1TechPoint = nil
        local team2TechPoint = nil

        if Server.teamSpawnOverride and #Server.teamSpawnOverride > 0 then

            for t = 1, #techPoints do

                local techPointName = string.lower(techPoints[t]:GetLocationName())
                local selectedSpawn = Server.teamSpawnOverride[1]
                if techPointName == selectedSpawn.marineSpawn then
                    team1TechPoint = techPoints[t]
                elseif techPointName == selectedSpawn.alienSpawn then
                    team2TechPoint = techPoints[t]
                end

            end

            if not team1TechPoint or not team2TechPoint then
                Shared.Message("Invalid spawns, defaulting to normal spawns")
                if Server.spawnSelectionOverrides then

                    local selectedSpawn = self.techPointRandomizer:random(1, #Server.spawnSelectionOverrides)
                    selectedSpawn = Server.spawnSelectionOverrides[selectedSpawn]

                    for t = 1, #techPoints do

                        local techPointName = string.lower(techPoints[t]:GetLocationName())
                        if techPointName == selectedSpawn.marineSpawn then
                            team1TechPoint = techPoints[t]
                        elseif techPointName == selectedSpawn.alienSpawn then
                            team2TechPoint = techPoints[t]
                        end

                    end

                else

                    -- Reset teams (keep players on them)
                    team1TechPoint = self:ChooseTechPoint(techPoints, kTeam1Index)
                    team2TechPoint = self:ChooseTechPoint(techPoints, kTeam2Index)

                end

            end

        elseif Server.spawnSelectionOverrides then

            local selectedSpawn = self.techPointRandomizer:random(1, #Server.spawnSelectionOverrides)
            selectedSpawn = Server.spawnSelectionOverrides[selectedSpawn]

            for t = 1, #techPoints do

                local techPointName = string.lower(techPoints[t]:GetLocationName())
                if techPointName == selectedSpawn.marineSpawn then
                    team1TechPoint = techPoints[t]
                elseif techPointName == selectedSpawn.alienSpawn then
                    team2TechPoint = techPoints[t]
                end

            end

        else

            -- Reset teams (keep players on them)
            team1TechPoint = self:ChooseTechPoint(techPoints, kTeam1Index)
            team2TechPoint = self:ChooseTechPoint(techPoints, kTeam2Index)

        end

        -- Reset the GameModeController for Combat++
        ResetGameMaster()
        GetGameMaster():SetMarineTechPoint(team1TechPoint)
        GetGameMaster():SetAlientTechPoint(team2TechPoint)

        self.team1:ResetPreservePlayers(team1TechPoint)
        self.team2:ResetPreservePlayers(team2TechPoint)

        assert(self.team1:GetInitialTechPoint() ~= nil)
        assert(self.team2:GetInitialTechPoint() ~= nil)

        -- Save data for end game stats later.
        self.startingLocationNameTeam1 = team1TechPoint:GetLocationName()
        self.startingLocationNameTeam2 = team2TechPoint:GetLocationName()
        self.startingLocationsPathDistance = GetPathDistance(team1TechPoint:GetOrigin(), team2TechPoint:GetOrigin())
        self.initialHiveTechId = nil

        self.worldTeam:ResetPreservePlayers(nil)
        self.spectatorTeam:ResetPreservePlayers(nil)

        -- Replace players with their starting classes with default loadouts at spawn locations
        self.team1:ReplaceRespawnAllPlayers()
        self.team2:ReplaceRespawnAllPlayers()

        self.clientpres = {}

        -- Create team specific entities
        local commandStructure1 = self.team1:ResetTeam()
        local commandStructure2 = self.team2:ResetTeam()

        -- Create living map entities fresh
        CreateLiveMapEntities()

        self.forceGameStart = false
        self.preventGameEnd = nil
        -- Reset banned players for new game
        self.bannedPlayers = {}

        -- Send scoreboard and tech node update, ignoring other scoreboard updates (clearscores resets everything)
        for index, player in ientitylist(Shared.GetEntitiesWithClassname("Player")) do
            Server.SendCommand(player, "onresetgame")
            player.sendTechTreeBase = true
        end

        -- kill all resource towers.. not used in combat mode
        for index, entity in ientitylist(Shared.GetEntitiesWithClassname("ResourceTower")) do
          DestroyEntity(entity);
        end

        self.team1:OnResetComplete()
        self.team2:OnResetComplete()

    end

    function NS2Gamerules:CheckForNoCommander(onTeam, commanderType)

    end

    local ns2_NS2GameRules_JoinTeam = NS2Gamerules.JoinTeam
    function NS2Gamerules:JoinTeam(player, newTeamNumber, force)

        local oldTeamNumber = player:GetTeamNumber()
        local success = false
        local newPlayer = nil

        if oldTeamNumber ~= newTeamNumber and player.UpgradeManager then
            player.UpgradeManager:GetTree():Initialize()
        end

        success, newPlayer = ns2_NS2GameRules_JoinTeam(self, player, newTeamNumber, force)

        if success and oldTeamNumber ~= newTeamNumber then

            -- kill any structures the player owned on their old team
            player:KillOwnedStructures()

            -- reset the player's upgrades
            if newPlayer.UpgradeManager then

                -- reset xp
                newPlayer:ResetCombatScores()

                -- reset upgrade manager
                newPlayer.UpgradeManager:SetPlayer(newPlayer)
                newPlayer.UpgradeManager:Reset()
                newPlayer.UpgradeManager:UpdateUnlocks(false)
                newPlayer.UpgradeManager:GetTree():SendFullTree(newPlayer)

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

    local ns2_SetGameState = NS2Gamerules.SetGameState
    function NS2Gamerules:SetGameState(state)

        -- if (state == kGameState.NotStarted) then
        --     Shared.Message("GameState changed to NotStarted.")
        -- elseif (state == kGameState.WarmUp) then
        --     Shared.Message("GameState changed to WarmUp.")
        -- elseif (state == kGameState.PreGame) then
        --     Shared.Message("GameState changed to PreGame.")
        -- elseif (state == kGameState.Countdown) then
        --     Shared.Message("GameState changed to Countdown.")
        -- elseif (state == kGameState.Started) then
        --     Shared.Message("GameState changed to Started.")
        -- end

        -- Reset player upgrade trees
        -- if state ~= self.gameState and state == kGameState.PreGame then
            
        --     if Server then

        --         for _, player in ientitylist(Shared.GetEntitiesWithClassname("Player")) do
        --             player:Reset()
        --         end

        --     end

        -- end

        ns2_SetGameState(self, state)

    end

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
