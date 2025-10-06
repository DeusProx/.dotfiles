return {
  cmd = { "lua-language-server", "--force-accept-workspace=true" },
  filetypes = { 'lua' }, -- TODO: Remove again, when lua_ls stops attaching to everything
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      telemetry = { enabled = false },
      diagnostics = { globals = { 'vim' } },
      -- Make LS aware of neovim runtime & libraries
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          "${3rd}/luv/library",
          vim.fn.stdpath('config'),
        },
      },
    },
  },
  single_file_support = true,
}

