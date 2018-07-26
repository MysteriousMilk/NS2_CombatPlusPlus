--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Marine Upgrade Manager for Combat++.
]]

class 'MarineUpgradeManager' (UpgradeManager)

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

local function ExoEjectAsJetpacker(exoPlayer)

    -- Create a pickupable version just long enough so that we can kill it
    local exosuit = CreateEntity(Exosuit.kMapName, exoPlayer:GetOrigin(), exoPlayer:GetTeamNumber())
    exosuit:SetLayout(exoPlayer.layout)
    exosuit:SetCoords(exoPlayer:GetCoords())
    exosuit:SetMaxArmor(exoPlayer:GetMaxArmor())
    exosuit:SetArmor(exoPlayer:GetArmor())
    exosuit:SetExoVariant(exoPlayer:GetExoVariant())

    -- Player always reverts to a marine from an exo because class
    -- upgrades are mutually exclusive. (Ex. Jetpack Marine gives up their jp
    -- to become an Exo)
    local jetpackMarine = exoPlayer:Replace(JetpackMarine.kMapName, exoPlayer:GetTeamNumber(), false, exoPlayer:GetOrigin() + Vector(0, 0.2, 0), { preventWeapons = false })
    jetpackMarine:SetHealth(exoPlayer.prevPlayerHealth or kMarineHealth)
    jetpackMarine:SetMaxArmor(exoPlayer.prevPlayerMaxArmor or kMarineArmor)
    jetpackMarine:SetArmor(exoPlayer.prevPlayerArmor or kMarineArmor)
    
    jetpackMarine.onGround = false
    local initialVelocity = exoPlayer:GetViewCoords().zAxis
    initialVelocity:Scale(4)
    initialVelocity.y = math.max(0,initialVelocity.y) + 9
    jetpackMarine:SetVelocity(initialVelocity)

    jetpackMarine:SetHUDSlotActive(1)
    jetpackMarine:SetFuel(0.25)

    -- kill the exosuit for effect
    exosuit:Kill(nil, nil, exosuit:GetOrigin())

    return jetpackMarine

end

local function BuyJetpack(techId, player)

    local jetpackMarine = nil

    if player:isa("JetpackMarine") then
        return true, jetpackMarine
    end

    if player:isa("Exo") then
        jetpackMarine = ExoEjectAsJetpacker(player)
        return true, jetpackMarine
    end

    -- local activeWeapon = player:GetActiveWeapon()
    -- local activeWeaponMapName
    local health = player:GetHealth()
    
    -- if activeWeapon ~= nil then
    --     activeWeaponMapName = activeWeapon:GetMapName()
    -- end
    
    jetpackMarine = player:Replace(JetpackMarine.kMapName, player:GetTeamNumber(), false, Vector(player:GetOrigin()))
    
    -- jetpackMarine:SetActiveWeapon(activeWeaponMapName)
    jetpackMarine:SetHealth(health)
    jetpackMarine:SetHUDSlotActive(1)

    return true, jetpackMarine

end

local function BuyExo(techId, player)

    local maxAttempts = 100
    for index = 1, maxAttempts do

        -- Find open area nearby to place the big guy.
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

            player:DestroyWeapons()

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

    player:SetQuickSwitchTarget(Pistol.kMapName)  

end

local function BuyPrimaryWeapon(techId, player)

    local success = false
    local mapName = LookupTechData(techId, kTechDataMapName)

    if player:isa("Exo") then
        return true
    end

    if mapName then

        local oldPrimaryWpn = player:GetWeaponInHUDSlot(1)
        if oldPrimaryWpn then
            player:RemoveWeapon(oldPrimaryWpn)
            DestroyEntity(oldPrimaryWpn)
        end

        -- Make sure we're ready to deploy new weapon so we switch to it properly.
        local newItem = player:GiveItem(mapName)

        if newItem then

            StartSoundEffectAtOrigin(Marine.kGunPickupSound, player:GetOrigin())
            ConfigureLoadout(player)

            success = true

        end

    end

    return success

end

local function RemovePrimaryWeapon(techId, player)

    if player:isa("Exo") then
        return
    end

    local oldPrimaryWpn = player:GetWeaponInHUDSlot(1)
    if oldPrimaryWpn then
        player:RemoveWeapon(oldPrimaryWpn)
        DestroyEntity(oldPrimaryWpn)
    end

end

local function BuyItemUpgrade(techId, player)

    local success = false
    local mapName = LookupTechData(techId, kTechDataMapName)

    if player:isa("Exo") then
        return true
    end

    if mapName then

        -- If the player already has this weapon, no need to give it again
        local hasWeapon = player:GetWeapon(mapName)
        if hasWeapon then
            -- player already has this weapon
            return true
        end

        -- Make sure we're ready to deploy new weapon so we switch to it properly.
        local newItem = player:GiveItem(mapName)

        if newItem then

            StartSoundEffectAtOrigin(Marine.kGunPickupSound, player:GetOrigin())
            ConfigureLoadout(player)

            success = true

        end

    end

    return success

end

local function RemoveItemUpgrade(techId, player)

    if player:isa("Exo") then
        return
    end
        
    local weapon = player:GetWeapon(mapName)

    if weapon then
        player:RemoveWeapon(weapon)
        DestroyEntity(weapon)
    end

end

function MarineUpgradeManager:Initialize()

    AddUserDefinedUpgradeFunctions(kTechId.Jetpack, BuyJetpack, nil)
    AddUserDefinedUpgradeFunctions(kTechId.DualMinigunExosuit, BuyExo, nil)
    AddUserDefinedUpgradeFunctions(kTechId.DualRailgunExosuit, BuyExo, nil)

    AddUserDefinedUpgradeFunctions(kTechId.Shotgun, BuyPrimaryWeapon, RemovePrimaryWeapon)
    AddUserDefinedUpgradeFunctions(kTechId.Flamethrower, BuyPrimaryWeapon, RemovePrimaryWeapon)
    AddUserDefinedUpgradeFunctions(kTechId.GrenadeLauncher, BuyPrimaryWeapon, RemovePrimaryWeapon)
    AddUserDefinedUpgradeFunctions(kTechId.HeavyMachineGun, BuyPrimaryWeapon, RemovePrimaryWeapon)

    AddUserDefinedUpgradeFunctions(kTechId.Welder, BuyItemUpgrade, RemoveItemUpgrade)
    AddUserDefinedUpgradeFunctions(kTechId.LayMines, BuyItemUpgrade, RemoveItemUpgrade)
    AddUserDefinedUpgradeFunctions(kTechId.ClusterGrenade, BuyItemUpgrade, RemoveItemUpgrade)
    AddUserDefinedUpgradeFunctions(kTechId.GasGrenade, BuyItemUpgrade, RemoveItemUpgrade)
    AddUserDefinedUpgradeFunctions(kTechId.PulseGrenade, BuyItemUpgrade, RemoveItemUpgrade)

    AddUserDefinedUpgradeFunctions(kTechId.Armory, BuyStructureUpgrade, nil)
    AddUserDefinedUpgradeFunctions(kTechId.PhaseGate, BuyStructureUpgrade, nil)
    AddUserDefinedUpgradeFunctions(kTechId.Observatory, BuyStructureUpgrade, nil)
    AddUserDefinedUpgradeFunctions(kTechId.Sentry, BuyStructureUpgrade, nil)

end

function MarineUpgradeManager:UpgradeLogic(techIdList, classTechId, player)

    -- upgrading to new class
    if classTechId then

        local newPlayerClass = nil
        local success

        -- run custom upgrade code for this upgrade
        local upgradeFunc = LookupUpgradeData(classTechId, kUpDataUpgradeFuncIndex)
        if upgradeFunc then
            success, newPlayerClass = upgradeFunc(classTechId, player)
        end

        -- we have a new player class so apply all upgrades to the new player entity
        if newPlayerClass then
            self:ApplyAllUpgrades(newPlayerClass, true)
        end

    else

        -- No class upgrade, so loop the tech id list and apply each upgrade
        for _, techId in ipairs(techIdList) do
            
            -- run custom upgrade code for this upgrade
            local upgradeFunc = LookupUpgradeData(techId, kUpDataUpgradeFuncIndex)
            if upgradeFunc then
                upgradeFunc(techId, player)
            end

        end

    end

    return true

end

function MarineUpgradeManager:RefundAllUpgrades(player)

    UpgradeManager.RefundAllUpgrades(self, player)

    local newPlayer = player:Replace(Marine.kMapName, player:GetTeamNumber(), false, Vector(player:GetOrigin()))
    newPlayer:SetActiveWeapon(Rifle.kMapName)

end