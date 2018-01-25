local ns2_Player_CopyPlayerDataFrom = Player.CopyPlayerDataFrom
function Player:CopyPlayerDataFrom(player)

    ns2_Player_CopyPlayerDataFrom(self, player)

    self.currentCreateStructureTechId = player.currentCreateStructureTechId

end

-- A table of tech Ids is passed in.
function Player:ProcessBuyAction(techIds)

  ASSERT(type(techIds) == "table")
  ASSERT(table.icount(techIds) > 0)

  local techId = techIds[1]

  local cost = CombatPlusPlus_GetCostByTechId(techId)
  local canAfford = cost <= self.combatSkillPoints
  local hasRequiredRank = CombatPlusPlus_GetRequiredRankByTechId(techId) <= self.combatRank

  if canAfford and hasRequiredRank then

      if self:AttemptToBuy(techIds) then
          self:SpendSkillPoints(cost)
          return true
      end

  else
      --Print("not enough resources sound server")
      Server.PlayPrivateSound(self, self:GetNotEnoughResourcesSound(), self, 1.0, Vector(0, 0, 0))
  end

  return false

end

local ns2_Player_Replace = Player.Replace
function Player:Replace(mapName, newTeamNumber, preserveWeapons, atOrigin, extraValues)

    local player = ns2_Player_Replace(self, mapName, newTeamNumber, preserveWeapons, atOrigin, extraValues)

    -- give the player their pistol or welder back if they already purchased it
    if player:isa("Marine") then

        local userId = Server.GetOwner(player):GetUserId()
        local persistData = GetGameMaster():GetMarinePersistData()

        player:SetArmorLevel(persistData:GetArmorLevel(userId))
        player:SetWeaponLevel(persistData:GetWeaponLevel(userId))

        if HasMixin(player, "MedPackAbility") then
            player:SetIsMedPackAbilityEnabled(persistData:GetHasAbility(userId, kTechId.MedPack))
        end

        if HasMixin(player, "AmmoPackAbility") then
            player:SetIsAmmoPackAbilityEnabled(persistData:GetHasAbility(userId, kTechId.AmmoPack))
        end

        if HasMixin(player, "CatPackAbility") then
            player:SetIsCatPackAbilityEnabled(persistData:GetHasAbility(userId, kTechId.CatPack))
        end

        if HasMixin(player, "CatPackAbility") then
            player:SetIsScanAbilityEnabled(persistData:GetHasAbility(userId, kTechId.Scan))
        end

        if persistData:GetHasWeapon(userId, kTechId.Pistol) then
            player:GiveItem(Pistol.kMapName)
            player:SetQuickSwitchTarget(Pistol.kMapName)
        end

        if persistData:GetHasWeapon(userId, kTechId.Welder) then
            player:GiveItem(Welder.kMapName)
            player:SetQuickSwitchTarget(Welder.kMapName)
        end

        player:SetActiveWeapon(Rifle.kMapName)

    end

    return player

end
