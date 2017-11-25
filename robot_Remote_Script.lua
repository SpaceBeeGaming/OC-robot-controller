local event = require("event")
local args = { ... }

if args[1] == nil then
  print("Usage: robot_Remmote_Script <script>")
  print("Scripts must be placed in '/scripts' folder")
  print("Available scripts: ")
  os.execute("ls /scripts")
else
  local file = io.open("/scripts/" .. args[1], "r")

  local script = {}
  if file then
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
    print("Script not found: place your script in '/scripts' folder")
    print("Available scripts: ")
    os.execute("ls /scripts")
  end
end
