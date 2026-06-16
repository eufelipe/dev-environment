# SETUP — Mac (Apple Silicon)

Runbook para configurar ou recriar a máquina. A ordem importa.

## 0. macOS (segurança de base)
- Atualizar o macOS; configurar Apple ID + Touch ID.
- **Ligar FileVault** e **Find My Mac**.
- Instalar **1Password** (app), logar, e:
  - imprimir o **Emergency Kit**, guardar offline e **testar recuperação**;
  - Settings → Developer → ligar **CLI integration** e **SSH agent**.

## 1. Base
```bash
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

## 2. Dotfiles + apps
```bash
brew install chezmoi
# Clona o repo numa pasta minha (HTTPS — SSH ainda não está pronto neste passo):
git clone https://github.com/eufelipe/dev-environment.git ~/Projects/dev-environment
# Fixa essa pasta como FONTE do chezmoi — o flag --source NÃO persiste, vai na config:
mkdir -p ~/.config/chezmoi
printf 'sourceDir = "%s/Projects/dev-environment"\n' "$HOME" > ~/.config/chezmoi/chezmoi.toml
chezmoi source-path     # confirma: /Users/<você>/Projects/dev-environment
chezmoi diff            # revisar antes de aplicar
chezmoi apply -v
brew bundle --file=~/Projects/dev-environment/Brewfile
```
> Depois do passo 4 (SSH), troque o remote: `cd ~/Projects/dev-environment && git remote set-url origin git@github.com:eufelipe/dev-environment.git`

## 3. Runtimes (mise) + Corepack
```bash
exec zsh               # recarrega o shell (mise/starship ativos)
mise use -g node@lts ruby@3.3 python@3.12 java@temurin-17
corepack enable
mise doctor
```

## 4. SSH (1Password) + GitHub
`~/.ssh/config`:
```
Host github.com
  HostName github.com
  User git
  IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
```
```bash
ssh -T git@github.com
```
Assinatura de commit: criar `~/.gitconfig.local` (fora do git) com a chave **pública**
do 1Password em `user.signingkey` + `[commit] gpgsign = true`. O `dot_gitconfig` já
faz `[include]` desse arquivo, então ele sobrescreve o `gpgsign=false` padrão.

## 5. Mobile (React Native)
```bash
brew install watchman
# Xcode: instalar pela App Store ANTES (não vem no Brewfile), depois:
sudo xcodebuild -license accept && xcodebuild -runFirstLaunch
# Android Studio: abrir uma vez → SDK Platform, Platform-Tools, Build-Tools,
#   Emulator, imagem ARM64, Command-line Tools.
# CocoaPods: por projeto, via Bundler →  cd ios && bundle install && bundle exec pod install
```

## 6. Defaults de macOS
```bash
bash ~/Projects/dev-environment/scripts/macos-defaults.sh
```

## 7. Verificar
```bash
mise doctor && brew doctor && op whoami
node -v && ruby -v && java -version && watchman --version && starship --version
```

---

### Regras de operação
- Runtimes só pelo **mise**. `pnpm`/`yarn` só via **Corepack** (`packageManager` no `package.json`).
- `.mise.toml` **por repo** (`CODE/<repo>`), nunca na raiz do projeto.
- Segredos no **1Password**. `.env` só com referências `op://`; rodar com `op run --env-file=.env -- <cmd>`.
- Ajustes só-desta-máquina em `~/.zshrc.local` (fora do git).
- Agente de IA só abre em `CODE/<repo>`. Autônomo (`--dangerously-skip-permissions`) só em container. Ver `~/.claude/CLAUDE.md` (`dot_claude/`).
