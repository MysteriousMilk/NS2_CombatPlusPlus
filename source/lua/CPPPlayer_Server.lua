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
      Print("not enough resources sound server")
      Server.PlayPrivateSound(self, self:GetNotEnoughResourcesSound(), self, 1.0, Vector(0, 0, 0))
  end

  return false

end
