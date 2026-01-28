# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz";
in
{
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  hardware = {
    bluetooth = {
      enable = true;
      settings = {
        General = {
          Experimental = true;
          ControllerMode = "dual"; 
        };
      };
    };

    graphics = {
      enable = true;
    };
 
    nvidia = {
  
      # Modesetting is required.
      modesetting.enable = true;
  
      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
      # of just the bare essentials.
      powerManagement.enable = false;
  
      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;
  
      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of 
      # supported GPUs is at: 
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
      # Only available from driver 515.43.04+
      open = false;
  
      # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
      nvidiaSettings = true;
  
      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.max = import ./home.nix;

  imports =
    [ 
    (import "${home-manager}/nixos")
    ./hardware-configuration.nix
    ];

  # Bootloader.
  boot = {
    loader = {
    systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
  };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.hostName = "nixos"; # Define your hostname.
  services.zapret = {
    enable = true;
    udpSupport = true;
    udpPorts = [ "50000:50099" "443" ];
    params = [
      "--dpi-desync-any-protocol=1" # udp support
      "--dpi-desync=fake,disorder2"
      "--dpi-desync-ttl=1"
      "--dpi-desync-autottl=2"
      "--dpi-desync-repeats=2"
    ];
    whitelist = [
        "googleusercontent.com"
        "accounts.google.com"
        "googleadservices.com"
        "googlevideo.com"
        "gvt1.com"
        "jnn-pa.googleapis.com"
        "play.google.com"
        "wide-youtube.l.google.com"
        "youtu.be"
        "youtube-nocookie.com"
        "youtube-ui.l.google.com"
        "youtube.com"
        "youtube.googleapis.com"
        "youtubeembeddedplayer.googleapis.com"
        "youtubei.googleapis.com"
        "yt-video-upload.l.google.com"
        "yt.be"
        "ytimg.com"
        "ggpht.com"
  "cloudflare-ech.com"
  "encryptedsni.com"
  "cloudflareaccess.com"
  "cloudflareapps.com"
  "cloudflarebolt.com"
  "cloudflareclient.com"
  "cloudflareinsights.com"
  "cloudflareok.com"
  "cloudflarepartners.com"
  "cloudflareportal.com"
  "cloudflarepreview.com"
  "cloudflareresolve.com"
  "cloudflaressl.com"
  "cloudflarestatus.com"
  "cloudflarestorage.com"
  "cloudflarestream.com"
  "cloudflaretest.com"
  "dis.gd"
  "discord-attachments-uploads-prd.storage.googleapis.com"
  "discord.app"
  "discord.co"
  "discord.com"
  "discord.design"
  "discord.dev"
  "discord.gift"
  "discord.gifts"
  "discord.gg"
  "discord.media"
  "discord.new"
  "discord.store"
  "discord.status"
  "discord-activities.com"
  "discordactivities.com"
  "discordapp.com"
  "discordapp.net"
  "discordcdn.com"
  "discordmerch.com"
  "discordpartygames.com"
  "discordsays.com"
  "discordsez.com"
  "discordstatus.com"
  "frankerfacez.com"
  "ffzap.com"
  "betterttv.net"
  "7tv.app"
  "7tv.io"
  "localizeapi.com"
      ];
  };  
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
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

  #  Pipewire as a bluetooth audio for AirPods
  security.rtkit.enable = true;

  # Configure keymap in X11
  services = {
    xserver.xkb = {
      layout = "us,ru";
      variant = "";
      options = "grp:alt_shift_toggle";
    };
  
    #Bluetooth
    blueman.enable = true;
    
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    
    pipewire.wireplumber.extraConfig.bluetoothEnhancements = {
      "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-msbc" = true;
        "bluez5.enable-hw-volume" = true;
        "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" "a2dp_sink" "a2dp_source" ];
        "bluez5.codecs" = [ "sbc" "sbc_xq" "aac" ];
      };
    };
    
    #Display manager
    greetd = {
      enable = true;
      settings = {
        initial_session = {
          command = "${pkgs.uwsm}/bin/uwsm start hyprland-uwsm.desktop";
          user = "max";
        };
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --greeting 'Welcome!' --asterisks --remember --remember-user-session --time --cmd '${pkgs.uwsm}/bin/uwsm start hyprland-uwsm.desktop'";
          user = "greeter";
        };
      };
    };
    
    printing = {
      enable = true;
    };

  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.max = {
    isNormalUser = true;
    description = "max";
    extraGroups = [ "networkmanager" "wheel" "sudo" "input" ];
    packages = with pkgs; [];
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
        withUWSM = true; # Это создаст hyprland-uwsm.desktop
    };

  };

  environment.systemPackages = with pkgs; [

  neovim
  tmux
  wl-clipboard
  wlogout
  hyprlock
  curl
  wget
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
  tuigreet
  wofi
  waybar
  hyprpaper
  hyprshot
  #Printer package
  pkgs.splix
  pavucontrol
  protonup-ng
  lutris
  ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  fonts.packages = with pkgs; [
    meslo-lgs-nf
  ];

  users.defaultUserShell = pkgs.zsh;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
