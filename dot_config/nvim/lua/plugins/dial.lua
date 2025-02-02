return {
  "monaqa/dial.nvim",
  dependencies = {},
  config = function()
    -- dial.nvim
    local augend = require("dial.augend")
    local baseAugends = {
      augend.integer.alias.decimal, -- nonnegative decimal number (0, 1, 2, 3, ...)
      augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
      augend.date.alias["%Y/%m/%d"],
      augend.date.alias["%Y-%m-%d"],
      augend.date.alias["%m/%d"],
      augend.date.alias["%H:%M"],
      augend.constant.alias.ja_weekday,
      augend.constant.alias.ja_weekday_full,
      augend.constant.alias.bool,
    }
    local mergeAugents = function(tbl)
      local merged = {}
      for k, v in pairs(baseAugends) do
        merged[k] = v
      end
      for k, v in pairs(tbl) do
        merged[k] = v
      end
      return merged
    end
    require("dial.config").augends:register_group({
      default = baseAugends,
      javascript = mergeAugents({
        augend.constant.new({ elements = { "let", "const" } }),
      }),
    })

    vim.cmd([[
    " 複数のファイルタイプで同じ設定を有効にする
    autocmd FileType typescript,typescriptreact,javascript,javascriptreact,astro,svelte lua vim.api.nvim_buf_set_keymap(0, "n", "<C-a>", require("dial.map").inc_normal("javascript"), {noremap = true})
    autocmd FileType typescript,typescriptreact,javascript,javascriptreact,astro,svelte lua vim.api.nvim_buf_set_keymap(0, "n", "<C-x>", require("dial.map").dec_normal("javascript"), {noremap = true})
    ]])

    vim.keymap.set("n", "<C-a>", function()
      require("dial.map").manipulate("increment", "normal")
    end)
    vim.keymap.set("n", "<C-x>", function()
      require("dial.map").manipulate("decrement", "normal")
    end)
    vim.keymap.set("n", "g<C-a>", function()
      require("dial.map").manipulate("increment", "gnormal")
    end)
    vim.keymap.set("n", "g<C-x>", function()
      require("dial.map").manipulate("decrement", "gnormal")
    end)
    vim.keymap.set("v", "<C-a>", function()
      require("dial.map").manipulate("increment", "visual")
    end)
    vim.keymap.set("v", "<C-x>", function()
      require("dial.map").manipulate("decrement", "visual")
    end)
    vim.keymap.set("v", "g<C-a>", function()
      require("dial.map").manipulate("increment", "gvisual")
    end)
    vim.keymap.set("v", "g<C-x>", function()
      require("dial.map").manipulate("decrement", "gvisual")
    end)
  end,
}

