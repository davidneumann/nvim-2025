-- WARNING: LAZY IS NOT LOADED YET! SETTINGS ONLY IN HERE!!

vim.cmd 'packadd cfilter' -- Add quickfist filtering
-- vim.cmd.colorscheme("moonfly")
vim.g.have_nerd_font = true
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.o.expandtab = true
vim.opt.background = 'dark'
vim.opt.breakindent = true -- Every wrapped line will continue visually indented
vim.opt.colorcolumn = '80,120'
vim.opt.cursorline = true
vim.opt.foldlevelstart = 99
vim.opt.ignorecase = true
vim.opt.inccommand = 'split'
vim.opt.linebreak = true

-- Show non-space whitespace
vim.opt.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.listchars = { tab = '| ', trail = '·', nbsp = '␣' }
-- vim.opt.listchars = { nbsp = '␣' }

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 4
vim.opt.shiftwidth = 2
vim.opt.smartcase = true
vim.opt.softtabstop = 2
vim.opt.spell = true
vim.opt.spelllang = 'en_us'
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.sw = 2
vim.opt.tabstop = 2
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.wrap = true
vim.o.signcolumn = 'yes'
