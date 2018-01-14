
class 'MarinePersistData'

function MarinePersistData:OnCreate()

    self.armorLevelPersistTable = {}
    self.weaponLevelPersistTable = {}
    self.permanentWeaponPurchaseTable =
    {
        [kTechId.Pistol] = {},
        [kTechId.Welder] = {}
    }

    self.permanentAbilityPurchaseTable =
    {
        [kTechId.MedPack] = {},
        [kTechId.AmmoPack] = {},
        [kTechId.CatPack] = {},
        [kTechId.Scan] = {}
    }

end

function MarinePersistData:Reset()

    for k in pairs(self.armorLevelPersistTable) do
        self.armorLevelPersistTable[k] = nil
    end

    for k in pairs(self.weaponLevelPersistTable) do
        self.weaponLevelPersistTable[k] = nil
    end

    for k in pairs(self.permanentWeaponPurchaseTable[kTechId.Pistol]) do
        self.permanentWeaponPurchaseTable[kTechId.Pistol][k] = nil
    end

    for k in pairs(self.permanentWeaponPurchaseTable[kTechId.Welder]) do
        self.permanentWeaponPurchaseTable[kTechId.Welder][k] = nil
    end

    for k in pairs(self.permanentAbilityPurchaseTable[kTechId.MedPack]) do
        self.permanentAbilityPurchaseTable[kTechId.MedPack][k] = nil
    end

    for k in pairs(self.permanentAbilityPurchaseTable[kTechId.AmmoPack]) do
        self.permanentAbilityPurchaseTable[kTechId.AmmoPack][k] = nil
    end

    for k in pairs(self.permanentAbilityPurchaseTable[kTechId.CatPack]) do
        self.permanentAbilityPurchaseTable[kTechId.CatPack][k] = nil
    end

    for k in pairs(self.permanentAbilityPurchaseTable[kTechId.Scan]) do
        self.permanentAbilityPurchaseTable[kTechId.Scan][k] = nil
    end

end

function MarinePersistData:GetHasWeapon(userId, techId)

    if self.permanentWeaponPurchaseTable[techId] and self.permanentWeaponPurchaseTable[techId][userId] then
        return self.permanentWeaponPurchaseTable[techId][userId]
    end

    return false

end

function MarinePersistData:SetHasWeapon(userId, techId, hasWeapon)

    if self.permanentWeaponPurchaseTable[techId] then
        self.permanentWeaponPurchaseTable[techId][userId] = hasWeapon
    end

end

function MarinePersistData:GetHasAbility(userId, techId)

    if self.permanentAbilityPurchaseTable[techId] and self.permanentAbilityPurchaseTable[techId][userId] then
        return self.permanentAbilityPurchaseTable[techId][userId]
    end

    return false

end

function MarinePersistData:SetHasAbility(userId, techId, hasAbility)

    if self.permanentAbilityPurchaseTable[techId] then
        self.permanentAbilityPurchaseTable[techId][userId] = hasAbility
    end

end

function MarinePersistData:UpdateArmorLevel(userId, armorLevel)

    self.armorLevelPersistTable[userId] = armorLevel

end

function MarinePersistData:GetArmorLevel(userId)

    if self.armorLevelPersistTable[userId] then
        return self.armorLevelPersistTable[userId]
    end

    return 0

end

function MarinePersistData:UpdateWeaponLevel(userId, weaponLevel)

    self.weaponLevelPersistTable[userId] = weaponLevel

end

function MarinePersistData:GetWeaponLevel(userId)

    if self.weaponLevelPersistTable[userId] then
        return self.weaponLevelPersistTable[userId]
    end

    return 0

end
