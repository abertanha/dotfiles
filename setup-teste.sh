#!/bin/bash

echo "Esse script é configurado para meu trabalho dev AGX"
echo "Ele instalará ambientes, ferramentas de desenvolvimento e configurará o Git."

read -p "Insira seu email do git: " git_config_user_email
read -p "Insira seu nome para git: " git_name

########################################
# 1. ATUALIZANDO E INSTALANDO PROGRAMAS ESSENCIAIS
########################################
echo "Atualizando lista de pacotes e instalando pacotes essenciais..."
sudo apt-get update
sudo apt-get install -y \
  build-essential git curl zsh tmux arandr \
  cmake ack-grep libssl-dev libreadline-dev \
  zlib1g-dev xclip ripgrep exuberant-ctags libbz2-dev \
  libsqlite3-dev libffi-dev liblzma-dev libtk-img-dev \
  wget gpg snapd

########################################
# 2. INSTALANDO BRAVE BROWSER
########################################
echo "Instalando Brave Browser..."
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt-get update
sudo apt-get install -y brave-browser

########################################
# 3. INSTALANDO VS CODE (ESTÁVEL) E VS CODE (INSIDERS)
########################################
echo "Configurando repositório da Microsoft para VS Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

echo "Instalando VS Code (Estável) e VS Code (Insiders) via apt..."
sudo apt-get update
sudo apt-get install -y code code-insiders # Instala ambas as versões

# Lista central de extensões
EXTENSIONS=(
  "dbaeumer.vscode-eslint"
  "denoland.vscode-deno"
  "mongodb.mongodb-vscode"
  "ms-vscode.vscode-typescript-next"
  "DigitalBrainstem.javascript-ejs"
  "ritwickdey.LiveServer"
  "PKief.material-icon-theme"
  "zhuangtongfa.Material-theme"
  "vincas.highlight-matching-tag"
  "eamodio.gitlens"
  "GitHub.vscode-pull-request-github"
  "yzhang.markdown-all-in-one"
  "Shan.code-settings-sync"
  "ms-vsls.vsls"
)

echo "Instalando extensões para o VS Code (Estável)..."
for extension in "${EXTENSIONS[@]}"; do
  echo "Instalando $extension..."
  code --install-extension "$extension" --force
done

echo "Instalando extensões para o VS Code (Insiders)..."
for extension in "${EXTENSIONS[@]}"; do
  echo "Instalando $extension..."
  code-insiders --install-extension "$extension" --force
done

echo "----------------------------------------------------------------"
echo "IMPORTANTE: Configure seus editores:"
echo
echo "Para o VS Code (Estável) focar no Node.js:"
echo "1. Abra o VS Code (Estável)."
echo "2. Abra a paleta de comandos (Ctrl+Shift+P)."
echo "3. Digite 'Extensions: Show Installed Extensions'."
echo "4. Encontre 'Deno' na lista e clique no ícone de engrenagem."
echo "5. Selecione 'Disable (Workspace)' para desativá-lo nos seus projetos Node."
echo
echo "Para o VS Code Insiders focar no Deno:"
echo "1. Abra o VS Code Insiders."
echo "2. Abra um projeto/pasta que usará Deno."
echo "3. Abra a paleta de comandos (Ctrl+Shift+P)."
echo "4. Digite e selecione 'Deno: Initialize Workspace Configuration'."
echo "5. Isso ativará o Deno para este workspace."
echo "----------------------------------------------------------------"
read -p "Pressione Enter para continuar..."

########################################
# 4. INSTALANDO MONGODB COMPASS E MONGOSH
########################################
echo "Instalando MongoDB Compass e MongoSH..."
wget https://downloads.mongodb.com/compass/mongodb-compass_1.42.0_amd64.deb -O /tmp/mongodb-compass.deb
sudo dpkg -i /tmp/mongodb-compass.deb
sudo apt-get install -f # Resolve dependências se necessário
rm /tmp/mongodb-compass.deb

curl -fsSL https://www.mongodb.org/static/pgp/server-6.0.asc | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/mongodb-6.gpg
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
sudo apt-get update
sudo apt-get install -y mongodb-mongosh
mongosh --version
read -p "Instalado MongoDB Compass e MongoSH, pressione Enter para continuar..."

########################################
# 5. INSTALANDO POSTMAN
########################################
echo "Instalando POSTMAN..."
sudo snap install postman
read -p "Pressione Enter para continuar..."

########################################
# 6. INSTALANDO KEEPASSXC
########################################
echo "Instalando KeePassXC..."
sudo apt-get install -y keepassxc
echo "Recomendo instalar a extensão para o browser BRAVE também!"
read -p "Pressione Enter para continuar..."

########################################
# 7. CONFIGURANDO GIT
########################################
echo "Configurando Git globalmente..."
git config --global user.email "$git_config_user_email"
git config --global user.name "$git_name"
git config --global core.excludesFile '~/.gitignore'

########################################
# 8. INSTALANDO DENO
########################################
echo "Instalando Deno..."
curl -fsSL https://deno.land/install.sh | sh

# Add Deno to PATH in zshrc
echo 'export DENO_INSTALL="$HOME/.deno"' >> ~/.zshrc
echo 'export PATH="$DENO_INSTALL/bin:$PATH"' >> ~/.zshrc

# Add Deno to current session
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
echo "Deno instalado."

########################################
# 9. INSTALANDO NODE.JS VIA NVM
########################################
echo "Instalando NVM (Node Version Manager)..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Export NVM para a sessão ATUAL
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

echo "Instalando Node.js LTS..."
nvm install --lts
nvm use --lts
nvm alias default 'lts/*'

# Add nvm ao zshrc para futuras sessões
echo '' >> ~/.zshrc
echo '# Configuração do NVM' >> ~/.zshrc
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.zshrc
echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> ~/.zshrc
echo "NVM e Node.js LTS instalados."

########################################
# 10. INSTALANDO OH-MY-ZSH
########################################
echo "Instalando oh-my-zsh..."
curl -sSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash
echo "zsh" >> ~/.bashrc # Sugere zsh ao iniciar bash

echo '' >> ~/.zshrc
echo '# Configurações GOPATH/GOROOT' >> ~/.zshrc
echo "export GOPATH=\$HOME/Documents/git/go" >> ~/.zshrc
echo "export GOROOT=/usr/local/go" >> ~/.zshrc
echo "export PATH=\$PATH:\$GOPATH/bin" >> ~/.zshrc
echo "export PATH=\$PATH:\$GOROOT/bin" >> ~/.zshrc
echo "export FZF_DEFAULT_COMMAND='rg --files --follow --hidden'" >> ~/.zshrc

########################################
# 11. GERANDO CHAVE SSH
########################################
echo "Gerando chave SSH..."
ssh-keygen -t rsa -b 4096 -C "$git_config_user_email" -N '' -f ~/.ssh/id_rsa <<< y
ssh-add ~/.ssh/id_rsa
echo "Chave SSH gerada. Copiando chave pública para o clipboard..."
cat ~/.ssh/id_rsa.pub | xclip -selection clipboard
echo "Sua chave pública SSH foi copiada para o clipboard. Cole-a no GitHub."
read -p "Pressione Enter para continuar..."

########################################
# 12. SCRIPT DE ATUALIZAÇÃO UNIVERSAL
########################################
echo "Clonando dotfiles e configurando script de update universal..."
git clone https://github.com/abertanha/dotfiles.git ~/Documentos/git/dotfiles
sudo mv ~/Documentos/git/dotfiles/update /usr/local/bin
sudo chown root:root /usr/local/bin/update
sudo chmod +x /usr/local/bin/update # Garantindo que é executável
ls -l /usr/local/bin/update
echo "Para atualizar seu sistema agora use simplesmente 'sudo update'!"
read -p "Aperte enter para continuar"

#######################################
clear
echo "Configuração concluída!"
echo "Por favor, reinicie sua máquina para que todas as alterações (especialmente o ZSH) tenham efeito."
