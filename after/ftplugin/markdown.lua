local map = function(keys, func, desc, mode)
  mode = mode or 'n'
  vim.keymap.set(mode, keys, func, { desc = '[O]bsidian: ' .. desc })
end

vim.opt.wrap = false
vim.opt.linebreak = false

require('which-key').add { '<leader>o', group = '[O]bsidian' }

map('<leader>o<space>', '<cmd>ObsidianToggleCheckbox<cr>', '[t]oggle checkbox')
map('<leader>ot', '<cmd>ObsidianTags<cr>', '[t]ags')
map('<leader>oT', '<cmd>ObsidianTemplate<cr>', 'apply [T]emplate')
map('<leader>on', '<cmd>ObsidianNew<cr>', '[n]ew')
map('<leader>oN', '<cmd>ObsidianNewFromTemplate<cr>', '[N]ew from template')
map('<leader>oo', '<cmd>ObsidianOpen<cr>', '[o]pen')
map('<leader>ob', '<cmd>ObsidianBacklinks<cr>', '[b]acklinks')
map('<leader>os', '<cmd>ObsidianSearch<cr>', '[s]earch')
