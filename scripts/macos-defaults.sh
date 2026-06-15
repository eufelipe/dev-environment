#!/usr/bin/env bash
set -euo pipefail
# Roda uma vez numa máquina nova: defaults úteis de macOS para dev/produtividade.

# Finder
defaults write com.apple.finder AppleShowAllFiles -bool true          # mostrar ocultos
defaults write NSGlobalDomain AppleShowAllExtensions -bool true        # sempre mostrar extensão
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true     # path POSIX no título
defaults write com.apple.finder ShowPathbar -bool true                 # barra de caminho
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true  # sem .DS_Store em rede

# Screenshots organizados
mkdir -p "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture location "$HOME/Pictures/Screenshots"

killall Finder || true
echo "✅ Defaults aplicados."
