--[[
  Set Lua 'require' and 'dofile' path index locations so that Lua can find
  nearby library files.
]]
package.path = package.path .. ";" .. (arg[1]:match("(.*[\\|/])")) .. "?.lua"

local Class = require("bin/class")
local FS = require("bin/fs")
local Imports = require("bin/import")
local Stack = require("bin/stack")
local Test = require("test/test")

Stack.push({

  LUNA = {
    stack = {
      get_super_scope = function()
        local stack_size = Stack.size()
        if (stack_size < 2) then
          return nil
        else
          return Stack.peek(Stack.size() - 1)
        end
      end,
      get_item = function(key)
        for i=0, Stack.size()-1 do
          local layer = Stack.peek(i)
          if (layer[key] ~= nil) then
            return layer[key]
          end
        end
        return nil
      end
    }
  },

  iif = function(a, b, c)
    if (a) then
      return b
    end
    return c
  end,

  read = function()
    return io.read()
  end,

  print = function(...)
    for i,v in ipairs({...}) do
      write(v, "\n")
    end
  end,

  write = function(...)
    local items = {...}
    for i,v in ipairs(items) do
      if (v ~= nil) then
        io.write(tostring(v))
      end
    end
  end,

  export = function(exports)
    if (type(exports) ~= "table") then
      return error("Expected table!")
    end

    local layer = LUNA.stack.get_super_scope()
    for k,v in pairs(exports) do
      layer[k] = v
    end
  end,

  import = function(path)
    Imports.import(path)
  end,

  class = function(identifier)
    if (identifier == nil) then
      return class("anon-" .. math.random())
    elseif (type(identifier) ~= "string") then
      return error("Anonymous classes not yet supported!")
    end

    return function(prototype)
      local class = Class.create(identifier, prototype)
      _G[identifier] = class
      return class
    end
  end,

  new = function(class, ...)
    if (class == nil) then
      return error("Attempt to instantiate nil!")
    elseif (type(class) ~= "table") then
      return error("Attempt to instantiate non-class!")
    elseif (class.prototype == nil) then
      return error("Attempt to instantiate non-class!")
    elseif (class.prototype.new == nil) then
      return error("Cannot instantiate class that does not have a constructor!")
    end

    local instance = Class.instantiate(class, ...)
    return instance
  end

})

_G = setmetatable(_G, {
  __newindex = function(self, key, value)
    local layer = Stack.peek()
    layer[key] = value
  end,
  __index = function(self, key)
    for i=0, Stack.size()-1 do
      local layer = Stack.peek(i)
      local value = layer[key]
      if (value) then
        return value
      end
    end

    return nil
  end
})

--[[
  True entry point of the application. Execute
  code in an anonymous function to avoid local
  variables being declared in the global scope.
--]]
return (function(args)
    if (#args > 0) then
      if (args[1] == "test") then
        Test.run()
      else
        LUNA.meta = {
          absolute_path = arg[0],
          directory = FS.get_directory(arg[0])
        }
        LUNA.script = {
          absolute_path = args[1],
          directory = FS.get_directory(args[1])
        }
        import(LUNA.script.absolute_path)
      end
    end
end)({...})
