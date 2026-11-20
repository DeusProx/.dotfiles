local auto_record = false
-- local directory_override = nil -- Set an absolute path to override XDG Videos.
local directory_override = '/mnt/alt-disk/' -- INFO: The current local directory on homi

local function recording_directory()
  local lookup = io.popen('xdg-user-dir VIDEOS', 'r')
  if not lookup then return end
  local videos = lookup:read('*l')
  lookup:close()
  if videos and videos:sub(1, 1) == '/' then
    return videos
  end
end
local directory = directory_override or recording_directory()
local runtime = assert(os.getenv('XDG_RUNTIME_DIR'))
local classes = {} -- Optional: ["org.example.MyGame"] = true

local games = {}
local manual = false
local socket, active_codec, active_application, active_file
local mode_timer, probe_path, probe_warned, output

local function quote(value)
  return '\'' .. value:gsub('\'', '\'"\'"\'') .. '\''
end

local function notify(options)
  options = options or {}
  local text = options.text or 'Screen recorder'
  local timeout = math.tointeger(options.timeout) or 2000
  local command = 'notify-send --app-name=Recording --expire-time=' .. timeout
    .. ' -- ' .. quote(text)

  if options.body then
    command = command .. ' ' .. quote(options.body)
  end

  hl.exec_cmd(command)
end

local function start_capture(application, codec, before_start)
  if not directory then
    notify({ text = 'Cannot resolve Videos directory with xdg-user-dir', timeout = 2000 })
    return
  end
  -- "/." succeeds only when the path resolves to a directory.
  local folder, err = io.open(directory .. '/.', 'r')
  if not folder then
    notify({ text = 'Recording directory unavailable: ', body = err, timeout = 2000 })
    return
  end
  folder:close()

  local token = os.tmpname()
  os.remove(token)
  local suffix = token:match('[^/]+$')
  socket = runtime .. '/gsr-' .. suffix .. '.sock'

  local name = application:gsub('%s+', '_'):gsub('[%c<>:"/\\|?*]', '-')
  local file = directory .. 'rec-' .. os.date('%y-%m-%d-%H:%M:%S') .. '-' .. name .. '.mkv'

  active_codec, active_application, active_file = codec, application, file
  hl.exec_cmd((before_start and before_start .. ' && ' or '')
    .. 'gpu-screen-recorder -w ' .. quote(output)
    .. ' -k ' .. quote(codec) .. ' -f 60 -q very_high -a default_output -o ' .. quote(file)
    .. ' -ipc ' .. quote(socket) .. ' >' .. quote(socket .. '.log') .. ' 2>&1')

  if not before_start then
    notify({
      text = 'Recording started!',
      body = 'Recording of "' .. active_application .. '" can be found at:\n"' .. active_file .. '"',
      timeout = 6000,
    })
  end

  return true
end

local function stop_command(socket_path)
  local path = quote(socket_path)
  local wait = 'until [ -S \"$1\" ]; do sleep 0.05; done'
  return 'timeout 5s sh -c ' .. quote(wait) .. ' sh ' .. path
    .. ' && gsr-cli -ipc ' .. path .. ' stop'
end

local function stop_capture()
  mode_timer:set_enabled(false)
  if probe_path then os.remove(probe_path) end
  probe_path, probe_warned, output = nil, nil, nil

  if not socket then return end
  hl.exec_cmd(stop_command(socket))
  notify({
    text = 'Recording stopped!',
    body = 'Recording of "' .. active_application .. '" can be found at:\n"' .. active_file .. '"',
    timeout = 6000,
  })
  socket, active_codec, active_application, active_file = nil, nil, nil, nil
end

local function probe_mode()
  local script = [[
for connector in /sys/class/drm/card*-"$1"; do
  [ "$(cat "$connector/status" 2>/dev/null)" = connected ] || continue
  id=$(cat "$connector/connector_id") || continue
  card=$(basename "$connector" | cut -d- -f1)
  timeout 0.4s drm_info -j "/dev/dri/$card" | jq -er --argjson id "$id" '
    .[].connectors[]? | select(.id == $id) | .properties.HDR_OUTPUT_METADATA
    | if .raw_value == 0 or .data.eotf == 0 then "av1_10bit"
      elif .data.eotf == 2 then "av1_hdr"
      else empty end'
  break
done
]]
  local temp = quote(probe_path .. '.tmp')
  hl.exec_cmd('sh -c ' .. quote(script) .. ' sh ' .. quote(output)
    .. ' >' .. temp .. ' 2>/dev/null; mv ' .. temp .. ' ' .. quote(probe_path))
end

local function check_mode()
  if not probe_path then return end
  local result = io.open(probe_path, 'r')
  if not result then return end

  local codec = result:read('*l')
  result:close()
  os.remove(probe_path)

  if codec == 'av1_hdr' or codec == 'av1_10bit' then
    probe_warned = false
    if codec ~= active_codec then
      local _, application = next(games)
      local before_start = socket and stop_command(socket)
      local name = active_application or application or 'Desktop'
      if not start_capture(name, codec, before_start) and not socket then
        manual = false
        stop_capture()
        return
      end
    end
  elseif not probe_warned then
    notify({
      text = 'Cannot determine SDR/HDR mode on ' .. output,
      timeout = 3000,
    })
    probe_warned = true
  end

  probe_mode()
end

local function sync()
  if manual or (auto_record and next(games)) then
    if not probe_path then
      local token = os.tmpname()
      os.remove(token)

      local monitor = hl.get_active_monitor()
      if not monitor then
        manual = false
        notify({ text = 'No active monitor to record', timeout = 3000 })
        return
      end
      output = monitor.name

      probe_path = runtime .. '/gsr-mode-' .. token:match("[^/]+$")
      probe_mode()
      mode_timer:set_enabled(true)
    end
  else
    stop_capture()
  end
end

mode_timer = hl.timer(check_mode, { timeout = 1000, type = 'repeat' })
mode_timer:set_enabled(false)

local function track(window)
  games[window.address] = nil
  if not window.monitor then return end

  local class = window.class or ''
  local title = (window.title or ''):match('^%s*(.-)%s*$')
  local id = class:match('^steam_app_([1-9]%d*)$')
  if id or window.xdg_tag == 'proton-game' then
    games[window.address] = 'Steam-' .. (title ~= '' and title or (id or class))
  elseif classes[class] then
    games[window.address] = title ~= '' and title or class
  end
end

local function update(window)
  local before = games[window.address]
  track(window)
  if before ~= games[window.address]
    then sync()
  end
end

local function restore()
  games = {}
  for _, window in pairs(hl.get_windows()) do track(window) end
  sync()
end

hl.on('window.open', update)
hl.on('window.class', update)
hl.on('window.move_to_workspace', update)
hl.on('window.close', function(window)
  if not games[window.address] then return end
  games[window.address] = nil
  sync()
end)
hl.on('hyprland.start', restore)
hl.on('config.reloaded', restore)
hl.on('monitor.layout_changed', restore)
hl.on('hyprland.shutdown', stop_capture)

local function start()
  manual = true
  sync()
end

local function stop()
  manual = false
  sync()
end

local function toggle()
  if manual
    then stop()
    else start()
  end
end

hl.bind('SUPER + SHIFT + R', toggle)
hl.bind('SUPER + SHIFT + A', function()
  auto_record = not auto_record
  sync()
  notify({
    text = 'Auto-recording',
    body = auto_record and 'ON' or 'OFF',
    timeout = 4000,
  })
end)

return {
  start = start,
  stop = stop,
  toggle = toggle
}

