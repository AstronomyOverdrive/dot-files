#!/bin/sh

# This was written for LMDE6, later releases might need adjusting

# Optional parts
laptop="yes" # Install auto-cpufreq
dracula="no" # Install dacula theme
nvidia="no" # Install nvidia drivers
x11="yes" # Install xclip, parcellite and flameshot
sway="no" # Install sway (and wofi, i3status etc)
golang="no" # Install golang
dotnet="no" # Install dotnet sdk
nodejs="yes" # Install nvm, nodejs, npm and typescript
backport="no" # Install kernel from backports
swapfile="no" # Setup swapfile
usedoas="yes" # Install and setup doas

####################
# Sections:        #
# - MULLVAD        #
# - UPDATE         #
# - INSTALL        #
# - REMOVE         #
# - CLEANUP        #
# - SWAP FILE      #
# - ALIASES        #
# - PANEL STYLING  #
# - SOURCECODEPRO  #
# - DOTFILES       #
# - DOAS           #
# - DRACULA        #
# - AUTO-CPUFREQ   #
####################

#############
## MULLVAD ##
#############

sudo curl -fsSLo /usr/share/keyrings/mullvad-keyring.asc https://repository.mullvad.net/deb/mullvad-keyring.asc
echo "deb [signed-by=/usr/share/keyrings/mullvad-keyring.asc arch=$( dpkg --print-architecture )] https://repository.mullvad.net/deb/stable stable main" | sudo tee /etc/apt/sources.list.d/mullvad.list

############
## UPDATE ##
############

sudo apt update
sudo apt upgrade -y

#############
## INSTALL ##
#############

if [ $backport = "yes" ]; then
	sudo apt install -y -t bookworm-backports linux-image-amd64 # Newer kernel, for network drivers
fi

if [ $x11 = "yes" ]; then
	sudo apt install -y xclip parcellite
	sudo apt install -y flameshot
fi

if [ $golang = "yes" ]; then
	cd $HOME
	wget https://go.dev/dl/go1.25.0.linux-amd64.tar.gz
	sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.25.0.linux-amd64.tar.gz
	rm go*.tar.gz
	echo "export PATH=\$PATH:/usr/local/go/bin" >> .profile
fi
if [ $nodejs = "yes" ]; then
	cd $HOME
	curl https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh > nvm.sh
	chmod +x nvm.sh
	/bin/bash nvm.sh
	. .nvm/nvm.sh
	rm nvm.sh
	nvm install node
	npm install -g typescript
fi
if [ $dotnet = "yes" ]; then
	cd $HOME
	wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
	sudo dpkg -i packages-microsoft-prod.deb
	rm packages-microsoft-prod.deb
	sudo apt-get update && sudo apt-get install -y dotnet-sdk-9.0
fi

# Apt
sudo apt install -y mint-meta-codecs
sudo apt install -y mpv
sudo apt install -y gimp
sudo apt install -y krita
sudo apt install -y inkscape
sudo apt install -y kdenlive
#sudo apt install -y obs-studio
sudo apt install -y mullvad-browser
sudo apt install -y papirus-icon-theme
sudo apt install -y vim
sudo apt install -y ark
sudo apt install -y rar unrar
sudo apt install -y geany geany-plugins
sudo apt install -y python3-venv
sudo apt install -y git
sudo apt install -y xfce4-terminal
sudo apt install -y gnome-mines
sudo apt install -y gnome-tetravex
if [ $nvidia = "yes" ]; then
	sudo apt install -y nvidia-driver
fi
if [ $sway = "yes" ]; then
	sudo apt install -y sway
	sudo apt install -y swayidle
	sudo apt install -y swaylock
	sudo apt install -y xdg-desktop-portal-gtk
	sudo apt install -y xdg-desktop-portal-wlr
	sudo apt install -y wofi
	sudo apt install -y polkitd
	sudo apt install -y sway-notification-center
	sudo apt install -y grim
	sudo apt install -y i3status
	sudo apt install -y wf-recorder
	sudo apt install -y wl-clipboard
	mkdir -p $HOME/.config/gtk-3.0
	#printf "[Settings]
	#gtk-theme-name=Adwaita
	#gtk-icon-theme-name=Papirus-Dark
	#gtk-application-prefer-dark-theme=true
	#" > $HOME/.config/gtk-3.0/settings.ini
	if [ $golang = "yes" ]; then
		cd $HOME
		export PATH=$PATH:/usr/local/go/bin
		go install go.senan.xyz/cliphist@latest
		sudo cp go/bin/cliphist /usr/bin/cliphist
	fi
fi

# Flatpak
flatpak install -y flathub com.valvesoftware.Steam
flatpak install -y flathub net.lutris.Lutris
flatpak install -y flathub com.github.tchx84.Flatseal
#flatpak install -y flathub org.freedesktop.Platform.VulkanLayer.MangoHud
flatpak install -y flathub net.minetest.Minetest
flatpak install -y flathub org.openmw.OpenMW
#flatpak install -y flathub org.kde.kdenlive
#flatpak install -y flathub org.gimp.GIMP
#flatpak install -y flathub com.obsproject.Studio
#flatpak install -y flathub chat.revolt.RevoltDesktop
#flatpak install -y flathub com.discordapp.Discord

############
## REMOVE ##
############

sudo apt purge -y warpinator
sudo apt purge -y hexchat
sudo apt purge -y transmission-gtk
sudo apt purge -y celluloid
sudo apt purge -y hypnotix
sudo apt purge -y rhythmbox
sudo apt purge -y onboard
sudo apt purge -y pix
sudo apt purge -y kdeconnect

#############
## CLEANUP ##
#############

sudo apt autoremove -y
sudo apt autoclean -y

###############
## SWAP FILE ##
###############

if [ $swapfile = "yes" ]; then
	sudo dd if=/dev/zero of=/swapfile bs=1024k count=8192
	sudo chmod 0600 /swapfile
	sudo mkswap /swapfile
	sudo swapon /swapfile
	echo "/swapfile   none    swap    sw  0 0" | sudo tee -a /etc/fstab
fi

#############
## ALIASES ##
#############

cd $HOME
touch .bash_aliases
echo "alias pmi='sudo apt install'" >> .bash_aliases
echo "alias pmu='sudo apt update && sudo apt upgrade && sudo apt autoclean && sudo apt autoremove && flatpak update'" >> .bash_aliases
echo "alias pmr='sudo apt purge'" >> .bash_aliases
echo "alias ..='cd ..'" >> .bash_aliases
echo "alias :q='exit'" >> .bash_aliases
printf "bright () {\n\tif test \$1 -lt 101 && test \$1 -gt -1; then\n\t\tmax_bright=\$(cat /sys/class/backlight/amdgpu_bl0/max_brightness)\n\t\techo \$(( \$1 * \$max_bright / 100 )) | doas tee -a /sys/class/backlight/amdgpu_bl0/brightness\n\tfi\n}\n" >> .bash_aliases
printf "mkcd () {\n\tmkdir \$1 && cd \$1\n}\n" >> .bash_aliases

###################
## PANEL STYLING ##
###################

sudo cp -r /usr/share/themes/Mint-Y-Dark-Grey/ $HOME/.themes/Mint-Y-Dark-Grey
sudo sed -i 's/applet-label {/applet-label {\nfont-size: 1.2em;/g' $HOME/.themes/Mint-Y-Dark-Grey/cinnamon/cinnamon.css
printf "\n#panel {background: black;}\n\n.workspace-button,\n.workspace-button:shaded,\n.workspace-button:outlined {\n\tbackground-color: black;\n\tborder: none;\n\tpadding: 0;\n\twidth: 1em;\n\tfont-size: 1.2em;\n}\n\n.grouped-window-list-item-box:focus,\n.grouped-window-list-item-box:hover {\n\tborder-color: lightgrey;\n\tbackground: black;\n}" | sudo tee -a $HOME/.themes/Mint-Y-Dark-Grey/cinnamon/cinnamon.css
gsettings set org.cinnamon.desktop.interface gtk-theme "Mint-Y-Dark-Grey"

###################
## SOURCECODEPRO ##
###################

mkdir -p $HOME/.local/share/fonts
git clone https://github.com/adobe-fonts/source-code-pro.git
cp source-code-pro/TTF/*.ttf $HOME/.local/share/fonts/
rm -fr source-code-pro

##############
## DOTFILES ##
##############

cd $HOME
git clone https://github.com/AstronomyOverdrive/dot-files.git
mkdir -p .config/mpv
mkdir -p .config/geany/colorschemes
mkdir -p .local/share/xfce4/terminal/colorschemes/
#mkdir -p .themes/YACT/cinnamon
mv dot-files/mpv/mpv.conf .config/mpv/mpv.conf
mv dot-files/editors/geany/geany.conf .config/geany/geany.conf
mv dot-files/editors/geany/colorschemes/yadt.conf .config/geany/colorschemes/yadt.conf
mv dot-files/terminal/yatt.theme .local/share/xfce4/terminal/colorschemes/yatt.theme
#mv dot-files/de-themes/cinnamon/cinnamon.css .themes/YACT/cinnamon/cinnamon.css
mv dot-files/editors/vim/.vimrc .vimrc
mv dot-files/git/.gitconfig .gitconfig

##########
## DOAS ##
##########

if [ $usedoas = "yes" ]; then
	sudo apt install -y doas
	username=$(whoami)
	sudo touch /etc/doas.conf
	echo "permit persist $username" | sudo tee -a /etc/doas.conf
	sudo chown root:root /etc/doas.conf
	sudo chmod 0400 /etc/doas.conf
	# Removing user from sudo will result in the GUI Polkit window not popping up
	#sudo usermod -rG sudo $username
else
	sudo ln -s /usr/bin/sudo /usr/bin/doas
fi

#############
## DRACULA ##
#############

if [ $dracula = "yes" ]; then
	cd $HOME
	mkdir -p .themes
	mkdir -p .icons
	mkdir -p .local/share/xfce4/terminal/colorschemes
	mkdir -p Pictures
	git clone https://github.com/dracula/gtk.git
	git clone https://github.com/alvatip/Sunity-cursors.git
	git clone https://github.com/PapirusDevelopmentTeam/papirus-folders.git
	git clone https://github.com/dracula/xfce4-terminal.git
	git clone https://github.com/aynp/dracula-wallpapers.git
	mv gtk/ .themes/Dracula/
	mv Sunity-cursors/Sunity-cursors .icons/Sunity-cursors
	mv xfce4-terminal/Dracula.theme .local/share/xfce4/terminal/colorschemes/Dracula.theme
	mv dracula-wallpapers Pictures/dracula-wallpapers
	chmod +x papirus-folders/install.sh
	/bin/bash papirus-folders/install.sh
	papirus-folders -C violet --theme Papirus-Dark
	rm -rf Sunity-cursors
	rm -rf xfce4-terminal
	rm -rf papirus-folders
	printf "\n.applet-label {font-size: 1.2em;}\n\n.workspace-button {\n\tpadding: 0;\n\twidth: 1em;\n\tfont-size: 1.2em;\n}" >> .themes/Dracula/cinnamon/cinnamon.css
	gsettings set org.cinnamon.desktop.interface cursor-theme "Sunity-cursors"
	gsettings set org.cinnamon.desktop.interface cursor-size 24
	gsettings set org.cinnamon.desktop.interface icon-theme "Papirus-Dark"
	gsettings set org.cinnamon.desktop.interface gtk-theme "Dracula"
	gsettings set org.cinnamon.theme name "Dracula"
fi

##################
## AUTO-CPUFREQ ##
##################

if [ $laptop = "yes" ]; then
	cd $HOME
	git clone https://github.com/AdnanHodzic/auto-cpufreq.git
	cd auto-cpufreq && sudo ./auto-cpufreq-installer
	sudo auto-cpufreq --install
fi

echo "-"
echo "All done!"
echo "Please restart your computer."

exit 0
