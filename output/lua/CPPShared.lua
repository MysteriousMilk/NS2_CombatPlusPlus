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

if Server then

    -- combat doesn't have batteries but we still want sentries to work
    local function UpdateBatteryState(self)
        -- just override the local function
        -- CPPSentry.lua has the PowerConsumerMixin injected in it to make the
        -- sentries work with power nodes
    end

    ReplaceLocals(Sentry.OnUpdate, {UpdateBatteryState = UpdateBatteryState})

end

if Client then

    local function ShowHUD(self, show)

        assert(Client)
        
        if self.marineHudVisible ~= show then
            self.marineHudVisible = show
            ClientUI.SetScriptVisibility("Hud/Marine/GUIMarineHUD", "Alive", show)
        end
        
        if self.exoHudVisible ~= show then
            self.exoHudVisible = show
            ClientUI.SetScriptVisibility("Hud/Marine/GUIExoHUD", "Alive", show)
            ClientUI.SetScriptVisibility("Combat/GUI/MarineStatusHUD", "Alive", true)
            Shared.Message("Turning on Combat Marine Status HUD for Exo")
        end
        
    end
    
    ReplaceLocals(Exo.OnInitLocalClient, { ShowHUD = ShowHUD })
    ReplaceLocals(Exo.UpdateClientEffects, { ShowHUD = ShowHUD } )

end
