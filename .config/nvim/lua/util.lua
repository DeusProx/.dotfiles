local M = {}

function M.isInstalled(program)
  local command = "command -v " .. program .. " >/dev/null 2>&1"
  local exitCode = os.execute(command)

  return exitCode == 0
end

return M

