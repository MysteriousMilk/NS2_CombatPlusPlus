--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * This class controls new features added to the gameplay/gamestate for Combat++.
 * Just a global singleton for accessing commmon things.
]]

Script.Load("lua/Utility.lua")
Script.Load("lua/Globals.lua")
Script.Load("lua/MarinePersistData.lua")

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

    self.marinePersistData = MarinePersistData()
    self.marinePersistData:OnCreate()

end

function CPPGameMaster:GetMarinePersistData()
    return self.marinePersistData
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
