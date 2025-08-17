# WSL Ubuntu Development Environment

🚀 **Script otomatis untuk setup dan cleanup lingkungan pengembangan di WSL Ubuntu**

Kompatibel dengan semua versi Ubuntu LTS (18.04, 20.04, 22.04, 24.04)
```bash
# Quick Setup
git clone https://github.com/osiic/dotfiles-ubuntu-wsl.git
cd dotfiles-ubuntu-wsl
chmod +x install.sh uninstall.sh
./install.sh
exec zsh
```
```bash
# Hanya untuk developer
git clone https://github.com/osiic/dotfiles-ubuntu-wsl.git
cd dotfiles-ubuntu-wsl
chmod +x install.sh uninstall.sh
./install.sh
git remote set-url origin git@github.com:osiic/dotfiles-ubuntu-wsl.git
ssh -T git@github.com
exec zsh
```

## 📋 Daftar Isi

- [Fitur](#fitur)
- [Persyaratan](#persyaratan)
- [Instalasi](#instalasi)
- [Tools yang Diinstall](#tools-yang-diinstall)
- [Penggunaan](#penggunaan)
- [Uninstall](#uninstall)
- [Struktur Direktori](#struktur-direktori)
- [Troubleshooting](#troubleshooting)

## 🎯 Fitur

### Script Install (`install.sh`)
- ✅ Setup lengkap environment pengembangan
- ✅ Konfigurasi Git otomatis
- ✅ Install Node.js, Python, dan tools modern
- ✅ Setup Zsh dengan Oh My Zsh + plugins
- ✅ Konfigurasi SSH key untuk GitHub
- ✅ Terminal yang cantik dengan Starship prompt

### Script Uninstall (`uninstall.sh`)
- 🧹 Hapus semua tools pengembangan
- 🧹 Reset konfigurasi ke default
- 🧹 Bersihkan cache dan file temporary
- 🧹 Kembalikan shell ke bash
- 🧹 **Aman**: Tidak menghapus folder projects

## 📦 Persyaratan

- WSL2 dengan Ubuntu (18.04/20.04/22.04/24.04)
- Koneksi internet
- Akses sudo

## 🚀 Instalasi

### 1. Download Script

```bash
# Download kedua script
curl -O https://raw.githubusercontent.com/osiic/dotfiles-ubuntu-wsl/main/install.sh
curl -O https://raw.githubusercontent.com/osiic/dotfiles-ubuntu-wsl/main/uninstall.sh
```
```bash
# Atau clone repository
git clone https://github.com/osiic/dotfiles-ubuntu-wsl.git
cd dotfiles-ubuntu-wsl
```

### 2. Berikan Permission

```bash
chmod +x install.sh uninstall.sh
```

### 3. Jalankan Install

```bash
./install.sh
```

Script akan meminta:
- Nama lengkap
- Email
- Username GitHub

Setelah selesai, restart terminal atau jalankan:
```bash
exec zsh
```

## 🛠 Tools yang Diinstall

### Development Tools
- **Git** - Version control
- **GitHub CLI** - Manajemen GitHub dari terminal
- **Neovim** - Text editor modern
- **Node.js** (via NVM) - Runtime JavaScript
- **Python 3** - Bahasa pemrograman
- **Docker** - Containerization (opsional)

### Terminal Tools
- **Zsh** - Shell yang powerful
- **Oh My Zsh** - Framework Zsh
- **Starship** - Prompt yang cantik dan cepat
- **fzf** - Fuzzy finder
- **ripgrep** - Pencarian file super cepat
- **bat** - Cat dengan syntax highlighting
- **exa** - ls yang lebih cantik
- **fd** - Find yang lebih cepat
- **lazygit** - Git TUI yang mudah
- **tldr** - Manual pages yang simpel

### Package Managers
- **npm/yarn/pnpm/bun** - JavaScript package managers
- **pip/pipx** - Python package managers

## 💡 Penggunaan

### Setelah Install

```bash
# Lihat welcome message
cat ~/.config/welcome.txt

# Mulai coding di direktori projects
cd ~/projects

# Buat project baru
mkdir my-project && cd my-project

# Edit file dengan Neovim
v README.md

# Status Git dengan alias
g st

# Commit dengan lazygit
lazygit
```

### Alias yang Tersedia

```bash
# File operations
ls          # exa dengan grup direktori
ll          # exa dengan detail lengkap
lt          # exa dalam bentuk tree
cat         # bat dengan syntax highlighting

# Search & navigation
grep        # ripgrep
find        # fd-find

# Development
v           # neovim
g           # git
d           # docker
dc          # docker-compose

# Shell
sz          # source ~/.zshrc (reload config)
```

## 🗑 Uninstall

Untuk mengembalikan sistem ke kondisi bersih:

```bash
./uninstall.sh
```

**Yang dihapus:**
- Semua tools pengembangan
- Konfigurasi shell dan Git
- Cache dan file temporary
- SSH config (key tetap aman)

**Yang TIDAK dihapus:**
- Folder `~/projects` (proyek Anda aman!)
- SSH private/public keys
- File sistem penting

## 📁 Struktur Direktori

Setelah install, struktur direktori Anda:

```
~/
├── projects/           # Tempat semua proyek coding
├── tools/             # Tools tambahan
├── scripts/           # Script custom
├── .config/
│   ├── starship.toml  # Konfigurasi prompt
│   ├── nvim/          # Konfigurasi Neovim
│   └── welcome.txt    # Pesan selamat datang
├── .oh-my-zsh/        # Oh My Zsh installation
├── .nvm/              # Node Version Manager
└── .local/bin/        # Binary lokal
```

## ⚙️ Kustomisasi

### Mengubah Prompt
Edit `~/.config/starship.toml`:
```bash
v ~/.config/starship.toml
```

### Menambah Alias Zsh
Edit `~/.zshrc`:
```bash
v ~/.zshrc

# Tambahkan alias baru di bagian aliases
alias myalias="command"

# Reload
sz
```

### Install Node.js Version Lain
```bash
# List versi tersedia
nvm list-remote

# Install versi tertentu
nvm install 18.17.0
nvm use 18.17.0

# Set sebagai default
nvm alias default 18.17.0
```

## 🔧 Troubleshooting

### SSH Key tidak terbaca GitHub
```bash
# Test koneksi SSH
ssh -T git@github.com

# Jika gagal, tambahkan key manually
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

### Zsh tidak jadi default shell
```bash
# Cek shell saat ini
echo $SHELL

# Ubah ke zsh
chsh -s $(which zsh)

# Logout dan login lagi
```

### Node.js command not found
```bash
# Reload NVM
source ~/.nvm/nvm.sh

# Atau restart terminal
exec zsh
```

### Permission denied saat install
```bash
# Pastikan script executable
chmod +x install.sh uninstall.sh

# Jalankan dengan bash jika perlu
bash install.sh
```

## 🤝 Kontribusi

1. Fork repository ini
2. Buat branch fitur (`git checkout -b fitur-baru`)
3. Commit perubahan (`git commit -m 'Tambah fitur baru'`)
4. Push ke branch (`git push origin fitur-baru`)
5. Buat Pull Request

## 📝 Changelog

### v1.0.0
- ✅ Script install lengkap
- ✅ Script uninstall yang aman
- ✅ Support semua Ubuntu LTS
- ✅ Konfigurasi development tools
- ✅ Setup SSH dan Git otomatis

## 📄 Lisensi

MIT License - Bebas digunakan untuk proyek apapun!

---

**Selamat coding! 🎉**

Jika ada pertanyaan atau masalah, silakan buat issue di repository ini.
