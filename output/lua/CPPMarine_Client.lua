-- Copied because its local and 'UpdateClientEffects' calls this
local function UpdatePoisonedEffect(self)

    local feedbackUI = ClientUI.GetScript("GUIPoisonedFeedback")
    if self.poisoned and self:GetIsAlive() and feedbackUI and not feedbackUI:GetIsAnimating() then
        feedbackUI:TriggerPoisonEffect()
    end

end

--[[
 * This function was copy/pasted from Marine_Client.lua because there was no
 * good way to short-cicuit the function to remove the closing of the buy menu
 * when not near a structure.  Just noting because this will likely have to be
 * updated every time UWE puts out a major update.
]]
function Marine:UpdateClientEffects(deltaTime, isLocal)

    Player.UpdateClientEffects(self, deltaTime, isLocal)

    if isLocal then

        Client.SetMouseSensitivityScalar(ConditionalValue(self:GetIsStunned(), 0, 1))

        self:UpdateGhostModel()

        UpdatePoisonedEffect(self)

        if self.lastAliveClient ~= self:GetIsAlive() then
            ClientUI.SetScriptVisibility("Hud/Marine/GUIMarineHUD", "Alive", self:GetIsAlive())
            ClientUI.SetScriptVisibility("Combat/GUI/MarineStatusHUD", "Alive", self:GetIsAlive())
            self.lastAliveClient = self:GetIsAlive()
        end

        if self.buyMenu then

            if not self:GetIsAlive() or self:GetIsStunned() then
                self:CloseMenu()
            end

        end

        if Player.screenEffects.disorient then
            Player.screenEffects.disorient:SetParameter("time", Client.GetTime())
        end

        local stunned = HasMixin(self, "Stun") and self:GetIsStunned()
        local blurEnabled = self.buyMenu ~= nil or stunned or (self.viewingHelpScreen == true)
        self:SetBlurEnabled(blurEnabled)

        -- update spit hit effect
        if not Shared.GetIsRunningPrediction() then

            if self.timeLastSpitHit ~= self.timeLastSpitHitEffect then

                local viewAngle = self:GetViewAngles()
                local angleDirection = Angles(GetPitchFromVector(self.lastSpitDirection), GetYawFromVector(self.lastSpitDirection), 0)
                angleDirection.yaw = GetAnglesDifference(viewAngle.yaw, angleDirection.yaw)
                angleDirection.pitch = GetAnglesDifference(viewAngle.pitch, angleDirection.pitch)

                TriggerSpitHitEffect(angleDirection:GetCoords())

                local intensity = self.lastSpitDirection:DotProduct(self:GetViewCoords().zAxis)
                self.spitEffectIntensity = intensity
                self.timeLastSpitHitEffect = self.timeLastSpitHit

            end

        end

        local spitHitDuration = Shared.GetTime() - self.timeLastSpitHitEffect

        if Player.screenEffects.disorient and self.timeLastSpitHitEffect ~= 0 and spitHitDuration <= Marine.kSpitHitEffectDuration then

            Player.screenEffects.disorient:SetActive(true)
            local amount = (1 - ( spitHitDuration/Marine.kSpitHitEffectDuration) ) * 3.5 * self.spitEffectIntensity
            Player.screenEffects.disorient:SetParameter("amount", amount)

        end

    end

    if self._renderModel then

        if self.ruptured and not self.ruptureMaterial then

            local material = Client.CreateRenderMaterial()
            material:SetMaterial(kRuptureMaterial)

            local viewMaterial = Client.CreateRenderMaterial()
            viewMaterial:SetMaterial(kRuptureMaterial)

            self.ruptureEntities = {}
            self.ruptureMaterial = material
            self.ruptureMaterialViewMaterial = viewMaterial
            AddMaterialEffect(self, material, viewMaterial, self.ruptureEntities)

        elseif not self.ruptured and self.ruptureMaterial then

            RemoveMaterialEffect(self.ruptureEntities, self.ruptureMaterial, self.ruptureMaterialViewMaterial)
            Client.DestroyRenderMaterial(self.ruptureMaterial)
            Client.DestroyRenderMaterial(self.ruptureMaterialViewMaterial)
            self.ruptureMaterial = nil
            self.ruptureMaterialViewMaterial = nil
            self.ruptureEntities = nil

        end

    end

end

local ns2_Marine_OnCountDown = Marine.OnCountDown
function Marine:OnCountDown()

    ns2_Marine_OnCountDown(self)
    ClientUI.SetScriptVisibility("Combat/GUI/MarineStatusHUD", "Countdown", false)

end

local ns2_Marine_OnCountDownEnd = Marine.OnCountDownEnd
function Marine:OnCountDownEnd()

    ns2_Marine_OnCountDownEnd(self)
    ClientUI.SetScriptVisibility("Combat/GUI/MarineStatusHUD", "Countdown", true)

end

function Marine:Buy()

  -- Don't allow display in the ready room
  if self:GetTeamNumber() ~= 0 and Client.GetLocalPlayer() == self and not HelpScreen_GetHelpScreen():GetIsBeingDisplayed() then

      if not self.buyMenu then

          self.buyMenu = GetGUIManager():CreateGUIScript("Combat/GUI/MarineBuyMenu")
          self:TriggerEffects("marine_buy_menu_open")

      else

        self:CloseMenu()

      end

  end

end

local ns2_Marine_UpdateGhostModel = Marine.UpdateGhostModel
function Marine:UpdateGhostModel()

    ns2_Marine_UpdateGhostModel(self)

    local weapon = self:GetActiveWeapon()

    if weapon and weapon:isa("Builder") and weapon:GetBuilderMode() == kBuilderMode.Create then

        self.currentTechId = self:GetCreateStructureTechId()
        self.ghostStructureCoords = weapon:GetGhostModelCoords()
        self.ghostStructureValid = weapon:GetIsPlacementValid()
        self.showGhostModel = weapon:GetShowGhostModel()

    end

end
