local ns2_Marine_CopyPlayerDataFrom = Marine.CopyPlayerDataFrom
function Marine:CopyPlayerDataFrom(player)

    ns2_Marine_CopyPlayerDataFrom(self, player)

    local playerInRR = player:GetTeamNumber() == kNeutralTeamType

    if not playerInRR and GetGamerules():GetGameStarted() then

        self.armorLevel = player.armorLevel
        self.weaponLevel = player.weaponLevel

    end

end

function Marine:InitWeapons()

    Player.InitWeapons(self)

    self:GiveItem(Rifle.kMapName)
    self:GiveItem(Axe.kMapName)
    self:GiveItem(Builder.kMapName)

    self:SetQuickSwitchTarget(Axe.kMapName)
    self:SetActiveWeapon(Rifle.kMapName)

end

local function BuyExo(self, techId)

    local maxAttempts = 100
    for index = 1, maxAttempts do

        -- Find open area nearby to place the big guy.
        -- local capsuleHeight, capsuleRadius = self:GetTraceCapsule()
        local extents = Vector(Exo.kXZExtents, Exo.kYExtents, Exo.kXZExtents)

        local spawnPoint
        local checkPoint = self:GetOrigin() + Vector(0, 0.02, 0)

        if GetHasRoomForCapsule(extents, checkPoint + Vector(0, extents.y, 0), CollisionRep.Move, PhysicsMask.Evolve, self) then
            spawnPoint = checkPoint
        else
            spawnPoint = GetRandomSpawnForCapsule(extents.y, extents.x, checkPoint, 0.5, 5, EntityFilterOne(self))
        end

        local weapons

        if spawnPoint then

            self:SpendSkillPoints(CombatPlusPlus_GetCostByTechId(techId))
            local weapons = self:GetWeapons()
            for i = 1, #weapons do
                weapons[i]:SetParent(nil)
            end

            local exo

            if techId == kTechId.Exosuit then
                exo = self:GiveExo(spawnPoint)
            elseif techId == kTechId.DualMinigunExosuit then
                exo = self:GiveDualExo(spawnPoint)
            elseif techId == kTechId.ClawRailgunExosuit then
                exo = self:GiveClawRailgunExo(spawnPoint)
            elseif techId == kTechId.DualRailgunExosuit then
                exo = self:GiveDualRailgunExo(spawnPoint)
            end

            if exo then
                for i = 1, #weapons do
                    exo:StoreWeapon(weapons[i])
                end
            end

            exo:TriggerEffects("spawn_exo")

            return

        end

    end

    Print("Error: Could not find a spawn point to place the Exo")

end

kIsExoTechId = { [kTechId.Exosuit] = true, [kTechId.DualMinigunExosuit] = true,
                 [kTechId.ClawRailgunExosuit] = true, [kTechId.DualRailgunExosuit] = true }
kIsMarineStructureTechId = { [kTechId.Armory] = true, [kTechId.PhaseGate] = true,
                             [kTechId.Observatory] = true, [kTechId.Sentry] = true,
                             [kTechId.RoboticsFactory] = true }
kIsArmorUpgradeTechId = { [kTechId.Armor1] = true, [kTechId.Armor2] = true, [kTechId.Armor3] = true }
kIsWeaponUpgradeTechId = { [kTechId.Weapons1] = true, [kTechId.Weapons2] = true, [kTechId.Weapons3] = true }
kPersistTechId = { [kTechId.Pistol] = true, [kTechId.Welder] = true }
function Marine:AttemptToBuy(techIds)

    local techId = techIds[1]

    local mapName = LookupTechData(techId, kTechDataMapName)

    if mapName then

        Shared.PlayPrivateSound(self, Marine.kSpendResourcesSoundName, nil, 1.0, self:GetOrigin())

        if self:GetTeam() and self:GetTeam().OnBought then
            self:GetTeam():OnBought(techId)
        end

        if techId == kTechId.Jetpack then

            -- Need to apply this here since we change the class.
            self:SpendSkillPoints(CombatPlusPlus_GetCostByTechId(techId))
            self:GiveJetpack()

        elseif kIsExoTechId[techId] then

            BuyExo(self, techId)

        elseif kIsMarineStructureTechId[techId] then

            self:SetCreateStructureTechId(techId)
            self:SetActiveWeapon(Builder.kMapName)

            local weapon = self:GetActiveWeapon()
            if weapon and weapon:isa("Builder") then
                weapon:SetBuilderMode(kBuilderMode.Create)
            end

        else

            -- Make sure we're ready to deploy new weapon so we switch to it properly.
            local newItem = self:GiveItem(mapName)

            -- make sure certain weapons persist
            if kPersistTechId[techId] then

                local userId = Server.GetOwner(self):GetUserId()
                GetGameMaster():GetMarinePersistData():SetHasWeapon(userId, techId, true)

            end

            if newItem then
                if newItem.UpdateWeaponSkins then
                    -- Apply weapon variant
                    newItem:UpdateWeaponSkins( self:GetClient() )
                end
                StartSoundEffectAtOrigin(Marine.kGunPickupSound, self:GetOrigin())
                return true

            end

        end

        return false

    else

        if kIsArmorUpgradeTechId[techId] then

            self:SetArmorLevelByTechId(techId)
            Shared.PlayPrivateSound(self, Marine.kSpendResourcesSoundName, nil, 1.0, self:GetOrigin())
            return true

        elseif kIsWeaponUpgradeTechId[techId] then

            self:SetWeaponLevelByTechId(techId)
            Shared.PlayPrivateSound(self, Marine.kSpendResourcesSoundName, nil, 1.0, self:GetOrigin())
            return true

        end

        return false

    end

    return false

end
