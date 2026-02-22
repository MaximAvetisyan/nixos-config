# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz";
in
{
  services = {
    openssh.enable = true;
    udisks2.enable = true;
    devmon.enable = true;
    gvfs.enable = true;
    getty.autologinUser = "max";
    xserver = {
      videoDrivers = ["nvidia"];
      xkb = {
        layout = "us,ru";
        variant = "";
        options = "grp:alt_shift_toggle";
      };
    };
    blueman.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.extraConfig.bluetoothEnhancements = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" "a2dp_sink" "a2dp_source" ];
          "bluez5.codecs" = [ "sbc" "sbc_xq" "aac" ];
        };
      };
    };
    
    printing = {
      enable = true;
      drivers = [ pkgs.samsung-unified-linux-driver ];
    };

    zapret = {
      enable = true;
      configureFirewall = false;
      params = [
        "--filter-udp=443 --hostlist=/etc/zapret/list-general.txt --hostlist-exclude=/etc/zapret/list-exclude.txt --ipset-exclude=/etc/zapret/ipset-exclude.txt --dpi-desync=fake --dpi-desync-repeats=6 --new"
        "--filter-udp=19294-19344,50000-50100 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-repeats=6 --new"
        "--filter-tcp=2053,2083,2087,2096,8443 --hostlist-domains=discord.media --dpi-desync=multisplit --dpi-desync-split-seqovl=681 --dpi-desync-split-pos=1  --new"
        "--filter-tcp=443 --hostlist=/etc/zapret/list-google.txt --ip-id=zero --dpi-desync=multisplit --dpi-desync-split-seqovl=681 --dpi-desync-split-pos=1 --new"
        "--filter-tcp=80,443 --hostlist=/etc/zapret/list-general.txt --hostlist-exclude=/etc/zapret/list-exclude.txt --ipset-exclude=/etc/zapret/ipset-exclude.txt --dpi-desync=multisplit --dpi-desync-split-seqovl=568 --dpi-desync-split-pos=1  --new"
        "--filter-udp=443 --ipset=/etc/zapret/ipset-all.txt --hostlist-exclude=/etc/zapret/list-exclude.txt --ipset-exclude=/etc/zapret/ipset-exclude.txt --dpi-desync=fake --dpi-desync-repeats=6 --new"
        "--filter-tcp=80,443 --ipset=/etc/zapret/ipset-all.txt --hostlist-exclude=/etc/zapret/list-exclude.txt --ipset-exclude=/etc/zapret/ipset-exclude.txt --dpi-desync=multisplit --dpi-desync-split-seqovl=568 --dpi-desync-split-pos=1  --new"
        "--filter-udp=443 --ipset=/etc/zapret/ipset-all.txt --ipset-exclude=/etc/zapret/ipset-exclude.txt --dpi-desync=fake --dpi-desync-repeats=12 --dpi-desync-any-protocol=1  --dpi-desync-cutoff=n2"
      ];
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      chromium = {
        enableWideVine = true;
      };
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.max = import ./home.nix;
  };

  imports =
    [ 
    (import "${home-manager}/nixos")
    ./hardware-configuration.nix
    ];

  boot = {
    loader = {
    systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelParams = [ "nvidia-drm.modeset=1" ];
    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = [ pkgs.linuxPackages.v4l2loopback ];
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall.enable = false;
    nftables.enable = true;
    nftables.ruleset = ''
      table inet zapret_filter {
        chain bypass {
          type filter hook postrouting priority mangle; policy accept;
          mark 0x40000000 return
          tcp flags syn tcp option maxseg size set 1200
          ip protocol tcp tcp dport { 80, 443, 2053, 2083, 2087, 2096, 8443 } counter queue num 200
          ip protocol udp udp dport { 443, 19294-19344, 50000-50100 } counter queue num 200
        }
      }
    '';
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  systemd.services.zapret.serviceConfig = {
    AmbientCapabilities = [ "CAP_NET_RAW" "CAP_NET_ADMIN" ];
    CapabilityBoundingSet = [ "CAP_NET_RAW" "CAP_NET_ADMIN" ];
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

  security.rtkit.enable = true;

  users = {
    defaultUserShell = pkgs.zsh;
    users.max = {
      isNormalUser = true;
      description = "max";
      extraGroups = [ "networkmanager" "wheel" "sudo" "input" ];
      packages = with pkgs; [];
    };
  };


  programs = {
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    hyprlock.enable = true;
    gamemode.enable = true;
    zsh.enable = true;
    hyprland = {
        enable = true;
        withUWSM = true;
    };
  };

  environment = {
    loginShellInit = ''
      if [ "$(tty)" = "/dev/tty1" ]; then
        uwsm start default
      fi
    '';
    systemPackages = with pkgs; [
      neovim
      tmux
      wl-clipboard
      wlogout
      hyprlock
      curl
      ripgrep
      unzip
      git
      cmake
      gcc
      clang
      go
      zig
      chromium
      pkgs.ghostty
      pkgs.apple-cursor
      wofi
      waybar
      hyprpaper
      hyprshot
      #discord-ptb
      pkgs.splix
      #Printer package
      pavucontrol
      protonup-ng
      pkgs.telegram-desktop
      ffmpeg
      udiskie
      lutris
    ];
  };

  fonts.packages = with pkgs; [
    meslo-lgs-nf
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
