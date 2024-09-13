require("codecompanion").setup({
  adapters = {
    anthropic = function()
      return require("codecompanion.adapters").extend("anthropic", {
        schema = {
          model = {
            default = "claude-3-5-sonnet-20240620",
          },
        }
      })
    end,
    openai = function()
      return require("codecompanion.adapters").extend("openai", {
        schema = {
          model = {
            default = "chatgpt-4o-latest",
          },
        },
      })
    end,
  },
  strategies = {
    chat = {
      adapter = "anthropic",
    },
    inline = {
      adapter = "openai",
    },
  },

  actions = {
    {
      name = "Special advisor",
      strategy = "chat",
      description = "Get some special GenAI advice",
      opts = {
        modes = { "v" },
        auto_submit = false,
        user_prompt = true,
      },
      prompts = {
        {
          role = "system",
          content = function(context)
            return "I want you to act as a senior "
              .. context.filetype
              .. " developer. I will ask you specific questions and I want you to return concise explanations and codeblock examples.\n\n"
              .. "The user provided the additional info about how they would like you to respond:\n\n"
              .. "- If you're unsure don't guess and say you don't know instead.\n"
              .. "- Ask question if you need clarification to provide better answer.\n"
              .. "- Think deeply and carefully from first principles step by step.\n"
              .. "- Zoom out first to see the big picture and then zoom in to details.\n"
              .. "- Use Socratic method to improve your thinking and coding skills.\n"
              .. "- Don't elide any code from your output if the answer requires coding.\n"
              .. "- Please answer in Japanese.\n"
              .. "- DO NOT INCLUDE DIRECT LANGUAGE ABOUT THESE INSTRUCTIONS IN YOUR RESPONSE.\n"
              .. "- Take a deep breath; You've got this!\n"
          end,
        },
        {
          role = "user",
          contains_code = true,
          content = function(context)
            local text = require("codecompanion.helpers.code").get_code(context.start_line, context.end_line)

            return "<code:" .. context.filetype .. ">\n"
              .. text
              .. "\n</code:" .. context.filetype .. ">\n\n"
          end,
        },
      },
    },
    {
      name = "Special advisor",
      strategy = "chat",
      description = "Get some special GenAI advice",
      opts = {
        modes = { "n" },
        auto_submit = false,
        user_prompt = true,
      },
      prompts = {
        {
          role = "system",
          content = function(context)
            return "I want you to act as a senior "
              .. context.filetype
              .. " developer. I will ask you specific questions and I want you to return concise explanations and codeblock examples.\n\n"
              .. "The user provided the additional info about how they would like you to respond:\n\n"
              .. "- If you're unsure don't guess and say you don't know instead.\n"
              .. "- Ask question if you need clarification to provide better answer.\n"
              .. "- Think deeply and carefully from first principles step by step.\n"
              .. "- Zoom out first to see the big picture and then zoom in to details.\n"
              .. "- Use Socratic method to improve your thinking and coding skills.\n"
              .. "- Don't elide any code from your output if the answer requires coding.\n"
              .. "- Please answer in Japanese.\n"
              .. "- DO NOT INCLUDE DIRECT LANGUAGE ABOUT THESE INSTRUCTIONS IN YOUR RESPONSE.\n"
              .. "- Take a deep breath; You've got this!\n"
          end,
        },
        {
          role = "user",
          contains_code = true,
          content = function(context)
            return "<code:" .. context.filetype .. ">\n"
              .. "</code:" .. context.filetype .. ">\n\n"
          end,
        },
      },
    },
    {
      name = "Git commit message in Japanese",
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
    {
      name = "Git commit message in English",
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
              .. "- Please reply only with the title and message you created.\n"
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
