# Home-manager config for WSL (trimmed from ../home.nix).
# Wayland/desktop bits removed; git/zsh/tmux kept so the
# terminal + tmux + nvim workflow feels like native Linux.

{ config, pkgs, lib, ... }:

{
  home = {
    username = "max";
    homeDirectory = "/home/max";
    stateVersion = "25.11";
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      # Windows Terminal / WSLg support 24-bit color; apps like nvim
      # only enable truecolor when COLORTERM is set
      COLORTERM = "truecolor";
    };
  };

  home.packages = with pkgs; [
    lua-language-server
    gopls
    rust-analyzer
    rustc
    cargo
    rustfmt
    basedpyright
  ];

  programs = {

    git = {
      enable = true;
      settings = {
        user = {
          name = "MaximAvetisyan";
          email = "maxwwhi@gmail.com";
        };
      };
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = false;
      syntaxHighlighting.enable = false;

      initContent = ''
        setopt no_beep
      '';

      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "git"
          "kubectl"
          "helm"
          "docker"
        ];
      };

      shellAliases = {
        ll = "ls -la";
        update = "sudo nixos-rebuild switch --flake ~/.config/nixos-config#wsl";
        rebuild = "sudo nixos-rebuild switch --flake ~/.config/nixos-config#wsl";
        cs = "tmux has-session -t \"$(basename \"$PWD\")\" 2>/dev/null && tmux attach -t \"$(basename \"$PWD\")\" || tmux new-session -d -s \"$(basename \"$PWD\")\" -c \"$PWD\" -n nvim nvim \\; new-window -c \"$PWD\" -n zsh \\; new-window -c \"$PWD\" -n opencode opencode \\; attach -t \"$(basename \"$PWD\")\"";
        clean = "sudo nix-collect-garbage -d";
        vim = "nvim";
        grep = "rg";
      };
    };

    tmux = {
      enable = true;
      clock24 = true;
      plugins = with pkgs.tmuxPlugins; [
        sensible
        resurrect
        vim-tmux-navigator
        yank
      ];
      extraConfig = ''
        set -ga terminal-features ",*:synchronized-updates"
        set -s set-clipboard on
        set -g mouse on
        set -g base-index 1
        setw -g pane-base-index 1
        set -g status-style bg=default
        bind-key -n M-1 select-window -t 1
        bind-key -n M-2 select-window -t 2
        bind-key -n M-3 select-window -t 3
        bind-key -n M-4 select-window -t 4
        bind-key -n M-5 select-window -t 5
        bind-key -n M-c new-window
        bind-key -n M-x kill-window
        bind-key -n M-s choose-tree -s
        bind-key -n M-d detach-client
      '';
    };

  };

  # oh-my-zsh plugins (docker, gem, hcloud, ...) copy their completion
  # scripts into $ZSH_CACHE_DIR/completions on every zsh start. The first
  # copy inherits the 0444 mode from the Nix store, so later copies fail
  # with "Permission denied". Ensure the cache dir stays writable.
  home.activation.oh-my-zsh-cache-writable = lib.hm.dag.entryAfter
    [ "writeBoundary" ]
    "mkdir -p \"$HOME/.cache/oh-my-zsh\" 2>/dev/null || true; chmod -R u+w \"$HOME/.cache/oh-my-zsh\" 2>/dev/null || true";
}
