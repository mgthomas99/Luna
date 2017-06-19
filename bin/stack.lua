
--[[
  The scope stack used by Luna.
]]
local Stack = {
  items = {}
}

--[[
  Removes all elements from the stack. This
  function also ensures that all elements are
  completely removed (i.e, their references
  are removed also).
]]
function Stack.clear()
  for i=1, #Stack.items do
    Stack.items[i] = nil
  end
end

--[[
  Returns the element `from` indexes away from
  the top of the stack. For example, `Stack.peek(0)`
  will return the top element of the stack,
  `Stack.peek(1)` will return the second element
  from the top of the stack, etc.

  If the stack has no values (i.e, a size of 0),
  this function will return `nil`.
]]
function Stack.peek(from)
  if (from == nil) then
    from = 0
  elseif (type(from) ~= "number") then
    return error("Expected number!")
  end

  local size = Stack.size()
  if (size == 0) then
    return nil
  elseif (size - from <= 0) then
    return nil
  end

  return Stack.items[size - from]
end

--[[
  Removes the top item from the stack and returns
  it. If the stack has no values, this function
  does nothing and returns nil.
]]
function Stack.pop()
  if (#Stack.items == 0) then
    return nil
  end
  local item = Stack.items[#Stack.items]
  Stack.items[#Stack.items] = nil
  return item
end

--[[
  Pushes the argument item onto the stack and
  returns the argument.
]]
function Stack.push(item)
  table.insert(Stack.items, item)
  return item
end

--[[
  Returns the number of elements in the stack.
]]
function Stack.size()
  return #Stack.items
end

return Stack
