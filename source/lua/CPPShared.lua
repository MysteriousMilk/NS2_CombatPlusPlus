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


if Server then

    -- combat doesn't have batteries but we still want sentries to work
    local function UpdateBatteryState(self)
        -- just override the local function
        -- CPPSentry.lua has the PowerConsumerMixin injected in it to make the
        -- sentries work with power nodes
    end

    ReplaceLocals(Sentry.OnUpdate, {UpdateBatteryState = UpdateBatteryState})

end
