
AmmoPackAbilityMixin = CreateMixin(AmmoPackAbilityMixin)
AmmoPackAbilityMixin.type = "AmmoPackAbility"

local kUseSound = PrecacheAsset("sound/NS2.fev/marine/common/pickup_ammo")

AmmoPackAbilityMixin.networkVars =
{
    timeLastAmmoPackUsed = "time",
    ammoPackAbilityEnabled = "boolean"
}

function AmmoPackAbilityMixin:__initmixin()

    self.timeLastAmmoPackUsed = 0
    self.ammoPackAbilityEnabled = false

end

function AmmoPackAbilityMixin:GetIsAmmoPackAbilityEnabled()
    return self.ammoPackAbilityEnabled
end

function AmmoPackAbilityMixin:SetIsAmmoPackAbilityEnabled(isEnabled)
    self.ammoPackAbilityEnabled = isEnabled
end

local function GetRemainingCooldownTime(self)

    if self.timeLastAmmoPackUsed == 0 then
        return 0
    end

    return math.max(0, self.timeLastAmmoPackUsed + kAmmoPackAbilityCooldown - Shared.GetTime())

end

local function CheckNeedsAmmo(self)

    local needsAmmo = false

    if self:isa("Marine") then

        for i = 0, self:GetNumChildren() - 1 do

            local child = self:GetChildAtIndex(i)
            if child:isa("ClipWeapon") and child:GetNeedsAmmo(false) then

                needsAmmo = true
                break

            end

        end

    end

    return needsAmmo

end

function AmmoPackAbilityMixin:CanApplyAmmoPack()

    if Server then

        if not self:isa("Marine") then
            return false
        end

        local coolDownTime = GetRemainingCooldownTime(self)
        local alive = self:GetIsAlive()
        local vortexed = GetIsVortexed()
        local hasAbility = self.UpgradeManager:GetTree():GetIsPurchased(kTechId.AmmoPack)
        local needsAmmo = CheckNeedsAmmo(self)

        return hasAbility and self.ammoPackAbilityEnabled and coolDownTime == 0 and alive and not vortexed and needsAmmo

    end

end

function AmmoPackAbilityMixin:ApplyAmmoPack()

    local consumedPack = false
    local emptyClip = false

    if self:isa("Marine") then

        for i = 0, self:GetNumChildren() - 1 do

            local child = self:GetChildAtIndex(i)

            if child:isa("ClipWeapon") then

                if child:GetAmmo() == 0 then
                    emptyClip = true
                end

                if child:GiveAmmo(AmmoPack.kNumClips, false) then
                    consumedPack = true
                end

            end

        end

        if consumedPack then

            self.timeLastAmmoPackUsed = Shared.GetTime()
            StartSoundEffectAtOrigin(kUseSound, self:GetOrigin())

            if emptyClip then
                self:Reload()
            end

        end

    end

end

function AmmoPackAbilityMixin:GetAmmoPackCooldownFraction()

    local timeRemaining = GetRemainingCooldownTime(self)
    return ConditionalValue(timeRemaining > 0, timeRemaining / kAmmoPackAbilityCooldown, 0)

end
