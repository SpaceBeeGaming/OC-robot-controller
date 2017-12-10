--Library of helper functions

--Requires
local shell = require("shell")
local term = require("term")

--END Requires


local helpers = {}

--Determines if string contains the specified string.
function helpers.string_contains(string, pattern, log_print)
  local result = string.match(string, pattern) ~= nil
  if (log_print) then
    print("helpers.string_contains():")
    print("message: " .. string .. " | pattern: " .. pattern)
    print("Result: " .. tostring(result))
  end
  return result
end

--Writes given text on given line and clears it first if so instucted.
function helpers.writeLine(x, y, clear, text)
  term.setCursor(x, y)
  if (clear) then term.clearLine() end
  term.write(text)
end

--Returns the absolute path of the program that runs it. aka. removes the name of the program.
function helpers.getAbsolutePath(callerPath, nameLength)
  local absPath_name = shell.resolve(callerPath)
  local absPath_name_Length = string.len(absPath_name) - nameLength
  local absPath = string.sub(absPath_name, 1, absPath_name_Length)
  return absPath
end

function helpers.math_round(num)
  local flr = math.floor(num)
  if (num < flr + 0.5) then
    return flr
  else
    return flr + 1
  end
end

return helpers
