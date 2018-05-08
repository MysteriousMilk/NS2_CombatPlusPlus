--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * New GUI that appears when the marines attempt to buy something using the 'B' key.
]]

Script.Load("lua/GUIAnimatedScript.lua")

class 'MarineBuyMenu' (GUIAnimatedScript)

MarineBuyMenu.kBackgroundColor = Color(0.05, 0.05, 0.1, 0.3)
MarineBuyMenu.kBackgroundCenterColor = Color(0.06, 0.06, 0.12, 0.4)
MarineBuyMenu.kBackgroundSize = Vector(1024, 1024, 0)

MarineBuyMenu.kLogoTexture = PrecacheAsset("ui/logo_marine.dds")
MarineBuyMenu.kButtonTexture = PrecacheAsset("ui/combatui_buymenu_button.dds")
MarineBuyMenu.kButtonLargeTexture = PrecacheAsset("ui/combatui_buymenu_button_large.dds")
MarineBuyMenu.kResIconTexture = PrecacheAsset("ui/pres_icon_big.dds")
MarineBuyMenu.kLevelUpIconTexture = PrecacheAsset("ui/levelup_icon.dds")
MarineBuyMenu.kInfoBackgroundTexture = PrecacheAsset("ui/combatui_marine_info_bkg.dds")
MarineBuyMenu.kCooldownIconTexture = PrecacheAsset("ui/cooldown_icon.dds")
MarineBuyMenu.kInfiniteIconTexture = PrecacheAsset("ui/infinite_icon.dds")

MarineBuyMenu.kIconTextureCoords = { 0, 0, 256, 256 }
MarineBuyMenu.kUpgradePointIconTexCoords = { 0, 0, 48, 48 }
MarineBuyMenu.kLevelUpIconTexCoords = { 0, 0, 128, 128 }
MarineBuyMenu.kInfoBackgroundTexCoords = { 0, 0, 400, 400 }
MarineBuyMenu.kSmallButtonTexCoords =  { 0, 0, 200, 64 }
MarineBuyMenu.kLargeButtonTexCoords =  { 0, 0, 128, 192 }

MarineBuyMenu.kTitleFont = Fonts.kAgencyFB_Large
MarineBuyMenu.kHeaderFont = Fonts.kAgencyFB_Medium
MarineBuyMenu.kTextColor = Color(kMarineFontColor)

MarineBuyMenu.kBtnColor = Color(1, 1, 1, 0.7)
MarineBuyMenu.kBtnHighlightColor = Color(0.5, 0.5, 1.0, 0.7)

MarineBuyMenu.kGreenHighlight = Color(0.4, 1, 0.4, 1)
MarineBuyMenu.kRedHighlight = Color(1, 0.3, 0.3, 1)
MarineBuyMenu.kGreyHighlight = Color(0.6, 0.6, 0.6, 1)

MarineBuyMenu.kButtonsPerRow = 4

local function GetHasPrerequisite(techId)

    return GetUpgradeTree():GetHasPrerequisites(techId)

end

local function GetIsEquipped(techId)

    local equippedTechIds = MarineBuy_GetEquipped()

    for k, itemTechId in ipairs(equippedTechIds) do

        if techId == itemTechId then
            return true
        end

    end

    if GetUpgradeTree():GetIsPurchased(techId) then
        return true
    end

    return false

end

local function GetIsHardCapped(techId, player)

    if CombatPlusPlus_GetIsStructureTechId(techId) then
        return CombatPlusPlus_GetStructureCountForTeam(techId, player:GetTeamNumber()) >= LookupUpgradeData(techId, kUpDataHardCapIndex)
    end

    return false

end

--
-- Checks if the mouse is over the passed in GUIItem and plays a sound if it has just moved over.
--
local function GetIsMouseOver(self, overItem)

    local mouseOver = GUIItemContainsPoint(overItem, Client.GetCursorPosScreen())
    if mouseOver and not self.mouseOverStates[overItem] then
        MarineBuy_OnMouseOver()
    end
    self.mouseOverStates[overItem] = mouseOver
    return mouseOver

end

local function UpdateItemsGUIScale(self)

    --background
    MarineBuyMenu.kBkgCenteredWidth = GUIScaleWidth(1000)

    -- marine logo
    MarineBuyMenu.kLogoSize = Vector(GUIScaleWidth(90), GUIScaleHeight(90), 0)
    MarineBuyMenu.kLogoPosition = Vector(GUIScaleWidth(60), GUIScaleHeight(20), 0)

    -- main header
    MarineBuyMenu.kTitleTextOffset = Vector(GUIScaleWidth(180), GUIScaleHeight(40), 0)
    MarineBuyMenu.kSubTitleTextOffset = Vector(GUIScaleWidth(180), GUIScaleHeight(80), 0)
    MarineBuyMenu.kUpgradePointTextOffset = Vector(GUIScaleWidth(-60), GUIScaleHeight(55), 0)
    MarineBuyMenu.kUpgradePointIconSize = Vector(GUIScaleWidth(36), GUIScaleHeight(36), 0)
    MarineBuyMenu.kUpgradePointIconPos = Vector(GUIScaleWidth(-100), GUIScaleHeight(36), 0)
    MarineBuyMenu.kHelpTextOffset = Vector(GUIScaleWidth(-60), GUIScaleHeight(85), 0)

    MarineBuyMenu.kCenterColumnGapWidth = GUIScaleWidth(40)

    -- weapons section
    MarineBuyMenu.kWeaponHeaderTextOffset = Vector(GUIScaleWidth(60), GUIScaleHeight(138), 0)
    MarineBuyMenu.kWeaponButtonStartOffset = Vector(GUIScaleWidth(60), GUIScaleHeight(163), 0)

    -- upgrades section
    MarineBuyMenu.kUpgradeHeaderTextOffset = Vector(GUIScaleWidth(520), GUIScaleHeight(138), 0)
    MarineBuyMenu.kUpgradeButtonStartOffset = Vector(GUIScaleWidth(520), GUIScaleHeight(163), 0)

    -- tech section
    MarineBuyMenu.kTechHeaderTextOffset = Vector(GUIScaleWidth(60), GUIScaleHeight(426), 0)
    MarineBuyMenu.kTechButtonStartOffset = Vector(GUIScaleWidth(60), GUIScaleHeight(451), 0)

    -- structure section
    MarineBuyMenu.kStructureHeaderTextOffset = Vector(GUIScaleWidth(60), GUIScaleHeight(644), 0)
    MarineBuyMenu.kStructureButtonStartOffset = Vector(GUIScaleWidth(60), GUIScaleHeight(669), 0)

    -- buttons
    MarineBuyMenu.kButtonSize = Vector(GUIScaleWidth(200), GUIScaleHeight(64), 0)
    MarineBuyMenu.kButtonPadding = Vector(GUIScaleWidth(10), GUIScaleHeight(10), 0)
    MarineBuyMenu.kButtonTextOffset = Vector(GUIScaleWidth(-6), GUIScaleHeight(14), 0)
    MarineBuyMenu.kButtonCostIconSize = Vector(GUIScaleWidth(20), GUIScaleHeight(20), 0)
    MarineBuyMenu.kButtonCostIconPos = Vector(GUIScaleWidth(-36), GUIScaleHeight(-24), 0)
    MarineBuyMenu.kButtonCostTextOffset = Vector(GUIScaleWidth(-8), GUIScaleHeight(-14), 0)
    MarineBuyMenu.kButtonRankIconSize = Vector(GUIScaleWidth(16), GUIScaleHeight(16), 0)
    MarineBuyMenu.kButtonRankIconPos = Vector(GUIScaleWidth(-70), GUIScaleHeight(-24), 0)
    MarineBuyMenu.kButtonRankTextOffset = Vector(GUIScaleWidth(-44), GUIScaleHeight(-14), 0)

    -- large buttons
    MarineBuyMenu.kButtonLargeSize = Vector(GUIScaleWidth(128), GUIScaleHeight(192), 0)
    MarineBuyMenu.kButtonLargePadding = Vector(GUIScaleWidth(10), GUIScaleHeight(10), 0)
    MarineBuyMenu.kButtonLargeTextOffset = Vector(GUIScaleWidth(6), GUIScaleHeight(-14), 0)
    MarineBuyMenu.kButtonLargeCostIconPos = Vector(GUIScaleWidth(-32), GUIScaleHeight(-22), 0)
    MarineBuyMenu.kButtonLargeCostTextOffset = Vector(GUIScaleWidth(-5), GUIScaleHeight(-12), 0)
    MarineBuyMenu.kButtonLargeRankIconPos = Vector(GUIScaleWidth(-32), GUIScaleHeight(-40), 0)
    MarineBuyMenu.kButtonLargeRankTextOffset = Vector(GUIScaleWidth(-5), GUIScaleHeight(-30), 0)
    MarineBuyMenu.kButtonLargeHardcapTextOffset = Vector(GUIScaleWidth(-4), GUIScaleHeight(4), 0)

    -- mouse over info
    MarineBuyMenu.kInfoBackgroundSize = Vector(GUIScaleWidth(394), GUIScaleHeight(394), 0)
    MarineBuyMenu.kInfoBackgroundPos = Vector(GUIScaleWidth(520), GUIScaleHeight(669), 0)
    MarineBuyMenu.kInfoTitleOffset = Vector(GUIScaleWidth(10), GUIScaleHeight(25), 0)
    MarineBuyMenu.kInfoTextOffset = Vector(GUIScaleWidth(10), GUIScaleHeight(50), 0)
    MarineBuyMenu.kInfoIconOffset = Vector(0, GUIScaleHeight(70), 0)
    MarineBuyMenu.kInfoSmallIconSize = Vector(GUIScaleWidth(28), GUIScaleHeight(28), 0)
    MarineBuyMenu.kInfoCostTextOffset = Vector(GUIScaleWidth(-18), GUIScaleHeight(11), 0)
    MarineBuyMenu.kInfoCostIconOffset = Vector(GUIScaleWidth(-48), GUIScaleHeight(10), 0)
    MarineBuyMenu.kInfoRankTextOffset = Vector(GUIScaleWidth(-62), GUIScaleHeight(11), 0)
    MarineBuyMenu.kInfoRankIconOffset = Vector(GUIScaleWidth(-92), GUIScaleHeight(10), 0)
    MarineBuyMenu.kInfoCooldownTextOffset = Vector(GUIScaleWidth(-120), GUIScaleHeight(11), 0)
    MarineBuyMenu.kInfoCooldownIconOffset = Vector(GUIScaleWidth(-150), GUIScaleHeight(10), 0)
    MarineBuyMenu.kInfoPersistIconOffsetMin = Vector(GUIScaleWidth(-122), GUIScaleHeight(10), 0)
    MarineBuyMenu.kInfoPersistIconOffsetMax = Vector(GUIScaleWidth(-180), GUIScaleHeight(10), 0)

end

function MarineBuyMenu:Initialize()

    GUIAnimatedScript.Initialize(self)

    UpdateItemsGUIScale(self)

    self.mouseOverStates = { }

    self:_InitializeBackground()
    self:_InitializeHeaders()
    self:_InitializeMouseOverInfo()
    self:_InitializeButtons()

    MarineBuy_OnOpen()
    MouseTracker_SetIsVisible(true, "ui/Cursor_MenuDefault.dds", true)

end

function MarineBuyMenu:Update(deltaTime)

    PROFILE("MarineBuyMenu:Update")

    GUIAnimatedScript.Update(self, deltaTime)
    self:_UpdateItemButtons(deltaTime)

end

function MarineBuyMenu:Uninitialize()

    GUIAnimatedScript.Uninitialize(self)

    GUI.DestroyItem(self.background)
    self.background = nil

    MouseTracker_SetIsVisible(false)

end

function MarineBuyMenu:OnResolutionChanged(oldX, oldY, newX, newY)

    self:Uninitialize()
    self:Initialize()

    MarineBuy_OnClose()

end

function MarineBuyMenu:_InitializeBackground()

    self.background = GUIManager:CreateGraphicItem()
    self.background:SetSize( Vector(Client.GetScreenWidth(), Client.GetScreenHeight(), 0) )
    self.background:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.background:SetColor(MarineBuyMenu.kBackgroundColor)
    self.background:SetLayer(kGUILayerPlayerHUDForeground4)

    self.backgroundCenteredArea = GUIManager:CreateGraphicItem()
    self.backgroundCenteredArea:SetSize( Vector(MarineBuyMenu.kBkgCenteredWidth, Client.GetScreenHeight(), 0) )
    self.backgroundCenteredArea:SetAnchor(GUIItem.Middle, GUIItem.Top)
    self.backgroundCenteredArea:SetPosition( Vector(-(MarineBuyMenu.kBkgCenteredWidth / 2), 0, 0) )
    self.backgroundCenteredArea:SetColor(MarineBuyMenu.kBackgroundCenterColor)
    self.background:AddChild(self.backgroundCenteredArea)

end

function MarineBuyMenu:_InitializeHeaders()

    local player = Client.GetLocalPlayer()

    self.logo = GetGUIManager():CreateGraphicItem()
    self.logo:SetSize( MarineBuyMenu.kLogoSize )
    self.logo:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.logo:SetPosition( MarineBuyMenu.kLogoPosition )
    self.logo:SetTexture(MarineBuyMenu.kLogoTexture)
    self.logo:SetTexturePixelCoordinates(unpack(MarineBuyMenu.kIconTextureCoords))
    self.backgroundCenteredArea:AddChild(self.logo)

    self.titleText = GetGUIManager():CreateTextItem()
    self.titleText:SetFontName(MarineBuyMenu.kTitleFont)
    self.titleText:SetFontIsBold(true)
    self.titleText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.titleText)
    self.titleText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.titleText:SetPosition( MarineBuyMenu.kTitleTextOffset )
    self.titleText:SetTextAlignmentX(GUIItem.Align_Min)
    self.titleText:SetTextAlignmentY(GUIItem.Align_Center)
    self.titleText:SetColor(MarineBuyMenu.kTextColor)
    self.titleText:SetText("TSE Uplink Established")
    self.titleText:SetIsVisible(true)
    self.backgroundCenteredArea:AddChild(self.titleText)

    self.subTitleText = GetGUIManager():CreateTextItem()
    self.subTitleText:SetFontName(MarineBuyMenu.kHeaderFont)
    self.subTitleText:SetFontIsBold(true)
    self.subTitleText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.subTitleText)
    self.subTitleText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.subTitleText:SetPosition( MarineBuyMenu.kSubTitleTextOffset )
    self.subTitleText:SetTextAlignmentX(GUIItem.Align_Min)
    self.subTitleText:SetTextAlignmentY(GUIItem.Align_Center)
    self.subTitleText:SetColor(MarineBuyMenu.kTextColor)
    self.subTitleText:SetText(string.format("Logged in as %s", player:GetName()))
    self.subTitleText:SetIsVisible(true)
    self.backgroundCenteredArea:AddChild(self.subTitleText)

    self.upgradePointText = GetGUIManager():CreateTextItem()
    self.upgradePointText:SetFontName(Fonts.kAgencyFB_Small)
    self.upgradePointText:SetFontIsBold(true)
    self.upgradePointText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.upgradePointText)
    self.upgradePointText:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.upgradePointText:SetPosition( MarineBuyMenu.kUpgradePointTextOffset )
    self.upgradePointText:SetTextAlignmentX(GUIItem.Align_Max)
    self.upgradePointText:SetTextAlignmentY(GUIItem.Align_Center)
    self.upgradePointText:SetColor(MarineBuyMenu.kTextColor)
    self.upgradePointText:SetIsVisible(true)
    self.backgroundCenteredArea:AddChild(self.upgradePointText)

    -- update upgrade point text
    local points = player:GetCombatUpgradePoints()
    local pointStr = ConditionalValue(points == 1, string.format("%s Upgrade Point", points), string.format("%s Upgrade Points", points))
    self.upgradePointText:SetText(pointStr)

    local textSize = Fancy_CalculateTextSize(pointStr, Fonts.kAgencyFB_Small)

    self.upgradePointIcon = GetGUIManager():CreateGraphicItem()
    self.upgradePointIcon:SetSize( MarineBuyMenu.kUpgradePointIconSize )
    self.upgradePointIcon:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.upgradePointIcon:SetPosition( Vector(-textSize.x, 0, 0) + MarineBuyMenu.kUpgradePointIconPos )
    self.upgradePointIcon:SetTexture(MarineBuyMenu.kResIconTexture)
    self.upgradePointIcon:SetTexturePixelCoordinates(unpack(MarineBuyMenu.kUpgradePointIconTexCoords))
    self.backgroundCenteredArea:AddChild(self.upgradePointIcon)

    self.helpText = GetGUIManager():CreateTextItem()
    self.helpText:SetFontName(Fonts.kAgencyFB_Tiny)
    self.helpText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.helpText)
    self.helpText:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.helpText:SetTextAlignmentX(GUIItem.Align_Min)
    self.helpText:SetTextAlignmentY(GUIItem.Align_Center)
    self.helpText:SetColor(MarineBuyMenu.kTextColor)
    self.helpText:SetIsVisible(false)
    self.backgroundCenteredArea:AddChild(self.helpText)

    self.wpnHeaderText = GetGUIManager():CreateTextItem()
    self.wpnHeaderText:SetFontName(MarineBuyMenu.kHeaderFont)
    self.wpnHeaderText:SetFontIsBold(true)
    self.wpnHeaderText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.wpnHeaderText)
    self.wpnHeaderText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.wpnHeaderText:SetPosition(MarineBuyMenu.kWeaponHeaderTextOffset)
    self.wpnHeaderText:SetTextAlignmentX(GUIItem.Align_Min)
    self.wpnHeaderText:SetTextAlignmentY(GUIItem.Align_Center)
    self.wpnHeaderText:SetColor(MarineBuyMenu.kTextColor)
    self.wpnHeaderText:SetText("Weapons")
    self.wpnHeaderText:SetIsVisible(true)
    self.backgroundCenteredArea:AddChild(self.wpnHeaderText)

    self.upgradeHeaderText = GetGUIManager():CreateTextItem()
    self.upgradeHeaderText:SetFontName(MarineBuyMenu.kHeaderFont)
    self.upgradeHeaderText:SetFontIsBold(true)
    self.upgradeHeaderText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.upgradeHeaderText)
    self.upgradeHeaderText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.upgradeHeaderText:SetPosition(MarineBuyMenu.kUpgradeHeaderTextOffset)
    self.upgradeHeaderText:SetTextAlignmentX(GUIItem.Align_Min)
    self.upgradeHeaderText:SetTextAlignmentY(GUIItem.Align_Center)
    self.upgradeHeaderText:SetColor(MarineBuyMenu.kTextColor)
    self.upgradeHeaderText:SetText("Upgrades")
    self.upgradeHeaderText:SetIsVisible(true)
    self.backgroundCenteredArea:AddChild(self.upgradeHeaderText)

    self.techHeaderText = GetGUIManager():CreateTextItem()
    self.techHeaderText:SetFontName(MarineBuyMenu.kHeaderFont)
    self.techHeaderText:SetFontIsBold(true)
    self.techHeaderText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.techHeaderText)
    self.techHeaderText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.techHeaderText:SetPosition(MarineBuyMenu.kTechHeaderTextOffset)
    self.techHeaderText:SetTextAlignmentX(GUIItem.Align_Min)
    self.techHeaderText:SetTextAlignmentY(GUIItem.Align_Center)
    self.techHeaderText:SetColor(MarineBuyMenu.kTextColor)
    self.techHeaderText:SetText("Tech")
    self.techHeaderText:SetIsVisible(true)
    self.backgroundCenteredArea:AddChild(self.techHeaderText)

    self.structureHeaderText = GetGUIManager():CreateTextItem()
    self.structureHeaderText:SetFontName(MarineBuyMenu.kHeaderFont)
    self.structureHeaderText:SetFontIsBold(true)
    self.structureHeaderText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.structureHeaderText)
    self.structureHeaderText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.structureHeaderText:SetPosition(MarineBuyMenu.kStructureHeaderTextOffset)
    self.structureHeaderText:SetTextAlignmentX(GUIItem.Align_Min)
    self.structureHeaderText:SetTextAlignmentY(GUIItem.Align_Center)
    self.structureHeaderText:SetColor(MarineBuyMenu.kTextColor)
    self.structureHeaderText:SetText("Structures")
    self.structureHeaderText:SetIsVisible(true)
    self.backgroundCenteredArea:AddChild(self.structureHeaderText)

end

local function CreateSmallButton(x, y, iconColor, itemTechId, enabled, canAfford, hasRank)

    local cost = LookupUpgradeData(itemTechId, kUpDataCostIndex)
    local rank = LookupUpgradeData(itemTechId, kUpDataRankIndex)
    local iconTexture = LookupUpgradeData(itemTechId, kUpDataIconTextureIndex)
    local iconSize = LookupUpgradeData(itemTechId, kUpDataIconSizeIndex)
    
    local buttonGraphic = GUIManager:CreateGraphicItem()
    buttonGraphic:SetSize( MarineBuyMenu.kButtonSize )
    buttonGraphic:SetAnchor(GUIItem.Left, GUIItem.Top)
    buttonGraphic:SetPosition( Vector(x, y, 0) )
    buttonGraphic:SetTexture(MarineBuyMenu.kButtonTexture)
    buttonGraphic:SetTexturePixelCoordinates(unpack(MarineBuyMenu.kSmallButtonTexCoords))
    buttonGraphic:SetColor( MarineBuyMenu.kBtnColor )

    if iconTexture and iconSize then

        local buttonIcon = GUIManager:CreateGraphicItem()
        buttonIcon:SetSize( Vector(GUIScaleWidth(iconSize.x), GUIScaleHeight(iconSize.y), 0) )
        buttonIcon:SetAnchor(GUIItem.Left, GUIItem.Top)
        buttonIcon:SetPosition( Vector(0, 0, 0) )
        buttonIcon:SetTexture(iconTexture)
        buttonIcon:SetTexturePixelCoordinates(unpack(CombatUI_GetMarineUpgradeTextureCoords(itemTechId, enabled)))
        buttonIcon:SetColor(iconColor)
        buttonGraphic:AddChild(buttonIcon)

    end

    local buttonText = GUIManager:CreateTextItem()
    buttonText:SetFontName(Fonts.kAgencyFB_Tiny)
    buttonText:SetScale(GetScaledVector())
    GUIMakeFontScale(buttonText)
    buttonText:SetAnchor(GUIItem.Right, GUIItem.Top)
    buttonText:SetPosition(MarineBuyMenu.kButtonTextOffset)
    buttonText:SetTextAlignmentX(GUIItem.Align_Max)
    buttonText:SetTextAlignmentY(GUIItem.Align_Center)
    buttonText:SetColor(MarineBuyMenu.kTextColor)
    buttonText:SetText(GetDisplayNameForTechId(itemTechId))
    buttonGraphic:AddChild(buttonText)

    local rankColor = ConditionalValue(hasRank, MarineBuyMenu.kTextColor, MarineBuyMenu.kRedHighlight)
    local rankIcon = GUIManager:CreateGraphicItem()
    rankIcon:SetSize(MarineBuyMenu.kButtonRankIconSize )
    rankIcon:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    rankIcon:SetPosition(MarineBuyMenu.kButtonRankIconPos)
    rankIcon:SetTexture(MarineBuyMenu.kLevelUpIconTexture)
    rankIcon:SetTexturePixelCoordinates(unpack(MarineBuyMenu.kLevelUpIconTexCoords))
    rankIcon:SetColor(rankColor)
    buttonGraphic:AddChild(rankIcon)

    local rankText = GUIManager:CreateTextItem()
    rankText:SetFontName(Fonts.kAgencyFB_Tiny)
    rankText:SetScale(GetScaledVector())
    GUIMakeFontScale(rankText)
    rankText:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    rankText:SetPosition(MarineBuyMenu.kButtonRankTextOffset)
    rankText:SetTextAlignmentX(GUIItem.Align_Max)
    rankText:SetTextAlignmentY(GUIItem.Align_Center)
    rankText:SetColor(rankColor)
    rankText:SetText(string.format("%s", rank))
    buttonGraphic:AddChild(rankText)

    local costColor = ConditionalValue(canAfford, MarineBuyMenu.kTextColor, MarineBuyMenu.kRedHighlight)
    local costIcon = GUIManager:CreateGraphicItem()
    costIcon:SetSize( MarineBuyMenu.kButtonCostIconSize )
    costIcon:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    costIcon:SetPosition(MarineBuyMenu.kButtonCostIconPos)
    costIcon:SetTexture(MarineBuyMenu.kResIconTexture)
    costIcon:SetTexturePixelCoordinates(unpack(MarineBuyMenu.kUpgradePointIconTexCoords))
    costIcon:SetColor(costColor)
    buttonGraphic:AddChild(costIcon)

    local costText = GUIManager:CreateTextItem()
    costText:SetFontName(Fonts.kAgencyFB_Tiny)
    costText:SetScale(GetScaledVector())
    GUIMakeFontScale(costText)
    costText:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    costText:SetPosition(MarineBuyMenu.kButtonCostTextOffset)
    costText:SetTextAlignmentX(GUIItem.Align_Max)
    costText:SetTextAlignmentY(GUIItem.Align_Center)
    costText:SetColor(costColor)
    costText:SetText(string.format("%s", cost))
    buttonGraphic:AddChild(costText)

    return buttonGraphic

end

local function InitWeaponButtons(self, player)

    local columnIndex = 0
    local rowIndex = 0
    local startOffset = MarineBuyMenu.kWeaponButtonStartOffset

    for k, itemTechId in ipairs(GetUpgradeTree():GetUpgradesByCategory("Weapon")) do

        if columnIndex == 2 then

            columnIndex = 0
            rowIndex = rowIndex + 1

        end

        local x = startOffset.x + (columnIndex * (MarineBuyMenu.kButtonSize.x + MarineBuyMenu.kButtonPadding.x))
        local y = startOffset.y + (rowIndex * (MarineBuyMenu.kButtonSize.y + MarineBuyMenu.kButtonPadding.y))

        local cost = LookupUpgradeData(itemTechId, kUpDataCostIndex)
        local rankRequired = LookupUpgradeData(itemTechId, kUpDataRankIndex)
        local equipped = GetIsEquipped(itemTechId)
        local canAfford = cost <= player.combatUpgradePoints
        local hasRequiredRank = rankRequired <= player.combatRank

        local enabled = canAfford and hasRequiredRank and not equipped
        local iconColor = Color(1, 1, 1, 1)

        if equipped then
            iconColor = MarineBuyMenu.kGreenHighlight
        elseif hasRequiredRank and not canAfford then
            iconColor = MarineBuyMenu.kRedHighlight
        end

        local buttonGraphic = CreateSmallButton(x, y, iconColor, itemTechId, enabled, canAfford, hasRequiredRank)
        self.backgroundCenteredArea:AddChild(buttonGraphic)

        columnIndex = columnIndex + 1

        table.insert(self.itemButtons, { Button = buttonGraphic, TechId = itemTechId } )

    end

end

local function InitUpgradeButtons(self, player)

    local columnIndex = 0
    local rowIndex = 0
    local startOffset = MarineBuyMenu.kUpgradeButtonStartOffset

    local armorTechId = CombatPlusPlus_GetTechIdByArmorLevel(player:GetArmorLevel() + 1)
    local wpnTechId = CombatPlusPlus_GetTechIdByWeaponLevel(player:GetWeaponLevel() + 1)

    local upgrades = GetUpgradeTree():GetUpgradesByCategory("Consumable")

    if armorTechId ~= kTechId.None then
        table.insert(upgrades, armorTechId)
    end

    if wpnTechId ~= kTechId.None then
        table.insert(upgrades, wpnTechId)
    end

    for k, itemTechId in ipairs(upgrades) do

        if columnIndex == 2 then

            columnIndex = 0
            rowIndex = rowIndex + 1

        end

        local x = startOffset.x + (columnIndex * (MarineBuyMenu.kButtonSize.x + MarineBuyMenu.kButtonPadding.x))
        local y = startOffset.y + (rowIndex * (MarineBuyMenu.kButtonSize.y + MarineBuyMenu.kButtonPadding.y))

        local cost = LookupUpgradeData(itemTechId, kUpDataCostIndex)
        local rankRequired = LookupUpgradeData(itemTechId, kUpDataRankIndex)
        local equipped = GetIsEquipped(itemTechId)
        local hasPrereq = GetHasPrerequisite(itemTechId)
        local canAfford = cost <= player.combatUpgradePoints
        local hasRequiredRank = rankRequired <= player.combatRank

        local enabled = canAfford and hasRequiredRank and hasPrereq and not equipped
        local iconColor = Color(1, 1, 1, 1)

        if equipped then
            iconColor = MarineBuyMenu.kGreenHighlight
        elseif hasRequiredRank and not canAfford then
            iconColor = MarineBuyMenu.kRedHighlight
        elseif not enabled then
            iconColor = MarineBuyMenu.kGreyHighlight
        end

        local buttonGraphic = CreateSmallButton(x, y, iconColor, itemTechId, enabled, canAfford, hasRequiredRank)
        self.backgroundCenteredArea:AddChild(buttonGraphic)

        columnIndex = columnIndex + 1

        table.insert(self.itemButtons, { Button = buttonGraphic, TechId = itemTechId } )

    end

end

local function InitTechButtons(self, player)

    local columnIndex = 0
    local rowIndex = 0
    local startOffset = MarineBuyMenu.kTechButtonStartOffset

    for k, itemTechId in ipairs(GetUpgradeTree():GetUpgradesByCategory("Tech")) do

        if columnIndex == MarineBuyMenu.kButtonsPerRow then

            columnIndex = 0
            rowIndex = rowIndex + 1

        end

        local x = startOffset.x + (columnIndex * (MarineBuyMenu.kButtonSize.x + MarineBuyMenu.kButtonPadding.x))
        local y = startOffset.y + (rowIndex * (MarineBuyMenu.kButtonSize.y + MarineBuyMenu.kButtonPadding.y))

        -- add a gap between column 2 and 3
        if columnIndex >= 2 then
            x = x + MarineBuyMenu.kCenterColumnGapWidth
        end

        local cost = LookupUpgradeData(itemTechId, kUpDataCostIndex)
        local rankRequired = LookupUpgradeData(itemTechId, kUpDataRankIndex)
        local equipped = GetIsEquipped(itemTechId)
        local canAfford = cost <= player.combatUpgradePoints
        local hasRequiredRank = rankRequired <= player.combatRank

        local enabled = canAfford and hasRequiredRank and not equipped
        local iconColor = Color(1, 1, 1, 1)

        if equipped then
            iconColor = MarineBuyMenu.kGreenHighlight
        elseif hasRequiredRank and not canAfford then
            iconColor = MarineBuyMenu.kRedHighlight
        end

        local buttonGraphic = CreateSmallButton(x, y, iconColor, itemTechId, enabled, canAfford, hasRequiredRank)
        self.backgroundCenteredArea:AddChild(buttonGraphic)

        columnIndex = columnIndex + 1

        table.insert(self.itemButtons, { Button = buttonGraphic, TechId = itemTechId } )

    end

end

local function InitStructureButtons(self, player)

    local columnIndex = 0
    local rowIndex = 0
    local startOffset = MarineBuyMenu.kStructureButtonStartOffset

    for k, itemTechId in ipairs(GetUpgradeTree():GetUpgradesByCategory("Structures")) do

        if columnIndex == 3 then

            columnIndex = 0
            rowIndex = rowIndex + 1

        end

        local x = startOffset.x + (columnIndex * (MarineBuyMenu.kButtonLargeSize.x + MarineBuyMenu.kButtonLargePadding.x))
        local y = startOffset.y + (rowIndex * (MarineBuyMenu.kButtonLargeSize.y + MarineBuyMenu.kButtonLargePadding.y))

        local buttonGraphic = GUIManager:CreateGraphicItem()
        buttonGraphic:SetSize( MarineBuyMenu.kButtonLargeSize )
        buttonGraphic:SetAnchor(GUIItem.Left, GUIItem.Top)
        buttonGraphic:SetPosition( Vector(x, y, 0) )
        buttonGraphic:SetTexture(MarineBuyMenu.kButtonLargeTexture)
        buttonGraphic:SetTexturePixelCoordinates(unpack(MarineBuyMenu.kLargeButtonTexCoords))
        buttonGraphic:SetColor( MarineBuyMenu.kBtnColor )
        self.backgroundCenteredArea:AddChild(buttonGraphic)

        local cost = LookupUpgradeData(itemTechId, kUpDataCostIndex)
        local rankRequired = LookupUpgradeData(itemTechId, kUpDataRankIndex)
        local canAfford = cost <= player.combatUpgradePoints
        local hasRequiredRank = rankRequired <= player.combatRank
        local isHardcapped = GetIsHardCapped(itemTechId, player)

        local enabled = canAfford and hasRequiredRank
        local iconColor = Color(1, 1, 1, 1)

        if (hasRequiredRank and not canAfford) or isHardcapped then
            iconColor = MarineBuyMenu.kRedHighlight
        end

        local iconTexture = LookupUpgradeData(itemTechId, kUpDataIconTextureIndex)
        local iconSize = LookupUpgradeData(itemTechId, kUpDataIconSizeIndex)

        if iconTexture and iconSize then

            local buttonIcon = GUIManager:CreateGraphicItem()
            buttonIcon:SetSize(Vector(GUIScaleWidth(iconSize.x), GUIScaleHeight(iconSize.y), 0))
            buttonIcon:SetAnchor(GUIItem.Left, GUIItem.Top)
            buttonIcon:SetPosition( Vector(0, 0, 0) )
            buttonIcon:SetTexture(iconTexture)
            buttonIcon:SetTexturePixelCoordinates(unpack(CombatUI_GetMarineUpgradeTextureCoords(itemTechId, enabled)))
            buttonIcon:SetColor(iconColor)
            buttonGraphic:AddChild(buttonIcon)

        end

        local buttonText = GUIManager:CreateTextItem()
        buttonText:SetFontName(Fonts.kAgencyFB_Tiny)
        buttonText:SetScale(GetScaledVector())
        GUIMakeFontScale(buttonText)
        buttonText:SetAnchor(GUIItem.Left, GUIItem.Bottom)
        buttonText:SetPosition(MarineBuyMenu.kButtonLargeTextOffset)
        buttonText:SetTextAlignmentX(GUIItem.Align_Min)
        buttonText:SetTextAlignmentY(GUIItem.Align_Center)
        buttonText:SetColor(MarineBuyMenu.kTextColor)
        buttonText:SetText(GetDisplayNameForTechId(itemTechId))
        buttonGraphic:AddChild(buttonText)

        local costColor = MarineBuyMenu.kTextColor
        if not canAfford or not hasRequiredRank then
            costColor = MarineBuyMenu.kRedHighlight
        end

        local costIcon = GUIManager:CreateGraphicItem()
        costIcon:SetSize(MarineBuyMenu.kButtonCostIconSize)
        costIcon:SetAnchor(GUIItem.Right, GUIItem.Bottom)
        costIcon:SetPosition(MarineBuyMenu.kButtonLargeCostIconPos)
        costIcon:SetTexture(MarineBuyMenu.kResIconTexture)
        costIcon:SetTexturePixelCoordinates(unpack(MarineBuyMenu.kUpgradePointIconTexCoords))
        costIcon:SetColor(costColor)
        buttonGraphic:AddChild(costIcon)

        local costText = GUIManager:CreateTextItem()
        costText:SetFontName(Fonts.kAgencyFB_Tiny)
        costText:SetScale(GetScaledVector())
        GUIMakeFontScale(costText)
        costText:SetAnchor(GUIItem.Right, GUIItem.Bottom)
        costText:SetPosition(MarineBuyMenu.kButtonLargeCostTextOffset)
        costText:SetTextAlignmentX(GUIItem.Align_Max)
        costText:SetTextAlignmentY(GUIItem.Align_Center)
        costText:SetColor(costColor)
        costText:SetText(string.format("%s", cost))
        buttonGraphic:AddChild(costText)

        local rankColor = MarineBuyMenu.kTextColor
        if not canAfford or not hasRequiredRank then
            rankColor = MarineBuyMenu.kRedHighlight
        end

        local rankIcon = GUIManager:CreateGraphicItem()
        rankIcon:SetSize(MarineBuyMenu.kButtonRankIconSize)
        rankIcon:SetAnchor(GUIItem.Right, GUIItem.Bottom)
        rankIcon:SetPosition(MarineBuyMenu.kButtonLargeRankIconPos)
        rankIcon:SetTexture(MarineBuyMenu.kLevelUpIconTexture)
        rankIcon:SetTexturePixelCoordinates(unpack(MarineBuyMenu.kLevelUpIconTexCoords))
        rankIcon:SetColor(rankColor)
        buttonGraphic:AddChild(rankIcon)

        local rankText = GUIManager:CreateTextItem()
        rankText:SetFontName(Fonts.kAgencyFB_Tiny)
        rankText:SetScale(GetScaledVector())
        GUIMakeFontScale(rankText)
        rankText:SetAnchor(GUIItem.Right, GUIItem.Bottom)
        rankText:SetPosition(MarineBuyMenu.kButtonLargeRankTextOffset)
        rankText:SetTextAlignmentX(GUIItem.Align_Max)
        rankText:SetTextAlignmentY(GUIItem.Align_Center)
        rankText:SetColor(rankColor)
        rankText:SetText(string.format("%s", rankRequired))
        buttonGraphic:AddChild(rankText)

        local hardCapColor = MarineBuyMenu.kTextColor
        if isHardcapped then
            hardCapColor = MarineBuyMenu.kRedHighlight
        end

        local hardCapText = GUIManager:CreateTextItem()
        hardCapText:SetFontName(Fonts.kAgencyFB_Tiny)
        hardCapText:SetScale(GetScaledVector())
        GUIMakeFontScale(hardCapText)
        hardCapText:SetAnchor(GUIItem.Right, GUIItem.Top)
        hardCapText:SetPosition(MarineBuyMenu.kButtonLargeHardcapTextOffset)
        hardCapText:SetTextAlignmentX(GUIItem.Align_Max)
        hardCapText:SetTextAlignmentY(GUIItem.Align_Min)
        hardCapText:SetColor(hardCapColor)
        hardCapText:SetText(string.format("%s/%s", CombatPlusPlus_GetStructureCountForTeam(itemTechId, player:GetTeamNumber()), LookupUpgradeData(itemTechId, kUpDataHardCapIndex)))
        buttonGraphic:AddChild(hardCapText)

        columnIndex = columnIndex + 1

        table.insert(self.itemButtons, { Button = buttonGraphic, TechId = itemTechId } )

    end

end

function MarineBuyMenu:_InitializeButtons()

    local player = Client.GetLocalPlayer()

    self.itemButtons = { }

    InitWeaponButtons(self, player)
    InitUpgradeButtons(self, player)
    InitTechButtons(self, player)
    InitStructureButtons(self, player)

    -- to prevent wrong display before the first update
    self:_UpdateItemButtons(0)

end

function MarineBuyMenu:_InitializeMouseOverInfo()

    self.infoBorder = GUIManager:CreateGraphicItem()
    self.infoBorder:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.infoBorder:SetSize(MarineBuyMenu.kInfoBackgroundSize)
    self.infoBorder:SetPosition(MarineBuyMenu.kInfoBackgroundPos)
    self.infoBorder:SetTexture(MarineBuyMenu.kInfoBackgroundTexture)
    self.infoBorder:SetTexturePixelCoordinates(unpack(MarineBuyMenu.kInfoBackgroundTexCoords))
    self.infoBorder:SetColor(MarineBuyMenu.kBtnHighlightColor)
    self.infoBorder:SetIsVisible(false)
    self.backgroundCenteredArea:AddChild(self.infoBorder)

    self.mouseOverTitleShadow = GUIManager:CreateTextItem()
    self.mouseOverTitleShadow:SetFontName(Fonts.kAgencyFB_Medium)
    self.mouseOverTitleShadow:SetScale(GetScaledVector())
    GUIMakeFontScale(self.mouseOverTitleShadow)
    self.mouseOverTitleShadow:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.mouseOverTitleShadow:SetPosition(MarineBuyMenu.kInfoTitleOffset)
    self.mouseOverTitleShadow:SetTextAlignmentX(GUIItem.Align_Min)
    self.mouseOverTitleShadow:SetTextAlignmentY(GUIItem.Align_Center)
    self.mouseOverTitleShadow:SetColor(MarineBuyMenu.kBtnHighlightColor)
    self.infoBorder:AddChild(self.mouseOverTitleShadow)

    self.mouseOverTitleText = GUIManager:CreateTextItem()
    self.mouseOverTitleText:SetFontName(Fonts.kAgencyFB_Medium)
    self.mouseOverTitleText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.mouseOverTitleText)
    self.mouseOverTitleText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.mouseOverTitleText:SetPosition(Vector(-1, -1, 0))
    self.mouseOverTitleText:SetTextAlignmentX(GUIItem.Align_Min)
    self.mouseOverTitleText:SetTextAlignmentY(GUIItem.Align_Center)
    self.mouseOverTitleText:SetColor(MarineBuyMenu.kTextColor)
    self.mouseOverTitleShadow:AddChild(self.mouseOverTitleText)

    self.mouseOverInfoText = GUIManager:CreateTextItem()
    self.mouseOverInfoText:SetFontName(Fonts.kAgencyFB_Tiny)
    self.mouseOverInfoText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.mouseOverInfoText)
    self.mouseOverInfoText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.mouseOverInfoText:SetPosition(MarineBuyMenu.kInfoTextOffset)
    self.mouseOverInfoText:SetTextAlignmentX(GUIItem.Align_Min)
    self.mouseOverInfoText:SetTextAlignmentY(GUIItem.Align_Min)
    self.mouseOverInfoText:SetColor(MarineBuyMenu.kTextColor)
    self.infoBorder:AddChild(self.mouseOverInfoText)

    self.mouseOverInfoIcon = GUIManager:CreateGraphicItem()
    self.mouseOverInfoIcon:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.mouseOverInfoIcon:SetPosition(MarineBuyMenu.kInfoIconOffset)
    self.infoBorder:AddChild(self.mouseOverInfoIcon)

    self.mouseOverInfoCostText = GUIManager:CreateTextItem()
    self.mouseOverInfoCostText:SetFontName(Fonts.kAgencyFB_Small)
    self.mouseOverInfoCostText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.mouseOverInfoCostText)
    self.mouseOverInfoCostText:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.mouseOverInfoCostText:SetPosition(MarineBuyMenu.kInfoCostTextOffset)
    self.mouseOverInfoCostText:SetTextAlignmentX(GUIItem.Align_Min)
    self.mouseOverInfoCostText:SetTextAlignmentY(GUIItem.Align_Min)
    self.mouseOverInfoCostText:SetColor(MarineBuyMenu.kTextColor)
    self.infoBorder:AddChild(self.mouseOverInfoCostText)

    local costIcon = GUIManager:CreateGraphicItem()
    costIcon:SetSize(MarineBuyMenu.kInfoSmallIconSize)
    costIcon:SetAnchor(GUIItem.Right, GUIItem.Top)
    costIcon:SetPosition(MarineBuyMenu.kInfoCostIconOffset)
    costIcon:SetTexture(MarineBuyMenu.kResIconTexture)
    costIcon:SetTexturePixelCoordinates(unpack(MarineBuyMenu.kUpgradePointIconTexCoords))
    costIcon:SetColor(MarineBuyMenu.kTextColor)
    self.infoBorder:AddChild(costIcon)

    self.mouseOverInfoRankText = GUIManager:CreateTextItem()
    self.mouseOverInfoRankText:SetFontName(Fonts.kAgencyFB_Small)
    self.mouseOverInfoRankText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.mouseOverInfoRankText)
    self.mouseOverInfoRankText:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.mouseOverInfoRankText:SetPosition(MarineBuyMenu.kInfoRankTextOffset)
    self.mouseOverInfoRankText:SetTextAlignmentX(GUIItem.Align_Min)
    self.mouseOverInfoRankText:SetTextAlignmentY(GUIItem.Align_Min)
    self.mouseOverInfoRankText:SetColor(MarineBuyMenu.kTextColor)
    self.infoBorder:AddChild(self.mouseOverInfoRankText)

    local rankIcon = GUIManager:CreateGraphicItem()
    rankIcon:SetSize(Vector(MarineBuyMenu.kInfoSmallIconSize.x - GUIScaleWidth(4), MarineBuyMenu.kInfoSmallIconSize.y - GUIScaleHeight(4), 0))
    rankIcon:SetAnchor(GUIItem.Right, GUIItem.Top)
    rankIcon:SetPosition(MarineBuyMenu.kInfoRankIconOffset)
    rankIcon:SetTexture(MarineBuyMenu.kLevelUpIconTexture)
    rankIcon:SetTexturePixelCoordinates(unpack(MarineBuyMenu.kLevelUpIconTexCoords))
    rankIcon:SetColor(MarineBuyMenu.kTextColor)
    self.infoBorder:AddChild(rankIcon)

    self.mouseOverInfoCooldownText = GUIManager:CreateTextItem()
    self.mouseOverInfoCooldownText:SetFontName(Fonts.kAgencyFB_Small)
    self.mouseOverInfoCooldownText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.mouseOverInfoCooldownText)
    self.mouseOverInfoCooldownText:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.mouseOverInfoCooldownText:SetPosition(MarineBuyMenu.kInfoCooldownTextOffset)
    self.mouseOverInfoCooldownText:SetTextAlignmentX(GUIItem.Align_Min)
    self.mouseOverInfoCooldownText:SetTextAlignmentY(GUIItem.Align_Min)
    self.mouseOverInfoCooldownText:SetColor(MarineBuyMenu.kTextColor)
    self.infoBorder:AddChild(self.mouseOverInfoCooldownText)

    self.mouseOverInfoCooldownIcon = GUIManager:CreateGraphicItem()
    self.mouseOverInfoCooldownIcon:SetSize(MarineBuyMenu.kInfoSmallIconSize)
    self.mouseOverInfoCooldownIcon:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.mouseOverInfoCooldownIcon:SetPosition(MarineBuyMenu.kInfoCooldownIconOffset)
    self.mouseOverInfoCooldownIcon:SetTexture(MarineBuyMenu.kCooldownIconTexture)
    self.mouseOverInfoCooldownIcon:SetTexturePixelCoordinates(unpack(MarineBuyMenu.kUpgradePointIconTexCoords))
    self.mouseOverInfoCooldownIcon:SetColor(MarineBuyMenu.kTextColor)
    self.infoBorder:AddChild(self.mouseOverInfoCooldownIcon)

end

function MarineBuyMenu:ShowMouseOverInfo(techId)

    self.infoBorder:SetIsVisible(true)

    local nameString = GetDisplayNameForTechId(techId)
    self.mouseOverTitleText:SetText(nameString)
    self.mouseOverTitleShadow:SetText(nameString)

    local infoString = LookupUpgradeData(techId, kUpDataDescIndex)

    if infoString == nil or infoString == "" then

        infoString = MarineBuy_GetWeaponDescription(techId)

        if infoString == nil or infoString == "" then
            infoString = GetTooltipInfoText(techId)
        end

    end

    self.mouseOverInfoText:SetText(infoString)
    self.mouseOverInfoText:SetTextClipped(true, MarineBuyMenu.kInfoBackgroundSize.x - MarineBuyMenu.kInfoTextOffset.x, MarineBuyMenu.kInfoBackgroundSize.y - MarineBuyMenu.kInfoTextOffset.y)

    local player = Client.GetLocalPlayer()
    local cost = LookupUpgradeData(techId, kUpDataCostIndex)
    local rankRequired = LookupUpgradeData(techId, kUpDataRankIndex)
    local hasPrereq = GetHasPrerequisite(techId)
    local canAfford = cost <= player.combatUpgradePoints
    local hasRequiredRank = rankRequired <= player.combatRank
    local enabled = hasPrereq and canAfford and hasRequiredRank

    self.mouseOverInfoCostText:SetText(string.format("%s", cost))
    self.mouseOverInfoCostText:SetIsVisible(true)

    self.mouseOverInfoRankText:SetText(string.format("%s", rankRequired))
    self.mouseOverInfoRankText:SetIsVisible(true)

    local hasCooldown = true
    if techId == kTechId.MedPack then
        self.mouseOverInfoCooldownText:SetText(CombatPlusPlus_GetTimeString(kMedPackAbilityCooldown))
        self.mouseOverInfoCooldownText:SetIsVisible(true)
        self.mouseOverInfoCooldownIcon:SetIsVisible(true)
    elseif techId == kTechId.AmmoPack then
        self.mouseOverInfoCooldownText:SetText(CombatPlusPlus_GetTimeString(kAmmoPackAbilityCooldown))
        self.mouseOverInfoCooldownText:SetIsVisible(true)
        self.mouseOverInfoCooldownIcon:SetIsVisible(true)
    elseif techId == kTechId.CatPack then
        self.mouseOverInfoCooldownText:SetText(CombatPlusPlus_GetTimeString(kCatPackAbilityCooldown))
        self.mouseOverInfoCooldownText:SetIsVisible(true)
        self.mouseOverInfoCooldownIcon:SetIsVisible(true)
    elseif techId == kTechId.Scan then
        self.mouseOverInfoCooldownText:SetText(CombatPlusPlus_GetTimeString(kScanAbilityCooldown))
        self.mouseOverInfoCooldownText:SetIsVisible(true)
        self.mouseOverInfoCooldownIcon:SetIsVisible(true)
    else
        self.mouseOverInfoCooldownText:SetIsVisible(false)
        self.mouseOverInfoCooldownIcon:SetIsVisible(false)
        hasCooldown = false
    end

    local iconTexture = LookupUpgradeData(techId, kUpDataLargeIconTextureIndex)
    local iconSize = LookupUpgradeData(techId, kUpDataLargeIconSizeIndex)

    if iconTexture and iconSize then
        local iconSizeScaled = Vector(GUIScaleWidth(iconSize.x / 2), GUIScaleHeight(iconSize.y / 2), 0)
        local pos = ((MarineBuyMenu.kInfoBackgroundSize / 2) - (iconSizeScaled / 2)) + MarineBuyMenu.kInfoIconOffset
        self.mouseOverInfoIcon:SetSize(iconSizeScaled)
        self.mouseOverInfoIcon:SetTexture(iconTexture)
        self.mouseOverInfoIcon:SetTexturePixelCoordinates(unpack(CombatUI_GetMarineUpgradeLargeTextureCoords(techId, enabled)))
        self.mouseOverInfoIcon:SetPosition(pos)
        self.mouseOverInfoIcon:SetIsVisible(true)
    else
        self.mouseOverInfoIcon:SetIsVisible(false)
    end

end

function MarineBuyMenu:_UpdateItemButtons(deltaTime)

    self.helpText:SetText("")
    self.helpText:SetIsVisible(false)

    self.infoBorder:SetIsVisible(false)

    if self.itemButtons then

        for i, item in ipairs(self.itemButtons) do

            if GetIsMouseOver(self, item.Button) then

                item.Button:SetColor( MarineBuyMenu.kBtnHighlightColor )

                local player = Client.GetLocalPlayer()
                local cost = LookupUpgradeData(item.TechId, kUpDataCostIndex)
                local rankRequired = LookupUpgradeData(item.TechId, kUpDataRankIndex)
                local equipped = GetIsEquipped(item.TechId) and not CombatPlusPlus_GetIsStructureTechId(item.TechId)
                local hasPrereq = GetHasPrerequisite(item.TechId)
                local canAfford = cost <= player.combatUpgradePoints
                local hasRequiredRank = rankRequired <= player.combatRank
                local isHardcapped = GetIsHardCapped(item.TechId, player)
                local helpString = ""

                if equipped then

                    helpString = "Cannot purchase. Item already equipped."
                    self.helpText:SetColor(MarineBuyMenu.kRedHighlight)

                elseif not hasRequiredRank then

                    helpString = "Cannot purchase. Required rank not met."
                    self.helpText:SetColor(MarineBuyMenu.kRedHighlight)
                    item.Button:SetColor(MarineBuyMenu.kRedHighlight)

                elseif not hasPrereq then

                    helpString = "Cannot purchase. Required prerequisite not met."
                    self.helpText:SetColor(MarineBuyMenu.kRedHighlight)
                    item.Button:SetColor(MarineBuyMenu.kRedHighlight)

                elseif not canAfford then

                    helpString = "Cannot purchase. Not enough upgrade points."
                    self.helpText:SetColor(MarineBuyMenu.kRedHighlight)
                    item.Button:SetColor(MarineBuyMenu.kRedHighlight)

                elseif isHardcapped then

                    if CombatPlusPlus_GetIsStructureTechId(item.TechId) then
                        helpString = "Cannot purchase.  Too many of this structure type are already built."
                    else
                        helpString = "Cannot purchase.  Too many players already have this upgrade."
                    end

                    self.helpText:SetColor(MarineBuyMenu.kRedHighlight)
                    item.Button:SetColor(MarineBuyMenu.kRedHighlight)

                else
                    if cost == 1 then
                        helpString = string.format("Purchase %s for %s upgrade point.", GetDisplayNameForTechId(item.TechId), cost)
                    else
                        helpString = string.format("Purchase %s for %s upgrade points.", GetDisplayNameForTechId(item.TechId), cost)
                    end

                    self.helpText:SetColor(MarineBuyMenu.kTextColor)
                end

                textSize = Fancy_CalculateTextSize(helpString, Fonts.kAgencyFB_Tiny)
                self.helpText:SetPosition( Vector(-textSize.x, 0, 0) + MarineBuyMenu.kHelpTextOffset )
                self.helpText:SetText(helpString)
                self.helpText:SetIsVisible(true)

                self:ShowMouseOverInfo(item.TechId)

            else

                item.Button:SetColor( MarineBuyMenu.kBtnColor )

            end

        end

    end

end

local function HandleItemClicked(self, mouseX, mouseY)

    if self.itemButtons then

        for i = 1, #self.itemButtons do

            local item = self.itemButtons[i]
            if GetIsMouseOver(self, item.Button) then

                local player = Client.GetLocalPlayer()
                local cost = LookupUpgradeData(item.TechId, kUpDataCostIndex)
                local rankRequired = LookupUpgradeData(item.TechId, kUpDataRankIndex)
                local equipped = GetIsEquipped(item.TechId) and not CombatPlusPlus_GetIsStructureTechId(item.TechId)
                local hasPrereq = GetHasPrerequisite(item.TechId)
                local canAfford = cost <= player.combatUpgradePoints
                local hasRequiredRank = rankRequired <= player.combatRank
                local isHardcapped = GetIsHardCapped(item.TechId, player)

                if hasRequiredRank and canAfford and hasPrereq and not equipped and not isHardcapped then

                    MarineBuy_PurchaseItem(item.TechId)
                    MarineBuy_OnClose()

                    return true, true

                end

            end

        end

    end

    return false, false

end

function MarineBuyMenu:SendKeyEvent(key, down)

    local closeMenu = false
    local inputHandled = false

    if key == InputKey.MouseButton0 and self.mousePressed ~= down then

        self.mousePressed = down

        local mouseX, mouseY = Client.GetCursorPosScreen()
        if down then

            inputHandled, closeMenu = HandleItemClicked(self, mouseX, mouseY)

        end

    end

    -- No matter what, this menu consumes MouseButton0/1.
    if key == InputKey.MouseButton0 or key == InputKey.MouseButton1 then
        inputHandled = true
    end

    if InputKey.Escape == key and not down then

        closeMenu = true
        inputHandled = true
        MarineBuy_OnClose()

    end

    if closeMenu then

        self.closingMenu = true
        MarineBuy_Close()

    end

    return inputHandled

end
