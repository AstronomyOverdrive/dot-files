#!/bin/sh

# Assuming you've installed using netinstall with the console enviroment

wm="i3" # Window manager to install, "i3" or "sway"
golang="yes" # Install golang
dotnet="yes" # Install dotnet sdk
nodejs="yes" # Install nvm, nodejs, npm and typescript
fonts="yes" # Install source code pro (requires git)
flatpak="no" # Install and setup flatpak

##################
# Sections:      #
# - UPDATE       #
# - INSTALL      #
# - REMOVE       #
# - CLEANUP      #
# - GTK3         #
# - AUDIO        #
# - DOAS         #
# - TMPFS (/tmp) #
##################

############
## UPDATE ##
############

sudo apt update
sudo apt upgrade -y

#############
## INSTALL ##
#############

sudo apt install -y abrowser
sudo apt install -y ark
sudo apt install -y curl
#sudo apt install -y doas
sudo apt install -y gcc
sudo apt install -y geany
sudo apt install -y geany-plugins
sudo apt install -y gimp
sudo apt install -y git
sudo apt install -y gvfs
sudo apt install -y inkscape
sudo apt install -y kdenlive
sudo apt install -y krita
sudo apt install -y libreoffice
sudo apt install -y lightdm
sudo apt install -y lightdm-gtk-greeter
sudo apt install -y mercurial
sudo apt install -y mpv
sudo apt install -y newsboat
sudo apt install -y numix-icon-theme-circle
sudo apt install -y pipewire
sudo apt install -y pipewire-pulse
sudo apt install -y policykit-1-gnome
sudo apt install -y ristretto
sudo apt install -y thunar
sudo apt install -y tlp
sudo apt install -y vim
sudo apt install -y wireplumber
sudo apt install -y xfce4-terminal

if [ $wm = "sway" ]; then
	sudo apt install -y sway
	sudo apt install -y swayidle
	sudo apt install -y swaylock
	sudo apt install -y xdg-desktop-portal-gtk
	sudo apt install -y xdg-desktop-portal-wlr
	sudo apt install -y wofi
	sudo apt install -y polkitd
	sudo apt install -y mako-notifier
	sudo apt install -y grim
	sudo apt install -y i3status
	sudo apt install -y wf-recorder
	sudo apt install -y wl-clipboard
	mkdir -p $HOME/.config/sway
	cp /etc/sway/config $HOME/.config/sway/
	sed -i "s/$(grep foot /etc/sway/config)/set \$term xfce4-terminal/g" $HOME/.config/sway/config
	sed -i "s/$(grep dmenu /etc/sway/config)/set \$menu wofi --show=drun -i --sort-order=alphabetical/g" $HOME/.config/sway/config
elif [ $wm = "i3" ]; then
	sudo apt install -y flameshot
	sudo apt install -y i3
	sudo apt install -y parcellite
	sudo apt install -y xclip
	sudo apt install -y xinit
	sudo apt install -y xorg
	sudo apt install -y xserver-xorg-input-wacom
fi


# Golang
if [ $golang = "yes" ]; then
	cd $HOME
	wget https://go.dev/dl/go1.25.0.linux-amd64.tar.gz
	sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.25.0.linux-amd64.tar.gz
	rm go*.tar.gz
	echo "export PATH=\$PATH:/usr/local/go/bin" >> .profile
	if [ $wm = "sway" ]; then
		cd $HOME
		export PATH=$PATH:/usr/local/go/bin
		go install go.senan.xyz/cliphist@latest
		sudo cp go/bin/cliphist /usr/bin/cliphist
	fi
fi

# NodeJS / NPM / TypeScript
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

# .NET
if [ $dotnet = "yes" ]; then
	cd $HOME
	wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
	sudo dpkg -i packages-microsoft-prod.deb
	rm packages-microsoft-prod.deb
	sudo apt-get update && sudo apt-get install -y dotnet-sdk-9.0
fi

# Fonts
if [ $fonts = "yes" ]; then
	cd $HOME
	git clone https://github.com/adobe-fonts/source-code-pro.git
	mkdir -p .local/share/fonts
	mv source-code-pro/TTF/* .local/share/fonts/
	rm -rf source-code-pro
fi

# Flatpak
if [ $flatpak = "yes" ]; then
	sudo apt install -y flatpak
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	flatpak remote-modify --subset=floss flathub
	#flatpak remote-modify --subset=verified_floss flathub
fi

############
## REMOVE ##
############

sudo apt purge -y kdeconnect

#############
## CLEANUP ##
#############

sudo apt autoremove -y
sudo apt autoclean -y

##########
## GTK3 ##
##########

mkdir -p $HOME/.config/gtk-3.0
printf "[Settings]
gtk-theme-name=Adwaita
gtk-icon-theme-name=Numix-Circle
gtk-application-prefer-dark-theme=true
" > $HOME/.config/gtk-3.0/settings.ini

###########
## AUDIO ##
###########

systemctl --user --now enable wireplumber.service

##########
## DOAS ##
##########

#username=$(whoami)
#sudo touch /etc/doas.conf
#echo "permit persist $username" | sudo tee -a /etc/doas.conf
#sudo chown root:root /etc/doas.conf
#sudo chmod 0400 /etc/doas.conf
sudo ln -s /usr/bin/sudo /usr/bin/doas

###########
## TMPFS ##
###########

echo "tmpfs   /tmp         tmpfs   rw,nodev,nosuid,mode=1777,size=4G          0  0" | sudo tee -a /etc/fstab

echo "-"
echo "All done!"
echo "Please restart your computer."
echo "To use polkit with i3, append the following to your config file:"
echo "exec --no-startup-id /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1"

exit 0
