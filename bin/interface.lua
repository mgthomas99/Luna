
local function is_type_name(name)
  return name == "string" or
         name == "number" or
         name == "boolean" or
         name == "function" or
         name == "table"
end

local Interface = {}

function Interface.create(identifier, super, template)
  if (type(identifier) == "string" and type(super) == "table" and type(template) == "table") then
    -- All good!
  elseif (type(identifier) == "string" and type(super) == "table") then
    template = super
    super = nil
  elseif (type(identifier) == "table" and type(super) == "table") then
    template = super
    super = identifier
    identifier = nil
  elseif (type(identifier) == "table") then
    template = identifier
    identifier = nil
  end

  local self = setmetatable({}, Interface)

  if (super ~= nil) then
    for k,v in pairs(super) do
      self[k] = v
    end
  end
  for k,v in pairs(template) do
    if (type(v) ~= "string") then
      return error("An interface property must be a string!")
    elseif (not is_type_name(v)) then
      return error("Interface property must be the name of a type!")
    end
    self[k] = v
  end

  return self
end

function Interface.is_interface(obj)
  for k,v in pairs(obj) do
    if (type(v) ~= "string") then
      return false
    end
  end
  return true
end

return Interface
