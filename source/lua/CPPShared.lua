--[[
 * Natural Selection 2 - Combat++ Mod
 * WhiteWizard - 2017
 * CPPShared
]]

if Server then
    Script.Load("lua/Server.lua")
elseif Client then
    Script.Load("lua/Client.lua")
elseif Predict then
    Script.Load("lua/Predict.lua")
end

Script.Load("lua/CPPUtilities.lua")
Script.Load("lua/MarinePersistData.lua")
Script.Load("lua/CPPMarineSpawn.lua")
Script.Load("lua/CPPSentry.lua")
