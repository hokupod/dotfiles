local actionlint = require("efmls-configs.linters.actionlint")
local biome = require("efmls-configs.formatters.biome")
local deno_fmt = require("efmls-configs.formatters.deno_fmt")
local goimports = require("efmls-configs.formatters.goimports")
local jq = require("efmls-configs.formatters.jq")
local prettier = require("efmls-configs.formatters.prettier")
local stylua = require("efmls-configs.formatters.stylua")

local on_attach = require("lsp-format").on_attach

return {
  init_options = {
    documentFormatting = true,
    documentRangeFormatting = true,
    codeAction = true,
  },
  on_attach = on_attach,
  settings = {
    languages = {
      lua = { stylua },
      go = { goimports },
      javascript = { prettier },
      astro = { biome },
      json = { jq },
      javascriptreact = { prettier },
      svelte = { prettier, biome },
      typescript = { prettier, deno_fmt },
      typescriptreact = { prettier, deno_fmt },
      yaml = { actionlint },
    },
  },
}
