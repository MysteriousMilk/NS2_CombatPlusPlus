
ScanAbilityMixin = CreateMixin(ScanAbilityMixin)
ScanAbilityMixin.type = "ScanAbility"

ScanAbilityMixin.networkVars =
{
    timeLastScanUsed = "time"
}

function ScanAbilityMixin:__initmixin()

    self.timeLastScankUsed = 0
    self.scanPosition = nil

end

local function GetRemainingCooldownTime(self)

    if self.timeLastScanUsed == 0 then
        return 0
    end

    return math.max(0, self.timeLastScanUsed + kScanAbilityCooldown - Shared.GetTime())

end

function ScanAbilityMixin:CanApplyScan()

    if Server then

        if self:isa("Marine") or self:isa("Exo") then

            local startPoint = self:GetOrigin()
            local directionVec = Vector(0, -1, 0)
            local endPoint = startPoint + directionVec * 1000
            self.scanPosition = nil

            local trace = Shared.TraceRay(startPoint, endPoint, CollisionRep.Select, PhysicsMask.CommanderSelect, EntityFilterAll() or EntityFilterOne(self))

            if trace.fraction < 1 then
                self.scanPosition = trace.endPoint
            end

            local coolDownTime = GetRemainingCooldownTime(self)
            local alive = self:GetIsAlive()
            local vortexed = GetIsVortexed()
            local hasAbility = self.GetHasUpgrade and self:GetHasUpgrade(kTechId.Scan)

            return hasAbility and self.scanPosition ~= nil and coolDownTime == 0 and alive and not vortexed

        else
            return false
        end

    end

end

function ScanAbilityMixin:ApplyScan()

    if Server then

        if self:isa("Marine") or self:isa("Exo") then

            if self.scanPosition ~= nil then

                CreateEntity(Scan.kMapName, self.scanPosition, self:GetTeamNumber())
                self.timeLastScanUsed = Shared.GetTime()
                self.scanPosition = nil

            end

        end

    end

end

function ScanAbilityMixin:GetScanCooldownFraction()

    local timeRemaining = GetRemainingCooldownTime(self)
    return ConditionalValue(timeRemaining > 0, timeRemaining / kScanAbilityCooldown, 0)

end
