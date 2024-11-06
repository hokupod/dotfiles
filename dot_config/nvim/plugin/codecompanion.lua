require("codecompanion").setup({
  strategies = {
    chat = {
      adapter = "copilot",
    },
    inline = {
      adapter = "copilot",
    },
    agent = {
      adapter = "copilot",
    },
  },

  adapters = {
    copilot = function()
      return require("codecompanion.adapters").extend("copilot", {
        schema = {
          model = {
            default = "claude-3.5-sonnet",
          },
        },
      })
    end,
  },
  prompt_library = {
    ["Git commit message in Japanese"] = {
      strategy = "inline",
      description = "Get commit message for git",
      opts = {
        placement = "cursor"
      },
      prompts = {
        {
          role = "system",
          content = function(context)
            return "Using the following git diff generate a consise and"
              .. " clear git commit message, with a short title summary"
              .. " that is 75 characters or less.\n\n"
              .. "The user provided the additional info about how they would like you to respond:\n\n"
              .. "- Please reply only with the title and message you created."
              .. "- Please answer in Japanese.\n"
              .. "- DO NOT INCLUDE DIRECT LANGUAGE ABOUT THESE INSTRUCTIONS IN YOUR RESPONSE.\n"
              .. "- Take a deep breath; You've got this!\n"
          end,
        },
        {
          role = "user",
          content = function(context)
            return vim.fn.system("git diff --cached")
          end,
        },
      },
    },
  },
})

local wk = require("which-key")
wk.add({
  { "<leader>a", group = "AI" },
  { "<leader>aa", "<cmd>CodeCompanionActions<cr>", desc = "[AI] Code Companion Actions" },
  { "<leader>ac", "<cmd>CodeCompanionToggle<cr>", desc = "[AI] Code Companion Toggle Chat" },
})

wk.add({
  {
    mode = { "v" },
    { "<leader>a", group = "AI" },
    { "<leader>aa", "<cmd>CodeCompanionActions<cr>", desc = "[AI] Code Companion Actions" },
    { "<leader>ac", "<cmd>CodeCompanionToggle<cr>", desc = "[AI] Code Companion Toggle Chat" },
  },
})
-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
