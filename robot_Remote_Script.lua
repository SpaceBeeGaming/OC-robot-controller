local event = require("event")
local fs = require("filesystem")
local process = require("process")
local shell = require("shell")

local args = { ... }

local path = string.sub(shell.resolve(process.info().path), 1, 10) .. "scripts/"

if not (fs.isDirectory(path)) then
  fs.makeDirectory(path)
  print("Script folder created at: " .. path)
  return 1
else
  if (args[1] == nil) then
    print("Usage: robot_Remmote_Script <script>")
    print("Scripts must be placed in: " .. path)
    print("Available scripts: ")
    os.execute("ls scripts")
  else
    local file = io.open(path .. args[1], "r")

    local script = {}
    if (file) then
      for line in file:lines() do table.insert(script, line) end
      file:close()

      local script_built = {}

      for step, command in ipairs(script) do
        script_built[step] = "robot_Remote " .. command
        print("Parsing: " .. script_built[step])
      end

      for step = 1, #script_built do
        os.execute(script_built[step])
        print("Executing: " .. script_built[step])
        local _, _, _, _, _, response = event.pull("modem_message")
        print("Responce: " .. response)
      end
    else
      print("Script not found: place your script in: " .. path)
      print("Available scripts: ")
      os.execute("ls scripts")
    end
  end
end