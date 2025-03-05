#!/bin/bash

VERSION=0.1.10

echo "*******************************"
echo "Jump Start (v$VERSION)"
echo "*******************************"

# basic update and upgrade and make sure curl is installed
sudo apt update && sudo apt upgrade -yq

# generate new ssh key
ssh-keygen -f $HOME/.ssh/id_rsa -N ""

# Run Nubuntu
curl -o- https://raw.githubusercontent.com/calobyte/Nubuntu/refs/heads/main/24.04.sh | bash -s -- \
    --debs "vscode,chrome,docker,dbeaver" \
    --flatpaks "com.bitwarden.desktop,org.localsend.localsend_app,com.usebruno.Bruno,com.ultimaker.cura,com.obsproject.Studio,com.github.xournalpp.xournalpp,org.kde.kdenlive,page.kramo.Sly" \
    --debloat "yes" \
    --neaten "yes" \
    --apt_install "htop,aria2,tilix,libreoffice-writer,libreoffice-calc,libreoffice-impress,libreoffice-draw,remmina,gimp,virtualbox,vlc" \
    --apt_remove "gnome-terminal" \
    --theme "dark"

# Run Lavavel-Localenv
curl -o- https://raw.githubusercontent.com/calobyte/Laravel-Localenv/refs/heads/main/run.sh | bash

# install extra vs code extensions
code --install-extension streetsidesoftware.code-spell-checker
code --install-extension usernamehw.errorlens
code --install-extension esbenp.prettier-vscode
code --install-extension eamodio.gitlens

# theme stuff
code --install-extension tal7aouy.icons
code --install-extension GitHub.github-vscode-theme

# vs code user settings
wget wget https://raw.githubusercontent.com/calobyte/jump-start/refs/heads/main/vscode_settings.json -O $HOME/.config/Code/User/settings.json

# update app menu folders
add_gnome_menu_folders() {
    folder_name=$1
    readable_name=$2
    apps=$3

    gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/$folder_name/ name "$readable_name"
    gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/$folder_name/ apps "[ $apps ]"

}

add_gnome_menu_folders "office" "✍ Office" "'libreoffice-impress.desktop', 'libreoffice-draw.desktop', 'libreoffice-calc.desktop', 'libreoffice-math.desktop', 'libreoffice-startcenter.desktop', 'libreoffice-writer.desktop', 'com.github.xournalpp.xournalpp.desktop', 'gitlab.adhami3310.Converter'"
add_gnome_menu_folders "create" "🎨 Create" "'gimp.desktop', 'com.obsproject.Studio.desktop', 'org.kde.kdenlive.desktop', 'page.kramo.Sly.desktop', 'gitlab.adhami3310.Converter'"
add_gnome_menu_folders "remote" "🛜 Remote" "'org.remmina.Remmina.desktop', 'org.localsend.localsend_app.desktop'"
add_gnome_menu_folders "media" "⏯️ Media" "'vlc.desktop'"

# update dev folder
dev_folder="$(gsettings get org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/dev/ apps)"
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/dev/ apps "[${dev_folder:1:-1} , 'virtualbox.desktop', 'com.ultimaker.cura.desktop', 'com.usebruno.Bruno.desktop']"

# update settings folder
system_folder="$(gsettings get org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/system/ apps)"
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/system/ apps "[${system_folder:1:-1}, 'com.gexperts.Tilix.desktop']"

# update menu folders
gsettings set org.gnome.desktop.app-folders folder-children "[ 'accessories', 'system', 'dev', 'office', 'create', 'remote', 'media' ]"

# tilix fix
sudo ln -s /etc/profile.d/vte-2.91.sh /etc/profile.d/vte.sh
echo "if [ \$TILIX_ID ] || [ \$VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi" >> $HOME/.bashrc

# install ollama
curl -fsSL https://ollama.com/install.sh | sh

# dock
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock autohide true
gsettings set org.gnome.shell.extensions.dash-to-dock autohide-in-fullscreen true
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 40
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock multi-monitor true
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'previews'
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false

