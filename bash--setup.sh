#!/bin/bash

# --- CONFIGURACIÓN ---
CONDA_DIR="$HOME/miniconda3"
ENV_FILE="$HOME/.bash_dev_env"
PACKAGES="neovim bat ripgrep fzf zoxide eza btop tldr just uv yazi duf rust"

# --- FUNCIÓN DE DESINSTALACIÓN ---
uninstall_env() {
  echo "🗑 Iniciando desinstalación..."
  [ -f "$ENV_FILE" ] && rm "$ENV_FILE"
  [ -d "$CONDA_DIR" ] && rm -rf "$CONDA_DIR"

  for RC in "$HOME/.bashrc" "$HOME/.zshrc"; do
    if [ -f "$RC" ]; then
      sed -i "/# Carga de entorno de asignatura/d" "$RC"
      sed -i "\|\[ -f $ENV_FILE \]|d" "$RC"
    fi
  done
  echo "✨ Sistema limpio."
  exit 0
}

if [ "$1" == "--uninstall" ]; then
  uninstall_env
fi

echo "🚀 Configurando entorno para $USER..."

# 1. Instalación de Miniconda
if [ ! -d "$CONDA_DIR" ]; then
  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
  bash miniconda.sh -b -p "$CONDA_DIR"
  rm miniconda.sh
fi

# 2. Cargar para instalación inmediata
source "$CONDA_DIR/etc/profile.d/conda.sh"
conda config --set auto_activate_base true --quiet
conda config --add channels conda-forge --quiet

# 3. Instalación de paquetes
echo "🛠 Instalando paquetes..."
conda install -y $PACKAGES

# 4. Crear el archivo de entorno (Solo con lo esencial)
echo "📝 Creando $ENV_FILE..."
cat <<'EOF' >"$ENV_FILE"
# --- CONFIGURACIÓN DE ENTORNO ---

# Si quieres desactivar todo, descomenta la siguiente línea:
# return 0 

# Cargar Conda y activar base
if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
    source "$HOME/miniconda3/etc/profile.d/conda.sh"
    conda activate base
fi

# Alias básicos
alias cat='bat'
alias ls='eza --icons'
alias l='eza -lh --icons'
alias n='nvim'
alias grep='rg'
alias y='yazi'
alias df='duf'
alias fe='nvim $(fzf)'
alias despertar='make -C ~/make servidor--despertar'

# Herramientas
export FZF_DEFAULT_COMMAND='rg --files --hidden --no-ignore-vcs --glob "!.git/*"'

# Zoxide (detecta automáticamente el shell)
eval "$(zoxide init $(basename $SHELL))"
EOF

# 5. Añadir a los archivos de inicio
ENTRY_LINE="[ -f $ENV_FILE ] && source $ENV_FILE"
for RC in "$HOME/.bashrc" "$HOME/.zshrc"; do
  if [ -f "$RC" ]; then
    grep -qF "$ENV_FILE" "$RC" || echo -e "\n# Carga de entorno de asignatura\n$ENTRY_LINE" >>"$RC"
  fi
done

echo "🎉 ¡Hecho! Ejecuta 'source ~/.bashrc' o 'source ~/.zshrc' para empezar."
