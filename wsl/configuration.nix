# NixOS-WSL system configuration.
# Adopted from the bare-metal desktop config (see ../configuration.nix).
# GUI, bluetooth, printing and GPU things are handled by the Windows host,
# so this is intentionally a slim CLI setup where tmux/nvim run natively.

{ config, pkgs, ... }:
{
  wsl = {
    enable = true;
    # User that `wsl -d NixOS` starts a shell as
    defaultUser = "max";
  };

  services.openssh.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # WSL manages eth0 + DNS itself, so no NetworkManager here.
  networking = {
    hostName = "nixos";
    firewall.enable = false;
  };

  time.timeZone = "Europe/Moscow";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "ru_RU.UTF-8";
      LC_IDENTIFICATION = "ru_RU.UTF-8";
      LC_MEASUREMENT = "ru_RU.UTF-8";
      LC_MONETARY = "ru_RU.UTF-8";
      LC_NAME = "ru_RU.UTF-8";
      LC_NUMERIC = "ru_RU.UTF-8";
      LC_PAPER = "ru_RU.UTF-8";
      LC_TELEPHONE = "ru_RU.UTF-8";
      LC_TIME = "ru_RU.UTF-8";
    };
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users.max = {
      isNormalUser = true;
      description = "max";
      extraGroups = [ "wheel" ];
    };
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    tmux
    curl
    ripgrep
    unzip
    git
    cmake
    gcc
    clang
    go
    zig
    ffmpeg
    wl-clipboard
    xclip
    fzf
    uv
    opencode
    docker
  ];


  system.stateVersion = "25.11";
}
