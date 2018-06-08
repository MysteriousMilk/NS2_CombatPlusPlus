class 'GameStatusHUD' (GUIAnimatedScript)

GameStatusHUD.kTimeOffset = Vector(0, GUIScale(40), 0)
GameStatusHUD.kTimeFontName = Fonts.kAgencyFB_Small
GameStatusHUD.kTimeFontSize = 16
GameStatusHUD.kTimeBold = true

GameStatusHUD.kMarineTextColor = kMarineFontColor
GameStatusHUD.kAlienTextColor = kAlienFontColor

function GameStatusHUD:Initialize()

	GUIAnimatedScript.Initialize(self)

	self.background = self:CreateAnimatedGraphicItem()
    self.background:SetIsScaling(false)
    self.background:SetSize( Vector(Client.GetScreenWidth(), Client.GetScreenHeight(), 0) )
    self.background:SetPosition( Vector(0, 0, 0) ) 
    self.background:SetIsVisible(true)
    self.background:SetLayer(kGUILayerPlayerHUDBackground)
    self.background:SetColor( Color(1, 1, 1, 0) )

    -- Time remaining shadow
    self.timeRemainingTextShadow = self:CreateAnimatedTextItem()
    self.timeRemainingTextShadow:SetAnchor(GUIItem.Middle, GUIItem.Top)
    self.timeRemainingTextShadow:SetPosition(GameStatusHUD.kTimeOffset)
	self.timeRemainingTextShadow:SetLayer(kGUILayerPlayerHUDForeground1)
	self.timeRemainingTextShadow:SetTextAlignmentX(GUIItem.Align_Center)
    self.timeRemainingTextShadow:SetTextAlignmentY(GUIItem.Align_Center)
	self.timeRemainingTextShadow:SetText("")
    self.timeRemainingTextShadow:SetColor(Color(0,0,0,1))
    self.timeRemainingTextShadow:SetFontSize(GameStatusHUD.kTimeFontSize)
    self.timeRemainingTextShadow:SetFontName(GameStatusHUD.kTimeFontName)
	self.timeRemainingTextShadow:SetFontIsBold(GameStatusHUD.kTimeBold)
    self.timeRemainingTextShadow:SetIsVisible(true)
    self.background:AddChild(self.timeRemainingTextShadow)

    -- Time remaining
    self.timeRemainingText = self:CreateAnimatedTextItem()
    self.timeRemainingText:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.timeRemainingText:SetPosition(Vector(-2, -2, 0))
	self.timeRemainingText:SetLayer(kGUILayerPlayerHUDForeground1)
	self.timeRemainingText:SetTextAlignmentX(GUIItem.Align_Center)
    self.timeRemainingText:SetTextAlignmentY(GUIItem.Align_Center)
	self.timeRemainingText:SetText("")
	self.timeRemainingText:SetColor(Color(1,1,1,1))
	self.timeRemainingText:SetFontSize(GameStatusHUD.kTimeFontSize)
    self.timeRemainingText:SetFontName(GameStatusHUD.kTimeFontName)
	self.timeRemainingText:SetFontIsBold(GameStatusHUD.kTimeBold)
    self.timeRemainingText:SetIsVisible(true)
    self.timeRemainingTextShadow:AddChild(self.timeRemainingText)

end

function GameStatusHUD:Update()

    local player = Client.GetLocalPlayer()

    -- Alter the display based on team, status.
    if player then

        if player:GetTeamNumber() == kTeam1Index then
            self.timeRemainingText:SetColor(GameStatusHUD.kMarineTextColor)
        elseif player:GetTeamNumber() == kTeam2Index then
            self.timeRemainingText:SetColor(GameStatusHUD.kAlienTextColor)
        end


        if PlayerUI_GetHasGameStarted() then

            self.background:SetIsVisible(true)

            local timeRemaining = PlayerUI_GetTimeRemaining()
            --Print(timeRemaining)
			if timeRemaining == "00:00:00" then		    
                self.timeRemainingText:SetText("Overtime")
                self.timeRemainingTextShadow:SetText("Overtime")
			else
                self.timeRemainingText:SetText(timeRemaining)
                self.timeRemainingTextShadow:SetText(timeRemaining)
            end

        else

            self.background:SetIsVisible(false)

        end

    end

end

function GameStatusHUD:Uninitialize()

    GUIAnimatedScript.Uninitialize(self)
    
    GUI.DestroyItem(self.timeRemainingText)
    GUI.DestroyItem(self.timeRemainingTextShadow)
    GUI.DestroyItem(self.background)

end