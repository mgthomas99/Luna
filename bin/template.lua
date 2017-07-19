
--[[
  Utility functions for dealing with class templates.
  A lot of the functions within the Template API exist
  to abstract away from operator-based expressions;
  for example, `template.has_static()` is an abstraction
  of `template.static ~= {}` and should be used in case
  support/implementation of static properties is
  modified.
]]
local Template = {}

--[[
  Removes any empty properties in `template`, such as
  empty 'static' tables.
]]
function Template.strip(template)
  if (Template.has_static(template)) then
    if (#(Template.get_static(template)) == 0) then
      template.static = nil
    end
  end
  return template
end

--[[
  Returns `template`'s static properties, or `nil`
  if there are none.
]]
function Template.get_static(template)
  return template.static
end

--[[
  Returns `true` if `template` has static properties
  defined, `false` otherwise.
]]
function Template.has_static(template)
  local static = Template.get_static(template)
  return static ~= nil
end

return Template
