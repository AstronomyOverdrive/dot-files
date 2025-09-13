#!/bin/sh

# Assuming you've installed using netinstall with the console enviroment

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
sudo apt install -y doas
sudo apt install -y flameshot
sudo apt install -y geany
sudo apt install -y geany-plugins
sudo apt install -y gimp
sudo apt install -y git
sudo apt install -y gvfs
sudo apt install -y i3
sudo apt install -y icedove
sudo apt install -y inkscape
sudo apt install -y kdenlive
sudo apt install -y krita
sudo apt install -y libreoffice
sudo apt install -y lightdm
sudo apt install -y lightdm-gtk-greeter
sudo apt install -y mpv
#sudo apt install -y nodejs
#sudo apt install -y npm
sudo apt install -y papirus-icon-theme
sudo apt install -y parcellite
sudo apt install -y pipewire
sudo apt install -y pipewire-pulse
sudo apt install -y policykit-1-gnome
sudo apt install -y ristretto
sudo apt install -y thunar
sudo apt install -y tlp
sudo apt install -y vim
sudo apt install -y wireplumber
sudo apt install -y xclip
sudo apt install -y xfce4-terminal
sudo apt install -y xinit
sudo apt install -y xorg
sudo apt install -y xserver-xorg-input-wacom

# Golang
cd $HOME
wget https://go.dev/dl/go1.25.0.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.25.0.linux-amd64.tar.gz
rm go*.tar.gz
echo "export PATH=\$PATH:/usr/local/go/bin" >> .profile

# NodeJS / NPM / TypeScript
cd $HOME
curl https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh > nvm.sh
chmod +x nvm.sh
/bin/bash nvm.sh
. .nvm/nvm.sh
rm nvm.sh
nvm install node
npm install -g typescript

# .NET
cd $HOME
wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt-get update && sudo apt-get install -y dotnet-sdk-9.0

##########
## GTK3 ##
##########

mkdir -p $HOME/.config/gtk-3.0
printf "[Settings]
gtk-theme-name=Adwaita
gtk-icon-theme-name=Papirus-Dark
gtk-application-prefer-dark-theme=true
" > $HOME/.config/gtk-3.0/settings.ini

###########
## AUDIO ##
###########

systemctl --user --now enable wireplumber.service

##########
## DOAS ##
##########

username=$(whoami)
sudo touch /etc/doas.conf
echo "permit persist $username" | sudo tee -a /etc/doas.conf
sudo chown root:root /etc/doas.conf
sudo chmod 0400 /etc/doas.conf
# sudo ln -s /usr/bin/sudo /usr/bin/doas

echo "-"
echo "All done!"

exit 0
