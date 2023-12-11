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

-- vim.g.mapleader = " "
require("lazy").setup({
  "folke/which-key.nvim",
  "folke/neodev.nvim",
  "sainnhe/everforest",
  "lewis6991/gitsigns.nvim",
  "machakann/vim-sandwich",
  { "asiryk/auto-hlsearch.nvim", tag = "1.1.0" },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', opt = true }
  },
  -- Terminal
  {'akinsho/toggleterm.nvim', version = "*", config = true},
  -- LSP
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "nvimtools/none-ls.nvim",
  "jayp0521/mason-null-ls.nvim",
  "neovim/nvim-lspconfig",
  "onsails/lspkind.nvim",
  "nvimdev/lspsaga.nvim",
  -- Code complete
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/cmp-nvim-lsp-signature-help',
  'hrsh7th/cmp-nvim-lua',
  'hrsh7th/nvim-cmp',
  'ray-x/cmp-treesitter',
  -- Snippet
  'hrsh7th/cmp-vsnip',
  'hrsh7th/vim-vsnip',

  -- ChatGPT
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
      require("chatgpt").setup({
        api_key_cmd = "op read op://Personal/ChatGPT.nvim/password --no-newline",
        openai_params = {
          model = "gpt-4-1106-preview"
        },
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    }
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })()
    end,
  },
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.4',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  'nvim-telescope/telescope-ghq.nvim',
  'nvim-telescope/telescope-z.nvim',
})

require('base')
