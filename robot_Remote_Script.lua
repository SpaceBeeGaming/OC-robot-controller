local file = io.open("/robot_Remote.txt", "r")
if file then
  local script = {}
  for line in file:lines() do
    table.insert(script, line)

    local event = require("event")

    local script_built = {}
    for step, command in ipairs(script) do
      script_built[step] = "robot_Remote " .. command
      print("Parsing: " .. script_built[step])
    end
  end
end




for step = 1, #script_built do
  os.execute(script_built[step])
  local _, _, _, _, _, response = event.pull("modem_message")
  print(response)
end
