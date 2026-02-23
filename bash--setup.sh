#!/bin/bash

# --- CONFIGURACIÓN ---
CONDA_DIR="$HOME/miniconda3"
ENV_FILE="$HOME/.bash_dev_env"
PACKAGES="neovim bat ripgrep fzf zoxide eza btop tldr just uv yazi duf rust"

echo "🚀 Iniciando configuración modular para $USER..."

# 1. Instalar Miniconda si no existe
if [ ! -d "$CONDA_DIR" ]; then
  echo "📦 Instalando Miniconda..."
  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
  bash miniconda.sh -b -p "$CONDA_DIR"
  rm miniconda.sh
  "$CONDA_DIR/bin/conda" init bash
fi

# 2. Crear/Limpiar el archivo de configuración independiente
echo "# --- ENTORNO DE DESARROLLO (MODULAR) ---" >"$ENV_FILE"

# 3. Instalar herramientas
source "$CONDA_DIR/etc/profile.d/conda.sh"
conda activate base
echo "🛠 Instalando paquetes..."
conda install -y -c conda-forge $PACKAGES

# 4. Escribir Alias y Configuración en el archivo independiente
cat <<'EOF' >>"$ENV_FILE"
# Alias de herramientas
alias cat='bat'
alias ls='eza --icons'
alias l='eza -lh --icons'
alias n='nvim'
alias grep='rg'
alias y='yazi'
alias df='duf'
alias fe='nvim $(fzf)'

# Configuraciones de entorno
export FZF_DEFAULT_COMMAND='rg --files --hidden --no-ignore-vcs --glob "!.git/*"'
eval "$(zoxide init bash)"

# Indicador visual de que el entorno está activo (opcional)
echo "✨ Entorno de desarrollo activado."
EOF

# 5. Puerta de enlace en .bashrc (Solo una vez)
ENTRY_LINE="[ -f $ENV_FILE ] && source $ENV_FILE"
if ! grep -qF "$ENV_FILE" ~/.bashrc; then
  echo -e "\n# Carga del entorno de desarrollo modular\n$ENTRY_LINE" >>~/.bashrc
fi

echo "✅ Configuración completada."
echo "👉 Ejecuta: source ~/.bashrc"
