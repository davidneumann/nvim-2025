return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"adrigzr/neotest-mocha",
			"nvim-neotest/neotest-jest",
			"nvim-neotest/neotest-go",
		},
		config = function()
			local neotest_ns = vim.api.nvim_create_namespace("neotest")
			vim.diagnostic.config({
				virtual_text = {
					format = function(diagnostic)
						local message =
							diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
						return message
					end,
				},
			}, neotest_ns)

			require("neotest").setup({
				log_level = vim.log.levels.DEBUG,
				adapters = {
					require("neotest-go"),
					require("neotest-mocha")({
						command = "npm test --",
						command_args = function(context)
							-- The context contains:
							--   results_path: The file that json results are written to
							--   test_name_pattern: The generated pattern for the test
							--   path: The path to the test file
							--
							-- It should return a string array of arguments
							--
							-- Not specifying 'command_args' will use the defaults below
							print(
								vim.fn.stdpath("log"),
								"--full-trace",
								"--reporter=json",
								"--reporter-options output=" .. context.results_path,
								"--grep=" .. context.test_name_pattern,
								context.path
							)
							return {
								"--full-trace",
								"--reporter=json",
								"--reporter-options output=" .. context.results_path,
								"--grep=" .. context.test_name_pattern,
								context.path,
							}
						end,
					}),
					-- require("neotest-jest")({
					-- 	jestCommand = "npx jest --",
					-- 	jestConfigFile = "custom.jest.config.ts",
					-- 	env = { CI = true },
					-- 	cwd = function(path)
					-- 		return vim.fn.getcwd()
					-- 	end,
					-- 	strategy_config = function(default_strategy, _)
					-- 		default_strategy["resolveSourceMapLocations"] = {
					-- 			"${workspaceFolder}/**",
					-- 			"!**/node_modules/**",
					-- 		}
					-- 		return default_strategy
					-- 	end,
					-- }),
				},
			})
		end,
	},
}
