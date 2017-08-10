
local IsType = require("Luna/lib/is-type")
local Interface = {}

function Interface.create(identifier, super, template)
  local self = setmetatable({}, Interface)

  for k,v in pairs(template) do
    if (type(v) ~= "string") then
      return error("An interface property must be a string!")
    elseif (not IsType.is_type_name(v)) then
      return error("Interface property must be the name of a type!")
    end
    self[k] = v
  end

  return self
end

return Interface
