
local GUI = require("GUI")
local system = require("System")
local screen = require("Screen")
local text = require("Text")
local component = require("component")
local localization = system.getCurrentScriptLocalization()
if not component.isAvailable("modem") then
  GUI.alert(localization.modemRequired)
  return
end
local modem = component.get("modem")
local message = pidorEbaniy

---------------------------------------------------------------------------------

modem.open(666)

local workspace, window, menu = system.addWindow(GUI.filledWindow(1, 1, 82, 28, 0x1E1E1E))

local display = window:addChild(GUI.object(2, 4, 1, 1))

local lines = {
  localization.generalchat
}

display.draw = function(display)
  if #lines == 0 then
    return
  end

  local y = display.y + display.height - 1
  
  for i = #lines, math.max(#lines - display.height, 1), -1 do
    screen.drawText(display.x, y - 2, 0xE1E1E1, lines[i])
    y = y - 1
  end
end

display.eventHandler = function(workspace, display, e1, e2, e3, e4, e5, e6)
  if e1 == "modem_message" then
    table.insert(lines, e6)
  end
end

local textPole = window:addChild(GUI.input(1, window.height - 2, window.width - 20, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, "", localization.pidorEbaniy))

local regularButton = window:addChild(GUI.button(window.width - 19, window.height - 2, 20, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, localization.send))
regularButton.onTouch = function()
  if textPole.text == "" then
    message = system.getUser() .. ": " .. localization.pidorEbaniy
    table.insert(lines, message)
    modem.broadcast(666, message)
  else
    message = system.getUser() .. ": " .. textPole.text
    table.insert(lines, message)
    modem.broadcast(666, message)
  end
  if #lines > display.height then
    table.remove(lines, 1)
  end
end

window.onResize = function(newWidth, newHeight)
  window.backgroundPanel.width, window.backgroundPanel.height = newWidth, newHeight
  display.width, display.height = newWidth - 2, newHeight - 4
end

---------------------------------------------------------------------------------

window.onResize(window.width, window.height)
workspace:draw()
