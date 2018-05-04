--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Makes ajustments to the alien team.
 *
 * Overriden Functions:
 *  'AlienTeam:SpawnWarmUpStructures' - Spawns a Crag and a Shade during warmup mode.
 *  'AlienTeam:SpawnInitialStructures' - Spawns the initial set of structures for the team.
]]

function AlienTeam:SpawnWarmUpStructures()

    local techPoint = self.startTechPoint

    if not Shared.GetCheatsEnabled() and #self.warmupStructures == 0 then
        self.warmupStructures[#self.warmupStructures + 1] = CreateTechEntity(techPoint, kTechId.Crag, 3.5, -2, kAlienTeamType)
        self.warmupStructures[#self.warmupStructures + 1] = CreateTechEntity(techPoint, kTechId.Shade, -3.5, 2, kAlienTeamType)
    end

end

-- Copied because it's local and called from 'AlienTeam:SpawnInitialStructures'
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
