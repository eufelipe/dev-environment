# Ambiente de Desenvolvimento — Mac M5 (consolidado)

> **O que é este documento:** a versão consolidada do meu plano de ambiente de desenvolvimento, unindo o melhor das opiniões do Perplexity e do GPT, com as contradições resolvidas e os erros corrigidos. É a base versionável do repo `eufelipe/dev-environment` (substitui o setup Intel antigo).
>
> **Status:** v2. Incorpora a auditoria dos meus configs Intel reais (gitconfig com e-mail invertido, cruft de migração, `rm='safe-rm -rf'`, `agent-safehouse` já em uso), a decisão "sem symlink" (§1.5), a curadoria de apps (§5.1), os comandos de produtividade/Finder (§6.1) e a remoção do `create_project`. Pesquisa verificada (agentes/toolchain) ainda a destilar em algumas frentes. Decisões firmes, mas revisáveis.
>
> **Como ler:** cada afirmação está marcada como **[Fato]** (verificável e estável), **[Consenso]** (prática dominante na indústria em 2026) ou **[Opinião]** (escolha minha, defensável, mas pessoal). A ordem dos passos importa.

---

## 0. Decisões finais (visão rápida)

| Área | Decisão | Plano B | Marcação |
|---|---|---|---|
| Raiz dos projetos | `~/Projects` | — | [Opinião] |
| Organização | Projeto como unidade; repo é só uma parte | — | [Opinião] |
| Artefatos | Pastas em **CAIXA ALTA** (`DESIGN`, `DOCS`, `RESEARCH`…) | — | [Opinião] |
| Código | Sempre em `CODE/<repo>`; agente só abre o repo | — | [Opinião] |
| Disco | **FileVault ligado** desde o primeiro boot | — | [Consenso] |
| Segredos / SSH | **1Password** (SSH agent off-disk + `op run` com `op://`) | — | [Consenso] |
| Recuperação 1Password | **Emergency Kit impresso, offline e testado** | — | [Fato] |
| Runtimes (Node/Ruby/Python/Java) | **mise** unifica os 4 | fnm (se virar só Node) | [Consenso] |
| Package managers JS | **Corepack** por projeto (`packageManager`) | — | [Fato] |
| Containers | **OrbStack** (com `mem_limit`) | Colima (grátis/CI) | [Consenso] |
| Prompt do shell | **Starship** + zsh enxuto (sem Oh My Zsh) | — | [Consenso] |
| Dotfiles | **chezmoi** + Brewfile | — | [Consenso] |
| IA local (Ollama) | **Fora do plano base** (24 GB não comporta junto do fluxo) | sessão dedicada pontual | [Opinião] |
| Agente interativo | Host, aprovação por ação, escopo no repo | — | [Opinião] |
| Agente autônomo | **Só em container** (não-root, só o repo montado, egress controlado) | VM Linux | [Opinião] |
| RN nativo (Xcode/Pods/simulador) | **Host interativo**, nunca em container | — | [Fato] |
| Backup | Git + Time Machine + cloud + 1Password Emergency Kit | — | [Consenso] |

---

## 1. Princípios

### 1.1 A máquina não é caixa preta
Depois de formatar ou trocar de Mac, reconstruir ~80% do ambiente com:

```bash
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install chezmoi
chezmoi init --apply eufelipe/dev-environment
```

Ajustes manuais inevitáveis (Xcode, Android Studio, login em apps, SSH) ficam **documentados** neste arquivo. **[Opinião]**

### 1.2 Projeto é maior que repositório

```text
~/Projects/
  okrtrack/
    CODE/
      okrtrack-monorepo/
    DOCS/
    DESIGN/
    PROMPTS/
    PROPOSTAS/
    RESEARCH/
    ASSETS/
    SCRIPTS/
    ARCHIVE/
```

O repo Git é uma parte do projeto, não o projeto inteiro. **[Opinião]**

### 1.3 Agente não vê tudo
```bash
# Certo — abre dentro do repo:
cd ~/Projects/okrtrack/CODE/okrtrack-monorepo
cursor .    # ou claude

# Errado — exporia DESIGN/PROPOSTAS/RESEARCH (não versionados, git não recupera):
cd ~/Projects/okrtrack
cursor .
```
**Risco aceito:** isso depende de disciplina; não há barreira técnica no host. A barreira real é o container (§12) para trabalho autônomo. **[Opinião]**

### 1.4 Segredo nunca é arquivo de projeto
Nunca na árvore do projeto: `.env.local` com valores reais, `*.p12`, `*.mobileprovision`, `*.pem`, `*.key`, `service-account.json`, `firebase-adminsdk.json`. Tudo vai para o 1Password. **[Consenso]**

```bash
# .env versionável — só referências, nenhum valor real:
#   DATABASE_URL=op://Dev/okrtrack/DATABASE_URL
#   ANTHROPIC_API_KEY=op://Dev/anthropic/dev-machine-key
op run --env-file=.env -- pnpm dev
```

### 1.5 Código mora fisicamente em `CODE/<repo>` — sem symlink
**Decisão:** o código fica fisicamente dentro de `CODE/<repo>`. **Não** uso symlink (ex.: código real em `~/Dev/` e `CODE/` apontando pra lá). **[Opinião]**

**Por quê:** o symlink não agrega ao objetivo e cobra custo no meu fluxo:
- **RN + Metro + Watchman atravessando symlink = bugs sutis** (FSEvents do macOS e indexador do Cursor se comportam de forma inconsistente). Fonte conhecida de "hot reload parou".
- **Não adiciona isolamento:** a barreira do agente vem de *onde* eu abro o agente (`cd CODE/<repo>`), não da localização física — o agente atravessa o symlink se quiser.
- **Backup ambíguo:** Time Machine e cloud seguem symlink de formas diferentes (duplica ou fura cobertura).
- Viola o princípio "uma regra na cabeça".

**Objetivo real (separar código versionado de artefatos) já resolvido** pela estrutura `CODE/` vs `DESIGN/`/`DOCS/`. Para "todo código num lugar pra scan/backup", uso um glob (`~/Projects/**/CODE/**`), não indireção.
**Única exceção legítima:** relocar `node_modules`/código pesado para SSD externo quando o interno encher (símlink com propósito técnico de espaço, não organizacional).

---

## 2. Ordem de instalação (a ordem importa)

```
Fase 1  macOS básico + FileVault + 1Password (login + Emergency Kit testado)
Fase 2  Command Line Tools + Homebrew
Fase 3  chezmoi → aplica dotfiles + Brewfile
Fase 4  mise + runtimes (node, ruby, python, java)  ← Java pelo mise, não pelo brew
Fase 5  Corepack (pnpm/yarn via packageManager)
Fase 6  Apps GUI (Xcode, Android Studio, Cursor, Warp, OrbStack…)
Fase 7  Toolchain React Native (Watchman, CocoaPods via Bundler, Android SDK)
Fase 8  1Password SSH agent + teste GitHub
Fase 9  Verificação (verify.sh / doctor)
Fase 10 Teste de Disaster Recovery (uma vez, com data marcada)
```

> **Por que 1Password tão cedo (Fase 1):** o chezmoi injeta segredos do 1Password nos dotfiles (e-mail/signing key do git). Sem `op` logado antes do `chezmoi apply`, os templates falham. Além disso é o **ponto único de falha** do plano inteiro — quero ele de pé, com Emergency Kit testado, antes de qualquer coisa. **[Opinião]**

---

## 3. Passo a passo

### Fase 1 — macOS básico + segurança de base
1. Atualizar o macOS.
2. Configurar Apple ID + Touch ID.
3. **Ativar FileVault** (Ajustes → Privacidade e Segurança → FileVault). **[Consenso]** Disco criptografado é table stakes para quem roda agentes.
4. **Ativar Find My Mac.**
5. Instalar 1Password (app) manualmente e fazer login.
6. **Emergency Kit do 1Password:** imprimir (com a Secret Key), guardar **offline** em cofre físico, **testar recuperar a conta** num dispositivo limpo, garantir 2FA recuperável. **[Fato]** Recuperação não testada = recuperação que não existe.
7. Ligar a integração CLI: 1Password → Settings → Developer → "Integrate with 1Password CLI" + "Use the SSH agent".

```bash
op signin && op whoami   # confirma o CLI logado
```

### Fase 2 — Command Line Tools + Homebrew
```bash
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Apple Silicon: prefixo é /opt/homebrew (não /usr/local)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
brew doctor
```
**[Fato]** No M-series o brew vive em `/opt/homebrew`; paths `/usr/local` do setup Intel antigo morrem aqui.

### Fase 3 — chezmoi (dotfiles + Brewfile)
```bash
brew install chezmoi
chezmoi init https://github.com/eufelipe/dev-environment.git   # https antes do SSH estar pronto
chezmoi diff                 # REVISA antes de aplicar
chezmoi apply -v             # aplica zshrc, gitconfig, mise, starship…
brew bundle --file=~/.local/share/chezmoi/Brewfile
```
**[Consenso]** chezmoi gerencia dotfiles com templates por máquina e injeta segredos do 1Password em tempo de `apply` (sem gravar valor no git). `chezmoi diff` mostra a mudança antes — diferente do symlink tudo-ou-nada do `install.sh` antigo.

Convenções de nome no repo: `dot_zshrc` → `~/.zshrc`; `dot_config/starship.toml` → `~/.config/starship.toml`; `private_` → permissão 600; sufixo `.tmpl` → template (usa `op` do 1Password).

> **Reprodutibilidade real — pin do Brewfile:** `brew bundle` sem lock pega sempre o latest. Para "recriar igual", commite o `Brewfile.lock.json` ou aceite conscientemente o drift. **[Opinião]**

### Fase 4 — mise + runtimes (incluindo Java)
```bash
brew install mise
# Ativação no shell — só a linha de eval, NUNCA "mise activate zsh >> ~/.zshrc":
#   eval "$(mise activate zsh)"   (já vem no dot_zshrc)

mise use -g node@lts
mise use -g ruby@3.3
mise use -g python@3.12
mise use -g java@temurin-17     # Java pelo mise — fonte única de verdade
mise doctor
```
**[Consenso]** Um só gerenciador para a stack poliglota (RN puxa Ruby p/ CocoaPods; POCs usam Python; Android exige JDK). Substitui nvm + rbenv + pyenv + Temurin manual do repo antigo.

> **Java só no mise (não no Homebrew):** gerenciar `openjdk` no brew **E** `java` no mise briga por `JAVA_HOME`/PATH. Escolhi o mise como fonte única e aponto o Gradle JDK do Android Studio para ele (Settings → Build Tools → Gradle → Gradle JDK). **[Opinião]**
>
> **JDK 17 para RN:** baseline seguro para builds Android/Gradle de React Native. **[Consenso, verificar por release]** O "Gradle quebra com JDK 21+" é exagero — Gradle 8.x suporta 21; o que ainda pede 17 é o tooling do RN dependendo da versão. **Confirme o JDK exato na doc oficial de "set up your environment" para a versão de RN que você usar.**

### Fase 5 — Corepack
```bash
# mise habilita o Corepack quando node está ativo. Por projeto:
corepack use pnpm@latest         # grava "packageManager": "pnpm@10.x" no package.json
pnpm install
```
**[Fato]** Divisão de papéis clara: **mise cuida dos runtimes**, **Corepack cuida do pnpm/yarn**. Nunca os dois no mesmo papel. Zero `npm i -g pnpm`.

### Fase 6 — Apps GUI
- **Xcode** (App Store) → `sudo xcodebuild -license accept` + `xcodebuild -runFirstLaunch`
- **Android Studio** (cask) → abrir uma vez: SDK Platform, Platform Tools, Build Tools, Emulator, imagem ARM64, Command-line Tools
- **Cursor**, **Warp**, **OrbStack**, **Raycast** (opcional, ótimo no M-series)

Xcode e Android Studio são pré-requisito do toolchain RN e baixam GBs — dispare cedo.

### Fase 7 — Toolchain React Native
```bash
brew install watchman                 # observador de arquivos do Metro

# Android SDK (via Android Studio); confirme no dot_exports:
#   ANDROID_HOME=$HOME/Library/Android/sdk  (+ emulator, platform-tools, cmdline-tools no PATH)
```

**CocoaPods via Bundler (recomendado):** não instalar global. Por projeto RN, com o Ruby do mise:
```bash
cd ios
bundle install            # lê o Gemfile do projeto — fixa a versão do CocoaPods
bundle exec pod install
```
**[Consenso]** Bundler + Gemfile por projeto evita o drift de versão do CocoaPods e o clássico problema de permissão (`sudo`). Se um projeto legado não tiver Gemfile, `gem install cocoapods` (Ruby do mise, sem sudo) como fallback.

> **RN é fluxo interativo:** agente coda, eu reviso o diff, **eu** rodo no simulador e valido. Builds nativos rodam **no host**, nunca em agente autônomo/container. **[Fato]** Container Linux não compila iOS.

### Fase 8 — 1Password SSH agent + GitHub
```sshconfig
# ~/.ssh/config
Host github.com
  HostName github.com
  User git
  IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
```
```bash
ssh -T git@github.com    # confirma a chave servida pelo agent (biometria a cada uso)
```
**[Consenso]** Chaves criptografadas e fora do disco; um agente comprometido não acha chave em texto plano.

### Fase 9 — Verificação
```bash
mise doctor && brew doctor && op whoami
node -v && ruby -v && python --version && java -version
watchman --version && pod --version && starship --version
```

### Fase 10 — Teste de Disaster Recovery (faça uma vez)
Num usuário macOS limpo ou VM: Homebrew → chezmoi → aplicar repo → Brewfile → login 1Password → SSH GitHub → clonar um repo → `pnpm install` → rodar um projeto simples.
**[Fato]** DR não testado é hipótese, não plano. **Marque uma data** — esse é o item que todo mundo adia e nunca faz.

---

## 4. Estrutura de pastas

```text
~/Projects/
  nome-projeto/
    CODE/
      nome-projeto-api/      # cada repo tem seu próprio .mise.toml
      nome-projeto-web/
      nome-projeto-app/
    DOCS/ (ADR, ARCHITECTURE, DECISIONS)
    DESIGN/ (FIGMA-EXPORTS, REFERENCES)
    PROMPTS/ (ARCHITECTURE, CODING, REVIEW, RESEARCH)
    PROPOSTAS/
    RESEARCH/
    ASSETS/  SCRIPTS/  ARCHIVE/
```

> **`.mise.toml` fica em `CODE/<repo>`, NÃO na raiz do projeto.** API/web/app divergem em Node/Ruby/Java. Um `.mise.toml` na raiz seria herdado pelos 3 repos (mise sobe na árvore) e forçaria a mesma versão — o oposto do que quero num monorepo + RN + POC. **[Opinião]**

> **Sem script `create_project`.** As pastas acima são um *menu*, não um template — nem todo projeto tem `DESIGN/`, `PROPOSTAS/` etc. Crio só o que cada projeto pedir, na hora (`mkdir -p`). Um script que materializa todas as pastas sempre gera estrutura morta. **[Opinião]**

---

## 5. Brewfile (corrigido)

```ruby
# Brewfile
tap "homebrew/bundle"

# Core
brew "git"
brew "gh"
brew "chezmoi"
brew "mise"
brew "jq"
brew "yq"
brew "openssl"
brew "ca-certificates"

# Shell e terminal
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
brew "btop"
brew "tldr"

# Dev UX
brew "lazygit"
brew "git-delta"
brew "git-lfs"
brew "trash"        # apagar reversível (vai pra Lixeira)
brew "httpie"
brew "act"          # rodar GitHub Actions localmente

# Containers
brew "docker"
brew "docker-compose"

# React Native (Java vem do mise; CocoaPods via Bundler por projeto)
brew "watchman"
brew "fastlane"

# Segurança e supply chain
brew "gitleaks"
brew "trivy"
brew "semgrep"

# 1Password CLI
brew "1password-cli"

# Apps
cask "1password"
cask "orbstack"
cask "cursor"
cask "warp"
cask "android-studio"
cask "google-chrome"
cask "figma"
cask "stats"        # monitor de RAM/swap — crítico nos 24 GB
# cask "raycast"
# cask "postman"  / cask "bruno"  (escolher um cliente de API)
```

**Removidos em relação às sugestões originais (e por quê):**
- `openjdk@17` → Java pelo **mise** (fonte única).
- `cocoapods` → via **Bundler** por projeto.
- `thefuck` → dependência Python + custo de startup no shell; incoerente com a disciplina de RAM.
- `safe-rm` → ver §6 (não aliasar `rm`).
- `commitizen`, `ntl` global → opcionais; se usar, via `pnpm dlx`/projeto, não global.

### 5.1 Apps GUI — curadoria (todos [Opinião], confirmar licença/RAM antes de adotar)
**Manter (boas escolhas atuais):** Shottr (screenshot nativo leve), Raycast (launcher — usar AI/clipboard/window pra aposentar utilitários soltos), Obsidian, Brave, Codex, Discord, LanguageTool, Notion.

**Trocar / avaliar upgrade:**
| Hoje | Sugestão | Por quê |
|---|---|---|
| GitKraken (queria free) | **Lazygit** (free, terminal) + olhar **GitButler** (free) | Lazygit casa com o fluxo Warp/terminal (já no Brewfile); GitButler é o hypado 2026 (virtual branches + commit por IA) |
| The Unarchiver | **Keka** | Open-source, mais formatos, nativo Apple Silicon |
| DBeaver (Java, pesado em 24 GB) | **TablePlus** (pago, nativo) ou **Beekeeper Studio** (free) | Nativo M-series, mais leve |
| Apidog (talvez) | **Bruno** | Local-first, coleções como arquivos no git — casa com "segredo off-disk + versionável" |

**Sobreposições a consolidar (24 GB agradece):** TextSniper ↔ Shottr (já faz OCR); SideNotes ↔ Obsidian ↔ Notion (3 ferramentas de nota — cortar uma).

**Hypado 2026 que faz sentido pro meu fluxo:**
- **superwhisper** — ditado voz→texto p/ prompts de agente (ganho real usando IA o dia todo). ⚠️ modelo local come RAM — usar modelo pequeno/cloud nos 24 GB. Alt.: **Wispr Flow**.
- **Ghostty** — terminal nativo, sem conta/telemetria (alternativa ao Warp, que exige conta).
- **Cap** — Loom open-source p/ demo de cliente (alternativa ao DemoPro).
- **Ice** — menu bar manager open-source (alternativa free ao Bartender).
- **Zed** — editor Rust nativo c/ IA, como 2º editor leve (não substitui Cursor).
- ~~Proxyman~~ — avaliado e descartado: o DevTools/novo debugger do RN já cobre o essencial (ver §10).

---

## 6. Dotfiles essenciais

### `dot_zshrc`
```bash
export EDITOR="cursor --wait"
export VISUAL="cursor --wait"

eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(mise activate zsh)"            # ÚNICA forma correta de ativar o mise
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

[ -f ~/.exports ]   && source ~/.exports
[ -f ~/.aliases ]   && source ~/.aliases
[ -f ~/.functions ] && source ~/.functions
```

### `dot_exports`
```bash
export PROJECTS_DIR="$HOME/Projects"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export ANDROID_HOME="$HOME/Library/Android/sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
# JAVA_HOME NÃO é setado aqui — quem cuida do Java é o mise.

export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1
export HOMEBREW_NO_ENV_HINTS=1
```

### `dot_aliases` (trecho)
```bash
alias l='eza -lah --git'
alias tree3="tree -L 3 -I 'node_modules|.git|dist|build|.next'"
alias projects='cd ~/Projects'

# rm NÃO é aliasado — fica como rm de verdade. Para apagar com segurança:
alias del='trash'
# Deleção destrutiva real é explícita: /bin/rm -rf

alias gs='git status -sb'
alias lg='lazygit'
alias dcup='docker compose up -d'
alias dcdown='docker compose down'

alias metro='npx react-native start'
alias rnios='npx react-native run-ios'
alias rnandroid='npx react-native run-android'
alias clear-derived-data='trash ~/Library/Developer/Xcode/DerivedData/*'
```

> **Por que NÃO aliasar `rm`:** `rm='trash'` ou `rm='safe-rm'` cria memória muscular que te trai no dia que você estiver em CI/outra máquina onde `rm` é `rm` de verdade. Mantenha `rm` honesto e use `del`/`trash` explícito. **[Opinião]**

### `dot_gitconfig.tmpl` (trecho)
> ⚠️ **Correção importante vinda do setup antigo:** no Intel, a identidade **global** era o e-mail **do empregador** — ou seja, todo commit de freela/produto próprio saía assinado como trabalho, salvo nos repos sob `~/PROJETOS/CODE/**`. Está **invertido**. O padrão seguro é: **global = pessoal**, e o e-mail de trabalho entra por `includeIf` só no diretório de trabalho. **[Fato]**
```ini
[user]
  name = Felipe Rosas
  email = contato@eufelipe.com    # PADRÃO = pessoal (ou {{ (onepasswordRead "op://Dev/git/email") }})
  signingkey = ~/.ssh/id_ed25519.pub
[commit]
  gpgsign = true                  # assinatura via SSH (já usava — manter)
[gpg]
  format = ssh
[core]
  editor = cursor --wait          # era "code --wait"
  excludesfile = ~/.gitignore_global
[init]
  defaultBranch = main
[pull]
  rebase = true
[rebase]
  autoStash = true
[push]
  autoSetupRemote = true
[merge]
  conflictstyle = zdiff3
[rerere]
  enabled = true
[diff]
  tool = cursor                   # era vscode
[alias]
  st = status -sb
  lg = log --all --graph --decorate --oneline --abbrev-commit
  undo = reset HEAD~1 --mixed
  pf = push --force-with-lease

# E-mail de trabalho só no diretório de trabalho — o "esquecimento" vaza pro lado certo (pessoal):
[includeIf "gitdir:~/Projects/work/**"]
  path = ~/.gitconfig-work        # contém [user] email = voce@empresa.com
```
**Lixo a NÃO migrar do home antigo:** `.gitconfig-work:` (com dois-pontos, nasceu de redirect errado), `.gitconfig.bak`, `.zshrc.BAK`, `.zshrc.backup`, paths `/usr/local/opt/...` (Intel: tcl-tk, openssl, nvm) e os blocos de nvm/pyenv/rbenv (substituídos pelo mise).

### 6.1 Produtividade: Finder + comandos dev (`macos-defaults.sh` + dotfiles)
Parte disto eu já tinha no `.aliases` antigo (`show`/`hide`, `folder`, `ports`, `flushdns`) — aqui consolido e melhoro. **[Opinião]**

```bash
# scripts/macos-defaults.sh — roda uma vez na máquina nova:
defaults write com.apple.finder AppleShowAllFiles -bool true        # mostrar arquivos ocultos
defaults write NSGlobalDomain AppleShowAllExtensions -bool true     # sempre mostrar extensão
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true  # path POSIX no título da janela
defaults write com.apple.finder ShowPathbar -bool true             # barra de caminho no rodapé
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true  # sem .DS_Store em rede
mkdir -p "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture location "$HOME/Pictures/Screenshots"   # screenshots organizados
killall Finder
```

```bash
# .aliases / .functions — utilitários dev:
alias show='defaults write com.apple.finder AppleShowAllFiles -bool true  && killall Finder'
alias hide='defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder'
alias folder='open .'
alias ports='lsof -i -P -n | grep LISTEN'
killport() { lsof -ti :"$1" | xargs kill -9; }     # mata o que estiver na porta
alias localip="ipconfig getifaddr en0"
alias path='echo $PATH | tr ":" "\n"'              # PATH legível, uma linha por entrada
alias derived='trash ~/Library/Developer/Xcode/DerivedData/*'   # com trash (reversível)
alias flushdns='sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder && echo flushed'
# caffeinate -d  → impede o Mac de dormir durante build/agente longo
```

---

## 7. mise por projeto

```toml
# CODE/<repo>/.mise.toml
[tools]
node = "22.11.0"
ruby = "3.3.6"      # só onde houver CocoaPods/fastlane
java = "temurin-17" # só nos repos Android/RN
python = "3.12"     # só onde houver POC

[tasks.dev]    = "pnpm dev"
[tasks.check]  = "pnpm lint && pnpm test && pnpm typecheck"
```
**[Consenso]** O `.mise.toml` versionado garante que eu e o agente rodamos a mesma versão. Inclua só os runtimes que aquele repo precisa.

---

## 8. Segurança de agentes de IA

### 8.1 Regra por tipo de trabalho
| Trabalho | Ambiente |
|---|---|
| Planejamento, arquitetura, crítica | Chat normal |
| Implementação normal | Cursor/Claude no host, aprovação por ação |
| Refactor JS/TS grande, autônomo | Worktree + **container** |
| RN com Xcode/Pods/simulador | Host interativo, sem autonomia total |
| Deploy, infra, credenciais | Manual ou assistido, aprovação explícita |
| Projeto sensível de cliente | Escopo mínimo, sem raiz, sem autonomia ampla |

> **Camada de sandbox no host (já em uso): `agent-safehouse`.** No setup antigo eu já rodava `claude-safe` (wrapper `eugene1g/agent-safehouse`, que usa o Seatbelt/`sandbox-exec` do macOS pra restringir FS/rede do agente). **Mantenho como camada do trabalho interativo no host** — é o meio-termo entre o sandbox nativo cru e o container. **[Opinião]** ⚠️ Lembrando (§8 do plano original): Seatbelt **não é fronteira de kernel** e está deprecated pela Apple — `agent-safehouse` reduz risco no interativo, mas **não substitui o container** pro trabalho autônomo (§9). É defesa em profundidade, não a barreira final.

### 8.2 `CLAUDE.md` — orientação, não controle
**[Fato]** `CLAUDE.md` é orientação; um agente comprometido ou prompt injection o ignora. Não conte pontos de segurança nele. Para controle real, use **hooks** (§8.3) e **container** (§12).

Conteúdo do `CLAUDE.md` global (defesa em profundidade): não rodar destrutivos sem explicar; não ler `~/.ssh`, `~/.aws`, containers do 1Password; não procurar segredos; não `git push --force` sem confirmação; não mexer fora do repo atual; justificar toda nova dependência; rodar lint/test/typecheck antes de finalizar; para RN, não assumir build OK sem validação no simulador.

### 8.3 Hook real (`PreToolUse`)
```bash
#!/usr/bin/env bash
set -euo pipefail
payload="$(cat)"
command="$(echo "$payload" | jq -r '.tool_input.command // empty')"
blocked=( "rm -rf /" "rm -rf ~" "sudo rm" "chmod -R 777" "git push --force"
          "DROP DATABASE" "cat ~/.ssh" "cat ~/.aws" "BEGIN.*PRIVATE" )
for p in "${blocked[@]}"; do
  if echo "$command" | grep -Eiq "$p"; then
    echo "Bloqueado pelo hook: $p" >&2; exit 2
  fi
done
exit 0
```

---

## 9. Agente autônomo em container

### 9.1 Dockerfile base
```Dockerfile
FROM node:22-bookworm
RUN apt-get update && apt-get install -y git curl jq ripgrep fd-find ca-certificates \
  && rm -rf /var/lib/apt/lists/*
RUN corepack enable
RUN useradd -m -s /bin/bash agent
USER agent
WORKDIR /work
```

### 9.2 Run isolado
```bash
cd ~/Projects/projeto/CODE/repo
docker run -it --rm \
  --memory 6g --cpus 4 --user 1000:1000 \
  -e ANTHROPIC_API_KEY \
  -v "$PWD":/work -w /work \
  agent-sandbox claude --dangerously-skip-permissions -p "Refatore o módulo de auth"
# ~/.ssh, ~/.aws, outros projetos e o shell do host ficam inalcançáveis.
```

### 9.3 O que o container NÃO resolve (importante)
**[Fato]** O container protege o **host contra destruição**, mas **não impede exfiltração** do código montado nem uso indevido da API key se a rede estiver aberta. Mitigações progressivas:

| Nível | Mitigação |
|---|---|
| Básico | Montar só o repo atual, nunca `~/Projects` inteiro. |
| Médio | **Chave Anthropic dedicada** para a dev machine, com **limite de gasto**. Nunca a chave principal. |
| Médio | Logs das sessões autônomas. |
| Médio | **Procedimento de rotação da chave** documentado (se um container vazar, troca rápida). |
| Alto | **Egress via proxy/allowlist** (só `api.anthropic.com` + registries) para projeto sensível. |
| Alto | VM Linux separada para código muito sensível. |

---

## 10. React Native — modelo realista

Fluxo: **agente ajuda a codar → você revisa o diff → você roda no host → valida no simulador → decide se aceita.** RN não cabe 100% em container Linux. **[Fato]**

Checklist iOS: `xcodebuild -version`, `pod --version`, `watchman --version`, `ruby -v`, `bundle -v` → `pnpm install` → `cd ios && bundle exec pod install` → `pnpm ios`.
Checklist Android: `java -version`, `adb version`, `emulator -list-avds` → `pnpm android`.

---

## 11. Docker / Compose com limites de RAM
**[Fato]** Em 24 GB, todo serviço de apoio leva limite explícito — sem isso o container come a memória.
```yaml
services:
  postgres: { image: postgres:16, mem_limit: 2g, cpus: 1, ports: ["5432:5432"] }
  redis:    { image: redis:7,     mem_limit: 512m, cpus: 0.5, ports: ["6379:6379"] }
  mailpit:  { image: axllent/mailpit, mem_limit: 256m, ports: ["1025:1025","8025:8025"] }
```
**Nunca instalar no host:** Postgres, Redis, MySQL, Mongo, RabbitMQ, MinIO, Elasticsearch. Sempre container. **[Consenso]**

---

## 12. Disciplina de RAM (24 GB)
Gargalo é RAM, não CPU (o M5 sobra). Vilões reais: Xcode build, Android Emulator, Cursor indexando, OrbStack, Chrome cheio, agente em tarefa longa.
- Um emulador por vez; fechar Android Studio quando focado em iOS.
- Limite de RAM em todo container.
- **Sem LLM local** junto do fluxo (Ollama só em sessão dedicada).
- Monitorar **swap via Stats** — decisão de troca por dado, não por feeling.
- **Sinal de troca (alvo 48 GB+):** se você rotineiramente fecha apps para abrir o simulador, vê swap constante, ou **evita rodar um agente "porque não tem RAM agora"** (a máquina te custando produtividade). Senão, fica com a atual; SSD cheio → disco externo antes de trocar a máquina. **[Opinião]**

---

## 13. Backup (3-2-1) e o que cada camada cobre
| Camada | Cobre | Não cobre |
|---|---|---|
| Git/GitHub | Código versionado | Não-commitado, design, propostas |
| Time Machine | Estado local | Lockout do 1Password |
| Cloud contínuo | Artefatos (`DESIGN`/`PROPOSTAS`/`RESEARCH`) | Segredos |
| 1Password | Segredos e chaves SSH | Perda de acesso sem Emergency Kit |
| Emergency Kit | Recuperação do 1Password | Arquivos locais |

Excluir do Time Machine e do Spotlight: `node_modules`, `.next`, `dist`, `build`, `coverage`, `DerivedData`, volumes grandes do Docker.

---

## 14. Supply chain e segredos
- **`pnpm approve-builds`** — controla quais deps rodam scripts de install/postinstall (vetor real). **[Fato]**
- Agente não adiciona dependência sem justificar + apresentar alternativa sem dep.
- `gitleaks detect` antes de push em projeto sensível; `semgrep scan --config auto` em mudança grande gerada por IA; `trivy fs .` para deps/imagens.
- **Renovate ou Dependabot ligado** nos projetos ativos (decisão ativa, não "considerar"). **[Consenso]**
- Vaults 1Password: `Personal/`, `Dev/` (GitHub, Anthropic Dev Machine, AWS, Apple Developer, Android Keystore, Firebase), `Clients/` por cliente. Chaves de API **separadas e com limite** por máquina.

Checklist antes de aceitar PR de agente:
```bash
pnpm lint && pnpm typecheck && pnpm test
gitleaks detect && semgrep scan --config auto
# RN: validação no simulador quando build completo for caro
```

---

## 15. Estrutura do repo `dev-environment`
```text
dev-environment/
  README.md  SETUP.md  Brewfile  Brewfile.lock.json  .chezmoi.toml.tmpl
  dot_zshrc  dot_aliases  dot_exports  dot_functions
  dot_gitconfig.tmpl  dot_gitignore_global
  dot_config/{starship.toml, mise/config.toml}
  scripts/{bootstrap.sh, macos-defaults.sh, verify.sh, setup-directories.sh}
  claude/{CLAUDE.md, settings.json.example, hooks/pre-tool-use.sh}
  agent-sandbox/{Dockerfile, README.md}
  docs/{01-principios, 02-seguranca-agentes, 03-react-native, 04-backup-dr, 05-operacao-diaria}.md
```

**Ordem de evolução do repo** (não tente o repo perfeito no primeiro commit): README → Brewfile → migrar dotfiles para chezmoi → `verify.sh` → `setup-directories.sh` → docs de operação → por último agent-sandbox e hooks. Reprodutibilidade básica primeiro, segurança avançada depois. **[Opinião]**

---

## 16. O que sai do setup Intel antigo
| Antes (repo Intel) | Agora | Motivo |
|---|---|---|
| nvm + rbenv + pyenv + Temurin manual | **mise** | Um arquivo, troca automática |
| `install.sh` com symlink na mão | **chezmoi** | Templates + 1Password + diff |
| Oh My Zsh + Spaceship | **Starship** + zsh enxuto | Rust, mais leve/rápido |
| `~/PROJETOS/CODE` (Intel, all-caps) | `~/Projects` + `CODE/<repo>` | Convencional |
| `expo-cli` global | `npx expo` / `eas-cli` | expo-cli foi deprecated **[Fato]** |
| npm globals soltos | mínimo + Homebrew | Cada `-g` é superfície de supply chain |
| `rm='safe-rm -rf'` | `rm` honesto + `del='trash'` | Não retreinar muscle memory destrutiva |
| Docker Desktop | **OrbStack** | Menos RAM, I/O quase nativo |
| paths `/usr/local` | `/opt/homebrew` | Apple Silicon |

---

## 17. Pontos abertos para a próxima rodada (pesquisa + brainstorm)
Esta consolidação fecha o "como eu já faço, corrigido". **Falta** a etapa que você pediu: pesquisar o estado da arte e ferramentas em alta que sirvam ao objetivo — **produzir mais, com mais segurança, rapidez e qualidade**. Candidatos a investigar e possivelmente entrar/trocar:
- Editores/agentes além de Cursor + Claude Code (segundo agente CLI, comparativos 2026).
- Toolchain JS de nova geração (runtimes, bundlers, test runners, linters unificados).
- Observabilidade e controle de custo de agentes.
- Qualidade automatizada (review por IA, type-safety end-to-end, CI local).
- Ferramentas de produtividade no M-series em alta na indústria.

> Decisões aqui são **firmes mas revisáveis** — a próxima rodada pode promover algo da lista acima a decisão.

---

*Consolidado a partir das opiniões de Perplexity (`SETUP-MAC-M5.md`) e GPT (`mac-dev-environment-2026.md`) sobre o setup Intel atual (`github.com/eufelipe/dev-environment`). Marcações [Fato]/[Consenso]/[Opinião] propositais. Versões de runtime são exemplos — ajuste por projeto.*
