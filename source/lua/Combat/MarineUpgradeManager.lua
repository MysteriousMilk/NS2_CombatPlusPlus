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

function MarineUpgradeManager:CreateUpgradeTree()

    self.Upgrades:SetTeamNumber(kTeam1Index)

    self.Upgrades:AddClassNode(kTechId.Marine, kTechId.None, nil)
    self.Upgrades:AddClassNode(kTechId.Jetpack, kTechId.None, nil)
    self.Upgrades:AddClassNode(kTechId.DualMinigunExosuit, kTechId.None, nil)
    self.Upgrades:AddClassNode(kTechId.DualRailgunExosuit, kTechId.None, nil)

    self.Upgrades:AddUpgradeNode(kTechId.Pistol, kTechId.None, nil)
    self.Upgrades:AddUpgradeNode(kTechId.Rifle, kTechId.None, nil)
    self.Upgrades:AddUpgradeNode(kTechId.Shotgun, kTechId.None, nil)
    self.Upgrades:AddUpgradeNode(kTechId.Flamethrower, kTechId.None, nil)
    self.Upgrades:AddUpgradeNode(kTechId.GrenadeLauncher, kTechId.None, nil)
    self.Upgrades:AddUpgradeNode(kTechId.HeavyMachineGun, kTechId.None, nil)
    self.Upgrades:AddUpgradeNode(kTechId.Welder, kTechId.None, nil)
    self.Upgrades:AddUpgradeNode(kTechId.LayMines, kTechId.None, nil)
    self.Upgrades:AddUpgradeNode(kTechId.ClusterGrenade, kTechId.None, nil)
    self.Upgrades:AddUpgradeNode(kTechId.GasGrenade, kTechId.None, nil)
    self.Upgrades:AddUpgradeNode(kTechId.PulseGrenade, kTechId.None, nil)
    self.Upgrades:AddUpgradeNode(kTechId.Armor1, kTechId.None, BuyArmorUpgrade)
    self.Upgrades:AddUpgradeNode(kTechId.Armor2, kTechId.Armor1, BuyArmorUpgrade)
    self.Upgrades:AddUpgradeNode(kTechId.Armor3, kTechId.Armor2, BuyArmorUpgrade)
    self.Upgrades:AddUpgradeNode(kTechId.Weapons1, kTechId.None, BuyWeaponUpgrade)
    self.Upgrades:AddUpgradeNode(kTechId.Weapons2, kTechId.Weapons1, nil)
    self.Upgrades:AddUpgradeNode(kTechId.Weapons3, kTechId.Weapons2, nil)
    self.Upgrades:AddUpgradeNode(kTechId.MedPack, kTechId.None, BuyMedPackAbility)
    self.Upgrades:AddUpgradeNode(kTechId.AmmoPack, kTechId.None, BuyAmmoPackAbility)
    self.Upgrades:AddUpgradeNode(kTechId.CatPack, kTechId.None, BuyCatPackAbility)
    self.Upgrades:AddUpgradeNode(kTechId.Scan, kTechId.None, BuyScanAbility)
    self.Upgrades:AddUpgradeNode(kTechId.Armory, kTechId.None, nil)
    self.Upgrades:AddUpgradeNode(kTechId.PhaseGate, kTechId.None, nil)
    self.Upgrades:AddUpgradeNode(kTechId.Observatory, kTechId.None, nil)
    self.Upgrades:AddUpgradeNode(kTechId.Sentry, kTechId.None, nil)

    self.Upgrades:SetIsUnlocked(kTechId.Marine, true)
    self.Upgrades:SetIsPurchased(kTechId.Marine, true)
    self.Upgrades:SetIsUnlocked(kTechId.Rifle, true)
    self.Upgrades:SetIsPurchased(kTechId.Rifle, true)

end

local function ConfigureLoadout(player)

    -- check to make sure we have a primary weapon (HUD slot 1), then switch to it
    local primaryWpn = player:GetWeaponInHUDSlot(1)
    if primaryWpn then
        player:SetHUDSlotActive(primaryWpn:GetHUDSlot())
    end

    if player.UpgradeManager:GetTree():GetIsUnlocked(kTechId.Pistol) then
        player:SetQuickSwitchTarget(Pistol.kMapName)
    end

    if player.UpgradeManager:GetTree():GetIsUnlocked(kTechId.Welder) then
        player:SetQuickSwitchTarget(Welder.kMapName)
    end

end


function MarineUpgradeManager:TeamSpecificLogic(node, player, overrideCost)

    Shared.Message("TeamSpecificLogic called")
    local techId = node:GetTechId()
    local bypass = CombatPlusPlus_GetIsMarineClassTechId(techId) or CombatPlusPlus_GetIsMarineCooldownAbility(techId) or CombatPlusPlus_GetIsMarineArmorUpgrade(techId) or CombatPlusPlus_GetIsMarineWeaponUpgrade(techId)
    local success = false

    if bypass then

        success = true

    else

        if CombatPlusPlus_GetIsStructureTechId(techId) then

            -- tell the player which structure to create
            player:SetCreateStructureTechId(techId)

            -- switch to the builder tool
            player:SetActiveWeapon(Builder.kMapName)

            -- put the builder tool in "create" mode
            local weapon = player:GetActiveWeapon()
            if weapon and weapon:isa("Builder") then
                weapon:SetBuilderMode(kBuilderMode.Create)
            end

            success = true

        else

            local mapName = LookupTechData(techId, kTechDataMapName)

            if mapName then

                -- Make sure we're ready to deploy new weapon so we switch to it properly.
                local newItem = player:GiveItem(mapName)

                if newItem then

                    if newItem.UpdateWeaponSkins then
                        -- Apply weapon variant
                        newItem:UpdateWeaponSkins( player:GetClient() )
                    end

                    if not overrideCost then
                        StartSoundEffectAtOrigin(Marine.kGunPickupSound, player:GetOrigin())
                    end

                    ConfigureLoadout(player)

                    success = true

                end

            end

        end

    end

    return success

end

function MarineUpgradeManager:PostGiveUpgrade(node, player, overrideCost)

    UpgradeManager.PostGiveUpgrade(self, node, player, overrideCost)

    if not overrideCost then
        Shared.PlayPrivateSound(player, Marine.kSpendResourcesSoundName, nil, 1.0, player:GetOrigin())
    end

end