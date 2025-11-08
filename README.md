# Dotfiles

Este repositorio contiene mis configuraciones personales y de entorno de desarrollo para sincronizar entre diferentes Macs.

## 📦 Contenido

- **Configuración de shell**: `.zshrc`, aliases y funciones personalizadas
- **Configuración de Git**: `.gitconfig` con mis preferencias
- **Configuración de SSH**: `.ssh/config` (sin claves privadas)
- **Configuración de editores**: VSCode, Neovim
- **Configuración de terminal**: Starship prompt
- **Brewfile**: Lista de todas las aplicaciones instaladas vía Homebrew

## 🚀 Instalación rápida

En una Mac nueva, ejecuta:

```bash
git clone git@github.com:<TU_USUARIO>/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

El script `install.sh` se encargará de:

- ✅ Instalar Homebrew si no está disponible
- ✅ Instalar todas las aplicaciones del Brewfile
- ✅ Crear enlaces simbólicos a los archivos de configuración
- ✅ Configurar oh-my-zsh y plugins comunes
- ✅ Configurar el entorno de desarrollo

## 🔧 Uso manual

Si prefieres instalar componentes específicos:

```bash
# Instalar aplicaciones de Homebrew
brew bundle --file=~/dotfiles/Brewfile

# Crear enlaces simbólicos manualmente
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
# ... etc
```

## 📝 Actualizar dotfiles

Después de hacer cambios en tu configuración:

```bash
cd ~/dotfiles
git add .
git commit -m "Descripción de los cambios"
git push
```

## ⚠️ Notas

- Las claves privadas SSH nunca se incluyen en este repositorio
- Revisa el `.gitignore` para ver qué archivos están excluidos
- Haz backup de tus configuraciones actuales antes de ejecutar el script de instalación

## 🛠️ Mantenimiento

Para agregar nuevas configuraciones al repositorio:

1. Copia el archivo a `~/dotfiles/`
2. Actualiza el script `install.sh` para crear el symlink correspondiente
3. Commit y push los cambios

---

**Última actualización**: $(date +%Y-%m-%d)
