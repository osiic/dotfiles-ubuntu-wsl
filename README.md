# Dotfiles Ubuntu WSL

<p align="center">
  <img src="https://img.shields.io/badge/Ubuntu-WSL-blue?style=for-the-badge&logo=ubuntu" alt="Ubuntu WSL">
  <img src="https://img.shields.io/badge/Shell-Zsh-green?style=for-the-badge&logo=gnu-bash" alt="Zsh Shell">
  <img src="https://img.shields.io/badge/License-MIT-blue?style=for-the-badge" alt="License MIT">
</p>

Repository ini berisi konfigurasi dan skrip otomatisasi untuk mengatur lingkungan pengembangan di Ubuntu pada Windows Subsystem for Linux (WSL). Dengan satu perintah, Anda bisa mendapatkan lingkungan pengembangan yang siap pakai dengan semua tools yang dibutuhkan.

## 🎯 Kenapa Harus Pakai Ini?

Mengatur lingkungan pengembangan di WSL bisa menjadi proses yang memakan waktu dan rawan kesalahan. Repository ini menyelesaikan masalah tersebut dengan:

### Keuntungan Utama:
- **Hemat Waktu**: Instalasi lengkap dalam satu perintah, bukan berjam-jam
- **Konsisten**: Konfigurasi yang sama di semua mesin
- **Komprehensif**: Menyertakan semua tools yang dibutuhkan developer
- **Mudah Dipelihara**: Update otomatis dan sistem uninstall
- **Modular**: Komponen dapat dikustomisasi sesuai kebutuhan

### Tools & Teknologi yang Diinstal:
- **Shell**: Zsh dengan Oh My Zsh + Plugin (autosuggestions, syntax highlighting)
- **Terminal**: Tmux untuk manajemen terminal
- **Editor**: Neovim dengan konfigurasi lengkap
- **Git**: Konfigurasi optimal + GitHub CLI
- **Bahasa Pemrograman**: Node.js (via NVM) & Python (venv)
- **Tools Tambahan**: fzf, lazygit, tldr, starship prompt

## 🚀 Instalasi Cepat (Quick Start)

Ingin langsung mulai? Jalankan perintah ini di terminal WSL Ubuntu Anda:

```bash
# Clone repository
git clone https://github.com/osiic/dotfiles-ubuntu-wsl.git ~/.dotfiles
cd ~/.dotfiles

# Jalankan instalasi
./setup.sh

# Restart shell untuk menerapkan perubahan
exec zsh
```

Setelah selesai, Anda akan memiliki lingkungan pengembangan yang siap pakai!

## 📖 Tutorial Lengkap: Dari Nol sampai Selesai

### 1. Persiapan WSL

Pertama, aktifkan WSL dan instal Ubuntu:

```bash
# Buka PowerShell sebagai Administrator dan jalankan:
wsl --install -d Ubuntu

# Atau jika WSL sudah terinstal:
wsl --set-default-version 2
wsl --install Ubuntu
```

### 2. Konfigurasi Awal Ubuntu

Setelah Ubuntu terinstal, lakukan konfigurasi awal:

```bash
# Update sistem
sudo apt update && sudo apt upgrade -y

# Install paket dasar yang dibutuhkan
sudo apt install -y git curl wget
```

### 3. Instalasi Dotfiles

Clone repository dan jalankan setup:

```bash
# Clone repository ke direktori tersembunyi
git clone https://github.com/osiic/dotfiles-ubuntu-wsl.git ~/.dotfiles

# Masuk ke direktori
cd ~/.dotfiles

# Beri hak akses eksekusi pada script
chmod +x setup.sh
chmod +x scripts/**/*.sh

# Jalankan instalasi
./setup.sh
```

### 4. Proses Instalasi

Setup akan memandu Anda melalui beberapa langkah:

1. **Autentikasi GitHub**:
   - Pilih metode SSH (direkomendasikan) atau HTTPS
   - Untuk SSH: Tambahkan SSH key ke akun GitHub Anda
   - Untuk HTTPS: Login dengan GitHub CLI

2. **Konfigurasi Pengguna**:
   - Nama lengkap
   - Email (untuk Git)
   - Username GitHub

3. **Instalasi Komponen**:
   - Sistem & paket dasar
   - Tools pengembangan (Node.js, Python, dll)
   - Shell environment (Zsh, Oh My Zsh, plugin)
   - Tools tambahan (fzf, lazygit, tldr)

### 5. Verifikasi Instalasi

Setelah selesai, restart shell dan verifikasi:

```bash
# Restart shell
exec zsh

# Cek versi tools yang terinstal
git --version
node --version
python3 --version
nvim --version
```

### 6. Fitur-Fitur Tambahan

#### Direktori Kerja
Repository ini membuat struktur direktori:
```bash
~/projects     # Tempat menyimpan proyek-proyek
~/tools        # Tools tambahan
~/scripts      # Script kustom Anda
~/.config      # Konfigurasi aplikasi
```

#### Fungsi Khusus
Beberapa fungsi berguna yang tersedia:
```bash
dev <nama_proyek>  # Pindah ke direktori proyek dan buka tmux
p                  # Pindah ke direktori ~/projects
```

## 🛠️ Perintah yang Tersedia

### Instalasi
```bash
./setup.sh install    # Instal lingkungan pengembangan
```

### Update
```bash
./setup.sh update     # Cek dan terapkan update terbaru
```

### Uninstall
```bash
./setup.sh uninstall  # Hapus semua komponen yang diinstal
```

### Bantuan
```bash
./setup.sh --help     # Tampilkan bantuan
```

## 📁 Struktur Repository

```
dotfiles-ubuntu-wsl/
├── setup.sh              # Entry point utama
├── scripts/
│   ├── install.sh        # Script instalasi utama
│   ├── core/
│   │   └── functions.sh  # Fungsi-fungsi dasar
│   ├── modules/
│   │   ├── github.sh     # Setup GitHub
│   │   ├── system.sh     # Setup sistem
│   │   ├── devtools.sh   # Tools pengembangan
│   │   ├── shell.sh      # Environment shell
│   │   └── extras.sh     # Tools tambahan
│   ├── utils/
│   │   ├── config.sh     # Manajemen konfigurasi
│   │   └── validation.sh # Validasi input
│   └── commands/
│       ├── update.sh     # Script update
│       └── uninstall.sh  # Script uninstall
```

## 🔧 Konfigurasi & Kustomisasi

### Konfigurasi Pengguna
Konfigurasi disimpan di `~/.wsl-dev-env.conf` dan mencakup:
- Nama pengguna
- Email
- Username GitHub

### Modifikasi Komponen
Anda dapat menyesuaikan komponen dengan mengedit file di direktori `scripts/modules/`:
- `github.sh`: Autentikasi GitHub
- `system.sh`: Paket sistem yang diinstal
- `devtools.sh`: Tools pengembangan
- `shell.sh`: Konfigurasi shell dan plugin
- `extras.sh`: Tools tambahan

## 🔄 Update & Pemeliharaan

Repository ini secara berkala diperbarui dengan fitur dan perbaikan terbaru:

```bash
# Cek update
./setup.sh update

# Repository akan menampilkan changelog dan meminta konfirmasi
```

## 🗑️ Uninstall

Untuk menghapus semua komponen yang diinstal:

```bash
./setup.sh uninstall
```

Catatan: Paket sistem dasar (git, curl, dll) tidak akan dihapus untuk menghindari mengganggu setup lain.

## 📝 Lisensi

Proyek ini dilisensikan di bawah MIT License - lihat file [LICENSE](LICENSE) untuk detailnya.

## 🤝 Kontribusi

Kontribusi sangat dihargai! Untuk kontribusi:
1. Fork repository ini
2. Buat branch fitur (`git checkout -b feature/AmazingFeature`)
3. Commit perubahan (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buka Pull Request

## 📧 Kontak

Jika Anda memiliki pertanyaan atau masukan, jangan ragu untuk menghubungi saya di [osiic@example.com](mailto:osiic@example.com).

---

Dibuat dengan ❤️ untuk komunitas developer WSL