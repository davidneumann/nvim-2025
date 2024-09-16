function SetKeybinds()
  local fileTy = vim.api.nvim_get_option_value('filetype', { buf = 0 })
  local opts = { prefix = '<localleader>', buffer = 0 }

  if fileTy == 'typescript' then
    require('which-key').add {
      {
        '<leader>co',
        function()
          vim.lsp.buf.code_action {
            apply = true,
            context = {
              only = { 'source.organizeImports.ts' },
              diagnostics = {},
            },
          }
        end,
        desc = 'Organize Imports',
      },
      {
        '<leader>ce',
        function()
          vim.opt.makeprg = "npm run --silent lint -- --format unix \\| grep ':'"
          vim.cmd 'make'
          vim.cmd 'botright copen'
        end,
        desc = 'Run eslint Project Wide',
      },
      {
        '<leader>cm',
        function()
          vim.opt.makeprg = 'npx tsc --pretty false \\| grep "./" \\| sed -r \'s/\\(([0-9]+),([0-9]+)\\)/:\\1:\\2/\' \\| sed "s@^@$PWD/@"'
          vim.cmd 'make'
          vim.cmd 'botright copen'
        end,
        desc = 'Run tsc Project Wide',
      },
      {
        '<leader>cR',
        function()
          vim.lsp.buf.code_action {
            apply = true,
            context = {
              only = { 'source.removeUnused.ts' },
              diagnostics = {},
            },
          }
        end,
        desc = 'Remove Unused Imports',
      },
    }
  elseif fileTy == 'sh' then
    --Left here as an example for future me
    -- wkl.register({
    --   ['W'] = { ':w<CR>', 'test write' },
    --   ['Q'] = { ':q<CR>', 'test quit' },
    -- }, opts)
  elseif fileTy == '' then
    require('which-key').add {
      { '<leader>F', desc = '[F]ile types' },
      {
        '<leader>Fj',
        function()
          vim.cmd 'set ft=json'
          vim.cmd "%!jq '.'"
        end,
        desc = 'Set [F]iletype [J]SON',
      },
    }
  end
end
vim.cmd 'autocmd FileType,VimEnter,BufEnter * lua SetKeybinds()'

-- Toggleterm keymaps
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
  vim.keymap.set('t', '<C-_>', [[<Cmd>ToggleTerm direction=float<CR>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd 'autocmd! TermOpen term://* lua set_terminal_keymaps()'

vim.keymap.set('n', '<leader>bd', ':bd<cr>', { desc = '[B]uffer [D]elete / Close' })
vim.keymap.set('n', '<leader>bs', ':w<cr>', { desc = '[B]uffer [S]ave' })

vim.keymap.set('n', '<space>cf', ':lua vim.lsp.buf.format()<cr>', { desc = 'Format code with LSP' })
vim.keymap.set('v', '<leader>cf', vim.lsp.buf.format, { desc = 'Format selected lines only?', silent = false })
vim.keymap.set('n', '<leader>cl', ':LspRestart<cr>', { desc = 'LSP [C]ode action: restart [l]sp', silent = false })

vim.keymap.set('n', '<leader>qf', function()
  vim.lsp.buf.code_action { apply = true }
end, { noremap = true, silent = false, desc = 'Auto fix all problems' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
