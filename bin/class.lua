
local Class = {}

--[[
  Creates a new class from the identifier and template
  provided.

  The 'identifier' argument is simply a string containing
  the name of the class. Try to use a unique identifier
  for every call to this function so that no two classes
  have the same name.

  The 'template' argument is a table that defines what
  the class should include. The template table is used
  to construct a class and the class' prototype. It
  should be formatted like so:

  template = {
    static = {
      -- Here goes all of the static values for
      -- this class.
    },

    new = function(self, ...)
      -- The class' constructor. This is an optional
      -- field. Not including a constructor means
      -- the class may not be instantiated.
    end,

    -- All of the prototype values should be added
    -- here.
  }

  This function, assuming no error occurs, will
  return a class (table) that can be sent to the
  `instantiate` function to be instantiated.
]]
function Class.create(identifier, template)
  local class = {
    meta = {
      template = template
    },
    name = identifier,
    prototype = {
      toString = function(self)
        local str = identifier
        for k,v in pairs(template) do
          str = str .. "\n\t" .. k .. " = " .. "[" .. type(v) .. "]"
        end
        return str
      end
    }
  }

  if (template.static ~= nil) then
    for k,v in pairs(template.static) do
      class[k] = v
    end
    template.static = {}
  end
  for k,v in pairs(template) do
    class.prototype[k] = v
  end

  return class
end

--[[
  Returns a new instance of the class provided,
  using the function call's varargs to invoke the
  class' constructor.
]]
function Class.instantiate(class, ...)
  if (class.prototype.new == nil) then
    return error("Cannot instantiate class without constructor!")
  end

  local instance = {
    meta = {
      class = class
    }
  }
  for k,v in pairs(class.prototype) do
    instance[k] = v
  end

  instance:new(...)
  return instance
end

return Class
