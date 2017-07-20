
--[[
  Add our lib/ folder to the package path so that
  `require()` can find Luna.
]]
package.path = package.path .. ";./../../../?.lua"
Luna = require("Luna/luna")

--[[
  The following line is optional; the line brings
  Luna's functions into the global scope, so that
  we don't have to prepend every Luna function
  with `Luna.` (For example, by doing `Luna.introduce()`,
  we can begin to use `MyClass = class({})` instead
  of `MyClass = Luna.class({})`)
]]
Luna.introduce()
