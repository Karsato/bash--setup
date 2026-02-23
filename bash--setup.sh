#!/bin/bash

# --- CONFIGURACIÓN ---
CONDA_DIR="$HOME/miniconda3"
ENV_FILE="$HOME/.bash_dev_env"
PACKAGES="neovim bat ripgrep fzf zoxide eza btop tldr just uv yazi duf rust"

# --- FUNCIÓN DE DESINSTALACIÓN ---
uninstall_env() {
  echo "🗑 Iniciando desinstalación completa..."
  [ -f "$ENV_FILE" ] && rm "$ENV_FILE"
  [ -d "$CONDA_DIR" ] && rm -rf "$CONDA_DIR"

  for RC in "$HOME/.bashrc" "$HOME/.zshrc"; do
    if [ -f "$RC" ]; then
      sed -i "/# Carga de entorno de asignatura/d" "$RC"
      sed -i "\|\[ -f $ENV_FILE \]|d" "$RC"
    fi
  done
  echo "✨ Todo limpio. Cierra y abre la terminal."
  exit 0
}

if [ "$1" == "--uninstall" ]; then
  uninstall_env
fi

echo "🚀 Configurando entorno para $USER..."

# 1. Instalación de Miniconda
if [ ! -d "$CONDA_DIR" ]; then
  echo "📦 Instalando Miniconda..."
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

# 4. Crear el archivo de entorno modular
echo "📝 Creando $ENV_FILE..."
cat <<'EOF' >"$ENV_FILE"
# --- CONFIGURACIÓN DE ENTORNO MODULAR ---

# Cargar Conda y activar entorno base
if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
    source "$HOME/miniconda3/etc/profile.d/conda.sh"
    conda activate base
fi

# Alias de herramientas
alias cat='bat'
alias ls='eza --icons'
alias l='eza -lh --icons'
alias n='nvim'
alias grep='rg'
alias y='yazi'
alias df='duf'
alias fe='nvim $(fzf)'
alias despertar='make -C ~/make servidor--despertar'

# Configuración de FZF y Zoxide
export FZF_DEFAULT_COMMAND='rg --files --hidden --no-ignore-vcs --glob "!.git/*"'
eval "$(zoxide init $(basename ${SHELL:-bash}))"
EOF

# 5. Añadir a los archivos de inicio (.bashrc y .zshrc)
ENTRY_LINE="[ -f $ENV_FILE ] && source $ENV_FILE"
for RC in "$HOME/.bashrc" "$HOME/.zshrc"; do
  if [ -f "$RC" ]; then
    if ! grep -qF "$ENV_FILE" "$RC"; then
      echo -e "\n# Carga de entorno de asignatura\n$ENTRY_LINE" >>"$RC"
    fi
  fi
done

echo "🎉 ¡Configuración finalizada con éxito!"
echo "👉 Ejecuta 'source $ENV_FILE' para activar los alias ahora."
