return {
  {
    'nvim-pack/nvim-spectre',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    keys = function(_, keys)
      return {
        {
          '<leader>sS',
          function()
            require('spectre').toggle()
          end,
          desc = 'Toggle Spectre',
        },
        unpack(keys),
      }
    end,
  },
}
