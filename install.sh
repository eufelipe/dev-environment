#!/usr/bin/env bash
set -e

# Diretório do repositório (pasta onde o script está localizado)
REPO_DIR="$(cd "$(dirname "$0")"; pwd)"

# ------------------------------------------------------------------------------
# VERIFICAÇÃO DOS SOFTWARES ESSENCIAIS
# ------------------------------------------------------------------------------
echo "Verificando se os softwares essenciais estão instalados..."

# Verifica se o Xcode está instalado (usando xcodebuild)
if command -v xcodebuild &>/dev/null; then
  echo "Xcode está instalado."
else
  echo "Xcode NÃO está instalado. Por favor, instale o Xcode antes de continuar."
fi

# Função para checar se o aplicativo existe na pasta /Applications
check_app() {
  if [ -d "/Applications/$1.app" ]; then
    echo "$1 está instalado."
  else
    echo "$1 NÃO está instalado. Por favor, instale $1."
  fi
}

check_app "Android Studio"
check_app "Visual Studio Code"
check_app "Warp"

echo "Certifique-se de que os softwares essenciais estejam instalados antes de prosseguir."


# ------------------------------------------------------------------------------
# SYMLINKS DAS CONFIGURAÇÕES
# ------------------------------------------------------------------------------
declare -A FILES_MAP=(
  [".aliases"]="$REPO_DIR/zsh/aliases"
  [".exports"]="$REPO_DIR/zsh/exports"
  [".functions"]="$REPO_DIR/zsh/functions"
  [".zshrc"]="$REPO_DIR/zsh/zshrc"
  [".gitconfig"]="$REPO_DIR/git/gitconfig"
)

echo "Criando backups e links simbólicos para as configurações..."
for file in "${!FILES_MAP[@]}"; do
  src="${FILES_MAP[$file]}"
  dest="$HOME/$file"

  # Se o arquivo existir e não for link, faz backup renomeando com .bak
  if [[ -e "$dest" && ! -L "$dest" ]]; then
    echo "Encontrado arquivo existente: $dest -> fazendo backup."
    mv "$dest" "$dest.bak"
  fi

  # Cria (ou atualiza) o link simbólico
  echo "Criando link simbólico: $dest -> $src"
  ln -sfn "$src" "$dest"
done

echo "Configurações de arquivos concluídas."


# ------------------------------------------------------------------------------
# INSTALAÇÕES VIA TERMINAL
# ------------------------------------------------------------------------------

# 1. Command Line Tools e licença do Xcode
echo "Instalando Command Line Tools e aceitando a licença do Xcode..."
xcode-select --install 2>/dev/null || echo "Command Line Tools já instalado ou em processo de instalação."
sudo xcodebuild -license accept

# 2. Homebrew
if ! command -v brew &>/dev/null; then
  echo "Instalando Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew já está instalado."
fi
echo "Atualizando Homebrew..."
brew update

# 3. Git (opcional, se desejar uma versão mais atualizada)
echo "Instalando Git (caso necessário)..."
brew install git || echo "Git já está instalado via Homebrew."

# 4. Java (Temurin17)
echo "Instalando Java (Temurin17)..."
brew install --cask temurin17 || echo "Temurin17 já está instalado."

# 5. Node.js e NVM
echo "Instalando NVM..."
brew install nvm || echo "NVM já está instalado."
mkdir -p ~/.nvm

# Configura a variável NVM_DIR e carrega o script do nvm, se disponível.
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  . "$NVM_DIR/nvm.sh"
  echo "Instalando Node.js LTS via NVM..."
  nvm install --lts
  nvm use --lts
else
  echo "NVM não encontrado. Por favor, verifique sua instalação do NVM."
fi

# 6. Pacotes globais com npm e utilitários adicionais via brew
echo "Instalando pacotes globais com npm..."
npm install -g yarn pnpm expo-cli ntl gitignore safe-rm commitizen cz-conventional-changelog

echo "Instalando utilitários adicionais (tree, httpie) via Homebrew..."
brew install tree httpie || echo "Tree e/ou httpie já instalados."

# 7. Ruby com rbenv
echo "Instalando rbenv e ruby-build..."
brew install rbenv ruby-build || echo "rbenv e ruby-build já estão instalados."
echo "Instalando Ruby 3.2.1..."
rbenv install 3.2.1 || echo "Ruby 3.2.1 já instalado."
rbenv global 3.2.1

# 8. Python com pyenv
echo "Instalando pyenv e pyenv-virtualenv..."
brew install pyenv pyenv-virtualenv || echo "pyenv e pyenv-virtualenv já estão instalados."
echo "Instalando Python 3.10.10..."
pyenv install 3.10.10 || echo "Python 3.10.10 já instalado."
pyenv global 3.10.10

# 9. Dependências para React Native
echo "Instalando CocoaPods..."
# Se estiver usando rbenv, pode não ser necessário usar sudo
if command -v rbenv &>/dev/null; then
  gem install cocoapods || echo "CocoaPods já instalado."
else
  sudo gem install cocoapods || echo "CocoaPods já instalado."
fi
echo "Instalando Watchman..."
brew install watchman || echo "Watchman já instalado."

# 10. Oh My Zsh e Plugins
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Instalando Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "Oh My Zsh já está instalado."
fi

# Define o diretório custom do Oh My Zsh
ZSH_CUSTOM=${ZSH_CUSTOM:-"$HOME/.oh-my-zsh/custom"}

# zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "Instalando zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
  echo "zsh-autosuggestions já instalado."
fi

# zsh-completions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ]; then
  echo "Instalando zsh-completions..."
  git clone https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions"
else
  echo "zsh-completions já instalado."
fi

# fast-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/fast-syntax-highlighting" ]; then
  echo "Instalando fast-syntax-highlighting..."
  git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$ZSH_CUSTOM/plugins/fast-syntax-highlighting"
else
  echo "fast-syntax-highlighting já instalado."
fi

# Tema Spaceship (opcional)
if [ ! -d "$ZSH_CUSTOM/themes/spaceship-prompt" ]; then
  echo "Instalando o tema Spaceship..."
  git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
  ln -sfn "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
else
  echo "Tema Spaceship já instalado."
fi

echo
echo "Instalação concluída."
echo "-> Se necessário, reinicie o terminal ou execute 'source ~/.zshrc' para carregar as novas configurações."