--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Adds an Auto Cyst feature.
 *
 * Wrapped Functions:
 *  'Hive:OnUpdate' - Adds the Auto Cyst feature to the hive update loop.
]]

local function GetNearestResourcePointWithoutCyst(self)

    local rps = GetAvailableResourcePoints()
    local hives = GetEntitiesForTeam("Hive", kAlienTeamType)
    local dist, rp = GetMinTableEntry(rps, function(rp)

        local position = rp:GetOrigin()
        local cysts = position and GetEntitiesForTeamWithinRange("Cyst", self:GetTeamNumber(), position, kCystRedeployRange) or {}
        local cyst = #cysts > 0 and cysts[1]

        if (not cyst or not cyst:GetIsActuallyConnected()) and rp:GetLocationId() ~= self:GetLocationId() then
            return GetMinPathDistToEntities(rp, hives)
        end

        return nil

    end)

    return rp

end

local function GetDisconnectedCysts(self)

    local disconnectedCysts = {}

    for _, cyst in ipairs(GetEntitiesForTeam("Cyst", self:GetTeamNumber())) do

        if not cyst:GetIsConnected() then
            table.insert(disconnectedCysts, cyst)
        end

    end

    return disconnectedCysts

end

local function CreateCyst(self, point, normal)

    Shared.Message("Create Cyst.")

    local cyst = CreateEntity(Cyst.kMapName, point, self:GetTeamNumber())
    cyst:SetCoords(AlignCyst(Coords.GetTranslation(point), normal))

    cyst:SetImmuneToRedeploymentTime(0.05)

    if not cyst:GetIsConnected() then
        cyst:ChangeParent(parent)
    end

end

function Hive:CreateNextCyst()

    local disconnectedCysts = GetDisconnectedCysts(self)

    if disconnectedCysts and #disconnectedCysts > 0 then

        Shared.Message(string.format("Number of disconnected cysts: %s", #disconnectedCysts))
        local position = disconnectedCysts[1]:GetOrigin()
        local extents = GetExtents(kTechId.Cyst)

        -- Random spawn does not always succeed.. just brute force until we get a good spawn.
        for i = 1, 100 do

            local cystPos = GetRandomSpawnForCapsule(extents.y, extents.x, position + Vector(0,1,0), 1, 4, EntityFilterAll())

            if cystPos then

                local cystPoints, parent, normals = GetCystPoints(cystPos)

                if parent and #cystPoints > 0 and cystPoints[1] then
                    CreateCyst(self, cystPoints[1], normals[1])
                    break
                end

            end

        end

    else

        local rp = GetNearestResourcePointWithoutCyst(self)

        if not rp then return end

        Shared.Message(string.format("Cysting towards %s.", rp:GetLocationName()))

        local position = rp and rp:GetOrigin()
        local extents = GetExtents(kTechId.Cyst)

        -- Random spawn does not always succeed.. just brute force until we get a good spawn.
        for i = 1, 100 do

            local cystPos = GetRandomSpawnForCapsule(extents.y, extents.x, position + Vector(0,1,0), 1, 4, EntityFilterAll(), GetIsPointOffInfestation)

            local cystPoints, parent, normals = GetCystPoints(cystPos)

            if parent and #cystPoints > 0 and cystPoints[1] then
                CreateCyst(self, cystPoints[1], normals[1])
                break
            end

        end

    end

end

function Hive:AutoCyst()

    if Shared.GetTime() - self.timeLastCyst >= kHiveAutoCystFrequency then

        Shared.Message("AutoCyst timer expired.")
        self:CreateNextCyst()
        self.timeLastCyst = Shared.GetTime()

    end

end

local ns2_Hive_OnUpdate = Hive.OnUpdate
function Hive:OnUpdate(deltaTime)

    if self:GetIsAlive() then

        ns2_Hive_OnUpdate(self, deltaTime)

        if self:GetIsAlive() then
            self:AutoCyst()
        end

    else

        ns2_Hive_OnUpdate(self, deltaTime)

    end

end
