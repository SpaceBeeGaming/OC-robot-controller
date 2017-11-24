local component = require("component")
local tunnel = component.tunnel
local computer = require("computer")
local event = require("event")
local term = require("term")
local robot = require("robot")

function move(direction)
  print("move: " .. direction)
  if (direction == "F") then
    local val, reason = robot.forward()
    if (val) then tunnel.send("move:F_done") else sendReason(direction, reason) end

  elseif (direction == "B") then
    local val, reason = robot.back()
    if (val) then tunnel.send("move:B_done") else sendReason(direction, reason) end

  elseif (direction == "L") then
    local val, reason = robot.turnLeft()
    if (val) then tunnel.send("move:L_done") else sendReason(direction, reason) end

  elseif (direction == "R") then
    local val, reason = robot.turnRight()
    if (val) then tunnel.send("move:R_done") else sendReason(direction, reason) end

  elseif (direction == "A") then
    local val, reason = robot.turnAround()
    if (val) then tunnel.send("move:A_done") else sendReason(direction, reason) end

  elseif (direction == "U") then
    local val, reason = robot.up()
    if (val) then tunnel.send("move:U_done") else sendReason(direction, reason) end

  elseif (direction == "D") then
    local val, reason = robot.down()
    if (val) then tunnel.send("move:D_done") else sendReason(direction, reason) end

  else tunnel.send("move:NIL_done") print("nil")
  end

  function sendReason(dir_letter, reason)
    if (reason == "entity") then tunnel.send("move:" .. dir_letter .. "_unable_entity")
    elseif (reason == "solid") then tunnel.send("move:" .. dir_letter .. "_unable_solid")
    else tunnel.send("move:" .. dir_letter .. "_unable_other")
    end
  end

  print()
end

function string.contains(message_st, pattern)
  print("string.contains(): ")
  print(" message: " .. message_st .. " | pattern: " .. pattern)

  local result = string.match(message_st, pattern) ~= nil
  print(" Result: " .. tostring(result))
  return result
end

term.clear()
computer.beep(1000)
os.sleep(0.25)
computer.beep(1000)

tunnel.send("robot_started")

while true do
  print("Waiting for command:")

  local _, _, _, _, _, message = event.pull("modem_message")
  print("Received command: '" .. message .. "'")

  if (string.contains(message, "move")) then move(string.sub(message, 6))
  elseif (string.contains(message, "quit")) then tunnel.send("robot_quit") os.exit()
  elseif (string.contains(message, "reboot")) then computer.shutdown(true)
  elseif (string.contains(message, "connected")) then tunnel.send("robot_connected")
  else tunnel.send("nil_command")
  end
end