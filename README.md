# dev-environment

Meu ambiente de desenvolvimento (Mac Apple Silicon / M5), gerenciado com
[chezmoi](https://chezmoi.io) + Homebrew Brewfile. Reprodutível e versionado.

📄 **Roteiro de setup:** [`SETUP.md`](SETUP.md) · **Comandos + glossário:** [`CHEATSHEET.md`](CHEATSHEET.md) · **Apps fora do Brew:** [`SOFTWARES.md`](SOFTWARES.md)

## Máquina nova, do zero (resumo — detalhes no `SETUP.md`)

```bash
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install chezmoi
git clone https://github.com/eufelipe/dev-environment.git ~/Projects/dev-environment
chezmoi init --source=~/Projects/dev-environment   # usa esta pasta como fonte
chezmoi diff                                        # revisar antes
chezmoi apply -v
brew bundle --file=~/Projects/dev-environment/Brewfile
mise install
bash ~/Projects/dev-environment/scripts/macos-defaults.sh
```

## Estrutura

| Caminho | Vira | O quê |
|---|---|---|
| `dot_zshrc` `dot_aliases` `dot_exports` `dot_functions` | `~/.zshrc` etc. | shell |
| `dot_gitconfig` `dot_gitignore_global` | `~/.gitconfig` etc. | git (identidade pessoal; trabalho via `includeIf`) |
| `dot_config/starship.toml` | `~/.config/starship.toml` | prompt |
| `dot_config/mise/config.toml` | `~/.config/mise/config.toml` | runtimes globais (node, ruby, python, java) |
| `dot_claude/CLAUDE.md` | `~/.claude/CLAUDE.md` | regras globais p/ agentes de IA |
| `Brewfile` | — | CLIs + apps de dev (declarativo) |
| `scripts/macos-defaults.sh` | — | defaults de macOS (rodar uma vez) |
| `legacy/` | — | setup Intel arquivado (referência) |

## Editar (fluxo do dia a dia)

```bash
chezmoi edit ~/.zshrc     # edita a fonte (dot_zshrc)
chezmoi diff              # revisa antes de aplicar
chezmoi apply -v          # aplica
chezmoi cd                # vai pra ~/Projects/dev-environment → git commit/push
```

## Notas

- Runtimes via **mise** (substitui nvm/pyenv/rbenv). Java pelo mise, não pelo brew.
- pnpm/yarn via **Corepack** (`packageManager` no `package.json`), nunca global.
- Ajustes só-desta-máquina vão em `~/.zshrc.local` (fora do git).
- Segredos no 1Password; `.env` só com referências `op://` + `op run`.
