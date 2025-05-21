---@type vim.lsp.Config
return {
  root_markers = { "package.json" },
  -- filetypes = filetypes,
  workspace_required = true,
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
    'astro',
    'svelte',
  },
}
