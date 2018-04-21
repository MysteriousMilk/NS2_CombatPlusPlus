--[[
 * Natural Selection 2 - Combat++ Mod
 * Created by: WhiteWizard
 *
 * Handles server functionality for Combat++.
]]

-- Set the name of the VM for debugging
decoda_name = "Server"
Script.Load("lua/CPPGameMaster.lua")
Script.Load("lua/Combat/UpgradeData.lua")
Script.Load("lua/Combat/UpgradeNode.lua")
Script.Load("lua/Combat/UpgradeTree.lua")
Script.Load("lua/Combat/UpgradeManager.lua")
Script.Load("lua/Combat/MarineUpgradeManager.lua")

local old_CreateVoiceMessage = CreateVoiceMessage
function CreateVoiceMessage(player, voiceId)

    if voiceId == kVoiceId.MarineRequestMedpack then
        if HasMixin(player, "MedPackAbility") and player:CanApplyMedPack() then
            player:ApplyMedPack()
        end
    elseif voiceId == kVoiceId.MarineRequestAmmo then
        if HasMixin(player, "AmmoPackAbility") and player:CanApplyAmmoPack() then
            player:ApplyAmmoPack()
        end
    elseif voiceId == kVoiceId.MarineRequestOrder then
        if HasMixin(player, "CatPackAbility") and player:CanApplyCatPack() then
            player:ApplyCatalystPack()
        end
    elseif voiceId == kVoiceId.MarineTaunt then
        if HasMixin(player, "ScanAbility") and player:CanApplyScan() then
            player:ApplyScan()
        end
    else
        old_CreateVoiceMessage(player, voiceId)
    end

end

local function OnCommandCombatGiveRank(client, rank)

    if Shared.GetCheatsEnabled() then

        local player = client:GetControllingPlayer()

        -- there must be a player for this command
        if not player then
            return
        end

        -- the player must be actively on a team (Marines or Aliens)
        if player:GetTeamNumber() == kTeam1Index or player:GetTeamNumber() == kTeam2Index then

            if not GetGameInfoEntity():GetWarmUpActive() and HasMixin(player, "CombatScore") then
                player:GiveCombatRank(rank)
            end

        end

    end

end

Event.Hook("Console_cppgiverank", OnCommandCombatGiveRank)
