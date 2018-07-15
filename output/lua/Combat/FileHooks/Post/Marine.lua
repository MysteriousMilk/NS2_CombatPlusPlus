--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Add some additional capabilities to the Marine entity.
 *
 * Hooked Functions:
 *  'Marine:OnCreate' - Add some new ability mixins and create the Upgrade Manager.
 *  'Marine:OnInitialized' - Set the initial armor and weapon levels and initialize the Upgrade Manager.
]]

Script.Load("lua/Combat/Abilities/AmmoPackAbilityMixin.lua")
Script.Load("lua/Combat/Abilities/CatPackAbilityMixin.lua")
Script.Load("lua/Combat/Abilities/MedPackAbilityMixin.lua")
Script.Load("lua/Combat/Abilities/ScanAbilityMixin.lua")

local networkVarsEx = {}

AddMixinNetworkVars(MedPackAbilityMixin, networkVarsEx)
AddMixinNetworkVars(AmmoPackAbilityMixin, networkVarsEx)
AddMixinNetworkVars(CatPackAbilityMixin, networkVarsEx)
AddMixinNetworkVars(ScanAbilityMixin, networkVarsEx)

local ns2_Marine_OnCreate = Marine.OnCreate
function Marine:OnCreate()

    InitMixin(self, MedPackAbilityMixin)
    InitMixin(self, AmmoPackAbilityMixin)
    InitMixin(self, CatPackAbilityMixin)
    InitMixin(self, ScanAbilityMixin)

    ns2_Marine_OnCreate(self)

end

local ns2_Marine_OnInitialized = Marine.OnInitialized
function Marine:OnInitialized()

    ns2_Marine_OnInitialized(self)

end

-- Weapons can't be dropped anymore
function Marine:Drop()

    -- just do nothing

end

function Marine:GetArmorLevel()
    
    local armorLevel = 0

    if self:GetHasUpgrade(kTechId.Armor1) then
        armorLevel = 1
    elseif self:GetHasUpgrade(kTechId.Armor2) then
        armorLevel = 2
    elseif self:GetHasUpgrade(kTechId.Armor3) then
        armorLevel = 3
    end

    return armorLevel
    
end

function Marine:GetWeaponLevel()

    local wpnLevel = 0

    if self:GetHasUpgrade(kTechId.Weapons1) then
        wpnLevel = 1
    elseif self:GetHasUpgrade(kTechId.Weapons2) then
        wpnLevel = 2
    elseif self:GetHasUpgrade(kTechId.Weapons3) then
        wpnLevel = 3
    end

    return wpnLevel

end

function Marine:GetArmorAmount(armorLevels)

    if not armorLevels then
        armorLevels = self:GetWeaponLevel()
    end

    return Marine.kBaseArmor + armorLevels * Marine.kArmorPerUpgradeLevel

end

function Marine:OnLevelUp()

    self:TriggerEffects("infantry_portal_spawn")
    
end

Shared.LinkClassToMap("Marine", Marine.kMapName, networkVarsEx, true)
