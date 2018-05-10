function AlienStructure:GetCanBeHealedOverride()

    -- disable structure healing in overtime
    if GetIsOvertime() then
        return false
    end

    return true

end