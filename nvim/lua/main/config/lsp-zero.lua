local lsp_zero = require('lsp-zero')

require('mason').setup({})

require('mason-lspconfig').setup({
  ensure_installed = {},
  handlers = {
    lsp_zero.default_setup,
  },
})

lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps({ buffer = bufnr })
end)


vim.lsp.config("lua_ls", {})
vim.lsp.enable("ts_ls")
vim.lsp.config("ts_ls",  {
  filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact" },
  cmd = { "typescript-language-server", "--stdio" },
  settings = {
    implicitProjectConfiguration = {
      checkJs = true,
    },
  },
})
-- vim.lsp.config("vtsls", {
--   settings = {
--     vtsls = { tsserver = { globalPlugins = {} } },
--     typescript = { preferences = { includePackageJsonAutoImports = "auto" } },
--   }})

vim.diagnostic.config({ virtual_text = false })

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})
