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
    },
  })
end

