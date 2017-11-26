--Requires
local event = require("event")
local fs = require("filesystem")
local process = require("process")
local shell = require("shell")
--End Requires

-- program arguments and absolute path of the scripts directory.
local args = { ... }
local pathLength = string.len(shell.resolve(process.info().path)) - 19
local path = string.sub(shell.resolve(process.info().path), 1, pathLength) .. "scripts/"

--First the program checks whether there is a "scripts" directory in the directory the program was run from.
if not (fs.isDirectory(path)) then
  --If there isn't a directory specified by path, the program creates it and then ends.
  fs.makeDirectory(path)
  print("Script folder created at: " .. path)
  return 1
else
  if (args[1] == nil) then
    --If the program was ran without argument, this prints the usage of the program and scripts in the scripts directory.
    print("Usage: robot_Remmote_Script <script>")
    print("Scripts must be placed in: " .. path)
    print("Available scripts: ")
    os.execute("ls scripts")
  else
    --Opening the file.
    local file = io.open(path .. args[1], "r")

    local script = {}
    --Checking that the file is opened.
    if (file) then
      --If it is, then reads the contensts into a table, and then colses the file.
      for line in file:lines() do table.insert(script, line) end
      file:close()

      local script_built = {}

      --Assings a numbers for the values in the "script" table and adds the command name in front of the values.
      for step, command in ipairs(script) do
        script_built[step] = "robot_Remote " .. command
        print("Parsing: " .. script_built[step])
      end

      --Executes the contents of the "script_built" table using the previously assined numbers and values.
      for step = 1, #script_built do
        os.execute(script_built[step])
        print(step .. ". Executing: " .. script_built[step])

        --Registers an event and waits until gets the response.
        local _, _, _, _, _, response = event.pull("modem_message")
        --Checks if response indicates to unkown command.
        if (response == "nil_command") then print(step .. ". Invalid command: " .. script_built[step])
        elseif (response == "move:NIL_done") then print(step .. ". Invalid direction: " .. script_built[step])
        else
          print(step .. ". Responce: " .. response)
        end
      end
    else

      --If the file was not opened, instructs the user to check where the script should be located. Then it gives a
      -- -- list of found scripts.
      print("Script not found: place your script in: " .. path)
      print("Available scripts: ")
      os.execute("ls scripts")
    end
  end
end