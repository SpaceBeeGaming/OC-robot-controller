--Library of helper functions

function string.contains(string, pattern)
  print("string.contains():")
  print("message: " .. string .. " | pattern: " .. pattern)

  local result = string.match(string, pattern) ~= nil
  print("Result: " .. result)
  return result
end