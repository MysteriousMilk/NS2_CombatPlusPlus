
MedPackCooldownMixin = CreateMixin(MedPackCooldownMixin)
MedPackCooldownMixin.type = "MedPackCooldown"

local kHealthSound = PrecacheAsset("sound/NS2.fev/marine/common/health")

MedPackCooldownMixin.networkVars =
{
    timeLastUsed = "time"
}

function MedPackCooldownMixin:__initmixin()

    self.timeLastMedPackUsed = Shared.GetTime()
    self.coolDownLength = 0
    self.medPackHealth = kMedpackHeal

end

function MedPackCooldownMixin:CanApplyMedPack()

    if not self:isa("Marine") then
        return false
    end

    if (Shared.GetTime() - self.timeLastMedPackUsed) < self.coolDownLength then
        return false
    end

    return self:GetIsAlive() and not GetIsVortexed() and self:GetHealth() < self:GetMaxHealth()

end

function MedPackCooldown:ApplyMedPack()

    self:AddHealth(self.timeLastMedPackUsed, false, true)
    self:AddRegeneration()
    self.timeLastMedPackUsed = Shared.GetTime()
    StartSoundEffectAtOrigin(kHealthSound, self:GetOrigin())

end
