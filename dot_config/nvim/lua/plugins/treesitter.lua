return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-context",
    "windwp/nvim-ts-autotag",
  },
  config = function()
    local ensure_installed = {
      "lua", "vim", "vimdoc", "javascript", "typescript", "astro",
      "svelte", "html", "ruby", "go", "zig", "markdown", "markdown_inline", "yaml"
    }

    local to_install = {}
    for _, lang in ipairs(ensure_installed) do
      if vim.fn.empty(vim.fn.globpath(vim.o.rtp, "parser/" .. lang .. ".*")) == 1 then
        table.insert(to_install, lang)
      end
    end
    if #to_install > 0 then
      require("nvim-treesitter").install(to_install)
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter_highlight", { clear = true }),
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end,
    })
  end,
}
