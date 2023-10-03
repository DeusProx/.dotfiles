local mark = require('harpoon.mark')
local ui = require('harpoon.ui')

vim.keymap.set('n', '<leader>a', mark.add_file, { desc = '[m]ark file in harpoon' })
vim.keymap.set('n', '<leader>fh', ui.toggle_quick_menu, { desc = '[f]ile [h]arpoon' })
