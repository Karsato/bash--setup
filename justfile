# Justfile para el entorno de desarrollo modular

# Establecer Bash como shell por defecto para las recetas
set shell := ["bash", "-c"]

# Muestra la ayuda por defecto
default:
    @just --list

# --- GESTIÓN DEL ENTORNO ---

# Instalar o actualizar el entorno completo
bash--setup:
    ./bash--setup.sh

# Desinstalar Conda y limpiar archivos de configuración
bash--uninstall:
    ./bash--setup.sh --uninstall

# Forzar una recarga del archivo de configuración en la terminal actual
bash--reload:
    source ~/.bash_dev_env && echo "✅ Entorno recargado"

# --- MANTENIMIENTO ---

# Actualizar todos los paquetes de conda a la última versión
bash--update:
    conda update --all -y

# Limpiar la caché de Conda para liberar espacio en disco
bash--clean:
    conda clean --all -y
    @echo "✨ Caché de paquetes y archivos temporales eliminada."

# --- UTILIDADES ---

# Listar todas las herramientas instaladas y sus versiones
bash--info:
    @echo "📋 Herramientas instaladas en el entorno modular:"
    @conda list | grep -E "neovim|bat|ripgrep|fzf|zoxide|eza|btop|tldr|just|uv|yazi|duf|rust"
    @echo -e "\n📍 Ubicación del archivo de alias: $HOME/.bash_dev_env"

# Comprobar si el interruptor del entorno está activo
bash--status:
    @if [ "$DISABLE_DEV_ENV" = "true" ]; then \
        echo "🔴 El entorno está DESACTIVADO (DISABLE_DEV_ENV=true)"; \
    else \
        echo "🟢 El entorno está ACTIVO"; \
    fi
