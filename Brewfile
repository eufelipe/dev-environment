# Brewfile — eufelipe/dev-environment (Mac M5)
# Escopo: SÓ ferramentas de dev. Apps pessoais e de App Store: instalar manualmente.
# Regra: só entra aqui o que você abre/roda hoje. Sugestão não-adotada fica no menu.
# Instala com:  brew bundle --file=~/Projects/dev-environment/Brewfile
# Java vem do mise; CocoaPods via Bundler por projeto.

tap "homebrew/bundle"

# ---- CLIs: core ----
brew "git"
brew "gh"
brew "chezmoi"
brew "mise"
brew "jq"

# ---- CLIs: shell e terminal ----
brew "starship"
brew "zsh-autosuggestions"
brew "zsh-completions"
brew "zsh-syntax-highlighting"
brew "fzf"
brew "zoxide"
brew "eza"
brew "bat"
brew "ripgrep"
brew "fd"
brew "tree"
brew "dust"             # du moderno: árvore visual de uso de disco
brew "btop"
brew "tldr"

# ---- CLIs: dev UX ----
brew "lazygit"
brew "git-delta"
brew "glow"             # render de Markdown no terminal (glow arquivo.md)
brew "trash"

# ---- CLIs: mídia / arquivos ----
brew "yt-dlp"            # usado pelo alias ytaudio
brew "sevenzip"          # binário 7zz, usado pela função extract() em .7z

# ---- CLIs: containers ----
brew "docker"
brew "docker-compose"
brew "lazydocker"       # TUI pro Docker/OrbStack (espírito do lazygit)

# ---- CLIs: React Native ----
brew "watchman"
brew "fastlane"

# ---- CLIs: segurança / supply chain ----
brew "gitleaks"
brew "semgrep"

# ---- CLIs: 1Password ----
brew "1password-cli"

# ---- Apps de dev (cask) ----
cask "1password"
cask "orbstack"
cask "cursor"
cask "warp"
cask "android-studio"
cask "brave-browser"
cask "stats"             # monitor de RAM/swap — crítico nos 24 GB
cask "raycast"
cask "dbeaver-community" # GUI de banco (você usa hoje)
cask "shottr"            # screenshot/OCR

# ---- Menu: avaliar e promover SÓ depois de adotar (descomente) ----
# cask "bruno"          # cliente de API local-first (no lugar do Apidog)
# cask "tableplus"      # GUI de banco nativo, mais leve (no lugar do DBeaver)
# cask "keka"           # extrator de arquivos (no lugar do The Unarchiver)
# cask "ghostty"        # terminal nativo sem conta (alt. ao Warp)
# cask "zed"            # editor Rust com IA (2º editor leve)
# cask "superwhisper"   # ditado voz->texto p/ prompts de agente

# ---- Apps fora do Brewfile (App Store / download direto / pessoais): ver SOFTWARES.md ----
