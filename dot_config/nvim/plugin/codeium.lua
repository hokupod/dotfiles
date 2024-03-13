local cmp = require('cmp')
local codeium_fts = {
  "lua",
  "ruby",
  "php",
  "go",
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "svelte",
  "astro",
  "html",
  "css",
}
for _, ft in ipairs(codeium_fts) do
  cmp.setup.filetype(ft, {
    sources = {
      { name = "codeium" },
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      { name = 'nvim_lsp_signature_help' },
      { name = 'nvim_lua' },
    }, {
      { name = 'buffer' },
    },
  })
end

