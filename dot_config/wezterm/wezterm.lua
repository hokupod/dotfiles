local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

local wsl_domains = wezterm.default_wsl_domains()
for idx, domain in ipairs(wsl_domains) do
  if domain.name == "WSL:Ubuntu-20.04" then
    domain.default_prog = { "fish" }
  end
end

config.enable_wayland = false

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  -- for Windows
  config.wsl_domains = wsl_domains
  config.default_prog = { "wsl" }
elseif wezterm.target_triple == "x86_64-unknown-linux-gnu" then
  -- for Linux
  config.enable_wayland = true
elseif wezterm.target_triple == "aarch64-apple-darwin" then
  -- for macOS
end

config.audible_bell = "Disabled"
config.color_scheme = "PaperColor Light (base16)"
config.font = wezterm.font("UDEV Gothic 35NFLG", { weight = "Regular", stretch = "Normal" })
config.initial_rows = 60
config.initial_cols = 140
config.keys = {
  -- CTRL-SHIFT-l activates the debug overlay
  { key = "L", mods = "CTRL", action = wezterm.action.ShowDebugOverlay },
}
return config
