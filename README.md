# Dotfiles

Este repositorio contiene mis configuraciones personales y de entorno de desarrollo para sincronizar entre diferentes Macs.

## 📦 Contenido

- **Configuración de shell**: `.zshrc` con configuración de Zsh y Powerlevel9k
- **Configuración de Git**: `.gitconfig` con mis preferencias
- **Configuración de SSH**: `.ssh/config` (plantilla sin claves privadas)
- **Variables de entorno**: `.env.example` (plantilla para API keys y secretos)
- **Brewfile**: Lista de todas las aplicaciones instaladas vía Homebrew

## 🚀 Instalación rápida

En una Mac nueva, ejecuta:

```bash
git clone https://github.com/angelloor/dotfiles.git ~/dotfiles
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

## ⚠️ Notas de seguridad

- **Nunca** comitees claves privadas SSH al repositorio
- Las API keys y secretos deben ir en `~/.env` (archivo local, no versionado)
- Usa `.env.example` como plantilla para configurar tus variables de entorno
- Revisa el `.gitignore` para ver qué archivos están excluidos
- Haz backup de tus configuraciones actuales antes de ejecutar el script de instalación

## 🔐 Configurar variables de entorno

Después de clonar el repositorio:

```bash
# Copiar la plantilla
cp ~/dotfiles/.env.example ~/.env

# Editar y agregar tus API keys reales
nano ~/.env

# El .zshrc ya está configurado para cargar ~/.env automáticamente
```

## 🛠️ Mantenimiento

Para agregar nuevas configuraciones al repositorio:

1. Copia el archivo a `~/dotfiles/`
2. Actualiza el script `install.sh` para crear el symlink correspondiente
3. Commit y push los cambios

---

**Autor**: Angel Loor  
**Repositorio**: https://github.com/angelloor/dotfiles
