return {
	{
		'nvim-treesitter/nvim-treesitter',
		lazy = false,
		build = ':TSUpdate',
		config = function()
			-- Enable treesitter highlighting for common languages
			vim.api.nvim_create_autocmd('FileType', {
				pattern = {
					'go', 'lua', 'vim', 'vimdoc', 'bash', 'c', 'cpp',
					'javascript', 'typescript', 'typescriptreact', 'jsx',
					'python', 'rust', 'html', 'css', 'json', 'yaml',
					'markdown', 'markdown_inline', 'toml', 'sql',
					'query', 'diff', 'regex', 'proto', 'dockerfile',
				},
				callback = function()
					vim.treesitter.start()
				end,
			})

			-- Enable treesitter-based indentation
			vim.api.nvim_create_autocmd('FileType', {
				pattern = {
					'go', 'lua', 'c', 'cpp', 'javascript', 'typescript',
					'typescriptreact', 'python', 'rust', 'html', 'css',
					'json', 'yaml', 'toml', 'proto', 'dockerfile',
				},
				callback = function()
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
	{
		'nvim-treesitter/nvim-treesitter-context',
		opts = {
			max_lines = 3,
		},
	},
}
