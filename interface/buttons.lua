-- ProbablyEngine Rotations - https://probablyengine.com/
-- Released under modified BSD, see attached LICENSE.

ProbablyEngine.buttons = {
  frame = CreateFrame("Frame", "PE_Buttons", UIParent),
  buttonFrame = CreateFrame("Frame", "PE_Buttons_Container", UIParent),
  buttons = { },
  size = 36,
  scale = 1,
  padding = 6,
  count = 0,
}

ProbablyEngine.buttons.frame:SetPoint("CENTER", UIParent)
ProbablyEngine.buttons.frame:SetWidth(170)
ProbablyEngine.buttons.frame:SetHeight(ProbablyEngine.buttons.size+5)
ProbablyEngine.buttons.frame:SetMovable(true)
ProbablyEngine.buttons.frame:SetFrameStrata('HIGH')

ProbablyEngine.buttons.frame:Hide()
ProbablyEngine.buttons.buttonFrame:Hide()

ProbablyEngine.buttons.statusText = ProbablyEngine.buttons.frame:CreateFontString('PE_StatusText')
ProbablyEngine.buttons.statusText:SetFont("Fonts\\ARIALN.TTF", 16)
ProbablyEngine.buttons.statusText:SetShadowColor(0,0,0, 0.8)
ProbablyEngine.buttons.statusText:SetShadowOffset(-1,-1)
ProbablyEngine.buttons.statusText:SetPoint("CENTER", ProbablyEngine.buttons.frame)
ProbablyEngine.buttons.statusText:SetText("|cffffffffDrag to Position|r")

ProbablyEngine.buttons.frame.texture = ProbablyEngine.buttons.frame:CreateTexture()
ProbablyEngine.buttons.frame.texture:SetAllPoints(ProbablyEngine.buttons.frame)
ProbablyEngine.buttons.frame.texture:SetTexture(0,0,0,0.6)

ProbablyEngine.buttons.frame:SetScript("OnMouseDown", function(self, button)
  if not self.isMoving then
   self:StartMoving()
   self.isMoving = true
  end
end)
ProbablyEngine.buttons.frame:SetScript("OnMouseUp", function(self, button)
  if self.isMoving then
   self:StopMovingOrSizing()
   self.isMoving = false
  end
end)
ProbablyEngine.buttons.frame:SetScript("OnHide", function(self)
  if self.isMoving then
   self:StopMovingOrSizing()
   self.isMoving = false
  end
end)

ProbablyEngine.buttons.create = function(name, icon, callback, tooltipl1, tooltipl2)

  ProbablyEngine.buttons.buttons[name] = CreateFrame("CheckButton", "PE_Buttons_"..name, ProbablyEngine.buttons.buttonFrame, "ActionButtonTemplate")
  ProbablyEngine.buttons.buttons[name]:RegisterForClicks("LeftButtonUp", "RightButtonUp")
  local button = ProbablyEngine.buttons.buttons[name]
  button:SetPoint("TOPLEFT", ProbablyEngine.buttons.frame, "TOPLEFT",
    (
      (ProbablyEngine.buttons.size*ProbablyEngine.buttons.count)
      +
      (ProbablyEngine.buttons.count*ProbablyEngine.buttons.padding)
      + 4
    )
  , -3)
  button:SetWidth(ProbablyEngine.buttons.size)
  button:SetHeight(ProbablyEngine.buttons.size)

  if icon == nil then
    _G[button:GetName().."Icon"]:SetTexture('Interface\\ICONS\\INV_Misc_QuestionMark')
  else
    _G[button:GetName().."Icon"]:SetTexture(icon)
  end

  button:SetScript("OnClick", callback)
  button:SetScript("OnClick", callback)

  if tooltipl1 ~= nil then
    button:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_TOP")
      GameTooltip:AddLine("|cffffffff" .. tooltipl1 .. "|r")
      if tooltipl2 then
        GameTooltip:AddLine(tooltipl2)
      end
      GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function(self)
      GameTooltip:Hide()
    end)
  end

  button.checked = false

  button:SetPushedTexture(nil);

  ProbablyEngine.buttons.count = ProbablyEngine.buttons.count + 1

end

ProbablyEngine.buttons.text = function(name, text)
  local hotkey = _G['PE_Buttons_'.. name .."HotKey"]
  hotkey:SetText(text);
  hotkey:Show();
end

ProbablyEngine.buttons.setActive = function(name)
  if name == 'MasterToggle' then ProbablyEngine.active = true end
  if _G['PE_Buttons_'.. name] then
    _G['PE_Buttons_'.. name].checked = true
    _G['PE_Buttons_'.. name]:SetChecked(1)
    ProbablyEngine.config.data['button_states'][name] = true
  end
end

ProbablyEngine.buttons.setInactive = function(name)
  if name == 'MasterToggle' then ProbablyEngine.active = false end
  if _G['PE_Buttons_'.. name] then
    _G['PE_Buttons_'.. name].checked = false
    _G['PE_Buttons_'.. name]:SetChecked(0)
    ProbablyEngine.config.data['button_states'][name] = false
  end
end

ProbablyEngine.buttons.toggle = function(name)
  if name == 'MasterToggle' then ProbablyEngine.active = not ProbablyEngine.active end
  if _G['PE_Buttons_'.. name] then
    _G['PE_Buttons_'.. name].checked = not _G['PE_Buttons_'.. name].checked
    if _G['PE_Buttons_'.. name].checked then
      _G['PE_Buttons_'.. name]:SetChecked(1)
    else
      _G['PE_Buttons_'.. name]:SetChecked(0)
    end
    ProbablyEngine.config.data['button_states'][name] = not ProbablyEngine.config.data['button_states'][name]
  end
end

ProbablyEngine.buttons.icon = function(name, icon)
  _G['PE_Buttons_'.. name ..'Icon']:SetTexture(icon)
end

ProbablyEngine.buttons.loadStates = function()

  if ProbablyEngine.config.read('uishown') then
    if ProbablyEngine.config.read('uishown') then
      ProbablyEngine.buttons.buttonFrame:Show()
    else
      ProbablyEngine.buttons.buttonFrame:Hide()
    end
  else
    ProbablyEngine.buttons.buttonFrame:Show()
    ProbablyEngine.config.write('uishown', true)
  end

  local states = ProbablyEngine.config.read('button_states', { })
  for button, state in pairs(states) do
    if state == true then
      ProbablyEngine.buttons.setActive(button)
      ProbablyEngine.toggle.states[button] = true
    else
      ProbablyEngine.buttons.setInactive(button)
      ProbablyEngine.toggle.states[button] = false
    end
  end
end
