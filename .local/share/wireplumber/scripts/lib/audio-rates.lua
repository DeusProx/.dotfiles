-- Find the highest sample rate for the output channel

local function highest(value)
  if type(value) == "number" then return value end
  if type(value) ~= "table" then return nil end
  if value.pod_type == "Choice.Range" then return value[3] end
  if value.pod_type == "Choice.Step" then
    return value[2] + math.floor((value[3] - value[2]) / value[4]) * value[4]
  end
  if value.pod_type == "Choice.Enum" or value.pod_type == "Choice.None" then
    return math.max(table.unpack(value))
  end
end

local function supports(value, channels)
  if not value or not channels then return true end
  if type(value) == "number" then return value == channels end
  if value.pod_type == "Choice.Range" or value.pod_type == "Choice.Step" then
    return channels >= value[2] and channels <= value[3]
        and (not value[4] or (channels - value[2]) % value[4] == 0)
  end
  for _, count in ipairs(value) do
    if count == channels then return true end
  end
  return false
end

return function(output, nodes)
  -- Split UCM outputs expose virtual formats; inspect their hardware instead.
  local parent = output.properties["api.alsa.split.name"]
  output = parent and nodes:lookup { Constraint { "node.name", "=", parent } } or output
  local channels = tonumber(output.properties["audio.channels"])
  local maximum
  for parameter in output:iterate_params("EnumFormat") do
    local format = parameter:parse().properties
    if format.mediaType == "audio" and format.mediaSubtype == "raw"
        and supports(format.channels, channels) then
      local rate = highest(format.rate)
      -- Reject unbounded virtual-adapter ranges rather than inventing a limit.
      if rate and rate >= 8000 and rate <= 1536000 then
        maximum = math.max(maximum or rate, rate)
      end
    end
  end
  return maximum
end

