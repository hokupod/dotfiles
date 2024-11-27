local header_text = [[
                            ███████H                        .
                    ███████████████████████                 .
                ████YY"!             ?"W██████H             .
             ██HY=`                      _TH█████           .
           █HY!                             ?W████H         .
         █HY                                  (W████        .
        █Y`                                     7████       .
       H^            .}           .,             ,H███      .
      H'          .ZY^             4&..           .H██      .
     H^                       `                 .JYH████H   .
  ███F             .JA+.         ....          .F.H███████  .
 ███H`           .H██) 4,      .███L?h        .P W██ ██████ .
 ███P           .████% ,L     .████F (]       J{.██ ███████ .
████%           J███#` .F     (████' .F       X`J█ █████████.
 ███)           d██#!  (\     dH█H\  .F       d.d█ ████████ .
N███]           ,h    .%      j|     (\       ([J██████████ .
 N██L            ."YT"`        Ta...d=         4xH████████  .
    H                                           .TH█████N   .
    N;       .P               ..         W.          H      .
    Nb       ▨▨▨▨▨▨▨▨▨▨▨▨▨▨▨▨▨▨▨▨▨▨▨▨▨▨▨▨▨          .       .
     N;                                             d       .
]]

require("snacks").setup {
  bigfile = { enabled = true },
  dashboard = { enabled = true,
    preset = {
      -- header = header_text,
    }
  },
  notifier = { enabled = true },
  quickfile = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = true },
}

require("which-key").add({
  { "<leader>s", group = "Snacks.nvim", mode = "n", },
  { "<leader>sgg", function() Snacks.lazygit() end, desc = "Lazygit", cond = is_git_repo, },
  { "<leader>sgb", function() Snacks.git.blame_line() end, desc = "Git Blame Line", cond = is_git_repo, mode = { "v", "n" }, },
  { "<leader>sgB", function() Snacks.gitbrowse() end, desc = "Git Browse", cond = is_git_repo, mode = { "v", "n" }, },
  { "<leader>sgf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History", cond = is_git_repo, },
  { "<leader>sgl", function() Snacks.lazygit.log() end, desc = "Lazygit Log (cwd)", cond = is_git_repo, },
})
