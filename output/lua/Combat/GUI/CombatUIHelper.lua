Script.Load("lua/Combat/UpgradeData.lua")


function CombatUI_GetMarineUpgradeTextureCoords(techId, enabled)

    local index = LookupUpgradeData(techId, kUpDataIconTextureOffsetIndex)
    local size = LookupUpgradeData(techId, kUpDataIconSizeIndex)

    if not size then
        size = Vector(0, 0, 0)
    end
    
    local x1 = 0
    local x2 = size.x

    if not enabled then
        x1 = size.x
        x2 = size.x * 2
    end

    if not index then
        index = 0
    end

    local y1 = index * size.y
    local y2 = (index + 1) * size.y

    return { x1, y1, x2, y2 }

end

function CombatUI_GetMarineUpgradeLargeTextureCoords(techId, enabled)

    local index = LookupUpgradeData(techId, kUpDataLargeIconTextureOffsetIndex)
    local size = LookupUpgradeData(techId, kUpDataLargeIconSizeIndex)

    if not size then
        size = Vector(0, 0, 0)
    end
    
    local x1 = 0
    local x2 = size.x

    if not enabled then
        x1 = size.x
        x2 = size.x * 2
    end

    if not index then
        index = 0
    end

    local y1 = index * size.y
    local y2 = (index + 1) * size.y

    return { x1, y1, x2, y2 }

end