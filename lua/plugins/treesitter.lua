return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")

			vim.g.skip_ts_context_comment_string_module = true
			configs.setup({
				sync_install = false,
				ignore_install = {},
				-- Installs are done by home-manager
				ensure_installed = {},
				-- ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
				-- Autoinstall languages that are not installed
				auto_install = false,
				highlight = {
					enable = true,
					-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
					--  If you are experiencing weird indenting issues, add the language to
					--  the list of additional_vim_regex_highlighting and disabled languages for indent.
					additional_vim_regex_highlighting = { "ruby" },
				},
				-- indent = { enable = true, disable = { 'ruby' } },
				indent = { enable = true, disable = { "ruby", "typescript", "typescritreact" } },
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = {
			max_lines = 3,
		},
	},
}
