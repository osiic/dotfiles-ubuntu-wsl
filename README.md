# 🚀 WSL Ubuntu Development Environment (Nix Edition)

Setup **reproducible** dan **declarative** untuk lingkungan pengembangan di **WSL Ubuntu** menggunakan **Nix Flakes** dan **Home Manager**.

> **Note**: Branch ini menggunakan **Nix**. Jika Anda mencari versi Bash script biasa, checkout branch `main`.

## 📋 Daftar Isi
- [Persiapan](#-persiapan)
- [Instalasi](#-instalasi)
- [Update & Maintenance](#-update--maintenance)
- [Fitur](#-fitur)
- [Struktur](#-struktur)

---

## ⚙️ Persiapan

### 1. Install WSL (Jika belum)
```powershell
wsl --install
```

### 2. Install & Setup
Jalankan script bootstrap untuk menginstall Nix (via Determinate Systems) dan apply konfigurasi:

```bash
./bootstrap.sh
```

Script ini akan:
1. Menginstall Nix (jika belum ada).
2. Mengaktifkan Flakes.
3. Menjalankan Home Manager setup.

*Jika diminta restart shell setelah install Nix, lakukan restart lalu jalankan `./bootstrap.sh` lagi.*

---

## 🔄 Update & Maintenance

### Update System
Setiap kali Anda mengubah `home.nix` atau `flake.nix`, jalankan:

```bash
home-manager switch --flake .#user
```

### Update Packages
Untuk mengupdate versi packages dari repository Nix:

```bash
nix flake update
home-manager switch --flake .#user
```

### Clean Up
Membersihkan file sampah dari Nix store:

```bash
nix-collect-garbage -d
```

---

## ✨ Fitur

* **Declarative**: Semua konfigurasi tertulis di code (`home.nix`).
* **Reproducible**: Setup yang sama persis di mesin manapun.
* **Rollback**: Bisa kembali ke konfigurasi sebelumnya jika ada error.
* **Tools**:
    * **Shell**: Zsh + Oh My Zsh + Starship
    * **Editor**: Neovim + Tmux
    * **Dev**: Git, GitHub CLI, Node.js, Python, Lazygit
    * **Utils**: fzf, ripgrep, fd, bat, eza

---

## 📁 Struktur

```
~/dotfiles-ubuntu-wsl/
├── flake.nix       # Entry point konfigurasi Nix
├── home.nix        # Daftar packages dan config
├── bootstrap.sh    # Script instalasi otomatis
├── nvim/           # Konfigurasi Neovim (Lua)
├── tmux/           # Konfigurasi Tmux
└── README.md       # Dokumentasi ini
```
