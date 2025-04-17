local js_based_languages = {
  'typescript',
  'javascript',
  'typescriptreact',
  'javascriptreact',
  'vue',
}

return {
  {
    'mfussenegger/nvim-dap',
    recommended = true,
    desc = 'Debugging support. Requires language specific adapters to be configured. (see lang extras)',

    dependencies = {
      'rcarriga/nvim-dap-ui',
      -- virtual text for the debugger
      {
        'theHamsta/nvim-dap-virtual-text',
        opts = {},
      },
    },

    -- stylua: ignore
    keys = {
      { "<leader>DB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>Db", function() require("dap").toggle_breakpoint() end,                                    desc = "Toggle Breakpoint" },
      { "<leader>Dc", function() require("dap").continue() end,                                             desc = "Run/Continue" },
      { "<leader>Da", function() require("dap").continue({ before = get_args }) end,                        desc = "Run with Args" },
      { "<leader>DC", function() require("dap").run_to_cursor() end,                                        desc = "Run to Cursor" },
      { "<leader>Dg", function() require("dap").goto_() end,                                                desc = "Go to Line (No Execute)" },
      { "<leader>Di", function() require("dap").step_into() end,                                            desc = "Step Into" },
      { "<leader>Dj", function() require("dap").down() end,                                                 desc = "Down" },
      { "<leader>Dk", function() require("dap").up() end,                                                   desc = "Up" },
      { "<leader>Dl", function() require("dap").run_last() end,                                             desc = "Run Last" },
      { "<leader>DO", function() require("dap").step_out() end,                                             desc = "Step Out" },
      { "<leader>Do", function() require("dap").step_over() end,                                            desc = "Step Over" },
      { "<leader>DP", function() require("dap").pause() end,                                                desc = "Pause" },
      { "<leader>Dr", function() require("dap").repl.toggle() end,                                          desc = "Toggle REPL" },
      { "<leader>Ds", function() require("dap").session() end,                                              desc = "Session" },
      { "<leader>DT", function() require("dap").terminate() end,                                            desc = "Terminate" },
      { "<leader>Dw", function() require("dap.ui.widgets").hover() end,                                     desc = "Widgets" },
      { '[d',         vim.diagnostic.goto_prev,                                                             desc = 'Go to previous diagnostic message' },
      { ']d',         vim.diagnostic.goto_next,                                                             desc = 'Go to next diagnostic message' },
      { '<leader>Dm', vim.diagnostic.open_float,                                                            desc = 'Open floating diagnostic message' },
      { '<leader>DL', vim.diagnostic.setloclist,                                                            desc = 'Open diagnostics list' },
    },

    config = function()
      vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })
    end,
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'nvim-neotest/nvim-nio' },
    -- stylua: ignore
    keys = {
      { "<leader>Dt", function() require("dapui").toggle({}) end, desc = "Dap UI toggle" },
      { "<leader>De", function() require("dapui").eval() end,     desc = "Eval",  mode = { "n", "v" } },
    },
    opts = {
      render = {
        indent = 1,
        max_value_lines = 2,
      },
    },
    config = function(_, opts)
      local dap = require 'dap'
      dap.set_log_level 'TRACE'
      local dapui = require 'dapui'
      dapui.setup(opts)
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open {}
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close {}
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close {}
      end

      dap.adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'js-debug',
          args = { '${port}' },
        },
      }
      dap.adapters['node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'js-debug',
          args = { '${port}' },
        },
      }
      dap.adapters['node-terminal'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'js-debug',
          args = { '${port}' },
        },
      }

      for _, language in ipairs(js_based_languages) do
        dap.configurations[language] = {
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch file',
            program = '${file}',
            cwd = '${workspaceFolder}',
          },
          {
            type = 'pwa-node',
            request = 'attach',
            name = 'Attach',
            processId = require('dap.utils').pick_process,
            cwd = '${workspaceFolder}',
          },
          {
            type = 'pwa-node',
            request = 'launch',
            name = '[node] Launch dev tsx',
            -- program = '${file}',
            runtimeExecutable = 'npx',
            rootPath = '${workspaceFolder}',
            cwd = '${workspaceFolder}',
            -- rootPath = vim.fn.getcwd(),
            -- cwd = vim.fn.getcwd(),
            -- args = { 'ts-node-dev', '--', '--transpile-only', '--require ', './src/server.ts' },
            -- args = { "${file}" },
            runtimeArgs = { 'ts-node-dev', '--transpile-only', '--require', 'dotenv/config', '${file}' },
            sourceMaps = true,
            protocol = 'inspector',
            console = 'integratedTerminal',
            outFiles = { '${workspaceFolder}/dist/**/*.js' },
            skipFiles = { '${workspaceFolder}/node_modules/**/*.js', '<node_internals>/**' },
            resolveSourceMapLocations = {
              '${workspaceFolder}/**',
              '!**/node_modules/**',
            },
          },
          {
            type = 'pwa-node',
            request = 'launch',
            name = '[node] Launch npm run dev',
            -- program = '${file}',
            runtimeExecutable = 'npm',
            rootPath = '${workspaceFolder}',
            cwd = '${workspaceFolder}',
            -- rootPath = vim.fn.getcwd(),
            -- cwd = vim.fn.getcwd(),
            -- args = { 'ts-node-dev', '--', '--transpile-only', '--require ', './src/server.ts' },
            -- args = { "${file}" },
            runtimeArgs = { 'run', 'dev', '--inspect' },
            sourceMaps = true,
            protocol = 'inspector',
            console = 'integratedTerminal',
            outFiles = { '${workspaceFolder}/dist/**/*.js' },
            skipFiles = { '${workspaceFolder}/node_modules/**/*.js', '<node_internals>/**' },
            resolveSourceMapLocations = {
              '${workspaceFolder}/**',
              '!**/node_modules/**',
            },
          },
          -- {
          --   type = 'pwa-node',
          --   request = 'launch',
          --   name = '[node] Next.js FULLER stack',
          --   -- program = '${file}',
          --   runtimeExecutable = '${workspaceFolder}/node_modules/.bin/next',
          --   rootPath = '${workspaceFolder}',
          --   cwd = '${workspaceFolder}',
          --   -- rootPath = vim.fn.getcwd(),
          --   -- cwd = vim.fn.getcwd(),
          --   -- args = { 'ts-node-dev', '--', '--transpile-only', '--require ', './src/server.ts' },
          --   -- args = { "${file}" },
          --   runtimeArgs = {},
          --   sourceMaps = true,
          --   protocol = 'inspector',
          --   console = 'integratedTerminal',
          --   outFiles = { '${workspaceFolder}/dist/**/*.js' },
          --   skipFiles = { '${workspaceFolder}/node_modules/**/*.js', '<node_internals>/**' },
          --   resolveSourceMapLocations = {
          --     '${workspaceFolder}/**',
          --     '!**/node_modules/**',
          --   },
          -- },
          {
            type = 'pwa-node',
            request = 'launch',
            name = '[node] NPM Launch dev start',
            -- program = '${file}',
            runtimeExecutable = 'npm',
            rootPath = '${workspaceFolder}',
            cwd = '${workspaceFolder}',
            -- rootPath = vim.fn.getcwd(),
            -- cwd = vim.fn.getcwd(),
            -- args = { 'ts-node-dev', '--', '--transpile-only', '--require ', './src/server.ts' },
            -- args = { "${file}" },
            runtimeArgs = { 'run', 'start' },
            sourceMaps = true,
            protocol = 'inspector',
            console = 'integratedTerminal',
            outFiles = { '${workspaceFolder}/dist/**/*.js' },
            skipFiles = { '${workspaceFolder}/node_modules/**/*.js', '<node_internals>/**' },
            resolveSourceMapLocations = {
              '${workspaceFolder}/**',
              '!**/node_modules/**',
            },
          },
        }
      end
    end,
  },
}
