!/bin/bash

echo "Esse script é configurado para meu trabalho dev AGX"

read -p "Insira seu email do git: " git_config_user_email
read -p "Insira seu nome para git: " git_name

########################################
# Atualizando e instalando programas essenciais
sudo apt-get update
sudo apt-get install -y \
  build-essential git curl zsh tmux arandr \
  cmake ack-grep libssl-dev libreadline-dev \
  zlib1g-dev xclip ripgrep exuberant-ctags libbz2-dev \
  libsqlite3-dev libffi-dev liblzma-dev libtk-img-dev \
  wget gpg snapd
########################################
# Instalando Brave Browser
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt-get update
sudo apt-get install -y brave-browser

########################################
# Instalando Visual Studio Code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt-get update
sudo apt-get install -y code


sudo apt-get update
sudo apt-get install -y code

# Install extensions
code --install-extension esbenp.prettier-vscode        # Prettier
code --install-extension dbaeumer.vscode-eslint        # ESLint
code --install-extension denoland.vscode-deno          # Deno extension
code --install-extension mongodb.mongodb-vscode        # MongoDB extension
code --install-extension ms-vscode.vscode-typescript-next # TypeScript support
#code --install-extension ms-azuretools.vscode-docker   # Docker
#code --install-extension alexcvzz.vscode-sqlite        # SQLite
code --install-extension DigitalBrainstem.javascript-ejs # EJS Support
code --install-extension ritwickdey.LiveServer         # Live Server
code --install-extension PKief.material-icon-theme     # Material Icons
code --install-extension zhuangtongfa.Material-theme   # One Dark Pro

########################################
# Instalando MongoDB Compass (GUI apenas)
wget https://downloads.mongodb.com/compass/mongodb-compass_1.42.0_amd64.deb -O /tmp/mongodb-compass.deb
sudo dpkg -i /tmp/mongodb-compass.deb
sudo apt-get install -f
rm /tmp/mongodb-compass.deb

########################################
# Installing DBeaver CE and Postman
sudo snap install dbeaver-ce
sudo snap install postman


########################################
# Instalando KeePassXC
sudo apt-get install -y keepassxc

########################################
# Configuiring git
git config --global user.email $git_config_user_email
git config --global user.name $git_name
git config --global core.excludesFile '~/.gitignore'

########################################
# Installing Deno
curl -fsSL https://deno.land/install.sh | sh

# Add Deno to PATH in zshrc
echo 'export DENO_INSTALL="$HOME/.deno"' >> ~/.zshrc
echo 'export PATH="$DENO_INSTALL/bin:$PATH"' >> ~/.zshrc

# Add Deno to current session
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

########################################
# Installing Node.js via nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install latest LTS Node.js and set as default
nvm install --lts
nvm use --lts
nvm alias default 'lts/*'

# Add nvm to zshrc
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.zshrc
echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> ~/.zshrc

########################################
# Installing oh-my-zshell
curl -sSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash
echo "zsh" >> ~/.bashrc

echo "export GOPATH=\$HOME/Documents/git/go" >> ~/.zshrc
echo "export GOROOT=/usr/local/go" >> ~/.zshrc
echo "export PATH=\$PATH:\$GOPATH/bin" >> ~/.zshrc
echo "export PATH=\$PATH:\$GOROOT/bin" >> ~/.zshrc
echo "export FZF_DEFAULT_COMMAND='rg --files --follow --hidden'" >> ~/.zshrc

########################################
# Generating asymmetric keys
echo "Generating a SSH Key..."
ssh-keygen -t rsa -b 4096 -C $git_config_user_email -N '' -f ~/.ssh/id_rsa <<< y
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub | xclip -selection clipboard
########################################

#######################################
# universal update script
git clone https://github.com/abertanha/dotfiles.git ~/Documentos/git/dotfiles
echo "Coping universal update script"
sudo mv ~/Documentos/git/dotfiles/update /usr/local/bin
sudo chown root:root /usr/local/bin/update
ls -l /usr/local/bin/
read -p "Aperte enter para continuar"
#######################################

clear
echo "Please reboot your machine..."
