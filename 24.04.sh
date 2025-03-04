#!/bin/bash

VERSION=0.0.2

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
    --flatpaks "com.bitwarden.desktop,org.localsend.localsend_app,com.usebruno.Bruno,com.ultimaker.cura,com.obsproject.Studio" \
    --debloat "yes" \
    --neaten "yes" \
    --apt_install "htop,aria2,tilix,libreoffice-writer,libreoffice-calc,libreoffice-impress,libreoffice-draw,remmina,gimp,virtualbox" \
    --apt-remove "gnome-terminal" \
    --theme "dark"

# Run Lavavel-Localenv
curl -o- https://raw.githubusercontent.com/calobyte/Laravel-Localenv/refs/heads/main/run.sh | bash

# install extra vs code extensions
code --install-extension streetsidesoftware.code-spell-checker
code --install-extension usernamehw.errorlens
code --install-extension esbenp.prettier-vscode

# theme stuff
code --install-extension tal7aouy.icons
code --install-extension GitHub.github-vscode-theme

# vs code user settings
wget wget https://raw.githubusercontent.com/calobyte/jump-start/refs/heads/main/vscode_settings.json -O $HOME/.config/Code/User/settings.json