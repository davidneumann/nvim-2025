return {
  'ThePrimeagen/harpoon',
  config = function()
    require('telescope').load_extension 'harpoon'
  end,
  keys = function(_, keys)
    return {
      {
        '<leader>Ha',
        function()
          require('harpoon.mark').add_file()
        end,
        desc = '[H]arpoon [A]dd File',
      },
      {
        '<leader>Hr',
        function()
          require('harpoon.mark').remove_file()
        end,
        desc = '[H]arpoon [R]emove File',
      },
      { '<leader>Hs', '<cmd>Telescope harpoon marks<cr>', desc = '[H]arpoon [S]search' },
      { '<leader>sh', '<cmd>Telescope harpoon marks<cr>', desc = '[S]search [H]arpoon' },
      {
        '<leader>Hl',
        function()
          require('harpoon.ui').toggle_quick_menu()
        end,
        desc = '[H]arpoon [L]ist',
      },
      {
        '<leader>H1',
        function()
          require('harpoon.ui').nav_file(1)
        end,
        desc = '[H]arpoon Goto File [1]',
      },
      {
        '<leader>H2',
        function()
          require('harpoon.ui').nav_file(2)
        end,
        desc = '[H]arpoon Goto File [2]',
      },
      {
        '<leader>H3',
        function()
          require('harpoon.ui').nav_file(3)
        end,
        desc = '[H]arpoon Goto File [3]',
      },
      {
        '<leader>H4',
        function()
          require('harpoon.ui').nav_file(4)
        end,
        desc = '[H]arpoon Goto File [4]',
      },
      unpack(keys),
    }
  end,
}
