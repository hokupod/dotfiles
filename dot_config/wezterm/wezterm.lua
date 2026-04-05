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
	-- Settings for inputting backslashes with JIS keyboard
	config.send_composed_key_when_left_alt_is_pressed = true
end

wezterm.on("window-config-reloaded", function(window, pane)
	window:toast_notification("wezterm", "Configuration reloaded!", nil, 4000)
end)

wezterm.on("bell", function(window, pane)
	local notification_message = "🔔 Now calling!:\n" .. pane:get_title()
	window:toast_notification("wezterm", notification_message, nil, 4000)
end)

config.audible_bell = "Disabled"
config.color_scheme = "Tokyo Night"
config.font = wezterm.font("UDEV Gothic 35NFLG", { weight = "Regular", stretch = "Normal" })
config.font_size = 13.0
config.initial_rows = 60
config.initial_cols = 140
config.use_ime = true

config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
config.window_decorations = "RESIZE"
config.window_frame = {
	inactive_titlebar_bg = "none",
	active_titlebar_bg = "none",
}
config.window_background_gradient = {
	colors = { "#000000" },
}

config.keys = {
	-- CTRL-SHIFT-l activates the debug overlay
	{ key = "L", mods = "CTRL", action = wezterm.action.ShowDebugOverlay },
	{
		key = "Enter",
		mods = "OPT",
		action = wezterm.action.DisableDefaultAssignment,
	},
	-- Claude Code for SHIFT-Enter to send ESC Enter
	{ key = "Enter", mods = "SHIFT", action = wezterm.action({ SendString = "\x1b\r" }) },
}
return config
