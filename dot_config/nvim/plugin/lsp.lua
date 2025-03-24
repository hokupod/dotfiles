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


local lspconfig = require("lspconfig")

local is_node_dir = function()
  return lspconfig.util.root_pattern("package.json")(vim.fn.getcwd())
end

lspconfig["ruby_lsp"].setup({
  cmd = { "ruby-lsp" },
  filetypes = { "ruby" },
  root_dir = lspconfig.util.root_pattern("Gemfile", ".git"),
  on_attach = on_attach,
})

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

-- Set up lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities()
require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers({
    function(server_name)
      require("lspconfig")[server_name].setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
    end,
  })
