--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Marine Upgrade Manager for Combat++.
]]

Script.Load("lua/Combat/UpgradeManager.lua")
Script.Load("lua/Combat/UpgradeData.lua")
Script.Load("lua/CPPUtilities.lua")

class 'MarineUpgradeManager' (UpgradeManager)

local function BuyMedPackAbility(techId, player)

    player:SetIsMedPackAbilityEnabled(true)
    return true

end

local function BuyAmmoPackAbility(techId, player)

    player:SetIsAmmoPackAbilityEnabled(true)
    return true

end

local function BuyCatPackAbility(techId, player)

    player:SetIsCatPackAbilityEnabled(true)
    return true

end

local function BuyScanAbility(techId, player)

    player:SetIsScanAbilityEnabled(true)
    return true

end

local function BuyArmorUpgrade(techId, player)

    player:SetArmorLevelByTechId(techId)
    return true

end

local function BuyWeaponUpgrade(techId, player)

    player:SetWeaponLevelByTechId(techId)
    return true

end

local function BuyStructureUpgrade(techId, player)

    local success = true

    -- tell the player which structure to create
    player:SetCreateStructureTechId(techId)

    -- switch to the builder tool
    player:SetActiveWeapon(Builder.kMapName)

    -- put the builder tool in "create" mode
    local weapon = player:GetActiveWeapon()
    if weapon and weapon:isa("Builder") then
        weapon:SetBuilderMode(kBuilderMode.Create)
    else
        success = false
    end

    return success

end

local function ConfigureLoadout(player)

    -- check to make sure we have a primary weapon (HUD slot 1), then switch to it
    local primaryWpn = player:GetWeaponInHUDSlot(1)
    if primaryWpn then
        player:SetHUDSlotActive(primaryWpn:GetHUDSlot())
    end

    if player.UpgradeManager:GetTree():GetIsPurchased(kTechId.Welder) then
        player:SetQuickSwitchTarget(Welder.kMapName)
    end

    if player.UpgradeManager:GetTree():GetIsPurchased(kTechId.Pistol) then
        player:SetQuickSwitchTarget(Pistol.kMapName)
    end    

end

local function BuyItemUpgrade(techId, player)

    local success = false
    local mapName = LookupTechData(techId, kTechDataMapName)

    if mapName then

        -- Make sure we're ready to deploy new weapon so we switch to it properly.
        local newItem = player:GiveItem(mapName)

        if newItem then

            if newItem.UpdateWeaponSkins then
                -- Apply weapon variant
                newItem:UpdateWeaponSkins( player:GetClient() )
            end

            StartSoundEffectAtOrigin(Marine.kGunPickupSound, player:GetOrigin())
            ConfigureLoadout(player)

            success = true

        end

    end

    return success

end

function MarineUpgradeManager:CreateUpgradeTree()

    self.Upgrades:AddClassNode(kTechId.Marine, kTechId.None, nil)
    self.Upgrades:AddClassNode(kTechId.Jetpack, kTechId.None, nil)
    self.Upgrades:AddClassNode(kTechId.DualMinigunExosuit, kTechId.None, nil)
    self.Upgrades:AddClassNode(kTechId.DualRailgunExosuit, kTechId.None, nil)

    self.Upgrades:AddUpgradeNode(kTechId.Pistol, kTechId.None, BuyItemUpgrade)
    self.Upgrades:AddUpgradeNode(kTechId.Rifle, kTechId.None, BuyItemUpgrade)
    self.Upgrades:AddUpgradeNode(kTechId.Shotgun, kTechId.None, BuyItemUpgrade)
    self.Upgrades:AddUpgradeNode(kTechId.Flamethrower, kTechId.None, BuyItemUpgrade)
    self.Upgrades:AddUpgradeNode(kTechId.GrenadeLauncher, kTechId.None, BuyItemUpgrade)
    self.Upgrades:AddUpgradeNode(kTechId.HeavyMachineGun, kTechId.None, BuyItemUpgrade)
    self.Upgrades:AddUpgradeNode(kTechId.Welder, kTechId.None, BuyItemUpgrade)
    self.Upgrades:AddUpgradeNode(kTechId.LayMines, kTechId.None, BuyItemUpgrade)
    self.Upgrades:AddUpgradeNode(kTechId.ClusterGrenade, kTechId.None, BuyItemUpgrade)
    self.Upgrades:AddUpgradeNode(kTechId.GasGrenade, kTechId.None, BuyItemUpgrade)
    self.Upgrades:AddUpgradeNode(kTechId.PulseGrenade, kTechId.None, BuyItemUpgrade)
    self.Upgrades:AddUpgradeNode(kTechId.Armor1, kTechId.None, BuyArmorUpgrade)
    self.Upgrades:AddUpgradeNode(kTechId.Armor2, kTechId.Armor1, BuyArmorUpgrade)
    self.Upgrades:AddUpgradeNode(kTechId.Armor3, kTechId.Armor2, BuyArmorUpgrade)
    self.Upgrades:AddUpgradeNode(kTechId.Weapons1, kTechId.None, BuyWeaponUpgrade)
    self.Upgrades:AddUpgradeNode(kTechId.Weapons2, kTechId.Weapons1, BuyWeaponUpgrade)
    self.Upgrades:AddUpgradeNode(kTechId.Weapons3, kTechId.Weapons2, BuyWeaponUpgrade)
    self.Upgrades:AddUpgradeNode(kTechId.MedPack, kTechId.None, BuyMedPackAbility)
    self.Upgrades:AddUpgradeNode(kTechId.AmmoPack, kTechId.None, BuyAmmoPackAbility)
    self.Upgrades:AddUpgradeNode(kTechId.CatPack, kTechId.None, BuyCatPackAbility)
    self.Upgrades:AddUpgradeNode(kTechId.Scan, kTechId.None, BuyScanAbility)
    self.Upgrades:AddUpgradeNode(kTechId.Armory, kTechId.None, BuyStructureUpgrade)
    self.Upgrades:AddUpgradeNode(kTechId.PhaseGate, kTechId.None, BuyStructureUpgrade)
    self.Upgrades:AddUpgradeNode(kTechId.Observatory, kTechId.None, BuyStructureUpgrade)
    self.Upgrades:AddUpgradeNode(kTechId.Sentry, kTechId.None, BuyStructureUpgrade)

    self.Upgrades:SetIsUnlocked(kTechId.Marine, true)
    self.Upgrades:SetIsPurchased(kTechId.Marine, true)
    self.Upgrades:SetIsUnlocked(kTechId.Rifle, true)
    self.Upgrades:SetIsPurchased(kTechId.Rifle, true)

end

function MarineUpgradeManager:PostGiveUpgrades(techIds, player, cost, overrideCost)

    UpgradeManager.PostGiveUpgrades(self, techIds, player, cost, overrideCost)

    if not overrideCost then
        Shared.PlayPrivateSound(player, Marine.kSpendResourcesSoundName, nil, 1.0, player:GetOrigin())
    end

end