local PROMPTS = {

  IsActive = false,

  ShowPrompt = function(self, data)
    self.IsActive = true;
    SendReactMessage('setText', data.text or "")
    SendReactMessage('setPressText', data.pressText or "")
    SendReactMessage('setVisible', self.IsActive and 1 or 0)
  end,

  HidePrompt = function(self, data)
    self.IsActive = false;
    SendReactMessage('setVisible', self.IsActive and 1 or 0)
  end,

}

exports('showPrompt', function(...) 
	return PROMPTS:ShowPrompt(...)
end)

--[[
  exports['prompts']:showPrompt({
    pressText = "Press E",
    text = "to insert your card"
  })
]]

exports('hidePrompt', function(...) -- exports['prompts']:hidePrompt()
	return PROMPTS:HidePrompt(...)
end)

