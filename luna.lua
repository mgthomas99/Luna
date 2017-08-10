
local Class = require("Luna/bin/class")
local Interface = require("Luna/bin/interface")

--[[
  Table containing all core Luna functions.
--]]
local Luna = {}
Luna = {

  --[[
    Copies the Luna function table into the global scope.
  ]]
  globalise = function()
    _G["Luna"] = Luna
  end,

  --[[
    Copies all properties of the Luna table into the global
    scope.
  --]]
  introduce = function()
    for k,v in pairs(Luna) do
      if (k ~= "introduce") then
        _G[k] = v
      end
    end
  end,

  --[[
    Creates a new class which is a subclass of `super`. The
    `template` is used to create the class.

    This function can be invoked in one of three ways:
      `Luna.class({ ... })`
        Creates an anonymous class.
      `Luna.class(Bar, { ... })`
        Creates an anonymous class which is a subclass of
        class `Bar`.
      `Luna.class("Foo", { ... })`
        Creates a named class, "Foo".
      `Luna.class("Foo", Bar, { ... })
        Creates a named class, "Foo", which is a subclass of
        the class `Bar`.
  ]]
  class = function(identifier, super, template)
    if (type(identifier) == "string" and type(super) == "table" and type(template) == "table") then
      -- Everything's good!
    elseif (type(identifier) == "string" and type(super) == "table") then
      template = super
      super = nil
    elseif (type(identifier) == "table" and type(super) == "table") then
      template = super
      super = identifier
    elseif (type(identifier) == "table") then
      template = identifier
      identifier = nil
    else
      return error([[Unknown parameters! Expected one of the following:
        class( template )
        class( "identifier", template )
        class( "identifier", superclass, template )]])
    end

    return Class.create(identifier, super, template)
  end,

  implement = function(class, interface)
    return Class.implement(class, interface)
  end,

  interface = function(identifier, super, template)
    if (type(identifier) == "string" and type(super) == "table" and type(template) == "table") then
      -- Everything's good!
    elseif (type(identifier) == "string" and type(super) == "table") then
      template = super
      super = nil
    elseif (type(identifier) == "table" and type(super) == "table") then
      template = super
      super = identifier
    elseif (type(identifier) == "table") then
      template = identifier
      identifier = nil
    else
      return error([[Unknown parameters! Expected one of the following:
        interface( template )
        interface( "identifier", template )
        interface( "identifier", superclass, template )]])
    end

    return Interface.create(identifier, super, template)
  end,

  --[[
    Instantiates the specified class using the constructor
    parameters provided.
  ]]
  new = function(class, ...)
    local instance = Class.instantiate(class, ...)
    return instance
  end

}

return Luna
