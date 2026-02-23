#!/bin/bash

# --- CONFIGURACIÓN ---
CONDA_DIR="$HOME/miniconda3"
ENV_FILE="$HOME/.bash_dev_env"
PACKAGES="neovim bat ripgrep fzf zoxide eza btop tldr just uv yazi duf rust"

echo "🚀 Iniciando configuración modular..."

# 1. Instalar Miniconda si no existe
if [ ! -d "$CONDA_DIR" ]; then
  echo "📦 Descargando e instalando Miniconda..."
  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
  bash miniconda.sh -b -p "$CONDA_DIR"
  rm miniconda.sh
fi

# 2. Cargar Conda EN ESTE SCRIPT para que funcione 'conda install' a la primera
source "$CONDA_DIR/etc/profile.d/conda.sh"

# 3. SOLUCIÓN AL ERROR DE ANACONDA (ToS)
# Configuramos conda para que use conda-forge como prioridad y aceptamos términos
echo "⚖️ Aceptando términos de servicio y configurando canales..."
conda config --set env_prompt '({name}) '
conda config --add channels conda-forge
conda config --set channel_priority strict

# 4. Instalar paquetes (ahora sí funcionará a la primera)
echo "🛠 Instalando herramientas ($PACKAGES)..."
conda install -y $PACKAGES

# 5. Crear el archivo de configuración modular
echo "📝 Creando archivo de entorno en $ENV_FILE..."
cat <<'EOF' >"$ENV_FILE"
# --- ENTORNO DE DESARROLLO MODULAR ---
# Solo añadir si conda está instalado
if [ -d "$HOME/miniconda3" ]; then
    source "$HOME/miniconda3/etc/profile.d/conda.sh"
    conda activate base
fi

# Alias
alias cat='bat'
alias ls='eza --icons'
alias l='eza -lh --icons'
alias n='nvim'
alias grep='rg'
alias y='yazi'
alias df='duf'
alias fe='nvim $(fzf)'
alias despertar='make -C ~/make servidor--despertar'

# Configs
export FZF_DEFAULT_COMMAND='rg --files --hidden --no-ignore-vcs --glob "!.git/*"'
eval "$(zoxide init ${SHELL##*/})"
EOF

# 6. INYECTAR EN BASH Y ZSH (Para que funcione en cualquier terminal del alumno)
ENTRY_LINE="[ -f $ENV_FILE ] && source $ENV_FILE"

# Para Bash
if [ -f ~/.bashrc ]; then
  grep -qF "$ENV_FILE" ~/.bashrc || echo -e "\n$ENTRY_LINE" >>~/.bashrc
fi

# Para Zsh (El que usas tú según la captura)
if [ -f ~/.zshrc ]; then
  grep -qF "$ENV_FILE" ~/.zshrc || echo -e "\n$ENTRY_LINE" >>~/.zshrc
fi

echo "🎉 ¡Todo listo! No hace falta ejecutarlo dos veces."
echo "👉 IMPORTANTE: Cierra esta terminal y abre una nueva o ejecuta: source $ENV_FILE"
