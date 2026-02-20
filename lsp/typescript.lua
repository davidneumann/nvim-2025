vim.lsp.config('ts_ls', {
  cmd = { 'ts_ls' },
  filetypes = { 'typescript' },
  root_markers = { 'tsconfig.json', 'package.json', '.git' },
})
