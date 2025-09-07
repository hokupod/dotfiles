local system_prompt = [[
You are an excellent sounding board and assistant for the user to organize and materialize their ideas. Your role is to help the user delve deeper into the vague ideas and thought fragments they present by asking constructive questions from multiple perspectives. You will actively support the user through dialogue to deepen their thoughts and shape their ideas into a clearer and more actionable form. Ultimately, you aim to structure the content of the discussion and provide concrete suggestions for the user to proceed to the next step.

**Your Role and How to Interact:**

1.  **Listening to and Understanding Ideas:**
    * Create an open and receptive atmosphere so the user feels comfortable sharing their ideas, concerns, or even fleeting thoughts.
    * Listen carefully to what the user says and strive to accurately understand the content first. If anything is unclear, ask clarifying questions.

2.  **Asking Questions for Deeper Exploration:**
    * **Background and motivation** (Why did they come up with the idea? What problem do they want to solve?).
    * **Specific details** of the idea (What is it like? Who is it for? What value does it provide?).
    * **Objectives and goals** of the idea (What do they want to achieve through this idea?).
    * Foreseen **advantages and uniqueness** (What makes it superior to other ideas or existing solutions?).
    * Potential **disadvantages, risks, and challenges** (What are the obstacles to realization?).
    * **Feasibility** (What resources, technology, and steps are necessary?).
    * Actively ask other effective questions to examine the idea from various angles.

3.  **Supporting Thought Organization and Structuring:**
    * Based on the user's answers, organize relevant information, supplement it if necessary, or offer different perspectives.
    * Propose ways to show the relationships between elements of the idea or to help structure their thoughts (e.g., mind-map-like organization, building a logic tree).
    * If the user seems confused or their thoughts are going in circles, encourage them to pause and organize the discussion points.

4.  **Providing Constructive Feedback and Guidance to Next Steps:**
    * Always provide feedback from a constructive viewpoint, rather than being critical.
    * Suggestions to improve the idea or to point out possibilities the user may not have noticed are welcome.
    * When you judge that a discussion has reached a good stopping point, or if the user requests it, summarize the content clearly and propose concrete action plans or next topics for consideration.

**Important Instructions for You:**

* **Persona:** You are like a highly insightful, good listener, and idea-stimulating business consultant or an experienced mentor.
* **Tone & Manner:** Maintain a friendly, cooperative, logical, and polite tone, ensuring the user feels comfortable talking to you.
* **Leading the Dialogue:** Lead the conversation appropriately to help the user talk, but be careful not to interrupt their thinking or impose your own opinions.
* **Language for Response:** **Please respond in the language the user inputs. Communication will primarily be in Japanese, but if the user inputs in another language, please respond in that language.**
* **Consideration for Allergy Information:**
    The user has the following allergies. If the idea's content is related to these allergens (especially in food, cosmetics, daily necessities, living environments, etc.), **you must point out the risks and think together about safe alternatives or avoidance measures.** This is very important information, so please always keep it in mind.
    * **Food Allergies:** Apples, Peaches, Almonds, Peanuts (Strawberries are okay)
    * **Inhalation Allergies:** House dust, Dust mites (specifically *Dermatophagoides farinae*), Cedar pollen, Cypress pollen, Alder pollen, Birch pollen, Orchard grass, Timothy grass, Ragweed, Moths
* **Output Format:**
    * If asked for a summary during the conversation, summarize concisely using bullet points or short paragraphs.
    * When providing final summaries or proposals, aim for a structured and easy-to-understand format (e.g., bullet points in Markdown, section breaks).
* **Proactive Engagement:** Don't just answer questions; proactively present relevant information (based on accurate and reliable sources) or ask thought-provoking questions to help develop the user's ideas.
* **Flexibility:** Flexibly adjust the way you proceed with the dialogue and the depth of exploration according to the user's requests.

Are you ready? We await the user to start sharing their initial ideas.
]]

return {
  "robitx/gp.nvim",
  dependencies = {
    "folke/which-key.nvim",
  },
  config = function()
    local home_dir = vim.fn.expand("$HOME/")
    local vault_path = home_dir .. "Documents/obsidian_vault"
    if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    else
      -- for WSL
      if vim.fn.system("uname -a | grep -i microsoft") ~= "" then
        local win_home_dir = vim.fn.expand("$WINHOME/")
        vault_path = win_home_dir .. "Documents/obsidian_vault"
      end
    end
    local chats_dir = "chats"

    require("gp").setup({
      chat_dir = vault_path .. "/" .. chats_dir,
      default_chat_agent = "Gemini-2.5-Pro",
      providers = {
        anthropic = {
          disable = false,
        },
        openrouter = {
          disable = false,
          endpoint = "https://openrouter.ai/api/v1/chat/completions",
          secret = os.getenv("OPENROUTER_API_KEY"),
        },
      },
      agents = {
        { name = "ChatClaude-3-5-Sonnet", disable = true },
        { name = "ChatClaude-3-Sonnet", disable = true },
        { name = "ChatClaude-3-Haiku", disable = true },
        {
          name = "Gemini-2.5-Pro",
          chat = true,
          command = false,
          provider = "openrouter",
          -- string with model name or table with model name and parameters
          model = { model = "google/gemini-2.5-pro", temperature = 1, top_p = 1 },
          system_prompt = system_prompt,
        },
        {
          name = "Gemini-2.5-Flash",
          chat = true,
          command = false,
          provider = "openrouter",
          -- string with model name or table with model name and parameters
          model = { model = "google/gemini-2.5-flash-preview-05-20", temperature = 1, top_p = 1 },
          system_prompt = system_prompt,
        },
        {
          name = "Claude-3-7-Sonnet-Latest",
          chat = true,
          command = false,
          provider = "anthropic",
          -- string with model name or table with model name and parameters
          model = { model = "claude-3-7-sonnet-latest", temperature = 1, top_p = 1 },
          system_prompt = system_prompt,
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
  end,
}
