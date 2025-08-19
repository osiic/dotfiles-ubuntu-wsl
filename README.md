# 🚀 WSL Ubuntu Development Environment

Script otomatis untuk **setup, cleanup, dan reinstall** lingkungan pengembangan di **WSL Ubuntu**.  
Kompatibel dengan semua versi **Ubuntu LTS** (18.04, 20.04, 22.04, 24.04+).

---

## 📋 Daftar Isi
- [Persiapan WSL di Windows](#-persiapan-wsl-di-windows)
- [Instalasi](#-instalasi)
- [Uninstall WSL/Distro](#-uninstall-wsldistro)
- [Reinstall WSL dari Awal](#-reinstall-wsl-dari-awal)
- [Fitur Script](#-fitur-script)
- [Tools yang Diinstall](#-tools-yang-diinstall)
- [Quick Commands](#-quick-commands)
- [Struktur Direktori](#-struktur-direktori)
- [Troubleshooting](#-troubleshooting)

---

## ⚙️ Persiapan WSL di Windows

### 1. Install WSL
Buka **CMD** atau **PowerShell (Admin)** lalu jalankan:

```powershell
wsl --install
````

Ini akan otomatis menginstall **WSL2** dan **Ubuntu LTS terbaru**.

> 🔎 Cek versi WSL:

```powershell
wsl --version
```

### 2. Pilih Distro (opsional)

Untuk lihat distro yang tersedia:

```powershell
wsl --list --online
```

Install distro tertentu, misalnya Ubuntu 22.04:

```powershell
wsl --install -d Ubuntu-22.04
```

### 3. Set Default Distro

```powershell
wsl --set-default Ubuntu-22.04
```

---

## 🗑️ Uninstall WSL/Distro

### Uninstall Distro Tertentu

```powershell
wsl --unregister Ubuntu-22.04
```

### Uninstall Semua WSL (Clean Reset)

```powershell
wsl --unregister <distro>
wsl --shutdown
```

Untuk hapus WSL sepenuhnya dari Windows:

1. Buka **Apps & Features** → cari *Windows Subsystem for Linux* → Uninstall.
2. (Opsional) Hapus folder:

   ```
   %LOCALAPPDATA%\Packages\CanonicalGroupLimited...
   ```

---

## 🔄 Reinstall WSL dari Awal

1. **Uninstall semua distro**

   ```powershell
   wsl --list --verbose
   wsl --unregister <distro-name>
   ```
2. **Uninstall WSL feature**

   ```powershell
   dism.exe /online /disable-feature /featurename:Microsoft-Windows-Subsystem-Linux
   dism.exe /online /disable-feature /featurename:VirtualMachinePlatform
   ```
3. **Restart Windows**
4. **Install ulang WSL**

   ```powershell
   wsl --install
   ```
5. **Install Ubuntu LTS terbaru**

   ```powershell
   wsl --install -d Ubuntu-24.04
   ```

---

## 🚀 Instalasi Script

### Clone Repo

```bash
git clone https://github.com/osiic/dotfiles-ubuntu-wsl.git
cd dotfiles-ubuntu-wsl
chmod +x *.sh
```

### Jalankan Script Install

```bash
./install.sh
exec zsh
```

> Script akan minta:

* 👤 Nama lengkap
* 📧 Email
* 🐙 GitHub username

---

## ✨ Fitur Script

* ✅ Setup lengkap environment (Git, SSH, Node.js, Python, Zsh, Neovim, Tmux)
* ✅ Konfigurasi terminal cantik (Starship + Zsh plugins)
* ✅ Auto-clone config (Neovim, Tmux)
* ✅ GitHub CLI + SSH key otomatis
* ✅ Quick alias & helper commands

---

## 🛠 Tools yang Diinstall

* **Shell**: Zsh + Oh My Zsh + Starship
* **Editor**: Neovim (custom config)
* **Multiplexer**: Tmux (custom config)
* **Git** + GitHub CLI + lazygit
* **Node.js** (via NVM, npm, yarn, pnpm, bun)
* **Python 3** + venv + pipx
* **Tools CLI**: fzf, bat, exa, fd, ripgrep, tldr

---

## ⚡ Quick Commands

### Navigasi & Project

```bash
proj        # cd ~/projects
dev         # buka ~/projects dengan Neovim
```

### File Management

```bash
ll          # list detail (exa)
lt          # tree view
cat file    # bat (highlighting)
grep text   # ripgrep
find name   # fd
```

### Git

```bash
gs          # status lengkap (branch, log, stash, remote, diff)
gac "msg"   # git add . && git commit -m "msg"
glg         # git log graph
lazygit     # Git TUI
```

### System

```bash
sz          # reload zshrc
exec zsh    # restart shell
```

---

## 📁 Struktur Direktori

```
~/
├── projects/      # Main project dir
├── tools/         # Custom tools
├── scripts/       # Extra scripts
├── .config/       # Neovim, starship, dll
├── .venvs/        # Python virtual env
├── .nvm/          # Node.js manager
└── welcome.txt    # Quick guide
```

---

## 🐛 Troubleshooting

### Gagal SSH ke GitHub

```bash
ssh -T git@github.com
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

### Shell masih Bash

```bash
sudo chsh -s $(which zsh) $USER
exec zsh
```

### Recreate Python venv

```bash
rm -rf ~/.venvs/default
python3 -m venv ~/.venvs/default
```

---

🎉 **Happy coding dengan WSL!**

```
