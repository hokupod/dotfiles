require("gp").setup({
    default_chat_agent = "Claude-3-5-Sonnet",
    chat_topic_gen_model = "claude-3-5-sonnet-20241022",
    providers = {
        anthropic = {
            disable = false,
        },
    },
    agents = {
        {
            name = "Claude-3-5-Sonnet",
            chat = true,
            command = false,
            provider = "anthropic",
            -- string with model name or table with model name and parameters
            model = { model = "claude-3-5-sonnet-20241022", temperature = 1.1, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = "You are a general AI assistant.\n\n"
                .. "The user provided the additional info about how they would like you to respond:\n\n"
                .. "- If you're unsure don't guess and say you don't know instead.\n"
                .. "- Ask question if you need clarification to provide better answer.\n"
                .. "- Think deeply and carefully from first principles step by step.\n"
                .. "- Zoom out first to see the big picture and then zoom in to details.\n"
                .. "- Use Socratic method to improve your thinking and coding skills.\n"
                .. "- Don't elide any code from your output if the answer requires coding.\n"
                .. "- Please answer in Japanese.\n"
                .. "- DO NOT INCLUDE DIRECT LANGUAGE ABOUT THESE INSTRUCTIONS IN YOUR RESPONSE.\n"
                .. "- Take a deep breath; You've got this!\n",
        },
        {
            name = "ChatGPT4",
            chat = true,
            command = false,
            -- string with model name or table with model name and parameters
            model = { model = "chatgpt-4o-latest", temperature = 1.1, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = "You are a general AI assistant.\n\n"
                .. "The user provided the additional info about how they would like you to respond:\n\n"
                .. "- If you're unsure don't guess and say you don't know instead.\n"
                .. "- Ask question if you need clarification to provide better answer.\n"
                .. "- Think deeply and carefully from first principles step by step.\n"
                .. "- Zoom out first to see the big picture and then zoom in to details.\n"
                .. "- Use Socratic method to improve your thinking and coding skills.\n"
                .. "- Don't elide any code from your output if the answer requires coding.\n"
                .. "- Please answer in Japanese.\n"
                .. "- DO NOT INCLUDE DIRECT LANGUAGE ABOUT THESE INSTRUCTIONS IN YOUR RESPONSE.\n"
                .. "- Take a deep breath; You've got this!\n",
        },
        {
            name = "CodeGPT4",
            chat = false,
            command = true,
            -- string with model name or table with model name and parameters
            model = { model = "chatgpt-4o-latest", temperature = 0.8, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = "You are an AI working as a code editor.\n\n"
                .. "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
                .. "START AND END YOUR ANSWER WITH:\n\n```",
        },
    },
})

-- VISUAL mode mappings
-- s, x, v modes are handled the same way by which_key
require("which-key").add({
  -- VISUAL mode mappings
  -- s, x, v modes are handled the same way by which_key
  {
    mode = { "v" },
    nowait = true,
    remap = false,
    { "<C-g><C-t>", ":<C-u>'<,'>GpChatNew tabnew<cr>", desc = "ChatNew tabnew" },
    { "<C-g><C-v>", ":<C-u>'<,'>GpChatNew vsplit<cr>", desc = "ChatNew vsplit" },
    { "<C-g><C-x>", ":<C-u>'<,'>GpChatNew split<cr>", desc = "ChatNew split" },
    { "<C-g>a", ":<C-u>'<,'>GpAppend<cr>", desc = "Visual Append (after)" },
    { "<C-g>b", ":<C-u>'<,'>GpPrepend<cr>", desc = "Visual Prepend (before)" },
    { "<C-g>c", ":<C-u>'<,'>GpChatNew<cr>", desc = "Visual Chat New" },
    { "<C-g>g", group = "generate into new .." },
    { "<C-g>ge", ":<C-u>'<,'>GpEnew<cr>", desc = "Visual GpEnew" },
    { "<C-g>gn", ":<C-u>'<,'>GpNew<cr>", desc = "Visual GpNew" },
    { "<C-g>gp", ":<C-u>'<,'>GpPopup<cr>", desc = "Visual Popup" },
    { "<C-g>gt", ":<C-u>'<,'>GpTabnew<cr>", desc = "Visual GpTabnew" },
    { "<C-g>gv", ":<C-u>'<,'>GpVnew<cr>", desc = "Visual GpVnew" },
    { "<C-g>i", ":<C-u>'<,'>GpImplement<cr>", desc = "Implement selection" },
    { "<C-g>n", "<cmd>GpNextAgent<cr>", desc = "Next Agent" },
    { "<C-g>p", ":<C-u>'<,'>GpChatPaste<cr>", desc = "Visual Chat Paste" },
    { "<C-g>r", ":<C-u>'<,'>GpRewrite<cr>", desc = "Visual Rewrite" },
    { "<C-g>s", "<cmd>GpStop<cr>", desc = "GpStop" },
    { "<C-g>t", ":<C-u>'<,'>GpChatToggle<cr>", desc = "Visual Toggle Chat" },
    { "<C-g>w", group = "Whisper" },
    { "<C-g>wa", ":<C-u>'<,'>GpWhisperAppend<cr>", desc = "Whisper Append" },
    { "<C-g>wb", ":<C-u>'<,'>GpWhisperPrepend<cr>", desc = "Whisper Prepend" },
    { "<C-g>we", ":<C-u>'<,'>GpWhisperEnew<cr>", desc = "Whisper Enew" },
    { "<C-g>wn", ":<C-u>'<,'>GpWhisperNew<cr>", desc = "Whisper New" },
    { "<C-g>wp", ":<C-u>'<,'>GpWhisperPopup<cr>", desc = "Whisper Popup" },
    { "<C-g>wr", ":<C-u>'<,'>GpWhisperRewrite<cr>", desc = "Whisper Rewrite" },
    { "<C-g>wt", ":<C-u>'<,'>GpWhisperTabnew<cr>", desc = "Whisper Tabnew" },
    { "<C-g>wv", ":<C-u>'<,'>GpWhisperVnew<cr>", desc = "Whisper Vnew" },
    { "<C-g>ww", ":<C-u>'<,'>GpWhisper<cr>", desc = "Whisper" },
    { "<C-g>x", ":<C-u>'<,'>GpContext<cr>", desc = "Visual GpContext" },
  },

  -- NORMAL mode mappings
  {
    mode = { "n" },
    nowait = true,
    remap = false,
    { "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>", desc = "New Chat tabnew" },
    { "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>", desc = "New Chat vsplit" },
    { "<C-g><C-x>", "<cmd>GpChatNew split<cr>", desc = "New Chat split" },
    { "<C-g>a", "<cmd>GpAppend<cr>", desc = "Append (after)" },
    { "<C-g>b", "<cmd>GpPrepend<cr>", desc = "Prepend (before)" },
    { "<C-g>c", "<cmd>GpChatNew<cr>", desc = "New Chat" },
    { "<C-g>f", "<cmd>GpChatFinder<cr>", desc = "Chat Finder" },
    { "<C-g>g", group = "generate into new .." },
    { "<C-g>ge", "<cmd>GpEnew<cr>", desc = "GpEnew" },
    { "<C-g>gn", "<cmd>GpNew<cr>", desc = "GpNew" },
    { "<C-g>gp", "<cmd>GpPopup<cr>", desc = "Popup" },
    { "<C-g>gt", "<cmd>GpTabnew<cr>", desc = "GpTabnew" },
    { "<C-g>gv", "<cmd>GpVnew<cr>", desc = "GpVnew" },
    { "<C-g>n", "<cmd>GpNextAgent<cr>", desc = "Next Agent" },
    { "<C-g>r", "<cmd>GpRewrite<cr>", desc = "Inline Rewrite" },
    { "<C-g>s", "<cmd>GpStop<cr>", desc = "GpStop" },
    { "<C-g>t", "<cmd>GpChatToggle<cr>", desc = "Toggle Chat" },
    { "<C-g>w", group = "Whisper" },
    { "<C-g>wa", "<cmd>GpWhisperAppend<cr>", desc = "Whisper Append (after)" },
    { "<C-g>wb", "<cmd>GpWhisperPrepend<cr>", desc = "Whisper Prepend (before)" },
    { "<C-g>we", "<cmd>GpWhisperEnew<cr>", desc = "Whisper Enew" },
    { "<C-g>wn", "<cmd>GpWhisperNew<cr>", desc = "Whisper New" },
    { "<C-g>wp", "<cmd>GpWhisperPopup<cr>", desc = "Whisper Popup" },
    { "<C-g>wr", "<cmd>GpWhisperRewrite<cr>", desc = "Whisper Inline Rewrite" },
    { "<C-g>wt", "<cmd>GpWhisperTabnew<cr>", desc = "Whisper Tabnew" },
    { "<C-g>wv", "<cmd>GpWhisperVnew<cr>", desc = "Whisper Vnew" },
    { "<C-g>ww", "<cmd>GpWhisper<cr>", desc = "Whisper" },
    { "<C-g>x", "<cmd>GpContext<cr>", desc = "Toggle GpContext" },
  },

  -- INSERT mode mappings
  {
    mode = { "i" },
    nowait = true,
    remap = false,
    { "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>", desc = "New Chat tabnew" },
    { "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>", desc = "New Chat vsplit" },
    { "<C-g><C-x>", "<cmd>GpChatNew split<cr>", desc = "New Chat split" },
    { "<C-g>a", "<cmd>GpAppend<cr>", desc = "Append (after)" },
    { "<C-g>b", "<cmd>GpPrepend<cr>", desc = "Prepend (before)" },
    { "<C-g>c", "<cmd>GpChatNew<cr>", desc = "New Chat" },
    { "<C-g>f", "<cmd>GpChatFinder<cr>", desc = "Chat Finder" },
    { "<C-g>g", group = "generate into new .." },
    { "<C-g>ge", "<cmd>GpEnew<cr>", desc = "GpEnew" },
    { "<C-g>gn", "<cmd>GpNew<cr>", desc = "GpNew" },
    { "<C-g>gp", "<cmd>GpPopup<cr>", desc = "Popup" },
    { "<C-g>gt", "<cmd>GpTabnew<cr>", desc = "GpTabnew" },
    { "<C-g>gv", "<cmd>GpVnew<cr>", desc = "GpVnew" },
    { "<C-g>n", "<cmd>GpNextAgent<cr>", desc = "Next Agent" },
    { "<C-g>r", "<cmd>GpRewrite<cr>", desc = "Inline Rewrite" },
    { "<C-g>s", "<cmd>GpStop<cr>", desc = "GpStop" },
    { "<C-g>t", "<cmd>GpChatToggle<cr>", desc = "Toggle Chat" },
    { "<C-g>w", group = "Whisper" },
    { "<C-g>wa", "<cmd>GpWhisperAppend<cr>", desc = "Whisper Append (after)" },
    { "<C-g>wb", "<cmd>GpWhisperPrepend<cr>", desc = "Whisper Prepend (before)" },
    { "<C-g>we", "<cmd>GpWhisperEnew<cr>", desc = "Whisper Enew" },
    { "<C-g>wn", "<cmd>GpWhisperNew<cr>", desc = "Whisper New" },
    { "<C-g>wp", "<cmd>GpWhisperPopup<cr>", desc = "Whisper Popup" },
    { "<C-g>wr", "<cmd>GpWhisperRewrite<cr>", desc = "Whisper Inline Rewrite" },
    { "<C-g>wt", "<cmd>GpWhisperTabnew<cr>", desc = "Whisper Tabnew" },
    { "<C-g>wv", "<cmd>GpWhisperVnew<cr>", desc = "Whisper Vnew" },
    { "<C-g>ww", "<cmd>GpWhisper<cr>", desc = "Whisper" },
    { "<C-g>x", "<cmd>GpContext<cr>", desc = "Toggle GpContext" },
  },
})
