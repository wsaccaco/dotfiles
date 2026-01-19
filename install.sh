#!/usr/bin/env bash

set -e  # salir si hay error
DOTFILES="$HOME/dotfiles"

echo "📦 Verificando Homebrew..."
if ! command -v brew &>/dev/null; then
  echo "➡️ Instalando Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "✅ Homebrew ya está instalado."
fi

echo "📂 Instalando dependencias con Brewfile..."
brew bundle --file="$DOTFILES/Brewfile"

echo "💻 Verificando Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "➡️ Instalando Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "✅ Oh My Zsh ya está instalado."
fi

echo "🔗 Creando symlinks de dotfiles..."
ln -sf "$DOTFILES/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES/.zprofile" "$HOME/.zprofile"
ln -sf "$DOTFILES/.vimrc" "$HOME/.vimrc"
ln -snf "$DOTFILES/.config" "$HOME/.config"

echo "📄 Configurando aliases..."
mkdir -p "$HOME/.oh-my-zsh/custom"
ln -sf "$DOTFILES/aliases.zsh" "$HOME/.oh-my-zsh/custom/aliases.zsh"

echo "🔌 Instalando plugins de Zsh..."
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "  -> Clonando zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
  echo "  ✅ zsh-autosuggestions ya está instalado"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  echo "  -> Clonando zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
  echo "  ✅ zsh-syntax-highlighting ya está instalado"
fi

echo "⚡ Recargando configuración de Zsh..."
#source "$HOME/.zshrc"

echo "🎉 Setup completado con éxito."

echo "✅ Cambiando a Zsh..."
exec zsh -l
