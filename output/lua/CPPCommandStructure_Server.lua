--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Overriden Functions:
 *  'CommandStructure:OnUse' - Override the 'OnUse' function to prevent the player
 *  from 'using' the CommandStructure.
]]

local function CheckForLogin(self)
    return false
end

local oldOnInit = CommandStructure.OnInitialized

function CommandStructure:OnInitialized()
    -- Replace the callback that checks if the structure should open or close
    -- Callbacks that return false get removed
    ReplaceLocals(oldOnInit, {CheckForLogin = CheckForLogin})

    oldOnInit(self)

    self.occupied = true
    self.loginAllowed = false
end

function CommandStructure:OnUse(player, elapsedTime, useSuccessTable)

end
