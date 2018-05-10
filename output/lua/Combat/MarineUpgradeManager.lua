--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Marine Upgrade Manager for Combat++.
]]

class 'MarineUpgradeManager' (UpgradeManager)

local function BuyMedPackAbility(techId, player)

    if not player:isa("Exo") then
        player:SetIsMedPackAbilityEnabled(true)
    end

    return true

end

local function BuyAmmoPackAbility(techId, player)

    if not player:isa("Exo") then
        player:SetIsAmmoPackAbilityEnabled(true)
    end

    return true

end

local function BuyCatPackAbility(techId, player)

    if not player:isa("Exo") then
        player:SetIsCatPackAbilityEnabled(true)
    end

    return true

end

local function BuyScanAbility(techId, player)

    if not player:isa("Exo") then
        player:SetIsScanAbilityEnabled(true)
    end
    
    return true

end

local function BuyArmorUpgrade(techId, player)

    if not player:isa("Exo") then
        player:SetArmorLevelByTechId(techId)
    end

    return true

end

local function BuyWeaponUpgrade(techId, player)

    if not player:isa("Exo") then
        player:SetWeaponLevelByTechId(techId)
    end

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

local function BuyJetpack(techId, player)

    local activeWeapon = player:GetActiveWeapon()
    local activeWeaponMapName
    local health = player:GetHealth()
    
    if activeWeapon ~= nil then
        activeWeaponMapName = activeWeapon:GetMapName()
    end
    
    local jetpackMarine = player:Replace(JetpackMarine.kMapName, player:GetTeamNumber(), true, Vector(player:GetOrigin()))
    
    jetpackMarine:SetActiveWeapon(activeWeaponMapName)
    jetpackMarine:SetHealth(health)

    return true, jetpackMarine

end

local function BuyExo(techId, player)

    local maxAttempts = 100
    for index = 1, maxAttempts do

        -- Find open area nearby to place the big guy.
        -- local capsuleHeight, capsuleRadius = self:GetTraceCapsule()
        local extents = Vector(Exo.kXZExtents, Exo.kYExtents, Exo.kXZExtents)

        local spawnPoint
        local checkPoint = player:GetOrigin() + Vector(0, 0.02, 0)

        if GetHasRoomForCapsule(extents, checkPoint + Vector(0, extents.y, 0), CollisionRep.Move, PhysicsMask.Evolve, player) then
            spawnPoint = checkPoint
        else
            spawnPoint = GetRandomSpawnForCapsule(extents.y, extents.x, checkPoint, 0.5, 5, EntityFilterOne(player))
        end

        local weapons

        if spawnPoint then

            local weapons = player:GetWeapons()
            for i = 1, #weapons do
                weapons[i]:SetParent(nil)
            end

            local exo

            if techId == kTechId.Exosuit then
                exo = player:GiveExo(spawnPoint)
            elseif techId == kTechId.DualMinigunExosuit then
                exo = player:GiveDualExo(spawnPoint)
            elseif techId == kTechId.ClawRailgunExosuit then
                exo = player:GiveClawRailgunExo(spawnPoint)
            elseif techId == kTechId.DualRailgunExosuit then
                exo = player:GiveDualRailgunExo(spawnPoint)
            end

            if exo then
                for i = 1, #weapons do
                    exo:StoreWeapon(weapons[i])
                end
            end

            exo:TriggerEffects("spawn_exo")

            return true, exo

        end

    end

    Print("Error: Could not find a spawn point to place the Exo")
    return false

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

        -- Need to remove the old primary weapon if we are replacing it with a 
        -- new primary.
        if CombatPlusPlus_GetIsPrimaryWeapon(mapName) then

            local oldPrimaryWpn = player:GetWeaponInHUDSlot(1)

            if oldPrimaryWpn then
                player:RemoveWeapon(oldPrimaryWpn)
                DestroyEntity(oldPrimaryWpn)
            end

        end

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
    self.Upgrades:AddClassNode(kTechId.Jetpack, kTechId.None, BuyJetpack)
    self.Upgrades:AddClassNode(kTechId.DualMinigunExosuit, kTechId.None, BuyExo)
    self.Upgrades:AddClassNode(kTechId.DualRailgunExosuit, kTechId.None, BuyExo)

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
    self.Upgrades:AddStructureNode(kTechId.Armory, kTechId.None, BuyStructureUpgrade)
    self.Upgrades:AddStructureNode(kTechId.PhaseGate, kTechId.None, BuyStructureUpgrade)
    self.Upgrades:AddStructureNode(kTechId.Observatory, kTechId.None, BuyStructureUpgrade)
    self.Upgrades:AddStructureNode(kTechId.Sentry, kTechId.None, BuyStructureUpgrade)

    self.Upgrades:SetIsUnlocked(kTechId.Marine, true)
    self.Upgrades:SetIsPurchased(kTechId.Marine, true)
    self.Upgrades:SetIsUnlocked(kTechId.Rifle, true)
    self.Upgrades:SetIsPurchased(kTechId.Rifle, true)
    self.Upgrades:SetIsUnlocked(kTechId.Pistol, true)
    self.Upgrades:SetIsPurchased(kTechId.Pistol, true)

end

function MarineUpgradeManager:PostGiveUpgrades(techIds, player, cost, overrideCost)

    UpgradeManager.PostGiveUpgrades(self, techIds, player, cost, overrideCost)

    if not overrideCost then
        Shared.PlayPrivateSound(player, Marine.kSpendResourcesSoundName, nil, 1.0, player:GetOrigin())
    end

end