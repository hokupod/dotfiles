local set = vim.keymap.set
local function show_documentation()
  local ft = vim.opt.filetype._value
  if ft == "vim" or ft == "help" then
    vim.cmd([[execute 'h ' . expand('<cword>') ]])
  else
    vim.cmd([[Lspsaga hover_doc]])
  end
end
local on_attach = function(client, bufnr)
  -- Keybind
  set("n", "K", show_documentation)
  set("n", "<F2>", "<cmd>Lspsaga rename<CR>")
  set("n", "<leader>=", "<cmd>Format<CR>")
  
  -- LSP mappings
  set("n", "<leader>l<F2>", "<cmd>Lspsaga rename<CR>", { desc = "Rename", buffer = bufnr })
  set("n", "<leader>lf", "<cmd>Lspsaga finder<CR>", { desc = "Finder", buffer = bufnr })
  set("n", "<leader>lgd", "<cmd>Lspsaga goto_definition<CR>", { desc = "Definition", buffer = bufnr })
  set("n", "<leader>lgi", "<cmd>Telescope lsp_implementations<CR>", { desc = "Implementations", buffer = bufnr })
  set("n", "<leader>lgt", "<cmd>Lspsaga goto_type_definition<CR>", { desc = "Type definition", buffer = bufnr })
  set("n", "<leader>lsd", "<cmd>Telescope diagnostics<CR>", { desc = "Telescope diagnostics", buffer = bufnr })
  set("n", "<leader>lsl", "<cmd>Lspsaga show_line_diagnostics<CR>", { desc = "Line diagnostics", buffer = bufnr })
  set("n", "<leader>lsc", require("actions-preview").code_actions, { desc = "Code action", buffer = bufnr })
  set("n", "<leader>lso", "<cmd>Lspsaga outline<CR>", { desc = "outline", buffer = bufnr })
  set("n", "<leader>lwa", "<cmd>vim.lsp.buf.add_workspace_folder<CR>", { desc = "Add workspace dir", buffer = bufnr })
  set("n", "<leader>lwr", "<cmd>vim.lsp.buf.remove_workspace_folder<CR>", { desc = "Remove workspace dir", buffer = bufnr })
  set("n", "<leader>lwl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", { desc = "List workspace dir", buffer = bufnr })
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
