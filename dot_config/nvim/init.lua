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
  "rmagatti/auto-session",
  "folke/which-key.nvim",
  "folke/neodev.nvim",
  "sainnhe/everforest",
  "lewis6991/gitsigns.nvim",
  "machakann/vim-sandwich",
  "glidenote/memolist.vim",
  "mattn/vim-findroot",
  'cohama/lexima.vim',
  'tpope/vim-commentary',
  'kevinhwang91/nvim-bqf',
  {
    'yamatsum/nvim-cursorline',
    config = function()
      require('nvim-cursorline').setup {
        cursorline = {
          enable = true,
          timeout = 1000,
          number = false,
        },
        cursorword = {
          enable = true,
          min_length = 3,
          hl = { underline = true },
        }
      }
    end
  },
  { "asiryk/auto-hlsearch.nvim", tag = "1.1.0" },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', opt = true }
  },
  {
    'smoka7/hop.nvim',
    version = "*",
    opts = {},
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
  {
    'nvimdev/lspsaga.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
  },
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

  -- Obsidian
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  -- ChatGPT
  {
    "Bryley/neoai.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    cmd = {
      "NeoAI",
      "NeoAIOpen",
      "NeoAIClose",
      "NeoAIToggle",
      "NeoAIContext",
      "NeoAIContextOpen",
      "NeoAIContextClose",
      "NeoAIInject",
      "NeoAIInjectCode",
      "NeoAIInjectContext",
      "NeoAIInjectContextCode",
    },
    keys = {
      { "<leader>as", desc = "summarize text" },
      { "<leader>ag", desc = "generate git message" },
    },
    config = function()
      require("neoai").setup({
        models = {
          {
            name = "openai",
            model = "gpt-4-1106-preview",
            params = nil,
          },
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup()
    end
  },
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.4',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  'nvim-telescope/telescope-ghq.nvim',
  'nvim-telescope/telescope-z.nvim',
  {
    "https://github.com/atusy/treemonkey.nvim",
    init = function()
      vim.keymap.set({"x", "o"}, "m", function()
        require("treemonkey").select({ ignore_injections = false })
      end)
    end
  },
})

require('base')
