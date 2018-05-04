local function SpawnResourceTower(self, techPoint)
  return nil
end

function PlayingTeam:GetInitialTechPoint()
  return Shared.GetEntity(self.initialTechPointId)
end

local ns2_PlayingTeam_RespawnPlayer = PlayingTeam.RespawnPlayer
function PlayingTeam:RespawnPlayer(player, origin, angles)

  local success = ns2_PlayingTeam_RespawnPlayer(self, player, origin, angles)

  if success and player.UpgradeManager then
    player.UpgradeManager:SpawnUpgrades(player)
  end

  return success

end
    
