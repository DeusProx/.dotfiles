-- See :help vim.o
-- Apply reasonable defaults

-- You shall not create strange files!
vim.opt.swapfile = false
vim.opt.backup = false

-- You shall remember what I did so I can undo at any point in time
vim.opt.undodir = os.getenv('HOME') .. '/.cache/nvim/undodir'
vim.opt.undofile = true

-- You shall provide true 24-bit colours in the terminal!
vim.opt.termguicolors = true

-- You shall provide line numbers and also relative ones!
vim.opt.nu = true
vim.opt.relativenumber = true

-- You shall always show the sign column!
vim.opt.signcolumn = "yes"

-- You shall not scroll of screen, but let me still jump to top and bottom!
vim.opt.scrolloff = 0

-- You shall provide visible line length!
vim.opt.colorcolumn = '80,120,140,160'

-- You shall not wrap lines!
vim.opt.wrap = false

-- You shall handle tab as two spaces (and be smart about it)!
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- You shall highlight all search matches!
vim.opt.hlsearch = true

-- You shall provide an incremental search!
vim.opt.incsearch = true

-- You shall show diagnostics in a floating window instead of inline text
vim.diagnostic.config({
  virtual_text = false
})
vim.o.updatetime = 250
vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

