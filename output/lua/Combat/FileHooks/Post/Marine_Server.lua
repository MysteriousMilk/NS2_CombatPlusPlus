--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * Add some additional capabilities to the Marine entity.
 *
 * Hooked Functions:
 *  'Marine:OnKill' - Reset builder mode, destory weapons and exosuit.
]]

local ns2_Marine_OnKill = Marine.OnKill
function Marine:OnKill(attacker, doer, point, direction)

    -- put builder back into build mode
    builder = self:GetWeapon(Builder.kMapName)
    builder:SetBuilderMode(kBuilderMode.Build)

    self:DestroyWeapons()

    self:DestroyExosuit()

    ns2_Marine_OnKill(self, attacker, doer, point, direction)

end

--[[
    If a player owns an exosuit, that is, the pickupable version,
    destory it.
]]
function Marine:DestroyExosuit()

    -- Kill any exosuits the player owns
    for i, exosuit in ientitylist(Shared.GetEntitiesWithClassname("Exosuit")) do
        
        if exosuit.ownerId == self:GetId() then
            exosuit:Kill(nil, nil, exosuit:GetOrigin())
        end

    end

end