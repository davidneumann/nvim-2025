return {
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    version = false, -- Never set this value to "*"! Never!
    cond = function()
      return os.getenv 'NEOVIM_USE_AI' == 'true'
    end,
    opts = {
      -- add any opts here
      -- for example
      provider = 'gemini',
      -- provider = 'deepseek',
      -- auto_suggestions_provider = 'gemini',
      gemini = {
        endpoint = 'https://generativelanguage.googleapis.com/v1beta/models',
        model = 'gemini-2.0-flash',
        timeout = 60000, -- Timeout in milliseconds
        temperature = 0,
        max_tokens = 25000,
      },
      vendors = {
        deepseek = {
          __inherited_from = 'openai',
          endpoint = 'https://api.deepseek.com',
          model = 'deepseek-reasoner',
          api_key_name = 'DEEPSEEK_API_KEY',
          disable_tools = true,
          max_tokens = 2048,
          -- parse_curl_args = function(opts, code_opts)
          --   local providers = require 'avante.providers'
          --
          --   local utils = require 'avante.utils'
          --   local apiKey = utils.environment.parse(opts.api_key_name, opts._shellenv)
          --
          --   local headers = {
          --     ['Content-Type'] = 'application/json',
          --     ['x-api-key'] = apiKey,
          --   }
          --
          --   return {
          --     url = utils.url_join(opts.endpoint, '/chat/completions'),
          --     headers = headers,
          --     body = {
          --       model = opts.model,
          --       messages = providers.openai:parse_messages(code_opts),
          --       stream = true,
          --     },
          --   }
          -- end,
        },
      },
      dual_boost = {
        enabled = false,
        first_provider = 'deepseek',
        second_provider = 'gemini',
        prompt = 'Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]',
        timeout = 60000, -- Timeout in milliseconds
      },
      openai = {
        endpoint = 'https://api.openai.com/v1',
        model = 'gpt-4o', -- your desired model (or use gpt-4o, etc.)
        timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
        temperature = 0,
        max_tokens = 60000, -- Increase this to include reasoning tokens (for reasoning models)
        reasoning_effort = 'medium', -- low|medium|high, only used for reasoning models
      },
      hints = { enabled = false },
      behaviour = {
        enable_cursor_planning_mode = true, -- Whether to enable Cursor Planning Mode. Default to false.
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = 'make',
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      --- The below dependencies are optional,
      -- 'echasnovski/mini.pick', -- for file_selector provider mini.pick
      'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
      'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
      'ibhagwan/fzf-lua', -- for file_selector provider fzf
      'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
      'zbirenbaum/copilot.lua', -- for providers='copilot'
      {
        -- support for image pasting
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
  },
}
