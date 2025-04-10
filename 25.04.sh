# #!/bin/bash

DOWNLOAD_PATH=$HOME/Downloads/tmp

snap_installs="bruno cura-slicer kdenlive onlyoffice-desktopeditors gimp bitwarden dbeaver-ce obs-studio localsend xournalpp darktable"
snap_removes="firefox"
apt_installs="htop aria2 tilix vlc git gnome-software-plugin-snap remmina"
apt_removes="gnome-user-docs yelp gnome-terminal"

mkdir $DOWNLOAD_PATH

sudo apt-get update
sudo apt-get upgrade -yq

sudo apt-get install -yq $apt_installs
sudo apt-get remove -yq $apt_removes

sudo snap remove $snap_removes
sudo snap install $snap_installs

# INSTALL: VS CODE
echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections
sudo apt-get install -yq wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
rm -f packages.microsoft.gpg
sudo apt-get install -yq apt-transport-https
sudo apt-get update
sudo apt-get install -yq code

# INSTALL: Chrome
wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O $DOWNLOAD_PATH/chrome.deb
sudo apt-get install -yq $DOWNLOAD_PATH/chrome.deb


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
gsettings set org.gnome.shell favorite-apps "[ 'google-chrome.desktop', 'bitwarden_bitwarden.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Software.desktop', 'org.remmina.Remmina.desktop' ]"

# menu folders
add_gnome_menu_folders() {
        folder_name=$1
        readable_name=$2
        apps=$3

        gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/$folder_name/ name "$readable_name"
        gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/$folder_name/ apps "[ $apps ]"
}

add_gnome_menu_folders "system" "🖥️ System" "'org.gnome.Logs.desktop', 'org.gnome.PowerStats.desktop', 'org.gnome.SystemMonitor.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.DiskUtility.desktop', 'org.gnome.Tecla.desktop', 'org.gnome.baobab.desktop', 'org.gnome.seahorse.Application.desktop', 'org.gnome.Settings.desktop', 'org.gnome.OnlineAccounts.OAuth2.desktop', 'software-properties-drivers', 'software-properties-gtk', 'update-manager', 'nm-connection-editor', 'gnome-session-properties', 'gnome-language-selector', 'gnome-session-properties.desktop', 'nm-connection-editor.desktop', 'gnome-language-selector.desktop', 'update-manager.desktop', 'software-properties-gtk.desktop', 'software-properties-drivers.desktop', 'htop.desktop', 'desktop-security-center_desktop-security-center.desktop', 'firmware-updater_firmware-updater.desktop', 'org.gnome.Sysprof.desktop'"

add_gnome_menu_folders "accessories" "🗂️ Accessories" "'org.gnome.clocks.desktop', 'org.gnome.Calculator.desktop', 'org.gnome.eog.desktop', 'org.gnome.TextEditor.desktop', 'org.gnome.Evince', 'org.gnome.Evince.desktop', 'org.gnome.Papers.desktop'"

add_gnome_menu_folders "dev" "💡 Dev" "'code.desktop', 'dbeaver-ce_dbeaver-ce.desktop', 'bruno_bruno.desktop'"

add_gnome_menu_folders "utils" "📏 Utils" "'localsend_localsend.desktop', 'com.gexperts.Tilix.desktop', 'org.gnome.Characters.desktop', 'org.gnome.font-viewer.desktop', 'snap-store_snap-store.desktop'"

add_gnome_menu_folders "media" "💽 Media" "'vlc.desktop'"

add_gnome_menu_folders "create" "⚒️ Create" "'cura-slicer_cura.desktop', 'obs-studio_obs-studio.desktop', 'gimp_gimp.desktop', 'kdenlive_kdenlive.desktop', 'darktable_darktable.desktop'"

add_gnome_menu_folders "office" "💼 Office" "'onlyoffice-desktopeditors_onlyoffice-desktopeditors.desktop', 'xournalpp_xournalpp.desktop'"

gsettings set org.gnome.desktop.app-folders folder-children "[ 'accessories', 'system', 'dev', 'utils', 'media', 'office', 'create' ]"

# theme and shell
mkdir -p $HOME/Pictures/Wallpapers

wget https://images.pexels.com/photos/325044/pexels-photo-325044.jpeg -O $HOME/Pictures/Wallpapers/wallpaper.jpeg
gsettings set org.gnome.desktop.background picture-uri-dark file://$HOME/Pictures/Wallpapers/wallpaper.jpeg

wget https://raw.githubusercontent.com/calobyte/Ubuntu-Quickstart/refs/heads/main/fonts/jetbrains-fonts.tar -O $DOWNLOAD_PATH/jetbrains-fonts.tar
sudo tar -xf $DOWNLOAD_PATH/jetbrains-fonts.tar -C /usr/share/fonts/truetype/ --wildcards "*.ttf"
fc-cache -f

gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-red-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Yaru-red-dark'
gsettings set org.gnome.desktop.interface accent-color 'red'
gsettings set org.gnome.Papers.Default annot-color 'red'
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.interface enable-hot-corners true
gsettings set org.gnome.desktop.interface monospace-font-name 'Jetbrains Mono 13'

sudo apt-get autoremove -yq
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
code --install-extension GitHub.github-vscode-theme
code --install-extension Catppuccin.catppuccin-vsc-icons

# vs code user settings
wget wget https://raw.githubusercontent.com/calobyte/Ubuntu-Quickstart/refs/heads/main/vscode_settings.json -O $HOME/.config/Code/User/settings.json

# tilix fix
sudo ln -s /etc/profile.d/vte-2.91.sh /etc/profile.d/vte.sh
echo "if [ \$TILIX_ID ] || [ \$VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi" >> $HOME/.bashrc

# install ollama
# curl -fsSL https://ollama.com/install.sh | sh

# dock
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 40
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock multi-monitor true
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'previews'
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false

# no notifications on lock screen
gsettings set org.gnome.desktop.notifications show-in-lock-screen true
