return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("diffview").setup({
      diff_binaries = false,
      enhanced_diff_hl = false,
      git_cmd = { "git" },
      hg_cmd = { "hg" },
      use_icons = true,
      show_help_hints = true,
      watch_index = true,

      -- ファイルパネルの設定
      file_panel = {
        listing_style = "tree",
        tree_options = {
          flatten_dirs = true,
          folder_statuses = "only_folded",
        },
        win_config = {
          position = "left",
          width = 35,
          win_opts = {},
        },
      },

      -- ファイル履歴パネルの設定
      file_history_panel = {
        log_options = {
          git = {
            single_file = {
              diff_merges = "combined",
            },
            multi_file = {
              diff_merges = "first-parent",
            },
          },
        },
        win_config = {
          position = "bottom",
          height = 16,
        },
      },

      -- キーマッピング
      keymaps = {
        disable_defaults = false,
        view = {
          { "n", "<tab>", "<cmd>DiffviewToggleFiles<CR>", { desc = "Toggle file panel" } },
          { "n", "gf", "<cmd>DiffviewToggleFiles<CR>", { desc = "Toggle file panel" } },
          { "n", "<leader>e", "<cmd>DiffviewToggleFiles<CR>", { desc = "Toggle file panel" } },
          { "n", "<leader>co", "<cmd>DiffviewConflictChooseOurs<CR>", { desc = "Choose ours" } },
          { "n", "<leader>ct", "<cmd>DiffviewConflictChooseTheirs<CR>", { desc = "Choose theirs" } },
          { "n", "<leader>cb", "<cmd>DiffviewConflictChooseBoth<CR>", { desc = "Choose both" } },
          { "n", "<leader>cn", "<cmd>DiffviewConflictChooseNone<CR>", { desc = "Choose none" } },
        },
        file_panel = {
          { "n", "j", "<cmd>lua require('diffview.actions').next_entry()<CR>", { desc = "Next entry" } },
          { "n", "k", "<cmd>lua require('diffview.actions').prev_entry()<CR>", { desc = "Previous entry" } },
          { "n", "<cr>", "<cmd>lua require('diffview.actions').select_entry()<CR>", { desc = "Select entry" } },
          { "n", "o", "<cmd>lua require('diffview.actions').select_entry()<CR>", { desc = "Select entry" } },
          {
            "n",
            "<2-LeftMouse>",
            "<cmd>lua require('diffview.actions').select_entry()<CR>",
            { desc = "Select entry" },
          },
          {
            "n",
            "s",
            "<cmd>lua require('diffview.actions').toggle_stage_entry()<CR>",
            { desc = "Stage / unstage" },
          },
          { "n", "S", "<cmd>lua require('diffview.actions').stage_all()<CR>", { desc = "Stage all" } },
          { "n", "U", "<cmd>lua require('diffview.actions').unstage_all()<CR>", { desc = "Unstage all" } },
          { "n", "R", "<cmd>lua require('diffview.actions').refresh_files()<CR>", { desc = "Refresh" } },
          { "n", "L", "<cmd>lua require('diffview.actions').open_commit_log()<CR>", { desc = "Commit log" } },
          { "n", "<tab>", "<cmd>lua require('diffview.actions').select_next_entry()<CR>", { desc = "Next file" } },
          {
            "n",
            "<s-tab>",
            "<cmd>lua require('diffview.actions').select_prev_entry()<CR>",
            { desc = "Previous file" },
          },
          { "n", "gf", "<cmd>lua require('diffview.actions').goto_file()<CR>", { desc = "Go to file" } },
          {
            "n",
            "<C-w>gf",
            "<cmd>lua require('diffview.actions').goto_file_split()<CR>",
            { desc = "Go to file (split)" },
          },
          {
            "n",
            "i",
            "<cmd>lua require('diffview.actions').listing_style()<CR>",
            { desc = "Toggle listing style" },
          },
          {
            "n",
            "f",
            "<cmd>lua require('diffview.actions').toggle_flatten_dirs()<CR>",
            { desc = "Toggle flatten" },
          },
        },
      },
    })
  end,
  keys = {
    {
      "<leader>gdv",
      function()
        if next(require("diffview.lib").views) == nil then
          vim.cmd("DiffviewOpen")
        else
          vim.cmd("DiffviewClose")
        end
      end,
      desc = "Toggle Diffview",
    },
    { "<leader>gdh", "<cmd>DiffviewFileHistory<CR>", desc = "File history" },
    { "<leader>gdf", "<cmd>DiffviewFileHistory %<CR>", desc = "Current file history" },
  },
}
