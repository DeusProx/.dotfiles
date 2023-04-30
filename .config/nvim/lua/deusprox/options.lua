-- See :help vim.o
-- Apply reasonable defaults

-- You shall not create strange files!
vim.opt.swapfile = false
vim.opt.backup = false

-- You shall show line numbers!
vim.opt.nu = true
vim.opt.relativenumber = true

-- You shall color certain columns so length of line can be kept short!
vim.opt.colorcolumn = '80,120,140,160'
vim.api.nvim_set_hl(0, 'colorcolumn', { ctermbg=0 })

-- You shall not wrap lines!
vim.opt.wrap = false

-- You shall handle tab as two spaces (and be smart about it)!
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
