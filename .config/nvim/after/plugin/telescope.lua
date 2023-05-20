local builtin = require('telescope.builtin')

-- choose '<leader>f' as common prefix for file commands

vim.keymap.set('n', '<leader>km', builtin.keymaps, {})     -- show keymaps

vim.keymap.set('n', '<leader>fu', builtin.buffers, {})     -- list buffers
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})     -- list buffers

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})  -- search fuzzy
vim.keymap.set('n', '<leader>fg', builtin.git_files, {})   -- search git

-- search with ripgrep in files
--   you need to have ripgrep installed
vim.keymap.set('n', '<leader>fs', function()
  builtin.grep_string({ search = vim.fn.input('grep > ')})
end)

-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

