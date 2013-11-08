-- ProbablyEngine Rotations - https://probablyengine.com/
-- Released under modified BSD, see attached LICENSE.

ProbablyEngine.toggle = {
  states = { }
}

ProbablyEngine.toggle.create = function(toggle_name, icon, tooltipl1, tooltipl2)
  ProbablyEngine.toggle.states[toggle_name] = false
  local toggleCallback = function(self)
    ProbablyEngine.toggle.states[toggle_name] = not ProbablyEngine.toggle.states[toggle_name]
    self.checked = not self.checked
    if self.checked then
      ProbablyEngine.buttons.setActive(toggle_name)
    else
      ProbablyEngine.buttons.setInactive(toggle_name)
    end
    ProbablyEngine.config.data['button_states'][toggle_name] = self.checked
  end
  ProbablyEngine.buttons.create(toggle_name, icon, toggleCallback, tooltipl1, tooltipl2)
  ProbablyEngine.buttons.loadStates()
end
