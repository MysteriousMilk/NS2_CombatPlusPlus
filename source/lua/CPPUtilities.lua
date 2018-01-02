function CombatPlusPlus_XPRequiredNextLevel(currentXP, rank)

    local xpRequired = 0
    if rank < kMaxRank then
        xpRequired = kXPLevelThresholds[ rank + 1 ]
    end

    return xpRequired

end

function CombatPlusPlus_GetLevelThresholdByRank(rank)

    local xpThreshold = 0

    if rank > 0 and rank <= kMaxRank then
        xpThreshold = kXPLevelThresholds[rank]
    end

    return xpThreshold

end

function CombatPlusPlus_GetMarineTitleByRank(rank)

    local title = "Private"

    if rank > 0 and rank <= kMaxRank then
        title = kMarineRankTitles[rank]
    end

    return title

end

function CombatPlusPlus_GetRankByXP(xp)

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

function CombatPlusPlus_GetCostByTechId(techId)

    local techIdCostTable = {}
    techIdCostTable[kTechId.Pistol] = 1
    techIdCostTable[kTechId.Rifle] = 1
    techIdCostTable[kTechId.Shotgun] = 1
    techIdCostTable[kTechId.Flamethrower] = 1
    techIdCostTable[kTechId.GrenadeLauncher] = 2
    techIdCostTable[kTechId.HeavyMachineGun] = 2
    techIdCostTable[kTechId.Welder] = 1
    techIdCostTable[kTechId.LayMines] = 1
    techIdCostTable[kTechId.ClusterGrenade] = 1
    techIdCostTable[kTechId.GasGrenade] = 1
    techIdCostTable[kTechId.PulseGrenade] = 1
    techIdCostTable[kTechId.Jetpack] = 2
    techIdCostTable[kTechId.DualMinigunExosuit] = 2
    techIdCostTable[kTechId.Armor1] = 1
    techIdCostTable[kTechId.Armor2] = 1
    techIdCostTable[kTechId.Armor3] = 1
    techIdCostTable[kTechId.Weapons1] = 1
    techIdCostTable[kTechId.Weapons2] = 1
    techIdCostTable[kTechId.Weapons3] = 1
    techIdCostTable[kTechId.MedPack] = 1
    techIdCostTable[kTechId.AmmoPack] = 1
    techIdCostTable[kTechId.CatPack] = 1
    techIdCostTable[kTechId.Scan] = 1
    techIdCostTable[kTechId.Armory] = 1
    techIdCostTable[kTechId.PhaseGate] = 1
    techIdCostTable[kTechId.Observatory] = 2
    techIdCostTable[kTechId.Sentry] = 1
    techIdCostTable[kTechId.RoboticsFactory] = 2

    local cost = techIdCostTable[techId]

    if not cost then
        cost = 0
    end

    return cost

end

function CombatPlusPlus_GetRequiredRankByTechId(techId)

    local techIdRankTable = {}
    techIdRankTable[kTechId.Pistol] = 1
    techIdRankTable[kTechId.Rifle] = 1
    techIdRankTable[kTechId.Shotgun] = 3
    techIdRankTable[kTechId.Flamethrower] = 6
    techIdRankTable[kTechId.GrenadeLauncher] = 7
    techIdRankTable[kTechId.HeavyMachineGun] = 8
    techIdRankTable[kTechId.Welder] = 1
    techIdRankTable[kTechId.LayMines] = 5
    techIdRankTable[kTechId.ClusterGrenade] = 6
    techIdRankTable[kTechId.GasGrenade] = 6
    techIdRankTable[kTechId.PulseGrenade] = 6
    techIdRankTable[kTechId.Jetpack] = 9
    techIdRankTable[kTechId.DualMinigunExosuit] = 10
    techIdRankTable[kTechId.Armor1] = 1
    techIdRankTable[kTechId.Armor2] = 2
    techIdRankTable[kTechId.Armor3] = 3
    techIdRankTable[kTechId.Weapons1] = 1
    techIdRankTable[kTechId.Weapons2] = 2
    techIdRankTable[kTechId.Weapons3] = 3
    techIdRankTable[kTechId.MedPack] = 2
    techIdRankTable[kTechId.AmmoPack] = 2
    techIdRankTable[kTechId.CatPack] = 7
    techIdRankTable[kTechId.Scan] = 5
    techIdRankTable[kTechId.Armory] = 3
    techIdRankTable[kTechId.PhaseGate] = 4
    techIdRankTable[kTechId.Observatory] = 5
    techIdRankTable[kTechId.Sentry] = 6
    techIdRankTable[kTechId.RoboticsFactory] = 8

    local rank = techIdRankTable[techId]

    if not rank then
        rank = 1
    end

    return rank

end

function CreateTechEntity( techPoint, techId, rightOffset, forwardOffset, teamType )

    local origin = techPoint:GetOrigin() + Vector(0, 2, 0)
    local right = techPoint:GetCoords().xAxis
    local forward = techPoint:GetCoords().zAxis
    local position = origin + right * rightOffset + forward * forwardOffset

    local trace = Shared.TraceRay(position, position - Vector(0, 10, 0), CollisionRep.Move, PhysicsMask.All)
    if trace.fraction < 1 then
        position = trace.endPoint
    end
    --local mapName = LookupTechData(techId, kTechDataMapName)

    --local newEnt = CreateEntity( mapName, position, teamType)
    local newEnt = CreateEntityForTeam(techId, position, teamType, nil)
    if HasMixin( newEnt, "Construct" ) then
        SetRandomOrientation( newEnt )
        newEnt:SetConstructionComplete()
    end

    if HasMixin( newEnt, "Live" ) then
        newEnt:SetIsAlive(true)
    end

    return newEnt

end
