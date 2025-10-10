#!/bin/sh

# Choose what to install here ("yes"/"no")
# Editors
geany="yes"
vi="no"
vim="yes"
neovim="yes"
# Window managers (for linux)
i3="no"
sway="yes"
# Desktop enviroment theme
xfce="no"
# Terminals
wezterm="yes"
xfce4="no"
# Shell aliases
bash="yes"
ksh="no"
# SCM
git="yes"
mercurial="yes"
# Other
gtk3="yes"
newsboat="yes"
mpv="yes"
scripts="no"
ssh="yes"

# Editors
if [ $geany = "yes" ]; then
	mkdir -p $HOME/.config/geany
	cp -r editors/geany/* $HOME/.config/geany/
fi
if [ $neovim = "yes" ]; then
	mkdir -p $HOME/.config/nvim
	cp -r editors/neovim/* $HOME/.config/nvim/
fi
if [ $vi = "yes" ]; then
	cp editors/nvi/.exrc $HOME/
fi
if [ $vim = "yes" ]; then
	cp editors/vim/.vimrc $HOME/
fi
# Window managers
if [ $i3 = "yes" ]; then
	mkdir -p $HOME/.config/i3
	mkdir -p $HOME/.config/i3status
	cp linux/i3/i3config $HOME/.config/i3/config
	cp linux/i3/i3statusconfig $HOME/.config/i3status/config
fi
if [ $sway = "yes" ]; then
	mkdir -p $HOME/.config/sway
	mkdir -p $HOME/.config/i3status
	cp linux/sway/config $HOME/.config/sway/
	cp linux/i3/i3statusconfig $HOME/.config/i3status/config
fi
# Desktop enviroment theme
if [ $xfce = "yes" ]; then
	mkdir -p $HOME/.config/gtk-3.0
	cp de-themes/xfce4/gtk.css $HOME/.config/gtk-3.0/
fi
# Terminals
if [ $wezterm = "yes" ]; then
	cp terminal/.wezterm.lua $HOME/
fi
if [ $xfce4 = "yes" ]; then
	mkdir -p $HOME/.local/share/xfce4/terminal/colorschemes/
	cp terminal/yatt.theme $HOME/.local/share/xfce4/terminal/colorschemes/
fi
# Shell aliases
if [ $bash = "yes" ]; then
	cp linux/.bash_aliases $HOME/
fi
if [ $ksh = "yes" ]; then
	cp obsd/.kshrc $HOME/
	echo "Add \"export ENV=\$HOME/.kshrc\" to .profile if ksh doesn't source"
fi
# SCM
if [ $git = "yes" ]; then
	cp git/.gitconfig $HOME/
fi
if [ $mercurial = "yes" ]; then
	cp mercurial/.hgrc $HOME/
fi
# Other
if [ $gtk3 = "yes" ]; then
	mkdir -p $HOME/.config/gtk-3.0
	cp gtk-3.0/settings.ini $HOME/.config/gtk-3.0/
fi
if [ $newsboat = "yes" ]; then
	mkdir -p $HOME/.newsboat
	cp newsboat/config $HOME/.newsboat/
fi
if [ $mpv = "yes" ]; then
	mkdir -p $HOME/.config/mpv
	cp mpv/mpv.conf $HOME/.config/mpv/
fi
if [ $scripts = "yes" ]; then
	mkdir -p $HOME/.scripts
	cp scripts/* $HOME/.scripts/
fi
if [ $ssh = "yes" ]; then
	mkdir -p $HOME/.ssh
	cp ssh/config $HOME/.ssh/
fi

exit 0
