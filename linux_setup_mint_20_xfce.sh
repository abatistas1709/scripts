#!/bin/sh

# repositorio Chrome
if ! [ -e /etc/apt/sources.list.d/google-chrome.list ]; then
   sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
   wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
fi

# repositorio Vivaldi
if ! [ -e /etc/apt/sources.list.d/vivaldi-archive.list ]; then
   wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub | gpg --dearmor | sudo dd of=/usr/share/keyrings/vivaldi-browser.gpg
   echo "deb [signed-by=/usr/share/keyrings/vivaldi-browser.gpg arch=$(dpkg --print-architecture)] https://repo.vivaldi.com/archive/deb/ stable main" | sudo dd of=/etc/apt/sources.list.d/vivaldi-archive.list
fi

# repositorio Kubernetes
if ! [ -e /etc/apt/sources.list.d/kubernetes.list ]; then
   sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
   echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
fi

# repositorio Brave
#if ! [ -e /etc/apt/sources.list.d/brave-browser-release.list ]; then
#   curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
#   echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
#fi

# repositorio Virtualbox
if ! [ -e /etc/apt/sources.list.d/virtualbox.list ]; then
   sudo sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian focal contrib" >> /etc/apt/sources.list.d/virtualbox.list'
   wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
fi

# repositorio Visual Studio Code
if ! [ -e /etc/apt/sources.list.d/vscode.list ]; then
   sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
   curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
   sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
fi

# repositorio AnyDesk
if ! [ -e /etc/apt/sources.list.d/anydesk-stable.list ]; then
   sudo sh -c 'echo "deb http://deb.anydesk.com/ all main" > /etc/apt/sources.list.d/anydesk-stable.list'
   wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
fi

# repositorio DBeaver
if ! [ -e /etc/apt/sources.list.d/dbeaver.list ]; then
  wget -O - https://dbeaver.io/debs/dbeaver.gpg.key | sudo apt-key add -
  echo "deb https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
fi

# repositorio Ansible
if ! [ -e /etc/apt/sources.list.d/ansible.list ]; then
  echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu focal main" | sudo tee /etc/apt/sources.list.d/ansible.list
  # sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
fi

sudo apt update -y && sudo apt install -y apt-transport-https

# chave pública "Spotify Public Repository Signing Key <tux@spotify.com>"
# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4773BD5E130D1D45

# instalacao de pacotes
sudo apt install -y google-chrome-stable vivaldi-stable htop virtualbox-6.1 remmina remmina-plugin-rdp remmina-plugin-vnc zsh \
  kubectl thunar-dropbox-plugin nmap code skypeforlinux vim variety anydesk taskwarrior kmymoney flameshot rofi spotify-client \
  papirus-icon-theme tmux html2text jq xfce4-genmon-plugin dbeaver-ce ansible
  # qt5-style-kvantum qt5-style-kvantum-themes openfortivpn network-manager-fortisslvpn network-manager-fortisslvpn-gnome 
  # brave-browser

# substituicao Java
sudo apt purge -y openjdk-11-* && sudo apt install -y openjdk-8-jdk

# remove repositorio duplicado
if [ -e /etc/apt/sources.list.d/google.list ]; then sudo rm /etc/apt/sources.list.d/google.list && sudo apt update -y; fi

# requisitos para montagem de particoes Windows
if ! [ -d "/windows/C" ]; then
   sudo mkdir /windows/C -p && sudo mkdir /windows/D -p
   sudo cp /etc/fstab /etc/fstab.orig
fi

# passos para configurar
# 1 - aparencia
# 1.1 - tema Arc Darker
# 1.2 - ícones: Papirus
# 1.3 - fontes: Ubuntu 9 / Ubuntu Mono 10
# 1.4 - ajustar configuracao Qt5 (echo "export QT_STYLE_OVERRIDE=kvantum" >> ~/.profile; Kvantum; qt5ct)
# 2 - painel
# 2.1 - formato relógio: %a %d %b, %T
# 2.2 - configurar favoritos: KeePassXC, Chrome, Spotify, Tilix, Gerenciador de tarefas
# 3 - montar particoes Windows
# 3.1 - sudo blkid
# 3.2 - editar /etc/fstab
# 3.3 - UUID=<id>  /windows/<drive>  ntfs-3g  defaults,windows_names,locale=pt_BR.utf8  0 0
# 3.4 - sudo mount -a
# 3.5 - 'linkar' pasta Downloads
# 4 - configurar Wallpapers
# 5 - configurar Timeshift
# 6 - Telegram (Telegram -startintray)
