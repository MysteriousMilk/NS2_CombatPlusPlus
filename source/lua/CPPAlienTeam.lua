function MakeTechEnt( techPoint, mapName, rightOffset, forwardOffset, teamType )
    local origin = techPoint:GetOrigin()
    local right = techPoint:GetCoords().xAxis
    local forward = techPoint:GetCoords().zAxis
    local position = origin + right * rightOffset + forward * forwardOffset

    local newEnt = CreateEntity( mapName, position, teamType)
    if HasMixin( newEnt, "Construct" ) then
        SetRandomOrientation( newEnt )
        newEnt:SetConstructionComplete()
    end

    if HasMixin( newEnt, "Live" ) then
        newEnt:SetIsAlive(true)
    end

    return newEnt
end

function AlienTeam:SpawnWarmUpStructures()
    local techPoint = self.startTechPoint
    if not (Shared.GetCheatsEnabled()) and #self.warmupStructures == 0 then
        self.warmupStructures[#self.warmupStructures+1] = MakeTechEnt(techPoint, Crag.kMapName, 3.5, -2, kAlienTeamType)
        self.warmupStructures[#self.warmupStructures+1] = MakeTechEnt(techPoint, Shade.kMapName, -3.5, 2, kAlienTeamType)
    end
end

local function CreateCysts(hive, harvester, teamNumber)

    local hiveOrigin = hive:GetOrigin()
    local harvesterOrigin = harvester:GetOrigin()

    -- Spawn all the Cyst spawn points close to the hive.
    local dist = (hiveOrigin - harvesterOrigin):GetLength()
    for c = 1, #Server.cystSpawnPoints do

        local spawnPoint = Server.cystSpawnPoints[c]
        if (spawnPoint - hiveOrigin):GetLength() <= (dist * 1.5) then

            local cyst = CreateEntityForTeam(kTechId.Cyst, spawnPoint, teamNumber, nil)
            cyst:SetConstructionComplete()
            cyst:SetInfestationFullyGrown()
            cyst:SetImmuneToRedeploymentTime(1)

        end

    end

end

function AlienTeam:SpawnInitialStructures(techPoint)

    self.startTechPoint = techPoint
    
    local tower, hive = PlayingTeam.SpawnInitialStructures(self, techPoint)

    hive:SetFirstLogin()
    hive:SetInfestationFullyGrown()

    -- It is possible there was not an available tower if the map is not designed properly.
    if tower then
        CreateCysts(hive, tower, self:GetTeamNumber())
    end

    return tower, hive

end
