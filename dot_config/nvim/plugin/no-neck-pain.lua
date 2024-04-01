local wk = require("which-key")
wk.register({
  n = {
    name = "NoNeckPain",
    ["n"] = { "<cmd>NoNeckPain<CR>", "[NoNeckPain] Toggle" },
    ["u"] = { "<cmd>NoNeckPainWidthUp<CR>", "[NoNeckPain] Width Up" },
    ["d"] = { "<cmd>NoNeckPainWidthDown<CR>", "[NoNeckPain] Width Down" },
  },
}, {
  mode = "n",
  prefix = "<leader>",
})
