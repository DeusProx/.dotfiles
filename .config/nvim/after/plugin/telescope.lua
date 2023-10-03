local builtin = require('telescope.builtin')
local util = require('util')

-- choose '<leader>f' as common prefix for [f]ind commands

vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[f]ind [f]iles' })
vim.keymap.set('n', '<leader>fg', builtin.git_files,  { desc = '[f]ind [g]it' })
vim.keymap.set('n', '<leader>fb', builtin.buffers,    { desc = '[f]ind [b]uffers' })
vim.keymap.set('n', '<leader>fk', builtin.keymaps,    { desc = '[f]ind [k]eymaps' })
vim.keymap.set('n', '<leader>flt', builtin.help_tags,  { desc = '[f]ind [l]ua [t]ags - shows lua help tags' })

-- you need to have ripgrep installed
local isRipgrepInstalled = util.isInstalled('rg')
if isRipgrepInstalled then
  vim.keymap.set('n',          '<leader>ft', builtin.live_grep,   { desc = '[f]ind [t]ext' })
  vim.keymap.set({ 'n', 'x' }, '<leader>fs', builtin.grep_string, { desc = '[f]ind [s]election' })
end

