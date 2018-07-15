--[[
 * Natural Selection 2 - Combat++ Mod
 * Created by: WhiteWizard
 *
 * Combat++ Server network message hooks.
]]

local function OnRequestSocketPowerPoint(client, message)

    local powerPoint = Shared.GetEntity(message.powerPointId)

    if powerPoint and powerPoint:GetPowerState() == PowerPoint.kPowerState.unsocketed then
        powerPoint:SocketPowerNode()
    end

end

Server.HookNetworkMessage("RequestSocketPowerPoint", OnRequestSocketPowerPoint)

local function OnRefundUpgradesRequested(client, message)

    local player = client:GetControllingPlayer()

    -- there must be a player for this command
    if not player then
        return
    end

    local team = player:GetTeam()

    if team then
        team:GetUpgradeHelper():RefundUpgrades(player)
    end

end
