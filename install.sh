#!/usr/bin/env bash

REPO_DIR="$(cd "$(dirname "$0")"; pwd)"

declare -A FILES_MAP=(
  [".aliases"]="$REPO_DIR/zsh/aliases"
  [".exports"]="$REPO_DIR/zsh/exports"
  [".functions"]="$REPO_DIR/zsh/functions"
  [".zshrc"]="$REPO_DIR/zsh/zshrc"
  [".gitconfig"]="$REPO_DIR/git/gitconfig"
)

# ------------------------------------------------------------------------------
# INSTALAÇÃO
# ------------------------------------------------------------------------------

for file in "${!FILES_MAP[@]}"; do
  src="${FILES_MAP[$file]}"
  dest="$HOME/$file"

  # BACKUP
  if [[ -e "$dest" && ! -L "$dest" ]]; then
    echo "Encontrado arquivo existente: $dest -> fazendo backup."
    mv "$dest" "$dest.bak"
  fi

  # LINK SYMBOLIC
  echo "Criando link simbólico: $dest -> $src"
  ln -sfn "$src" "$dest"
done

echo "Instalação finalizada."