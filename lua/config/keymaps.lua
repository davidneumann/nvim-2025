-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Buffers
vim.keymap.set('n', '<leader>bs', ':w<cr>', { desc = '[B]uffer [S]ave' })

vim.keymap.set('n', '<leader>bd', ':bd<cr>', { desc = '[B]uffer [D]elete / Close' })
vim.keymap.set('n', '<leader>bs', ':w<cr>', { desc = '[B]uffer [S]ave' })

function SetKeybinds()
  local fileTy = vim.api.nvim_get_option_value('filetype', { buf = 0 })

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
