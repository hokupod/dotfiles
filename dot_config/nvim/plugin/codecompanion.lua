require("codecompanion").setup({
  adapters = {
    chat = "anthropic",
    inline = "anthropic"
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

            return "I have the following code:\n\n```" .. context.filetype .. "\n" .. text .. "\n```\n\n"
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
            return "\n\n```" .. context.filetype .. "\n\n```\n\n"
          end,
        },
      },
    },
  },
})

local wk = require("which-key")
wk.register({
  a = {
    name = "AI",
    ["a"] = { "<cmd>CodeCompanionActions<cr>", "[AI] Code Companion Actions" },
    ["c"] = { "<cmd>CodeCompanionToggle<cr>", "[AI] Code Companion Toggle Chat" },
  },
}, {
  mode = "n",
  prefix = "<leader>",
})

wk.register({
  a = {
    name = "AI",
    ["a"] = { "<cmd>CodeCompanionActions<cr>", "[AI] Code Companion Actions" },
    ["c"] = { "<cmd>CodeCompanionToggle<cr>", "[AI] Code Companion Toggle Chat" },
  },
}, {
  mode = "v",
  prefix = "<leader>",
})
