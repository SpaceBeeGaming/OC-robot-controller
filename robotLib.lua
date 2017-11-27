--Resets library packages in order to make debugging easier. --TODO: Remove this!
package.loaded.helpers = nil

--Requires
local component = require("component")
local tunnel = assert(component.tunnel, "No Linked card detected")
local computer = require("computer")
local event = require("event")
local helpers = require("helpers")
local term = require("term")
local robot = require("robot")
--End Requires

--Robot Functions
--These are wrappers for the functions available in the "robot" library.
--- Handles robots movement.
function move(direction)
  --Takes the direction as sent by the main program loop "F,B,L,R,A,U or D" and prints the command.
  print("move: " .. direction)

  --Function that gets called when the move couldn't be completed, and sends the corresponding error data.
  function sendReason(dir_letter, reason)
    if (reason == "entity") then tunnel.send("move:" .. dir_letter .. "_unable_entity")
    elseif (reason == "solid") then tunnel.send("move:" .. dir_letter .. "_unable_solid")
    else tunnel.send("move:" .. dir_letter .. "_unable_other")
    end
  end

  --Determines what to do based on specified direction
  local result
  if (direction == "F") then
    local val, reason = robot.forward()
    if (val) then result = "move:F_done" else sendReason(direction, reason) end

  elseif (direction == "B") then
    local val, reason = robot.back()
    if (val) then result = "move:B_done" else sendReason(direction, reason) end

  elseif (direction == "L") then
    local val, reason = robot.turnLeft()
    if (val) then result = "move:L_done" else sendReason(direction, reason) end

  elseif (direction == "R") then
    local val, reason = robot.turnRight()
    if (val) then result = "move:R_done" else sendReason(direction, reason) end

  elseif (direction == "A") then
    local val, reason = robot.turnAround()
    if (val) then result = "move:A_done" else sendReason(direction, reason) end

  elseif (direction == "U") then
    local val, reason = robot.up()
    if (val) then result = "move:U_done" else sendReason(direction, reason) end

  elseif (direction == "D") then
    local val, reason = robot.down()
    if (val) then result = "move:D_done" else sendReason(direction, reason) end

  else result = "move:NIL_done"
  end
  tunnel.send(result)

  print()
end

--- Wait for x seconds.
function wait(seconds)
  print("Waiting for: " .. seconds .. "seconds.")
  os.sleep(seconds)
  tunnel.send("robot_slept")
end

--End Robot Functions



--Beeps twice to inform the user that robotLib started running >> Used after reboot.
term.clear()
computer.beep(1000)
os.sleep(0.25)
computer.beep(1000)

--Inform controller that robot is ready to accept commands >> Used after reboot
tunnel.send("robot_booted")

--Main program loop
while true do
  print("Waiting for command:")

  --Waits for a message from the command computer.
  local _, _, _, _, _, message = event.pull("modem_message")
  print("Received command: '" .. message .. "'")

  --Determines the command in the message and its parameters, and sends them forward accordingly.
  if (helpers.string_contains(message, "move", true)) then move(string.sub(message, 6))
  elseif (helpers.string_contains(message, "quit", true)) then tunnel.send("robot_quit") os.exit()
  elseif (helpers.string_contains(message, "reboot", true)) then computer.shutdown(true)
  elseif (helpers.string_contains(message, "connected", true)) then tunnel.send("robot_connected")
  elseif (helpers.string_contains(message, "wait", true)) then wait(tonumber(string.sub(message, 6)))
  else tunnel.send("nil_command")
  end
end
