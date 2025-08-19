# WSL Ubuntu Development Environment

🚀 **Script otomatis untuk setup, cleanup, dan reinstall lingkungan pengembangan di WSL Ubuntu**

Kompatibel dengan semua versi Ubuntu LTS (18.04, 20.04, 22.04, 24.04+)

```bash
# Quick Setup
git clone https://github.com/osiic/dotfiles-ubuntu-wsl.git
cd dotfiles-ubuntu-wsl
chmod +x *.sh
./install.sh
exec zsh
```

## 📋 Daftar Isi

- [Fitur](#-fitur)
- [Persyaratan](#-persyaratan)
- [Instalasi](#-instalasi)
- [Tools yang Diinstall](#-tools-yang-diinstall)
- [Penggunaan](#-penggunaan)
- [Script Management](#-script-management)
- [Struktur Direktori](#-struktur-direktori)
- [Kustomisasi](#-kustomisasi)
- [Troubleshooting](#-troubleshooting)

## 🎯 Fitur

### 🚀 Script Install (`install.sh`)
- ✅ Setup lengkap environment pengembangan modern
- ✅ Konfigurasi Git dan SSH otomatis
- ✅ Install Node.js, Python, dan development tools terbaru
- ✅ Setup Zsh dengan Oh My Zsh + plugins premium
- ✅ Terminal yang cantik dengan Starship prompt
- ✅ Konfigurasi Neovim dan Tmux custom
- ✅ User-friendly dengan interactive prompts

### 🧹 Script Uninstall (`uninstall.sh`)
- 🗑️ **Interactive removal** - pilih apa saja yang mau dihapus
- 🔒 **Backup otomatis** untuk konfigurasi penting
- 🎯 **Granular control** - SSH, Node.js, Python, dll bisa dipilih terpisah
- 🛡️ **Safety first** - multiple confirmation untuk operasi berbahaya
- 🔄 Reset shell dan cleanup system
- ⚠️ **Aman**: Projects directory dilindungi dengan konfirmasi khusus

### 🔄 Script Reinstall (`reinstall.sh`)
- 🚀 **One-click reinstall** - update environment dengan mudah
- 💾 **Auto-backup** semua konfigurasi sebelum reinstall
- 🎯 **Preserve user data** - nama, email, GitHub username tersimpan
- ✨ **Smart detection** - deteksi konfigurasi Git yang sudah ada
- 📋 **Post-install verification** - cek semua tools terinstall dengan benar
- 📄 **Detailed summary** - laporan lengkap setelah reinstall

## 📦 Persyaratan

- WSL2 dengan Ubuntu (18.04/20.04/22.04/24.04+)
- Koneksi internet stabil
- Akses sudo
- GitHub account (untuk SSH key setup)

## 🚀 Instalasi

### 1. Download Scripts

```bash
# Clone repository (recommended)
git clone https://github.com/osiic/dotfiles-ubuntu-wsl.git
cd dotfiles-ubuntu-wsl
```

```bash
# Atau download individual scripts
curl -O https://raw.githubusercontent.com/osiic/dotfiles-ubuntu-wsl/main/install.sh
curl -O https://raw.githubusercontent.com/osiic/dotfiles-ubuntu-wsl/main/uninstall.sh
curl -O https://raw.githubusercontent.com/osiic/dotfiles-ubuntu-wsl/main/reinstall.sh
```

### 2. Setup Permissions

```bash
chmod +x install.sh uninstall.sh reinstall.sh
```

### 3. Fresh Installation

```bash
./install.sh
```

**Script akan meminta:**
- 👤 Nama lengkap
- 📧 Email address
- 🐙 Username GitHub

**Setelah selesai:**
```bash
exec zsh  # Restart shell untuk apply semua perubahan
```

## 🛠 Tools yang Diinstall

### 🔧 Development Tools
- **Git** + **GitHub CLI** - Version control dan manajemen GitHub
- **Neovim** (custom config) - Text editor modern dengan LSP
- **Tmux** (custom config) - Terminal multiplexer
- **Node.js LTS** (via NVM) - JavaScript runtime
- **Python 3** + **Virtual Env** - Python development environment

### 🐚 Terminal Enhancement
- **Zsh** + **Oh My Zsh** - Shell yang powerful
- **Starship** - Cross-shell prompt yang cepat dan cantik
- **Zsh plugins**: autosuggestions, syntax-highlighting, z navigation

### ⚡ CLI Tools
- **fzf** - Fuzzy finder untuk semua kebutuhan
- **ripgrep (rg)** - Pencarian text super cepat
- **bat** - Cat dengan syntax highlighting
- **exa** - ls replacement yang lebih cantik
- **fd** - Find alternative yang lebih cepat
- **lazygit** - Git TUI yang intuitive
- **tldr** - Simplified man pages

### 📦 Package Managers
- **npm/yarn/pnpm/bun** - JavaScript package managers
- **pip/pipx** - Python package management

## 💡 Penggunaan

### Quick Start Commands

```bash
# Navigation & Projects
proj                # cd ~/projects
dev                 # cd ~/projects && nvim .

# File Operations  
ll                  # exa -alF (detailed list)
lt                  # exa -T (tree view)
cat file.txt        # bat file.txt (with highlighting)
grep pattern        # rg pattern (ripgrep)
find name           # fd name (fast find)

# Development
v file.txt          # nvim file.txt
g st                # git status with enhanced info
glg                 # git log with graph
gac "message"       # git add . && git commit -m
lazygit             # visual git interface

# System
sz                  # source ~/.zshrc (reload shell config)
```

### Advanced Git Aliases

```bash
# Comprehensive git status
gs                  # Shows branches, commits, stash, remote, status, diff

# Branch management
gb                  # git branch
gcb feature         # git checkout -b feature
gbd feature         # git branch -D feature

# Quick commits
gac "fix bug"       # git add . && git commit -m "fix bug"  
gca "quick fix"     # git commit -am "quick fix"

# Log and history
glg                 # beautiful git log with graph
gcp hash            # git cherry-pick hash
```

## 🎮 Script Management

### 🔄 Reinstall (Update Environment)

```bash
./reinstall.sh
```

**Perfect untuk:**
- 📡 Update ke konfigurasi terbaru
- 🧹 Clean install tanpa setup ulang
- 🔧 Fix corrupted environment
- ✨ Apply script improvements

**Process:**
1. 💾 Backup semua konfigurasi penting
2. 🗑️ Uninstall environment (interactive)
3. 🚀 Fresh install dengan data tersimpan
4. ✅ Verification dan summary report

### 🗑️ Uninstall (Granular Removal)

```bash
./uninstall.sh
```

**Interactive options:**
- 🔑 SSH keys & configuration
- 📦 Development packages
- 🟢 Node.js environment (NVM, npm packages)
- 🐍 Python virtual environments & packages
- 🐚 Zsh & Oh My Zsh configuration
- 📝 Neovim & Tmux configuration
- 🛠️ Additional tools (lazygit, starship, fzf, etc.)
- 📚 Git global configuration
- 📁 Projects directory (**protected with extra confirmation**)
- 🔄 Shell reset to bash

**Safety features:**
- 🛡️ Auto-backup sebelum penghapusan
- ⚠️ Multiple confirmations untuk operasi berisiko
- 📋 Detailed preview sebelum eksekusi
- 🎯 Granular control - pilih per komponen

## 📁 Struktur Direktori

```
~/
├── projects/              # 🚀 Main development directory
├── tools/                 # 🛠️ Additional development tools
├── scripts/               # 📜 Custom scripts
├── .config/
│   ├── starship.toml     # ⭐ Starship prompt configuration
│   └── nvim/             # 📝 Neovim configuration (custom)
├── .tmux/                # 🪟 Tmux configuration (custom)
├── .oh-my-zsh/           # 🐚 Oh My Zsh installation
├── .nvm/                 # 🟢 Node Version Manager
├── .venvs/               # 🐍 Python virtual environments
├── .local/bin/           # 🔧 Local binaries
└── welcome.txt           # 👋 Quick reference guide
```

## ⚙️ Kustomisasi

### 🎨 Mengubah Prompt Theme

```bash
# Edit Starship config
v ~/.config/starship.toml

# Preview perubahan langsung (restart terminal untuk apply)
```

### 🔧 Menambah Alias Zsh

```bash
# Edit zsh configuration
v ~/.zshrc

# Tambahkan di bagian aliases
alias mycode="cd ~/projects/my-project"
alias deploy="npm run build && npm run deploy"

# Reload configuration
sz
```

### 🟢 Node.js Version Management

```bash
# List semua versi tersedia
nvm list-remote

# Install versi spesifik
nvm install 18.17.0
nvm install 20.10.0

# Switch between versions
nvm use 18.17.0
nvm use 20.10.0

# Set default version
nvm alias default 20.10.0
```

### 🐍 Python Virtual Environment

```bash
# Activate default environment
source ~/.venvs/default/bin/activate

# Create new environment
python3 -m venv ~/.venvs/myproject
source ~/.venvs/myproject/bin/activate

# Install packages in virtual env
pip install requests flask django
```

### 📝 Neovim Customization

```bash
# Custom Neovim config location
~/.config/nvim/

# Main configuration files
~/.config/nvim/init.lua          # Main config
~/.config/nvim/lua/config/       # Custom configurations
~/.config/nvim/lua/plugins/      # Plugin configurations
```

## 🔧 Troubleshooting

### 🔑 SSH Issues

```bash
# Test GitHub SSH connection
ssh -T git@github.com

# If failed, restart SSH agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Check SSH key was added to GitHub
cat ~/.ssh/id_ed25519.pub
# Copy output and add to: https://github.com/settings/keys
```

### 🐚 Shell Problems

```bash
# Check current shell
echo $SHELL

# If not zsh, change it
sudo chsh -s $(which zsh) $USER

# Logout and login again, or
exec zsh
```

### 🟢 Node.js Issues

```bash
# Reload NVM manually
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Check NVM installation
nvm --version

# Reinstall Node.js if needed
nvm install --lts --reinstall-packages-from=current
```

### 🐍 Python Environment Issues

```bash
# Check Python installation
python3 --version
pip --version

# Recreate virtual environment
rm -rf ~/.venvs/default
python3 -m venv ~/.venvs/default
source ~/.venvs/default/bin/activate
pip install --upgrade pip
```

### 🛠️ Permission Issues

```bash
# Fix script permissions
chmod +x install.sh uninstall.sh reinstall.sh

# If still fails, run with bash
bash install.sh
```

### 🔄 Environment Corruption

```bash
# Quick fix: reinstall everything
./reinstall.sh

# Nuclear option: complete cleanup then reinstall
./uninstall.sh  # Remove everything
./install.sh    # Fresh install
```

## 🚨 Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| `command not found: zsh` | Run `sudo apt install zsh` |
| Git push permission denied | Check SSH key in GitHub settings |
| Node.js version not switching | Restart terminal or run `exec zsh` |
| Neovim plugins not working | Run `:PackerSync` inside Neovim |
| Tmux config not loading | Run `tmux source ~/.tmux.conf` |
| Starship prompt not showing | Check if `eval "$(starship init zsh)"` is in ~/.zshrc |

## 🤝 Kontribusi

1. 🍴 Fork repository ini
2. 🌿 Buat branch fitur (`git checkout -b fitur-awesome`)
3. 💾 Commit perubahan (`git commit -m 'Add awesome feature'`)
4. 📤 Push ke branch (`git push origin fitur-awesome`)
5. 🔄 Buat Pull Request

## 📝 Changelog

### v2.0.0 (Latest)
- ✨ **NEW**: `reinstall.sh` script untuk update environment mudah
- ✨ **NEW**: Interactive uninstall dengan granular control
- ✨ **NEW**: Auto-backup system untuk semua konfigurasi
- ✨ **NEW**: Post-install verification dan detailed reporting
- 🔧 **IMPROVED**: Better error handling dan user experience
- 🔧 **IMPROVED**: Smart user data preservation
- 🔧 **IMPROVED**: Enhanced Git aliases dan workflow
- 🛡️ **SECURITY**: Protected projects directory dengan extra confirmation

### v1.0.0
- ✅ Script install lengkap dengan development tools
- ✅ Script uninstall yang aman
- ✅ Support semua Ubuntu LTS versions
- ✅ SSH dan Git setup otomatis

## 📄 Lisensi

MIT License - Bebas digunakan untuk proyek personal maupun komersial!

---

## 🎯 Quick Reference

```bash
# Essential commands setelah install
proj              # Go to projects directory
dev               # Open projects in Neovim  
gs                # Comprehensive git status
v filename        # Edit with Neovim
lazygit           # Visual git interface
sz                # Reload shell configuration

# Script management
./install.sh      # Fresh installation
./uninstall.sh    # Interactive removal
./reinstall.sh    # Update environment
```

**🎉 Selamat coding dengan environment yang powerful dan modern!**

💡 **Pro tip**: Gunakan `./reinstall.sh` setiap kali ada update script untuk mendapatkan fitur terbaru!

---

Jika ada pertanyaan atau masalah, silakan buat issue di repository ini. Kontribusi dan feedback sangat diterima! 🚀
