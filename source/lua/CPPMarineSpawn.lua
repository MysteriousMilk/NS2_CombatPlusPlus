--[[
 * Natural Selection 2 - Combat++ Mod
 * Created by: WhiteWizard
 *
 * This class provides a spawn queue for Marines (replacing IPs) SetCameraDistance
 * Combat++ does not use Infantry Portals to spawn marines.
 *
 * Uses a lot of the logic from lua/InfantryPortal.lua
]]

Script.Load("lua/LiveMixin.lua")
Script.Load("lua/TeamMixin.lua")
Script.Load("lua/EntityChangeMixin.lua")

Script.Load("lua/ScriptActor.lua")
Script.Load("lua/OrdersMixin.lua")
Script.Load("lua/PowerConsumerMixin.lua")

class 'CPPMarineSpawn' (ScriptActor)

CPPMarineSpawn.kMapName = "cpp_marine_spawn"

local kHoloMarineModel = PrecacheAsset("models/marine/male/male_spawn.model")
local kHoloMarineMaterialname = PrecacheAsset("cinematics/vfx_materials/marine_ip_spawn.material")

if Client then
    PrecacheAsset("cinematics/vfx_materials/marine_ip_spawn.surface_shader")
end

local kUpdateRate = 0.25
local kPushRange = 3
local kPushImpulseStrength = 40

local networkVars =
{
    queuedPlayerId = "entityid",
    queuedPlayerStartTime = "time",
}

AddMixinNetworkVars(LiveMixin, networkVars)
AddMixinNetworkVars(TeamMixin, networkVars)
AddMixinNetworkVars(OrdersMixin, networkVars)
AddMixinNetworkVars(PowerConsumerMixin, networkVars)

local function CreateSpawnEffect(self)

    if not self.fakeMarineModel and not self.fakeMarineMaterial then

        self.fakeMarineModel = Client.CreateRenderModel(RenderScene.Zone_Default)
        self.fakeMarineModel:SetModel(Shared.GetModelIndex(kHoloMarineModel))

        self.fakeMarineModel:SetCoords(self:GetCoords())
        self.fakeMarineModel:InstanceMaterials()
        self.fakeMarineModel:SetMaterialParameter("hiddenAmount", 1.0)

        self.fakeMarineMaterial = AddMaterial(self.fakeMarineModel, kHoloMarineMaterialname)

    end

    if self.clientQueuedPlayerId ~= self.queuedPlayerId then
        self.timeSpinStarted = self.queuedPlayerStartTime or Shared.GetTime()
        self.clientQueuedPlayerId = self.queuedPlayerId
    end

    local spawnProgress = Clamp((Shared.GetTime() - self.timeSpinStarted) / kMarineRespawnTime, 0, 1)

    self.fakeMarineModel:SetIsVisible(true)
    self.fakeMarineMaterial:SetParameter("spawnProgress", spawnProgress+0.2)    -- Add a little so it always fills up

end

local function DestroySpawnEffect(self)

  if self.fakeMarineModel then
      self.fakeMarineModel:SetIsVisible(false)
  end

end

function CPPMarineSpawn:OnCreate()

    ScriptActor.OnCreate(self)

    InitMixin(self, LiveMixin)
    InitMixin(self, TeamMixin)
    InitMixin(self, EntityChangeMixin)
    InitMixin(self, OrdersMixin, { kMoveOrderCompleteDistance = kAIMoveOrderCompleteDistance })
    InitMixin(self, PowerConsumerMixin)

    if Server then
        self.timeLastPush = 0
    end

    self.queuedPlayerId = Entity.invalidId

end

local function StopSpawning(self)
    self.timeSpinUpStarted = nil
end

local function PushPlayers(self)

    for _, player in ipairs(GetEntitiesWithinRange("Player", self:GetOrigin(), 0.5)) do

        if player:GetIsAlive() and HasMixin(player, "Controller") then

            player:DisableGroundMove(0.1)
            player:SetVelocity(Vector(GetSign(math.random() - 0.5) * 2, 3, GetSign(math.random() - 0.5) * 2))

        end

    end

end

local function MarineSpawnUpdate(self)

    self:FillQueueIfFree()

    if self:GetIsPowered() then

        local remainingSpawnTime = self:GetSpawnTime()
        if self.queuedPlayerId ~= Entity.invalidId then

            local queuedPlayer = Shared.GetEntity(self.queuedPlayerId)
            if queuedPlayer then

                remainingSpawnTime = math.max(0, self.queuedPlayerStartTime + self:GetSpawnTime() - Shared.GetTime())

                if remainingSpawnTime < 0.3 and self.timeLastPush + 0.5 < Shared.GetTime() then

                    PushPlayers(self)
                    self.timeLastPush = Shared.GetTime()

                end

            else

                self.queuedPlayerId = nil
                self.queuedPlayerStartTime = nil

            end

        end

        if remainingSpawnTime == 0 then
            self:FinishSpawn()
        end

    end

    return true

end

function CPPMarineSpawn:OnInitialized()

    ScriptActor.OnInitialized(self)

    if Server then

        self:AddTimedCallback(MarineSpawnUpdate, kUpdateRate)

        -- Point it towards the command station
        local lookAtPoint = self:GetTeam():GetInitialTechPoint():GetOrigin() + Vector(0, 5, 0)
        local toTechPoint = GetNormalizedVector(lookAtPoint - self:GetOrigin())

        self:SetAngles(Angles(0, GetYawFromVector(toTechPoint), 0))

    end

end

function CPPMarineSpawn:OnDestroy()

    ScriptActor.OnDestroy(self)

    if Client then

        DestroySpawnEffect(self)

        if self.fakeMarineModel then

            Client.DestroyRenderModel(self.fakeMarineModel)
            self.fakeMarineModel = nil
            self.fakeMarineModel = nil

        end

    end

end

function CPPMarineSpawn:GetRequiresPower()
    return true
end

local function QueueWaitingPlayer(self)

    if self.queuedPlayerId == Entity.invalidId then

        -- Remove player from team spawn queue and add here
        local team = self:GetTeam()
        local playerToSpawn = team:GetOldestQueuedPlayer()

        if playerToSpawn ~= nil then

            playerToSpawn:SetIsRespawning(true)
            team:RemovePlayerFromRespawnQueue(playerToSpawn)

            self.queuedPlayerId = playerToSpawn:GetId()
            self.queuedPlayerStartTime = Shared.GetTime()

            self:StartSpawning()

            SendPlayersMessage({ playerToSpawn }, kTeamMessageTypes.Spawning)

            if Server then

                if playerToSpawn.SetSpectatorMode then
                    playerToSpawn:SetSpectatorMode(kSpectatorMode.Following)
                end

                playerToSpawn:SetFollowTarget(self)

            end

        end

    end

end

function CPPMarineSpawn:GetSpawnTime()
    return kMarineRespawnTime
end

local function SpawnPlayer(self)

    if self.queuedPlayerId ~= Entity.invalidId then

        local queuedPlayer = Shared.GetEntity(self.queuedPlayerId)
        local team = queuedPlayer:GetTeam()

        local success, player = team:ReplaceRespawnPlayer(queuedPlayer, self:GetOrigin(), queuedPlayer:GetAngles())
        if success then

            local weapon = player:GetWeapon(Rifle.kMapName)
            if weapon then
                weapon.deployed = true -- start the rifle already deployed
                weapon.skipDraw = true
            end

            player:SetCameraDistance(0)

            if HasMixin( player, "Controller" ) and HasMixin( player, "AFKMixin" ) then

                if player:GetAFKTime() > self:GetSpawnTime() - 1 then

                    player:DisableGroundMove(0.1)
                    player:SetVelocity( Vector( GetSign( math.random() - 0.5) * 2.25, 3, GetSign( math.random() - 0.5 ) * 2.25 ) )

                end

            end

            self.queuedPlayerId = Entity.invalidId
            self.queuedPlayerStartTime = nil

            player:ProcessRallyOrder(self)

            return true

        else
            Print("Warning: MarineSpawn failed to spawn the player")
        end

    end

    return false

end

-- Takes the queued player from this MarineSpawn and places them back in the
-- respawn queue to be spawned elsewhere.
function CPPMarineSpawn:RequeuePlayer()

    if self.queuedPlayerId ~= Entity.invalidId then

        local player = Shared.GetEntity(self.queuedPlayerId)
        local team = self:GetTeam()
        if team then
            team:PutPlayerInRespawnQueue(Shared.GetEntity(self.queuedPlayerId))
        end
        player:SetIsRespawning(false)
        player:SetSpectatorMode(kSpectatorMode.Following)

    end

    -- Don't spawn player.
    self.queuedPlayerId = Entity.invalidId
    self.queuedPlayerStartTime = nil

end

if Server then

    function CPPMarineSpawn:OnEntityChange(entityId, newEntityId)

      if self.queuedPlayerId == entityId then

          -- Player left or was replaced, either way
          -- they're not in the queue anymore
          self.queuedPlayerId = Entity.invalidId
          self.queuedPlayerStartTime = nil

      end

    end

    function CPPMarineSpawn:GetCanTakeDamageOverride()
        return false
    end

    function CPPMarineSpawn:GetCanDieOverride()
        return false
    end

    function CPPMarineSpawn:FillQueueIfFree()

        local gameInfo = GetGameInfoEntity()
        if gameInfo and not gameInfo:GetWarmUpActive() and self:GetIsPowered() then

            if self.queuedPlayerId == Entity.invalidId then
                QueueWaitingPlayer(self)
            end

        end

    end

    function CPPMarineSpawn:FinishSpawn()

        SpawnPlayer(self)
        self.timeSpinUpStarted = nil

    end

end

function CPPMarineSpawn:StartSpawning()

  if self.timeSpinUpStarted == nil then
      self.timeSpinUpStarted = Shared.GetTime()
  end

end

function CPPMarineSpawn:OnPowerOn()

    if self.queuedPlayerId ~= Entity.invalidId then

        local queuedPlayer = Shared.GetEntity(self.queuedPlayerId)
        if queuedPlayer then

            queuedPlayer:SetRespawnQueueEntryTime(Shared.GetTime())
            self:StartSpawning()

        end

    end

end

function CPPMarineSpawn:OnPowerOff()

    -- Put the player back in queue if there was one hoping to spawn at this IP.
    StopSpawning(self)
    self:RequeuePlayer()

end

if Client then

    function CPPMarineSpawn:OnUpdate(deltaTime)

      PROFILE("CPPMarineSpawn:OnUpdate")

      ScriptActor.OnUpdate(self, deltaTime)

      local showSpawnEffect = self:GetIsPowered() and self.queuedPlayerId ~= Entity.invalidId

      if showSpawnEffect then
          CreateSpawnEffect(self)
      else
          DestroySpawnEffect(self)
      end

    end

end

Shared.LinkClassToMap("CPPMarineSpawn", CPPMarineSpawn.kMapName, networkVars, true)
