return {
  'danymat/neogen',
  config = true,
  -- Uncomment next line if you want to follow only stable versions
  -- version = "*"
  keys = function(_, keys)
    return {
      {
        '<leader>cd',
        function()
          require('neogen').generate()
        end,
        desc = '[c]ode [d]ocument generate',
      },
      unpack(keys),
    }
  end,
}
