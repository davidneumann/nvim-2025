-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',

    -- Breakpoints between sessions
    'Weissle/persistent-breakpoints.nvim',

    -- Text values of vars during breakpoints
    'theHamsta/nvim-dap-virtual-text',
  },
  keys = function(_, keys)
    local dap = require 'dap'
    local dapui = require 'dapui'
    return {
      -- Basic debugging keymaps, feel free to change to your liking!
      { '<F5>', dap.continue, desc = 'Debug: Start/Continue' },
      { '<F11>', dap.step_into, desc = 'Debug: Step Into' },
      { '<F10>', dap.step_over, desc = 'Debug: Step Over' },
      { 'S-<F11>', dap.step_out, desc = 'Debug: Step Out' },
      { '<leader>b', require('persistent-breakpoints.api').toggle_breakpoint, desc = 'Debug: Toggle Breakpoint' },
      {
        '<leader>B',
        require('persistent-breakpoints.api').set_conditional_breakpoint,
        -- function()
        --   dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        -- end,
        desc = 'Debug: Set Breakpoint',
      },
      { '<leader>Dc', require('persistent-breakpoints.api').clear_all_breakpoints, desc = 'Clear all breakpoints' },
      { '<leader>Dl', require('persistent-breakpoints.api').set_log_point, desc = 'Set log point' },
      -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
      { '<F7>', dapui.toggle, desc = 'Debug: See last session result.' },
      unpack(keys),
    }
  end,
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
        'js',
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }

    dap.adapters['pwa-node'] = {
      type = 'server',
      host = 'localhost',
      port = '${port}',
      executable = {
        command = vim.fn.exepath 'js-debug-adapter',
        args = { '${port}' },
      },
      rootPath = '${workspaceFolder}',
      cwd = '${workspaceFolder}',
    }

    for _, language in ipairs { 'typescript', 'javascript' } do
      dap.configurations[language] = {
        {
          type = 'pwa-node',
          request = 'launch',
          name = '[node] Launch file',
          -- program = '${file}',
          cwd = '${workspaceFolder}',
          args = { '${file}' },
          -- runtimeExecutable = "npm",
          runtimeArgs = { '-r', 'ts-node/register' },
          sourceMaps = true,
          protocol = 'inspector',
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = '[node] Launch dev',
          -- program = '${file}',
          runtimeExecutable = 'npm',
          rootPath = '${workspaceFolder}',
          cwd = '${workspaceFolder}',
          args = { 'run', 'develop' },
          -- runtimeArgs = { '-r', 'ts-node/register' },
          sourceMaps = true,
          protocol = 'inspector',
          console = 'integratedTerminal',
          outFiles = { '${workspaceFolder}/dist/**/*.js' },
          skipFiles = { '${workspaceFolder}/node_modules/**/*.js', '<node_internals>/**' },
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
          args = { 'src/server.ts' },
          runtimeArgs = { 'ts-node-dev', '--transpile-only', '--require', 'dotenv/config' },
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
          request = 'attach',
          name = '[node] Attach',
          processId = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Debug Jest Tests',
          -- trace = true, -- include debugger info
          runtimeExecutable = 'node',
          runtimeArgs = {
            './node_modules/jest/bin/jest.js',
            '--runInBand',
          },
          rootPath = '${workspaceFolder}',
          cwd = '${workspaceFolder}',
          console = 'integratedTerminal',
          internalConsoleOptions = 'neverOpen',
        },
      }
    end

    -- -- Attempt to load vscode launch.json but I think this isn't suppose to be here
    -- require('dap.ext.vscode').load_launchjs()

    -- Persistent breakpoints
    require('persistent-breakpoints').setup {
      load_breakpoints_event = { 'BufReadPost' },
    }

    require('nvim-dap-virtual-text').setup()
  end,
}
