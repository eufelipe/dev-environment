# Cheatsheet — dev-environment

Referência rápida: comandos do chezmoi e do mise + o que cada CLI do Brewfile faz.

## chezmoi (dotfiles)

**Modelo mental:** há 2 cópias de cada dotfile — a **fonte** (`dot_zshrc`, no repo) e o **alvo** (`~/.zshrc`, usado pelo shell). Edita a fonte, dá `apply`. **Nunca edite `~/.zshrc` direto.**

```bash
# Setup na máquina nova usando ~/Projects/dev-environment como fonte:
git clone git@github.com:eufelipe/dev-environment.git ~/Projects/dev-environment
chezmoi init --source=~/Projects/dev-environment   # fixa a fonte aqui (some o ~/.local/share/chezmoi)
chezmoi diff                                        # revisar
chezmoi apply -v                                    # aplicar

# Dia a dia:
chezmoi edit ~/.zshrc      # edita a FONTE (dot_zshrc)
chezmoi diff               # preview do que mudaria
chezmoi apply              # fonte -> casa
chezmoi cd                 # vai pra ~/Projects/dev-environment (commit/push aqui)
chezmoi update             # git pull + apply (sincronizar de outra máquina)
chezmoi add ~/.algo        # traz um arquivo da casa PARA o controle do chezmoi
```
> chezmoi **não commita sozinho** — depois do `apply`, faça `git push` (via `chezmoi cd`).

## mise (runtimes)

**Modelo mental:** lê `.mise.toml` na pasta atual/pais e **troca a versão das ferramentas ao entrar na pasta** (já ativado no `.zshrc`). Global: `~/.config/mise/config.toml`.

```bash
mise use node@22         # versão neste projeto (grava .mise.toml) + instala
mise use -g node@lts     # versão global
mise install             # instala tudo que os configs pedem (máquina/projeto novo)
mise ls                  # o que está instalado/ativo
mise current             # versões ativas agora, nesta pasta
mise exec -- <cmd>       # roda com o ambiente do mise, sem ativar
mise trust               # 👈 se a versão não trocar ao entrar na pasta, é isto
```
> mise cuida de **node/ruby/python/java**. `pnpm`/`yarn` vêm do **Corepack**, não do mise.
> Config global do mise é gerenciada pelo chezmoi → mude com `chezmoi edit`, não só `mise use -g`.

---

## Glossário dos CLIs (o que cada um faz)

### Core
| CLI | Para quê |
|---|---|
| git | Controle de versão |
| gh | CLI do GitHub (PRs, repos, auth, releases) |
| chezmoi | Gerenciador de dotfiles |
| mise | Gerenciador de runtimes + env + tasks |
| jq | Filtra/transforma **JSON** na linha de comando |

### Shell e terminal
| CLI | Para quê |
|---|---|
| starship | Prompt do shell (rápido, Rust) |
| zsh-autosuggestions | Sugere comando do histórico enquanto digita (→ aceita) |
| zsh-completions | Completions extras no Tab |
| zsh-syntax-highlighting | Colore o comando enquanto digita (vermelho = inválido) |
| fzf | Busca fuzzy (Ctrl-R histórico, Ctrl-T arquivos) |
| zoxide | `cd` inteligente: `z proj` pula pra pasta mais usada que casa "proj" |
| eza | `ls` moderno (cores, ícones, git status) |
| bat | `cat` com syntax highlight e nº de linha |
| ripgrep (`rg`) | Busca texto recursiva ultrarrápida (respeita .gitignore) |
| fd | `find` moderno e rápido |
| tree | Árvore de diretórios |
| btop | Monitor de recursos no terminal (CPU/RAM/processos) |
| tldr | Exemplos práticos de comandos (man page resumida) |

### Git / dev UX
| CLI | Para quê |
|---|---|
| lazygit | TUI pro git (stage/commit/branch visual) — alias `lg` |
| git-delta | Deixa `git diff`/`git log -p` lindo (syntax, line-numbers) — **já wirado** no `dot_gitconfig` |
| trash | Apaga pra Lixeira (reversível) — alias `del` |

### Mídia / arquivos
| CLI | Para quê |
|---|---|
| yt-dlp | Baixa áudio/vídeo (alias `ytaudio`) |
| sevenzip | Compactador 7-Zip (binário `7zz`), usado pelo `extract()` |

### Containers / mobile
| CLI | Para quê |
|---|---|
| docker / docker-compose | Containers (rodam no OrbStack) |
| watchman | Observador de arquivos (Metro/React Native) |
| fastlane | Automação de build/release mobile |

### Segurança
| CLI | Para quê |
|---|---|
| gitleaks | Varre o repo procurando segredos vazados |
| semgrep | Análise estática (regras de segurança/qualidade) |
| 1password-cli (`op`) | Injeta segredos do 1Password em runtime |
