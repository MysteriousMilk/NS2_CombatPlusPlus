function PlayerUI_GetArmorLevel(researched)

    local player = Client.GetLocalPlayer()
    local armorLevel = 0

    if player:isa("Marine") then
        armorLevel = player:GetArmorLevel()
    end

    return armorLevel

end

function PlayerUI_GetWeaponLevel(researched)

    local player = Client.GetLocalPlayer()
    local weaponLevel = 0

    if player:isa("Marine") then
        weaponLevel = player:GetWeaponLevel()
    end

    return weaponLevel

end
