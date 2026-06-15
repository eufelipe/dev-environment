# dev-environment

Meu ambiente de desenvolvimento (Mac Apple Silicon / M5), gerenciado com
[chezmoi](https://chezmoi.io) + Homebrew Brewfile. Reprodutível e versionado.

## Máquina nova, do zero

```bash
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install chezmoi
chezmoi init --apply eufelipe/dev-environment
brew bundle --file=~/.local/share/chezmoi/Brewfile
mise install
./scripts/macos-defaults.sh
```

## Estrutura

| Caminho | Vira | O quê |
|---|---|---|
| `dot_zshrc` `dot_aliases` `dot_exports` `dot_functions` | `~/.zshrc` etc. | shell |
| `dot_gitconfig` `dot_gitignore_global` | `~/.gitconfig` etc. | git (identidade pessoal por padrão; trabalho via `includeIf`) |
| `dot_config/starship.toml` | `~/.config/starship.toml` | prompt |
| `dot_config/mise/config.toml` | `~/.config/mise/config.toml` | runtimes globais (node, ruby, python, java) |
| `Brewfile` | — | apps e CLIs (declarativo) |
| `scripts/macos-defaults.sh` | — | defaults de macOS (rodar uma vez) |
| `claude/CLAUDE.md` | — | regras globais p/ agentes de IA |
| `legacy/` | — | setup Intel arquivado (referência) |

## Editar

```bash
chezmoi edit ~/.zshrc     # edita a fonte
chezmoi diff              # revisa antes de aplicar
chezmoi apply -v          # aplica
```

## Notas

- Runtimes via **mise** (substitui nvm/pyenv/rbenv do setup Intel). Java pelo mise, não pelo brew.
- pnpm/yarn via **Corepack** (`packageManager` no `package.json`), nunca global.
- Ajustes só-desta-máquina vão em `~/.zshrc.local` (fora do git).
- Decisões e justificativas completas: `SETUP-CONSOLIDADO.md`.
