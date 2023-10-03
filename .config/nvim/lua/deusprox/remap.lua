-- Set leader prefix to space
vim.g.mapleader = ' '

vim.keymap.set('n', '<leader>fmt',   vim.lsp.buf.format,          { desc = '[f]or[m]a[t]' })

vim.keymap.set('n', '<leader>fe',    vim.cmd.Ex,          { desc = '[f]ile [e]xplorer' })

vim.keymap.set('n', '<leader>h',     '<cmd>bprev<CR>',    { desc = 'previous buffer - vim style' })
vim.keymap.set('n', '<leader>l',     '<cmd>bnext<CR>',    { desc = 'next buffer - vim style' })
vim.keymap.set('n', '<leader><tab>', '<cmd>b#<CR>',       { desc = 'last buffer' })

vim.keymap.set('n', '<leader>ub',    '<cmd>bdelete<CR>',  { desc = '[u]nload [b]uffer' })
vim.keymap.set('n', '<leader>uba',   '<cmd>%bdelete<CR>', { desc = '[u]nload [b]uffer [a]ll' })

