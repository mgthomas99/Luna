
local FS = {
  separator = "\\"
}

function FS.exists(path)
  local stream = FS.open(path, "r")
  if (stream ~= nil) then
    FS.close(stream)
    return true
  else
    return false
  end
end

function FS.close(stream, operation)
  io.close(stream)
end

function FS.open(path, operation)
  local stream = io.open(path, operation)
  return stream
end

function FS.join_directories(...)
  local dir = ""
  local items = {...}
  for i,v in ipairs(items) do
    dir = dir .. v .. FS.separator
  end
  return dir
end

function FS.get_directory(path, separator)
  separator = separator or FS.separator or "[\\|/]"
  return path:match("(.*" .. separator .. ")")
end

return FS
