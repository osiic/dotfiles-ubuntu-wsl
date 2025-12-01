{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "osiic"; # Default, will be overridden if needed or user changes it
  home.homeDirectory = "/home/osiic";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # Core
    git
    curl
    wget
    jq
    htop
    unzip
    zip
    ripgrep
    fd
    fzf
    bat
    eza # Modern replacement for ls (exa is unmaintained)
    tldr
    
    # Development
    neovim
    tmux
    gh # GitHub CLI
    lazygit
    
    # Languages & Runtimes
    nodejs_20
    python3
    luarocks
    gcc
    gnumake
    
    # Utils
    xclip
    wl-clipboard
    openssh
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # Symlink the local nvim folder to ~/.config/nvim
    ".config/nvim".source = ./nvim;
    
    # Symlink the local tmux config
    ".tmux.conf".source = ./tmux/.tmux.conf;
    # If there are other files in tmux folder needed, we might need to link them too
    # or link the whole folder to ~/.tmux like:
    ".tmux".source = ./tmux;
  };

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less";
  };

  # Program Configurations
  
  # Git
  programs.git = {
    enable = true;
    userName = "Your Name"; # Update this
    userEmail = "your.email@example.com"; # Update this
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "nvim";
    };
    aliases = {
      co = "checkout";
      br = "branch";
      ci = "commit";
      st = "status";
      last = "log -1 HEAD";
    };
  };

  # Zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    shellAliases = {
      ll = "eza -l --icons --git";
      la = "eza -la --icons --git";
      lt = "eza --tree --level=2 --icons";
      cat = "bat";
      grep = "rg";
      find = "fd";
      v = "nvim";
      g = "git";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gs = "git status";
      gd = "git diff";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "docker" "npm" "node" "python" ];
      theme = "robbyrussell";
    };
    
    initExtra = ''
      # Custom functions
      function dev() {
        if [ -z "$1" ]; then
          echo "Usage: dev <project_name>"
          ls -al ~/projects/
          return 1
        fi
        cd ~/projects/"$1" || return 1
        tmux
      }
    '';
  };

  # Starship
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      # Ported from your toml
      palette = "catppuccin_mocha";
      palettes.catppuccin_mocha = {
        rosewater = "#f5e0dc";
        flamingo = "#f2cdcd";
        pink = "#f5c2e7";
        mauve = "#cba6f7";
        red = "#f38ba8";
        maroon = "#eba0ac";
        peach = "#fab387";
        yellow = "#f9e2af";
        green = "#a6e3a1";
        teal = "#94e2d5";
        sky = "#89dceb";
        sapphire = "#74c7ec";
        blue = "#89b4fa";
        lavender = "#b4befe";
        text = "#cdd6f4";
        subtext1 = "#bac2de";
        subtext0 = "#a6adc8";
        overlay2 = "#9399b2";
        overlay1 = "#7f849c";
        overlay0 = "#6c7086";
        surface2 = "#585b70";
        surface1 = "#45475a";
        surface0 = "#313244";
        base = "#1e1e2e";
        mantle = "#181825";
        crust = "#11111b";
      };
    };
  };

  # Tmux
  programs.tmux = {
    enable = true;
    shortcut = "b";
    baseIndex = 1;
    newSession = true;
    escapeTime = 0;
    secureSocket = false;
    
    plugins = with pkgs; [
      tmuxPlugins.cpu
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '60' # minutes
        '';
      }
    ];

    extraConfig = ''
      set -g mouse on
      set-option -g status-position top
    '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
