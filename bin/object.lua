
local Object = {
  assign = function(target, properties)
    for k,v in pairs(properties) do
      target[k] = v
    end
    return target
  end
}

function Object.new()
  return setmetatable({}, Object)
end

function Object:equals(self, obj)
  return self == obj
end

return Object
