--[[
 * A table of tech Ids is passed in.
]]
function Player:ProcessBuyAction(techIds)

  ASSERT(type(techIds) == "table")
  ASSERT(table.icount(techIds) > 0)

  local techId = techIds[1]

  local cost = GetCostByTechId(techId)
  local canAfford = cost <= self.combatSkillPoints
  local hasRequiredRank = GetRequiredRankByTechId(techId) <= self.combatRank

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
