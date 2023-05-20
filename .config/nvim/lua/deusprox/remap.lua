vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)
vim.keymap.set('i', 'jk', '<Esc>', options)

vim.keymap.set('n', '<leader>h', '<cmd>bprev<CR>')
vim.keymap.set('n', '<leader>l', '<cmd>bnext<CR>')

-- https://www.reddit.com/r/neovim/comments/10fr6gh/comment/j4zcto7/?utm_source=reddit&utm_medium=web2x&context=3
-- vim.keymap.set('n', '<M-h>', '<cmd>bprev<CR>')
-- vim.keymap.set('n', '<M-l>', '<cmd>bnext<CR>')
-- vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>')

