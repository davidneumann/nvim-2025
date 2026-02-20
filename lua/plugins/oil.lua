return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      columns = { 'icons', 'permissions', 'size', 'mtime', 'time' },
      keymaps = {
        ['<C-h>'] = false,
        ['<M-h>'] = 'actions.select_split',
        ['<leader>Y'] = 'actions.copy_to_system_clipboard',
      },
      view_options = {
        show_hidden = true,
      },
      float = {
        border = 'single',
      },
    },
    -- Optional dependencies
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,

    keys = {
      {
        '<leader>-',
        function()
          require('oil').toggle_float()
        end,
        desc = 'Oil: Open parent directory',
      },
    },
    -- We do this here so the oil command desc still shows up under search -> keymaps
    init = function()
      local wk = require 'which-key'
      wk.add {
        '<leader>-',
        desc = 'which_key_ignore',
      }
    end,
  },
}
