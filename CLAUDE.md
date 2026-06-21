# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## O que é este repo

Dotfiles do macOS (Apple Silicon / M5) gerenciados por **chezmoi** + **Homebrew Brewfile**.
Não é uma aplicação — não há build, servidor nem suíte de testes. O "deploy" é aplicar a
fonte versionada (este repo) sobre os arquivos da home (`~/.zshrc` etc.). Idioma do repo:
português (comentários e docs).

Docs de referência (não duplicar aqui): `README.md` (visão geral), `SETUP.md` (runbook de
máquina nova, ordem importa), `CHEATSHEET.md` (glossário de cada CLI + comandos chezmoi/mise).

## Regra cardinal: fonte vs alvo

Cada dotfile tem **duas cópias**: a **fonte** neste repo (`dot_zshrc`) e o **alvo** vivo na
home (`~/.zshrc`). O shell lê o alvo; o git versiona a fonte.

- **Edite SEMPRE a fonte deste repo** (ou `chezmoi edit ~/.zshrc`). Nunca edite `~/.zshrc`
  diretamente — o próximo `chezmoi apply` sobrescreve e a mudança se perde.
- Convenção de nomes do chezmoi: prefixo `dot_` → `.` no alvo. `dot_zshrc` → `~/.zshrc`;
  `dot_config/starship.toml` → `~/.config/starship.toml`.
- `.chezmoiignore` lista o que fica no repo mas **não** é aplicado à home (docs, `Brewfile`,
  `scripts/`, `legacy/`, `.vscode`, `.github`). Ao adicionar um arquivo de doc/tooling novo
  que não deva virar dotfile, inclua-o aqui.

## Fluxo de trabalho

```bash
chezmoi diff               # dry-run: o que mudaria na home (revisar SEMPRE antes de aplicar)
chezmoi apply -v           # aplica a fonte -> home
chezmoi cd                 # entra em ~/Projects/dev-environment para git commit/push
```

- chezmoi **não commita sozinho**: depois do `apply`, faça `git add/commit/push` manualmente.
- A fonte do chezmoi é fixada em `~/.config/chezmoi/chezmoi.toml` (`sourceDir`), não pelo flag
  `--source` (que não persiste entre comandos).
- Pacotes: `brew bundle --file=~/Projects/dev-environment/Brewfile`. O `Brewfile` é declarativo
  e escopado **só a ferramentas de dev** — apps pessoais/App Store ficam em `SOFTWARES.md`.
- Runtimes (node/ruby/python/java) só por **mise**; `pnpm`/`yarn` só por **Corepack**. Nunca
  via brew nem global. Config global do mise em `dot_config/mise/config.toml` (edite a fonte).

## Restrições arquiteturais (não óbvias)

- **Ordem do PATH é load-bearing.** Em `dot_zshrc`, o `mise activate` roda **por último** de
  propósito, para que as versões do mise venham antes do Android SDK e do sistema. O Android SDK
  é *appendado* (fim do PATH) em `dot_exports`. `typeset -U path` deduplica. Vários commits já
  corrigiram isso — preserve a ordem ao mexer em `dot_zshrc`/`dot_exports`.
- **Cadeia de sourcing do shell:** `dot_zshrc` carrega, nesta ordem, `~/.exports` → `~/.aliases`
  → `~/.functions`, depois `mise activate`, e por fim `~/.zshrc.local`. Guardas `command -v`/`[ -f ]`
  mantêm o arquivo portável (não quebra onde mise/starship/zoxide ainda não existem).

## Limites de segredos e identidade (arquivos fora do git)

Estes existem só na máquina e **não** estão (nem devem entrar) no repo:

- `~/.zshrc.local` — ajustes só-desta-máquina (atalhos de projeto, etc.).
- `~/.gitconfig.local` — `user.signingkey` (chave **pública** do 1Password) + `gpgsign = true`.
  É `[include]`-ado por último no `dot_gitconfig`, sobrescrevendo o `gpgsign = false` padrão.
- `~/.gitconfig-work` — e-mail de trabalho, carregado via `includeIf "gitdir/i:~/Projects/work/**"`.

Segredos ficam no **1Password** (`op`), nunca em texto no repo. SSH e assinatura de commit usam
o agente do 1Password (chave off-disk). Respeite as regras de `dot_claude/CLAUDE.md` (que vira
`~/.claude/CLAUDE.md`): não ler `~/.ssh`/`~/.aws`/Group Containers, não varrer o FS por segredos.

## legacy/

Setup arquivado do Mac Intel (install.sh, gitconfig/zsh antigos). Referência histórica — **não**
é config ativa. Não edite como se fosse aplicado; o setup atual é chezmoi + Brewfile.

## Verificação

Não há lint/test formal. Antes de aplicar mudanças de shell, confira que `chezmoi diff` mostra só
o esperado. Sanidade pós-setup: `mise doctor && brew doctor && op whoami` e versões dos runtimes
(`node -v`, `ruby -v`, `java -version`). Para validar um `.sh`, prefira `shellcheck` se disponível.
