-- Set leader prefix to space
vim.g.mapleader = ' '

vim.keymap.set('n', '<leader>fe',    vim.cmd.Ex,          { desc = '[f]ile [e]xplorer' })

vim.keymap.set('n', '<leader>h',     '<cmd>bprev<cr>',    { desc = 'previous buffer - vim style' })
vim.keymap.set('n', '<leader>l',     '<cmd>bnext<cr>',    { desc = 'next buffer - vim style' })
vim.keymap.set('n', '<leader><tab>', '<cmd>b#<cr>',       { desc = 'last buffer' })

vim.keymap.set('n', '<leader>ub',    '<cmd>bdelete<cr>',  { desc = '[u]nload [b]uffer' })
vim.keymap.set('n', '<leader>uba',   '<cmd>%bdelete<cr>', { desc = '[u]nload [b]uffer [a]ll' })

