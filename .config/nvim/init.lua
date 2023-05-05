require('deusprox')

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
  -- import plugins from ~/.config/nvim/lua/plugin/*
  { import = 'plugin' },

  -- theme: tokyonight
  { 'folke/tokyonight.nvim' },

  -- helps showing identation level
  { 'lukas-reineke/indent-blankline.nvim' },

  -- helps undoing unwanted changes
  { 'mbbill/undotree' },

  -- shows trailing white spaces
  { 'echasnovski/mini.trailspace', version = false },

  -- tree-sitter - incremental parser for buffer
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
  { 'nvim-treesitter/playground'},

  -- collection of lsp (language server protocol) configs
  { 'neovim/nvim-lspconfig' },

  -- mason - package manager for neovim
  --   installs & manages ...
  --   - lsp (language server protocol) servers
  --   - dap (debug adapter protocol) servers
  --   - linters
  --   - formatters
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end,
  },
  -- bridge between lspconfig and mason
  --   helps with advanced installation features
  {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = {
          'lua_ls',
          'tsserver',
          'rust_analyzer',
          'wgsl_analyzer',
          'jsonls',
          'html'
        }
      })
    end,
  },

  -- autocompletion
  --   completion engine
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },

  --   luasnip
  { 'L3MON4D3/LuaSnip' },
  { 'saadparwaiz1/cmp_luasnip' },

  -- offers git support
  { 'tpope/vim-fugitive' },
})

require('indent_blankline').setup({
  space_char_blankline = ' ',
})

require('mini.trailspace').setup()

-- nvim-cmp
--   completion engine
local cmp = require('cmp')
cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    -- { name = 'vsnip' }, -- For vsnip users.
    { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Actually load the damn lsp servers
--   still quite unsure why I have to do that manually after these mason shenanigans
--   https://imgflip.com/i/7k4h3c
require('lspconfig').lua_ls.setup {
  capabilities = capabilities
}
require('lspconfig').tsserver.setup {
  capabilities = capabilities
}
require('lspconfig').rust_analyzer.setup {
  capabilities = capabilities
}
require('lspconfig').wgsl_analyzer.setup {
  capabilities = capabilities
}
require('lspconfig').jsonls.setup {
  capabilities = capabilities
}
require('lspconfig').html.setup {
  capabilities = capabilities
}
--require('lspconfig').markdown.setup {
--  capabilities = capabilities
--}

require('tokyonight').setup({
  style = 'night',
  transparent = true,
  styles = {
    sidebars = 'transparent',
    floats = 'transparent',
  }
})
vim.cmd.colorscheme('tokyonight')

