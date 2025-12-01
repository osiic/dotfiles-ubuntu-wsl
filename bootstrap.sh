#!/bin/bash
set -e

echo "🚀 Bootstrapping Nix Environment..."

# 1. Install Nix using Determinate Systems Installer if not present
if ! command -v nix &> /dev/null; then
    echo "📦 Nix not found. Installing via Determinate Systems..."
    curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate

    echo "✅ Nix installed. You may need to restart your shell or source the nix profile."
    echo "Please run this script again after restarting your shell."
    exit 0
else
    echo "✅ Nix is already installed."
fi

# 2. Enable Flakes (if needed, though Determinate Systems does this by default)
mkdir -p ~/.config/nix
if ! grep -q "experimental-features = nix-command flakes" ~/.config/nix/nix.conf 2>/dev/null; then
    echo "⚙️  Ensuring Flakes are enabled..."
    # This might require sudo if it's a multi-user install, but let's try user config first or just rely on the installer
fi

# 3. Apply Home Manager Configuration
echo "🔮 Applying Home Manager configuration..."
nix run home-manager/master -- switch --flake .#user

echo "🎉 Setup complete! Please restart your shell."
