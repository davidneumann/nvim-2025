return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'adrigzr/neotest-mocha',
    },
    config = function()
      require('neotest').setup {
        adapters = {
          require 'neotest-mocha' {
            command = 'npm test --',
            command_args = function(context)
              -- The context contains:
              --   results_path: The file that json results are written to
              --   test_name_pattern: The generated pattern for the test
              --   path: The path to the test file
              --
              -- It should return a string array of arguments
              --
              -- Not specifying 'command_args' will use the defaults below
              return {
                '--full-trace',
                '--reporter=json',
                '--reporter-options=output=' .. context.results_path,
                '--grep=' .. context.test_name_pattern,
                context.path,
              }
            end,
            env = { CI = true },
            cwd = function(_)
              return vim.fn.getcwd()
            end,
          },
        },
      }
    end,
    keys = function(_, keys)
      return {
        { '<leader>Ts', '<cmd>Neotest summary<cr>', desc = '[T]est [s]ummary' },
        {
          '<leader>Tc',
          function()
            require('neotest').run.run { strategy = 'dap' }
          end,
          desc = '[T]est [c]losest',
        },
        {
          '<leader>Tf',
          function()
            require('neotest').run.run(vim.fn.expand '%')
          end,
          desc = '[T]est all in [f]ile',
        },
        {
          '<leader>Tl',
          function()
            require('neotest').run.run_last { strategy = 'dap' }
          end,
          desc = '[T]est run [l]ast',
        },
        {
          '<leader>TS',
          function()
            require('neotest').run.stop()
          end,
          desc = '[T]est [S]stop!',
        },
        { '<leader>T', group = '[T]ests' },
        { '<leader>Tw', group = '[T]ests [w]atch' },
        {
          '<leader>Twt',
          function()
            require('neotest').watch.toggle()
          end,
          desc = '[T]est watch [t]oggle',
        },
        {
          '<leader>Tws',
          function()
            require('neotest').watch.stop()
          end,
          desc = '[T]est watch [s]top',
        },
        unpack(keys),
      }
    end,
  },
}
