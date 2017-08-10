
local Object = require("Luna/bin/object")
local Template = require("Luna/bin/template")

--[[
  API for creating classes from Lua tables, and instantiating
  them to produce Objects.

  A class can be created using the API call
      local Class = require("class")
      local my_class = Class.create("MyClass", {
        -- class properties
      })
  where '-- class properties' is replaced with the
  properties of the class. The table passed to the
  `Class.create` function is called a 'template' - it
  is an unprocessed table that cannot yet be instantiated.

  When the template is sent to the `Class.create()`
  function, it is processed and transformed into a
  class - a table that can be sent to the `Class.instantiate()`
  function to be instantiated.

  A class table contains all of the static properties
  that were defined in the template's 'static' table
  as first-level properties, as well as a table called
  'prototype' which contains all of the properties that
  should be cloned and applied to every instance of the
  class.

  Luna's class/object system is very similar to
  JavaScript's prototype-based object system.
]]
local Class = {}

--[[
  Creates a new class from the identifier and template
  provided.

  This function, assuming no error occurs, will
  return a class (table) that can be sent to the
  `instantiate` function to be instantiated.

  @param  identifier
          The name of the class.
  @param  template
          The class template (or definition).
]]
function Class.create(identifier, super, template)
  local class = {
    name = identifier,
    prototype = {
      toString = function(self)
        return "[Object " .. tostring(self) .. "]"
      end
    }
  }

  if (super) then
    for k,v in pairs(super.prototype) do
      if (k ~= "constructor") then
        class.prototype[k] = v
      end
    end
  end

  if (Template.has_static(template)) then
    for k,v in pairs(template.static) do
      class[k] = v
    end
    template.static = nil
  end
  for k,v in pairs(template) do
    class.prototype[k] = v
  end
  return class
end

function Class.implements(class, interface)
  for k,v in pairs(interface) do
    if (type(class[k]) ~= v) then
      return error("Incompatible types: interface " ..
          "defines property '" .. k .. "' as type " ..
          v .. " but it is implemented as type " .. type(class[k]) .. "!")
    end
  end
  return true
end

function Class.implement(class, ...)
  local interfaces = { ... }
  for i=1, #interfaces do
    local interface = interfaces[i]
    if (not Class.implements(class, interface)) then
      return error("Class " .. (class.name or "") .. "incorrectly implements interface!")
    end
  end
end

--[[
  Returns a new instance of the class provided,
  using the function call's varargs to invoke the
  class' constructor.

  If the class has no constructor, an error is
  thrown.
]]
function Class.instantiate(class, ...)
  if ((class == nil) or (type(class) ~= "table")) then
    return error("Attempted to instantiate non-class!")
  elseif (class.prototype == nil) then
    return error("Attempted to instantiate non-class!")
  elseif (class.prototype.constructor == nil) then
    return error("Cannot instantiate class without constructor!")
  end

  local instance = Object.new()
  Object.assign(instance, class.prototype)
  setmetatable(instance, getmetatable(class.prototype))

  instance:constructor(...)
  return instance
end

return Class
