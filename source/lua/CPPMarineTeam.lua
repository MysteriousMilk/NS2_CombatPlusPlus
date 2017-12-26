function MarineTeam:GetHasAbilityToRespawn()
    return true
end

function MarineTeam:GetTotalInRespawnQueue()

    local queueSize = #self.respawnQueue
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

-- local used in Update()
local function GetArmorLevel(self)

    local armorLevels = 0

    local techTree = self:GetTechTree()
    if techTree then

        if techTree:GetHasTech(kTechId.Armor3) then
            armorLevels = 3
        elseif techTree:GetHasTech(kTechId.Armor2) then
            armorLevels = 2
        elseif techTree:GetHasTech(kTechId.Armor1) then
            armorLevels = 1
        end

    end

    return armorLevels

end

-- remove no-ip check
function MarineTeam:Update(timePassed)

    PROFILE("MarineTeam:Update")

    PlayingTeam.Update(self, timePassed)

    -- Update distress beacon mask
    self:UpdateGameMasks(timePassed)

    local armorLevel = GetArmorLevel(self)
    for index, player in ipairs(GetEntitiesForTeam("Player", self:GetTeamNumber())) do
        player:UpdateArmorAmount(armorLevel)
    end

end

function MakeTechEnt( techPoint, mapName, rightOffset, forwardOffset, teamType )
    local origin = techPoint:GetOrigin() + Vector(0, 2, 0)
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

function MarineTeam:SpawnWarmUpStructures()
    local techPoint = self.startTechPoint
    if not (Shared.GetCheatsEnabled() and MarineTeam.gSandboxMode) and #self.warmupStructures == 0 then
        --self.warmupStructures[#self.warmupStructures+1] = MakeTechEnt(techPoint, AdvancedArmory.kMapName, 3.5, -2, kMarineTeamType)
        self.warmupStructures[#self.warmupStructures+1] = MakeTechEnt(techPoint, Observatory.kMapName, -3.5, 2, kMarineTeamType)
    end
end

function MarineTeam:SpawnInitialStructures(techPoint)

    self.startTechPoint = techPoint

    local tower, commandStation = PlayingTeam.SpawnInitialStructures(self, techPoint)

    -- Spawn an armory at start
    local forwardOffset = 2
    if math.random() < 0.5 then
        forwardOffset = -2
    end

    MakeTechEnt(techPoint, AdvancedArmory.kMapName, 3.5, forwardOffset, kMarineTeamType)

    if Shared.GetCheatsEnabled() and MarineTeam.gSandboxMode then
        MakeTechEnt(techPoint, AdvancedArmory.kMapName, 3.5, -2, kMarineTeamType)
        MakeTechEnt(techPoint, PrototypeLab.kMapName, -3.5, 2, kMarineTeamType)
    end

    return tower, commandStation

end
