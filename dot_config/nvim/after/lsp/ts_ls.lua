---@type vim.lsp.Config
return {
  root_markers = { "package.json" },
  workspace_required = true,
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
}
