
package.path = package.path .. ";" .. (arg[1]:match("(.*[\\|/])") or "") .. "?.lua"

local Class = require("bin/class")
local FS = require("bin/fs")
local Imports = require("bin/import")

  export = function(exports)
    if (type(exports) ~= "table") then
      return error("Expected table!")
    end

    for k,v in pairs(exports) do
      _G[k] = v
    end
  end

  import = function(path)
    Imports.import(path)
  end

  class = function(identifier)
    if ((identifier == nil) or (type(identifier) ~= "string")) then
      return error("Anonymous classes not yet supported!")
    end

    return function(prototype)
      local class = Class.create(identifier, prototype)
      _G[identifier] = class
      return class
    end
  end

  new = function(class, ...)
    local instance = Class.instantiate(class, ...)
    return instance
  end

--[[
  True entry point of the application. Execute
  code in an anonymous function to avoid local
  variables being declared in the global scope.
  The exit code is returned.
--]]
return (function(args)
    LUNA = {}
    if (#args > 0) then
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
end)({...})
