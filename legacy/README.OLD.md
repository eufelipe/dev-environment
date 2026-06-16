# Configuração de um Novo Mac (Intel, macOS Ventura)

A ordem de passos abaixo evita que você precise editar o arquivo ~/.zshrc várias vezes. Primeiro, fazemos as instalações básicas (Xcode, Homebrew, etc.). Em seguida, listamos as instalações específicas (Java, Node, Ruby, Python) e, ao final, mostramos como configurar o ZSH e o Oh My Zsh em um único lugar.

---

## 1. Baixar Aplicativos Essenciais

- Xcode (https://developer.apple.com/xcode/)  
- Android Studio (https://developer.android.com/studio?hl=pt-br)  
- Visual Studio Code (https://code.visualstudio.com/)  
- Warp (https://www.warp.dev/)

---

## 2. Ferramentas de Linha de Comando (Xcode Command Line Tools)

Essenciais para compilar e rodar binários no macOS, incluindo projetos iOS.

1. Instale as ferramentas:
```
xcode-select --install
```

2. Aceite a licença do Xcode:
```
sudo xcodebuild -license accept
```

---

## 3. Homebrew

Facilita a instalação de diversas ferramentas.

1. Instale o Homebrew:
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. Atualize o Homebrew:
```
brew update
```

---

## 4. Git

- Instalação (caso queira uma versão mais recente que a do macOS):
```
brew install git
```

- Para configurar o Git, você pode usar os scripts disponíveis:

### 4.1 Instalação do .gitconfig

```
./git/setup_gitconfig.sh
```


Ambos os scripts copiam o arquivo .gitconfig da pasta git/ para o diretório home do usuário (~/.gitconfig).

---

## 5. Java (Temurin17)

Para desenvolvimento Android (ou outras necessidades), instale Java 17 via Homebrew:

```
brew install --cask temurin17
```

---

## 6. Node.js (nvm)

Para projetos Node, React e React Native, é comum precisar de múltiplas versões do Node.

1. Instale o nvm:
```
brew install nvm
```

2. (Opcional) Crie uma pasta para o nvm:
```
mkdir ~/.nvm
```

3. Depois configuraremos o nvm no ~/.zshrc (ver exemplo no final).  
4. Após configurar, instale a versão LTS do Node:
```
nvm install --lts
nvm use --lts
```

---

## 7. Pacotes Globais Essenciais

### 7.1 Via NPM

```
npm install -g yarn
npm install -g pnpm
npm i -g expo-cli
npm install -g ntl
npm install -g gitignore
npm install -g safe-rm
npm install -g commitizen cz-conventional-changelog
```

### 7.2 Via Homebrew

```
brew install tree
brew install httpie
```

---

## 8. Ruby (rbenv)

Gerenciador de múltiplas versões de Ruby:

```
brew install rbenv ruby-build
```

Após a configuração do ~/.zshrc, você pode:

```
rbenv install 3.2.1
rbenv global 3.2.1
```

---

## 9. Python (pyenv)

```
brew install pyenv
brew install pyenv-virtualenv
```

Depois de configurar o ~/.zshrc (ver adiante), você pode:

```
pyenv install 3.10.10
pyenv global 3.10.10
pyenv virtualenv 3.10.10 meu_env
pyenv activate meu_env
```

---

## 10. React Native

- CocoaPods (para builds iOS):
```
sudo gem install cocoapods
```
  *(Se usar rbenv, pode instalar sem sudo.)*

- Watchman (para React Native CLI):
```
brew install watchman
```

---

## 11. Oh My Zsh (Instalação e Configuração)

1. Verifique a versão do Zsh (normalmente é o shell padrão no macOS Ventura):
```
zsh --version
```

2. Instale o Oh My Zsh:
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

3. Instale manualmente os plugins:
   - zsh-autosuggestions:
   ```
   git clone https://github.com/zsh-users/zsh-autosuggestions \
     $ZSH/custom/plugins/zsh-autosuggestions
   ```

   - zsh-completions:
   ```
   git clone https://github.com/zsh-users/zsh-completions \
     $ZSH/custom/plugins/zsh-completions
   ```

   - fast-syntax-highlighting:
   ```
   git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
     $ZSH/custom/plugins/fast-syntax-highlighting
   ```

4. Instale o tema Spaceship:
```
git clone https://github.com/spaceship-prompt/spaceship-prompt.git \
  "$ZSH/custom/themes/spaceship-prompt" --depth=1
ln -s "$ZSH/custom/themes/spaceship-prompt/spaceship.zsh-theme" \
  "$ZSH/custom/themes/spaceship.zsh-theme"
```

---

## 12. Arquivo Final: ~/.zshrc

Após concluir todas as instalações acima, você pode substituir ou editar seu ~/.zshrc com um conteúdo similar a este:

```
# ------------------------------------------------------------------------------
# OH MY ZSH PATH
# ------------------------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"

# ------------------------------------------------------------------------------
# TEMA
# ------------------------------------------------------------------------------
ZSH_THEME="spaceship"

# ------------------------------------------------------------------------------
# PLUGINS
# ------------------------------------------------------------------------------
plugins=(
  git
  z
  colored-man-pages
  zsh-autosuggestions
  zsh-completions
  fast-syntax-highlighting
)

# ------------------------------------------------------------------------------
# CARREGA OH MY ZSH
# ------------------------------------------------------------------------------
source $ZSH/oh-my-zsh.sh

# ------------------------------------------------------------------------------
# DESABILITAR AUTO-UPDATE (OPCIONAL)
# ------------------------------------------------------------------------------
DISABLE_AUTO_UPDATE="true"

# ------------------------------------------------------------------------------
# ANDROID SDK
# ------------------------------------------------------------------------------
export ANDROID_SDK=~/Library/Android/sdk
export ANDROID_HOME="$ANDROID_SDK"
export ANDROID_SDK_ROOT="$ANDROID_SDK"
export PATH="$ANDROID_SDK/emulator:$ANDROID_SDK/tools:$ANDROID_SDK/tools/bin:$ANDROID_SDK/platform-tools:$PATH"

# ------------------------------------------------------------------------------
# JAVA HOME (Java 17)
# ------------------------------------------------------------------------------
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export PATH="$JAVA_HOME/bin:$PATH"

# ------------------------------------------------------------------------------
# NODE (NVM)
# ------------------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"

# ------------------------------------------------------------------------------
# RUBY (rbenv)
# ------------------------------------------------------------------------------
eval "$(rbenv init - zsh)"

# ------------------------------------------------------------------------------
# PYTHON (pyenv)
# ------------------------------------------------------------------------------
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init - zsh)"

# ------------------------------------------------------------------------------
# FLUTTER (opcional)
# ------------------------------------------------------------------------------
# export FLUTTER_SDK="$HOME/flutter"
# export PATH="$FLUTTER_SDK/bin:$PATH"

# ------------------------------------------------------------------------------
# VISUAL STUDIO CODE
# ------------------------------------------------------------------------------
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# ------------------------------------------------------------------------------
# GEM (Ruby)
# ------------------------------------------------------------------------------
export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
export PATH="$GEM_HOME/bin:$PATH"

# ------------------------------------------------------------------------------
# ALIAS
# ------------------------------------------------------------------------------
alias zshconfig="nano ~/.zshrc"
alias ohmyzsh="nano ~/.oh-my-zsh"
alias c="clear"
alias l="ls -lah"
alias ll="ls -l"
alias ls="ls -G"
alias rm='safe-rm'
alias ..="cd .."
alias ...="cd ../.."
alias dev="cd ~/PROJETOS"
alias docs="cd ~/Documents"
alias downloads="cd ~/Downloads"
alias ip="ifconfig | grep 'inet ' | grep -v 127.0.0.1 | awk '{print \$2}'"
alias clear-derived-data="rm -rf ~/Library/Developer/Xcode/DerivedData/*"
alias clear-cache="rm -rf ~/Library/Caches/*"
alias kill-process="kill -9 \$(pgrep -f)"

# Docker
alias dps="docker ps"
alias dimg="docker images"
alias dcup="docker compose up"
alias dcdown="docker compose down"

# React Native
alias metro="npx react-native start"
alias emulator="$ANDROID_SDK/emulator/emulator"
alias androidemulator="emulator -avd Pixel_3a_API_30_x86"

# ------------------------------------------------------------------------------
# Spaceship Prompt - Exemplo de Configuração
# ------------------------------------------------------------------------------
SPACESHIP_PROMPT_ORDER=(
  user
  dir
  host
  git
  hg
  exec_time
  line_sep
  vi_mode
  jobs
  exit_code
  char
)
SPACESHIP_USER_SHOW=always
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL="❯"
SPACESHIP_CHAR_SUFFIX=" "

# ------------------------------------------------------------------------------
# FIM DO .ZSHRC
# ------------------------------------------------------------------------------

```

Depois de salvar o arquivo, feche e reabra o terminal ou execute:
```
source ~/.zshrc
```
para carregar todas as configurações.

---

## Conclusão

Seguindo esta sequência, você terá:

1. Ferramentas de compilação para iOS (Command Line Tools / Xcode).
2. Homebrew instalado e atualizado.
3. Git configurado.
4. Java 17 para desenvolvimento Android.
5. Node.js gerenciado via nvm, com versão LTS instalada.
6. Pacotes globais (npm / brew) como Yarn, PNPM, expo-cli, etc.
7. Ruby gerenciado via rbenv, se necessário (com cocoapods para iOS).
8. Python gerenciado via pyenv, se necessário.
9. Oh My Zsh com plugins, tema Spaceship e aliases úteis.
10. React Native pronto para builds iOS/Android (CocoaPods + Watchman).

Feito isso, seu ambiente estará pronto para projetos em Node, React, React Native, Ruby e Python.