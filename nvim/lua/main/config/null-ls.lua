local null_ls = require("null-ls")

require("mason-null-ls").setup({
  ensure_installed = { "prettierd" },
  automatic_installation = true,
})

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettierd,
  },
})
