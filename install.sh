#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Variables
USERNAME=intart

# Update system
dnf update -y

 Set hostname
hostnamectl set-hostname $USERNAME-pc

# Install graphical enviroment
dnf groupinstall base-x -y
dnf install lightdm lightdm-gtk -y
systemctl enable lightdm.service
systemctl set-default graphical.target

# Install some utilities
dnf install git wget curl stow mlocate zip unzip tar wireless-tools crda network-manager-applet \
NetworkManager-wifi wpa_supplicant sqlite pciutils usbutils snapd -y

sudo ln -s /var/lib/snapd/snap /snap

# Configure Git
dnf install git -y
sudo -u $USERNAME git config --global user.name  "Víctor Peñaló"
sudo -u $USERNAME git config --global user.email  "victor.alexander23@gmail.com"

# Set configuration files
sudo -u $USERNAME git clone https://github.com/intart-do/.dotfiles.git /home/$USERNAME/.dotfiles
cd /home/$USERNAME/.dotfiles
sudo -u $USERNAME stow dunst i3 neovim polybar rofi terminator zsh

# Install some utilities
dnf install wget curl stow mlocate zip unzip tar wireless-tools crda network-manager-applet \
NetworkManager-wifi wpa_supplicant sqlite pciutils usbutils -y

dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

dnf install gnome-keyring-pam gnome-keyring libgnome-keyring polkit polkit-gnome libsecret \
gvfs gvfs-mtp gvfs-nfs gvfs-fuse gvfs-smb ntfs-3g \
pulseaudio pulseaudio-esound-compat alsa-plugins-pulseaudio pulseaudio-module-x11 pulseaudio-module-gconf pulseaudio-utils \
dejavu-sans-mono-fonts liberation-*-fonts \
lxappearance qt5ct adwaita-qt4 adwaita-qt5 \
gstreamer1-plugins-base gstreamer1-plugins-good gstreamer1-plugins-ugly gstreamer1-plugins-bad-free gstreamer1-plugins-bad-free \
gstreamer1-plugins-bad-freeworld gstreamer1-plugins-bad-free-extras ffmpeg -y

# Install some programs
dnf install nautilus terminator timeshift firefox keepassxc libreoffice evince inkscape kicad freecad \
gnome-boxes gnome-calculator evolution kde-connect nextcloud-client neovim python{2,3}-neovim -y

### Install i3-gaps
cd /tmp
wget https://github.com/intart-do/rpmbuild/raw/master/RPMS/i3-gaps-4.16.1-1.fc29.x86_64.rpm
dnf install i3-gaps-4.16.1-1.fc29.x86_64.rpm -y
dnf install rofi i3status i3lock dunst compton feh -y

### Install polybar
cd /tmp
wget https://github.com/intart-do/rpmbuild/raw/master/RPMS/polybar-3.3.1-1.x86_64.rpm
dnf install polybar-3.3.1-1.x86_64.rpm -y

### Install Spotify
snap install spotify

### Install zsh
dnf install zsh -y

#### oh-my-zsh
sudo -u $USERNAME git clone https://github.com/robbyrussell/oh-my-zsh.git /home/$USERNAME/.oh-my-zsh

#### zsh-autosuggestions
sudo -u $USERNAME git clone https://github.com/zsh-users/zsh-autosuggestions /home/$USERNAME/.oh-my-zsh/custom/plugins/zsh-autosuggestions

#### zsh-completions 
sudo -u $USERNAME git clone https://github.com/zsh-users/zsh-completions /home/$USERNAME/.oh-my-zsh/custom/plugins/zsh-completions

#### zsh-syntax-highlighting
sudo -u $USERNAME git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/$USERNAME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

#### zsh-history-substring-search
sudo -u $USERNAME git clone https://github.com/zsh-users/zsh-history-substring-search /home/$USERNAME/.oh-my-zsh/custom/plugins/zsh-history-substring-search

### Fantasque Fonts
cd /tmp
wget https://github.com/belluzj/fantasque-sans/releases/download/v1.7.2/FantasqueSansMono-Normal.zip
unzip -o FantasqueSansMono-Normal.zip
cd OTF
mkdir /usr/share/fonts/fantasque
cp *.otf /usr/share/fonts/fantasque

### Material Design Fonts
cd /tmp
wget -O master.zip https://codeload.github.com/Templarian/MaterialDesign-Webfont/zip/master
unzip -o master.zip
cd MaterialDesign-Webfont-master/fonts/
rm -R /usr/share/fonts/material-design
mkdir /usr/share/fonts/material-design
cp *.ttf /usr/share/fonts/material-design

### Awesome For Desktop Fonts 
cd /tmp
wget https://use.fontawesome.com/releases/v5.8.1/fontawesome-free-5.8.1-desktop.zip
unzip -o fontawesome-free-5.8.1-desktop.zip
rm -R /usr/share/fonts/awesome
mkdir /usr/share/fonts/awesome
cd fontawesome-free-5.8.1-desktop/otfs 
cp *.otf /usr/share/fonts/awesome

### Fira Mono Nerd Fonts
cd tmp
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/FiraMono.zip
unzip -o FiraMono.zip 
rm -R /usr/share/fonts/fira-mono
mkdir /usr/share/fonts/fira-mono
cp Fura\ Mono\ * /usr/share/fonts/fira-mono
fc-cache -f

echo 'The End'
echo 'Now Reboot'
