--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Some marine spawn code, and initial structure placement.
]]

MarineTeam.kSpawnArmoryMaxRetries = 200
MarineTeam.kArmorySpawnMinDistance = 6
MarineTeam.kArmorySpawnMaxDistance = 60

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

    -- Check if there is already an Armory
	if #GetEntitiesForTeam("Armory", self:GetTeamNumber()) == 0 then	

        -- spawn initial Armory for marine team    
        local techPointOrigin = techPoint:GetOrigin() + Vector(0, 2, 0)
        
        for i = 1, MarineTeam.kSpawnArmoryMaxRetries do

            -- Increase the spawn distance on a gradual basis.
            local origin = CalculateRandomSpawn(nil, techPointOrigin, kTechId.Armory, true, MarineTeam.kArmorySpawnMinDistance, (MarineTeam.kArmorySpawnMaxDistance * i / MarineTeam.kSpawnArmoryMaxRetries), nil)

            if origin then

                local armory = CreateEntity(Armory.kMapName, origin - Vector(0, 0.1, 0), self:GetTeamNumber())
                
                SetRandomOrientation(armory)
                armory:SetConstructionComplete()
                break

            end

        end

    end

    return tower, commandStation

end
