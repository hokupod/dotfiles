local set = vim.keymap.set
local function show_documentation()
  local ft = vim.opt.filetype._value
  if ft == "vim" or ft == "help" then
    vim.cmd([[execute 'h ' . expand('<cword>') ]])
  else
    vim.cmd([[Lspsaga hover_doc]])
  end
end
local wk = require("which-key")
local on_attach = function(client, bufnr)
  -- Keybind
  set("n", "K", show_documentation)
  set("n", "<F2>", "<cmd>Lspsaga rename<CR>")
  set("n", "<leader>=", "<cmd>Format<CR>")

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
end

local mason = require("mason")
mason.setup({
  ensure_installed = {
    "lua_ls",
    "efm",
    "denols",
    "ts_ls",
  },
})

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

-- Set up lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities()
vim.lsp.config("*", {
  on_attach = on_attach,
  capabilities = capabilities,
})

require("mason-lspconfig").setup()
