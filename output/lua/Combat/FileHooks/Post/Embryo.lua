local ns2_Embryo_SetGestationData = Embryo.SetGestationData
function Embryo:SetGestationData(techIds, previousTechId, healthScalar, armorScalar)

    ns2_Embryo_SetGestationData(self, techIds, previousTechId, healthScalar, armorScalar)

    self.gestationTime = kSkulkGestateTime

    if self.isSpawning then

        self.gestationTime = kSpawnGestateTime

    else

        local newGestateTime = kGestateTime[previousTechId]
        if newGestateTime then
            self.gestationTime = newGestateTime
        end

    end

    self.isSpawning = false

end