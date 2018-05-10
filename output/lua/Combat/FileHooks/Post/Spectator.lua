--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Add upgrade manager to spectator so the upgrades can be passed through will the player is a 'spectator'
 * waiting to spawn.
 *
 * Hooked Functions:
 *  'Spectator:OnCreate' - Creates the UpgradeManager.
]]

local ns2_Spectator_OnCreate = Spectator.OnCreate
function Spectator:OnCreate()

    ns2_Spectator_OnCreate(self)

    if Server then
        self.UpgradeManager = UpgradeManager()
        self.UpgradeManager:Initialize()
    end

end