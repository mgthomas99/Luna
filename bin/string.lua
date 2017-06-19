
local String = {}

function String.substring(str, a, b)
  b = b or str:len()

  if (a < 0) then a = str:len() + a end
  if (b < 0) then b = str:len() + b end
  return str:sub(a, b)
end

return String
