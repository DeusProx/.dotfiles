require('deusprox')

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- import plugins from ~/.config/nvim/lua/plugin/*
  { import = 'plugin' },

  -- theme: tokyonight
  { 'folke/tokyonight.nvim' },

  -- better escape handling
  --   e.g. provides 'jk' & 'jj' to escape
  { 'max397574/better-escape.nvim' },

  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Flash Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },

  -- helps showing identation level
  { 'lukas-reineke/indent-blankline.nvim' },

  -- shows the colorcolumns as characters
  -- { 'lukas-reineke/virt-column.nvim' },
  { 'DeusProx/virt-column.nvim' }, -- Fork to fix deprecated API usage

  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },

  -- helps undoing unwanted changes
  { 'mbbill/undotree' },

  -- shows trailing white spaces
  { 'echasnovski/mini.trailspace', version = false },

  -- appearance --

  -- scrollbar
  { 'petertriho/nvim-scrollbar', lazy = true },

  -- bufferline
  { 'tomiis4/BufferTabs.nvim', lazy = false },

  -- statusline
  -- { 'nvim-lualine/lualine.nvim' },
  -- { 'tamton-aquib/staline.nvim'  }, -- Also includes the tabline named 'stabline'
  { 'DeusProx/staline.nvim'  }, -- Fork to fix deprecated API usage

  -- icons
  { 'nvim-tree/nvim-web-devicons', lazy = true },

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
        'astro',
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
  { 'nvim-treesitter/playground' },

  -- html
  { 'windwp/nvim-ts-autotag' }, -- adds autoclose and autorename for html tags to treesitter

  -- css
  { 'ziontee113/color-picker.nvim' }, -- adds color picker ability for css
  { 'nvim-colortils/colortils.nvim' }, -- adds color picker ability for css
  { 'brenoprata10/nvim-highlight-colors' }, -- highlights css values for colors with the color itself

  {
    'iamcco/markdown-preview.nvim', -- previews markdown in the browser
    lazy = false,
    config = function()
      vim.fn['mkdp#util#install']()
    end,
  },

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
          'bashls',
          'tsserver',
          'rust_analyzer',
          'wgsl_analyzer',
          'jsonls',
          'html',
          'cssls',
          'marksman',
          'eslint',
          'volar', -- vue
          'pyright',
          'typst_lsp',
        }
      })
    end,
  },

  {
    'kaarmu/typst.vim',
    ft = 'typst',
    lazy = false,
  },

  -- json schemas
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false, -- last release is way too old
  },

  -- collection of lsp (language server protocol) configs
  { 'neovim/nvim-lspconfig' },

  -- comments, because they are language dependent
  { 'JoosepAlviste/nvim-ts-context-commentstring' },
  { 'echasnovski/mini.comment', version = false },

  -- autocompletion
  --   completion engine
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-emoji' },
  { 'chrisgrieser/cmp-nerdfont' },
  { 'hrsh7th/cmp-cmdline' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-path' },

  --   luasnip
  { 'L3MON4D3/LuaSnip' },
  { 'saadparwaiz1/cmp_luasnip' },

  -- offers git support
  { 'tpope/vim-fugitive' },
  { 'lewis6991/gitsigns.nvim' },
})

require('nvim-ts-autotag').setup()
require('color-picker').setup()
require('colortils').setup()
require('nvim-highlight-colors').setup()

require('better_escape').setup()

require('ibl').setup({
  indent = {
    char = '│',
  },
})

require('virt-column').setup()

require('mini.trailspace').setup()

require('nvim-web-devicons').setup()

require('scrollbar').setup()

require('buffertabs').setup({
      ---@type 'row'|'column'
    display = 'column',

    ---@type 'left'|'right'|'center'
    horizontal = 'right',

    ---@type 'top'|'bottom'|'center'
    vertical = 'center',
})

-- require('lualine').setup()
require('staline').setup({ -- based on https://github.com/tamton-aquib/staline.nvim/wiki/Examples#simple-line
  sections = {
    left = { '  ', 'mode', ' ', 'branch', ' ',  'file_name' },
    mid = { 'lsp' },
    right = { 'file_size' ,  'file_name', 'line_column', '  ', ' ' }
	},
	-- mode_colors = {
	--   i = "#d4be98",
	--   n = "#84a598",
	--   c = "#8fbf7f",
	--   v = "#fc802d",
	-- },
	defaults = {
    true_colors = true,
    line_column = ' [%l/%L] :%c  ',
    branch_symbol = ' 󰘬 '
	},
  mode_icons = {
    n = '',
    i = '',
    c = '',
    v = '',
  },
})

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
  sources = cmp.config.sources(
    {
      { name = 'nvim_lsp' },
      -- { name = 'vsnip' }, -- For vsnip users.
      { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    },
    {{ name = 'buffer' }},
    {
      { name = 'emoji' },
      { name = 'nerdfont' }
    }
  )
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources(
    {{ name = 'cmp_git' }}, -- You can specify the `cmp_git` source if you were installed it.
    {{ name = 'buffer' }}
  )
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {{ name = 'buffer' }}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources(
    {{ name = 'path' }},
    {{ name = 'cmdline' }}
  )
})

-- Also use diagnostics provided by lsp in insert mode
vim.diagnostic.config({
  update_in_insert = true,
})

-- Workaround which causes 100% CPU usage und blocks neovim when a lot of files are watched
-- TODO: Check if this can be removed again
local ok, wf = pcall(require, "vim.lsp._watchfiles")
if ok then
   -- disable lsp watcher. Too slow on linux
   wf._watchfunc = function()
     return function() end
   end
end

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Actually load the damn lsp servers
--   still quite unsure why I have to do that manually after these mason shenanigans
--   https://imgflip.com/i/7k4h3c
require('lspconfig').bashls.setup {
  capabilities = capabilities
}
require('lspconfig').lua_ls.setup {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
    },
  },
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
  capabilities = capabilities,
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    }
  },
}
require('lspconfig').html.setup {
  capabilities = capabilities
}
require('lspconfig').volar.setup {
  capabilities = capabilities
}
require('lspconfig').cssls.setup {
  capabilities = capabilities
}
require('lspconfig').eslint.setup {
  capabilities = capabilities
}
require('lspconfig').marksman.setup {
  capabilities = capabilities
}
require('lspconfig').pyright.setup {
  capabilities = capabilities
}
require('lspconfig').typst_lsp.setup {
  capabilities = capabilities,
  settings = {
    exportPdf = "onType",
  },
}

require('ts_context_commentstring').setup({
  enable_autocmd = false,
})
require('mini.comment').setup({
    options = {
    custom_commentstring = function()
      return require('ts_context_commentstring').calculate_commentstring() or vim.bo.commentstring
    end,
  },
})

require('gitsigns').setup({
  signcolumn = true,
  numhl = false,
  linehl = false,
  word_diff = false,
  current_line_blame = true,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol',
    delay = 0,
    ignore_whitespace = true,
  },
})

require('tokyonight').setup({
  style = 'night',
  transparent = true,
  styles = {
    sidebars = 'transparent',
    floats = 'transparent',
  }
})
vim.cmd.colorscheme('tokyonight')

