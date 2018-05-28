local ns2_Embryo_SetGestationData = Embryo.SetGestationData
function Embryo:SetGestationData(techIds, previousTechId, healthScalar, armorScalar)

    ns2_Embryo_SetGestationData(self, techIds, previousTechId, healthScalar, armorScalar)

    if self.isSpawning then
        self.gestationTime = kSpawnGestateTime
    else
        self.gestationTime = kSkulkGestateTime
    end

end