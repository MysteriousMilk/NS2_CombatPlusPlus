--[[
 * Natural Selection 2 - Combat++ Mod
 * Authors:
 *          WhiteWizard
 *
 * New GUI that appears when the marines attempt to buy something using the 'B' key.
]]

Script.Load("lua/GUIAnimatedScript.lua")

class 'CPPGUICombatMarineBuyMenu' (GUIAnimatedScript)

CPPGUICombatMarineBuyMenu.kBackgroundColor = Color(0.05, 0.05, 0.1, 0.6)
CPPGUICombatMarineBuyMenu.kBackgroundCenterColor = Color(0.06, 0.06, 0.12, 0.8)
CPPGUICombatMarineBuyMenu.kBackgroundSize = Vector(1024, 1024, 0)

CPPGUICombatMarineBuyMenu.kLogoTexture = PrecacheAsset("ui/logo_marine.dds")
CPPGUICombatMarineBuyMenu.kLogoSize = Vector(256, 256, 0)

CPPGUICombatMarineBuyMenu.kButtonTexture = PrecacheAsset("ui/combatui_buymenu_button.dds")
CPPGUICombatMarineBuyMenu.kButtonSize = Vector(200, 64, 0)

CPPGUICombatMarineBuyMenu.kButtonLargeTexture = PrecacheAsset("ui/combatui_buymenu_button_large.dds")
CPPGUICombatMarineBuyMenu.kButtonLargeSize = Vector(128, 192, 0)

CPPGUICombatMarineBuyMenu.kButtonPadding = Vector(10, 20, 0)
CPPGUICombatMarineBuyMenu.kButtonLargePadding = Vector(55, 20, 0)

CPPGUICombatMarineBuyMenu.kWeaponIconTexture = PrecacheAsset("ui/combatui_marine_weapon_icons.dds")
CPPGUICombatMarineBuyMenu.kStructureIconTexture = PrecacheAsset("ui/combatui_marine_structure_icons_large.dds")
CPPGUICombatMarineBuyMenu.kTechIconTexture = PrecacheAsset("ui/combatui_marine_tech_icons.dds")
CPPGUICombatMarineBuyMenu.kConsumableIconTexture = PrecacheAsset("ui/combatui_marine_consumable_icons.dds")
CPPGUICombatMarineBuyMenu.kUpgradeIconTexture = PrecacheAsset("ui/combatui_marine_upgrade_icons.dds")

CPPGUICombatMarineBuyMenu.kResIconTexture = PrecacheAsset("ui/pres_icon_big.dds")

CPPGUICombatMarineBuyMenu.kTitleFont = Fonts.kAgencyFB_Large
CPPGUICombatMarineBuyMenu.kHeaderFont = Fonts.kAgencyFB_Medium
CPPGUICombatMarineBuyMenu.kTextColor = Color(kMarineFontColor)

CPPGUICombatMarineBuyMenu.kBtnColor = Color(1, 1, 1, 0.7)
CPPGUICombatMarineBuyMenu.kBtnHighlightColor = Color(0.5, 0.5, 1.0, 0.7)

CPPGUICombatMarineBuyMenu.kBlueHighlight = Color(0.6, 0.6, 1, 1)
CPPGUICombatMarineBuyMenu.kRedHighlight = Color(1, 0.3, 0.3, 1)

CPPGUICombatMarineBuyMenu.kButtonsPerRow = 4

local weaponIconHeight = 64
local weaponIconWidth = 128
local gWeaponIconIndex
local function GetWeaponIconPixelCoordinates(itemTechId, enabled)

  if not gWeaponIconIndex then

    gWeaponIconIndex = {}
    gWeaponIconIndex[kTechId.Pistol] = 0
    gWeaponIconIndex[kTechId.Rifle] = 1
    gWeaponIconIndex[kTechId.Shotgun] = 2
    gWeaponIconIndex[kTechId.Flamethrower] = 3
    gWeaponIconIndex[kTechId.GrenadeLauncher] = 4
    gWeaponIconIndex[kTechId.HeavyMachineGun] = 5

  end

  local x1 = 0
  local x2 = weaponIconWidth
  if not enabled then
    x1 = weaponIconWidth
    x2 = weaponIconWidth * 2
  end

  local index = gWeaponIconIndex[itemTechId]
  if not index then
      index = 0
  end

  local y1 = index * weaponIconHeight
  local y2 = (index + 1) * weaponIconHeight

  return x1, y1, x2, y2

end

local smallIconHeight = 64
local smallIconWidth = 64
local gTechIconIndex
local function GetTechIconPixelCoordinates(itemTechId, enabled)

  if not gTechIconIndex then

    gTechIconIndex = {}
    gTechIconIndex[kTechId.Welder] = 0
    gTechIconIndex[kTechId.LayMines] = 1
    gTechIconIndex[kTechId.ClusterGrenade] = 2
    gTechIconIndex[kTechId.GasGrenade] = 3
    gTechIconIndex[kTechId.PulseGrenade] = 4
    gTechIconIndex[kTechId.Jetpack] = 5
    gTechIconIndex[kTechId.DualMinigunExosuit] = 6

  end

  local x1 = 0
  local x2 = smallIconWidth
  if not enabled then
    x1 = smallIconWidth
    x2 = smallIconWidth * 2
  end

  local index = gTechIconIndex[itemTechId]
  if not index then
      index = 0
  end

  local y1 = index * smallIconHeight
  local y2 = (index + 1) * smallIconHeight

  return x1, y1, x2, y2

end

local gUpgradeIconIndex
local function GetUpgradeIconPixelCoordinates(itemTechId)

  if not gUpgradeIconIndex then

    gUpgradeIconIndex = {}
    gUpgradeIconIndex[kTechId.Armor1] = 0
    gUpgradeIconIndex[kTechId.Armor2] = 1
    gUpgradeIconIndex[kTechId.Armor3] = 2
    gUpgradeIconIndex[kTechId.Weapons1] = 3
    gUpgradeIconIndex[kTechId.Weapons2] = 4
    gUpgradeIconIndex[kTechId.Weapons3] = 5

  end

  local x1 = 0
  local x2 = smallIconWidth

  local index = gUpgradeIconIndex[itemTechId]
  if not index then
      index = 0
  end

  local y1 = index * smallIconHeight
  local y2 = (index + 1) * smallIconHeight

  return x1, y1, x2, y2

end

local gConsumableIconIndex
local function GetConsumableIconPixelCoordinates(itemTechId, enabled)

  if not gConsumableIconIndex then

    gConsumableIconIndex = {}
    gConsumableIconIndex[kTechId.MedPack] = 0
    gConsumableIconIndex[kTechId.AmmoPack] = 1
    gConsumableIconIndex[kTechId.CatPack] = 2
    gConsumableIconIndex[kTechId.Scan] = 3

  end

  local x1 = 0
  local x2 = smallIconWidth
  if not enabled then
    x1 = smallIconWidth
    x2 = smallIconWidth * 2
  end

  local index = gConsumableIconIndex[itemTechId]
  if not index then
      index = 0
  end

  local y1 = index * smallIconHeight
  local y2 = (index + 1) * smallIconHeight

  return x1, y1, x2, y2

end

local structureIconHeight = 192
local structureIconWidth = 128
local gStructureIconIndex
local function GetStructureIconPixelCoordinates(itemTechId, enabled)

  if not gStructureIconIndex then

    gStructureIconIndex = {}
    gStructureIconIndex[kTechId.Armory] = 0
    gStructureIconIndex[kTechId.PhaseGate] = 1
    gStructureIconIndex[kTechId.Observatory] = 2
    gStructureIconIndex[kTechId.Sentry] = 3
    gStructureIconIndex[kTechId.RoboticsFactory] = 4

  end

  local index = gStructureIconIndex[itemTechId]
  if not index then
      index = 0
  end

  local x1 = index * structureIconWidth
  local x2 = (index + 1) * structureIconWidth

  local y1 = 0
  local y2 = structureIconHeight

  if not enabled then
    y1 = structureIconHeight
    y2 = structureIconHeight * 2
  end

  return x1, y1, x2, y2

end


local function GetWeaponItemList()

    local weaponItemList =
    {
        kTechId.Pistol,
        kTechId.Rifle,
        kTechId.Shotgun,
        kTechId.Flamethrower,
        kTechId.GrenadeLauncher,
        kTechId.HeavyMachineGun
    }

    return weaponItemList

end

local function GetTechItemList()

    local techItemList =
    {
        kTechId.Welder,
        kTechId.LayMines,
        kTechId.ClusterGrenade,
        kTechId.GasGrenade,
        kTechId.PulseGrenade,
        kTechId.Jetpack,
        kTechId.DualMinigunExosuit
    }

    return techItemList

end

local function GetUpgradeItemList()

    local upgradeItemList =
    {
        kTechId.Armor1,
        kTechId.Weapons1,
        kTechId.Armor2,
        kTechId.Weapons2,
        kTechId.Armor3,
        kTechId.Weapons3
    }

    return upgradeItemList

end

local function GetConsumableItemList()

    local consumableItemList =
    {
        kTechId.MedPack,
        kTechId.AmmoPack,
        kTechId.CatPack,
        kTechId.Scan
    }

    return consumableItemList

end

local function GetStructureItemList()

    local structureItemList =
    {
        kTechId.Armory,
        kTechId.PhaseGate,
        kTechId.Observatory,
        kTechId.Sentry,
        kTechId.RoboticsFactory
    }

    return structureItemList

end

local function GetIsEquipped(techId)

    local player = Client.GetLocalPlayer()
    local armorLevel = player:GetArmorLevel()
    local weaponLevel = player:GetWeaponLevel()

    if techId == kTechId.Armor1 and armorLevel == 1 then
        return true
    end

    if techId == kTechId.Armor2 and armorLevel == 2 then
        return true
    end

    if techId == kTechId.Armor3 and armorLevel == 3 then
        return true
    end

    if techId == kTechId.Weapons1 and weaponLevel == 1 then
        return true
    end

    if techId == kTechId.Weapons2 and weaponLevel == 2 then
        return true
    end

    if techId == kTechId.Weapons3 and weaponLevel == 3 then
        return true
    end

    local equippedTechIds = MarineBuy_GetEquipped()

    for k, itemTechId in ipairs(equippedTechIds) do

        if techId == itemTechId then
            return true
        end

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

function CPPGUICombatMarineBuyMenu:Initialize()

    GUIAnimatedScript.Initialize(self)

    self.mouseOverStates = { }

    self:_InitializeBackground()
    self:_InitializeHeaders()
    self:_InitializeButtons()

    MarineBuy_OnOpen()
    MouseTracker_SetIsVisible(true, "ui/Cursor_MenuDefault.dds", true)

end

function CPPGUICombatMarineBuyMenu:Update(deltaTime)

    PROFILE("CPPGUICombatMarineBuyMenu:Update")

    GUIAnimatedScript.Update(self, deltaTime)
    self:_UpdateItemButtons(deltaTime)

end

function CPPGUICombatMarineBuyMenu:Uninitialize()

    GUIAnimatedScript.Uninitialize(self)

    GUI.DestroyItem(self.background)
    self.background = nil
    self.backgroundVisual = nil
    self.btnPistol = nil

    MouseTracker_SetIsVisible(false)

end

function CPPGUICombatMarineBuyMenu:OnResolutionChanged(oldX, oldY, newX, newY)

    self:Uninitialize()
    self:Initialize()

    MarineBuy_OnClose()

end

function CPPGUICombatMarineBuyMenu:_InitializeBackground()

    self.background = GUIManager:CreateGraphicItem()
    self.background:SetSize( Vector(Client.GetScreenWidth(), Client.GetScreenHeight(), 0) )
    self.background:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.background:SetColor(CPPGUICombatMarineBuyMenu.kBackgroundColor)
    self.background:SetLayer(kGUILayerPlayerHUDForeground4)

    self.backgroundCenteredArea = GUIManager:CreateGraphicItem()
    self.backgroundCenteredArea:SetSize( Vector(1000, Client.GetScreenHeight(), 0) )
    self.backgroundCenteredArea:SetAnchor(GUIItem.Middle, GUIItem.Top)
    self.backgroundCenteredArea:SetPosition( Vector(-500, 0, 0) )
    self.backgroundCenteredArea:SetColor(CPPGUICombatMarineBuyMenu.kBackgroundCenterColor)
    self.background:AddChild(self.backgroundCenteredArea)

end

function CPPGUICombatMarineBuyMenu:_InitializeHeaders()

    local player = Client.GetLocalPlayer()

    self.logo = GetGUIManager():CreateGraphicItem()
    self.logo:SetSize( CPPGUICombatMarineBuyMenu.kLogoSize )
    self.logo:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.logo:SetPosition( Vector(-10, -60, 0) )
    self.logo:SetScale( Vector(0.5, 0.5, 0) )
    self.logo:SetTexture(CPPGUICombatMarineBuyMenu.kLogoTexture)
    self.logo:SetTexturePixelCoordinates(0, 0, CPPGUICombatMarineBuyMenu.kLogoSize.x, CPPGUICombatMarineBuyMenu.kLogoSize.y)
    self.logo:SetColor( Color(1, 1, 1, 1) )
    self.backgroundCenteredArea:AddChild(self.logo)

    self.titleText = GetGUIManager():CreateTextItem()
    self.titleText:SetFontName(CPPGUICombatMarineBuyMenu.kTitleFont)
    self.titleText:SetFontIsBold(true)
    self.titleText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.titleText)
    self.titleText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.titleText:SetPosition( Vector(208, 40, 0) )
    self.titleText:SetTextAlignmentX(GUIItem.Align_Min)
    self.titleText:SetTextAlignmentY(GUIItem.Align_Center)
    self.titleText:SetColor(CPPGUICombatMarineBuyMenu.kTextColor)
    self.titleText:SetText("TSE Uplink Established")
    self.titleText:SetIsVisible(true)
    self.backgroundCenteredArea:AddChild(self.titleText)

    self.subTitleText = GetGUIManager():CreateTextItem()
    self.subTitleText:SetFontName(CPPGUICombatMarineBuyMenu.kHeaderFont)
    self.subTitleText:SetFontIsBold(true)
    self.subTitleText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.subTitleText)
    self.subTitleText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.subTitleText:SetPosition( Vector(208, 80, 0) )
    self.subTitleText:SetTextAlignmentX(GUIItem.Align_Min)
    self.subTitleText:SetTextAlignmentY(GUIItem.Align_Center)
    self.subTitleText:SetColor(CPPGUICombatMarineBuyMenu.kTextColor)
    self.subTitleText:SetText(string.format("Logged in as %s", player:GetName()))
    self.subTitleText:SetIsVisible(true)
    self.backgroundCenteredArea:AddChild(self.subTitleText)

    self.skillPointText = GetGUIManager():CreateTextItem()
    self.skillPointText:SetFontName(Fonts.kAgencyFB_Small)
    self.skillPointText:SetFontIsBold(true)
    self.skillPointText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.skillPointText)
    self.skillPointText:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.skillPointText:SetPosition( Vector(-125, 85, 0) )
    self.skillPointText:SetTextAlignmentX(GUIItem.Align_Min)
    self.skillPointText:SetTextAlignmentY(GUIItem.Align_Center)
    self.skillPointText:SetColor(CPPGUICombatMarineBuyMenu.kTextColor)
    self.skillPointText:SetIsVisible(true)
    self.backgroundCenteredArea:AddChild(self.skillPointText)

    -- update skill point text
    if player.combatSkillPoints == 1 then
        self.skillPointText:SetText(string.format("%s Skill Point", player.combatSkillPoints))
    else
        self.skillPointText:SetText(string.format("%s Skill Points", player.combatSkillPoints))
    end

    self.skillPointIcon = GetGUIManager():CreateGraphicItem()
    self.skillPointIcon:SetSize( Vector(48, 48, 0) )
    self.skillPointIcon:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.skillPointIcon:SetPosition( Vector(-170, 61, 0) )
    self.skillPointIcon:SetScale( Vector(0.75, 0.75, 0) )
    self.skillPointIcon:SetTexture(CPPGUICombatMarineBuyMenu.kResIconTexture)
    self.skillPointIcon:SetTexturePixelCoordinates(0, 0, 48, 48)
    self.skillPointIcon:SetColor( Color(1, 1, 1, 1) )
    self.backgroundCenteredArea:AddChild(self.skillPointIcon)

    self.helpText = GetGUIManager():CreateTextItem()
    self.helpText:SetFontName(Fonts.kAgencyFB_Small)
    self.helpText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.helpText)
    self.helpText:SetAnchor(GUIItem.Right, GUIItem.Top)
    self.helpText:SetPosition( Vector(-100, 115, 0) )
    self.helpText:SetTextAlignmentX(GUIItem.Align_Min)
    self.helpText:SetTextAlignmentY(GUIItem.Align_Center)
    self.helpText:SetText("")
    self.helpText:SetColor(CPPGUICombatMarineBuyMenu.kTextColor)
    self.helpText:SetIsVisible(true)
    self.backgroundCenteredArea:AddChild(self.helpText)

    self.wpnHeaderText = GetGUIManager():CreateTextItem()
    self.wpnHeaderText:SetFontName(CPPGUICombatMarineBuyMenu.kHeaderFont)
    self.wpnHeaderText:SetFontIsBold(true)
    self.wpnHeaderText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.wpnHeaderText)
    self.wpnHeaderText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.wpnHeaderText:SetPosition( Vector(60, 148, 0) )
    self.wpnHeaderText:SetTextAlignmentX(GUIItem.Align_Min)
    self.wpnHeaderText:SetTextAlignmentY(GUIItem.Align_Center)
    self.wpnHeaderText:SetColor(CPPGUICombatMarineBuyMenu.kTextColor)
    self.wpnHeaderText:SetText("Weapons")
    self.wpnHeaderText:SetIsVisible(true)
    self.backgroundCenteredArea:AddChild(self.wpnHeaderText)

    self.upgradeHeaderText = GetGUIManager():CreateTextItem()
    self.upgradeHeaderText:SetFontName(CPPGUICombatMarineBuyMenu.kHeaderFont)
    self.upgradeHeaderText:SetFontIsBold(true)
    self.upgradeHeaderText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.upgradeHeaderText)
    self.upgradeHeaderText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.upgradeHeaderText:SetPosition( Vector(520, 148, 0) )
    self.upgradeHeaderText:SetTextAlignmentX(GUIItem.Align_Min)
    self.upgradeHeaderText:SetTextAlignmentY(GUIItem.Align_Center)
    self.upgradeHeaderText:SetColor(CPPGUICombatMarineBuyMenu.kTextColor)
    self.upgradeHeaderText:SetText("Upgrades")
    self.upgradeHeaderText:SetIsVisible(true)
    self.backgroundCenteredArea:AddChild(self.upgradeHeaderText)

    self.techHeaderText = GetGUIManager():CreateTextItem()
    self.techHeaderText:SetFontName(CPPGUICombatMarineBuyMenu.kHeaderFont)
    self.techHeaderText:SetFontIsBold(true)
    self.techHeaderText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.techHeaderText)
    self.techHeaderText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.techHeaderText:SetPosition( Vector(60, 446, 0) )
    self.techHeaderText:SetTextAlignmentX(GUIItem.Align_Min)
    self.techHeaderText:SetTextAlignmentY(GUIItem.Align_Center)
    self.techHeaderText:SetColor(CPPGUICombatMarineBuyMenu.kTextColor)
    self.techHeaderText:SetText("Tech")
    self.techHeaderText:SetIsVisible(true)
    self.backgroundCenteredArea:AddChild(self.techHeaderText)

    self.consumableHeaderText = GetGUIManager():CreateTextItem()
    self.consumableHeaderText:SetFontName(CPPGUICombatMarineBuyMenu.kHeaderFont)
    self.consumableHeaderText:SetFontIsBold(true)
    self.consumableHeaderText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.consumableHeaderText)
    self.consumableHeaderText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.consumableHeaderText:SetPosition( Vector(60, 664, 0) )
    self.consumableHeaderText:SetTextAlignmentX(GUIItem.Align_Min)
    self.consumableHeaderText:SetTextAlignmentY(GUIItem.Align_Center)
    self.consumableHeaderText:SetColor(CPPGUICombatMarineBuyMenu.kTextColor)
    self.consumableHeaderText:SetText("Consumables")
    self.consumableHeaderText:SetIsVisible(true)
    self.backgroundCenteredArea:AddChild(self.consumableHeaderText)

    self.structureHeaderText = GetGUIManager():CreateTextItem()
    self.structureHeaderText:SetFontName(CPPGUICombatMarineBuyMenu.kHeaderFont)
    self.structureHeaderText:SetFontIsBold(true)
    self.structureHeaderText:SetScale(GetScaledVector())
    GUIMakeFontScale(self.structureHeaderText)
    self.structureHeaderText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.structureHeaderText:SetPosition( Vector(60, 798, 0) )
    self.structureHeaderText:SetTextAlignmentX(GUIItem.Align_Min)
    self.structureHeaderText:SetTextAlignmentY(GUIItem.Align_Center)
    self.structureHeaderText:SetColor(CPPGUICombatMarineBuyMenu.kTextColor)
    self.structureHeaderText:SetText("Structures")
    self.structureHeaderText:SetIsVisible(true)
    self.backgroundCenteredArea:AddChild(self.structureHeaderText)

end

local function InitWeaponButtons(self, player)

    local columnIndex = 0
    local rowIndex = 0
    local startOffset = Vector(60, 178, 0)

    for k, itemTechId in ipairs(GetWeaponItemList()) do

        if columnIndex == 2 then

            columnIndex = 0
            rowIndex = rowIndex + 1

        end

        local x = startOffset.x + (columnIndex * (CPPGUICombatMarineBuyMenu.kButtonSize.x + CPPGUICombatMarineBuyMenu.kButtonPadding.x))
        local y = startOffset.y + (rowIndex * (CPPGUICombatMarineBuyMenu.kButtonSize.y + CPPGUICombatMarineBuyMenu.kButtonPadding.y))

        local buttonGraphic = GUIManager:CreateGraphicItem()
        buttonGraphic:SetSize( CPPGUICombatMarineBuyMenu.kButtonSize )
        buttonGraphic:SetAnchor(GUIItem.Left, GUIItem.Top)
        buttonGraphic:SetPosition( Vector(x, y, 0) )
        buttonGraphic:SetTexture(CPPGUICombatMarineBuyMenu.kButtonTexture)
        buttonGraphic:SetTexturePixelCoordinates(0, 0, CPPGUICombatMarineBuyMenu.kButtonSize.x, CPPGUICombatMarineBuyMenu.kButtonSize.y)
        buttonGraphic:SetColor( CPPGUICombatMarineBuyMenu.kBtnColor )
        self.backgroundCenteredArea:AddChild(buttonGraphic)

        local cost = CombatPlusPlus_GetCostByTechId(itemTechId)
        local equipped = GetIsEquipped(itemTechId)
        local canAfford = cost <= player.combatSkillPoints
        local hasRequiredRank = CombatPlusPlus_GetRequiredRankByTechId(itemTechId) <= player.combatRank

        local enabled = canAfford and hasRequiredRank and not equipped
        local iconColor = Color(1, 1, 1, 1)

        if equipped then
            iconColor = CPPGUICombatMarineBuyMenu.kBlueHighlight
        elseif hasRequiredRank and not canAfford then
            iconColor = CPPGUICombatMarineBuyMenu.kRedHighlight
        end

        local buttonIcon = GUIManager:CreateGraphicItem()
        buttonIcon:SetSize( Vector(weaponIconWidth, weaponIconHeight, 0) )
        buttonIcon:SetAnchor(GUIItem.Left, GUIItem.Top)
        buttonIcon:SetPosition( Vector(x, y, 0) )
        buttonIcon:SetTexture(CPPGUICombatMarineBuyMenu.kWeaponIconTexture)
        buttonIcon:SetTexturePixelCoordinates(GetWeaponIconPixelCoordinates(itemTechId, enabled))
        buttonIcon:SetColor(iconColor)
        self.backgroundCenteredArea:AddChild(buttonIcon)

        local weaponText = GUIManager:CreateTextItem()
        weaponText:SetFontName(Fonts.kAgencyFB_Tiny)
        weaponText:SetScale(GetScaledVector())
        GUIMakeFontScale(weaponText)
        weaponText:SetAnchor(GUIItem.Right, GUIItem.Top)
        weaponText:SetPosition( Vector(-6, 14, 0) )
        weaponText:SetTextAlignmentX(GUIItem.Align_Max)
        weaponText:SetTextAlignmentY(GUIItem.Align_Center)
        weaponText:SetColor(CPPGUICombatMarineBuyMenu.kTextColor)
        weaponText:SetText(GetDisplayNameForTechId(itemTechId))
        buttonGraphic:AddChild(weaponText)

        local resColor = CPPGUICombatMarineBuyMenu.kTextColor
        if not canAfford or not hasRequiredRank then
            resColor = CPPGUICombatMarineBuyMenu.kRedHighlight
        end

        local resIcon = GUIManager:CreateGraphicItem()
        resIcon:SetSize( Vector(48, 48, 0) )
        resIcon:SetScale( Vector(0.4, 0.4, 0) )
        resIcon:SetAnchor(GUIItem.Right, GUIItem.Bottom)
        resIcon:SetPosition( Vector(-50, -38, 0))
        resIcon:SetTexture(CPPGUICombatMarineBuyMenu.kResIconTexture)
        resIcon:SetTexturePixelCoordinates( 0, 0, 48, 48 )
        resIcon:SetColor( resColor )
        buttonGraphic:AddChild(resIcon)

        local resText = GUIManager:CreateTextItem()
        resText:SetFontName(Fonts.kAgencyFB_Tiny)
        resText:SetScale(GetScaledVector())
        GUIMakeFontScale(resText)
        resText:SetAnchor(GUIItem.Right, GUIItem.Bottom)
        resText:SetPosition( Vector(-8, -14, 0) )
        resText:SetTextAlignmentX(GUIItem.Align_Max)
        resText:SetTextAlignmentY(GUIItem.Align_Center)
        resText:SetColor(resColor)
        resText:SetText(string.format("%s", cost))
        buttonGraphic:AddChild(resText)

        columnIndex = columnIndex + 1

        table.insert(self.itemButtons, { Button = buttonGraphic, TechId = itemTechId } )

    end

end

local function InitUpgradeButtons(self, player)

    local columnIndex = 0
    local rowIndex = 0
    local startOffset = Vector(520, 178, 0)

    for k, itemTechId in ipairs(GetUpgradeItemList()) do

        if columnIndex == 2 then

            columnIndex = 0
            rowIndex = rowIndex + 1

        end

        local x = startOffset.x + (columnIndex * (CPPGUICombatMarineBuyMenu.kButtonSize.x + CPPGUICombatMarineBuyMenu.kButtonPadding.x))
        local y = startOffset.y + (rowIndex * (CPPGUICombatMarineBuyMenu.kButtonSize.y + CPPGUICombatMarineBuyMenu.kButtonPadding.y))

        local buttonGraphic = GUIManager:CreateGraphicItem()
        buttonGraphic:SetSize( CPPGUICombatMarineBuyMenu.kButtonSize )
        buttonGraphic:SetAnchor(GUIItem.Left, GUIItem.Top)
        buttonGraphic:SetPosition( Vector(x, y, 0) )
        buttonGraphic:SetTexture(CPPGUICombatMarineBuyMenu.kButtonTexture)
        buttonGraphic:SetTexturePixelCoordinates(0, 0, CPPGUICombatMarineBuyMenu.kButtonSize.x, CPPGUICombatMarineBuyMenu.kButtonSize.y)
        buttonGraphic:SetColor( CPPGUICombatMarineBuyMenu.kBtnColor )
        self.backgroundCenteredArea:AddChild(buttonGraphic)

        local cost = CombatPlusPlus_GetCostByTechId(itemTechId)
        local equipped = GetIsEquipped(itemTechId)
        local canAfford = cost <= player.combatSkillPoints
        local hasRequiredRank = CombatPlusPlus_GetRequiredRankByTechId(itemTechId) <= player.combatRank

        local enabled = canAfford and hasRequiredRank and not equipped
        local iconColor = Color(1, 1, 1, 1)

        if equipped then
            iconColor = CPPGUICombatMarineBuyMenu.kBlueHighlight
        elseif hasRequiredRank and not canAfford then
            iconColor = CPPGUICombatMarineBuyMenu.kRedHighlight
        end

        local buttonIcon = GUIManager:CreateGraphicItem()
        buttonIcon:SetSize( Vector(smallIconWidth, smallIconHeight, 0) )
        buttonIcon:SetAnchor(GUIItem.Left, GUIItem.Top)
        buttonIcon:SetPosition( Vector(x, y, 0) )
        buttonIcon:SetTexture(CPPGUICombatMarineBuyMenu.kUpgradeIconTexture)
        buttonIcon:SetTexturePixelCoordinates(GetUpgradeIconPixelCoordinates(itemTechId, enabled))
        buttonIcon:SetColor(iconColor)
        self.backgroundCenteredArea:AddChild(buttonIcon)

        local buttonText = GUIManager:CreateTextItem()
        buttonText:SetFontName(Fonts.kAgencyFB_Tiny)
        buttonText:SetScale(GetScaledVector())
        GUIMakeFontScale(buttonText)
        buttonText:SetAnchor(GUIItem.Right, GUIItem.Top)
        buttonText:SetPosition( Vector(-6, 14, 0) )
        buttonText:SetTextAlignmentX(GUIItem.Align_Max)
        buttonText:SetTextAlignmentY(GUIItem.Align_Center)
        buttonText:SetColor(CPPGUICombatMarineBuyMenu.kTextColor)
        buttonText:SetText(GetDisplayNameForTechId(itemTechId))
        buttonGraphic:AddChild(buttonText)

        local resColor = CPPGUICombatMarineBuyMenu.kTextColor
        if not canAfford or not hasRequiredRank then
            resColor = CPPGUICombatMarineBuyMenu.kRedHighlight
        end

        local resIcon = GUIManager:CreateGraphicItem()
        resIcon:SetSize( Vector(48, 48, 0) )
        resIcon:SetScale( Vector(0.4, 0.4, 0) )
        resIcon:SetAnchor(GUIItem.Right, GUIItem.Bottom)
        resIcon:SetPosition( Vector(-50, -38, 0))
        resIcon:SetTexture(CPPGUICombatMarineBuyMenu.kResIconTexture)
        resIcon:SetTexturePixelCoordinates( 0, 0, 48, 48 )
        resIcon:SetColor( resColor )
        buttonGraphic:AddChild(resIcon)

        local resText = GUIManager:CreateTextItem()
        resText:SetFontName(Fonts.kAgencyFB_Tiny)
        resText:SetScale(GetScaledVector())
        GUIMakeFontScale(resText)
        resText:SetAnchor(GUIItem.Right, GUIItem.Bottom)
        resText:SetPosition( Vector(-8, -14, 0) )
        resText:SetTextAlignmentX(GUIItem.Align_Max)
        resText:SetTextAlignmentY(GUIItem.Align_Center)
        resText:SetColor(resColor)
        resText:SetText(string.format("%s", cost))
        buttonGraphic:AddChild(resText)

        columnIndex = columnIndex + 1

        table.insert(self.itemButtons, { Button = buttonGraphic, TechId = itemTechId } )

    end

end

local function InitTechButtons(self, player)

    local columnIndex = 0
    local rowIndex = 0
    local startOffset = Vector(60, 476, 0)

    for k, itemTechId in ipairs(GetTechItemList()) do

        if columnIndex == CPPGUICombatMarineBuyMenu.kButtonsPerRow then

            columnIndex = 0
            rowIndex = rowIndex + 1

        end

        local x = startOffset.x + (columnIndex * (CPPGUICombatMarineBuyMenu.kButtonSize.x + CPPGUICombatMarineBuyMenu.kButtonPadding.x))
        local y = startOffset.y + (rowIndex * (CPPGUICombatMarineBuyMenu.kButtonSize.y + CPPGUICombatMarineBuyMenu.kButtonPadding.y))

        -- add a gap between column 2 and 3
        if columnIndex >= 2 then
            x = x + 40
        end

        local buttonGraphic = GUIManager:CreateGraphicItem()
        buttonGraphic:SetSize( CPPGUICombatMarineBuyMenu.kButtonSize )
        buttonGraphic:SetAnchor(GUIItem.Left, GUIItem.Top)
        buttonGraphic:SetPosition( Vector(x, y, 0) )
        buttonGraphic:SetTexture(CPPGUICombatMarineBuyMenu.kButtonTexture)
        buttonGraphic:SetTexturePixelCoordinates(0, 0, CPPGUICombatMarineBuyMenu.kButtonSize.x, CPPGUICombatMarineBuyMenu.kButtonSize.y)
        buttonGraphic:SetColor( CPPGUICombatMarineBuyMenu.kBtnColor )
        self.backgroundCenteredArea:AddChild(buttonGraphic)

        local cost = CombatPlusPlus_GetCostByTechId(itemTechId)
        local equipped = GetIsEquipped(itemTechId)
        local canAfford = cost <= player.combatSkillPoints
        local hasRequiredRank = CombatPlusPlus_GetRequiredRankByTechId(itemTechId) <= player.combatRank

        local enabled = canAfford and hasRequiredRank and not equipped
        local iconColor = Color(1, 1, 1, 1)

        if equipped then
            iconColor = CPPGUICombatMarineBuyMenu.kBlueHighlight
        elseif hasRequiredRank and not canAfford then
            iconColor = CPPGUICombatMarineBuyMenu.kRedHighlight
        end

        local buttonIcon = GUIManager:CreateGraphicItem()
        buttonIcon:SetSize( Vector(smallIconWidth, smallIconHeight, 0) )
        buttonIcon:SetAnchor(GUIItem.Left, GUIItem.Top)
        buttonIcon:SetPosition( Vector(x, y, 0) )
        buttonIcon:SetTexture(CPPGUICombatMarineBuyMenu.kTechIconTexture)
        buttonIcon:SetTexturePixelCoordinates(GetTechIconPixelCoordinates(itemTechId, enabled))
        buttonIcon:SetColor(iconColor)
        self.backgroundCenteredArea:AddChild(buttonIcon)

        local buttonText = GUIManager:CreateTextItem()
        buttonText:SetFontName(Fonts.kAgencyFB_Tiny)
        buttonText:SetScale(GetScaledVector())
        GUIMakeFontScale(buttonText)
        buttonText:SetAnchor(GUIItem.Right, GUIItem.Top)
        buttonText:SetPosition( Vector(-6, 14, 0) )
        buttonText:SetTextAlignmentX(GUIItem.Align_Max)
        buttonText:SetTextAlignmentY(GUIItem.Align_Center)
        buttonText:SetColor(CPPGUICombatMarineBuyMenu.kTextColor)
        buttonText:SetText(GetDisplayNameForTechId(itemTechId))
        buttonGraphic:AddChild(buttonText)

        local resColor = CPPGUICombatMarineBuyMenu.kTextColor
        if not canAfford or not hasRequiredRank then
            resColor = CPPGUICombatMarineBuyMenu.kRedHighlight
        end

        local resIcon = GUIManager:CreateGraphicItem()
        resIcon:SetSize( Vector(48, 48, 0) )
        resIcon:SetScale( Vector(0.4, 0.4, 0) )
        resIcon:SetAnchor(GUIItem.Right, GUIItem.Bottom)
        resIcon:SetPosition( Vector(-50, -38, 0))
        resIcon:SetTexture(CPPGUICombatMarineBuyMenu.kResIconTexture)
        resIcon:SetTexturePixelCoordinates( 0, 0, 48, 48 )
        resIcon:SetColor( resColor )
        buttonGraphic:AddChild(resIcon)

        local resText = GUIManager:CreateTextItem()
        resText:SetFontName(Fonts.kAgencyFB_Tiny)
        resText:SetScale(GetScaledVector())
        GUIMakeFontScale(resText)
        resText:SetAnchor(GUIItem.Right, GUIItem.Bottom)
        resText:SetPosition( Vector(-8, -14, 0) )
        resText:SetTextAlignmentX(GUIItem.Align_Max)
        resText:SetTextAlignmentY(GUIItem.Align_Center)
        resText:SetColor(resColor)
        resText:SetText(string.format("%s", cost))
        buttonGraphic:AddChild(resText)

        columnIndex = columnIndex + 1

        table.insert(self.itemButtons, { Button = buttonGraphic, TechId = itemTechId } )

    end

end

local function InitConsumableButtons(self, player)

    local columnIndex = 0
    local rowIndex = 0
    local startOffset = Vector(60, 694, 0)

    for k, itemTechId in ipairs(GetConsumableItemList()) do

        if columnIndex == CPPGUICombatMarineBuyMenu.kButtonsPerRow then

            columnIndex = 0
            rowIndex = rowIndex + 1

        end

        local x = startOffset.x + (columnIndex * (CPPGUICombatMarineBuyMenu.kButtonSize.x + CPPGUICombatMarineBuyMenu.kButtonPadding.x))
        local y = startOffset.y + (rowIndex * (CPPGUICombatMarineBuyMenu.kButtonSize.y + CPPGUICombatMarineBuyMenu.kButtonPadding.y))

        -- add a gap between column 2 and 3
        if columnIndex >= 2 then
            x = x + 40
        end

        local buttonGraphic = GUIManager:CreateGraphicItem()
        buttonGraphic:SetSize( CPPGUICombatMarineBuyMenu.kButtonSize )
        buttonGraphic:SetAnchor(GUIItem.Left, GUIItem.Top)
        buttonGraphic:SetPosition( Vector(x, y, 0) )
        buttonGraphic:SetTexture(CPPGUICombatMarineBuyMenu.kButtonTexture)
        buttonGraphic:SetTexturePixelCoordinates(0, 0, CPPGUICombatMarineBuyMenu.kButtonSize.x, CPPGUICombatMarineBuyMenu.kButtonSize.y)
        buttonGraphic:SetColor( CPPGUICombatMarineBuyMenu.kBtnColor )
        self.backgroundCenteredArea:AddChild(buttonGraphic)

        local cost = CombatPlusPlus_GetCostByTechId(itemTechId)
        local equipped = GetIsEquipped(itemTechId)
        local canAfford = cost <= player.combatSkillPoints
        local hasRequiredRank = CombatPlusPlus_GetRequiredRankByTechId(itemTechId) <= player.combatRank

        local enabled = canAfford and hasRequiredRank and not equipped
        local iconColor = Color(1, 1, 1, 1)

        if equipped then
            iconColor = CPPGUICombatMarineBuyMenu.kBlueHighlight
        elseif hasRequiredRank and not canAfford then
            iconColor = CPPGUICombatMarineBuyMenu.kRedHighlight
        end

        local buttonIcon = GUIManager:CreateGraphicItem()
        buttonIcon:SetSize( Vector(smallIconWidth, smallIconHeight, 0) )
        buttonIcon:SetAnchor(GUIItem.Left, GUIItem.Top)
        buttonIcon:SetPosition( Vector(x, y, 0) )
        buttonIcon:SetTexture(CPPGUICombatMarineBuyMenu.kConsumableIconTexture)
        buttonIcon:SetTexturePixelCoordinates(GetConsumableIconPixelCoordinates(itemTechId, enabled))
        buttonIcon:SetColor(iconColor)
        self.backgroundCenteredArea:AddChild(buttonIcon)

        local buttonText = GUIManager:CreateTextItem()
        buttonText:SetFontName(Fonts.kAgencyFB_Tiny)
        buttonText:SetScale(GetScaledVector())
        GUIMakeFontScale(buttonText)
        buttonText:SetAnchor(GUIItem.Right, GUIItem.Top)
        buttonText:SetPosition( Vector(-6, 14, 0) )
        buttonText:SetTextAlignmentX(GUIItem.Align_Max)
        buttonText:SetTextAlignmentY(GUIItem.Align_Center)
        buttonText:SetColor(CPPGUICombatMarineBuyMenu.kTextColor)
        buttonText:SetText(GetDisplayNameForTechId(itemTechId))
        buttonGraphic:AddChild(buttonText)

        local resColor = CPPGUICombatMarineBuyMenu.kTextColor
        if not canAfford or not hasRequiredRank then
            resColor = CPPGUICombatMarineBuyMenu.kRedHighlight
        end

        local resIcon = GUIManager:CreateGraphicItem()
        resIcon:SetSize( Vector(48, 48, 0) )
        resIcon:SetScale( Vector(0.4, 0.4, 0) )
        resIcon:SetAnchor(GUIItem.Right, GUIItem.Bottom)
        resIcon:SetPosition( Vector(-50, -38, 0))
        resIcon:SetTexture(CPPGUICombatMarineBuyMenu.kResIconTexture)
        resIcon:SetTexturePixelCoordinates( 0, 0, 48, 48 )
        resIcon:SetColor( resColor )
        buttonGraphic:AddChild(resIcon)

        local resText = GUIManager:CreateTextItem()
        resText:SetFontName(Fonts.kAgencyFB_Tiny)
        resText:SetScale(GetScaledVector())
        GUIMakeFontScale(resText)
        resText:SetAnchor(GUIItem.Right, GUIItem.Bottom)
        resText:SetPosition( Vector(-8, -14, 0) )
        resText:SetTextAlignmentX(GUIItem.Align_Max)
        resText:SetTextAlignmentY(GUIItem.Align_Center)
        resText:SetColor(resColor)
        resText:SetText(string.format("%s", cost))
        buttonGraphic:AddChild(resText)

        columnIndex = columnIndex + 1

        table.insert(self.itemButtons, { Button = buttonGraphic, TechId = itemTechId } )

    end

end

local function InitStructureButtons(self, player)

    local columnIndex = 0
    local rowIndex = 0
    local startOffset = Vector(60, 828, 0)

    for k, itemTechId in ipairs(GetStructureItemList()) do

        if columnIndex == 5 then

            columnIndex = 0
            rowIndex = rowIndex + 1

        end

        local x = startOffset.x + (columnIndex * (CPPGUICombatMarineBuyMenu.kButtonLargeSize.x + CPPGUICombatMarineBuyMenu.kButtonLargePadding.x))
        local y = startOffset.y + (rowIndex * (CPPGUICombatMarineBuyMenu.kButtonLargeSize.y + CPPGUICombatMarineBuyMenu.kButtonLargePadding.y))

        local buttonGraphic = GUIManager:CreateGraphicItem()
        buttonGraphic:SetSize( CPPGUICombatMarineBuyMenu.kButtonLargeSize )
        buttonGraphic:SetAnchor(GUIItem.Left, GUIItem.Top)
        buttonGraphic:SetPosition( Vector(x, y, 0) )
        buttonGraphic:SetTexture(CPPGUICombatMarineBuyMenu.kButtonLargeTexture)
        buttonGraphic:SetTexturePixelCoordinates(0, 0, CPPGUICombatMarineBuyMenu.kButtonLargeSize.x, CPPGUICombatMarineBuyMenu.kButtonLargeSize.y)
        buttonGraphic:SetColor( CPPGUICombatMarineBuyMenu.kBtnColor )
        self.backgroundCenteredArea:AddChild(buttonGraphic)

        local cost = CombatPlusPlus_GetCostByTechId(itemTechId)
        local canAfford = cost <= player.combatSkillPoints
        local hasRequiredRank = CombatPlusPlus_GetRequiredRankByTechId(itemTechId) <= player.combatRank

        local enabled = canAfford and hasRequiredRank
        local iconColor = Color(1, 1, 1, 1)

        if hasRequiredRank and not canAfford then
            iconColor = CPPGUICombatMarineBuyMenu.kRedHighlight
        end

        local buttonIcon = GUIManager:CreateGraphicItem()
        buttonIcon:SetSize( Vector(structureIconWidth, structureIconHeight, 0) )
        buttonIcon:SetAnchor(GUIItem.Left, GUIItem.Top)
        buttonIcon:SetPosition( Vector(x, y, 0) )
        buttonIcon:SetTexture(CPPGUICombatMarineBuyMenu.kStructureIconTexture)
        buttonIcon:SetTexturePixelCoordinates(GetStructureIconPixelCoordinates(itemTechId, enabled))
        buttonIcon:SetColor(iconColor)
        self.backgroundCenteredArea:AddChild(buttonIcon)

        local buttonText = GUIManager:CreateTextItem()
        buttonText:SetFontName(Fonts.kAgencyFB_Tiny)
        buttonText:SetScale(GetScaledVector())
        GUIMakeFontScale(buttonText)
        buttonText:SetAnchor(GUIItem.Left, GUIItem.Bottom)
        buttonText:SetPosition( Vector(6, -14, 0) )
        buttonText:SetTextAlignmentX(GUIItem.Align_Min)
        buttonText:SetTextAlignmentY(GUIItem.Align_Center)
        buttonText:SetColor(CPPGUICombatMarineBuyMenu.kTextColor)
        buttonText:SetText(GetDisplayNameForTechId(itemTechId))
        buttonGraphic:AddChild(buttonText)

        local resColor = CPPGUICombatMarineBuyMenu.kTextColor
        if not canAfford or not hasRequiredRank then
            resColor = CPPGUICombatMarineBuyMenu.kRedHighlight
        end

        local resIcon = GUIManager:CreateGraphicItem()
        resIcon:SetSize( Vector(48, 48, 0) )
        resIcon:SetScale( Vector(0.4, 0.4, 0) )
        resIcon:SetAnchor(GUIItem.Right, GUIItem.Bottom)
        resIcon:SetPosition( Vector(-50, -38, 0))
        resIcon:SetTexture(CPPGUICombatMarineBuyMenu.kResIconTexture)
        resIcon:SetTexturePixelCoordinates( 0, 0, 48, 48 )
        resIcon:SetColor( resColor )
        buttonGraphic:AddChild(resIcon)

        local resText = GUIManager:CreateTextItem()
        resText:SetFontName(Fonts.kAgencyFB_Tiny)
        resText:SetScale(GetScaledVector())
        GUIMakeFontScale(resText)
        resText:SetAnchor(GUIItem.Right, GUIItem.Bottom)
        resText:SetPosition( Vector(-8, -14, 0) )
        resText:SetTextAlignmentX(GUIItem.Align_Max)
        resText:SetTextAlignmentY(GUIItem.Align_Center)
        resText:SetColor(resColor)
        resText:SetText(string.format("%s", cost))
        buttonGraphic:AddChild(resText)

        columnIndex = columnIndex + 1

        table.insert(self.itemButtons, { Button = buttonGraphic, TechId = itemTechId } )

    end

end

function CPPGUICombatMarineBuyMenu:_InitializeButtons()

    local player = Client.GetLocalPlayer()

    self.itemButtons = { }

    InitWeaponButtons(self, player)
    InitUpgradeButtons(self, player)
    InitTechButtons(self, player)
    InitConsumableButtons(self, player)
    InitStructureButtons(self, player)

    -- to prevent wrong display before the first update
    self:_UpdateItemButtons(0)

end

function CPPGUICombatMarineBuyMenu:_UpdateItemButtons(deltaTime)

    self.helpText:SetText("")

    if self.itemButtons then

        for i, item in ipairs(self.itemButtons) do

            if GetIsMouseOver(self, item.Button) then

                item.Button:SetColor( CPPGUICombatMarineBuyMenu.kBtnHighlightColor )

                local player = Client.GetLocalPlayer()
                local cost = CombatPlusPlus_GetCostByTechId(item.TechId)
                local equipped = GetIsEquipped(item.TechId)
                local canAfford = cost <= player.combatSkillPoints
                local hasRequiredRank = CombatPlusPlus_GetRequiredRankByTechId(item.TechId) <= player.combatRank
                local helpString = ""

                if equipped then

                    helpString = "Cannot purchase. Item already equipped."
                    self.helpText:SetColor(CPPGUICombatMarineBuyMenu.kRedHighlight)

                elseif not hasRequiredRank then

                    helpString = "Cannot purchase. Required rank not met."
                    self.helpText:SetColor(CPPGUICombatMarineBuyMenu.kRedHighlight)

                elseif not canAfford then

                    helpString = "Cannot purchase. Not enough skill points."
                    self.helpText:SetColor(CPPGUICombatMarineBuyMenu.kRedHighlight)

                else
                    if cost == 1 then
                        helpString = string.format("Purchase %s for %s skill point.", GetDisplayNameForTechId(item.TechId), cost)
                    else
                        helpString = string.format("Purchase %s for %s skill points.", GetDisplayNameForTechId(item.TechId), cost)
                    end

                    self.helpText:SetColor(CPPGUICombatMarineBuyMenu.kTextColor)
                end

                textSize = Fancy_CalculateTextSize(helpString, Fonts.kAgencyFB_Small)
                self.helpText:SetPosition( Vector((textSize.x * -1) - 40, 115, 0) )
                self.helpText:SetText(helpString)

            else

                item.Button:SetColor( CPPGUICombatMarineBuyMenu.kBtnColor )

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
              local equipped = GetIsEquipped(itemTechId)
              local canAfford = CombatPlusPlus_GetCostByTechId(itemTechId) <= player.combatSkillPoints
              local hasRequiredRank = CombatPlusPlus_GetRequiredRankByTechId(itemTechId) <= player.combatRank

                if hasRequiredRank and canAfford and not equipped then

                    MarineBuy_PurchaseItem(item.TechId)
                    MarineBuy_OnClose()

                    return true, true

                end

            end

        end
    end

    return false, false

end

function CPPGUICombatMarineBuyMenu:SendKeyEvent(key, down)

    local closeMenu = false
    local inputHandled = false

    if key == InputKey.MouseButton0 and self.mousePressed ~= down then

        self.mousePressed = down

        local mouseX, mouseY = Client.GetCursorPosScreen()
        if down then

            inputHandled, closeMenu = HandleItemClicked(self, mouseX, mouseY)

            --if not inputHandled then

                -- Check if the close button was pressed.
                --if GetIsMouseOver(self, self.closeButton) then

                --    closeMenu = true
                --    MarineBuy_OnClose()

                --end

            --end

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
