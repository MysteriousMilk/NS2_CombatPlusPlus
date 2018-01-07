if Server then
    -- combat doesn't have batteries but we still want sentries to work
    local function UpdateBatteryState(self)
        self.attachedToBattery = true
    end

    ReplaceLocals(Sentry.OnUpdate, {UpdateBatteryState = UpdateBatteryState})
end
