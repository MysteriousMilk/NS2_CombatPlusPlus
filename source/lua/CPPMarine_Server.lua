
function Marine:InitWeapons()

    Player.InitWeapons(self)

    if not self.permanentTechItems then

      self.permanentTechItems = {}
      self.permanentTechItems[kTechId.Pistol] = { MapName = Pistol.kMapName, Purchased = false }
      self.permanentTechItems[kTechId.Welder] = { MapName = Welder.kMapName, Purchased = false }

    end

    self:GiveItem(Rifle.kMapName)
    --self:GiveItem(Pistol.kMapName)
    self:GiveItem(Axe.kMapName)
    --self:GiveItem(Welder.kMapName)
    self:GiveItem(Builder.kMapName)

    local hasPistol = false
    local hasWelder = false

    for k, techItem in ipairs(self.permanentTechItems) do
      Shared.Message("blah")
      Shared.Message(string.format("Permanent Tech Items [%s, %s]", techItem.MapName, techItem.Purchased))

      if techItem.Purchased then

        self.GetItem(techItem.MapName)

        if techItem.MapName == Pistol.kMapName then
          hasPistol = true
        elseif techItem.MapName == Welder.kMapName then
          hasWelder = true
        end

      end

    end

    if hasPistol then
      self:SetQuickSwitchTarget(Pistol.kMapName)
    elseif hasWelder then
      self:SetQuickSwitchTarget(Welder.kMapName)
    else
      self:SetQuickSwitchTarget(Axe.kMapName)
    end

    self:SetActiveWeapon(Rifle.kMapName)

end

local function UpdatePermanentTechItems(self, techId)

  if techId == kTechId.Pistol then
    self.permanentTechItems[techId].Purchased = true
    Shared.Message(string.format("Setting purchased for %s to true", self.permanentTechItems[techId].MapName))
  elseif techId == kTechId.Welder then
    self.permanentTechItems[techId].Purchased = true
    Shared.Message(string.format("Setting purchased for %s to true", self.permanentTechItems[techId].MapName))
  end

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

            self.combatSkillPoints = self.combatSkillPoints - GetCostByTechId(techId)
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
            self.combatSkillPoints = self.combatSkillPoints - GetCostByTechId(techId)
            self:GiveJetpack()

        elseif kIsExoTechId[techId] then
            BuyExo(self, techId)
        else

            -- Make sure we're ready to deploy new weapon so we switch to it properly.
            local newItem = self:GiveItem(mapName)

            UpdatePermanentTechItems(self, techId)

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

    end

    return false

end
