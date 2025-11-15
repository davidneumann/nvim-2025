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
        opts = {
          display_callback = function(variable)
            if #variable.value > 15 then
              return ' ' .. variable.value:sub(1, 15) .. '...'
            end
            return ' ' .. variable.value
          end,
        },
      },
    },

    -- stylua: ignore
    keys = {
      -- { "<leader>DB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      {
        "<leader>DB",
        function()
          require('config.lib.dap').set_conditional_breakpoint()
        end,
        desc = "Breakpoint Condition"
      },
      -- { "<leader>Db", function() require("dap").toggle_breakpoint() end,                                    desc = "Toggle Breakpoint" },
      {
        "<leader>Db",
        function()
          require('config.lib.dap').toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint"
      },
      {
        "<leader>DX",
        function()
          require('config.lib.dap').clear_breakpoints()
        end,
        desc = "Clear all breakpoints"
      },
      { "<leader>Dc", function() require("dap").continue() end,                      desc = "Run/Continue" },
      { "<leader>Da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
      { "<leader>DC", function() require("dap").run_to_cursor() end,                 desc = "Run to Cursor" },
      { "<leader>Dg", function() require("dap").goto_() end,                         desc = "Go to Line (No Execute)" },
      { "<leader>Di", function() require("dap").step_into() end,                     desc = "Step Into" },
      { "<leader>Dj", function() require("dap").down() end,                          desc = "Down" },
      { "<leader>Dk", function() require("dap").up() end,                            desc = "Up" },
      { "<leader>Dl", function() require("dap").run_last() end,                      desc = "Run Last" },
      { "<leader>DO", function() require("dap").step_out() end,                      desc = "Step Out" },
      { "<leader>Do", function() require("dap").step_over() end,                     desc = "Step Over" },
      { "<F10>",      function() require("dap").step_over() end,                     desc = "Step Over" },
      { "<leader>DP", function() require("dap").pause() end,                         desc = "Pause" },
      { "<leader>Dr", function() require("dap").repl.toggle() end,                   desc = "Toggle REPL" },
      { "<leader>Ds", function() require("dap").session() end,                       desc = "Session" },
      { "<leader>DT", function() require("dap").terminate({ all = true }) end,       desc = "Terminate" },
      { "<leader>Dw", function() require("dap.ui.widgets").hover() end,              desc = "Widgets" },
      { '[d',         vim.diagnostic.goto_prev,                                      desc = 'Go to previous diagnostic message' },
      { ']d',         vim.diagnostic.goto_next,                                      desc = 'Go to next diagnostic message' },
      { '<leader>Dm', vim.diagnostic.open_float,                                     desc = 'Open floating diagnostic message' },
      { '<leader>DL', vim.diagnostic.setloclist,                                     desc = 'Open diagnostics list' },
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
      { "<leader>Du", function() require("dapui").toggle({}) end, desc = "Dap UI toggle" },
      { "<leader>De", function() require("dapui").eval() end,     desc = "Eval",         mode = { "n", "v" } },
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

      -- dap.adapters.delve = function(callback, config)
      --   if config.mode == 'remote' and config.request == 'attach' then
      --     callback {
      --       type = 'server',
      --       host = config.host or '127.0.0.1',
      --       port = config.port or '38697',
      --     }
      --   else
      --     callback {
      --       type = 'server',
      --       port = '${port}',
      --       executable = {
      --         command = 'dlv',
      --         args = { 'dap', '-l', '127.0.0.1:${port}', '--log', '--log-output=dap' },
      --         detached = vim.fn.has 'win32' == 0,
      --       },
      --     }
      --   end
      -- end
      --
      -- -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
      -- dap.configurations.go = {
      --   {
      --     type = 'delve',
      --     name = 'Debug ./main.go',
      --     request = 'launch',
      --     program = '${workspaceFolder}/main.go',
      --   },
      --   {
      --     type = 'delve',
      --     name = 'Debug test', -- configuration for debugging test files
      --     request = 'launch',
      --     mode = 'test',
      --     program = '${file}',
      --   },
      --   -- works with go.mod packages and sub packages
      --   {
      --     type = 'delve',
      --     name = 'Debug test (go.mod)',
      --     request = 'launch',
      --     mode = 'test',
      --     program = './${relativeFileDirname}',
      --   },
      -- }

      dap.adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'js-debug-adapter',
          args = { '${port}' },
        },
      }
      dap.adapters['node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'js-debug-adapter',
          args = { '${port}' },
        },
      }
      dap.adapters['node-terminal'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'js-debug-adapter',
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
            name = '[node] Launch file tsx',
            -- program = '${file}',
            runtimeExecutable = 'npx',
            rootPath = '${workspaceFolder}',
            cwd = '${workspaceFolder}',
            -- rootPath = vim.fn.getcwd(),
            -- cwd = vim.fn.getcwd(),
            -- args = { 'ts-node-dev', '--', '--transpile-only', '--require ', './src/server.ts' },
            -- args = { "${file}" },
            runtimeArgs = { 'tsx', '--env-file=.env', '${file}' },
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
            -- skipFiles = { '${workspaceFolder}/node_modules/**/*.js', '<node_internals>/**' },
            resolveSourceMapLocations = {
              '${workspaceFolder}/**',
              '!**/node_modules/**',
            },
          },
          {
            type = 'pwa-node',
            request = 'launch',
            name = '[node] Launch npm run develop',
            -- program = '${file}',
            runtimeExecutable = 'npm',
            rootPath = '${workspaceFolder}',
            cwd = '${workspaceFolder}',
            -- rootPath = vim.fn.getcwd(),
            -- cwd = vim.fn.getcwd(),
            -- args = { 'ts-node-dev', '--', '--transpile-only', '--require ', './src/server.ts' },
            -- args = { "${file}" },
            runtimeArgs = { 'run', 'develop', '--inspect' },
            sourceMaps = true,
            protocol = 'inspector',
            console = 'integratedTerminal',
            outFiles = { '${workspaceFolder}/dist/**/*.js' },
            -- skipFiles = { '${workspaceFolder}/node_modules/**/*.js', '<node_internals>/**' },
            -- skipFiles = {},
            resolveSourceMapLocations = {
              '${workspaceFolder}/**',
              '!**/node_modules/**',
            },
          },
          {
            type = 'pwa-node',
            request = 'launch',
            name = '[node] Launch npm run test',
            -- program = '${file}',
            runtimeExecutable = 'npm',
            rootPath = '${workspaceFolder}',
            cwd = '${workspaceFolder}',
            -- rootPath = vim.fn.getcwd(),
            -- cwd = vim.fn.getcwd(),
            -- args = { 'ts-node-dev', '--', '--transpile-only', '--require ', './src/server.ts' },
            -- args = { "${file}" },
            runtimeArgs = { 'run', 'test', '--inspect' },
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
  {
    'leoluz/nvim-dap-go',
    opts = {},
  },
}
