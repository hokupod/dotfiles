return {
    "andrewferrier/debugprint.nvim",
    opts = {
        keymaps = {
            normal = {
                plain_below = "gpp",
                plain_above = "gpP",
                variable_below = "gpv",
                variable_above = "gpV",
                variable_below_alwaysprompt = "",
                variable_above_alwaysprompt = "",
                textobj_below = "gpo",
                textobj_above = "gpO",
                toggle_comment_debug_prints = "",
                delete_debug_prints = "",
            },
            insert = {
                plain = "<C-G>p",
                variable = "<C-G>v",
            },
            visual = {
                variable_below = "gpv",
                variable_above = "gpV",
            },
        },
        commands = {
            toggle_comment_debug_prints = "ToggleCommentDebugPrints",
            delete_debug_prints = "DeleteDebugPrints",
            reset_debug_prints_counter = "ResetDebugPrintsCounter",
        },
    },
    dependencies = {
        "echasnovski/mini.nvim" -- Needed for :ToggleCommentDebugPrints(NeoVim 0.9 only)
                                -- and line highlighting (optional)
    },
    lazy = false, -- Required to make line highlighting work before debugprint is first used
    version = "*", -- Remove if you DON'T want to use the stable version
}
