
--[[
  Add our lib/ folder to the package path so that
  `require()` can find Luna.
]]
package.path = package.path .. ";./../../../?.lua"
Luna = require("Luna/luna")
