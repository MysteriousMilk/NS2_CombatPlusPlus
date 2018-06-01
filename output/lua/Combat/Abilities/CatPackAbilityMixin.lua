
CatPackAbilityMixin = CreateMixin(CatPackAbilityMixin)
CatPackAbilityMixin.type = "CatPackAbility"

local kUseSound = PrecacheAsset("sound/NS2.fev/marine/common/catalyst")

CatPackAbilityMixin.networkVars =
{
    timeLastCatPackUsed = "time",
    catPackAbilityEnabled = "boolean"
}

function CatPackAbilityMixin:__initmixin()

    self.timeLastCatPackUsed = 0
    self.catPackAbilityEnabled = false

end

function CatPackAbilityMixin:GetIsCatPackAbilityEnabled()
    return self.catPackAbilityEnabled
end

function CatPackAbilityMixin:SetIsCatPackAbilityEnabled(isEnabled)
    self.catPackAbilityEnabled = isEnabled
end

local function GetRemainingCooldownTime(self)

    if self.timeLastCatPackUsed == 0 then
        return 0
    end

    return math.max(0, self.timeLastCatPackUsed + kCatPackAbilityCooldown - Shared.GetTime())

end

function CatPackAbilityMixin:CanApplyCatPack()

    if Server then

        if not self:isa("Marine") then
            return false
        end

        local coolDownTime = GetRemainingCooldownTime(self)
        local alive = self:GetIsAlive()
        local vortexed = GetIsVortexed()
        local hasAbility = self.UpgradeManager:GetTree():GetIsPurchased(kTechId.CatPack)
        local canUse = self.GetCanUseCatPack and self:GetCanUseCatPack()

        return hasAbility and canUse and self.catPackAbilityEnabled and coolDownTime == 0 and alive and not vortexed

    end

end

-- have to use the word "Catalyst" here because Marine already has
-- function called "ApplyCatPack"
function CatPackAbilityMixin:ApplyCatalystPack()

    if Server then

        if not self:isa("Marine") then
            return false
        end

        StartSoundEffectAtOrigin(kUseSound, self:GetOrigin())
        self:ApplyCatPack()
        self.timeLastCatPackUsed = Shared.GetTime()

    end

end

function CatPackAbilityMixin:GetCatPackCooldownFraction()

    local timeRemaining = GetRemainingCooldownTime(self)
    return ConditionalValue(timeRemaining > 0, timeRemaining / kCatPackAbilityCooldown, 0)

end
