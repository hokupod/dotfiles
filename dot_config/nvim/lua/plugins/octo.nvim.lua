return {
  "pwntester/octo.nvim",
  cmd = "Octo",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "folke/snacks.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("octo").setup({
      picker = "snacks",
      -- GitHub CLI ツールを使って認証
      use_local_fs = false,

      -- SSH エイリアス設定（企業GitHubを使用する場合）
      ssh_aliases = {
        -- ["github.company.com"] = "github.com"
      },

      -- Projects v2 のスコープ警告を抑制（必要に応じて）
      suppress_missing_scope = {
        projects_v2 = true,
      },

      -- デフォルトのマージ方法
      default_merge_method = "squash",

      -- リアクション設定
      reaction_viewer_hint_icon = "",
      user_icon = " ",
      timeline_marker = "",
      timeline_indent = 2,

      -- マッピングのカスタマイズ（お好みで）
      mappings = {
        issue = {
          close_issue = { lhs = "<space>ic", desc = "close issue" },
          reopen_issue = { lhs = "<space>io", desc = "reopen issue" },
          list_issues = { lhs = "<space>il", desc = "list open issues" },
          reload = { lhs = "<C-r>", desc = "reload issue" },
          open_in_browser = { lhs = "<C-b>", desc = "open issue in browser" },
          copy_url = { lhs = "<C-y>", desc = "copy url to clipboard" },
          add_assignee = { lhs = "<space>aa", desc = "add assignee" },
          add_label = { lhs = "<space>la", desc = "add label" },
          add_comment = { lhs = "<space>ca", desc = "add comment" },
        },
        pull_request = {
          checkout_pr = { lhs = "<space>po", desc = "checkout PR" },
          merge_pr = { lhs = "<space>pm", desc = "merge PR" },
          list_commits = { lhs = "<space>pc", desc = "list PR commits" },
          list_changed_files = { lhs = "<space>pf", desc = "list PR changed files" },
          show_pr_diff = { lhs = "<space>pd", desc = "show PR diff" },
          add_reviewer = { lhs = "<space>va", desc = "add reviewer" },
          remove_reviewer = { lhs = "<space>vd", desc = "remove reviewer" },
        },
        review_thread = {
          add_comment = { lhs = "<space>ca", desc = "add comment" },
          add_suggestion = { lhs = "<space>sa", desc = "add suggestion" },
          delete_comment = { lhs = "<space>cd", desc = "delete comment" },
        },
      },
    })

    -- TreeSitter markdown パーサーを Octo バッファに適用
    -- PR の説明やコメントのシンタックスハイライトが改善される
    vim.treesitter.language.register("markdown", "octo")
  end,
  keys = {
    { "<leader>gh", "", desc = "+octo" },
    { "<leader>ghi", "<cmd>Octo issue list<CR>", desc = "List issues" },
    { "<leader>ghp", "<cmd>Octo pr list<CR>", desc = "List PRs" },
    { "<leader>ghr", "<cmd>Octo review start<CR>", desc = "Start review" },
    { "<leader>ghs", "<cmd>Octo search<CR>", desc = "Search" },
  },
}
