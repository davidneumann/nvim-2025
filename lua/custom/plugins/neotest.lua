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
            cwd = function(path)
              return vim.fn.getcwd()
            end,
          },
        },
      }
    end,
  },
}
