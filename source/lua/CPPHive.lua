--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Some additions to Hive creation.
 *
 * Wrapped Functions:
 *  'Hive:OnCreate' - Starts the Hive in a Mature state.
]]

local ns2_Hive_OnCreate = Hive.OnCreate
function Hive:OnCreate()

    ns2_Hive_OnCreate(self)

    if Server then

        self:SetMature()

        self.timeLastCyst = 0

    end

end
