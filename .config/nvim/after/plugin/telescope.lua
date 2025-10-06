local builtin = require('telescope.builtin')
local util = require('util')

-- choose '<leader>f' as common prefix for "[f]ind" commands

vim.keymap.set('n', '<leader>fr',  builtin.resume,     { desc = '[f]ind [r]esume     - opens last search' })
vim.keymap.set('n', '<leader>ff',  builtin.find_files, { desc = '[f]ind [f]iles      - ' })
vim.keymap.set('n', '<leader>fb',  builtin.buffers,    { desc = '[f]ind [b]uffer     - searches for input in the file paths of all open buffers' })
vim.keymap.set('n', '<leader>fk',  builtin.keymaps,    { desc = '[f]ind [k]eymaps    - searches in keyboard shortcuts' })
vim.keymap.set('n', '<leader>flt', builtin.help_tags,  { desc = '[f]ind [l]ua [t]ags - searches in plugin documentation' })
vim.keymap.set('n', '<leader>fg',  builtin.git_files,  { desc = '[f]ind [g]it        - ' }) -- TODO
vim.keymap.set('n', '<leader>fq',  builtin.quickfix,   { desc = '[f]ind [q]uickfix   - ' }) -- TODO
-- builtin.lsp_definitions -- TODO: <leader>flsp
-- builtin.jumplist -- TODO: <leader>fj

local function live_grep_visual()
    local saved_reg = vim.fn.getreg('a')
    local saved_regtype = vim.fn.getregtype('a')

    vim.cmd('normal! "ay')
    --local text = vim.fn.getreg('a')
    vim.fn.setreg('a', saved_reg, saved_regtype)

    builtin.live_grep({
        additional_args = {'--multiline'},
        -- default_text = text:gsub('\n', '\\n'):gsub('([%(%).%%%+%-%*%?%[%]%^%$%\\%{%}%|])', '\\%1'):gsub('\\\\n', '\\n'),
    })
end

-- you need to have ripgrep installed
if util.isInstalled('rg', 'ripgrep') then
  vim.keymap.set('n',          '<leader>ft', live_grep_visual,   { desc = '[f]ind [t]ext - searches for input text in all buffers' })
  -- vim.keymap.set('n',          '<leader>fc', builtin.current_buffer_fuzzy_find,     { desc = '[f]ind [c]urrent buffer - searches for input in current buffer' }) -- TODO: remove?
  -- vim.keymap.set('n',          '<leader>fb', builtin.buffers,     { desc = '[f]ind [b]uffers - searches for input in all open buffers' }) -- TODO: remove?
  vim.keymap.set({ 'n', 'x' }, '<leader>fs', builtin.grep_string, { desc = '[f]ind [s]election - searches for the string under the cursor' })
end

