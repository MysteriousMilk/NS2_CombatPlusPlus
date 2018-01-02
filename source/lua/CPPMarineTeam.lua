--Cache for spawned ip positions
local takenInfantryPortalPoints = {}

local ns2_MarineTeam_ResetTeam = MarineTeam.ResetTeam
function MarineTeam:ResetTeam()

    local commandStructure = ns2_MarineTeam_ResetTeam(self)

    takenInfantryPortalPoints = {}

    return commandStructure

end

function MarineTeam:GetHasAbilityToRespawn()
    return true
end

function MarineTeam:GetTotalInRespawnQueue()

    local numPlayers = 0

    for i = 1, #self.respawnQueue do
        local player = Shared.GetEntity(self.respawnQueue[i])
        if player then
            numPlayers = numPlayers + 1
        end

    end

    return numPlayers

end

function MarineTeam:OnRespawnQueueChanged()

    --GetGameMaster():SpawnMarinePlayer(self:GetOldestQueuedPlayer())
    local spawningStructures = GetEntitiesForTeam("CPPMarineSpawn", self:GetTeamNumber())

    for index, current in ipairs(spawningStructures) do

        if current:GetIsPowered() then
            current:FillQueueIfFree()
        end

    end

end

local function CreateSpawnPoint(self, techPoint)

    local techPointOrigin = techPoint:GetOrigin() + Vector(0, 2, 0)
    local spawnPoint

    -- First check the predefined spawn points. Look for a close one.
    for p = 1, #Server.infantryPortalSpawnPoints do

        if not takenInfantryPortalPoints[p] then
            local predefinedSpawnPoint = Server.infantryPortalSpawnPoints[p]
            if (predefinedSpawnPoint - techPointOrigin):GetLength() <= kInfantryPortalAttachRange then
                spawnPoint = predefinedSpawnPoint
                takenInfantryPortalPoints[p] = true
                break
            end
        end

    end

    if not spawnPoint then

        spawnPoint = GetRandomBuildPosition( kTechId.InfantryPortal, techPointOrigin, kInfantryPortalAttachRange )
        spawnPoint = spawnPoint and spawnPoint - Vector( 0, 0.6, 0 )

    end

    if spawnPoint then

        local ip = CreateEntity(CPPMarineSpawn.kMapName, spawnPoint, self:GetTeamNumber())
        SetRandomOrientation(ip)

    end

end

-- remove no-ip check
function MarineTeam:Update(timePassed)

    PROFILE("MarineTeam:Update")

    PlayingTeam.Update(self, timePassed)

    -- Update distress beacon mask
    self:UpdateGameMasks(timePassed)

    for index, player in ipairs(GetEntitiesForTeam("Player", self:GetTeamNumber())) do
        if player:isa("Marine") then
            player:UpdateArmorAmount(player:GetArmorLevel())
        end
    end

    --  check to see if the team has enough players now for an extra spawn point
    local spawnPointCount = table.icount(GetEntitiesForTeam("CPPMarineSpawn", self:GetTeamNumber()))
    if self:GetNumPlayers() > kMarineSpawnAdjustmentThreshold and spawnPointCount == kMinMarineSpawnPoints then
        CreateSpawnPoint(self, GetGameMaster():GetMarineTechPoint())
    end

end

function MarineTeam:SpawnWarmUpStructures()

    local techPoint = self.startTechPoint

    if not (Shared.GetCheatsEnabled() and MarineTeam.gSandboxMode) and #self.warmupStructures == 0 then
        self.warmupStructures[#self.warmupStructures + 1] = CreateTechEntity(techPoint, kTechId.Observatory, -3.5, 2, kMarineTeamType)
    end

end

function MarineTeam:SpawnInitialStructures(techPoint)

    self.startTechPoint = techPoint

    local tower, commandStation = PlayingTeam.SpawnInitialStructures(self, techPoint)

    local marineSpawnPointCount = kMinMarineSpawnPoints
    if self:GetNumPlayers() > kMarineSpawnAdjustmentThreshold then
        marineSpawnPointCount = marineSpawnPointCount + 1
    end

    -- Create initial spawn points
    for i = 1, marineSpawnPointCount do
        CreateSpawnPoint(self, techPoint)
    end

    -- Spawn an armory at start
    local forwardOffset = 2
    if math.random() < 0.5 then
        forwardOffset = -2
    end

    CreateTechEntity(techPoint, kTechId.Armory, 3.5, forwardOffset, kMarineTeamType)

    if Shared.GetCheatsEnabled() and MarineTeam.gSandboxMode then
        CreateTechEntity(techPoint, kTechId.Observatory, -3.5, forwardOffset * -1, kMarineTeamType)
    end

    return tower, commandStation

end
