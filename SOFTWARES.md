# Softwares fora do Brewfile

Apps que instalo **manualmente** — App Store, download direto, ou pessoais que prefiro
não automatizar. O que é ferramenta de dev e instala limpo via Homebrew está no `Brewfile`.

## Dev — instalado, mas exige setup manual pós-instalação

| App | Instalação | Setup manual |
|---|---|---|
| Android Studio | `cask "android-studio"` (Brewfile) | Abrir 1x e instalar: SDK Platform, Platform-Tools, Build-Tools, Emulator, imagem ARM64, Command-line Tools |
| Xcode | App Store | `sudo xcodebuild -license accept` && `xcodebuild -runFirstLaunch` |

## App Store / download direto (sem cask confiável)

| App | Para quê | Link |
|---|---|---|
| SideNotes | Notas na borda da tela | https://www.apptorium.com/sidenotes |
| TextSniper | OCR (extrair texto de imagem/tela) | https://www.textsniper.app |
| DemoPro | Gravação de demo com destaque de cliques/teclas | https://www.demoproapp.com |

## Pessoais (têm cask, mas mantidos manuais por escolha)

| App | Para quê | Cask (se quiser via brew) |
|---|---|---|
| Figma | Design (uso no browser) | `cask "figma"` |
| Obsidian | Notas / PKM | `cask "obsidian"` |
| Notion | Docs / colaboração | `cask "notion"` |
| Discord | Comunicação | `cask "discord"` |
| LanguageTool | Revisão de texto/gramática | `cask "languagetool"` |

## Globais npm (sem fórmula brew equivalente)

| Pacote | Para quê | Instalar |
|---|---|---|
| ntl | Menu interativo dos scripts do `package.json` | `npm i -g ntl` (ou `npx ntl` sob demanda) |


## Manual (GitHub / script — sem brew/npm)

| Ferramenta | Para quê | Instalar |
|---|---|---|
| agent-safehouse | Sandbox no host pros agentes (`claude-safe`) | https://github.com/eugene1g/agent-safehouse |

## Outros / a decidir

| Item | Observação |
|---|---|
| Apidog | Cliente de API. Avaliando trocar por **Bruno** (local-first, no menu do Brewfile). `cask "apidog"` |
| Codex | É CLI (npm/agente), não app — instalar no fluxo de dev, não aqui. |

> Candidatos a testar (estão comentados no `Brewfile`): Bruno, TablePlus, Keka, Ghostty, Zed, superwhisper.
> Ao adotar um de verdade, promova do menu do Brewfile (ou daqui) para o auto-install.
