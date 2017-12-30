Script.Load("lua/Weapons/Weapon.lua")

class 'MarineDropStructureAbility' (Weapon)

local kDropCooldown = 1

MarineDropStructureAbility.kMapName = "marine_drop_structure_ability"

local kModelName = PrecacheAsset("models/marine/welder/builder.model")
local kViewModels = GenerateMarineViewModelPaths("welder")
local kAnimationGraph = PrecacheAsset("models/marine/welder/welder_view.animation_graph")

local networkVars =
{
    dropping = "boolean"
}

function MarineDropStructureAbility:OnCreate()

    Weapon.OnCreate(self)

    self.dropping = false

end

function MarineDropStructureAbility:OnInitialized()

    Weapon.OnInitialized(self)

    self:SetModel(kModelName)

end

function MarineDropStructureAbility:GetViewModelName(sex, variant)
    return kViewModels[sex][variant]
end

function MarineDropStructureAbility:GetAnimationGraphName()
    return kAnimationGraph
end

function MarineDropStructureAbility:GetIsDropping()
    return self.dropping
end

function MarineDropStructureAbility:GetHUDSlot()
    return -1
end

function MarineDropStructureAbility:OnPrimaryAttackEnd(player)
    self.dropping = false
end

function MarineDropStructureAbility:OnPrimaryAttack(player)

    -- Ensure the current location is valid for placement.
    if not player:GetPrimaryAttackLastFrame() then

        local showGhost, coords, valid = self:GetPositionForStructure(player)
        if valid then

            if player:GetCreateStructureTechId() ~= kTechId.None then

                if self:PerformPrimaryAttack(player) then
                    self.dropping = true
                    self:OnHolster(player)
                    player:SwitchWeapon(1)
                end

            else

                self.dropping = false

                if Client then
                    player:TriggerInvalidSound()
                end

            end

        else

            self.dropping = false

            if Client then
                player:TriggerInvalidSound()
            end

        end

    end

end

local function GetMapNameForTechId(techId)

    local mapName = ""

    if techId == kTechId.Observatory then
        mapName = Observatory.kMapName
    end

    return mapName

end

local function DropStructure(self, player)

    if Server then

        local showGhost, coords, valid = self:GetPositionForStructure(player)
        if valid then

            -- Create structure
            local mapName = GetMapNameForTechId(player:GetCreateStructureTechId())
            local struct = CreateEntity(mapName, coords.origin, player:GetTeamNumber())
            if struct then

                --mine:SetOwner(player)

                -- Check for space
                if struct:SpaceClearForEntity(coords.origin) then

                    local angles = Angles()
                    angles:BuildFromCoords(coords)
                    struct:SetAngles(angles)

                    -- start unconstructed
                    if HasMixin(struct, "Construct") then
                        struct:ResetConstructionStatus()
                    end

                    --player:TriggerEffects("create_" .. self:GetSuffixName())

                    -- Jackpot.
                    return true

                else

                    player:TriggerInvalidSound()
                    DestroyEntity(struct)

                end

            else
                player:TriggerInvalidSound()
            end

        else

            if not valid then
                player:TriggerInvalidSound()
            end

        end

    elseif Client then
        return true
    end

    return false

end

function MarineDropStructureAbility:PerformPrimaryAttack(player)

    local success = true

    if player:GetCreateStructureTechId() ~= kTechId.None then

        --player:TriggerEffects("start_create_" .. self:GetSuffixName())

        local viewAngles = player:GetViewAngles()
        local viewCoords = viewAngles:GetCoords()

        success = DropStructure(self, player)

    end

    return success

end

function MarineDropStructureAbility:OnHolster(player, previousWeaponMapName)

    Weapon.OnHolster(self, player, previousWeaponMapName)

    self.dropping = false

end

function MarineDropStructureAbility:OnDraw(player, previousWeaponMapName)

    Weapon.OnDraw(self, player, previousWeaponMapName)

    -- Attach weapon to parent's hand
    self:SetAttachPoint(Weapon.kHumanAttachPoint)

end

function MarineDropStructureAbility:UpdateViewModelPoseParameters(viewModel)
    viewModel:SetPoseParam("welder", 0)
end

function MarineDropStructureAbility:OnUpdateAnimationInput(modelMixin)

    PROFILE("Builder:OnUpdateAnimationInput")

    modelMixin:SetAnimationInput("activity", "primary")
    modelMixin:SetAnimationInput("welder", false)
    modelMixin:SetAnimationInput("needWelder", false)
    self:SetPoseParam("welder", 0)


end

-- Given a gorge player's position and view angles, return a position and orientation
-- for structure. Used to preview placement via a ghost structure and then to create it.
-- Also returns bool if it's a valid position or not.
function MarineDropStructureAbility:GetPositionForStructure(player)

    local isPositionValid = false
    local foundPositionInRange = false
    local structPosition

    local origin = player:GetEyePos() + player:GetViewAngles():GetCoords().zAxis * kPlacementDistance

    -- Commented out code enforces trace to always be to the ground.
    -- Trace short distance in front
    --local trace = Shared.TraceRay(player:GetEyePos(), origin, CollisionRep.Default, PhysicsMask.AllButPCsAndRagdolls, EntityFilterTwo(player, self))

    --local displayOrigin = trace.endPoint

    -- If we hit nothing, trace down to place on ground
    --if trace.fraction == 1 then

        origin = player:GetEyePos() + player:GetViewAngles():GetCoords().zAxis * kPlacementDistance
        trace = Shared.TraceRay(origin, origin - Vector(0, kPlacementDistance, 0), CollisionRep.Default, PhysicsMask.AllButPCsAndRagdolls, EntityFilterTwo(player, self))

    --end

    -- If it hits something, position on this surface (must be the world or another structure)
    if trace.fraction < 1 then

        foundPositionInRange = true

        if trace.entity == nil then
            isPositionValid = true
        elseif not trace.entity:isa("ScriptActor") and not trace.entity:isa("Clog") and not trace.entity:isa("Web") then
            isPositionValid = true
        end

        displayOrigin = trace.endPoint

        -- Can not be built on infestation
        if GetIsPointOnInfestation(displayOrigin) then
            isPositionValid = false
        end

        -- Don't allow dropped structures to go too close to techpoints and resource nozzles
        if GetPointBlocksAttachEntities(displayOrigin) then
            isPositionValid = false
        end

        if trace.surface == "nocling" then
            isPositionValid = false
        end

        -- Don't allow placing above or below us and don't draw either
        local structureFacing = player:GetViewAngles():GetCoords().zAxis

        if math.abs(Math.DotProduct(trace.normal, structureFacing)) > 0.9 then
            structureFacing = trace.normal:GetPerpendicular()
        end

        -- Coords.GetLookIn will prioritize the direction when constructing the coords,
        -- so make sure the facing direction is perpendicular to the normal so we get
        -- the correct y-axis.
        local perp = Math.CrossProduct(trace.normal, structureFacing)
        structureFacing = Math.CrossProduct(perp, trace.normal)

        structPosition = Coords.GetLookIn(displayOrigin, structureFacing, trace.normal)

    end

    return foundPositionInRange, structPosition, isPositionValid

end

function MarineDropStructureAbility:GetGhostModelName()
    local player = self:GetParent()
    return LookupTechData(player:GetCreateStructureTechId(), kTechDataModel)
end

if Client then

    function LayMines:OnProcessIntermediate(input)

        local player = self:GetParent()

        if player then

            self.showGhost, self.ghostCoords, self.placementValid = self:GetPositionForStructure(player)
            self.showGhost = self.showGhost and player:GetCreateStructureTechId() ~= kTechId.None

        end

    end

end

function MarineDropStructureAbility:GetShowGhostModel()
    return self.showGhost
end

function MarineDropStructureAbility:GetGhostModelCoords()
    return self.ghostCoords
end

function MarineDropStructureAbility:GetIsPlacementValid()
    return self.placementValid
end

Shared.LinkClassToMap("MarineDropStructureAbility", MarineDropStructureAbility.kMapName, networkVars)
