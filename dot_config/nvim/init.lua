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
  "glidenote/memolist.vim",
  {
    'renerocksai/telekasten.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' }
  },
  "mattn/vim-findroot",
  'cohama/lexima.vim',
  'monaqa/dial.nvim',
  'monaqa/modesearch.vim',
  'tpope/vim-commentary',
  'kevinhwang91/nvim-bqf',
  'lambdalisue/fern.vim',
  {
    "karb94/neoscroll.nvim",
    config = function()
      require('neoscroll').setup {}
    end
  },
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
  {
    "asiryk/auto-hlsearch.nvim",
    tag = "1.1.0",
    config = function()
      require("auto-hlsearch").setup()
    end
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', opt = true }
  },
  {
    'smoka7/hop.nvim',
    version = "*",
    opts = {},
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
  -- Syntax Highlighting
  'sheerun/vim-polyglot',
  'wuelnerdotexe/vim-astro',
  'evanleck/vim-svelte',
  'leafOfTree/vim-svelte-plugin',
  -- Terminal
  { 'akinsho/toggleterm.nvim', version = "*", config = true },
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
  "j-hui/fidget.nvim",
  -- Code complete
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/cmp-nvim-lsp-signature-help',
  'hrsh7th/cmp-nvim-lua',
  'hrsh7th/nvim-cmp',
  'ray-x/cmp-treesitter',
  'petertriho/cmp-git',
  {
    'Exafunction/codeium.nvim',
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("codeium").setup({
      })
    end,
  },
  -- Snippet
  'hrsh7th/cmp-vsnip',
  'hrsh7th/vim-vsnip',
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
            model = "gpt-4-0125-preview",
            params = nil,
          },
        },
      })
    end,
  },
  "robitx/gp.nvim",
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
    'nvim-telescope/telescope.nvim',
    tag = '0.1.4',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  'nvim-telescope/telescope-ghq.nvim',
  'nvim-telescope/telescope-z.nvim',
  {
    "https://github.com/atusy/treemonkey.nvim",
    init = function()
      vim.keymap.set({ "x", "o" }, "m", function()
        require("treemonkey").select({ ignore_injections = false })
      end)
    end
  },
})

require('base')
