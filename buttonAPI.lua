local buttonAPI = {}
local button = {}

local component = require("component")
local gpu = component.gpu
local term = require("term")
local w, h = gpu.getResolution()

local colors = {
  ["lime"] = 0x00FF00,
  ["red"] = 0xFF0000,
  ["black"] = 0x000000,
}

buttonStatus = nil

function buttonAPI.clear()
  gpu.setBackground(colors.black)
  gpu.fill(1, 1, w, h, " ")
end

function buttonAPI.clearTable()
  button = {}
  buttonAPI.clear()
end

function buttonAPI.setTable(name, func, param, xmin, xmax, ymin, ymax)
  button[name] = {}
  button[name]["func"] = func
  button[name]["active"] = false
  button[name]["param"] = param
  button[name]["xmin"] = xmin
  button[name]["xmax"] = xmax
  button[name]["ymin"] = ymin
  button[name]["ymax"] = ymax
end

function buttonAPI.fill(text, color, bData)
  local yspot = math.floor((bData["ymin"] + bData["ymax"]) / 2)
  local xspot = math.floor((bData["xmax"] + bData["xmin"] - string.len(text)) / 2) + 1
  local oldColor = gpu.setBackground(color)
  gpu.fill(bData["xmin"], bData["ymin"], (bData["xmax"] - bData["xmin"] + 1), (bData["ymax"] - bData["ymin"] + 1), " ")
  gpu.set(xspot, yspot, text)
  gpu.setBackground(oldColor)
end

function buttonAPI.screen()
  local currColor
  for name, data in pairs(button) do
    local on = data["active"]
    if on == true then currColor = colors.lime else currColor = colors.red end
    buttonAPI.fill(name, currColor, data)
  end
end

function buttonAPI.toggleButton(name)
  button[name]["active"] = not button[name]["active"]
  buttonStatus = button[name]["active"]
  buttonAPI.screen()
end

function buttonAPI.flash(name, length)
  buttonAPI.toggleButton(name)
  buttonAPI.screen()
  if (length == nil) then
    os.sleep(0.05)
  else
    os.sleep(length)
  end
  buttonAPI.toggleButton(name)
  buttonAPI.screen()
end

function buttonAPI.checkxy(x, y)
  for _, data in pairs(button) do
    if (y >= data["ymin"] and y <= data["ymax"]) then
      if (x >= data["xmin"] and x <= data["xmax"]) then
        if (data["param"] == "") then
          data["func"]()
        else
          data["func"](data["param"])
        end
        return true
      end
    end
  end
  return false
end

function buttonAPI.heading(text)
  w, h = gpu.getResolution()
  term.setCursor((w - string.len(text)) / 2 + 1, 1)
  term.write(text)
end

function buttonAPI.label(w, h, text, center)
  if (center) then
    w, _ = gpu.getResolution()
    term.setCursor((w - string.len(text)) / 2 + 1, h)
    term.write(text)
  else
    term.setCursor(w, h)
    term.write(text)
  end
end


return buttonAPI
