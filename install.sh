#!/usr/bin/env bash

###############################################################################
# Dotfiles Installation Script
# Instalación automatizada de configuración de desarrollo para macOS
###############################################################################

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Directorios
DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

###############################################################################
# Funciones auxiliares
###############################################################################

print_info() {
    echo -e "${BLUE}ℹ ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

###############################################################################
# 1. Verificar que estamos en el directorio correcto
###############################################################################

if [ ! -d "$DOTFILES_DIR" ]; then
    print_error "Directorio $DOTFILES_DIR no encontrado"
    print_info "Clona el repositorio primero: git clone <repo-url> $DOTFILES_DIR"
    exit 1
fi

cd "$DOTFILES_DIR"
print_success "Directorio de dotfiles encontrado: $DOTFILES_DIR"

###############################################################################
# 2. Instalar Homebrew si no está instalado
###############################################################################

print_info "Verificando instalación de Homebrew..."

if ! command -v brew &> /dev/null; then
    print_warning "Homebrew no está instalado. Instalando..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Configurar Homebrew en el PATH para Apple Silicon
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    
    print_success "Homebrew instalado correctamente"
else
    print_success "Homebrew ya está instalado"
fi

###############################################################################
# 3. Instalar aplicaciones desde Brewfile
###############################################################################

if [ -f "$DOTFILES_DIR/Brewfile" ]; then
    print_info "Instalando aplicaciones desde Brewfile..."
    brew bundle --file="$DOTFILES_DIR/Brewfile"
    print_success "Aplicaciones instaladas"
else
    print_warning "Brewfile no encontrado, saltando instalación de aplicaciones"
fi

###############################################################################
# 4. Crear backup de configuraciones existentes
###############################################################################

print_info "Creando backup de configuraciones existentes..."
mkdir -p "$BACKUP_DIR"

files_to_backup=(
    ".zshrc"
    ".bashrc"
    ".gitconfig"
    ".ssh/config"
)

for file in "${files_to_backup[@]}"; do
    if [ -f "$HOME/$file" ] || [ -d "$HOME/$file" ]; then
        cp -r "$HOME/$file" "$BACKUP_DIR/" 2>/dev/null || true
        print_success "Backup creado: $file"
    fi
done

print_success "Backup guardado en: $BACKUP_DIR"

###############################################################################
# 5. Crear enlaces simbólicos
###############################################################################

print_info "Creando enlaces simbólicos..."

# Función para crear symlink
create_symlink() {
    local source="$1"
    local target="$2"
    
    # Crear directorio padre si no existe
    mkdir -p "$(dirname "$target")"
    
    # Eliminar archivo/link existente
    if [ -e "$target" ] || [ -L "$target" ]; then
        rm -rf "$target"
    fi
    
    # Crear symlink
    ln -sf "$source" "$target"
    print_success "Enlace creado: $target -> $source"
}

# Archivos de configuración principales
create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"

# SSH config
if [ -f "$DOTFILES_DIR/.ssh/config" ]; then
    mkdir -p "$HOME/.ssh"
    create_symlink "$DOTFILES_DIR/.ssh/config" "$HOME/.ssh/config"
    chmod 600 "$HOME/.ssh/config"
fi

# Configuración de Starship (si existe)
if [ -f "$DOTFILES_DIR/starship.toml" ]; then
    mkdir -p "$HOME/.config"
    create_symlink "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"
fi

# Configuración de Neovim (si existe)
if [ -d "$DOTFILES_DIR/nvim" ]; then
    mkdir -p "$HOME/.config"
    create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
fi

# Aliases personalizados (si existen)
if [ -f "$DOTFILES_DIR/.aliases" ]; then
    create_symlink "$DOTFILES_DIR/.aliases" "$HOME/.aliases"
fi

if [ -f "$DOTFILES_DIR/.functions" ]; then
    create_symlink "$DOTFILES_DIR/.functions" "$HOME/.functions"
fi

###############################################################################
# 6. Instalar oh-my-zsh si no está instalado
###############################################################################

print_info "Verificando instalación de oh-my-zsh..."

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_warning "oh-my-zsh no está instalado. Instalando..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_success "oh-my-zsh instalado"
else
    print_success "oh-my-zsh ya está instalado"
fi

###############################################################################
# 7. Instalar plugins comunes de oh-my-zsh
###############################################################################

print_info "Instalando plugins de oh-my-zsh..."

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    print_success "Plugin instalado: zsh-autosuggestions"
else
    print_success "Plugin ya instalado: zsh-autosuggestions"
fi

# zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    print_success "Plugin instalado: zsh-syntax-highlighting"
else
    print_success "Plugin ya instalado: zsh-syntax-highlighting"
fi

###############################################################################
# 8. Configurar Git
###############################################################################

print_info "Configurando Git..."

# Verificar si el usuario de Git está configurado
if [ -z "$(git config --global user.name)" ]; then
    print_warning "Nombre de usuario de Git no configurado"
    read -p "Ingresa tu nombre: " git_name
    git config --global user.name "$git_name"
fi

if [ -z "$(git config --global user.email)" ]; then
    print_warning "Email de Git no configurado"
    read -p "Ingresa tu email: " git_email
    git config --global user.email "$git_email"
fi

print_success "Git configurado correctamente"

###############################################################################
# 9. Configurar permisos
###############################################################################

print_info "Configurando permisos..."

# Asegurar permisos correctos para .ssh
if [ -d "$HOME/.ssh" ]; then
    chmod 700 "$HOME/.ssh"
    chmod 600 "$HOME/.ssh/"* 2>/dev/null || true
    print_success "Permisos de SSH configurados"
fi

###############################################################################
# 10. Recargar configuración de shell
###############################################################################

print_info "Recargando configuración de shell..."

# Cambiar a zsh si no es el shell predeterminado
if [ "$SHELL" != "$(which zsh)" ]; then
    print_warning "zsh no es tu shell predeterminado"
    print_info "Puedes cambiarlo con: chsh -s $(which zsh)"
fi

###############################################################################
# Finalización
###############################################################################

echo ""
print_success "=========================================="
print_success "  ¡Instalación completada con éxito!"
print_success "=========================================="
echo ""
print_info "Próximos pasos:"
echo "  1. Reinicia tu terminal o ejecuta: source ~/.zshrc"
echo "  2. Revisa tu backup en: $BACKUP_DIR"
echo "  3. Personaliza tus configuraciones según sea necesario"
echo ""
print_info "VSCode Settings Sync:"
echo "  - Habilita Settings Sync en VSCode (Cmd+Shift+P > Settings Sync: Turn On)"
echo "  - Sincroniza con tu cuenta de GitHub o Microsoft"
echo ""
