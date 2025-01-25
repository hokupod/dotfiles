require("fidget").setup({})
require("aerial").setup({
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
    vim.keymap.set("n", "+", "<cmd>AerialToggle!<CR>", { buffer = bufnr })
  end,
})

local set = vim.keymap.set
local function show_documentation()
  local ft = vim.opt.filetype._value
  if ft == "vim" or ft == "help" then
    vim.cmd([[execute 'h ' . expand('<cword>') ]])
  else
    vim.cmd([[Lspsaga hover_doc]])
  end
end
local conform = require("conform")
local wk = require("which-key")
local on_attach = function(client, bufnr)
  -- Keybind
  set("n", "K", show_documentation)
  set("n", "<F2>", "<cmd>Lspsaga rename<CR>")

  wk.add({
    mode = { "n" },
    { "<leader>l", group = "LSP" },
    { "<leader>l<F2>", "<cmd>Lspsaga rename<CR>", desc = "Rename" },
    { "<leader>lf", "<cmd>Lspsaga finder<CR>", desc = "Finder" },

    { "<leader>lg", group = "+go" },
    { "<leader>lgd", "<cmd>Lspsaga goto_definition<CR>", desc = "Definition" },
    {
      "<leader>lgi",
      "<cmd>Telescope lsp_implementations<CR>",
      desc = "Implementations",
    },
    {
      "<leader>lgt",
      "<cmd>Lspsaga goto_type_definition<CR>",
      desc = "Type definition",
    },

    { "<leader>ls", group = "+show" },
    {
      "<leader>lsd",
      "<cmd>Telescope diagnostics<CR>",
      desc = "Telescope diagnostics",
    },
    {
      "<leader>lsl",
      "<cmd>Lspsaga show_line_diagnostics<CR>",
      desc = "Line diagnostics",
    },
    {
      "<leader>lsc",
      require("actions-preview").code_actions,
      desc = "Code action",
    },
    { "<leader>lso", "<cmd>Lspsaga outline<CR>", desc = "outline" },

    { "<leader>lw", group = "+workspace" },
    {
      "<leader>lwa",
      "<cmd>vim.lsp.buf.add_workspace_folder<CR>",
      desc = "Add workspace dir",
    },
    {
      "<leader>lwr",
      "<cmd>vim.lsp.buf.remove_workspace_folder<CR>",
      desc = "Remove workspace dir",
    },
    {
      "<leader>lwl",
      "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
      desc = "List workspace dir",
    },
  })

  local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function(args)
        conform.format({ bufnr = args.buf })
      end,
    })
  end
end

local mason = require("mason")
mason.setup()

require("mason-lspconfig").setup()
require("lspsaga").setup({
  outline = {
    layout = "float",
  },
  finder = {
    default = "tyd+ref+imp+def",
    methods = {
      tyd = "textDocument/typeDefinition",
    },
  },
})

-- Set up nvim-cmp.
local cmp = require("cmp")
local lspkind = require("lspkind")

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local kind_icons = {
  Text = "",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰇽",
  Variable = "󰂡",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "󰅲",
}

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-c>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({
      select = false,
    }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "copilot", group_index = 2 },
    { name = "nvim_lsp", group_index = 2 },
    { name = "vsnip", group_index = 2 }, -- For vsnip users.
    { name = "nvim_lsp_signature_help", group_index = 2 },
    { name = "nvim_lua", group_index = 2 },
  }, {
    { name = "buffer" },
  }),
  formatting = {
    fields = { "kind", "abbr", "menu" },
    expandable_indicator = true,
    format = lspkind.cmp_format({
      mode = "symbol",
      maxwidth = 50,
      ellipsis_char = "...",
      symbol_map = {
        Codeium = "",
        Copilot = "",
      },
      show_labelDetails = true,

      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      before = function(entry, vim_item)
        return vim_item
      end,
    }),
  },
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = "buffer" },
  }),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

-- Set up lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities()
require("mason-lspconfig").setup_handlers({
  function(server_name)
    require("lspconfig")[server_name].setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end,
})

local lspconfig = require("lspconfig")

local is_node_dir = function()
  return lspconfig.util.root_pattern("package.json")(vim.fn.getcwd())
end

lspconfig["ts_ls"].setup({
  root_dir = lspconfig.util.root_pattern("package.json"),
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)

    client.server_capabilities.document_formatting = false
    client.server_capabilities.documentRangeFormattingProvider = false

    if not is_node_dir() then
      client.stop(true)
    end
  end,
})

lspconfig["denols"].setup({
  root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
  init_options = {
    lint = true,
    unstable = true,
    suggest = {
      imports = {
        hosts = {
          ["https://deno.land"] = true,
          ["https://cdn.nest.land"] = true,
          ["https://crux.land"] = true,
        },
      },
    },
  },
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    if is_node_dir() then
      client.stop(true)
    end
  end,
})

-- formatter
local js_formatters = {
  {
    "biome",
    -- "prettierd",
    -- "prettier",
  },
}
conform.setup({
  formatters_by_ft = {
    lua = { "stylua" },
    html = js_formatters,
    css = js_formatters,
    json = js_formatters,
    yaml = js_formatters,
    javascript = js_formatters,
    typescript = js_formatters,
    javascriptreact = js_formatters,
    typescriptreact = js_formatters,
    astro = js_formatters,
    svelte = js_formatters,
    go = { "goimports" },
  },
})
wk.add({
  mode = { "n" },
  {
    "<leader>=",
    function()
      conform.format()
    end,
    desc = "Format",
  },
})

-- linter
local js_linters = {
  -- "eslint",
  "biomejs",
  -- "eslint_d",
}
local lint = require("lint")
local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

lint.linters_by_ft = {
  javascript = js_linters,
  typescript = js_linters,
  javascriptreact = js_linters,
  typescriptreact = js_linters,
  astro = js_linters,
  svelte = js_linters,
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  group = lint_augroup,
  callback = function()
    lint.try_lint(nil, {
      ignore_errors = true,
    })
  end,
})

lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        pathStrict = true,
        path = { "?.lua", "?/init.lua" },
      },
      workspace = {
        library = vim.list_extend(vim.api.nvim_get_runtime_file("lua", true), {
          "${3rd}/luv/library",
          -- "${3rd}/busted/library",
          -- "${3rd}/luassert/library",
        }),
        checkThirdParty = "Disable",
      },
    },
  },
})
