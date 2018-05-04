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

Script.Load("lua/Abilities/MedPackAbilityMixin.lua")
Script.Load("lua/Abilities/AmmoPackAbilityMixin.lua")
Script.Load("lua/Abilities/CatPackAbilityMixin.lua")
Script.Load("lua/Abilities/ScanAbilityMixin.lua")

local networkVarsEx =
{
    armorLevel = "integer",
    weaponLevel = "integer",
}

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

    if Server then
        self.UpgradeManager = MarineUpgradeManager()
    end

    ns2_Marine_OnCreate(self)

end

local ns2_Marine_OnInitialized = Marine.OnInitialized
function Marine:OnInitialized()

    ns2_Marine_OnInitialized(self)

    self.armorLevel = 0
    self.weaponLevel = 0

end

function Marine:GetArmorLevel()
    return self.armorLevel
end

function Marine:GetWeaponLevel()
    return self.weaponLevel
end

function Marine:SetArmorLevel(level)
    self.armorLevel = Clamp(level, 0, 3)
end

function Marine:SetArmorLevelByTechId(techId)

    if techId == kTechId.Armor1 then
        self:SetArmorLevel(1)
    elseif techId == kTechId.Armor2 then
        self:SetArmorLevel(2)
    elseif techId == kTechId.Armor3 then
        self:SetArmorLevel(3)
    else
        self:SetArmorLevel(0)
    end

end

function Marine:SetWeaponLevel(level)
    self.weaponLevel = Clamp(level, 0, 3)
end

function Marine:SetWeaponLevelByTechId(techId)

    if techId == kTechId.Weapons1 then
        self:SetWeaponLevel(1)
    elseif techId == kTechId.Weapons2 then
        self:SetWeaponLevel(2)
    elseif techId == kTechId.Weapons3 then
        self:SetWeaponLevel(3)
    else
        self:SetWeaponLevel(0)
    end

end

function Marine:GetArmorAmount(armorLevels)

    if not armorLevels then
        armorLevels = self:GetWeaponLevel()
    end

    return Marine.kBaseArmor + armorLevels * Marine.kArmorPerUpgradeLevel

end

Shared.LinkClassToMap("Marine", Marine.kMapName, networkVarsEx, true)
