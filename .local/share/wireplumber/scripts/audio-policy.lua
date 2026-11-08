-- Loaded by WirePlumber configs in ~/.config/wireplumber/wireplumber.conf.d/
-- Selects EQ profiles defined in ~/.config/pipewire/pipewire.conf.d/
-- Switch profiles with: wpctl settings audio.profile <auto|profile>

-- See WirePlumber Lua API:
-- https://pipewire.pages.freedesktop.org/wireplumber/scripting/lua_api.html

local config = Conf.get_section_as_json("audio.policy", Json.Object {}):parse()
local hostname = Core.get_info().host_name:match("^[^.]+")
local default_profile = config.hosts[hostname] or config.default
local common = require("common-utils")
local linking = require("linking-utils")
local filters = require("filter-utils")
local maximum_rate = require("audio-rates")
local nodes = common.get_object_manager("node")
local metadata = common.get_object_manager("metadata")
local log = Log.open_topic("s-audio-policy")

local function find_node(name)
  return nodes:lookup { Constraint { "node.name", "=", name } }
end

local function set(name, subject, key, value)
  local object = metadata:lookup { Constraint { "metadata.name", "=", name } }
  if object and object:find(subject, key) ~= value then
    object:set(subject, key, "Spa:String:JSON", value)
  end
end

local function update()
  local defaults = common.get_default_metadata_object()
  local selected = defaults and defaults:find(0, "default.audio.sink")
  local output = selected and find_node(Json.Raw(selected):parse().name)
  if output and output.properties["node.name"]:match("^eq%.") then output = nil end

  local profile = Settings.get_string("audio.profile")
  if profile == "auto" then
    profile = default_profile
    for _, rule in ipairs(config.devices) do
      if output and output.properties["node.name"]:match(rule.name) then
        profile = rule.profile
        break
      end
    end
  end
  if profile ~= "neutral" and profile ~= "bathtub" and profile ~= "harman" then
    log:warning("Unknown audio profile: " .. tostring(profile))
    return
  end

  -- Disable other profiles before enabling the selected one.
  for _, name in ipairs { "bathtub", "harman" } do
    local filter = find_node("eq." .. name)
    if filter and (not output or name ~= profile) then
      set("filters", filter["bound-id"], "filter.smart.disabled", "true")
    end
  end

  local filter = find_node("eq." .. profile)
  if output and filter then
    local target = Json.Object { ["node.name"] = output.properties["node.name"] }
    set("filters", filter["bound-id"], "filter.smart.target", target:get_data())
    set("filters", filter["bound-id"], "filter.smart.disabled", "false")
  end

  local rate = output and Settings.get_int("audio.rate") or 0
  if output and rate == 0 then rate = maximum_rate(output, nodes) or 0 end
  set("settings", 0, "clock.force-rate", tostring(rate))
end

SimpleEventHook {
  name = "audio-policy/update",
  interests = {
    EventInterest {
      Constraint { "event.type", "=", "metadata-changed" },
      Constraint { "metadata.name", "=", "default" },
      Constraint { "event.subject.key", "=", "default.audio.sink" },
    },
    EventInterest {
      Constraint { "event.type", "=", "node-added" },
      Constraint { "node.name", "#", "eq.*" },
    },
    EventInterest {
      Constraint { "event.type", "=", "node-params-changed" },
      Constraint { "event.subject.param-id", "c", "EnumFormat", "Format" },
    },
    EventInterest {
      Constraint { "event.type", "=", "metadata-added" },
      Constraint { "metadata.name", "c", "settings", "filters" },
    },
  },
  execute = update,
}:register()

Settings.subscribe("audio.profile", update)
Settings.subscribe("audio.rate", update)
update()

-- Native smart-filter lookup can skip targets that are UCM loopbacks.
local hook = SimpleEventHook {
  name = "audio-policy/route",
  after = { "linking/get-filter-from-target" },
  before = { "linking/prepare-link" },
  interests = { EventInterest {
    Constraint { "event.type", "=", "select-target" },
  } },
  execute = function(event)
    local _, _, stream, properties, flags, target =
        linking:unwrap_select_target_event(event)

    if not target then return end
    local node = stream:get_associated_proxy("node")
    if node.properties["node.link-group"] then return end

    for _, filter in ipairs(filters.filters) do
      if (filter.name == "bathtub" or filter.name == "harman")
          and filter.smart and not filter.disabled
          and filter.direction == common.getTargetDirection(properties)
          and filter.media_type == properties["media.type"]
          and filter.target and filter.target.id == target.id then
        local compatible, passthrough =
            linking.checkPassthroughCompatibility(stream, filter.main_si)

        if compatible and linking.canLink(properties, filter.main_si) then
          flags.can_passthrough = passthrough
          event:set_data("target", filter.main_si)
        end
        return
      end
    end
  end,
}
hook:register()

