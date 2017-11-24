local event = require("event")
local component = require("component")
local tunnel = component.tunnel
local args = { ... }

function printUsage()
  print("Usage: robotCommand [[-r] <command> ]")
  print("-r: the program will wait for response from the robot")
end

function validCommand(command)
  if (command == "nil_command") then
    print("Error: Not a valid command")
  else print("Command: " .. command)
  end
end

if (#args == 1) then
  if not (args[1] == "-r") then tunnel.send(args[1])
  else printUsage()
  end

elseif (#args == 2) then
  if (args[1] == "-r") then
    tunnel.send(args[2])
    local _, _, _, _, _, message = event.pull("modem_message")
    validCommand(message)
  else printUsage()
  end
end

if (#args > 2 or #args < 1) then
  printUsage()
end
