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
function screen_lost_contact()
  buttonAPI.clearTable()
  buttonAPI.setTable("Retry", lost_contact_retry, "", 10, 45, 24, 26)
  buttonAPI.setTable("Quit", lost_contact_quit, "", 55, 90, 24, 26)
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

function screen_move()
  buttonAPI.clearTable()
  buttonAPI.setTable("Move Up", move_up, "", 2, 12, 3, 5)
  buttonAPI.setTable("Move Down", move_down, "", 14, 24, 3, 5)
  buttonAPI.setTable("Quit", quit_robot, "", 2, 12, 7, 9)
  buttonAPI.screen()
  buttonAPI.heading("Robot Commander")
end

function screen_quit_robot_final()
  buttonAPI.clearTable()
  buttonAPI.setTable("Yes", quit_robot_final_yes, "", 10, 45, 24, 26)
  buttonAPI.setTable("No", quit_robot_final_no, "", 55, 90, 24, 26)
  buttonAPI.screen()
  buttonAPI.label(1, 22, "Are you sure?", true)
  gpu.setForeground(0xFF0000)
  buttonAPI.label(1, 28, "WARNING!", true)
  buttonAPI.label(1, 29, "This will terminate the connection with the robot!", true)
  buttonAPI.label(1, 30, "You'll have to run the program on the robot manually!", true)
  buttonAPI.label(1, 31, "So, please do NOT do this if you don't have the robot within reach!", true)
  gpu.setForeground(0xFFFFFF)
end

-- End Screens

-- Other Functions
--- Function that get called behind the scenes by other functions.
function latestCommand(latestCommand) --Prints the latest command sent to the robot on the screen.
  term.setCursor(1, 49)
  term.clearLine()
  term.write("Command: " .. latestCommand)
end

function commandResponse()
  --Prints the response sent by the robot. If no responce was received then shows the no connectin screen.
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

function close_GUI() --Function to exit the "Robot Commander"
  local w, h = gpu.maxResolution()
  gpu.setResolution(w, h)
  term.clear()
  term.setCursorBlink(true)
  screen.setTouchModeInverted(false)

  os.exit()
end

-- End Other Functions

--Button Functions
--- Functions executed by clicking on buttons on specified screens.
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

function quit_robot_final_yes()
  buttonAPI.flash("Yes")
  local command = "robot_Remote quit"
  os.execute(command)
  close_GUI()
end

function quit_robot_final_no()
  buttonAPI.flash("No")
  screen_move()
end

function lost_contact_retry()
  buttonAPI.toggleButton("Retry")
  if (robotConnected()) then screen_move() end
end

function lost_contact_quit()
  buttonAPI.toggleButton("Quit")
  close_GUI()
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