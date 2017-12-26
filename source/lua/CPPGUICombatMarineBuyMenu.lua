Script.Load("lua/GUIAnimatedScript.lua")

class 'CPPGUICombatMarineBuyMenu' (GUIAnimatedScript)

CPPGUICombatMarineBuyMenu.kBackgroundColor = Color(0.05, 0.05, 0.1, 0.6)
CPPGUICombatMarineBuyMenu.kBackgroundCenterColor = Color(0.06, 0.06, 0.12, 0.8)
CPPGUICombatMarineBuyMenu.kBackgroundTexture = PrecacheAsset("ui/combatui_marine_buy_bkg.dds")
CPPGUICombatMarineBuyMenu.kBackgroundSize = Vector(1024, 1024, 0)

CPPGUICombatMarineBuyMenu.kButtonTexture = PrecacheAsset("ui/combatui_buymenu_button.dds")
CPPGUICombatMarineBuyMenu.kButtonSize = Vector(200, 64, 0)
CPPGUICombatMarineBuyMenu.kButtonPadding = Vector(10, 20, 0)

CPPGUICombatMarineBuyMenu.kIconTexture = PrecacheAsset("ui/combatui_weapon_icons.dds")
CPPGUICombatMarineBuyMenu.kSelectorTexture = PrecacheAsset("ui/marine_buymenu_selector.dds")

CPPGUICombatMarineBuyMenu.kHeaderFont = Fonts.kAgencyFB_Medium
CPPGUICombatMarineBuyMenu.kTextColor = Color(kMarineFontColor)

CPPGUICombatMarineBuyMenu.kBtnColor = Color(1, 1, 1, 0.7)
CPPGUICombatMarineBuyMenu.kBtnHighlightColor = Color(0.5, 0.5, 1.0, 0.7)

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

local function GetIsEquipped(techId)

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

  --self.backgroundVisual = GUIManager.CreateGraphicItem()
  --self.backgroundVisual:SetSize(CPPGUICombatMarineBuyMenu.kBtnOverlaySize)
  --self.backgroundVisual:SetAnchor(GUIItem.Middle, GUIItem.Center)
  --self.backgroundVisual:SetPosition( Vector(-CPPGUICombatMarineBuyMenu.kBtnOverlaySize.x / 2, -CPPGUICombatMarineBuyMenu.kBtnOverlaySize.y / 2, 0) )
  --self.backgroundVisual:SetTexture(CPPGUICombatMarineBuyMenu.kBtnOverlayTexture)
  --self.backgroundVisual:SetTexturePixelCoordinates(0, 0, CPPGUICombatMarineBuyMenu.kBtnOverlaySize.x, CPPGUICombatMarineBuyMenu.kBtnOverlaySize.y)
  --self.backgroundVisual:SetColor( Color(1,1,1,0.8) )
  --self.backgroundVisual:SetIsVisible(true)
  --self.backgroundCenteredArea:AddChild(self.backgroundVisual)

end

function CPPGUICombatMarineBuyMenu:_InitializeHeaders()

  self.wpnHeaderText = GetGUIManager():CreateTextItem()
  self.wpnHeaderText:SetFontName(CPPGUICombatMarineBuyMenu.kHeaderFont)
  self.wpnHeaderText:SetFontIsBold(true)
  self.wpnHeaderText:SetScale(GetScaledVector())
  GUIMakeFontScale(self.wpnHeaderText)
  self.wpnHeaderText:SetAnchor(GUIItem.Left, GUIItem.Top)
  self.wpnHeaderText:SetPosition( Vector(50, 100, 0) )
  self.wpnHeaderText:SetTextAlignmentX(GUIItem.Align_Min)
  self.wpnHeaderText:SetTextAlignmentY(GUIItem.Align_Center)
  self.wpnHeaderText:SetColor(CPPGUICombatMarineBuyMenu.kTextColor)
  self.wpnHeaderText:SetText("Weapons")
  self.wpnHeaderText:SetIsVisible(true)
  self.backgroundCenteredArea:AddChild(self.wpnHeaderText)

end

function CPPGUICombatMarineBuyMenu:_InitializeButtons()

  local columnIndex = 0
  local rowIndex = 0
  local startOffset = Vector(70, 130, 0)

  local player = Client.GetLocalPlayer()

  self.itemButtons = { }

  for k, itemTechId in ipairs(GetWeaponItemList()) do

    if columnIndex == CPPGUICombatMarineBuyMenu.kButtonsPerRow then

      columnIndex = 0
      rowIndex = rowIndex + 1

    end

    local x = startOffset.x + (columnIndex * (CPPGUICombatMarineBuyMenu.kButtonSize.x + CPPGUICombatMarineBuyMenu.kButtonPadding.x))
    local y = startOffset.y + (rowIndex * (CPPGUICombatMarineBuyMenu.kButtonSize.y + CPPGUICombatMarineBuyMenu.kButtonPadding.y))

    --Shared.Message(GetDisplayNameForTechId(itemTechId))

    local buttonGraphic = GUIManager:CreateGraphicItem()
    buttonGraphic:SetSize( CPPGUICombatMarineBuyMenu.kButtonSize )
    buttonGraphic:SetAnchor(GUIItem.Left, GUIItem.Top)
    buttonGraphic:SetPosition( Vector(x, y, 0) )
    buttonGraphic:SetTexture(CPPGUICombatMarineBuyMenu.kButtonTexture)
    buttonGraphic:SetTexturePixelCoordinates(0, 0, CPPGUICombatMarineBuyMenu.kButtonSize.x, CPPGUICombatMarineBuyMenu.kButtonSize.y)
    buttonGraphic:SetColor( CPPGUICombatMarineBuyMenu.kBtnColor )
    self.backgroundCenteredArea:AddChild(buttonGraphic)

    --local buttonGraphicActive = GUIManager:CreateGraphicItem()
    --buttonGraphicActive:SetSize( Vector(194, 99, 0) )
    --buttonGraphicActive:SetAnchor(GUIItem.Left, GUIItem.Center)
    --buttonGraphicActive:SetPosition( Vector(-10, 0, 0) )
    --buttonGraphicActive:SetTexture(CPPGUICombatMarineBuyMenu.kSelectorTexture)
    --buttonGraphic.AddChild(buttonGraphicActive)

    local equipped = GetIsEquipped(itemTechId)
    local canAfford = GetCostByTechId(itemTechId) <= player.combatSkillPoints
    local hasRequiredRank = GetRequiredRankByTechId(itemTechId) <= player.combatRank

    local enabled = canAfford and hasRequiredRank and not equipped
    local iconColor = Color(1, 1, 1, 1)

    if equipped then
      iconColor = Color(0, 1, 0, 1)
    elseif hasRequiredRank and not canAfford then
      iconColor = Color(1, 0, 0, 1)
    end

    local buttonIcon = GUIManager:CreateGraphicItem()
    buttonIcon:SetSize( Vector(weaponIconWidth, weaponIconHeight, 0) )
    buttonIcon:SetAnchor(GUIItem.Left, GUIItem.Top)
    buttonIcon:SetPosition( Vector(x, y, 0) )
    buttonIcon:SetTexture(CPPGUICombatMarineBuyMenu.kIconTexture)
    buttonIcon:SetTexturePixelCoordinates(GetWeaponIconPixelCoordinates(itemTechId, enabled))
    buttonIcon:SetColor(iconColor)
    self.backgroundCenteredArea:AddChild(buttonIcon)

    local weaponText = GUIManager:CreateTextItem()
    weaponText:SetFontName(Fonts.kAgencyFB_Tiny)
    weaponText:SetScale(GetScaledVector())
    GUIMakeFontScale(weaponText)
    weaponText:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    weaponText:SetPosition( Vector(-6, -14, 0) )
    weaponText:SetTextAlignmentX(GUIItem.Align_Max)
    weaponText:SetTextAlignmentY(GUIItem.Align_Center)
    weaponText:SetColor(CPPGUICombatMarineBuyMenu.kTextColor)
    weaponText:SetText(GetDisplayNameForTechId(itemTechId))
    buttonGraphic:AddChild(weaponText)

    columnIndex = columnIndex + 1

    table.insert(self.itemButtons, { Button = buttonGraphic, TechId = itemTechId } )

  end

  -- to prevent wrong display before the first update
  self:_UpdateItemButtons(0)

end

function CPPGUICombatMarineBuyMenu:_UpdateItemButtons(deltaTime)

  if self.itemButtons then

    for i, item in ipairs(self.itemButtons) do

      if GetIsMouseOver(self, item.Button) then
        item.Button:SetColor( CPPGUICombatMarineBuyMenu.kBtnHighlightColor )
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
              local canAfford = GetCostByTechId(itemTechId) <= player.combatSkillPoints
              local hasRequiredRank = GetRequiredRankByTechId(itemTechId) <= player.combatRank

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
