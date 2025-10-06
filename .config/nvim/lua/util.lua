local M = {}

---@param command_name string
---@param program_name string
---
---@return boolean
function M.isInstalled(command_name, program_name)
  local command = 'command -v ' .. command_name .. ' >/dev/null 2>&1'
  local exitCode = os.execute(command)

  local isInstalled = exitCode == 0

  if isInstalled then
    vim.health.ok(command_name .. ': Found ' .. program_name)
  else
    vim.health.warn(command_name .. ': ' .. program_name.. ' not available')
  end

  return isInstalled
end

return M

