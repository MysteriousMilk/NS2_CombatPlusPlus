--[[
 * Natural Selection 2 - Combat++ Mod
 * Created by: WhiteWizard
 *
 * This class provides a spawn queue for Marines (replacing IPs) SetCameraDistance
 * Combat++ does not use Infantry Portals to spawn marines.
 *
 * Uses a lot of the logic from lua/InfantryPortal.lua
]]

Script.Load("lua/Mixins/ModelMixin.lua")
Script.Load("lua/LOSMixin.lua")
Script.Load("lua/TeamMixin.lua")
Script.Load("lua/EntityChangeMixin.lua")
Script.Load("lua/Entity.lua")

class 'CPPMarineSpawn' (ScriptActor)

CPPMarineSpawn.kMapName = "cpp_marine_spawn"
CPPMarineSpawn.kModelName = PrecacheAsset("models/marine/male/male_spawn.model")
CPPMarineSpawn.kHoloMarineMaterial = PrecacheAsset("cinematics/vfx_materials/marine_ip_spawn.material")

local kUpdateRate = 0.25

local networkVars =
{
    queuedPlayerId = "entityid",
    queuedPlayerStartTime = "time",
}

AddMixinNetworkVars(BaseModelMixin, networkVars)
AddMixinNetworkVars(ModelMixin, networkVars)
AddMixinNetworkVars(TeamMixin, networkVars)
AddMixinNetworkVars(LOSMixin, networkVars)

function CPPMarineSpawn:OnCreate()

    ScriptActor.OnCreate(self)

    InitMixin(self, BaseModelMixin)
    InitMixin(self, ModelMixin)
    InitMixin(self, TeamMixin)
    InitMixin(self, EntityChangeMixin)
    InitMixin(self, LOSMixin)

    self.queuedPlayerId = Entity.invalidId

    self:SetLagCompensated(true)
    self:SetPhysicsType(PhysicsType.Kinematic)
    self:SetPhysicsGroup(PhysicsGroup.MediumStructuresGroup)

end

function CPPMarineSpawn:OnInitialized()

    ScriptActor.OnInitialized(self)

    self:SetModel(CPPMarineSpawn.kModelName)

    --if Server then
    --  self:AddTimedCallback(MarineSpawnUpdate, kUpdateRate)
    if Client then
      self:GetRenderModel():InstanceMaterials()
      self:GetRenderModel():SetMaterialParameter("hiddenAmount", 1.0)
      AddMaterial(self:GetRenderModel(), CPPMarineSpawn.kHoloMarineMaterial)
    end

end

local function MarineSpawnUpdate(self)
end

Shared.LinkClassToMap("CPPMarineSpawn", CPPMarineSpawn.kMapName, networkVars, true)
