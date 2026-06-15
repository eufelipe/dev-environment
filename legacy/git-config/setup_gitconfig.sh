#!/bin/bash

# Definir cores para saída
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Instalando configuração do Git...${NC}"

SOURCE_GITCONFIG="git/.gitconfig"

if [ ! -f "$SOURCE_GITCONFIG" ]; then
    echo -e "${RED}Erro: O arquivo $SOURCE_GITCONFIG não existe.${NC}"
    echo -e "${YELLOW}Verifique se o arquivo .gitconfig está presente na pasta git.${NC}"
    exit 1
fi

# backup
if [ -f ~/.gitconfig ]; then
    echo -e "${YELLOW}Fazendo backup do ~/.gitconfig existente para ~/.gitconfig.bak${NC}"
    cp ~/.gitconfig ~/.gitconfig.bak
fi


echo -e "${YELLOW}Copiando $SOURCE_GITCONFIG para ~/.gitconfig...${NC}"
cp "$SOURCE_GITCONFIG" ~/.gitconfig


if [ $? -eq 0 ] && [ -f ~/.gitconfig ]; then
    echo -e "${GREEN}Configuração do Git instalada com sucesso!${NC}"
else
    echo -e "${RED}Erro ao copiar o arquivo .gitconfig${NC}"
    exit 1
fi 