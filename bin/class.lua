
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
  class. Luna inherits JavaScript's prototype-based
  class system.
]]
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

  local instance = {}
  for k,v in pairs(class.prototype) do
    instance[k] = v
  end
  instance.getClass = function(self)
    return self.__meta.class
  end

  instance:new(...)
  return instance
end

return Class
