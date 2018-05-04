--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Modified the builder ability to have a 'Create' mode.
 *
 * Wrapped Functions:
 *  'Builder:OnInitialized' - Initialize the new variables.
 *  'Builder:OnHolster' - Put the builder ability back in 'Build' mode when holstered.
 *
 * Overriden Functions:
 *  'Builder:OnPrimaryAttack' - Player uses primary attack to place structures.
 *  'Builder:OnPrimaryAttackEnd' - Set builder ability back to 'Build' mode after a structure is placed.
]]

local networkVarsEx =
{
    buildMode = "enum kBuilderMode"
}

local kPlacementDistance = 2.5

local ns2_Builder_OnInitialized = Builder.OnInitialized
function Builder:OnInitialized()

    ns2_Builder_OnInitialized(self)

    self.buildMode = kBuilderMode.Build
    self.createdSuccessfully = false

end

local ns2_Builder_OnHolster = Builder.OnHolster
function Builder:OnHolster(player)

    ns2_Builder_OnHolster(self, player)

    -- always reset to build mode when holstered
    self.buildMode = kBuilderMode.Build

end

function Builder:GetBuilderMode()

    return self.buildMode

end

function Builder:SetBuilderMode(buildMode)

    self.buildMode = buildMode

end

function Builder:OnPrimaryAttack(player)

    if player:GetPrimaryAttackLastFrame() then
        return
    end

    if self.buildMode == kBuilderMode.Create then

        -- Ensure the current location is valid for placement.
        local showGhost, coords, valid = self:GetPositionForStructure(player)
        if valid then

            if player:GetCreateStructureTechId() ~= kTechId.None then

                if self:PerformPrimaryAttack(player) then

                    self.createdSuccessfully = true
                    player:OnStructureCreated()
                    self:OnHolster(player)
                    player:SwitchWeapon(1)

                end

            else

                if Client then
                    player:TriggerInvalidSound()
                end

            end

        else

            if Client then
                player:TriggerInvalidSound()
            end

        end

    end

end

function Builder:OnPrimaryAttackEnd(player)

    if self.createdSuccessfully == true then

        self.buildMode = kBuilderMode.Build

    end

end

local kExtents = Vector(0.4, 0.5, 0.4) -- 0.5 to account for pathing being too high/too low making it hard to palce tunnels
local function IsPathable(position)

    local noBuild = Pathing.GetIsFlagSet(position, kExtents, Pathing.PolyFlag_NoBuild)
    local walk = Pathing.GetIsFlagSet(position, kExtents, Pathing.PolyFlag_Walk)
    return not noBuild and walk

end

local function DropStructure(self, player)

    if Server then

        local showGhost, coords, valid = self:GetPositionForStructure(player)
        if valid then

            -- Create structure
            local techId = player:GetCreateStructureTechId()
            local mapName = LookupTechData(techId, kTechDataMapName)
            local struct = CreateEntity(mapName, coords.origin, player:GetTeamNumber())
            if struct then

                struct:SetOwner(player)

                -- Check for space
                if struct:SpaceClearForEntity(coords.origin) then

                    local angles = Angles()
                    angles:BuildFromCoords(coords)
                    struct:SetAngles(angles)

                    -- start unconstructed
                    if HasMixin(struct, "Construct") then
                        struct:ResetConstructionStatus()
                    end

                    struct:TriggerEffects("spawn")

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

function Builder:PerformPrimaryAttack(player)

    local success = true

    if player:GetCreateStructureTechId() ~= kTechId.None then

        local viewAngles = player:GetViewAngles()
        local viewCoords = viewAngles:GetCoords()

        success = DropStructure(self, player)

    end

    return success

end

-- Given a gorge player's position and view angles, return a position and orientation
-- for structure. Used to preview placement via a ghost structure and then to create it.
-- Also returns bool if it's a valid position or not.
function Builder:GetPositionForStructure(player)

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

        if not IsPathable(displayOrigin) and trace.surface ~= "tunnel_allowed" then
            isPositionValid = false
        end

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

function Builder:GetGhostModelName()
    local player = self:GetParent()
    return LookupTechData(player:GetCreateStructureTechId(), kTechDataModel)
end

if Client then

    function Builder:OnProcessIntermediate(input)

        if self.buildMode == kBuilderMode.Create then

            local player = self:GetParent()

            if player then

                self.showGhost, self.ghostCoords, self.placementValid = self:GetPositionForStructure(player)
                self.showGhost = self.showGhost and player:GetCreateStructureTechId() ~= kTechId.None

            end

        end

    end

end

function Builder:GetShowGhostModel()
    return self.buildMode == kBuilderMode.Create and self.showGhost
end

function Builder:GetGhostModelCoords()
    return self.ghostCoords
end

function Builder:GetIsPlacementValid()
    return self.buildMode == kBuilderMode.Create and self.placementValid
end

Shared.LinkClassToMap("Builder", Builder.kMapName, networkVarsEx)
