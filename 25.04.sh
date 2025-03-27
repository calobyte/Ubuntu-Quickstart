# #!/bin/bash

# # Global Vars
# OS_VERSION=24.04
# VERSION=0.2.23

# # Fetch all the named args
# while [ $# -gt 0 ]; do

#    if [[ $1 == *"--"* ]]; then
#         v="${1/--/}"
#         declare $v="$2"
#    fi

#   shift
# done

# clear 

# echo "----------------------------------------------------"
# echo "Welcome to Nubuntu $OS_VERSION (v$VERSION)"
# echo "=> The following will be installed:"
# echo " -> debs: $debs"
# echo " -> flatpaks: $flatpaks"
# if [ -n "$apt_install" ]; then
#   echo "=> the following apt install(s) will be invoked"
#   echo " -> $apt_install"
# fi
# if [ -n "$apt_remove" ]; then
#   echo "=> the following apt remove(s) will be invoked"
#   echo " -> $apt_remove"
# fi
# if [[ $debloat == "yes" ]]; then
#   echo "=> debloat"
# fi
# if [[ $neaten == "yes" ]]; then
#   echo "=> the shell will also be neatened"
# fi
# if [[ $theme == "dark" ]]; then
#   echo "=> dark theme will be set"
# fi
# echo "----------------------------------------------------"

DOWNLOAD_PATH=$HOME/Downloads/tmp

snap_installs="bruno cura-slicer kdenlive onlyoffice-desktopeditors gimp bitwarden dbeaver-ce obs-studio localsend xournalpp"
snap_removes="firefox"
apt_installs="htop aria2 tilix vlc"
apt_removes="gnome-user-docs yelp gnome-terminal"

mkdir $DOWNLOAD_PATH

sudo apt update
sudo apt upgrade -yq

sudo apt install -yq $apt_installs
sudo apt install -yq $apt_removes

sudo snap remove $snap_removes
sudo snap install $snap_installs

# INSTALL: VS CODE
echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections
sudo apt-get install -yq wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
rm -f packages.microsoft.gpg
sudo apt install -yq apt-transport-https
sudo apt update
sudo apt install -yq code

# INSTALL: Chrome
wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O $DOWNLOAD_PATH/chrome.deb
sudo apt install -yq $DOWNLOAD_PATH/chrome.deb


# INSTALL: docker
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
sudo apt-get update
sudo apt-get install -yq ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get -yq install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER


# dock pinned apps
gsettings set org.gnome.shell favorite-apps "[ 'google-chrome.desktop', 'com.bitwarden.desktop.desktop', 'org.gnome.Nautilus.desktop' ]"

# menu folders
add_gnome_menu_folders() {
folder_name=$1
readable_name=$2
apps=$3

gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/$folder_name/ name "$readable_name"
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/$folder_name/ apps "[ $apps ]"

}

add_gnome_menu_folders "system" "🖥️ System" "'org.gnome.Logs.desktop', 'org.gnome.PowerStats.desktop', 'org.gnome.SystemMonitor.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.DiskUtility.desktop', 'org.gnome.Tecla.desktop', 'org.gnome.baobab.desktop', 'org.gnome.seahorse.Application.desktop', 'org.gnome.Settings.desktop', 'org.gnome.OnlineAccounts.OAuth2.desktop', 'software-properties-drivers', 'software-properties-gtk', 'update-manager', 'nm-connection-editor', 'gnome-session-properties', 'gnome-language-selector', 'gnome-session-properties.desktop', 'nm-connection-editor.desktop', 'gnome-language-selector.desktop', 'update-manager.desktop', 'software-properties-gtk.desktop', 'software-properties-drivers.desktop', 'htop.desktop'"

add_gnome_menu_folders "accessories" "🖊️ Accessories" "'org.gnome.font-viewer.desktop', 'org.gnome.clocks.desktop', 'org.gnome.Characters.desktop', 'org.gnome.Calculator.desktop', 'org.gnome.eog.desktop', 'org.gnome.TextEditor.desktop', 'org.gnome.Evince', 'org.gnome.Evince.desktop', 'org.gnome.Software.desktop'"

add_gnome_menu_folders "dev" "⚒️ Dev" "'code.desktop', 'dbeaver-ce_dbeaver-ce.desktop'"

gsettings set org.gnome.desktop.app-folders folder-children "[ 'accessories', 'system', 'dev' ]"

# theme and shell
mkdir -p $HOME/Pictures/Wallpapers
# wallpaper credit : https://wallhaven.cc/w/g82vvq
wget https://raw.githubusercontent.com/calobyte/nubuntu/refs/heads/main/wallpapers/24.04/dark.jpg -O $HOME/Pictures/Wallpapers/dark.jpeg
gsettings set org.gnome.desktop.background picture-uri-dark file://$HOME/Pictures/Wallpapers/dark.jpeg

wget https://raw.githubusercontent.com/calobyte/nubuntu/refs/heads/main/fonts/jetbrains-fonts.tar -O $DOWNLOAD_PATH/jetbrains-fonts.tar
sudo tar -xf $DOWNLOAD_PATH/jetbrains-fonts.tar -C /usr/share/fonts/truetype/ --wildcards "*.ttf"
fc-cache -f

gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-blue-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Yaru-blue'
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.interface enable-hot-corners true
gsettings set org.gnome.desktop.interface monospace-font-name 'Jetbrains Mono 13'

sudo apt autoremove -yq
rm -rf $DOWNLOAD_PATH

# generate new ssh key
ssh-keygen -f $HOME/.ssh/id_rsa -N ""

# Run Lavavel-Localenv
curl -o- https://raw.githubusercontent.com/calobyte/Laravel-Localenv/refs/heads/main/run.sh | bash

# install extra vs code extensions
code --install-extension streetsidesoftware.code-spell-checker
code --install-extension usernamehw.errorlens
code --install-extension esbenp.prettier-vscode
code --install-extension eamodio.gitlens

# vs code theme stuff
code --install-extension Catppuccin.catppuccin-vsc
code --install-extension Catppuccin.catppuccin-vsc-icons

# vs code user settings
wget wget https://raw.githubusercontent.com/calobyte/jump-start/refs/heads/main/vscode_settings.json -O $HOME/.config/Code/User/settings.json

# tilix fix
sudo ln -s /etc/profile.d/vte-2.91.sh /etc/profile.d/vte.sh
echo "if [ \$TILIX_ID ] || [ \$VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi" >> $HOME/.bashrc

# install ollama
curl -fsSL https://ollama.com/install.sh | sh

# dock
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 40
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock multi-monitor true
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'previews'
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false

# no notifications on lock screen
gsettings set org.gnome.desktop.notifications show-in-lock-screen true
