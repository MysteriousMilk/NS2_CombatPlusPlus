local function SpawnResourceTower(self, techPoint)
  Shared.Message("In SpawnResourceTower function.")
  return nil
end

function PlayingTeam:GetInitialTechPoint()
    return Shared.GetEntity(self.initialTechPointId)
end
