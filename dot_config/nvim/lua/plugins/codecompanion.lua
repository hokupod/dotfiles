return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
    "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
    { "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves vim.ui.select
    { "echasnovski/mini.diff", version = "*" },
    "nvim-lualine/lualine.nvim",
    "j-hui/fidget.nvim",
  },
  config = function()
    local constants = {
      LLM_ROLE = "llm",
      USER_ROLE = "user",
      SYSTEM_ROLE = "system",
    }

    local config = require("codecompanion.config")
    require("codecompanion").setup({
      init = function()
        require("plugins.codecompanion.fidget-spinner"):init()
        require("plugins.codecompanion.lualine-spinner"):init()
      end,
      opts = {
        language = "Japanese",
      },
      display = {
        chat = {
          render_headers = false,
        },
        diff = {
          enabled = true,
          close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
          layout = "vertical", -- vertical|horizontal split for default provider
          opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
          provider = "mini_diff", -- default|mini_diff
        },
      },
      strategies = {
        chat = {
          adapter = "copilot",
          slash_commands = {
            ["file"] = {
              opts = {
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
        openai = function()
          return require("codecompanion.adapters").extend("openai", {
            schema = {
              model = {
                default = "o3-mini",
              },
              reasoning_effort = {
                default = "high",
              },
            },
          })
        end,
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = {
                default = "o3-mini",
              },
              reasoning_effort = {
                default = "high",
              },
            },
          })
        end,
        open_router = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            name = "open_router",
            env = {
              url = "https://openrouter.ai/api",
              api_key = function()
                return os.getenv("OPENROUTER_API_KEY")
              end,
            },
            schema = {
              model = {},
            },
          })
        end,
      },
      prompt_library = {
        ["Multi Translate"] = {
          strategy = "chat",
          description = "Create Translated Text",
          opts = {
            short_name = "tr",
            auto_submit = true,
            is_slash_cmd = true,
            is_default = true,
            adapter = {
              name = "openai",
              model = "o3-mini",
              reasoning_effort = "low",
            },
          },
          prompts = {
            {
              role = constants.SYSTEM_ROLE,
              content = function(context)
                local lang = config.opts.language or "Japanese"
                return "You are a bilingual translation expert specialized in "
                  .. lang
                  .. "-English translation.\n"
                  .. "Your primary tasks are:\n"
                  .. "- Automatically detect the input language\n"
                  .. "- Translate "
                  .. lang
                  .. " to English or other languages to "
                  .. lang
                  .. "\n"
                  .. "- Maintain high accuracy and natural expression in both languages\n"
                  .. "- Preserve the original tone and context\n"
                  .. "- Add cultural explanations when necessary\n"
                  .. "- If the input text is too large, do multiple exchanges and translate the full text.\n"
                  .. "- If the input text is too large, split it into smaller sections and translate each section entirely.\n"
                  .. "\n"
                  .. "Translation Format Guidelines:\n"
                  .. "\n"
                  .. "1. Language Detection and Translation Header\n"
                  .. "[ {Source Language} → {Target Language} Translation ]\n"
                  .. "\n"
                  .. "2. Translation Sections\n"
                  .. "[ Section Title or Thematic Segment ]\n"
                  .. "{Complete translated text for this section}\n"
                  .. "\n"
                  .. "3. Continuation for Large Texts\n"
                  .. "- Split text into logical sections\n"
                  .. "- Translate each section fully\n"
                  .. "- Maintain overall context and tone\n"
                  .. "- Use clear, professional language\n"
                  .. "- Preserve original formatting and structure\n"
                  .. "\n"
                  .. "4. Additional Notes\n"
                  .. "- Include cultural explanations if necessary\n"
                  .. "- Maintain the original text's professional tone\n"
                  .. "- Ensure high accuracy and natural expression\n"
                  .. "\n"
                  .. "Example Implementation:\n"
                  .. "```\n"
                  .. "[ English → Japanese Translation ]\n"
                  .. "[ Company Overview ]\n"
                  .. "{Japanese translation of the company overview section}\n"
                  .. "\n"
                  .. "[ Product Description ]\n"
                  .. "{Japanese translation of the product description section}\n"
                  .. "{... (repeat for each segment as necessary)}\n"
                  .. "```\n"
                  .. "You must adhere to these instructions exactly.\n"
              end,
              opts = {
                visible = false,
              },
            },
            {
              role = constants.USER_ROLE,
              content = function(context)
                local lang = config.opts.language or "Japanese"
                local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                return "Please translate the following text.\n"
                  .. "\n"
                  .. "Requirements:\n"
                  .. "- If "
                  .. lang
                  .. " input: Translate to natural, professional English\n"
                  .. "- If non-"
                  .. lang
                  .. " input: Translate to natural, professional "
                  .. lang
                  .. "\n"
                  .. "- Preserve all details and context\n"
                  .. "- Add line breaks for readability\n"
                  .. "- If the text is too large, split it and translate each section fully\n"
                  .. "\n"
                  .. "Text to translate:\n"
                  .. "```\n"
                  .. text
                  .. "```\n"
              end,
              opts = {
                auto_submit = true,
                visible = false,
              },
            },
          },
        },
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
              name = "openai",
              model = "o3-mini",
              reasoning_effort = "low",
            },
          },
          prompts = {
            {
              role = constants.SYSTEM_ROLE,
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
              role = constants.USER_ROLE,
              content = function(context)
                local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                return "Based on the above guidelines, please organize the following text so that it can be used as is.\n"
                  .. "```\n"
                  .. text
                  .. "```\n"
              end,
            },
          },
        },
        ["Git commit message in Japanese"] = {
          strategy = "inline",
          description = "Get commit message for git",
          opts = {
            placement = "add",
          },
          prompts = {
            {
              role = constants.SYSTEM_ROLE,
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
              role = constants.USER_ROLE,
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

    vim.cmd([[cab cc CodeCompanion]])
    vim.cmd([[cab ccc CodeCompanionChat]])
    vim.cmd([[cab cmd CodeCompanionCmd]])
    vim.cmd([[cab ccm CodeCompanion /cm]])
    vim.cmd([[cab cct CodeCompanion /tr]])
  end,
}
