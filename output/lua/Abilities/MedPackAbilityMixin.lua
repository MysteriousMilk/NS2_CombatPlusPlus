
MedPackAbilityMixin = CreateMixin(MedPackAbilityMixin)
MedPackAbilityMixin.type = "MedPackAbility"

local kHealthSound = PrecacheAsset("sound/NS2.fev/marine/common/health")

MedPackAbilityMixin.networkVars =
{
    timeLastMedPackUsed = "time",
    medPackAbilityEnabled = "boolean"
}

function MedPackAbilityMixin:__initmixin()

    self.medPackHealth = kMedpackHeal
    self.timeLastMedPackUsed = 0
    self.medPackAbilityEnabled = false

end

function MedPackAbilityMixin:GetIsMedPackAbilityEnabled()
    return self.medPackAbilityEnabled
end

function MedPackAbilityMixin:SetIsMedPackAbilityEnabled(isEnabled)
    self.medPackAbilityEnabled = isEnabled
end

local function GetRemainingCooldownTime(self)

    if self.timeLastMedPackUsed == 0 then
        return 0
    end

    return math.max(0, self.timeLastMedPackUsed + kMedPackAbilityCooldown - Shared.GetTime())

end

function MedPackAbilityMixin:CanApplyMedPack()

    if Server then

        if not self:isa("Marine") then
            return false
        end

        local coolDownTime = GetRemainingCooldownTime(self)
        local alive = self:GetIsAlive()
        local vortexed = GetIsVortexed()
        local hasAbility = self.UpgradeManager:GetTree():GetIsPurchased(kTechId.MedPack)

        return hasAbility and self.medPackAbilityEnabled and coolDownTime == 0 and alive and not vortexed and self:GetHealth() < self:GetMaxHealth()

    end

end

function MedPackAbilityMixin:ApplyMedPack()

    self:AddHealth(self.medPackHealth, false, true)
    self:AddRegeneration()
    self.timeLastMedPackUsed = Shared.GetTime()
    StartSoundEffectAtOrigin(kHealthSound, self:GetOrigin())

end

function MedPackAbilityMixin:GetMedPackCooldownFraction()

    local timeRemaining = GetRemainingCooldownTime(self)
    return ConditionalValue(timeRemaining > 0, timeRemaining / kMedPackAbilityCooldown, 0)

end
