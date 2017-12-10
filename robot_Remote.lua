--Requires
local event = require("event")
local component = require("component")
local tunnel = component.tunnel
--End Requires

--Program arguments
local args = { ... }

function printUsage() --Function to print the usage of the program.
  print("Usage: robotCommand [[-r] <command> ]")
  print("-r: the program will wait for response from the robot")
end

function validCommand(command)
  --Checks that the command that was send was recognised by the robot based on the response from the robot,
  -- -- prints user understandable error message if the command was not understood.
  if (command == "nil_command") then
    print("Error: Not a valid command")
  else print("Response: " .. command)
  end
end

if (#args == 1) then
  --If only one argument check that it isn't "-r" then sends the argument,
  -- -- if it was "-r" calls the printUsage function
  if (args[1] ~= "-r") then tunnel.send(args[1])
  else printUsage()
  end

elseif (#args == 2) then
  -- If two arguments then check if first argument is "-r",
  -- -- if it is then send the second argument and wait for the response, after that validate it.
  -- -- If "-r" is not the is not the first argument then call printUsage()
  if (args[1] == "-r") then
    tunnel.send(args[2])
    local _, _, _, _, _, message = event.pull("modem_message")
    validCommand(message)
  else printUsage()
  end

else
  --If there isn't any arguments or more than two, print usage of the program.
  printUsage()
end
