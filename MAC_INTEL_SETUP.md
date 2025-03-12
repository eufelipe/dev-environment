# Setup do Ambiente de Desenvolvimento (macOS Intel)

Este documento descreve os passos básicos para configurar um novo Mac (Intel, rodando macOS Ventura) para desenvolvimento com Node.js, React Native, Ruby, Python etc. 

---

## 1. Softwares Essenciais (Download)

Antes de começar a instalação via terminal, baixe e instale:

1. **Xcode**:  
   - [https://developer.apple.com/xcode/](https://developer.apple.com/xcode/)  

2. **Android Studio**:
   - [https://developer.android.com/studio](https://developer.android.com/studio)

3. **Visual Studio Code**:  
   - [https://code.visualstudio.com/](https://code.visualstudio.com/)

4. **Warp**:  
   - [https://www.warp.dev/](https://www.warp.dev/)


---

## 2. Instalações Básicas via Terminal

1. **Command Line Tools** e Licença do Xcode:
   ```
   xcode-select --install
   sudo xcodebuild -license accept
   ```

2. **Homebrew**:
   ```
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   brew update
   ```

3. **Git** (opcional, caso queira a versão mais recente do que a do sistema):
   ```
   brew install git
   ```

4. **Java (Temurin17)** (necessário para Android, builds Gradle, etc.):
   ```
   brew install --cask temurin17
   ```

5. **Node.js / nvm** (para gerenciar múltiplas versões de Node):
   ```
   brew install nvm
   mkdir ~/.nvm   # se necessário
   ```
   Depois de configurar o NVM em seu shell (export NVM_DIR etc.), instale a versão LTS:
   ```
   nvm install --lts
   nvm use --lts
   ```

6. **Pacotes Globais** (npm e brew):
   ```
   npm install -g yarn pnpm expo-cli ntl gitignore safe-rm commitizen cz-conventional-changelog
   brew install tree httpie
   ```

7. **Ruby (rbenv)** (para projetos Ruby, CocoaPods, etc.):
   ```
   brew install rbenv ruby-build
   rbenv install 3.2.1
   rbenv global 3.2.1
   ```

8. **Python (pyenv)** (para projetos Python):
   ```
   brew install pyenv pyenv-virtualenv
   pyenv install 3.10.10
   pyenv global 3.10.10
   ```

9. **React Native**:
   - **CocoaPods** (para iOS):
     ```
     sudo gem install cocoapods
     ```
     *(ou sem `sudo` se estiver usando rbenv)*
   - **Watchman**:
     ```
     brew install watchman
     ```

---

## 3. Oh My Zsh + Plugins

1. Verifique se o Zsh é o shell padrão:
   ```
   zsh --version
   ```
2. **Oh My Zsh**:
   ```
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```
3. **Plugins** (exemplos):
   - **zsh-autosuggestions**:
     ```
     git clone https://github.com/zsh-users/zsh-autosuggestions \
       $ZSH/custom/plugins/zsh-autosuggestions
     ```
   - **zsh-completions**:
     ```
     git clone https://github.com/zsh-users/zsh-completions \
       $ZSH/custom/plugins/zsh-completions
     ```
   - **fast-syntax-highlighting**:
     ```
     git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
       $ZSH/custom/plugins/fast-syntax-highlighting
     ```

4. **Tema Spaceship** (opcional):
   ```
   git clone https://github.com/spaceship-prompt/spaceship-prompt.git \
     "$ZSH/custom/themes/spaceship-prompt" --depth=1
   ln -s "$ZSH/custom/themes/spaceship-prompt/spaceship.zsh-theme" \
     "$ZSH/custom/themes/spaceship.zsh-theme"
   ```

---
 
### Como usar

1. **Dentro** do diretório `dev-environment`:
   ```
   chmod +x install.sh
   ./install.sh
   ```


2. O script faz backup de quaisquer arquivos existentes (renomeando para `.bak`) e depois cria symlinks que apontam para as configs no repositório.

---

## 6. Rode o Script e Reabra o Terminal

- Após rodar `./install.sh`, **feche** o terminal e abra novamente ou rode `source ~/.zshrc`.  
- Isso garante que os aliases, exports e demais configurações sejam carregadas.

---


