require('deusprox.options')

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      -- load the colorscheme here
      -- vim.cmd([[colorscheme tokyonight]])
      vim.cmd([[colorscheme tokyonight-night]])
      -- vim.cmd([[colorscheme tokyonight-storm]])
      -- vim.cmd([[colorscheme tokyonight-day]])
      -- vim.cmd([[colorscheme tokyonight-moon]])
    end,
  },
  { 'lukas-reineke/indent-blankline.nvim' },
})

require('indent_blankline').setup({
  space_char_blankline = ' ',
})

