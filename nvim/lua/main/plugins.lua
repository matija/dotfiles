local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {

  -- new lsp
  -- LSP Support
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = false,
    config = false,
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
    }
  },
  -- Autocompletion and Snippets
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      { 'L3MON4D3/LuaSnip' }
    },
  },
  { 'saadparwaiz1/cmp_luasnip' },
  { "rafamadriz/friendly-snippets" },
  -- null ls none ls
  "nvimtools/none-ls.nvim",
  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = { "williamboman/mason.nvim", "nvimtools/none-ls.nvim" },
  },

  --  -- typescript
  --  {
  --    "pmizio/typescript-tools.nvim",
  --    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  --    opts = {},
  --  },
  --
  -- TREE
  -- 'nvim-tree/nvim-tree.lua',
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    }
  },
  'nvim-tree/nvim-web-devicons',

  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.2',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5 && cmake --build build --config=Release && cmake --install build' },
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',

  -- dap
  { "folke/neodev.nvim",                        opts = {} },
  'mfussenegger/nvim-dap',
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      require("neodev").setup({
        library = { plugins = { "nvim-dap-ui" }, types = true },
      })
    end
  },

  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies =
    'nvim-tree/nvim-web-devicons'
  },
  --utils
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
  },
  "moll/vim-bbye",

  -- comments
  'JoosepAlviste/nvim-ts-context-commentstring',
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
    end
  },

  -- colors
  {
    'deparr/tairiki.nvim',
    lazy = false,
    priority = 1000, -- only necessary if you use tairiki as default theme
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },

  { 'kepano/flexoki-neovim',            lazy = false,   priority = 1000, name = 'flexoki' },
  { 'rose-pine/neovim', lazy = false, priority = 1000, name = 'rose-pine' },

  -- ai
  {
    "alex35mil/pi.nvim",
    dependencies = { "HakonHarnes/img-clip.nvim" }, -- optional, clipboard image paste
    config = function()
      require("pi").setup({
        expand_startup_details = false, -- collapse the skills/extensions preamble; Tab expands it
      })
    end,
  },
}

local opts = {
  rocks = { enabled = false },
}

require("lazy").setup(plugins, opts)
