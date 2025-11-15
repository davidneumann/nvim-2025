vim.keymap.set('n', '<leader>sC', function()
  require('telescope.builtin').live_grep { glob_pattern = { '*controller*.{ts,js}', '!*qatest', '!*/test', '!*.spec.*' }, default_text = '^ *@.*/' }
end, { desc = '[S]earch [C]ontrollers' })
