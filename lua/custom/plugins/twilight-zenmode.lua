local focusToggle = false

return {
  {
    'folke/twilight.nvim',
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  {
    'folke/zen-mode.nvim',
    opts = { plugins = { tmux = { enabled = true }, twilight = { enabled = false } } },
    keys = function(_, keys)
      return {
        { '<leader>uZ', '<cmd>ZenMode<cr>', desc = '[U]I Toggle [Z]enMode' },
        { '<leader>uT', '<cmd>Twilight<cr>', desc = '[U]I Toggle [T]wilight' },
        {
          '<leader>uF',
          function()
            focusToggle = not focusToggle
            if focusToggle then
              require('zen-mode').open {
                window = {
                  width = 0.85, -- width will be 85% of the editor width
                },
              }
              vim.cmd 'TwilightEnable'
            else
              require('zen-mode').close {
                window = {
                  width = 0.85, -- width will be 85% of the editor width
                },
              }
              vim.cmd 'TwilightDisable'
            end
          end,
          desc = '[U]I Toggle [F]ocus with ZenMode & Twlight',
        },
        unpack(keys),
      }
    end,
  },
}
