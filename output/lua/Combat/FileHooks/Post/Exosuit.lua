if Server then

    function Exosuit:OnUpdate(deltaTime)
    
        ScriptActor.OnUpdate(self, deltaTime)
        
        -- prevent exosuits from losing their owner
        --if self.resetOwnerTime and self.resetOwnerTime < Shared.GetTime() then
        --    self:SetOwner(nil)
        --    self.resetOwnerTime = nil
        --end
        if not self:GetOwner() or self:GetOwner():GetTeamNumber() ~= self:GetTeamNumber() then
            self:Kill(nil, nil, self:GetOrigin())
        end
        
    end

    function Exosuit:OnUseDeferred()
        
        local player = self.useRecipient 
        self.useRecipient = nil
        
        if player and not player:GetIsDestroyed() and self:GetIsValidRecipient(player) then
        
            player:DestroyWeapons()

            local exoPlayer
            if self.layout == "MinigunMinigun" then
                exoPlayer = player:GiveDualExo()            
            elseif self.layout == "RailgunRailgun" then
                exoPlayer = player:GiveDualRailgunExo()
            elseif self.layout == "ClawRailgun" then
                exoPlayer = player:GiveClawRailgunExo()
            else
                exoPlayer = player:GiveExo()
            end  

            if exoPlayer then

                exoPlayer:SetMaxArmor(self:GetMaxArmor())
                exoPlayer:SetArmor(self:GetArmor())
                exoPlayer:SetFlashlightOn(self:GetFlashlightOn())
                exoPlayer:TransferParasite(self)
                
                local newAngles = player:GetViewAngles()
                newAngles.pitch = 0
                newAngles.roll = 0
                newAngles.yaw = GetYawFromVector(self:GetCoords().zAxis)
                exoPlayer:SetOffsetAngles(newAngles)
                -- the coords of this entity are the same as the players coords when he left the exo, so reuse these coords to prevent getting stuck
                exoPlayer:SetCoords(self:GetCoords())

                self:TriggerEffects("pickup")
                DestroyEntity(self)

                -- Apply the player's upgrades to the new class entity
                exoPlayer:GetTeam():GetUpgradeHelper():ApplyAllUpgrades(exoPlayer, true)
                
            end
            
        end
    
    end

end