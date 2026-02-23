#!/bin/bash

# --- CONFIGURACIÓN ---
CONDA_DIR="$HOME/miniconda3"
ENV_FILE="$HOME/.bash_dev_env"
PACKAGES="neovim bat ripgrep fzf zoxide eza btop tldr just uv yazi duf rust"

echo "🚀 Iniciando configuración modular..."

# 1. Instalar Miniconda si no existe
if [ ! -d "$CONDA_DIR" ]; then
  echo "📦 Instalando Miniconda..."
  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
  bash miniconda.sh -b -p "$CONDA_DIR"
  rm miniconda.sh
fi

# 2. Cargar Conda para la sesión actual del script (evitando errores de shell)
source "$CONDA_DIR/etc/profile.d/conda.sh" 2>/dev/null

# 3. Configurar canales y ToS
echo "⚖️ Configurando canales (prioridad conda-forge)..."
conda config --add channels conda-forge --quiet
conda config --set channel_priority strict --quiet

# 4. Instalar paquetes
echo "🛠 Instalando herramientas..."
conda install -y $PACKAGES

# 5. Crear el archivo de configuración modular con "Interruptor"
echo "📝 Generando $ENV_FILE..."
cat <<'EOF' >"$ENV_FILE"
# --- ENTORNO DE DESARROLLO MODULAR ---

# Si la variable DISABLE_DEV_ENV existe, no cargar nada
if [ -n "$DISABLE_DEV_ENV" ]; then
    return 0
fi

# Evitar errores de compatibilidad Bash/Zsh en scripts de activación
if [ -n "$ZSH_VERSION" ]; then
    emulate -L bash 2>/dev/null
fi

# Cargar Conda
if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
    source "$HOME/miniconda3/etc/profile.d/conda.sh"
    # Silenciar el error específico de toolchain_activate.sh si ocurre
    conda activate base 2>/dev/null
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

# Configuración de herramientas
export FZF_DEFAULT_COMMAND='rg --files --hidden --no-ignore-vcs --glob "!.git/*"'

# Inicializar zoxide según el shell activo
if [ -n "$ZSH_VERSION" ]; then
    eval "$(zoxide init zsh)"
else
    eval "$(zoxide init bash)"
fi
EOF

# 6. Vincular a los archivos de inicio (.bashrc y .zshrc)
ENTRY_LINE="[ -f $ENV_FILE ] && source $ENV_FILE"

for RC in "$HOME/.bashrc" "$HOME/.zshrc"; do
  if [ -f "$RC" ]; then
    grep -qF "$ENV_FILE" "$RC" || echo -e "\n# Carga de entorno modular\n$ENTRY_LINE" >>"$RC"
  fi
done

echo "🎉 ¡Hecho! El error '=' debería desaparecer al reiniciar."
echo "👉 Para desactivar temporalmente: export DISABLE_DEV_ENV=true"
