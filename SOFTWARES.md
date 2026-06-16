# Softwares fora do Brewfile

Apps que instalo **manualmente** — App Store, download direto, ou pessoais que prefiro
não automatizar. O que é ferramenta de dev e instala limpo via Homebrew está no `Brewfile`.

## App Store / download direto (sem cask confiável)

| App | Para quê | Link |
|---|---|---|
| SideNotes | Notas na borda da tela | https://www.apptorium.com/sidenotes |
| TextSniper | OCR (extrair texto de imagem/tela) | https://www.textsniper.app |
| DemoPro | Gravação de demo com destaque de cliques/teclas | App Store |

## Pessoais (têm cask, mas mantidos manuais por escolha)

| App | Para quê | Cask (se quiser via brew) |
|---|---|---|
| Obsidian | Notas / PKM | `cask "obsidian"` |
| Notion | Docs / colaboração | `cask "notion"` |
| Discord | Comunicação | `cask "discord"` |
| LanguageTool | Revisão de texto/gramática | `cask "languagetool"` |

## Outros / a decidir

| Item | Observação |
|---|---|
| Apidog | Cliente de API. Avaliando trocar por **Bruno** (local-first, no menu do Brewfile). `cask "apidog"` |
| Codex | É CLI (npm/agente), não app — instalar no fluxo de dev, não aqui. |

> Candidatos a testar (estão comentados no `Brewfile`): Bruno, TablePlus, Keka, Ghostty, Zed, superwhisper.
> Ao adotar um de verdade, promova do menu do Brewfile (ou daqui) para o auto-install.
