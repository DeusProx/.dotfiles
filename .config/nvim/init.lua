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

  -- tree-sitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      -- for syntax-highlight, instead of regular expressions, use tree-sitter:
      highlight = {
        enable = true,
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      ensure_installed = {
        -- scripts
        'bash',
        'python',
        'lua',

        -- document
        'latex',
        'bibtex',
        'markdown',
        'markdown_inline',

        -- web
        'typescript',
        'tsx',
        'javascript',
        'html',
        'css',
        'scss',

        -- rust
        'rust',
        'ron',

        -- oldschool
        'c',
        'c_sharp',
        'cpp',

        -- rendering
        'glsl',
        'hlsl',
        'wgsl',

        -- build
        'make',
        'cmake',
        'dockerfile',

        -- tooling
        -- 'diff',
        -- 'comment',
        -- 'git_config',
        -- 'git_rebase',
        -- 'gitattributes',
        -- 'gitcommit',
        -- 'gitignore',

        -- data
        'json',
        'yaml',
        'proto',

        -- misc
        'regex',
        'sql',
      }
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,

  },
})

require('indent_blankline').setup({
  space_char_blankline = ' ',
})

