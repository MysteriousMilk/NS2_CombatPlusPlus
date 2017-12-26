--Script.Load("lua/CPPGlobals.lua")

function XPRequiredNextLevel(currentXP, rank)

    local xpRequired = 0
    if rank < kMaxRank then
        xpRequired = kXPLevelThresholds[ rank + 1 ]
    end

    return xpRequired

end

function GetLevelThresholdByRank(rank)

    local xpThreshold = 0

    if rank >  0 then
        if rank <= kMaxRank then
            xpThreshold = kXPLevelThresholds[rank]
        end
    end

    return xpThreshold

end

function GetMarineTitleByRank(rank)

    local title = "Private"

    if rank > 0 then
        if rank <= kMaxRank then
            title = kMarineRankTitles[rank]
        end
    end

    return title

end

function GetRankByXP(xp)

    local rank = 1

    if xp >= kXPLevelThresholds[ kMaxRank ] then

      rank = kMaxRank

    else

      for i=1, kMaxRank-1 do

          if xp < kXPLevelThresholds[ i + 1 ] then
              rank = i
              break
          end

      end

    end

    return rank

end

function GetCostByTechId(techId)

  local techIdCostTable = {}
  techIdCostTable[kTechId.Pistol] = 1
  techIdCostTable[kTechId.Rifle] = 1
  techIdCostTable[kTechId.Shotgun] = 1
  techIdCostTable[kTechId.Flamethrower] = 1
  techIdCostTable[kTechId.GrenadeLauncher] = 2
  techIdCostTable[kTechId.HeavyMachineGun] = 2

  local cost = techIdCostTable[techId]

  if not cost then
    cost = 0
  end

  return cost

end

function GetRequiredRankByTechId(techId)

  local techIdRankTable = {}
  techIdRankTable[kTechId.Pistol] = 2
  techIdRankTable[kTechId.Rifle] = 1
  techIdRankTable[kTechId.Shotgun] = 3
  techIdRankTable[kTechId.Flamethrower] = 6
  techIdRankTable[kTechId.GrenadeLauncher] = 7
  techIdRankTable[kTechId.HeavyMachineGun] = 8

  local rank = techIdRankTable[techId]

  if not rank then
    rank = 1
  end

  return rank

end
