local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")

-- デフォルト設定
local config = {
  register = '"', -- デフォルトのレジスター
}

-- レジスターに保存する共通関数
local function yank_entries(entries)
  if #entries == 0 then
    return
  end

  local texts = {}
  for _, entry in ipairs(entries) do
    table.insert(texts, entry[1])
  end

  local yanked_text = table.concat(texts, "\n")
  vim.fn.setreg(config.register, yanked_text)
  print(string.format("Yanked %d line%s to register '%s'", #texts, (#texts > 1 and "s" or ""), config.register))
end

local messages = function(opts)
  opts = opts or {}

  local messages = vim.fn.execute("messages")
  local lines = vim.split(messages, "\n")

  local filtered_lines = {}
  for _, line in ipairs(lines) do
    if line ~= "" then
      table.insert(filtered_lines, line)
    end
  end

  pickers
    .new(opts, {
      prompt_title = "Messages",
      finder = finders.new_table({
        results = filtered_lines,
      }),
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          local picker = action_state.get_current_picker(prompt_bufnr)
          local selections = picker:get_multi_selection()

          if #selections > 0 then
            yank_entries(selections)
          else
            yank_entries({ action_state.get_selected_entry() })
          end

          actions.close(prompt_bufnr)
        end)

        return true
      end,
    })
    :find()
end

-- setup関数を追加
local setup = function(opts)
  opts = opts or {}
  config = vim.tbl_deep_extend("force", config, opts)
end

return require("telescope").register_extension({
  exports = {
    messages = messages,
    setup = setup,
  },
})
