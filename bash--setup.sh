#!/bin/bash

# --- CONFIGURACIÓN ---
CONDA_DIR="$HOME/miniconda3"
# Añadidos yazi y duf a la lista
PACKAGES="nvim bat ripgrep fzf zoxide eza btop tldr just uv yazi duf"

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

# Cargar conda en la sesión actual del script para poder instalar paquetes inmediatamente
source "$CONDA_DIR/etc/profile.d/conda.sh"
conda activate base

# 2. Instalar herramientas desde conda-forge
echo "🛠 Instalando herramientas modernas ($PACKAGES)..."
# Usamos -y para que no pida confirmación y acepte los términos automáticamente
conda install -y -c conda-forge $PACKAGES

# 3. Configurar Alias y Variables de Entorno
echo "📝 Configurando alias y funciones en .bashrc..."

# Función para añadir líneas sin duplicar
add_to_bashrc() {
    grep -qF "$1" ~/.bashrc || echo "$1" >> ~/.bashrc
}

add_to_bashrc ""
add_to_bashrc "# --- CONFIGURACIÓN PERSONAL ---"
add_to_bashrc "alias cat='bat'"
add_to_bashrc "alias ls='eza --icons'"
add_to_bashrc "alias l='eza -lh --icons'"
add_to_bashrc "alias n='nvim'"
add_to_bashrc "alias grep='rg'"
add_to_bashrc "alias y='yazi'"
add_to_bashrc "alias df='duf'"
add_to_bashrc "alias despertar='make -C ~/make servidor--despertar'"

# Alias "fe": Busca archivos interactivamente y los abre con nvim
add_to_bashrc 'alias fe="nvim \$(fzf)"'

# Configuración de FZF para que use ripgrep (ignora .git y archivos ocultos innecesarios)
add_to_bashrc "export FZF_DEFAULT_COMMAND='rg --files --hidden --no-ignore-vcs --glob \"!.git/*\"'"

# Inicializar zoxide en el bashrc
add_to_bashrc 'eval "$(zoxide init bash)"'

echo "🎉 ¡Todo listo! Las herramientas están instaladas y los alias configurados."
echo "👉 IMPORTANTE: Ejecuta 'source ~/.bashrc' para activar todo ahora mismo."
