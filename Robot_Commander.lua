--Resets the "buttonAPI" package in order to make debugging easier.
package.loaded.buttonAPI = nil

--Requires
buttonAPI = require("buttonAPI")
local event = require("event")
--local computer = require("computer") --Going to be used later
local component = require("component")
local gpu = component.gpu
local screen = component.screen
local term = require("term")
--End Requires

local retryCount = 0

--Screens
--- All of the different button and text layouts.
function general_Buttons()
  buttonAPI.setTable("Close GUI", close_GUI, "", 80, 90, 36, 38)
  buttonAPI.setTable("Reboot", reboot_robot, "", 80, 90, 40, 42)
  buttonAPI.setTable("Quit", quit_robot, "", 80, 90, 44, 46)
end

function screen_move()
  buttonAPI.clearTable()

  buttonAPI.setTable("Forward", move_forward, "", 14, 24, 3, 5)
  buttonAPI.setTable("Turn Left", move_left, "", 2, 12, 7, 9)
  buttonAPI.setTable("Turn Right", move_right, "", 26, 36, 7, 9)
  buttonAPI.setTable("Turn Around", move_around, "", 14, 24, 7, 9)
  buttonAPI.setTable("Back", move_back, "", 14, 24, 11, 13)

  buttonAPI.setTable("Move Up", move_up, "", 40, 50, 3, 5)
  buttonAPI.setTable("Move Down", move_down, "", 40, 50, 11, 13)

  general_Buttons()
  buttonAPI.screen()
  buttonAPI.heading("Robot Commander")
end

function screen_lost_contact()
  buttonAPI.clearTable()
  buttonAPI.setTable("Retry", robot_lost_contact, "RETRY", 10, 45, 24, 26)
  buttonAPI.setTable("Quit", robot_lost_contact, "QUIT", 55, 90, 24, 26)
  buttonAPI.screen()
  buttonAPI.label(1, 22, "No connection!", true)
  gpu.setForeground(0xFF0000)
  buttonAPI.label(1, 28, "Error: No connection to the robot!", true)
  gpu.setForeground(0xFFFFFF)
  buttonAPI.label(1, 29, "Please ensure that robotLib.lua is running on the robot,", true)
  buttonAPI.label(1, 30, "if it isn't, run it.", true)
  retryCount = retryCount + 1
  buttonAPI.label(1, 40, "Retry: " .. retryCount)
end

function screen_quit_robot_final()
  buttonAPI.clearTable()
  buttonAPI.setTable("Yes", quit_robot_final, "YES", 10, 45, 24, 26)
  buttonAPI.setTable("No", quit_robot_final, "NO", 55, 90, 24, 26)
  buttonAPI.screen()
  buttonAPI.label(1, 22, "Are you sure?", true)
  gpu.setForeground(0xFF0000)
  buttonAPI.label(1, 28, "WARNING!", true)
  buttonAPI.label(1, 29, "This will terminate the connection with the robot!", true)
  buttonAPI.label(1, 30, "You'll have to run the program on the robot manually!", true)
  buttonAPI.label(1, 31, "So, please do NOT do this if you don't have the robot within reach!", true)
  gpu.setForeground(0xFFFFFF)
end

function screen_close_GUI_final()
  buttonAPI.clearTable()
  buttonAPI.setTable("Yes", close_GUI_final, "Yes", 10, 45, 24, 26)
  buttonAPI.setTable("No", close_GUI_final, "No", 55, 90, 24, 26)
  buttonAPI.screen()
  buttonAPI.label(1, 22, "Are you sure?", true)
  buttonAPI.label(1, 28, "This WON'T terminate the robot connection.", true)
  buttonAPI.label(1, 29, "Use this if you want to finetune the button layout.", true)
end

-- End Screens

-- Other Functions
--- Function that get called behind the scenes by other functions.
function latestCommand(latestCommand) --Prints the latest command sent to the robot on the screen.
  local text
  if (string.match(latestCommand, "C:")) then text = string.sub(latestCommand, 3)
  else text = "Command: " .. latestCommand
  end

  term.setCursor(1, 49)
  term.clearLine()
  term.write(text)
end

function commandResponse()
  --Prints the response sent by the robot. If no responce was received then shows the no connection screen.
  local _, _, _, _, _, message = event.pull(1, "modem_message")

  if (message == nil) then
    retryCount = 0
    screen_lost_contact()
  else
    term.setCursor(1, 50)
    term.clearLine()
    term.write("Last Command reply: " .. message)
    return true
  end
end

function robotConnected()
  --Checks whether the computer has a connection with the robot. Works mostly the same way as "commandResponse()"
  os.execute("robot_Remote connected")
  local _, _, _, _, _, message = event.pull(1, "modem_message")
  if (message == nil) then screen_lost_contact()
  else return true
  end
end

function reboot_robot_result()
  local _, _, _, _, _, message = event.pull(10, "modem_message")

  if (message == nil) then
    retryCount = 0
    screen_lost_contact()
  else
    return true
  end
end

-- End Other Functions

--Button Functions
--- Functions executed by clicking on buttons on specified screens.
function move_forward()
  buttonAPI.toggleButton("Forward")
  local command = "robot_Remote move:F"
  os.execute(command)
  latestCommand(command)
  if (commandResponse()) then buttonAPI.toggleButton("Forward") end
end

function move_back()
  buttonAPI.toggleButton("Back")
  local command = "robot_Remote move:B"
  os.execute(command)
  latestCommand(command)
  if (commandResponse()) then buttonAPI.toggleButton("Back") end
end

function move_left()
  buttonAPI.toggleButton("Turn Left")
  local command = "robot_Remote move:L"
  os.execute(command)
  latestCommand(command)
  if (commandResponse()) then buttonAPI.toggleButton("Turn Left") end
end

function move_right()
  buttonAPI.toggleButton("Turn Right")
  local command = "robot_Remote move:R"
  os.execute(command)
  latestCommand(command)
  if (commandResponse()) then buttonAPI.toggleButton("Turn Right") end
end

function move_around()
  buttonAPI.toggleButton("Turn Around")
  local command = "robot_Remote move:A"
  os.execute(command)
  latestCommand(command)
  if (commandResponse()) then buttonAPI.toggleButton("Turn Around") end
end

function move_up()
  buttonAPI.toggleButton("Move Up")
  local command = "robot_Remote move:U"
  os.execute(command)
  latestCommand(command)
  if (commandResponse()) then buttonAPI.toggleButton("Move Up") end
end

function move_down()
  buttonAPI.toggleButton("Move Down")
  local command = "robot_Remote move:D"
  os.execute(command)
  latestCommand(command)
  if (commandResponse()) then buttonAPI.toggleButton("Move Down") end
end


function quit_robot()
  buttonAPI.flash("Quit")
  screen_quit_robot_final()
end

function close_GUI()
  screen_close_GUI_final()
end

function reboot_robot()
  buttonAPI.toggleButton("Reboot")
  local command = "robot_Remote reboot"
  os.execute(command)
  latestCommand("C:Rebooting...")
  if (reboot_robot_result()) then term.clearLine() term.write("Rebooted") buttonAPI.toggleButton("Reboot") end
end


function close_GUI_final(answer) --Function to exit the "Robot Commander"
  if (answer == "Yes") then
    buttonAPI.flash("Yes")
    local w, h = gpu.maxResolution()
    gpu.setResolution(w, h)
    term.clear()
    term.setCursorBlink(true)
    screen.setTouchModeInverted(false)

    os.exit()
  else
    buttonAPI.flash("No")
    screen_move()
  end
end

function quit_robot_final(answer)
  if (answer == "YES") then
    buttonAPI.flash("Yes")
    local command = "robot_Remote quit"
    os.execute(command)
    close_GUI()
  else
    buttonAPI.flash("No")
    screen_move()
  end
end

function robot_lost_contact(answer)
  if (answer == "RETRY") then
    buttonAPI.toggleButton("Retry")
    if (robotConnected()) then screen_move() end
  else
    buttonAPI.flash("Quit")
    close_GUI()
  end
end

--End Button Functions

--Disbles cursor blinking and sets the resolution to square (a hight of a pixel in twice the width of it),
-- -- so the whole area of inworld screens can be used
screen.setTouchModeInverted(true)
term.setCursorBlink(false)
gpu.setResolution(100, 50)

--Run the "robotConnected" function, if it returns then show the move screen.
if (robotConnected()) then screen_move() end

--No need to touch these
function getClick() --Function to detect the touch events.
  local _, _, x, y = event.pull(1, touch)
  if x == nil or y == nil then
    local h, w = gpu.getResolution()
    gpu.set(h, w, ".")
    gpu.set(h, w, " ")
  else
    buttonAPI.checkxy(x, y)
  end
end

while true do
  getClick()
end
--End No need to touch these