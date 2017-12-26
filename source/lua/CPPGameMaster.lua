--[[
 * Natural Selection 2 - Combat++ Mod
 * Created by: WhiteWizard
 *
 * This class controls new features added to the gameplay/gamestate for Combat++.
]]

Script.Load("lua/Utility.lua")
Script.Load("lua/Globals.lua")

local gameMaster = nil

function GetGameMaster()

    if not gameMaster then
        gameMaster = CreateGameMaster()
        gameMaster:OnCreate()
    end

    return gameMaster

end

function CreateGameMaster()

    local newGM = CPPGameMaster()
    return newGM

end

function DestroyGameMaster()

    gameMaster = nil

end

function ResetGameMaster()

    DestroyGameMaster()
    GetGameMaster()

end

class 'CPPGameMaster'

function CPPGameMaster:OnCreate()
    local counter = 0

    for p = 1, #Server.infantryPortalSpawnPoints do
        counter = counter + 1
    end

    Shared.Message(string.format('Number of Spawn Points: %s', counter))
end

function CPPGameMaster:GetMarineTechPoint()
    return self.MarineTechPoint
end

function CPPGameMaster:SetMarineTechPoint(techPoint)
    self.MarineTechPoint = techPoint
end

function CPPGameMaster:SetAlientTechPoint(techPoint)
    self.AlienTechPoint = techPoint
end

function CPPGameMaster:GetCommandStation()
    local ents = GetEntitiesForTeam("CommandStation", kMarineTeamType)
    return ents[1]
end

local function DetermineSpawnLocation(self)

    local techPointOrigin = self.MarineTechPoint:GetOrigin() + Vector(0, 2, 0)
    local spawnPoint = nil

    -- First check the predefined spawn points. Look for a close one.
    --for p = 1, #Server.infantryPortalSpawnPoints do

    --    if not takenInfantryPortalPoints[p] then
    --        local predefinedSpawnPoint = Server.infantryPortalSpawnPoints[p]
    --        if (predefinedSpawnPoint - techPointOrigin):GetLength() <= kInfantryPortalAttachRange then
    --            spawnPoint = predefinedSpawnPoint
    --            takenInfantryPortalPoints[p] = true
    --            break
    --        end
    --    end

    --end

    if not spawnPoint then

        spawnPoint = GetRandomBuildPosition( kTechId.InfantryPortal, techPointOrigin, kInfantryPortalAttachRange )
        spawnPoint = spawnPoint and spawnPoint - Vector( 0, 0.6, 0 )

    end

    return spawnPoint
end

function CPPGameMaster:CreateMarineSpawnPoints()
    for i=1,4 do
        local spawnOrigin = DetermineSpawnLocation(self)
        CreateEntity(CPPMarineSpawn.kMapName, spawnOrigin, kMarineTeamType)
    end
end

-- Spawn player on top of IP. Returns true if it was able to, false if way was blocked.
function CPPGameMaster:SpawnMarinePlayer(queuedPlayer)

    local team = queuedPlayer:GetTeam()

    -- Spawn player on top of IP
    local spawnOrigin = DetermineSpawnLocation(self)

    local success, player = team:ReplaceRespawnPlayer(queuedPlayer, spawnOrigin, queuedPlayer:GetAngles())
    if success then

        local weapon = player:GetWeapon(Rifle.kMapName)
        if weapon then
            weapon.deployed = true -- start the rifle already deployed
            weapon.skipDraw = true
        end

        player:SetCameraDistance(0)

    end

end
