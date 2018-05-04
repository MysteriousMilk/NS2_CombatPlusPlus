-- Spawn command station or hive on tech point
function TechPoint:SpawnCommandStructure(teamNumber)

    local alienTeam = GetGamerules():GetTeam(teamNumber):GetTeamType() == kAlienTeamType
    local techId = ConditionalValue(alienTeam, kTechId.Hive, kTechId.CommandStation)

    return CreateEntityForTeam(techId, Vector(self:GetOrigin()), teamNumber)

end
