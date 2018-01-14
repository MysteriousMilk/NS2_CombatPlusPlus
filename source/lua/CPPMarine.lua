Script.Load("lua/Abilities/MedPackAbilityMixin.lua")
Script.Load("lua/Abilities/AmmoPackAbilityMixin.lua")
Script.Load("lua/Abilities/CatPackAbilityMixin.lua")
Script.Load("lua/Abilities/ScanAbilityMixin.lua")

local networkVarsEx =
{
    armorLevel = "integer",
    weaponLevel = "integer",
    purchasedPistol = "boolean",
    purchasedWelder = "boolean"
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

    ns2_Marine_OnCreate(self)

end

local ns2_Marine_OnInitialized = Marine.OnInitialized
function Marine:OnInitialized()

    ns2_Marine_OnInitialized(self)

    self.armorLevel = 0
    self.weaponLevel = 0
    self.purchasedPistol = false
    self.purchasedWelder = false

end

function Marine:GetArmorLevel()
    return self.armorLevel
end

function Marine:GetWeaponLevel()
    return self.weaponLevel
end

function Marine:SetArmorLevel(level)

    self.armorLevel = Clamp(level, 0, 3)

    local userId = Server.GetOwner(self):GetUserId()
    GetGameMaster():GetMarinePersistData():UpdateArmorLevel(userId, self.armorLevel)

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

    local userId = Server.GetOwner(self):GetUserId()
    GetGameMaster():GetMarinePersistData():UpdateWeaponLevel(userId, self.weaponLevel)

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
