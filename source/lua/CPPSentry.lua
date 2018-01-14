Script.Load("lua/PowerConsumerMixin.lua")

local networkVarsEx = {}

AddMixinNetworkVars(PowerConsumerMixin, networkVarsEx)

local ns2_Sentry_OnCreate = Sentry.OnCreate
function Sentry:OnCreate()

    ns2_Sentry_OnCreate(self)

    -- add the power consumer mixin so sentries work with power nodes
    InitMixin(self, PowerConsumerMixin)

end

function Sentry:GetRequiresPower()
    return true
end

function Sentry:OnPowerOn()
    self.attachedToBattery = true
end

function Sentry:OnPowerOff()
    self.attachedToBattery = false
end

Shared.LinkClassToMap("Sentry", Sentry.kMapName, networkVarsEx)
