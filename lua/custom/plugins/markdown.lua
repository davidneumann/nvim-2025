return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {},
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  },
  { 'jannis-baum/vivify.vim' },
  {
    'epwalsh/obsidian.nvim',
    version = '*', -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = 'markdown',
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    --   -- refer to `:h file-pattern` for more examples
    --   "BufReadPre path/to/my-vault/*.md",
    --   "BufNewFile path/to/my-vault/*.md",
    -- },
    dependencies = {
      -- Required.
      'nvim-lua/plenary.nvim',

      -- see below for full list of optional dependencies 👇
    },
    config = function()
      require('obsidian').setup {
        ui = { enable = false },
        workspaces = {
          {
            name = 'personal',
            path = '~/personal',
          },
          {
            name = 'no-vault',
            path = function()
              -- alternatively use the CWD:
              return assert(vim.fn.getcwd())
              -- return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
            end,
            overrides = {
              notes_subdir = vim.NIL, -- have to use 'vim.NIL' instead of 'nil'
              new_notes_location = 'current_dir',
              templates = {
                folder = vim.NIL,
              },
              disable_frontmatter = true,
            },
          },
        },
      }
    end,
    -- keys = function(_, keys)
    --   return {
    --     { '<leader>o<space>', '<cmd>ObsidianToggleCheckbox<cr>', desc = '[O]bsidian [t]oggle checkbox' },
    --     { '<leader>ot', '<cmd>ObsidianTags<cr>', desc = '[O]bsidian [t]ags' },
    --     { '<leader>oT', '<cmd>ObsidianTemplates<cr>', desc = '[O]bsidian [T]emplates' },
    --     { '<leader>on', '<cmd>ObsidianNew<cr>', desc = '[O]bsidian [n]ew' },
    --     { '<leader>oN', '<cmd>ObsidianNewFromTemplate<cr>', desc = '[O]bsidian [N]ew from template' },
    --     { '<leader>oo', '<cmd>ObsidianOpen<cr>', desc = '[O]bsidian [o]pen' },
    --     { '<leader>ob', '<cmd>ObsidianBacklinks<cr>', desc = '[O]bsidian [b]acklinks' },
    --     { '<leader>os', '<cmd>ObsidianSearch<cr>', desc = '[O]bsidian [s]earch' },
    --     unpack(keys),
    --   }
    -- end,
  },
}
