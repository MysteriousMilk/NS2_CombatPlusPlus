--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * New GUI that appears when the aliens attempt to buy something using the 'B' key.
]]

Script.Load("lua/GUIAnimatedScript.lua")

class 'CPPGUICombatAlienBuyMenu' (GUIAnimatedScript)

CPPGUICombatAlienBuyMenu.kBackgroundColor = Color(0.28, 0.17, 0.04, 0.6)
CPPGUICombatAlienBuyMenu.kBackgroundCenterColor = Color(0.4, 0.1, 0.06, 0.8)
CPPGUICombatAlienBuyMenu.kBackgroundSize = Vector(1024, 1024, 0)

CPPGUICombatAlienBuyMenu.kBuyMenuTexture = PrecacheAsset("ui/alien_buymenu.dds")
CPPGUICombatAlienBuyMenu.kBuyMenuMaskTexture = PrecacheAsset("ui/alien_buymenu_mask.dds")
CPPGUICombatAlienBuyMenu.kBuyHUDTexture = "ui/buildmenu.dds"
CPPGUICombatAlienBuyMenu.kAbilityIcons = "ui/buildmenu.dds"

CPPGUICombatAlienBuyMenu.kSlotTexture = PrecacheAsset("ui/alien_buyslot.dds")
CPPGUICombatAlienBuyMenu.kSlotLockedTexture = PrecacheAsset("ui/alien_buyslot_locked.dds")

CPPGUICombatAlienBuyMenu.kBackgroundTextureCoordinates = { 9, 1, 602, 424 }

CPPGUICombatAlienBuyMenu.kAlienSelectedBackground = PrecacheAsset("ui/AlienBackground.dds")

CPPGUICombatAlienBuyMenu.kEvolveButtonNeedResourcesTextureCoordinates = { 87, 429, 396, 511 }
CPPGUICombatAlienBuyMenu.kEvolveButtonTextureCoordinates = { 396, 428, 706, 511 }
CPPGUICombatAlienBuyMenu.kEvolveButtonVeinsTextureCoordinates = { 600, 350, 915, 419 }
local kVeinsMargin = GUIScale(4)

CPPGUICombatAlienBuyMenu.kResourceIconTexture = PrecacheAsset("ui/pres_icon_big.dds")

CPPGUICombatAlienBuyMenu.kButtonTexture = PrecacheAsset("ui/combatui_alien_button.dds")
CPPGUICombatAlienBuyMenu.kButtonHighlightTexture = PrecacheAsset("ui/combatui_alien_button_highlight.dds")
CPPGUICombatAlienBuyMenu.kButtonSize = Vector(128, 128, 0)
CPPGUICombatAlienBuyMenu.kButtonPadding = Vector(60, 20, 0)

CPPGUICombatAlienBuyMenu.kLifeformIconTexture = PrecacheAsset("ui/combatui_alien_lifeforms.dds")

CPPGUICombatAlienBuyMenu.kTitleFont = Fonts.kStamp_Large
CPPGUICombatAlienBuyMenu.kHeaderFont = Fonts.kStamp_Medium
CPPGUICombatAlienBuyMenu.kTextColor = Color(kAlienFontColor)

CPPGUICombatAlienBuyMenu.kCornerPulseTime = 4
CPPGUICombatAlienBuyMenu.kCornerTextureCoordinates = { TopLeft = { 605, 1, 765, 145 },  BottomLeft = { 605, 145, 765, 290 }, TopRight = { 765, 1, 910, 145 }, BottomRight = { 765, 145, 910, 290 } }
CPPGUICombatAlienBuyMenu.kCornerWidths = { }
CPPGUICombatAlienBuyMenu.kCornerHeights = { }

CPPGUICombatAlienBuyMenu.kMaxNumberOfUpgradeButtons = 8
CPPGUICombatAlienBuyMenu.kUpgradeButtonTextureSize = 80
CPPGUICombatAlienBuyMenu.kUpgradeButtonBackgroundTextureCoordinates = { 15, 434, 85, 505 }
CPPGUICombatAlienBuyMenu.kUpgradeButtonMoveTime = 0.5

local kTooltipTextWidth = GUIScale(300)

CPPGUICombatAlienBuyMenu.kHealthIconTextureCoordinates = { 854, 318, 887, 351 }
CPPGUICombatAlienBuyMenu.kArmorIconTextureCoordinates = { 887, 318, 920, 351 }

CPPGUICombatAlienBuyMenu.kRedHighlight = Color(1, 0.3, 0.3, 1)
CPPGUICombatAlienBuyMenu.kDisabledColor = Color(0.5, 0.5, 0.5, 0.5)
CPPGUICombatAlienBuyMenu.kCannotBuyColor = Color(1, 0, 0, 0.5)
CPPGUICombatAlienBuyMenu.kEnabledColor = Color(1, 1, 1, 1)

local kLargeFont = Fonts.kAgencyFB_Large
local kFont = Fonts.kAgencyFB_Small
local kOffsetToCircleCenter = Vector(-70, 0, 0)

local function GetTotalCost(self)

    local totalCost = 0

    -- alien cost
    if self.selectedAlienType ~= AlienBuy_GetCurrentAlien() then
        totalCost = CombatPlusPlus_GetCostByTechId(self.kAlienTypes[self.selectedAlienType].TechId)
    end

    -- upgrade costs
    for i, currentButton in ipairs(self.upgradeButtons) do

        local upgradeCost = CombatPlusPlus_GetCostByTechId(currentButton.TechId)

        -- Skulks have free upgrades even in Combat++ :)
        if self.kAlienTypes[self.selectedAlienType].TechId == kTechId.Skulk then
            upgradeCost = 0
        end

        local player = Client.GetLocalPlayer()
        if currentButton.Selected and not player:GetHasUpgrade(currentButton.TechId) then
            totalCost = totalCost + upgradeCost
        end

    end

    return totalCost

end

local function GetNumberOfNewlySelectedUpgrades(self)

    local numSelected = 0
    local player = Client.GetLocalPlayer()

    if player then

        for i, currentButton in ipairs(self.upgradeButtons) do

            if currentButton.Selected and not player:GetHasUpgrade(currentButton.TechId) then
                numSelected = numSelected + 1
            end

        end

    end

    return numSelected

end

--
-- Checks if the mouse is over the passed in GUIItem and plays a sound if it has just moved over.
--
function CPPGUICombatAlienBuyMenu:_GetIsMouseOver(overItem)

    local mouseOver = GUIItemContainsPoint(overItem, Client.GetCursorPosScreen())
    if mouseOver and not self.mouseOverStates[overItem] then
        AlienBuy_OnMouseOver()
    end
    self.mouseOverStates[overItem] = mouseOver
    return mouseOver

end

local function UpdateItemsGUIScale(self)

    CPPGUICombatAlienBuyMenu.kAlienTypes = { { LocaleName = Locale.ResolveString("FADE"), Name = "Fade", Width = GUIScale(188), Height = GUIScale(220), XPos = 4, Index = 1, TechId = kTechId.Fade },
        { LocaleName = Locale.ResolveString("GORGE"), Name = "Gorge", Width = GUIScale(200), Height = GUIScale(167), XPos = 1, Index = 2, TechId = kTechId.Gorge },
        { LocaleName = Locale.ResolveString("LERK"), Name = "Lerk", Width = GUIScale(284), Height = GUIScale(253), XPos = 3, Index = 3, TechId = kTechId.Lerk },
        { LocaleName = Locale.ResolveString("ONOS"), Name = "Onos", Width = GUIScale(304), Height = GUIScale(326), XPos = 5, Index = 4, TechId = kTechId.Onos },
        { LocaleName = Locale.ResolveString("SKULK"), Name = "Skulk", Width = GUIScale(240), Height = GUIScale(170), XPos = 2, Index = 5, TechId = kTechId.Skulk } }

    CPPGUICombatAlienBuyMenu.kOffsetToCircleCenter = Vector(GUIScale(-70), 0, 0)

    CPPGUICombatAlienBuyMenu.kBackgroundWidth = GUIScale((CPPGUICombatAlienBuyMenu.kBackgroundTextureCoordinates[3] - CPPGUICombatAlienBuyMenu.kBackgroundTextureCoordinates[1]) * 0.80)
    CPPGUICombatAlienBuyMenu.kBackgroundHeight = GUIScale((CPPGUICombatAlienBuyMenu.kBackgroundTextureCoordinates[4] - CPPGUICombatAlienBuyMenu.kBackgroundTextureCoordinates[2]) * 0.80)

    CPPGUICombatAlienBuyMenu.kBackgroundXOffset = GUIScale(75)

    CPPGUICombatAlienBuyMenu.kAlienButtonSize = GUIScale(180)
    CPPGUICombatAlienBuyMenu.kPlayersTextSize = GUIScale(24)
    CPPGUICombatAlienBuyMenu.kAlienSelectedButtonSize = CPPGUICombatAlienBuyMenu.kAlienButtonSize * 2

    CPPGUICombatAlienBuyMenu.kResourceIconWidth = GUIScale(33)
    CPPGUICombatAlienBuyMenu.kResourceIconHeight = GUIScale(33)

    CPPGUICombatAlienBuyMenu.kEvolveButtonWidth = GUIScale(250)
    CPPGUICombatAlienBuyMenu.kEvolveButtonHeight = GUIScale(80)
    CPPGUICombatAlienBuyMenu.kEvolveButtonYOffset = GUIScale(40)
    CPPGUICombatAlienBuyMenu.kEvolveButtonTextSize = GUIScale(22)

    CPPGUICombatAlienBuyMenu.kSlotDistance = GUIScale(120)
    CPPGUICombatAlienBuyMenu.kSlotSize = GUIScale(54)

    CPPGUICombatAlienBuyMenu.kCurrentAlienSize = GUIScale(200)
    CPPGUICombatAlienBuyMenu.kCurrentAlienTitleOffset = Vector(0, GUIScale(25), 0)

    CPPGUICombatAlienBuyMenu.kHealthIconWidth = GUIScale(CPPGUICombatAlienBuyMenu.kHealthIconTextureCoordinates[3] - CPPGUICombatAlienBuyMenu.kHealthIconTextureCoordinates[1])
    CPPGUICombatAlienBuyMenu.kHealthIconHeight = GUIScale(CPPGUICombatAlienBuyMenu.kHealthIconTextureCoordinates[4] - CPPGUICombatAlienBuyMenu.kHealthIconTextureCoordinates[2])

    CPPGUICombatAlienBuyMenu.kArmorIconWidth = GUIScale(CPPGUICombatAlienBuyMenu.kArmorIconTextureCoordinates[3] - CPPGUICombatAlienBuyMenu.kArmorIconTextureCoordinates[1])
    CPPGUICombatAlienBuyMenu.kArmorIconHeight = GUIScale(CPPGUICombatAlienBuyMenu.kArmorIconTextureCoordinates[4] - CPPGUICombatAlienBuyMenu.kArmorIconTextureCoordinates[2])

    CPPGUICombatAlienBuyMenu.kMouseOverTitleOffset = Vector(GUIScale(-25), GUIScale(-390), 0)
    CPPGUICombatAlienBuyMenu.kMouseOverInfoResIconOffset = GUIScale(Vector(-34, -340, 0))
    CPPGUICombatAlienBuyMenu.kMouseOverInfoTextSize = GUIScale(20)
    CPPGUICombatAlienBuyMenu.kMouseOverInfoOffset = Vector(GUIScale(-25), GUIScale(-300), 0)

    kTooltipTextWidth = GUIScale(300)

    CPPGUICombatAlienBuyMenu.kUpgradeButtonSize = GUIScale(54)
    CPPGUICombatAlienBuyMenu.kUpgradeButtonDistance = GUIScale(198)
    -- The distance in pixels to move the button inside the embryo when selected.
    CPPGUICombatAlienBuyMenu.kUpgradeButtonDistanceInside = GUIScale(74)

    for location, texCoords in pairs(CPPGUICombatAlienBuyMenu.kCornerTextureCoordinates) do
        CPPGUICombatAlienBuyMenu.kCornerWidths[location] = GUIScale(texCoords[3] - texCoords[1])
        CPPGUICombatAlienBuyMenu.kCornerHeights[location] = GUIScale(texCoords[4] - texCoords[2])
    end

end

function CPPGUICombatAlienBuyMenu:Initialize()

    GUIAnimatedScript.Initialize(self)

    UpdateItemsGUIScale(self)

    self.numSelectedUpgrades = 0
    self.mouseOverStates = { }
    self.upgradeList = {}
    self.abilityIcons = {}
    self.selectedAlienType = AlienBuy_GetCurrentAlien()

    self:_InitializeBackground()
    self:_InitializeCorners()
    self:_InitializeBackgroundCircle()
    self:_InitializeCurrentAlienDisplay()
    self:_InitializeMouseOverInfo()
    self:_InitializeSlots()
    self:_InitializeUpgradeButtons()
    self:_InitializeAlienButtons()
    self:_InitializeEvolveButton()
    --self:_InitializeHeaders()
    --self:_InitializeButtons()

    AlienBuy_OnOpen()
    MouseTracker_SetIsVisible(true, "ui/Cursor_MenuDefault.dds", true)

end

function CPPGUICombatAlienBuyMenu:Update(deltaTime)

    PROFILE("CPPGUICombatAlienBuyMenu:Update")

    GUIAnimatedScript.Update(self, deltaTime)
    
    -- Assume there is no mouse over info to start.
    self:_HideMouseOverInfo()

    self.currentAlienDisplay.Icon:SetTexture("ui/" .. CPPGUICombatAlienBuyMenu.kAlienTypes[self.selectedAlienType].Name .. ".dds")
    local width = CPPGUICombatAlienBuyMenu.kAlienTypes[self.selectedAlienType].Width
    local height = CPPGUICombatAlienBuyMenu.kAlienTypes[self.selectedAlienType].Height
    self.currentAlienDisplay.Icon:SetSize(Vector(width, height, 0))
    self.currentAlienDisplay.Icon:SetPosition(Vector(-width / 2, -height / 2, 0) + kOffsetToCircleCenter)

    self.currentAlienDisplay.TitleShadow:SetText(CPPGUICombatAlienBuyMenu.kAlienTypes[self.selectedAlienType].LocaleName)
    self.currentAlienDisplay.Title:SetText(CPPGUICombatAlienBuyMenu.kAlienTypes[self.selectedAlienType].LocaleName)

    self:_UpdateCorners(deltaTime)
    self:_UpdateAlienButtons()
    self:_UpdateEvolveButton()
    self:_UpdateUpgrades(deltaTime)

end

function CPPGUICombatAlienBuyMenu:Uninitialize()

    GUIAnimatedScript.Uninitialize(self)

    GUI.DestroyItem(self.background)
    self.background = nil

    self.corners = { }
    self.cornerTweeners = { }

    MouseTracker_SetIsVisible(false)

end

function CPPGUICombatAlienBuyMenu:OnResolutionChanged(oldX, oldY, newX, newY)

    self:Uninitialize()
    self:Initialize()

end

function CPPGUICombatAlienBuyMenu:_InitializeBackground()

    self.background = GUIManager:CreateGraphicItem()
    self.background:SetSize( Vector(Client.GetScreenWidth(), Client.GetScreenHeight(), 0) )
    self.background:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.background:SetColor(CPPGUICombatAlienBuyMenu.kBackgroundColor)
    self.background:SetLayer(kGUILayerPlayerHUDForeground4)

    self.backgroundCenteredArea = GUIManager:CreateGraphicItem()
    self.backgroundCenteredArea:SetSize( Vector(1000, Client.GetScreenHeight(), 0) )
    self.backgroundCenteredArea:SetAnchor(GUIItem.Middle, GUIItem.Top)
    self.backgroundCenteredArea:SetPosition( Vector(-500, 0, 0) )
    self.backgroundCenteredArea:SetColor(CPPGUICombatAlienBuyMenu.kBackgroundCenterColor)
    self.background:AddChild(self.backgroundCenteredArea)

end

function CPPGUICombatAlienBuyMenu:_InitializeCorners()

    self.corners = { }

    local topLeftCorner = GUIManager:CreateGraphicItem()
    topLeftCorner:SetAnchor(GUIItem.Left, GUIItem.Top)
    topLeftCorner:SetSize(Vector(CPPGUICombatAlienBuyMenu.kCornerWidths.TopLeft, CPPGUICombatAlienBuyMenu.kCornerHeights.TopLeft, 0))
    topLeftCorner:SetTexture(CPPGUICombatAlienBuyMenu.kBuyMenuTexture)
    topLeftCorner:SetTexturePixelCoordinates(GUIUnpackCoords(CPPGUICombatAlienBuyMenu.kCornerTextureCoordinates.TopLeft))
    topLeftCorner:SetShader("shaders/GUIWavyNoMask.surface_shader")
    self.backgroundCenteredArea:AddChild(topLeftCorner)
    self.corners.TopLeft = topLeftCorner

    local bottomLeftCorner = GUIManager:CreateGraphicItem()
    bottomLeftCorner:SetAnchor(GUIItem.Left, GUIItem.Bottom)
    bottomLeftCorner:SetPosition(Vector(0, -CPPGUICombatAlienBuyMenu.kCornerHeights.BottomLeft, 0))
    bottomLeftCorner:SetSize(Vector(CPPGUICombatAlienBuyMenu.kCornerWidths.BottomLeft, CPPGUICombatAlienBuyMenu.kCornerHeights.BottomLeft, 0))
    bottomLeftCorner:SetTexture(CPPGUICombatAlienBuyMenu.kBuyMenuTexture)
    bottomLeftCorner:SetTexturePixelCoordinates(GUIUnpackCoords(CPPGUICombatAlienBuyMenu.kCornerTextureCoordinates.BottomLeft))
    bottomLeftCorner:SetShader("shaders/GUIWavyNoMask.surface_shader")
    self.backgroundCenteredArea:AddChild(bottomLeftCorner)
    self.corners.BottomLeft = bottomLeftCorner

    local topRightCorner = GUIManager:CreateGraphicItem()
    topRightCorner:SetAnchor(GUIItem.Right, GUIItem.Top)
    topRightCorner:SetPosition(Vector(-CPPGUICombatAlienBuyMenu.kCornerWidths.TopRight, 0, 0))
    topRightCorner:SetSize(Vector(CPPGUICombatAlienBuyMenu.kCornerWidths.TopRight, CPPGUICombatAlienBuyMenu.kCornerHeights.TopRight, 0))
    topRightCorner:SetTexture(CPPGUICombatAlienBuyMenu.kBuyMenuTexture)
    topRightCorner:SetTexturePixelCoordinates(GUIUnpackCoords(CPPGUICombatAlienBuyMenu.kCornerTextureCoordinates.TopRight))
    topRightCorner:SetShader("shaders/GUIWavyNoMask.surface_shader")
    self.backgroundCenteredArea:AddChild(topRightCorner)
    self.corners.TopRight = topRightCorner

    local bottomRightCorner = GUIManager:CreateGraphicItem()
    bottomRightCorner:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    bottomRightCorner:SetPosition(Vector(-CPPGUICombatAlienBuyMenu.kCornerWidths.BottomRight, -CPPGUICombatAlienBuyMenu.kCornerHeights.BottomRight, 0))
    bottomRightCorner:SetSize(Vector(CPPGUICombatAlienBuyMenu.kCornerWidths.BottomRight, CPPGUICombatAlienBuyMenu.kCornerHeights.BottomRight, 0))
    bottomRightCorner:SetTexture(CPPGUICombatAlienBuyMenu.kBuyMenuTexture)
    bottomRightCorner:SetTexturePixelCoordinates(GUIUnpackCoords(CPPGUICombatAlienBuyMenu.kCornerTextureCoordinates.BottomRight))
    bottomRightCorner:SetShader("shaders/GUIWavyNoMask.surface_shader")
    self.backgroundCenteredArea:AddChild(bottomRightCorner)
    self.corners.BottomRight = bottomRightCorner

    self.cornerTweeners = { }
    for cornerName, _ in pairs(self.corners) do
        self.cornerTweeners[cornerName] = Tweener("loopforward")
        self.cornerTweeners[cornerName].add(CPPGUICombatAlienBuyMenu.kCornerPulseTime, { percent = 1 }, Easing.linear)
        self.cornerTweeners[cornerName].add(CPPGUICombatAlienBuyMenu.kCornerPulseTime, { percent = 0 }, Easing.linear)
    end

end

function CPPGUICombatAlienBuyMenu:_InitializeBackgroundCircle()

    self.backgroundCircle = GUIManager:CreateGraphicItem()
    self.backgroundCircle:SetSize(Vector(CPPGUICombatAlienBuyMenu.kBackgroundWidth, CPPGUICombatAlienBuyMenu.kBackgroundHeight, 0))
    self.backgroundCircle:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.backgroundCircle:SetPosition(Vector((-CPPGUICombatAlienBuyMenu.kBackgroundWidth / 2) + CPPGUICombatAlienBuyMenu.kBackgroundXOffset, -CPPGUICombatAlienBuyMenu.kBackgroundHeight / 2, 0))
    self.backgroundCircle:SetTexture(CPPGUICombatAlienBuyMenu.kBuyMenuTexture)
    self.backgroundCircle:SetTexturePixelCoordinates(GUIUnpackCoords(CPPGUICombatAlienBuyMenu.kBackgroundTextureCoordinates))
    self.backgroundCircle:SetShader("shaders/GUIWavy.surface_shader")
    self.backgroundCircle:SetAdditionalTexture("wavyMask", CPPGUICombatAlienBuyMenu.kBuyMenuMaskTexture)
    self.backgroundCenteredArea:AddChild(self.backgroundCircle)

    self.backgroundCircleStencil = GUIManager:CreateGraphicItem()
    self.backgroundCircleStencil:SetIsStencil(true)
    -- This never moves and we want it to draw the stencil for the upgrade buttons.
    self.backgroundCircleStencil:SetClearsStencilBuffer(false)
    self.backgroundCircleStencil:SetSize(Vector(CPPGUICombatAlienBuyMenu.kBackgroundWidth, CPPGUICombatAlienBuyMenu.kBackgroundHeight, 0))
    self.backgroundCircleStencil:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.backgroundCircleStencil:SetPosition(Vector((-CPPGUICombatAlienBuyMenu.kBackgroundWidth / 2) + CPPGUICombatAlienBuyMenu.kBackgroundXOffset, -CPPGUICombatAlienBuyMenu.kBackgroundHeight / 2, 0))
    self.backgroundCircleStencil:SetTexture(CPPGUICombatAlienBuyMenu.kBuyMenuTexture)
    self.backgroundCircleStencil:SetTexturePixelCoordinates(GUIUnpackCoords(CPPGUICombatAlienBuyMenu.kBackgroundTextureCoordinates))
    self.backgroundCenteredArea:AddChild(self.backgroundCircleStencil)

end

function CPPGUICombatAlienBuyMenu:_InitializeCurrentAlienDisplay()

    self.currentAlienDisplay = { }

    self.currentAlienDisplay.Icon = GUIManager:CreateGraphicItem()
    self.currentAlienDisplay.Icon:SetAnchor(GUIItem.Middle, GUIItem.Center)
    local width = CPPGUICombatAlienBuyMenu.kAlienTypes[AlienBuy_GetCurrentAlien()].Width
    local height = CPPGUICombatAlienBuyMenu.kAlienTypes[AlienBuy_GetCurrentAlien()].Height
    self.currentAlienDisplay.Icon:SetSize(Vector(width, height, 0))
    self.currentAlienDisplay.Icon:SetPosition(Vector(-width / 2, -height / 2, 0) + kOffsetToCircleCenter)
    self.currentAlienDisplay.Icon:SetTexture("ui/" .. CPPGUICombatAlienBuyMenu.kAlienTypes[AlienBuy_GetCurrentAlien()].Name .. ".dds")
    --self.currentAlienDisplay.Icon:SetLayer(kGUILayerPlayerHUDForeground2)
    self.backgroundCircle:AddChild(self.currentAlienDisplay.Icon)

    self.currentAlienDisplay.TitleShadow = GUIManager:CreateTextItem()
    self.currentAlienDisplay.TitleShadow:SetAnchor(GUIItem.Middle, GUIItem.Top)
    self.currentAlienDisplay.TitleShadow:SetPosition(CPPGUICombatAlienBuyMenu.kCurrentAlienTitleOffset + kOffsetToCircleCenter)
    self.currentAlienDisplay.TitleShadow:SetFontName(kLargeFont)
    self.currentAlienDisplay.TitleShadow:SetScale(GetScaledVector())
    GUIMakeFontScale(self.currentAlienDisplay.TitleShadow)
    self.currentAlienDisplay.TitleShadow:SetTextAlignmentX(GUIItem.Align_Center)
    self.currentAlienDisplay.TitleShadow:SetTextAlignmentY(GUIItem.Align_Min)
    self.currentAlienDisplay.TitleShadow:SetText(CPPGUICombatAlienBuyMenu.kAlienTypes[AlienBuy_GetCurrentAlien()].LocaleName)
    self.currentAlienDisplay.TitleShadow:SetColor(Color(0, 0, 0, 1))
    --self.currentAlienDisplay.TitleShadow:SetLayer(kGUILayerPlayerHUDForeground3)
    self.backgroundCircle:AddChild(self.currentAlienDisplay.TitleShadow)

    self.currentAlienDisplay.Title = GUIManager:CreateTextItem()
    self.currentAlienDisplay.Title:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.currentAlienDisplay.Title:SetPosition(Vector(-2, -2, 0))
    self.currentAlienDisplay.Title:SetFontName(kLargeFont)
    self.currentAlienDisplay.Title:SetScale(GetScaledVector())
    GUIMakeFontScale(self.currentAlienDisplay.Title)
    self.currentAlienDisplay.Title:SetTextAlignmentX(GUIItem.Align_Center)
    self.currentAlienDisplay.Title:SetTextAlignmentY(GUIItem.Align_Min)
    self.currentAlienDisplay.Title:SetText(CPPGUICombatAlienBuyMenu.kAlienTypes[AlienBuy_GetCurrentAlien()].LocaleName)
    self.currentAlienDisplay.Title:SetColor(ColorIntToColor(kAlienTeamColor))
    --self.currentAlienDisplay.Title:SetLayer(kGUILayerPlayerHUDForeground3)
    self.currentAlienDisplay.TitleShadow:AddChild(self.currentAlienDisplay.Title)

end

function CPPGUICombatAlienBuyMenu:_InitializeMouseOverInfo()

    self.mouseOverTitle = GUIManager:CreateTextItem()
    self.mouseOverTitle:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.mouseOverTitle:SetPosition(CPPGUICombatAlienBuyMenu.kMouseOverTitleOffset)
    self.mouseOverTitle:SetFontName(kLargeFont)
    self.mouseOverTitle:SetScale(GetScaledVector())
    GUIMakeFontScale(self.mouseOverTitle)
    self.mouseOverTitle:SetTextAlignmentX(GUIItem.Align_Min)
    self.mouseOverTitle:SetTextAlignmentY(GUIItem.Align_Min)
    self.mouseOverTitle:SetText(CPPGUICombatAlienBuyMenu.kAlienTypes[AlienBuy_GetCurrentAlien()].LocaleName)
    self.mouseOverTitle:SetColor(ColorIntToColor(kAlienTeamColor))
    self.mouseOverTitle:SetIsVisible(false)
    self.backgroundCenteredArea:AddChild(self.mouseOverTitle)

    self.mouseOverInfo = GUIManager:CreateTextItem()
    self.mouseOverInfo:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.mouseOverInfo:SetPosition(CPPGUICombatAlienBuyMenu.kMouseOverInfoOffset)
    self.mouseOverInfo:SetFontName(kFont)
    self.mouseOverInfo:SetScale(GetScaledVector())
    GUIMakeFontScale(self.mouseOverInfo)
    self.mouseOverInfo:SetTextAlignmentX(GUIItem.Align_Min)
    self.mouseOverInfo:SetTextAlignmentY(GUIItem.Align_Min)
    self.mouseOverInfo:SetColor(ColorIntToColor(kAlienTeamColor))
    -- Only visible on mouse over.
    self.mouseOverInfo:SetIsVisible(false)
    self.backgroundCenteredArea:AddChild(self.mouseOverInfo)

    self.mouseOverInfoResIcon = GUIManager:CreateGraphicItem()
    self.mouseOverInfoResIcon:SetSize(Vector(CPPGUICombatAlienBuyMenu.kResourceIconWidth, CPPGUICombatAlienBuyMenu.kResourceIconHeight, 0))
    -- Anchor to parent's left so we can hard-code "float" distance
    self.mouseOverInfoResIcon:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.mouseOverInfoResIcon:SetPosition(CPPGUICombatAlienBuyMenu.kMouseOverInfoResIconOffset)
    self.mouseOverInfoResIcon:SetTexture(CPPGUICombatAlienBuyMenu.kResourceIconTexture)
    self.mouseOverInfoResIcon:SetColor(kIconColors[kAlienTeamType])
    self.mouseOverInfoResIcon:SetIsVisible(false)
    self.mouseOverInfoResIcon:SetInheritsParentScaling(false)
    self.backgroundCenteredArea:AddChild(self.mouseOverInfoResIcon)

    local kStatsPadding = Vector(GUIScale(5), 0, 0)
    self.mouseOverInfoResAmount = GUIManager:CreateTextItem()
    self.mouseOverInfoResAmount:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.mouseOverInfoResAmount:SetFontName(kFont)
    self.mouseOverInfoResAmount:SetScale(GetScaledVector())
    GUIMakeFontScale(self.mouseOverInfoResAmount)
    self.mouseOverInfoResAmount:SetTextAlignmentX(GUIItem.Align_Min)
    self.mouseOverInfoResAmount:SetTextAlignmentY(GUIItem.Align_Min)
    self.mouseOverInfoResAmount:SetPosition(kStatsPadding)
    self.mouseOverInfoResAmount:SetColor(ColorIntToColor(kAlienTeamColor))
    self.mouseOverInfoResIcon:AddChild(self.mouseOverInfoResAmount)

    -- Create health and armor icons and text
    self.mouseOverInfoHealthIcon = GUIManager:CreateGraphicItem()
    self.mouseOverInfoHealthIcon:SetSize(Vector(CPPGUICombatAlienBuyMenu.kResourceIconWidth, CPPGUICombatAlienBuyMenu.kResourceIconHeight, 0))
    self.mouseOverInfoHealthIcon:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.mouseOverInfoHealthIcon:SetInheritsParentScaling(false)
    self.mouseOverInfoHealthIcon:SetPosition(kStatsPadding)
    self.mouseOverInfoHealthIcon:SetTexture(CPPGUICombatAlienBuyMenu.kBuyMenuTexture)
    self.mouseOverInfoHealthIcon:SetTexturePixelCoordinates(GUIUnpackCoords(CPPGUICombatAlienBuyMenu.kHealthIconTextureCoordinates))
    self.mouseOverInfoHealthIcon:SetIsVisible(false)
    self.mouseOverInfoResAmount:AddChild(self.mouseOverInfoHealthIcon)

    self.mouseOverInfoHealthAmount = GUIManager:CreateTextItem()
    self.mouseOverInfoHealthAmount:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.mouseOverInfoHealthAmount:SetFontName(kFont)
    self.mouseOverInfoHealthAmount:SetScale(GetScaledVector())
    GUIMakeFontScale(self.mouseOverInfoHealthAmount)
    self.mouseOverInfoHealthAmount:SetTextAlignmentX(GUIItem.Align_Min)
    self.mouseOverInfoHealthAmount:SetTextAlignmentY(GUIItem.Align_Min)
    self.mouseOverInfoHealthAmount:SetPosition(kStatsPadding)
    self.mouseOverInfoHealthAmount:SetColor(ColorIntToColor(kAlienTeamColor))
    self.mouseOverInfoHealthIcon:AddChild(self.mouseOverInfoHealthAmount)

    self.mouseOverInfoArmorIcon = GUIManager:CreateGraphicItem()
    self.mouseOverInfoArmorIcon:SetSize(Vector(CPPGUICombatAlienBuyMenu.kResourceIconWidth, CPPGUICombatAlienBuyMenu.kResourceIconHeight, 0))
    self.mouseOverInfoArmorIcon:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.mouseOverInfoArmorIcon:SetPosition(kStatsPadding)
    self.mouseOverInfoArmorIcon:SetTexture(CPPGUICombatAlienBuyMenu.kBuyMenuTexture)
    self.mouseOverInfoArmorIcon:SetTexturePixelCoordinates(GUIUnpackCoords(CPPGUICombatAlienBuyMenu.kArmorIconTextureCoordinates))
    self.mouseOverInfoArmorIcon:SetIsVisible(false)
    self.mouseOverInfoArmorIcon:SetInheritsParentScaling(false)
    self.mouseOverInfoHealthAmount:AddChild(self.mouseOverInfoArmorIcon)

    self.mouseOverInfoArmorAmount = GUIManager:CreateTextItem()
    self.mouseOverInfoArmorAmount:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.mouseOverInfoArmorAmount:SetFontName(kFont)
    self.mouseOverInfoArmorAmount:SetScale(GetScaledVector())
    GUIMakeFontScale(self.mouseOverInfoArmorAmount)
    self.mouseOverInfoArmorAmount:SetTextAlignmentX(GUIItem.Align_Min)
    self.mouseOverInfoArmorAmount:SetTextAlignmentY(GUIItem.Align_Min)
    self.mouseOverInfoArmorAmount:SetPosition(kStatsPadding)
    self.mouseOverInfoArmorAmount:SetColor(ColorIntToColor(kAlienTeamColor))
    self.mouseOverInfoArmorIcon:AddChild(self.mouseOverInfoArmorAmount)

end

function CPPGUICombatAlienBuyMenu:_InitializeUpgradeButtons()

    -- There are purchased and unpurchased buttons. Both are managed in this list.
    self.upgradeButtons = { }

    local upgrades = AlienUI_GetPersonalUpgrades()

    for i = 1, #self.slots do

        local upgrades = AlienUI_GetUpgradesForCategory(self.slots[i].Category)
        local offsetAngle = self.slots[i].Angle
        local anglePerUpgrade = math.pi * 0.25 / 3
        local category = self.slots[i].Category

        for upgradeIndex = 1, #upgrades do

            local angle = offsetAngle + anglePerUpgrade * (upgradeIndex-1) - anglePerUpgrade
            local techId = upgrades[upgradeIndex]

            -- Every upgrade has an icon.
            local buttonIcon = GUIManager:CreateGraphicItem()
            buttonIcon:SetAnchor(GUIItem.Middle, GUIItem.Center)
            buttonIcon:SetSize(Vector(CPPGUICombatAlienBuyMenu.kUpgradeButtonSize, CPPGUICombatAlienBuyMenu.kUpgradeButtonSize, 0))
            buttonIcon:SetPosition(Vector(-CPPGUICombatAlienBuyMenu.kUpgradeButtonSize / 2, CPPGUICombatAlienBuyMenu.kUpgradeButtonSize, 0))
            buttonIcon:SetTexture(CPPGUICombatAlienBuyMenu.kBuyHUDTexture)

            local iconX, iconY = GetMaterialXYOffset(techId, false)
            iconX = iconX * CPPGUICombatAlienBuyMenu.kUpgradeButtonTextureSize
            iconY = iconY * CPPGUICombatAlienBuyMenu.kUpgradeButtonTextureSize
            buttonIcon:SetTexturePixelCoordinates(iconX, iconY, iconX + CPPGUICombatAlienBuyMenu.kUpgradeButtonTextureSize, iconY + CPPGUICombatAlienBuyMenu.kUpgradeButtonTextureSize)

            -- Render above the Alien image.
            --buttonIcon:SetLayer(kGUILayerPlayerHUDForeground3)
            self.backgroundCircle:AddChild(buttonIcon)

            local unselectedPosition = Vector( math.cos(angle) * CPPGUICombatAlienBuyMenu.kUpgradeButtonDistance - CPPGUICombatAlienBuyMenu.kUpgradeButtonSize * .5, math.sin(angle) * CPPGUICombatAlienBuyMenu.kUpgradeButtonDistance - CPPGUICombatAlienBuyMenu.kUpgradeButtonSize * .5, 0 ) + kOffsetToCircleCenter

            buttonIcon:SetPosition(unselectedPosition)

            local purchased = AlienBuy_GetUpgradePurchased(techId)
            if purchased then
                table.insertunique(self.upgradeList, techId)
            end

            table.insert(self.upgradeButtons, { Background = nil, Icon = buttonIcon, TechId = techId, Category = category,
                Selected = purchased, SelectedMovePercent = 0, Cost = 0, Purchased = purchased, Index = nil,
                UnselectedPosition = unselectedPosition, SelectedPosition = self.slots[i].Graphic:GetPosition()  })

        end

    end

end

local function CreateSlot(self, category)

    local graphic = GUIManager:CreateGraphicItem()
    graphic:SetSize(Vector(CPPGUICombatAlienBuyMenu.kSlotSize, CPPGUICombatAlienBuyMenu.kSlotSize, 0))
    graphic:SetTexture(CPPGUICombatAlienBuyMenu.kSlotTexture)
    --graphic:SetLayer(kGUILayerPlayerHUDForeground3)
    graphic:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.backgroundCircle:AddChild(graphic)

    table.insert(self.slots, { Graphic = graphic, Category = category } )


end

function CPPGUICombatAlienBuyMenu:_InitializeSlots()

    self.slots = {}

    CreateSlot(self, kTechId.CragHive)
    CreateSlot(self, kTechId.ShadeHive)
    CreateSlot(self, kTechId.ShiftHive)

    local anglePerSlot = (math.pi * 0.6) / (#self.slots-1)

    for i = 1, #self.slots do

        local angle = (i-1) * anglePerSlot + math.pi * 0.2
        local distance = CPPGUICombatAlienBuyMenu.kSlotDistance

        self.slots[i].Graphic:SetPosition( Vector( math.cos(angle) * distance - CPPGUICombatAlienBuyMenu.kSlotSize * .5, math.sin(angle) * distance - CPPGUICombatAlienBuyMenu.kSlotSize * .5, 0) + kOffsetToCircleCenter )
        self.slots[i].Angle = angle

    end


end

local function CreateAbilityIcon(self, alienGraphicItem, techId)

    local graphicItem = GetGUIManager():CreateGraphicItem()
    graphicItem:SetTexture(CPPGUICombatAlienBuyMenu.kAbilityIcons)
    graphicItem:SetSize(Vector(CPPGUICombatAlienBuyMenu.kUpgradeButtonSize, CPPGUICombatAlienBuyMenu.kUpgradeButtonSize, 0))
    graphicItem:SetAnchor(GUIItem.Left, GUIItem.Bottom)
    graphicItem:SetTexturePixelCoordinates(GUIUnpackCoords(GetTextureCoordinatesForIcon(techId, false)))
    graphicItem:SetColor(kIconColors[kAlienTeamType])

    local highLight = GetGUIManager():CreateGraphicItem()
    highLight:SetSize(Vector(CPPGUICombatAlienBuyMenu.kUpgradeButtonSize, CPPGUICombatAlienBuyMenu.kUpgradeButtonSize, 0))
    highLight:SetIsVisible(false)
    highLight:SetTexture(CPPGUICombatAlienBuyMenu.kBuyMenuTexture)
    highLight:SetTexturePixelCoordinates(GUIUnpackCoords(CPPGUICombatAlienBuyMenu.kUpgradeButtonBackgroundTextureCoordinates))

    graphicItem:AddChild(highLight)
    alienGraphicItem:AddChild(graphicItem)

    return { Icon = graphicItem, TechId = techId, HighLight = highLight }

end

local function CreateAbilityIcons(self, alienGraphicItem, alienType)

    local lifeFormTechId = IndexToAlienTechId(alienType.Index)
    local availableAbilities = GetTechForCategory(lifeFormTechId)

    local numAbilities = #availableAbilities

    for i = 1, numAbilities do

        local techId = availableAbilities[#availableAbilities - i + 1]
        local ability = CreateAbilityIcon(self, alienGraphicItem, techId)
        local xPos = 10
        local yPos = ( (i - 1) * CPPGUICombatAlienBuyMenu.kUpgradeButtonSize ) + 10

        ability.Icon:SetPosition(Vector(xPos, yPos, 0))
        table.insert(self.abilityIcons, ability)

    end

end

function CPPGUICombatAlienBuyMenu:_InitializeAlienButtons()

    self.alienButtons = { }

    for k, alienType in ipairs(CPPGUICombatAlienBuyMenu.kAlienTypes) do

        -- The alien image.
        local alienGraphicItem = GUIManager:CreateGraphicItem()
        local ARAdjustedHeight = (alienType.Height / alienType.Width) * CPPGUICombatAlienBuyMenu.kAlienButtonSize
        alienGraphicItem:SetSize(Vector(CPPGUICombatAlienBuyMenu.kAlienButtonSize, ARAdjustedHeight, 0))
        alienGraphicItem:SetAnchor(GUIItem.Middle, GUIItem.Center)
        alienGraphicItem:SetPosition(Vector(-CPPGUICombatAlienBuyMenu.kAlienButtonSize / 2, -ARAdjustedHeight / 2, 0))
        alienGraphicItem:SetTexture("ui/" .. alienType.Name .. ".dds")
        --alienGraphicItem:SetIsVisible(AlienBuy_IsAlienResearched(alienType.Index))

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
        playersText:SetPosition(Vector(0, -CPPGUICombatAlienBuyMenu.kPlayersTextSize, 0))
        alienGraphicItem:AddChild(playersText)

        -- Create the selected background item for this alien item.
        local selectedBackground = GUIManager:CreateGraphicItem()
        selectedBackground:SetAnchor(GUIItem.Middle, GUIItem.Center)
        selectedBackground:SetSize(Vector(CPPGUICombatAlienBuyMenu.kAlienSelectedButtonSize, CPPGUICombatAlienBuyMenu.kAlienSelectedButtonSize, 0))
        selectedBackground:SetTexture(CPPGUICombatAlienBuyMenu.kAlienSelectedBackground)
        -- Hide the selected background for now.
        selectedBackground:SetColor(Color(1, 1, 1, 0))
        selectedBackground:AddChild(alienGraphicItem)

        table.insert(self.alienButtons, { TypeData = alienType, Button = alienGraphicItem, SelectedBackground = selectedBackground, PlayersText = playersText, ARAdjustedHeight = ARAdjustedHeight })

        CreateAbilityIcons(self, alienGraphicItem, alienType)

        self.backgroundCenteredArea:AddChild(selectedBackground)

    end

    self:_UpdateAlienButtons()

end

function CPPGUICombatAlienBuyMenu:_InitializeEvolveButton()

    self.evolveButtonBackground = GUIManager:CreateGraphicItem()
    self.evolveButtonBackground:SetAnchor(GUIItem.Middle, GUIItem.Bottom)
    self.evolveButtonBackground:SetSize(Vector(CPPGUICombatAlienBuyMenu.kEvolveButtonWidth, CPPGUICombatAlienBuyMenu.kEvolveButtonHeight, 0))
    self.evolveButtonBackground:SetPosition(Vector(-CPPGUICombatAlienBuyMenu.kEvolveButtonWidth / 2, (CPPGUICombatAlienBuyMenu.kEvolveButtonHeight / 2 + CPPGUICombatAlienBuyMenu.kEvolveButtonYOffset) * -1, 0))
    self.evolveButtonBackground:SetTexture(CPPGUICombatAlienBuyMenu.kBuyMenuTexture)
    self.evolveButtonBackground:SetTexturePixelCoordinates(GUIUnpackCoords(CPPGUICombatAlienBuyMenu.kEvolveButtonTextureCoordinates))
    self.backgroundCenteredArea:AddChild(self.evolveButtonBackground)

    self.evolveButtonVeins = GUIManager:CreateGraphicItem()
    self.evolveButtonVeins:SetSize(Vector(CPPGUICombatAlienBuyMenu.kEvolveButtonWidth - kVeinsMargin * 2, CPPGUICombatAlienBuyMenu.kEvolveButtonHeight - kVeinsMargin * 2, 0))
    self.evolveButtonVeins:SetPosition(Vector(kVeinsMargin, kVeinsMargin, 0))
    self.evolveButtonVeins:SetTexture(CPPGUICombatAlienBuyMenu.kBuyMenuTexture)
    self.evolveButtonVeins:SetTexturePixelCoordinates(GUIUnpackCoords(CPPGUICombatAlienBuyMenu.kEvolveButtonVeinsTextureCoordinates))
    self.evolveButtonVeins:SetColor(Color(1, 1, 1, 0))
    self.evolveButtonBackground:AddChild(self.evolveButtonVeins)

    self.evolveButtonText = GUIManager:CreateTextItem()
    self.evolveButtonText:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.evolveButtonText:SetFontName(kFont)
    self.evolveButtonText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.evolveButtonText)
    self.evolveButtonText:SetTextAlignmentX(GUIItem.Align_Center)
    self.evolveButtonText:SetTextAlignmentY(GUIItem.Align_Center)
    self.evolveButtonText:SetText(Locale.ResolveString("ABM_EVOLVE_FOR"))
    self.evolveButtonText:SetColor(Color(0, 0, 0, 1))
    self.evolveButtonText:SetPosition(Vector(0, 0, 0))
    self.evolveButtonVeins:AddChild(self.evolveButtonText)

    self.evolveResourceIcon = GUIManager:CreateGraphicItem()
    self.evolveResourceIcon:SetSize(Vector(CPPGUICombatAlienBuyMenu.kResourceIconWidth, CPPGUICombatAlienBuyMenu.kResourceIconHeight, 0))
    self.evolveResourceIcon:SetAnchor(GUIItem.Middle, GUIItem.Top)
    self.evolveResourceIcon:SetPosition(Vector(0, -CPPGUICombatAlienBuyMenu.kResourceIconHeight / 2, 0))
    self.evolveResourceIcon:SetTexture(CPPGUICombatAlienBuyMenu.kResourceIconTexture)
    self.evolveResourceIcon:SetColor(Color(0, 0, 0, 1))
    self.evolveResourceIcon:SetIsVisible(false)
    self.evolveResourceIcon:SetInheritsParentScaling(false)
    self.evolveButtonText:AddChild(self.evolveResourceIcon)

    self.evolveButtonResAmount = GUIManager:CreateTextItem()
    self.evolveButtonResAmount:SetAnchor(GUIItem.Right, GUIItem.Center)
    self.evolveButtonResAmount:SetPosition(Vector(0, 0, 0))
    self.evolveButtonResAmount:SetFontName(kFont)
    self.evolveButtonResAmount:SetScale(GetScaledVector())
    GUIMakeFontScale(self.evolveButtonResAmount)
    self.evolveButtonResAmount:SetTextAlignmentX(GUIItem.Align_Min)
    self.evolveButtonResAmount:SetTextAlignmentY(GUIItem.Align_Center)
    self.evolveButtonResAmount:SetColor(Color(0, 0, 0, 1))
    self.evolveButtonResAmount:SetInheritsParentScaling(false)
    self.evolveResourceIcon:AddChild(self.evolveButtonResAmount)

end

function CPPGUICombatAlienBuyMenu:_InitializeHeaders()

    self.lifeformHeaderText = GetGUIManager():CreateTextItem()
    self.lifeformHeaderText:SetFontName(CPPGUICombatAlienBuyMenu.kHeaderFont)
    self.lifeformHeaderText:SetFontIsBold(true)
    self.lifeformHeaderText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.lifeformHeaderText)
    self.lifeformHeaderText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.lifeformHeaderText:SetPosition( Vector(60, 148, 0) )
    self.lifeformHeaderText:SetTextAlignmentX(GUIItem.Align_Min)
    self.lifeformHeaderText:SetTextAlignmentY(GUIItem.Align_Center)
    self.lifeformHeaderText:SetColor(CPPGUICombatAlienBuyMenu.kTextColor)
    self.lifeformHeaderText:SetText("Lifeforms")
    self.lifeformHeaderText:SetIsVisible(true)
    self.backgroundCenteredArea:AddChild(self.lifeformHeaderText)

end

function CPPGUICombatAlienBuyMenu:_UpdateCorners(deltaTime)

    for _, cornerName in ipairs(self.corners) do
        self.cornerTweeners[cornerName].update(deltaTime)
        local percent = self.cornerTweeners[cornerName].getCurrentProperties().percent
        self.corners[cornerName]:SetColor(Color(1, percent, percent, math.abs(percent - 0.5) + 0.5))
    end

end

function CPPGUICombatAlienBuyMenu:_UpdateAlienButtons()

    local numAlienTypes = 5
    local totalAlienButtonsWidth = CPPGUICombatAlienBuyMenu.kAlienButtonSize * numAlienTypes
    local player = Client.GetLocalPlayer()

    for k, alienButton in ipairs(self.alienButtons) do

        -- Info needed for the rest of this code.
        local itemTechId = alienButton.TypeData.TechId
        local cost = CombatPlusPlus_GetCostByTechId(itemTechId)
        local isCurrentAlien = AlienBuy_GetCurrentAlien() == alienButton.TypeData.Index
        local canAfford = cost <= player.combatSkillPoints
        local hasRequiredRank = CombatPlusPlus_GetRequiredRankByTechId(itemTechId) <= player.combatRank

        alienButton.Button:SetIsVisible(true)

        if hasRequiredRank and canAfford and not isCurrentAlien then
            alienButton.Button:SetColor(CPPGUICombatAlienBuyMenu.kEnabledColor)
        elseif hasRequiredRank and not canAfford then
            alienButton.Button:SetColor(CPPGUICombatAlienBuyMenu.kCannotBuyColor)
        elseif not hasRequiredRank then
            alienButton.Button:SetColor(CPPGUICombatAlienBuyMenu.kDisabledColor)
        end

        local mouseOver = self:_GetIsMouseOver(alienButton.Button)

        if mouseOver then

            local classStats = AlienBuy_GetClassStats(CPPGUICombatAlienBuyMenu.kAlienTypes[alienButton.TypeData.Index].Index)
            local mouseOverName = CPPGUICombatAlienBuyMenu.kAlienTypes[alienButton.TypeData.Index].LocaleName
            local health = classStats[2]
            local armor = classStats[3]
            self:_ShowMouseOverInfo(mouseOverName, GetTooltipInfoText(IndexToAlienTechId(alienButton.TypeData.Index)), classStats[4], health, armor)

        end

        -- Only show the background if the mouse is over this button.
        alienButton.SelectedBackground:SetColor(Color(1, 1, 1, ((mouseOver and 1) or 0)))

        --local offset = Vector((((alienButton.TypeData.XPos - 1) / numAlienTypes) * (CPPGUICombatAlienBuyMenu.kAlienButtonSize * numAlienTypes)) - (totalAlienButtonsWidth / 2), 120, 0)
        local offset = Vector(-450, (((alienButton.TypeData.XPos - 1) / numAlienTypes) * (CPPGUICombatAlienBuyMenu.kAlienButtonSize * numAlienTypes)) - (totalAlienButtonsWidth / 2) + 150, 0)
        alienButton.SelectedBackground:SetPosition(Vector(-CPPGUICombatAlienBuyMenu.kAlienButtonSize / 2, -CPPGUICombatAlienBuyMenu.kAlienSelectedButtonSize / 2 - alienButton.ARAdjustedHeight / 2, 0) + offset)

        alienButton.PlayersText:SetText("x" .. ToString(ScoreboardUI_GetNumberOfAliensByType(alienButton.TypeData.Name)))

    end

end

function CPPGUICombatAlienBuyMenu:_UpdateEvolveButton()

    local player = Client.GetLocalPlayer()
    local numberOfSelectedUpgrades = GetNumberOfNewlySelectedUpgrades(self)
    local evolveButtonTextureCoords = GUIAlienBuyMenu.kEvolveButtonTextureCoordinates
    local evolveCost = GetTotalCost(self)
    local canAfford = evolveCost <= player.combatSkillPoints
    local allowedToEvolve = false
    local hasGameStarted = PlayerUI_GetHasGameStarted()
    local evolveText = Locale.ResolveString("ABM_GAME_NOT_STARTED")

    if hasGameStarted then

        evolveText = Locale.ResolveString("ABM_SELECT_UPGRADES")

        -- If the current alien is selected with no upgrades, cannot evolve.
        if self.selectedAlienType == AlienBuy_GetCurrentAlien() and numberOfSelectedUpgrades == 0 then

            evolveButtonTextureCoords = CPPGUICombatAlienBuyMenu.kEvolveButtonNeedResourcesTextureCoordinates

        elseif not canAfford then

            -- If cannot afford selected alien type and/or upgrades, cannot evolve.
            evolveButtonTextureCoords = CPPGUICombatAlienBuyMenu.kEvolveButtonNeedResourcesTextureCoordinates
            evolveText = "Need More Skill Points"

        else

            evolveText = Locale.ResolveString("ABM_EVOLVE_FOR")
            allowedToEvolve = true

        end

    end

    self.evolveButtonBackground:SetTexturePixelCoordinates(GUIUnpackCoords(evolveButtonTextureCoords))
    self.evolveButtonText:SetText(evolveText)
    self.evolveResourceIcon:SetIsVisible(evolveCost ~= nil)
    local totalEvolveButtonTextWidth = 0

    if evolveCost ~= nil then

        local evolveCostText = ToString(evolveCost)
        self.evolveButtonResAmount:SetText(evolveCostText)
        totalEvolveButtonTextWidth = totalEvolveButtonTextWidth + self.evolveResourceIcon:GetScaledSize().x + GUIScale(self.evolveButtonResAmount:GetTextWidth(evolveCostText))

    end

    self.evolveButtonText:SetPosition(Vector(-totalEvolveButtonTextWidth / 2, 0, 0))

    local veinsAlpha = 0
    self.evolveButtonBackground:SetScale(Vector(1, 1, 0))

    if allowedToEvolve then

        if self:_GetIsMouseOver(self.evolveButtonBackground) then

            veinsAlpha = 1
            self.evolveButtonBackground:SetScale(Vector(1.1, 1.1, 0))

        else
            veinsAlpha = (math.sin(Shared.GetTime() * 4) + 1) / 2
        end

    end

    self.evolveButtonVeins:SetColor(Color(1, 1, 1, veinsAlpha))

end

local function GetHasAnyCategoryUpgrade(category, player)

    local upgrades = AlienUI_GetUpgradesForCategory(category)

    for i = 1, #upgrades do

        if CombatPlusPlus_GetRequiredRankByTechId(upgrades[i]) <= player.combatRank then
            return true
        end
    end

    return false

end

local kDefaultColor = Color(kIconColors[kAlienTeamType])
local kNotAvailableColor = Color(0.0, 0.0, 0.0, 1)
local kNotAllowedColor = Color(1, 0,0,1)
local kPurchasedColor = Color(1, 0.6, 0, 1)

function CPPGUICombatAlienBuyMenu:_UpdateUpgrades(deltaTime)

    local categoryHasSelected = {}
    local player = Client.GetLocalPlayer()

    for i, currentButton in ipairs(self.upgradeButtons) do

        local cost = CombatPlusPlus_GetCostByTechId(currentButton.TechId)
        local canAfford = cost <= player.combatSkillPoints
        local hasRequiredRank = CombatPlusPlus_GetRequiredRankByTechId(currentButton.TechId) <= player.combatRank

        local useColor = kDefaultColor

        if currentButton.Purchased then

            useColor = kPurchasedColor

        elseif not hasRequiredRank then

            useColor = kNotAvailableColor

            -- unselect button if tech becomes unavailable
            if currentButton.Selected then
                currentButton.Selected = false
            end

        end

        currentButton.Icon:SetColor(useColor)

        if currentButton.Selected then
            categoryHasSelected[ currentButton.Category ] = true
            currentButton.Icon:SetPosition(currentButton.SelectedPosition)
        else
            currentButton.Icon:SetPosition(currentButton.UnselectedPosition)
        end

        if self:_GetIsMouseOver(currentButton.Icon) then
        
            local currentUpgradeInfoText = GetDisplayNameForTechId(currentButton.TechId)
            local tooltipText = GetTooltipInfoText(currentButton.TechId)
        
            local health = LookupTechData(currentButton.TechId, kTechDataMaxHealth)
            local armor = LookupTechData(currentButton.TechId, kTechDataMaxArmor)
            local cost = CombatPlusPlus_GetCostByTechId(currentButton.TechId)
        
            self:_ShowMouseOverInfo(currentUpgradeInfoText, tooltipText, cost)
        
        end

    end


    for i, slot in ipairs(self.slots) do

        if categoryHasSelected[ slot.Category ] or GetHasAnyCategoryUpgrade(slot.Category, player) then
            slot.Graphic:SetTexture(CPPGUICombatAlienBuyMenu.kSlotTexture)
        else
            slot.Graphic:SetTexture(CPPGUICombatAlienBuyMenu.kSlotLockedTexture)
        end

    end

end

function CPPGUICombatAlienBuyMenu:_ShowMouseOverInfo(lifeformText, infoText, costAmount, health, armor)

    self.mouseOverTitle:SetIsVisible(true)
    self.mouseOverTitle:SetText(lifeformText)
    self.mouseOverTitle:SetTextClipped(true, kTooltipTextWidth, 1024)

    self.mouseOverInfo:SetIsVisible(true)
    self.mouseOverInfo:SetText(infoText)
    self.mouseOverInfo:SetTextClipped(true, kTooltipTextWidth, 1024)

    self.mouseOverInfoResIcon:SetIsVisible(costAmount ~= nil)

    self.mouseOverInfoHealthIcon:SetIsVisible(health ~= nil)
    self.mouseOverInfoArmorIcon:SetIsVisible(health ~= nil)

    self.mouseOverInfoHealthAmount:SetIsVisible(armor ~= nil)
    self.mouseOverInfoArmorAmount:SetIsVisible(armor ~= nil)

    if costAmount then
        self.mouseOverInfoResAmount:SetText(ToString(costAmount))
    end

    if health then
        self.mouseOverInfoHealthAmount:SetText(ToString(health))
    end

    if armor then
        self.mouseOverInfoArmorAmount:SetText(ToString(armor))
    end

end

function CPPGUICombatAlienBuyMenu:_HideMouseOverInfo()

    self.mouseOverTitle:SetIsVisible(false)
    self.mouseOverInfo:SetIsVisible(false)
    self.mouseOverInfoResIcon:SetIsVisible(false)
    self.mouseOverInfoHealthIcon:SetIsVisible(false)
    self.mouseOverInfoArmorIcon:SetIsVisible(false)
    self.mouseOverInfoHealthAmount:SetIsVisible(false)
    self.mouseOverInfoArmorAmount:SetIsVisible(false)

end

local function MarkAlreadyPurchased( self )
    local isAlreadySelectedAlien = self.selectedAlienType ~= AlienBuy_GetCurrentAlien()
    for i, currentButton in ipairs(self.upgradeButtons) do
        currentButton.Purchased = isAlreadySelectedAlien and AlienBuy_GetUpgradePurchased( currentButton.TechId )
    end
end

local function SelectButton( self, button )
    if not button.Selected then
        button.Selected = true
        table.insertunique(self.upgradeList, button.TechId)
    end
end

local function DeselectButton( self, button )
    if button.Selected then
        button.Selected = false
        table.removevalue( self.upgradeList, button.TechId )
    end
end

local function ToggleButton( self,  button )
    if button.Selected then
        DeselectButton( self, button )
    else
        SelectButton( self, button )
    end
end

function CPPGUICombatAlienBuyMenu:SetPurchasedSelected()

    for i, button in ipairs(self.upgradeButtons) do
        if button.Purchased then
            SelectButton( self, button )
        else
            DeselectButton( self, button )
        end
    end

end

function CPPGUICombatAlienBuyMenu:SendKeyEvent(key, down)

    local closeMenu = false
    local inputHandled = false

    if key == InputKey.MouseButton0 and self.mousePressed ~= down then

        self.mousePressed = down

        local mouseX, mouseY = Client.GetCursorPosScreen()
        local player = Client.GetLocalPlayer()

        if down then

            local numberOfSelectedUpgrades = GetNumberOfNewlySelectedUpgrades(self)
            local evolveCost = GetTotalCost(self)
            local canAfford = evolveCost <= player.combatSkillPoints

            local allowedToEvolve = canAfford and (self.selectedAlienType ~= AlienBuy_GetCurrentAlien() or  numberOfSelectedUpgrades > 0)
            if allowedToEvolve and self:_GetIsMouseOver(self.evolveButtonBackground) then

                local purchases = { }
                -- Buy the selected alien if we have a different one selected.
                if self.selectedAlienType ~= AlienBuy_GetCurrentAlien() then
                    table.insert(purchases, { Type = "Alien", Alien = self.selectedAlienType })
                end

                -- Buy all selected upgrades.
                for i, currentButton in ipairs(self.upgradeButtons) do

                    if currentButton.Selected then
                        table.insert(purchases, { Type = "Upgrade", Alien = self.selectedAlienType, UpgradeIndex = currentButton.Index, TechId = currentButton.TechId })
                    end

                end

                closeMenu = true
                inputHandled = true

                if #purchases > 0 then
                    Shared.Message(string.format("Purchase Count: %s", #purchases))
                    CombatPlusPlus_AlienPurchase(purchases)
                end

                AlienBuy_OnPurchase()

            end

            inputHandled = self:_HandleUpgradeClicked(mouseX, mouseY) or inputHandled

            if not inputHandled then

                -- Check if an alien was selected.
                for k, buttonItem in ipairs(self.alienButtons) do

                    local itemTechId = buttonItem.TypeData.TechId
                    local cost = CombatPlusPlus_GetCostByTechId(itemTechId)
                    local canAfford = cost <= player.combatSkillPoints
                    local hasRequiredRank = CombatPlusPlus_GetRequiredRankByTechId(itemTechId) <= player.combatRank

                    if canAfford and hasRequiredRank and self:_GetIsMouseOver(buttonItem.Button) then

                        -- Deselect all upgrades when a different alien type is selected.
                        if self.selectedAlienType ~= buttonItem.TypeData.Index then

                            AlienBuy_OnSelectAlien(CPPGUICombatAlienBuyMenu.kAlienTypes[buttonItem.TypeData.Index].Name)

                        end

                        self.selectedAlienType = buttonItem.TypeData.Index
                        MarkAlreadyPurchased( self )
                        self:SetPurchasedSelected()

                        inputHandled = true
                        break

                    end

                end

            end

        end

    end

    -- No matter what, this menu consumes MouseButton0/1 down.
    if down and (key == InputKey.MouseButton0 or key == InputKey.MouseButton1) then
        inputHandled = true
    end

    if InputKey.Escape == key and not down then

        closeMenu = true
        inputHandled = true
        AlienBuy_OnClose()

    end

    if closeMenu then

        self.closingMenu = true
        AlienBuy_OnClose()

    end

    return inputHandled

end

function CPPGUICombatAlienBuyMenu:GetCanSelect(upgradeButton, player)

    local hasRequiredRank = CombatPlusPlus_GetRequiredRankByTechId(upgradeButton.TechId) <= player.combatRank

    -- since you've already purchased it, it should be selectable
    return upgradeButton.Purchased or hasRequiredRank

end


function CPPGUICombatAlienBuyMenu:_HandleUpgradeClicked(mouseX, mouseY)

    local inputHandled = false
    local player = Client.GetLocalPlayer()

    for i, currentButton in ipairs(self.upgradeButtons) do
        -- Can't select if it has been purchased already.

        local allowedToUnselect = currentButton.Selected
        local allowedToPuchase = not currentButton.Selected and self:GetCanSelect(currentButton, player)

        if (allowedToUnselect or allowedToPuchase) and self:_GetIsMouseOver(currentButton.Icon) then

            -- Deselect or Select current button
            ToggleButton( self, currentButton )

            if currentButton.Selected then

                local hiveTypeCurrent = GetHiveTypeForUpgrade( currentButton.TechId )

                for j, otherButton in ipairs(self.upgradeButtons) do

                    if currentButton ~= otherButton and otherButton.Selected then

                        local hiveTypeOther = GetHiveTypeForUpgrade( otherButton.TechId )
                        if hiveTypeCurrent == hiveTypeOther then
                            DeselectButton( self, otherButton )
                        end

                    end

                end

                AlienBuy_OnUpgradeSelected()

            else

                AlienBuy_OnUpgradeDeselected()

            end

            inputHandled = true
            break

        end
    end

    return inputHandled

end
