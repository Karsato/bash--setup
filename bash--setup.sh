#!/bin/bash

# --- CONFIGURACIÓN ---
CONDA_DIR="$HOME/miniconda3"
PACKAGES="nvim bat ripgrep fzf zoxide eza btop tldr just uv"

echo "🚀 Iniciando configuración de entorno para $USER..."

# 1. Instalar Miniconda si no existe
if [ ! -d "$CONDA_DIR" ]; then
    echo "📦 Descargando e instalando Miniconda..."
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
    bash miniconda.sh -b -p "$CONDA_DIR"
    rm miniconda.sh
    # Inicializar conda para bash
    "$CONDA_DIR/bin/conda" init bash
    echo "✅ Miniconda instalado."
else
    echo "✔ Miniconda ya está instalado."
fi

# Cargar conda en la sesión actual del script
source "$CONDA_DIR/etc/profile.d/conda.sh"
conda activate base

# 2. Instalar herramientas desde conda-forge
echo "🛠 Instalando herramientas modernas ($PACKAGES)..."
conda install -y -c conda-forge $PACKAGES

# 3. Configurar Alias y Variables de Entorno
echo "📝 Configurando alias en .bashrc..."

# Función para añadir líneas sin duplicar
add_to_bashrc() {
    grep -qF "$1" ~/.bashrc || echo "$1" >> ~/.bashrc
}

add_to_bashrc "# --- MIS ALIAS ---"
add_to_bashrc "alias cat='bat'"
add_to_bashrc "alias ls='eza --icons'"
add_to_bashrc "alias l='eza -lh --icons'"
add_to_bashrc "alias n='nvim'"
add_to_bashrc "alias grep='rg'"
add_to_bashrc "alias despertar='make -C ~/make servidor--despertar'"

# Inicializar zoxide en el bashrc
add_to_bashrc 'eval "$(zoxide init bash)"'

echo "🎉 ¡Todo listo! Por favor, ejecuta: source ~/.bashrc"
