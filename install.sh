#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Variables
USERNAME=xxxxx
GITUSER="xxxxx"
GITEMAIL="xxxxx@xxxxx.com"

# Update system
dnf update -y

# Set hostname
hostnamectl set-hostname $USERNAME-pc

# Install graphical enviroment
dnf groupinstall base-x -y
dnf install lightdm lightdm-gtk -y
systemctl enable lightdm.service
systemctl set-default graphical.target

# Configure Git
dnf install git -y
sudo -u $USERNAME git config --global user.name $GITUSER 
sudo -u $USERNAME git config --global user.email  $GITEMAIL

# Set configuration files
sudo -u $USERNAME git clone https://github.com/intart-do/.dotfiles.git /home/$USERNAME/.dotfiles
cd /home/$USERNAME/.dotfiles
sudo -u $USERNAME stow dunst i3 neovim polybar rofi xfce4-terminal zsh

# Install some utilities
dnf install wget curl stow mlocate zip unzip tar wireless-tools crda network-manager-applet \
NetworkManager-wifi openvpn NetworkManager-openvpn NetworkManager-openvpn-gnome wpa_supplicant sqlite util-linux-user pciutils usbutils flatpak -y

dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

dnf install openssh-askpass gnome-keyring-pam gnome-keyring libgnome-keyring polkit polkit-gnome libsecret \
gvfs gvfs-mtp gvfs-nfs gvfs-fuse gvfs-smb ntfs-3g \
pulseaudio pulseaudio-esound-compat alsa-plugins-pulseaudio pulseaudio-module-x11 pulseaudio-module-gconf pulseaudio-utils \
pavucontrol dejavu-sans-mono-fonts liberation-*-fonts \
lxappearance qt5ct adwaita-qt4 adwaita-qt5 \
gstreamer1-plugins-base gstreamer1-plugins-good gstreamer1-plugins-ugly gstreamer1-plugins-bad-free gstreamer1-plugins-bad-free \
gstreamer1-plugins-bad-freeworld gstreamer1-plugins-bad-free-extras ffmpeg -y

# Install some programs
dnf install xfce4-terminal timeshift file-roller firefox keepassxc libreoffice evince -y
dnf install inkscape kicad freecad -y
dnf install evolution kde-connect nextcloud-client neovim python{2,3}-neovim -y

# Install i3-gaps
cd /tmp
wget https://github.com/intart-do/rpmbuild/raw/master/RPMS/i3-gaps-4.16.1-1.fc29.x86_64.rpm
dnf install i3-gaps-4.16.1-1.fc29.x86_64.rpm -y
dnf install rofi i3status i3lock dunst compton feh -y

# Install polybar
cd /tmp
wget https://github.com/intart-do/rpmbuild/raw/master/RPMS/polybar-3.3.1-1.x86_64.rpm
dnf install polybar-3.3.1-1.x86_64.rpm -y

# Install Brave Browser
dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
dnf install brave-keyring brave-browser -y

# Install KVM and Virtual Machine Manager
dnf install bridge-utils libvirt virt-install qemu-kvm virt-top libguestfs-tools virt-manager -y
systemctl enable libvirtd

# Install Spotify
flatpak install -y --from https://flathub.org/repo/appstream/com.spotify.Client.flatpakref

# Install zsh
dnf install zsh -y

# oh-my-zsh
sudo -u $USERNAME git clone https://github.com/robbyrussell/oh-my-zsh.git /home/$USERNAME/.oh-my-zsh

# zsh-autosuggestions
sudo -u $USERNAME git clone https://github.com/zsh-users/zsh-autosuggestions /home/$USERNAME/.oh-my-zsh/custom/plugins/zsh-autosuggestions

# zsh-completions 
sudo -u $USERNAME git clone https://github.com/zsh-users/zsh-completions /home/$USERNAME/.oh-my-zsh/custom/plugins/zsh-completions

# zsh-syntax-highlighting
sudo -u $USERNAME git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/$USERNAME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# zsh-history-substring-search
sudo -u $USERNAME git clone https://github.com/zsh-users/zsh-history-substring-search /home/$USERNAME/.oh-my-zsh/custom/plugins/zsh-history-substring-search

# Fantasque Fonts
cd /tmp
wget https://github.com/belluzj/fantasque-sans/releases/download/v1.7.2/FantasqueSansMono-Normal.zip
unzip -o FantasqueSansMono-Normal.zip
cd OTF
mkdir /usr/share/fonts/fantasque
cp *.otf /usr/share/fonts/fantasque

# Material Design Fonts
cd /tmp
wget -O master.zip https://codeload.github.com/Templarian/MaterialDesign-Webfont/zip/master
unzip -o master.zip
cd MaterialDesign-Webfont-master/fonts/
rm -R /usr/share/fonts/material-design
mkdir /usr/share/fonts/material-design
cp *.ttf /usr/share/fonts/material-design

# Awesome For Desktop Fonts 
cd /tmp
wget https://use.fontawesome.com/releases/v5.8.1/fontawesome-free-5.8.1-desktop.zip
unzip -o fontawesome-free-5.8.1-desktop.zip
rm -R /usr/share/fonts/awesome
mkdir /usr/share/fonts/awesome
cd fontawesome-free-5.8.1-desktop/otfs 
cp *.otf /usr/share/fonts/awesome

# Fira Mono Nerd Fonts
cd tmp
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/FiraMono.zip
unzip -o FiraMono.zip 
rm -R /usr/share/fonts/fira-mono
mkdir /usr/share/fonts/fira-mono
cp Fura\ Mono\ * /usr/share/fonts/fira-mono
fc-cache -f

# Create default user folders
sudo -u $USERNAME xdg-user-dirs-update

# Change shell
sudo -u $USERNAME chsh -s $(which zsh)

echo 'The End'
echo 'Now Reboot'

