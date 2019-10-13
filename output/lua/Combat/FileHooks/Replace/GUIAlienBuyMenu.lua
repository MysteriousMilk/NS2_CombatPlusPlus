--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * New GUI that appears when the aliens attempt to buy something using the 'B' key.
]]

Script.Load("lua/GUIAnimatedScript.lua")
Script.Load("lua/Combat/GUI/AnimatedTechButton.lua")

class 'GUIAlienBuyMenu' (GUIAnimatedScript)

-- Textures
GUIAlienBuyMenu.kBackgroundTexture = PrecacheAsset("ui/combatui_alienbuy_bkg.dds")
GUIAlienBuyMenu.kBuyMenuTexture = PrecacheAsset("ui/alien_buymenu.dds")
GUIAlienBuyMenu.kBuyMenuMaskTexture = PrecacheAsset("ui/alien_buymenu_mask.dds")
GUIAlienBuyMenu.kBuyEmbryoTexture = PrecacheAsset("ui/combatui_AlienCircleSaturated.dds")
GUIAlienBuyMenu.kBuySlotTexture = PrecacheAsset("ui/combatui_alien_buyslot.dds")
GUIAlienBuyMenu.kUpgradeFrameTexture = PrecacheAsset("ui/alien_hivestatus_frame_bgs.dds")
GUIAlienBuyMenu.kUpgradeTextBkgTexture = PrecacheAsset("ui/alien_hivestatus_locationname_bg.dds")
GUIAlienBuyMenu.kAlienSelectedBackground = PrecacheAsset("ui/AlienBackground.dds")
GUIAlienBuyMenu.kTechTexture = "ui/buildmenu.dds"

-- Texture Coords
GUIAlienBuyMenu.kUpgradeFrameTextureCoords = { 0, 0, 380, 125 }
GUIAlienBuyMenu.kTechButtonTextureSize = 80;

-- Colors
GUIAlienBuyMenu.kBackgroundColor = Color(0.28, 0.17, 0.04, 0.3)
GUIAlienBuyMenu.kRedHighlight = Color(1, 0.3, 0.3, 1)
GUIAlienBuyMenu.kDisabledColor = Color(0.2, 0.2, 0.2, 0.6)
GUIAlienBuyMenu.kCannotBuyColor = Color(1, 0, 0, 0.5)
GUIAlienBuyMenu.kEnabledColor = Color(1, 1, 1, 1)
GUIAlienBuyMenu.kPurchasingColor = Color(0.4, 0.7, 0, 1)

-- Corner Veins
GUIAlienBuyMenu.kCornerPulseTime = 4
GUIAlienBuyMenu.kCornerTextureCoordinates = { TopLeft = { 605, 1, 765, 145 },  BottomLeft = { 605, 145, 765, 290 }, TopRight = { 765, 1, 910, 145 }, BottomRight = { 765, 145, 910, 290 } }
GUIAlienBuyMenu.kCornerWidths = { }
GUIAlienBuyMenu.kCornerHeights = { }

local kLargeFont = Fonts.kAgencyFB_Large
local kFont = Fonts.kAgencyFB_Small

local function UpdateItemsGUIScale(self)

    local embryoTextureSizeOrig = Vector(600, 428, 0)

    -- Embryo Circle Texture
    GUIAlienBuyMenu.kEmbryoTextureSize = Vector(GUIScaleWidth(embryoTextureSizeOrig.x), GUIScaleHeight(embryoTextureSizeOrig.y), 0)
    GUIAlienBuyMenu.kEmbryoCircleSize = Vector(GUIScaleWidth(440), GUIScaleHeight(428), 0)

    GUIAlienBuyMenu.kCircleOffsetX = GUIAlienBuyMenu.kEmbryoTextureSize.x - GUIAlienBuyMenu.kEmbryoCircleSize.x
    GUIAlienBuyMenu.kEmbryoPosition = Vector(GUIScaleWidth(-embryoTextureSizeOrig.x / 2) + (GUIAlienBuyMenu.kCircleOffsetX / 2), GUIScaleHeight((-embryoTextureSizeOrig.y / 2) - 25), 0)
    
    GUIAlienBuyMenu.kAlienTypes =
    {
        {
            LocaleName = Locale.ResolveString("FADE"),
            Name = "Fade",
            Width = GUIScaleWidth(188),
            Height = GUIScaleHeight(220),
            Pos = Vector((GUIAlienBuyMenu.kEmbryoCircleSize.x / 2) - GUIAlienBuyMenu.kCircleOffsetX - GUIScaleWidth(130), (-GUIAlienBuyMenu.kEmbryoCircleSize.y / 2) + GUIScaleHeight(20), 0),
            Index = 1,
            TechId = kTechId.Fade
        },
        {
            LocaleName = Locale.ResolveString("GORGE"),
            Name = "Gorge",
            Width = GUIScaleWidth(200),
            Height = GUIScaleHeight(167),
            Pos = Vector((-GUIAlienBuyMenu.kEmbryoCircleSize.x / 2) - GUIAlienBuyMenu.kCircleOffsetX - GUIScaleWidth(40), (-GUIAlienBuyMenu.kEmbryoCircleSize.y / 2) + GUIScaleHeight(80), 0),
            Index = 2,
            TechId = kTechId.Gorge
        },
        {
            LocaleName = Locale.ResolveString("LERK"),
            Name = "Lerk",
            Width = GUIScaleWidth(284),
            Height = GUIScaleHeight(253),
            Pos = Vector((-GUIAlienBuyMenu.kEmbryoCircleSize.x / 2) - GUIAlienBuyMenu.kCircleOffsetX + GUIScaleWidth(130), (-GUIAlienBuyMenu.kEmbryoCircleSize.y / 2) + GUIScaleHeight(20), 0),
            Index = 3,
            TechId = kTechId.Lerk
        },
        {
            LocaleName = Locale.ResolveString("ONOS"),
            Name = "Onos",
            Width = GUIScaleWidth(304),
            Height = GUIScaleHeight(326),
            Pos = Vector((GUIAlienBuyMenu.kEmbryoCircleSize.x / 2) - GUIAlienBuyMenu.kCircleOffsetX + GUIScaleWidth(40), (-GUIAlienBuyMenu.kEmbryoCircleSize.y / 2) + GUIScaleHeight(80), 0),
            Index = 4,
            TechId = kTechId.Onos
        },
        { LocaleName = Locale.ResolveString("SKULK"), Name = "Skulk", Width = GUIScaleWidth(240), Height = GUIScaleHeight(170), Pos = Vector(0,0,0), Index = 5, TechId = kTechId.Skulk }
    }

    GUIAlienBuyMenu.kAlienButtonSize = GUIScaleWidth(120)
    GUIAlienBuyMenu.kAlienSelectedButtonSize = GUIAlienBuyMenu.kAlienButtonSize * 2
    GUIAlienBuyMenu.kPlayersTextSize = GUIScaleHeight(24)

    -- Background
    GUIAlienBuyMenu.kBkgCenteredWidth = GUIScaleWidth(1000)

    -- Buy Slots
    GUIAlienBuyMenu.kBuySlotSize = Vector(GUIScaleWidth(80), GUIScaleHeight(80), 0)

    -- Shift Upgrade Frame
    GUIAlienBuyMenu.kUpgradeFrameShiftSize = Vector(GUIScaleWidth(380), GUIScaleHeight(100), 0)
    GUIAlienBuyMenu.kUpgradeFrameShiftPos = Vector(GUIScaleWidth(-240) - GUIAlienBuyMenu.kUpgradeFrameShiftSize.x - GUIAlienBuyMenu.kCircleOffsetX / 2, GUIScaleHeight(140), 0)

    -- Shade Upgrade Frame
    GUIAlienBuyMenu.kUpgradeFrameShadeSize = Vector(GUIScaleWidth(380), GUIScaleHeight(100), 0)
    GUIAlienBuyMenu.kUpgradeFrameShadePos = Vector(GUIScaleWidth(240) - GUIAlienBuyMenu.kCircleOffsetX / 2, GUIScaleHeight(140), 0)

    -- Crag Upgrade Frame
    GUIAlienBuyMenu.kUpgradeFrameCragSize = Vector(GUIScaleWidth(380), GUIScaleHeight(100), 0)
    GUIAlienBuyMenu.kUpgradeFrameCragPos = Vector(GUIScaleWidth(-190) - GUIAlienBuyMenu.kUpgradeFrameCragSize.x - GUIAlienBuyMenu.kCircleOffsetX / 2, GUIScaleHeight(260), 0)

    -- Special Upgrade Frame
    GUIAlienBuyMenu.kUpgradeFrameSpecialSize = Vector(GUIScaleWidth(380), GUIScaleHeight(100), 0)
    GUIAlienBuyMenu.kUpgradeFrameSpecialPos = Vector(GUIScaleWidth(190) - GUIAlienBuyMenu.kCircleOffsetX / 2, GUIScaleHeight(260), 0)
    
    --GUIAlienBuyMenu.kUpgradeFrameShadePos = Vector(GUIScaleWidth(100), GUIScaleHeight(260), 0)
    --GUIAlienBuyMenu.kUpgradeFrameShadeSize = Vector(GUIScaleWidth(380), GUIScaleHeight(100), 0)

    -- Passive Upgrade Frame
    GUIAlienBuyMenu.kUpgradeFramePassivePos = Vector(GUIScaleWidth(10), GUIScaleHeight(-110), 0)
    GUIAlienBuyMenu.kUpgradeFramePassiveSize = Vector(GUIScaleWidth(280), GUIScaleHeight(100), 0)

    -- Upgrade Text
    GUIAlienBuyMenu.kUpgradeTextBkgPos = Vector(GUIScaleWidth(-2), GUIScaleHeight(-13.2), 0 )
    GUIAlienBuyMenu.kUpgradeTextBkgSize = Vector(GUIScaleWidth(141), GUIScaleHeight(24), 0 )
    GUIAlienBuyMenu.kUpgradeTextPos = Vector(GUIScaleWidth(9), GUIScaleHeight(6), 0 )
    GUIAlienBuyMenu.kUpgradeTextScale = GUIScale( Vector(1,1,0) * 0.465 )

    GUIAlienBuyMenu.kTechButtonSize = Vector(GUIScaleWidth(54), GUIScaleHeight(54), 0)

    GUIAlienBuyMenu.kCurrentAlienSize = GUIScale(200)
    GUIAlienBuyMenu.kCurrentAlienTitleTextSize = GUIScale(32)
    GUIAlienBuyMenu.kCurrentAlienTitleOffset = Vector(0, GUIScaleHeight(-100), 0)

    -- Corner Veins
    for location, texCoords in pairs(GUIAlienBuyMenu.kCornerTextureCoordinates) do
        GUIAlienBuyMenu.kCornerWidths[location] = GUIScale(texCoords[3] - texCoords[1])
        GUIAlienBuyMenu.kCornerHeights[location] = GUIScale(texCoords[4] - texCoords[2])
    end

end

function GUIAlienBuyMenu:Initialize()

    GUIAnimatedScript.Initialize(self)

    UpdateItemsGUIScale(self)

    self.mouseOverStates = { }
    self.selectedAlienType = AlienBuy_GetCurrentAlien()

    self:_BuildUpgradeTable()
    self:_InitializeBackground()
    self:_InitializeCorners()
    self:_InitializeUpgradeChamber()
    self:_InitializeCurrentAlienDisplay()
    self:_InitializeLifeforms()
    self:_InitializeUpgrades()

    AlienBuy_OnOpen()
    MouseTracker_SetIsVisible(true, "ui/Cursor_MenuDefault.dds", true)

end

function GUIAlienBuyMenu:Update(deltaTime)

    PROFILE("GUIAlienBuyMenu:Update")

    GUIAnimatedScript.Update(self, deltaTime)

    self:_UpdateCorners()
    self:_UpdateAlienButtons()
    self:_UpdateUpgrades()
end

function GUIAlienBuyMenu:Uninitialize()

    GUIAnimatedScript.Uninitialize(self)

    self.corners = { }
    self.cornerTweeners = { }

    MouseTracker_SetIsVisible(false)

end

function GUIAlienBuyMenu:OnResolutionChanged(oldX, oldY, newX, newY)

    self:Uninitialize()
    self:Initialize()

end

function GUIAlienBuyMenu:_BuildUpgradeTable()

    local player = Client.GetLocalPlayer()

    self.upgradeTable = { }

    for k, upgradeTech in ipairs(player:GetUpgrades()) do

        for _, childTech in ipairs(LookupUpgradesByPrereq(upgradeTech, 2)) do
            table.insert(self.upgradeTable, { TechId = childTech, Type = LookupUpgradeData(upgradeTech, kUpDataTypeIndex), Purchased = false, HasPrereq = true, Slotted = false })
        end

        table.insert(self.upgradeTable, { TechId = upgradeTech, Type = LookupUpgradeData(upgradeTech, kUpDataTypeIndex), Purchased = true, HasPrereq = false, Slotted = true })

    end

    for k, upgradeTech in ipairs(LookupUpgradesByType(kCombatUpgradeType.Upgrade, 2)) do

        if not player:GetHasUpgrade(upgradeTech) then
            table.insert(self.upgradeTable, { TechId = upgradeTech, Type = LookupUpgradeData(upgradeTech, kUpDataTypeIndex), Purchased = false, HasPrereq = false, Slotted = false })
        end

    end

    for k, upgradeTech in ipairs(LookupUpgradesByType(kCombatUpgradeType.Special, 2)) do

        if not player:GetHasUpgrade(upgradeTech) then
            table.insert(self.upgradeTable, { TechId = upgradeTech, Type = LookupUpgradeData(upgradeTech, kUpDataTypeIndex), Purchased = false, HasPrereq = false, Slotted = false })
        end

    end

    table.sort(self.upgradeTable,
        function(a, b)
            local priorityA = LookupUpgradeData(a.TechId, kUpDataPriorityIndex)
            local priorityB = LookupUpgradeData(b.TechId, kUpDataPriorityIndex)
            return priorityA < priorityB
        end)

    for k, upgrade in ipairs(self.upgradeTable) do
        local output = "[" .. kTechId[upgrade.TechId] .. " ("
        output = output .. "Purchased=" .. ConditionalValue(upgrade.Purchased, "True, ", "False, ")
        output = output .. "HasPrereq=" .. ConditionalValue(upgrade.HasPrereq, "True, ", "False, ")
        output = output .. "Slotted=" .. ConditionalValue(upgrade.Slotted, "True, ", "False)]")
        Print(output)
    end

end

function GUIAlienBuyMenu:_InitializeBackground()

    self.background = self:CreateAnimatedGraphicItem()
    self.background:SetIsScaling(false)
    self.background:SetSize( Vector(Client.GetScreenWidth(), Client.GetScreenHeight(), 0) )
    self.background:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.background:SetColor(GUIAlienBuyMenu.kBackgroundColor)
    self.background:SetLayer(kGUILayerPlayerHUDForeground4)

    self.backgroundCenteredArea = self:CreateAnimatedGraphicItem()
    self.backgroundCenteredArea:SetIsScaling(false)
    self.backgroundCenteredArea:SetSize(Vector(GUIAlienBuyMenu.kBkgCenteredWidth, Client.GetScreenHeight(), 0))
    self.backgroundCenteredArea:SetAnchor(GUIItem.Middle, GUIItem.Top)
    self.backgroundCenteredArea:SetPosition(Vector(-GUIAlienBuyMenu.kBkgCenteredWidth / 2, 0, 0))
    self.backgroundCenteredArea:SetTexture(GUIAlienBuyMenu.kBackgroundTexture)
    self.backgroundCenteredArea:SetColor(Color(1.0, 1.0, 1.0, 0.0))
    self.background:AddChild(self.backgroundCenteredArea)

end

function GUIAlienBuyMenu:_InitializeCorners()

    self.corners = { }

    local topLeftCorner = GUIManager:CreateGraphicItem()
    topLeftCorner:SetAnchor(GUIItem.Left, GUIItem.Top)
    topLeftCorner:SetSize(Vector(GUIAlienBuyMenu.kCornerWidths.TopLeft, GUIAlienBuyMenu.kCornerHeights.TopLeft, 0))
    topLeftCorner:SetTexture(GUIAlienBuyMenu.kBuyMenuTexture)
    topLeftCorner:SetTexturePixelCoordinates(GUIUnpackCoords(GUIAlienBuyMenu.kCornerTextureCoordinates.TopLeft))
    topLeftCorner:SetShader("shaders/GUIWavyNoMask.surface_shader")
    self.background:AddChild(topLeftCorner)
    self.corners.TopLeft = topLeftCorner

    local bottomLeftCorner = GUIManager:CreateGraphicItem()
    bottomLeftCorner:SetAnchor(GUIItem.Left, GUIItem.Bottom)
    bottomLeftCorner:SetPosition(Vector(0, -GUIAlienBuyMenu.kCornerHeights.BottomLeft, 0))
    bottomLeftCorner:SetSize(Vector(GUIAlienBuyMenu.kCornerWidths.BottomLeft, GUIAlienBuyMenu.kCornerHeights.BottomLeft, 0))
    bottomLeftCorner:SetTexture(GUIAlienBuyMenu.kBuyMenuTexture)
    bottomLeftCorner:SetTexturePixelCoordinates(GUIUnpackCoords(GUIAlienBuyMenu.kCornerTextureCoordinates.BottomLeft))
    bottomLeftCorner:SetShader("shaders/GUIWavyNoMask.surface_shader")
    self.background:AddChild(bottomLeftCorner)
    self.corners.BottomLeft = bottomLeftCorner

    local topRightCorner = GUIManager:CreateGraphicItem()
    topRightCorner:SetAnchor(GUIItem.Right, GUIItem.Top)
    topRightCorner:SetPosition(Vector(-GUIAlienBuyMenu.kCornerWidths.TopRight, 0, 0))
    topRightCorner:SetSize(Vector(GUIAlienBuyMenu.kCornerWidths.TopRight, GUIAlienBuyMenu.kCornerHeights.TopRight, 0))
    topRightCorner:SetTexture(GUIAlienBuyMenu.kBuyMenuTexture)
    topRightCorner:SetTexturePixelCoordinates(GUIUnpackCoords(GUIAlienBuyMenu.kCornerTextureCoordinates.TopRight))
    topRightCorner:SetShader("shaders/GUIWavyNoMask.surface_shader")
    self.background:AddChild(topRightCorner)
    self.corners.TopRight = topRightCorner

    local bottomRightCorner = GUIManager:CreateGraphicItem()
    bottomRightCorner:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    bottomRightCorner:SetPosition(Vector(-GUIAlienBuyMenu.kCornerWidths.BottomRight, -GUIAlienBuyMenu.kCornerHeights.BottomRight, 0))
    bottomRightCorner:SetSize(Vector(GUIAlienBuyMenu.kCornerWidths.BottomRight, GUIAlienBuyMenu.kCornerHeights.BottomRight, 0))
    bottomRightCorner:SetTexture(GUIAlienBuyMenu.kBuyMenuTexture)
    bottomRightCorner:SetTexturePixelCoordinates(GUIUnpackCoords(GUIAlienBuyMenu.kCornerTextureCoordinates.BottomRight))
    bottomRightCorner:SetShader("shaders/GUIWavyNoMask.surface_shader")
    self.background:AddChild(bottomRightCorner)
    self.corners.BottomRight = bottomRightCorner

    self.cornerTweeners = { }
    for cornerName, _ in pairs(self.corners) do
        self.cornerTweeners[cornerName] = Tweener("loopforward")
        self.cornerTweeners[cornerName].add(GUIAlienBuyMenu.kCornerPulseTime, { percent = 1 }, Easing.linear)
        self.cornerTweeners[cornerName].add(GUIAlienBuyMenu.kCornerPulseTime, { percent = 0 }, Easing.linear)
    end

end

local function CreateSlot(angle, type)

    local slot = {}

    slot.Angle = angle
    slot.Type = type
    slot.IsEmpty = true

    local circleCenter = Vector(GUIAlienBuyMenu.kEmbryoCircleSize.x / 2, GUIAlienBuyMenu.kEmbryoCircleSize.y / 2, 0)
    local distScale = 250

    local angleRads = angle * (math.pi / 180.0)
    local slotOffset = Vector(GUIAlienBuyMenu.kBuySlotSize.x / 2, GUIAlienBuyMenu.kBuySlotSize.y / 2, 0)
    local slotPos = Vector(distScale * math.cos(angleRads), distScale * math.sin(angleRads), 0) + circleCenter - slotOffset

    slot.SlotGraphic = GUIManager:CreateGraphicItem()
    slot.SlotGraphic:SetAnchor(GUIItem.Left, GUIItem.Top)
    slot.SlotGraphic:SetSize(GUIAlienBuyMenu.kBuySlotSize)
    slot.SlotGraphic:SetTexture(GUIAlienBuyMenu.kBuySlotTexture)
    slot.SlotGraphic:SetPosition(slotPos)
    slot.SlotGraphic:SetColor(Color(1.0, 1.0, 1.0, 0.6))

    slot.Icon = GUIManager:CreateGraphicItem()
    slot.Icon:SetAnchor(GUIItem.Middle, GUIItem.Center)
    slot.Icon:SetSize(GUIAlienBuyMenu.kTechButtonSize)
    slot.Icon:SetPosition(Vector(-GUIAlienBuyMenu.kTechButtonSize.x / 2, -GUIAlienBuyMenu.kTechButtonSize.y / 2, 0))
    slot.Icon:SetTexture(GUIAlienBuyMenu.kTechTexture)
    slot.Icon:SetColor(kIconColors[kAlienTeamType])
    slot.Icon:SetIsVisible(false)
    slot.SlotGraphic:AddChild(slot.Icon)

    return slot

end

-- function GUIAlienBuyMenu:GetEmptySlotByType(upgradeType)

--     local emptySlot = nil

--     for k, slot in ipairs(self.upgradeSlots) do

--         if slot.Type == upgradeType and slot.TechId == kTechId.None then
--             emptySlot = slot
--             break
--         end

--     end

--     return emptySlot

-- end

-- function GUIAlienBuyMenu:GetMutuallyExlusiveSlot(techId)

--     local swapSlot = nil

--     for k, slot in ipairs(self.upgradeSlots) do

--         if slot.TechId ~= kTechId.None then

--             local mutuallyExclusiveTechs = LookupUpgradeData(slot.TechId, kUpDataMutuallyExclusiveIndex)

--             for _, mutuallyExclusiveTechId in ipairs(mutuallyExclusiveTechs) do

--                 if techId == mutuallyExclusiveTechId then
--                     swapSlot = slot
--                     break;
--                 end

--             end

--             if swapSlot ~= nil then
--                 break
--             end
            
--         end

--     end

--     return swapSlot

-- end



function GUIAlienBuyMenu:_InitializeUpgradeChamber()

    local player = Client.GetLocalPlayer()

    self.embryo = GUIManager:CreateGraphicItem()
    self.embryo:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.embryo:SetSize(GUIAlienBuyMenu.kEmbryoTextureSize)
    self.embryo:SetTexture(GUIAlienBuyMenu.kBuyEmbryoTexture)
    self.embryo:SetPosition(GUIAlienBuyMenu.kEmbryoPosition)
    -- embryo:SetShader("shaders/GUIWavy.surface_shader")
    -- embryo:SetAdditionalTexture("wavyMask", GUIAlienBuyMenu.kBuyMenuMaskTexture)
    self.embryo:SetColor(Color(1.0, 1.0, 1.0, 0.7))
    self.backgroundCenteredArea:AddChild(self.embryo)

    local slot
    self.upgradeSlots = {}

    slot = CreateSlot(280, kCombatUpgradeType.Passive)
    table.insert(self.upgradeSlots, slot)
    self.embryo:AddChild(slot.SlotGraphic)

    slot = CreateSlot(300, kCombatUpgradeType.Passive)
    table.insert(self.upgradeSlots, slot)
    self.embryo:AddChild(slot.SlotGraphic)

    slot = CreateSlot(320, kCombatUpgradeType.Passive)
    table.insert(self.upgradeSlots, slot)
    self.embryo:AddChild(slot.SlotGraphic)

    slot = CreateSlot(140, kCombatUpgradeType.Upgrade)
    table.insert(self.upgradeSlots, slot)
    self.embryo:AddChild(slot.SlotGraphic)

    slot = CreateSlot(120, kCombatUpgradeType.Upgrade)
    table.insert(self.upgradeSlots, slot)
    self.embryo:AddChild(slot.SlotGraphic)
    
    slot = CreateSlot(100, kCombatUpgradeType.Upgrade)
    table.insert(self.upgradeSlots, slot)
    self.embryo:AddChild(slot.SlotGraphic)

    slot = CreateSlot(80, kCombatUpgradeType.Upgrade)
    table.insert(self.upgradeSlots, slot)
    self.embryo:AddChild(slot.SlotGraphic)

    slot = CreateSlot(60, kCombatUpgradeType.Upgrade)
    table.insert(self.upgradeSlots, slot)
    self.embryo:AddChild(slot.SlotGraphic)

    slot = CreateSlot(40, kCombatUpgradeType.Upgrade)
    table.insert(self.upgradeSlots, slot)
    self.embryo:AddChild(slot.SlotGraphic)

    slot = CreateSlot(240, kCombatUpgradeType.Special)
    table.insert(self.upgradeSlots, slot)
    self.embryo:AddChild(slot.SlotGraphic)

    slot = CreateSlot(220, kCombatUpgradeType.Special)
    table.insert(self.upgradeSlots, slot)
    self.embryo:AddChild(slot.SlotGraphic)

    slot = CreateSlot(200, kCombatUpgradeType.Special)
    table.insert(self.upgradeSlots, slot)
    self.embryo:AddChild(slot.SlotGraphic)

    slot = CreateSlot(180, kCombatUpgradeType.Special)
    table.insert(self.upgradeSlots, slot)
    self.embryo:AddChild(slot.SlotGraphic)

    -- if player.upgrade1 ~= kTechId.None then

    --     slot = self:GetEmptySlotByType(kCombatUpgradeType.Upgrade)
    --     if slot then
    --         slot.TechId = player.upgrade1
    --         slot.IsEmpty = false
    --     end

    -- end

    -- if player.upgrade2 ~= kTechId.None then

    --     slot = self:GetEmptySlotByType(kCombatUpgradeType.Upgrade)
    --     if slot then
    --         slot.TechId = player.upgrade2
    --         slot.IsEmpty = false
    --     end

    -- end

    -- if player.upgrade3 ~= kTechId.None then

    --     slot = self:GetEmptySlotByType(kCombatUpgradeType.Upgrade)
    --     if slot then
    --         slot.TechId = player.upgrade3
    --         slot.IsEmpty = false
    --     end

    -- end

    -- if player.upgrade4 ~= kTechId.None then

    --     slot = self:GetEmptySlotByType(kCombatUpgradeType.Upgrade)
    --     if slot then
    --         slot.TechId = player.upgrade4
    --         slot.IsEmpty = false
    --     end

    -- end

    -- if player.upgrade5 ~= kTechId.None then

    --     slot = self:GetEmptySlotByType(kCombatUpgradeType.Upgrade)
    --     if slot then
    --         slot.TechId = player.upgrade5
    --         slot.IsEmpty = false
    --     end

    -- end

    -- if player.upgrade6 ~= kTechId.None then

    --     slot = self:GetEmptySlotByType(kCombatUpgradeType.Upgrade)
    --     if slot then
    --         slot.TechId = player.upgrade6
    --         slot.IsEmpty = false
    --     end

    -- end

    -- if player.specialTech1 ~= kTechId.None then

    --     slot = self:GetEmptySlotByType(kCombatUpgradeType.Special)
    --     if slot then
    --         slot.TechId = player.specialTech1
    --         slot.IsEmpty = false
    --     end

    -- end

    -- if player.specialTech2 ~= kTechId.None then

    --     slot = self:GetEmptySlotByType(kCombatUpgradeType.Special)
    --     if slot then
    --         slot.TechId = player.specialTech2
    --         slot.IsEmpty = false
    --     end

    -- end

    -- if player.specialTech3 ~= kTechId.None then

    --     slot = self:GetEmptySlotByType(kCombatUpgradeType.Special)
    --     if slot then
    --         slot.TechId = player.specialTech3
    --         slot.IsEmpty = false
    --     end

    -- end

    -- if player.specialTech4 ~= kTechId.None then

    --     slot = self:GetEmptySlotByType(kCombatUpgradeType.Special)
    --     if slot then
    --         slot.TechId = player.specialTech4
    --         slot.IsEmpty = false
    --     end

    -- end

    -- if player.passiveTech1 ~= kTechId.None then

    --     slot = self:GetEmptySlotByType(kCombatUpgradeType.Passive)
    --     if slot then
    --         slot.TechId = player.passiveTech1
    --         slot.IsEmpty = false
    --     end

    -- end

    -- if player.passiveTech2 ~= kTechId.None then

    --     slot = self:GetEmptySlotByType(kCombatUpgradeType.Passive)
    --     if slot then
    --         slot.TechId = player.passiveTech2
    --         slot.IsEmpty = false
    --     end

    -- end

    -- if player.passiveTech3 ~= kTechId.None then

    --     slot = self:GetEmptySlotByType(kCombatUpgradeType.Passive)
    --     if slot then
    --         slot.TechId = player.passiveTech3
    --         slot.IsEmpty = false
    --     end

    -- end

    -- local circleCenter = Vector(GUIAlienBuyMenu.kEmbryoCircleSize.x / 2, GUIAlienBuyMenu.kEmbryoCircleSize.y / 2, 0)
    -- local angles = { 280, 300, 320, 40, 60, 80, 100, 120, 140, 180, 200, 220, 240 }
    -- local distScale = 250

    -- for k, angle in ipairs(angles) do

    --     local angleRads = angle * (math.pi / 180.0)
    --     local slotOffset = Vector(GUIAlienBuyMenu.kBuySlotSize.x / 2, GUIAlienBuyMenu.kBuySlotSize.y / 2, 0)
    --     local slotPos = Vector(distScale * math.cos(angleRads), distScale * math.sin(angleRads), 0) + circleCenter - slotOffset

    --     local slot = GUIManager:CreateGraphicItem()
    --     slot:SetAnchor(GUIItem.Left, GUIItem.Top)
    --     slot:SetSize(GUIAlienBuyMenu.kBuySlotSize)
    --     slot:SetTexture(GUIAlienBuyMenu.kBuySlotTexture)
    --     slot:SetPosition(slotPos)
    --     slot:SetColor(Color(1.0, 1.0, 1.0, 0.6))
    --     self.embryo:AddChild(slot)

    -- end

end

function GUIAlienBuyMenu:_InitializeCurrentAlienDisplay()

    self.currentAlienDisplay = { }

    self.currentAlienDisplay.Icon = GUIManager:CreateGraphicItem()
    self.currentAlienDisplay.Icon:SetAnchor(GUIItem.Middle, GUIItem.Center)
    local width = GUIAlienBuyMenu.kAlienTypes[AlienBuy_GetCurrentAlien()].Width
    local height = GUIAlienBuyMenu.kAlienTypes[AlienBuy_GetCurrentAlien()].Height
    self.currentAlienDisplay.Icon:SetSize(Vector(width, height, 0))
    self.currentAlienDisplay.Icon:SetPosition(Vector((-width / 2) - (GUIAlienBuyMenu.kCircleOffsetX / 2), -height / 2, 0))
    self.currentAlienDisplay.Icon:SetTexture("ui/" .. GUIAlienBuyMenu.kAlienTypes[AlienBuy_GetCurrentAlien()].Name .. ".dds")
    self.currentAlienDisplay.Icon:SetLayer(kGUILayerPlayerHUDForeground2)
    self.embryo:AddChild(self.currentAlienDisplay.Icon)

    self.currentAlienDisplay.TitleShadow = GUIManager:CreateTextItem()
    self.currentAlienDisplay.TitleShadow:SetAnchor(GUIItem.Middle, GUIItem.Top)
    self.currentAlienDisplay.TitleShadow:SetPosition(GUIAlienBuyMenu.kCurrentAlienTitleOffset)
    self.currentAlienDisplay.TitleShadow:SetFontName(kLargeFont)
    self.currentAlienDisplay.TitleShadow:SetScale(GetScaledVector())
    GUIMakeFontScale(self.currentAlienDisplay.TitleShadow)
    self.currentAlienDisplay.TitleShadow:SetTextAlignmentX(GUIItem.Align_Center)
    self.currentAlienDisplay.TitleShadow:SetTextAlignmentY(GUIItem.Align_Min)
    self.currentAlienDisplay.TitleShadow:SetText(GUIAlienBuyMenu.kAlienTypes[AlienBuy_GetCurrentAlien()].LocaleName)
    self.currentAlienDisplay.TitleShadow:SetColor(Color(0, 0, 0, 1))
    self.currentAlienDisplay.Icon:AddChild(self.currentAlienDisplay.TitleShadow)

    self.currentAlienDisplay.Title = GUIManager:CreateTextItem()
    self.currentAlienDisplay.Title:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.currentAlienDisplay.Title:SetPosition(Vector(-2, -2, 0))
    self.currentAlienDisplay.Title:SetFontName(kLargeFont)
    self.currentAlienDisplay.Title:SetScale(GetScaledVector())
    GUIMakeFontScale(self.currentAlienDisplay.Title)
    self.currentAlienDisplay.Title:SetTextAlignmentX(GUIItem.Align_Center)
    self.currentAlienDisplay.Title:SetTextAlignmentY(GUIItem.Align_Min)
    self.currentAlienDisplay.Title:SetText(GUIAlienBuyMenu.kAlienTypes[AlienBuy_GetCurrentAlien()].LocaleName)
    self.currentAlienDisplay.Title:SetColor(ColorIntToColor(kAlienTeamColor))
    self.currentAlienDisplay.TitleShadow:AddChild(self.currentAlienDisplay.Title)

end

local function CreateTechButton(position, techId)

    local button = GUIManager:CreateGraphicItem()
    button:SetAnchor(GUIItem.Left, GUIItem.Top)
    button:SetSize(GUIAlienBuyMenu.kTechButtonSize)
    button:SetPosition(position)
    button:SetTexture(GUIAlienBuyMenu.kTechTexture)
    button:SetColor(Color(0,0,0,0))

    if techId then

        local iconX, iconY = GetMaterialXYOffset(techId, false)
        iconX = iconX * GUIAlienBuyMenu.kTechButtonTextureSize
        iconY = iconY * GUIAlienBuyMenu.kTechButtonTextureSize

        button:SetColor(kIconColors[kAlienTeamType])
        button:SetTexturePixelCoordinates(iconX, iconY, iconX + GUIAlienBuyMenu.kTechButtonTextureSize, iconY + GUIAlienBuyMenu.kTechButtonTextureSize)

    end

    return button

end

local function CreateUpgradeSection(self, sectionName, sectionPos, category, text, passiveTechId)

    local sectionFrame = GUIManager:CreateGraphicItem()
    sectionFrame:SetAnchor(GUIItem.Middle, GUIItem.Center)
    sectionFrame:SetSize(GUIAlienBuyMenu.kUpgradeFrameShiftSize)
    sectionFrame:SetPosition(sectionPos)
    sectionFrame:SetTexture(GUIAlienBuyMenu.kUpgradeFrameTexture)
    sectionFrame:SetTexturePixelCoordinates(unpack(GUIAlienBuyMenu.kUpgradeFrameTextureCoords))
    sectionFrame:SetColor(Color(1, 1, 1, 0.8))
    self.embryo:AddChild(sectionFrame)

    local textBackground = GUIManager:CreateGraphicItem()
    textBackground:SetAnchor(GUIItem.Left, GUIItem.Top)
    textBackground:SetSize(GUIAlienBuyMenu.kUpgradeTextBkgSize)
    textBackground:SetPosition(GUIAlienBuyMenu.kUpgradeTextBkgPos)
    textBackground:SetTexture(GUIAlienBuyMenu.kUpgradeTextBkgTexture)
    textBackground:SetColor(Color(1, 1, 1, 0.8))
    sectionFrame:AddChild(textBackground)

    local sectionText = GUIManager:CreateTextItem()
    sectionText:SetAnchor(GUIItem.Left, GUIItem.Top)
    sectionText:SetPosition(GUIAlienBuyMenu.kUpgradeTextPos)
    sectionText:SetFontName(Fonts.kAgencyFB_Large_Bold)
    sectionText:SetScale(GUIAlienBuyMenu.kUpgradeTextScale)
    sectionText:SetColor(kAlienFontColor)
    sectionText:SetText(text)
    textBackground:AddChild(sectionText)

    -- create the upgrade holders for this section
    self.upgradeSections[sectionName] = { }

    local startOffset = Vector(GUIScaleWidth(30), GUIScaleHeight(24), 0)
    local paddingX = GUIScaleWidth(8)

    for i = 0, 4 do

        local pos = Vector(startOffset.x + (GUIAlienBuyMenu.kTechButtonSize.x * i) + paddingX, startOffset.y, 0)
        local button = CreateTechButton(pos)
        sectionFrame:AddChild(button)

        local upgradeHolder =
        {
            Button = button,
            IsEmpty = true
        }

        table.insert(self.upgradeSections[sectionName], upgradeHolder)

    end

    -- self.upgradeSections[sectionName] = { }

    -- local upgrades = LookupUpgradesByCategory(category, 2)
    
    -- if passiveTechId ~= nil then

    --     local nextPassiveTech = GetFirstUpgradeByPrereq(passiveTechId, 2)
    --     if nextPassiveTech ~= kTechId.None then
    --         table.insert(upgrades, 1, nextPassiveTech)
    --     end

    -- end

    -- local startOffset = Vector(GUIScaleWidth(30), GUIScaleHeight(24), 0)
    -- local paddingX = GUIScaleWidth(8)
    -- local index = 0

    -- for k, upgradeTech in ipairs(upgrades) do

    --     local pos = Vector(startOffset.x + (GUIAlienBuyMenu.kTechButtonSize.x * index) + paddingX, startOffset.y, 0)
    --     local button = CreateTechButton(upgradeTech, pos)
    --     sectionFrame:AddChild(button)

    --     local upgradeHolder =
    --     {
    --         TechId = upgradeTech,
    --         Type = LookupUpgradeData(upgradeTech, kUpDataTypeIndex),
    --         Button = button,
    --         SectionName = sectionName
    --     }

    --     table.insert(self.purchasableUpgrades, upgradeHolder)
    --     table.insert(self.upgradeSections[sectionName], upgradeHolder)
        
    --     index = index + 1

    -- end  

end

function GUIAlienBuyMenu:_InitializeUpgrades()

    local player = Client.GetLocalPlayer()

    
    self.upgradeSections = { }

    CreateUpgradeSection(self, "Shift", GUIAlienBuyMenu.kUpgradeFrameShiftPos, "SpurUpgrades", "SHIFT UPGRADES", player.passiveTech1)
    CreateUpgradeSection(self, "Shade", GUIAlienBuyMenu.kUpgradeFrameShadePos, "VeilUpgrades", "SHADE UPGRADES", player.passiveTech2)
    CreateUpgradeSection(self, "Crag", GUIAlienBuyMenu.kUpgradeFrameCragPos, "ShellUpgrades", "CRAG UPGRADES", player.passiveTech3)
    CreateUpgradeSection(self, "Special", GUIAlienBuyMenu.kUpgradeFrameSpecialPos, "Special", "SPECIAL UPGRADES")

end

function GUIAlienBuyMenu:_InitializeLifeforms()

    self.alienButtons = { }

    for k, alienType in ipairs(GUIAlienBuyMenu.kAlienTypes) do

        if alienType.Name ~= "Skulk" then

            -- The alien image.
            local alienGraphicItem = GUIManager:CreateGraphicItem()
            local ARAdjustedHeight = (alienType.Height / alienType.Width) * GUIAlienBuyMenu.kAlienButtonSize
            alienGraphicItem:SetSize(Vector(GUIAlienBuyMenu.kAlienButtonSize, ARAdjustedHeight, 0))
            alienGraphicItem:SetAnchor(GUIItem.Middle, GUIItem.Center)
            alienGraphicItem:SetPosition(Vector(-GUIAlienBuyMenu.kAlienButtonSize / 2, -ARAdjustedHeight / 2, 0))
            alienGraphicItem:SetTexture("ui/" .. alienType.Name .. ".dds")

            -- Create the text that indicates how many players are playing as a specific alien type.
            local playersText = GUIManager:CreateTextItem()
            playersText:SetAnchor(GUIItem.Right, GUIItem.Bottom)
            playersText:SetFontName(kFont)
            playersText:SetScale(GetScaledVector())
            GUIMakeFontScale(playersText)
            playersText:SetTextAlignmentX(GUIItem.Align_Max)
            playersText:SetTextAlignmentY(GUIItem.Align_Min)
            playersText:SetText("x" .. ToString(ScoreboardUI_GetNumberOfAliensByType(alienType.Name)))
            playersText:SetColor(ColorIntToColor(kAlienTeamColor))
            playersText:SetPosition(Vector(0, -GUIAlienBuyMenu.kPlayersTextSize, 0))
            alienGraphicItem:AddChild(playersText)

            -- Create the selected background item for this alien item.
            local selectedBackground = GUIManager:CreateGraphicItem()
            selectedBackground:SetAnchor(GUIItem.Middle, GUIItem.Top)
            selectedBackground:SetSize(Vector(GUIAlienBuyMenu.kAlienSelectedButtonSize, GUIAlienBuyMenu.kAlienSelectedButtonSize, 0))
            selectedBackground:SetTexture(GUIAlienBuyMenu.kAlienSelectedBackground)
            -- Hide the selected background for now.
            selectedBackground:SetColor(Color(1, 1, 1, 0))
            selectedBackground:AddChild(alienGraphicItem)

            table.insert(self.alienButtons, { TypeData = alienType, Button = alienGraphicItem, SelectedBackground = selectedBackground, ARAdjustedHeight = ARAdjustedHeight })
            self.embryo:AddChild(selectedBackground)

        end

    end

    self:_UpdateAlienButtons()

end

function GUIAlienBuyMenu:_UpdateCorners(deltaTime)

    for _, cornerName in ipairs(self.corners) do
        self.cornerTweeners[cornerName].update(deltaTime)
        local percent = self.cornerTweeners[cornerName].getCurrentProperties().percent
        self.corners[cornerName]:SetColor(Color(1, percent, percent, math.abs(percent - 0.5) + 0.5))
    end

end

function GUIAlienBuyMenu:_UpdateAlienButtons()

    local numAlienTypes = #GUIAlienBuyMenu.kAlienTypes - 1 -- not displaying skulk button
    local totalAlienButtonsWidth = GUIAlienBuyMenu.kAlienButtonSize * numAlienTypes
    local player = Client.GetLocalPlayer()
    local mouseX, mouseY = Client.GetCursorPosScreen()

    for k, alienButton in ipairs(self.alienButtons) do

        -- Info needed for the rest of this code.
        local itemTechId = alienButton.TypeData.TechId
        local cost = LookupUpgradeData(itemTechId, kUpDataCostIndex)
        local isCurrentAlien = AlienBuy_GetCurrentAlien() == alienButton.TypeData.Index
        local canAfford = cost <= player.combatUpgradePoints
        local hasRequiredRank = LookupUpgradeData(itemTechId, kUpDataRankIndex) <= player.combatRank

        alienButton.Button:SetIsVisible(true)

        if hasRequiredRank and canAfford and not isCurrentAlien then
            alienButton.Button:SetColor(GUIAlienBuyMenu.kEnabledColor)
        elseif hasRequiredRank and not canAfford then
            alienButton.Button:SetColor(GUIAlienBuyMenu.kCannotBuyColor)
        elseif not hasRequiredRank then
            alienButton.Button:SetColor(GUIAlienBuyMenu.kDisabledColor)
        end

        local mouseOver = self:_GetIsMouseOver(alienButton.Button)

        -- Only show the background if the mouse is over this button.
        alienButton.SelectedBackground:SetColor(Color(1, 1, 1, ((mouseOver and 1) or 0)))

        --local offset = Vector((((alienButton.TypeData.XPos - 1) / numAlienTypes) * (GUIAlienBuyMenu.kAlienButtonSize * numAlienTypes)) - (totalAlienButtonsWidth / 2), 0, 0)
        --alienButton.SelectedBackground:SetPosition(Vector(-GUIAlienBuyMenu.kAlienButtonSize / 2, GUIScaleHeight(-40), 0) + offset)
        alienButton.SelectedBackground:SetPosition(Vector(-GUIAlienBuyMenu.kAlienButtonSize / 2, -GUIAlienBuyMenu.kAlienButtonSize / 2, 0) + alienButton.TypeData.Pos)

    end

end

function GUIAlienBuyMenu:GetEmptyUpgradeSlotByType(type)

    local emptySlot = nil

    for k, slot in ipairs(self.upgradeSlots) do

        if slot.Type == type and slot.IsEmpty then
            emptySlot = slot
            break
        end

    end

    return emptySlot

end

function GUIAlienBuyMenu:GetEmptyUpgradeHolderBySectionName(sectionName)

    local emptyHolder = nil

    if self.upgradeSections[sectionName] then

        for k, upgradeHolder in ipairs(self.upgradeSections[sectionName]) do

            if upgradeHolder.IsEmpty then
                emptyHolder = upgradeHolder
                break
            end

        end

    end

    return emptyHolder

end

function GUIAlienBuyMenu:_UpdateUpgrades()

    -- reset slots
    for k, slot in ipairs(self.upgradeSlots) do
        slot.IsEmpty = true
        slot.Icon:SetIsVisible(false)
    end

    -- reset sections
    for k, section in pairs(self.upgradeSections) do
        for _, holder in ipairs(section) do
            holder.IsEmpty = true
            holder.Button:SetIsVisible(false)
        end
    end

    -- update all slots and sections based on upgrade states
    for k, upgrade in ipairs(self.upgradeTable) do

        local iconX, iconY = GetMaterialXYOffset(upgrade.TechId, false)
        iconX = iconX * GUIAlienBuyMenu.kTechButtonTextureSize
        iconY = iconY * GUIAlienBuyMenu.kTechButtonTextureSize

        if upgrade.Slotted then

            local slot = self:GetEmptyUpgradeSlotByType(upgrade.Type)

            if slot then

                slot.IsEmpty = false
                slot.Icon:SetTexturePixelCoordinates(iconX, iconY, iconX + GUIAlienBuyMenu.kTechButtonTextureSize, iconY + GUIAlienBuyMenu.kTechButtonTextureSize)
                slot.Icon:SetIsVisible(true)

                if upgrade.Purchased then
                    slot.Icon:SetColor(kIconColors[kAlienTeamType])
                else
                    slot.Icon:SetColor(GUIAlienBuyMenu.kPurchasingColor)
                end

            end

        else

            local category = LookupUpgradeData(upgrade.TechId, kUpDataCategoryIndex)
            local sectionUpgradeHolder = self:GetEmptyUpgradeHolderBySectionName(category)

            if sectionUpgradeHolder then
                sectionUpgradeHolder.IsEmpty = false
                sectionUpgradeHolder.Button:SetTexturePixelCoordinates(iconX, iconY, iconX + GUIAlienBuyMenu.kTechButtonTextureSize, iconY + GUIAlienBuyMenu.kTechButtonTextureSize)
                sectionUpgradeHolder.Button:SetIsVisible(true)
                sectionUpgradeHolder.Button:SetColor(kIconColors[kAlienTeamType])
            end

        end

    end

end

--
-- Checks if the mouse is over the passed in GUIItem and plays a sound if it has just moved over.
--
function GUIAlienBuyMenu:_GetIsMouseOver(overItem)

    local mouseOver = GUIItemContainsPoint(overItem, Client.GetCursorPosScreen())
    if mouseOver and not self.mouseOverStates[overItem] then
        AlienBuy_OnMouseOver()
    end
    self.mouseOverStates[overItem] = mouseOver
    return mouseOver

end

-- local function SwapSlots(self, upgrade, slot)

--     local swapTechId = slot.TechId
--     local swapType = slot.Type
--     local upgradeFound = false

--     slot.TechId = upgrade.TechId
--     slot.IsEmpty = false
--     slot.IsPurchasing = true

--     for k, upgrade in ipairs(self.purchasableUpgrades) do

--         if upgrade.TechId == swapTechId then
--             upgrade.Button:SetIsVisible(true)
--             upgradeFound = true
--             break
--         end
        
--     end

--     if not upgradeFound then
--         upgrade.TechId = swapTechId
--         upgrade.Type = swapType
--         upgrade.Button:SetIsVisible(true)
--     end

-- end

function GUIAlienBuyMenu:_HandleUpgradeClicked(mouseX, mouseY)

    local inputHandled = false
    local player = Client.GetLocalPlayer()
    local selectedUpgrade = nil

    -- for k, upgrade in ipairs(self.purchasableUpgrades) do

    --     if self:_GetIsMouseOver(upgrade.Button) then

    --         local slot = self:GetMutuallyExlusiveSlot(upgrade.TechId)

    --         if slot then

    --             SwapSlots(self, upgrade, slot)

    --         else

    --             slot = self:GetEmptySlotByType(upgrade.Type)

    --             if slot then

    --                 slot.TechId = upgrade.TechId
    --                 slot.IsEmpty = false
    --                 slot.IsPurchasing = true

    --                 inputHandled = true
    --                 selectedUpgrade = upgrade
    --                 break

    --             end

    --         end

    --     end

    -- end

    -- if inputHandled then
    --     table.removevalue(self.purchasableUpgrades, selectedUpgrade)
    --     selectedUpgrade.Button:SetIsVisible(false)
    -- end

    return inputHandled

end

function GUIAlienBuyMenu:SendKeyEvent(key, down)

    local closeMenu = false
    local inputHandled = false

    if key == InputKey.MouseButton0 and self.mousePressed ~= down then

        self.mousePressed = down

        local mouseX, mouseY = Client.GetCursorPosScreen()
        local player = Client.GetLocalPlayer()

        if down then

            inputHandled = self:_HandleUpgradeClicked(mouseX, mouseY) or inputHandled

        end

    end

    -- No matter what, this menu consumes MouseButton0/1 down.
    if down and (key == InputKey.MouseButton0 or key == InputKey.MouseButton1) then
        inputHandled = true
    end

    if InputKey.Escape == key and not down then

        closeMenu = true
        inputHandled = true

    end

    if closeMenu then

        self.closingMenu = true
        AlienBuy_OnClose()
        AlienBuy_Close()

    end

    return inputHandled

end