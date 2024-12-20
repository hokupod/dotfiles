require("codecompanion").setup({
  opts = {
    language = "Japanese",
  },
  display = {
    chat = {
      render_headers = false,
    },
  },
  strategies = {
    chat = {
      adapter = "copilot",
      slash_commands = {
        ["file"] = {
          opts = {
            -- ref: https://github.com/olimorris/codecompanion.nvim/discussions/276
            provider = "telescope",
          },
        },
      },
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
    ["Communicatable Message"] = {
      strategy = "inline",
      description = "Create Communicatable Message",
      opts = {
        placement = "replace",
        short_name = "cm",
        auto_submit = true,
        is_slash_cmd = true,
        is_default = true,
        adapter = {
          name = "anthropic",
        }
      },
      prompts = {
        {
          role = "system",
          content = function(context)
            return "You are a professional communication editor.\n"
              .. "Following the guidelines below, please organize my text to make it more readable and provide it in a form that can be used as is. Please output the final text in the same language as the message.\n"
              .. "\n"
              .. "If there are sentences where the subject is unclear, please place placeholders where the subject should be.\n"
              .. "\n"
              .. "1. Structure\n"
              .. "- One main topic per paragraph\n"
              .. "- Maintain logical flow\n"
              .. "- Use appropriate conjunctions\n"
              .. "\n"
              .. "2. Clarity\n"
              .. "- Use concise and direct expressions\n"
              .. "- Employ specific wording\n"
              .. "- Eliminate ambiguous expressions\n"
              .. "\n"
              .. "3. Readability\n"
              .. "- Proper placement of punctuation\n"
              .. "- Separate into paragraphs as needed\n"
              .. "- Use bullet points when appropriate\n"
              .. "\n"
              .. "4. Tone\n"
              .. "- Use appropriate honorifics and politeness according to the situation\n"
              .. "- Express positivity and forward-thinking\n"
              .. "- Maintain sincerity and consistency\n"
              .. "\n"
              .. "5. Conclusion\n"
              .. "- Clarify claims and key points\n"
              .. "- Provide action proposals or inquiries as necessary\n"
          end,
        },
        {
          role = "user",
          content = function(context)
            local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
            return "Based on the above guidelines, please organize the following text so that it can be used as is.\n"
              .. "```\n" .. text .. "```\n"
          end,
        },
      },
    },
    ["Git commit message in Japanese"] = {
      strategy = "inline",
      description = "Get commit message for git",
      opts = {
        placement = "add"
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

local M = require("lualine.component"):extend()

M.processing = false
M.spinner_index = 1

local spinner_symbols = {
  "⠋",
  "⠙",
  "⠹",
  "⠸",
  "⠼",
  "⠴",
  "⠦",
  "⠧",
  "⠇",
  "⠏",
}
local spinner_symbols_len = 10

-- Initializer
function M:init(options)
  M.super.init(self, options)

  local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequest*",
    group = group,
    callback = function(request)
      if request.match == "CodeCompanionRequestStarted" then
        self.processing = true
      elseif request.match == "CodeCompanionRequestFinished" then
        self.processing = false
      end
    end,
  })
end

-- Function that runs every time statusline is updated
function M:update_status()
  if self.processing then
    self.spinner_index = (self.spinner_index % spinner_symbols_len) + 1
    return spinner_symbols[self.spinner_index]
  else
    return nil
  end
end


local wk = require("which-key")
wk.add({
  {
    mode = { "n", "x" },
    { "<leader>a", group = "AI" },
    { "<leader>aa", "<cmd>CodeCompanionActions<cr>", desc = "[AI] Code Companion Actions" },
  },
  {
    mode = { "v" },
    { "<leader>a", group = "AI" },
    { "<leader>aa", "<cmd>CodeCompanionActions<cr>", desc = "[AI] Code Companion Actions" },
    { "<leader>ac", "<cmd>CodeCompanion /cm<cr>", desc = "[AI] Create Communicatable Message" },
  },
})
-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
vim.cmd([[cab ccc CodeCompanionChat]])
vim.cmd([[cab cmd CodeCompanionCmd]])
vim.cmd([[cab ccm CodeCompanion /cm]])
