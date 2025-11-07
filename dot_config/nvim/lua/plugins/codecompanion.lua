return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "windwp/nvim-ts-autotag",
    "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
    { "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves vim.ui.select
    { "echasnovski/mini.diff", version = "*" },
    "folke/snacks.nvim",
    "nvim-lualine/lualine.nvim",
    "j-hui/fidget.nvim",
    "folke/snacks.nvim",
    "ravitemer/mcphub.nvim",
    "ravitemer/codecompanion-history.nvim",
  },
  keys = {
    { "<leader>aa", "<cmd>CodeCompanionActions<cr>", desc = "[AI] Code Companion Actions", mode = { "n", "x" } },
    { "<leader>ac", "<cmd>CodeCompanion /cm<cr>", desc = "[AI] Create Communicatable Message", mode = "v" },
  },
  cmd = {
    "CodeCompanion",
    "CodeCompanionChat",
    "CodeCompanionCmd",
    "CodeCompanionActions",
  },
  config = function()
    local constants = {
      LLM_ROLE = "llm",
      USER_ROLE = "user",
      SYSTEM_ROLE = "system",
    }

    local config = require("codecompanion.config")
    require("codecompanion").setup({
      opts = {
        language = "Japanese",
        log_level = "DEBUG",
      },
      display = {
        chat = {
          render_headers = false,
          show_header_separator = true,
        },
        diff = {
          enabled = true,
          close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
          layout = "vertical", -- vertical|horizontal split for default provider
          opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
          provider = "mini_diff", -- default|mini_diff
        },
      },
      extensions = {
        vectorcode = {
          ---@type VectorCode.CodeCompanion.ExtensionOpts
          opts = {
            tool_group = {
              enabled = true,
              collapse = true,
              -- tools in this array will be included to the `vectorcode_toolbox` tool group
              extras = {},
            },
            tool_opts = {
              ---@type VectorCode.CodeCompanion.LsToolOpts
              ls = {},
              ---@type VectorCode.CodeCompanion.QueryToolOpts
              query = {},
              ---@type VectorCode.CodeCompanion.VectoriseToolOpts
              vectorise = {},
            },
          },
        },
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            show_result_in_chat = true, -- Show the mcp tool result in the chat buffer
            make_vars = true, -- make chat #variables from MCP server resources
            make_slash_commands = true, -- make /slash_commands from MCP server prompts
          },
        },
        history = {
          enabled = true,
          opts = {
            -- Keymap to open history from chat buffer (default: gh)
            keymap = "gh",
            -- Keymap to save the current chat manually (when auto_save is disabled)
            save_chat_keymap = "sc",
            -- Save all chats by default (disable to save only manually using 'sc')
            auto_save = true,
            -- Number of days after which chats are automatically deleted (0 to disable)
            expiration_days = 0,
            -- Picker interface ("telescope" or "snacks" or "fzf-lua" or "default")
            picker = "telescope",
            ---Automatically generate titles for new chats
            auto_generate_title = true,
            title_generation_opts = {
              ---Adapter for generating titles (defaults to active chat's adapter)
              adapter = nil, -- e.g "copilot"
              ---Model for generating titles (defaults to active chat's model)
              model = nil, -- e.g "gpt-4o"
            },
            ---On exiting and entering neovim, loads the last chat on opening chat
            continue_last_chat = false,
            ---When chat is cleared with `gx` delete the chat from history
            delete_on_clearing_chat = false,
            ---Directory path to save the chats
            dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
            ---Enable detailed logging for history extension
            enable_logging = false,
          },
        },
      },
      strategies = {
        chat = {
          adapter = "open_router",
          slash_commands = {
            ["file"] = {
              opts = {
                provider = "snacks",
              },
            },
          },
        },
        inline = {
          adapter = "gemini_cli",
          keymaps = {
            accept_change = {
              modes = { n = "ga" },
              description = "Accept the suggested change",
            },
            reject_change = {
              modes = { n = "gr" },
              description = "Reject the suggested change",
            },
          },
        },
        agent = {
          adapter = "gemini_cli",
        },
      },

      adapters = {
        http = {
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
          gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
              schema = {
                model = {
                  default = "gemini-2.5-flash-preview-04-17",
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
                model = {
                  default = "anthropic/claude-sonnet-4.5",
                },
              },
              body = {
                provider = {
                  order = {
                    "anthropic",
                  },
                },
              },
            })
          end,
        },
        acp = {
          gemini_cli = function()
            return require("codecompanion.adapters").extend("gemini_cli", {
              commands = {
                flash = {
                  "gemini",
                  "--experimental-acp",
                  "-m",
                  "gemini-2.5-flash",
                },
                pro = {
                  "gemini",
                  "--experimental-acp",
                  "-m",
                  "gemini-2.5-pro",
                },
              },
              defaults = {
                -- auth_method = "gemini-api-key", -- "oauth-personal" | "gemini-api-key" | "vertex-ai"
                auth_method = "oauth-personal",
                -- auth_method = "vertex-ai",
              },
            })
          end,
        },
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
          -- strategy = "chat",
          description = "Create Communicatable Message",
          opts = {
            placement = "replace",
            -- placement = "new",
            short_name = "cm",
            auto_submit = true,
            is_slash_cmd = true,
            is_default = true,
            adapter = {
              name = "anthropic",
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
    local TagConfigs = require("nvim-ts-autotag.config.init")
    TagConfigs:add_alias("codecompanion", "markdown")
  end,
  init = function()
    -- require("plugins.codecompanion.fidget-spinner"):init()
    require("plugins.codecompanion.lualine-spinner"):init()
    require("plugins.codecompanion.snacks-spinner"):setup()


    vim.cmd([[cab cc CodeCompanion]])
    vim.cmd([[cab ccc CodeCompanionChat]])
    vim.cmd([[cab cmd CodeCompanionCmd]])
    vim.cmd([[cab ccm CodeCompanion /cm]])
    vim.cmd([[cab cct CodeCompanion /tr]])
  end,
}
