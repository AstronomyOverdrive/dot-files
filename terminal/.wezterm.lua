local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font_size = 18
config.font = wezterm.font('Source Code Pro', { weight = 'Medium', italic = false })

config.hide_tab_bar_if_only_one_tab = true

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.colors = {
	foreground = "#EBEBEB",
	background = "#171717",
	cursor_bg = "#EBEBEB",
	cursor_border = "#EBEBEB",
	cursor_fg = "#171717",
	selection_bg = "#EBEBEB",
	selection_fg = "#171717",
	ansi = { "#171717", "#C75A4C", "#3F9E3F", "#FA8916", "#01C0FB", "#D47FD4", "#8EDBD7", "#E5E5E5" },
	brights = { "#7F7F7F", "#FF0000", "#00FF00", "#FFFF00", "#5C5CFF", "#FF00FF", "#00FFFF", "#EBEBEB" },
	tab_bar = {
		background = "#333333",
		active_tab = {
			bg_color = "#171717",
			fg_color = "#EBEBEB",
		},
		inactive_tab = {
			bg_color = "#333333",
			fg_color = "#EBEBEB",
		},
	}
}
config.bold_brightens_ansi_colors = false

config.term = 'xterm-256color'

config.max_fps = 144

config.disable_default_key_bindings = true
config.keys = {
	{ key = 'c', mods = 'SHIFT|CTRL', action = wezterm.action.CopyTo 'Clipboard' },
	{ key = 'v', mods = 'SHIFT|CTRL', action = wezterm.action.PasteFrom 'Clipboard' },
	{ key = 'n', mods = 'SHIFT|CTRL', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
	{ key = 'W', mods = 'SHIFT|CTRL', action = wezterm.action.CloseCurrentTab { confirm = true } },
	{ key = 'q', mods = 'SHIFT|CTRL', action = wezterm.action.ActivateTabRelative(-1) },
	{ key = 'e', mods = 'SHIFT|CTRL', action = wezterm.action.ActivateTabRelative(1) },
}

return config
