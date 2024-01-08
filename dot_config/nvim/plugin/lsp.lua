local set = vim.keymap.set
local function show_documentation()
  local ft = vim.opt.filetype._value
  if ft == 'vim' or ft == 'help' then
    vim.cmd([[execute 'h ' . expand('<cword>') ]])
  else
    vim.cmd([[Lspsaga hover_doc]])
  end
end
local on_attach = function(client, bufnr)
  -- Keybind
  set("n", "K", show_documentation)
  set("n", "<F2>", "<cmd>Lspsaga rename<CR>")

  local wk = require("which-key")
  wk.register({
    l = {
      name = "LSP",
      ["="] = { "<cmd>lua vim.lsp.buf.format()<CR>", "[LSP] Format" },
      ["<F2>"] = { "<cmd>Lspsaga rename<CR>", "[LSP] Rename" },
      g = {
        name = "+go",
        d = { "<cmd>Lspsaga lsp_finder<CR>", "[LSP] Definition" },
        i = { "<cmd>Telescope lsp_implementations<CR>", "[LSP] Implementations" },
        t = { "<cmd>Lspsaga goto_type_definition<CR>", "[LSP] Type definition" },
        n = { "<cmd>Lspsaga diagnostic_jump_next<CR>", "[LSP] Diagnostics next" },
        p = { "<cmd>Lspsaga diagnostic_jump_prev<CR>", "[LSP] Diagnostics prev" },
      },
      s = {
        name = "+show",
        d = { "<cmd>Telescope diagnostics<CR>", "[LSP] Telescope diagnostics" },
        l = { "<cmd>Lspsaga show_line_diagnostics<CR>", "[LSP] Line diagnostics" },
        c = { "<cmd>Lspsaga code_action<CR>", "[LSP] Code action" },
        o = { "<cmd>Lspsaga outline<CR>", "[LSP] outline" },
      },
      w = {
        name = "+workspace",
        a = { "<cmd>vim.lsp.buf.add_workspace_folder<CR>", "[LSP] Add workspace dir" },
        r = { "<cmd>vim.lsp.buf.remove_workspace_folder<CR>", "[LSP] Remove workspace dir" },
        l = { "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", "[LSP] List workspace dir" },
      }
    },
  }, {
      mode = "n",
      prefix = "<leader>",
  })
end

local mason = require('mason')
local mason_null_ls = require('mason-null-ls')
local null_ls = require('null-ls')

mason.setup()
mason_null_ls.setup({
  ensure_installed = { 'prettier', 'dprint', 'goimports' },
  automatic_installation = true,
  automatic_setup = true,
})
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.dprint.with {
      condition = function(utils)
        return utils.has_file { "dprint.json", }
      end,
      extra_filetypes = { "svelte", },
    },
    null_ls.builtins.formatting.prettier.with {
      condition = function(utils)
        return utils.has_file { ".prettierrc", ".prettierrc.js", ".prettierrc.yaml" }
      end,
      prefer_local = "node_modules/.bin",
      extra_filetypes = { "svelte", },
    },
    null_ls.builtins.diagnostics.eslint.with {
      condition = function(utils)
        return utils.has_file { ".eslintrc.cjs", }
      end,
      prefer_local = "node_modules/.bin",
      extra_filetypes = { "svelte" },
    },
    null_ls.builtins.formatting.goimports,
  },
})

require("mason-lspconfig").setup()
require('lspsaga').setup({
  outline = {
    layout = 'float',
  },
})
-- Set up nvim-cmp.
local cmp = require('cmp')
local lspkind = require('lspkind')

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-c>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({
      select = false,
    }),
  }),
  sources = cmp.config.sources({
    { name = 'codeium' },
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
    { name = 'nvim_lsp_signature_help' },
    { name = 'nvim_lua' },
  }, {
    { name = 'buffer' },
  }),

  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol', -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
      symbol_map = { Codeium = "", },

      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      -- before = function (entry, vim_item)
      --   ...
      --   return vim_item
      -- end
    })
  },
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' },
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'cmdline' },
  })
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require("mason-lspconfig").setup_handlers {
  function (server_name)
    require("lspconfig")[server_name].setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end,
}

