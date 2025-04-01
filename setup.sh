!/bin/bash

read -p "Insira seu email do git: " git_config_user_email

########################################
# Installing essentials programs
sudo apt-get update
sudo apt-get install -y \
  build-essential git curl zsh tmux arandr \
  cmake ack-grep libssl-dev libreadline-dev \
  zlib1g-dev xclip ripgrep neovim exuberant-ctags libbz2-dev \
  libsqlite3-dev libffi-dev liblzma-dev libtk-img-dev
########################################

########################################
# Configuiring git
git config --global user.email $git_config_user_email
git config --global user.name "adriano"
git config --global core.excludesFile '~/.gitignore'
########################################

########################################
# Installing oh-my-zshell
curl -sSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash
echo "zsh" >> ~/.bashrc
########################################

echo "export GOPATH=\$HOME/Documents/git/go" >> ~/.zshrc
echo "export GOROOT=/usr/local/go" >> ~/.zshrc
echo "export PATH=\$PATH:\$GOPATH/bin" >> ~/.zshrc
echo "export PATH=\$PATH:\$GOROOT/bin" >> ~/.zshrc
echo "export FZF_DEFAULT_COMMAND='rg --files --follow --hidden'" >> ~/.zshrc

########################################
# Installing Docker
curl -fsSL https://get.docker.com | bash 

# Create permission to use docker
sudo groupadd docker
sudo usermod -aG docker $USER
########################################

########################################
# Installing Docker-Compose

DC_LATEST_VERSION=$(curl --silent \
  "https://api.github.com/repos/docker/compose/releases/latest" \
  | grep '"tag_name":' \
  | sed -E 's/.*"([^"]+)".*/\1/')

sudo curl -L "https://github.com/docker/compose/releases/download/$DC_LATEST_VERSION/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
########################################

########################################
# Generating asymmetric keys
echo "Generating a SSH Key..."
ssh-keygen -t rsa -b 4096 -C $git_config_user_email -N '' -f ~/.ssh/id_rsa <<< y
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub | xclip -selection clipboard
########################################

#######################################
# universal update script
git clone https://github.com/abertanha/dotfiles.git ~/Documents/git/dotfiles
echo "Coping universal update script"
sudo mv ./update /usr/local/bin
sudo chown root:root /usr/local/bin/update
ls -l /usr/local/bin/
read -p "Aperte enter para continuar"
#######################################

clear
echo "Please reboot your machine..."
