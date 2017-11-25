--Requires
local component = require("component")
local tunnel = component.tunnel
local computer = require("computer")
local event = require("event")
local term = require("term")
local robot = require("robot")
--End Requires

--Robot Functions
--These are wrappers for the functions available in the "robot" library.
--- Handles robots movement
function move(direction)
  --Takes the direction as sent by the main program loop "F,B,L,R,A,U or D" and prints the command.
  print("move: " .. direction)

  --Determines what to do based on specified direction
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

  --Function that gets called when the move couldn't be completed, and sends the corresponding error data.
  function sendReason(dir_letter, reason)
    if (reason == "entity") then tunnel.send("move:" .. dir_letter .. "_unable_entity")
    elseif (reason == "solid") then tunnel.send("move:" .. dir_letter .. "_unable_solid")
    else tunnel.send("move:" .. dir_letter .. "_unable_other")
    end
  end

  print()
end

--End Robot Functions



--Beeps twice to inform the user that robotLib started running >> Used after reboot.
term.clear()
computer.beep(1000)
os.sleep(0.25)
computer.beep(1000)

--Inform controller that robot is ready to accept commands >> Used after reboot
tunnel.send("robot_started")

--Function to easily determine if string contains the specified string.
function string.contains(message_st, pattern)
  print("string.contains(): ")
  print(" message: " .. message_st .. " | pattern: " .. pattern)

  local result = string.match(message_st, pattern) ~= nil
  print(" Result: " .. tostring(result))
  return result
end

--Main program loop
while true do
  print("Waiting for command:")

  --Waits for a message from the command computer.
  local _, _, _, _, _, message = event.pull("modem_message")
  print("Received command: '" .. message .. "'")

  --Determines the command in the message and its parameters, and sends them forward accordingly.
  if (string.contains(message, "move")) then move(string.sub(message, 6))
  elseif (string.contains(message, "quit")) then tunnel.send("robot_quit") os.exit()
  elseif (string.contains(message, "reboot")) then computer.shutdown(true)
  elseif (string.contains(message, "connected")) then tunnel.send("robot_connected")
  else tunnel.send("nil_command")
  end
end
