function CombatPlusPlus_XPRequiredForNextRank(currentXP, rank)

    local xpRequired = 0
    if rank < kMaxCombatRank then
        xpRequired = kXPTable[ rank + 1 ]["XP"]
    end

    return xpRequired

end

function CombatPlusPlus_GetXPThresholdByRank(rank)

    rank = Clamp(rank, 1, kMaxCombatRank)
    return kXPTable[rank]["XP"]

end

function CombatPlusPlus_GetMarineTitleByRank(rank)

    rank = Clamp(rank, 1, kMaxCombatRank)
    return kXPTable[rank]["MarineName"]

end

function CombatPlusPlus_GetAlienTitleByRank(rank)

    rank = Clamp(rank, 1, kMaxCombatRank)
    return kXPTable[rank]["AlienName"]

end

function CombatPlusPlus_GetBaseKillXP(victimRank)

    victimRank = Clamp(victimRank, 1, kMaxCombatRank)
    return kXPTable[victimRank]["BaseXpOnKill"]

end

function CombatPlusPlus_GetRankByXP(xp)

    local rank = 1

    if xp >= kXPTable[kMaxCombatRank]["XP"] then

      rank = kMaxCombatRank

    else

      for i = 1, kMaxCombatRank-1 do

          if xp < kXPTable[ i + 1 ]["XP"] then
              rank = kXPTable[i]["Rank"]
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

function GetDistanceBetweenTechPoints()

    local marineTechPointOrigin = GetGameMaster():GetMarineTechPoint():GetOrigin()
    local alienTechPointOrigin = GetGameMaster():GetAlienTechPoint():GetOrigin()

    return math.abs((marineTechPointOrigin - alienTechPointOrigin):GetLength())

end

function ScaleXPByDistance(player, baseXp)

    local enemyTechPointOrigin = nil
    local scaledXp = baseXp

    if player:GetTeamNumber() == kTeam1Index then
        enemyTechPointOrigin = GetGameMaster():GetAlienTechPoint():GetOrigin()
    elseif player:GetTeamNumber() == kTeam2Index then
        enemyTechPointOrigin = GetGameMaster():GetMarineTechPoint():GetOrigin()
    end

    if enemyTechPointOrigin ~= nil then

        local distance = math.abs((enemyTechPointOrigin - player:GetOrigin()):GetLength())
        local percentage = 1 - distance / GetDistanceBetweenTechPoints()
        local modifier = LerpNumber(1, kDistanceXPModifierMaxUpperBound, percentage)
        scaledXp = math.ceil(baseXp * modifier)

    end

    return scaledXp

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
