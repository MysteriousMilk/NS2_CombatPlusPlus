function PlayingTeam:GetHasTeamLost()

    -- Don't bother with the original - we just set our own logic here.
	-- You can lose with cheats on (testing purposes)
	if(GetGamerules():GetGameStarted()) then
    
        -- Team can't respawn or last Command Station or Hive destroyed
        local numCommandStructures = self:GetNumAliveCommandStructures()
        
        if  ( numCommandStructures == 0 ) or
            ( self:GetNumPlayers() == 0 ) then
            
            return true
            
        end
            
    end

    return false

end

function PlayingTeam:Update(timePassed)

    if self.timeSinceLastSpawn == nil then 
		self:ResetSpawnTimer()
    end

    -- Increment the spawn timer
    self.timeSinceLastSpawn = self.timeSinceLastSpawn + timePassed

    -- check if there are really no Spectators (should fix the spawnbug)
    local players = GetEntitiesForTeam("Spectator", self:GetTeamNumber())

    -- Spawn all players in the queue every time the spawn wave timer expires
    if self:GetNumPlayersInQueue() or (#players > 0)  then
		
		-- Are we ready to spawn? This is based on the time since the last spawn wave...
        local respawnTimer = kCombatRespawnTimer
        
		if GetIsOvertime() then
			respawnTimer = kCombatOvertimeRespawnTimer
        end
        
        if self.timeSinceLastSpawn >= respawnTimer then
            
			-- Reset the spawn timer.
			self:ResetSpawnTimer()
			
			-- Loop through the respawn queue and spawn dead players.
            local thisPlayer = self:GetOldestQueuedPlayer()
			
            if thisPlayer then

                local numPlayersSpawned = 0

                while thisPlayer ~= nil and numPlayersSpawned < CombatSettings["MaxSpawnersPerWave"] do

                    local success = self:SpawnPlayer(thisPlayer)
    
                    -- Don't crash the server when no more players can spawn...
                    if not success then break end

                    numPlayersSpawned = numPlayersSpawned + 1
                    thisPlayer = self:GetOldestQueuedPlayer()
    
                end

            else

                -- somethings wrong, spawn all Spectators
                for _, player in ipairs(players) do

                    local success = self:SpawnPlayer(player)

                    -- Don't crash the server when no more players can spawn...
                    if not success then break end

                end

            end
  
        else
            
            if GetGamerules():GetIsFreeSpawnTime() then

                -- Loop through the respawn queue and spawn any players that have not yet intially spawned
                for i = 1, #self.respawnQueue do

                    local playerid = self.respawnQueue[i]
                    local thisPlayer = Shared.GetEntity(playerid)

                    if thisPlayer and thisPlayer:IsInitialSpawn() then

                        if not self:SpawnPlayer(thisPlayer) then
                            break
                        end

                    end

                end

            end

			-- Send any 'waiting to respawn' messages (normally these only go to AlienSpectators)
            for _, player in ipairs(self:GetPlayers()) do
                
                if not player.waitingToSpawnMessageSent then
                    
                    if player:GetIsAlive() == false then
                        
						SendPlayersMessage( { player }, kTeamMessageTypes.SpawningWait )
						player.waitingToSpawnMessageSent = true
                        player.timeWaveSpawnEnd = self.nextSpawnTime
                        
                    end
                    
                end
                
            end
            
        end
        
    end

end

function PlayingTeam:ResetSpawnTimer()

	-- Reset the spawn timer
    self.timeSinceLastSpawn = 0
    
    if GetIsOvertime() then
		self.nextSpawnTime = Shared.GetTime() + kCombatOvertimeRespawnTimer
	else
        self.nextSpawnTime = Shared.GetTime() + kCombatRespawnTimer
    end

end

function PlayingTeam:SpawnPlayer(player)

    local success = false
    local newPlayer = nil

    player.isSpawning = true

    if Server and player.GetSpectatorMode then
        player:SetSpectatorMode(kSpectatorMode.Following)
    end

    success, newPlayer = self:ReplaceRespawnPlayer(player, nil, nil)

    if success then

        self:RemovePlayerFromRespawnQueue(player)

        --give spawn protection (dont set the time here, just that spawn protect is active)
        newPlayer:SetSpawnProtect()

        -- spawn effect
        if newPlayer:isa("Marine") then
            newPlayer:TriggerEffects("infantry_portal_spawn")
        end

        newPlayer:TriggerEffects("spawnSoundEffects")

        -- Remove the third-person mode (bug introduced in 216).
        newPlayer:SetCameraDistance(0)

        -- always switch to first weapon
        newPlayer:SwitchWeapon(1)

        newPlayer.isSpawning = false

        -- check for late join xp eligibility
        newPlayer:CheckLateJoinXp()

        -- do this last because newPlayer can be replace if there is a class upgrade
        if newPlayer.UpgradeManager then
            newPlayer.UpgradeManager:ApplyAllUpgrades(newPlayer)
        end

    else

        player.isSpawning = false

    end

    return success

end

-- Call with origin and angles, or pass nil to have them determined from team location and spawn points.
function PlayingTeam:RespawnPlayer(player, origin, angles)

    local success = false
    local initialTechPoint = Shared.GetEntity(self.initialTechPointId)
    
    if origin ~= nil and angles ~= nil then
        success = Team.RespawnPlayer(self, player, origin, angles)
    elseif initialTechPoint ~= nil then
    
        -- Compute random spawn location
        local capsuleHeight, capsuleRadius = player:GetTraceCapsule()
        local spawnOrigin = GetRandomSpawnForCapsule(capsuleHeight, capsuleRadius, initialTechPoint:GetOrigin(), kSpawnMinDistance, kSpawnMaxDistance, EntityFilterAll())
        
        if not spawnOrigin then
            spawnOrigin = initialTechPoint:GetOrigin() + Vector(2, 0.2, 2)
        end
        
        -- Orient player towards tech point
        local lookAtPoint = initialTechPoint:GetOrigin() + Vector(0, 5, 0)
        local toTechPoint = GetNormalizedVector(lookAtPoint - spawnOrigin)
        success = Team.RespawnPlayer(self, player, spawnOrigin, Angles(GetPitchFromVector(toTechPoint), GetYawFromVector(toTechPoint), 0))
        
    else
        Print("PlayingTeam:RespawnPlayer(): No initial tech point.")
    end

    if success then
        player.CombatData.IsInitialSpawn = false
    end

    return success
    
end

-- Call with origin and angles, or pass nil to have them determined from team location and spawn points.
-- function PlayingTeam:RespawnPlayer(player, origin, angles)

--     local success = false
--     local initialTechPoint = Shared.GetEntity(self.initialTechPointId)

--     if origin ~= nil and angles ~= nil then

--         success = Team.RespawnPlayer(self, player, origin, angles)
--         assert(success)

--     elseif initialTechPoint ~= nil then

--         -- Compute random spawn location
--         local capsuleHeight, capsuleRadius = player:GetTraceCapsule()
--         local spawnOrigin

--         -- Try it 10 times here
--         for index = 1, 10 do

--             spawnOrigin = GetRandomSpawnForCapsule(capsuleHeight, capsuleRadius, initialTechPoint:GetOrigin(), kSpawnMinDistance, kSpawnMaxDistance, EntityFilterAll())

--             if spawnOrigin ~= nil then
--                 break
--             end

--         end

--         if spawnOrigin ~= nil then

--             -- Orient player towards tech point
--             local lookAtPoint = initialTechPoint:GetOrigin() + Vector(0, 5, 0)
--             local toTechPoint = GetNormalizedVector(lookAtPoint - spawnOrigin)

--             success = Team.RespawnPlayer(self, player, spawnOrigin, Angles(GetPitchFromVector(toTechPoint), GetYawFromVector(toTechPoint), 0))
--             assert(success)

--         else

--             Print("PlayingTeam:RespawnPlayer: Couldn't compute random spawn for player. Will retry at next wave...\n")

--             -- Escape the player's name here... names like Sandwich% cause a crash to appear here!
--             local escapedPlayerName = string.gsub(player:GetName(), "%%", "")
--             Print("PlayingTeam:RespawnPlayer: Name: " .. escapedPlayerName .. " Class: " .. player:GetClassName())

--         end

--     else

--         Shared.Message("PlayingTeam:RespawnPlayer(): No initial tech point.")

--     end

-- end