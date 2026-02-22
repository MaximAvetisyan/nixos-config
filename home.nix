{ config, pkgs, ... }:

{
  home = {
    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.apple-cursor;
      name = "macOS";
      size = 24;
    };
    username = "max";
    homeDirectory = "/home/max";
    stateVersion = "25.11";
    sessionVariables = {
      NVD_BACKEND = "direct";
      MOZ_ENABLE_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      EDITOR = "nvim";
      VISUAL = "nvim";
      STEAM_EXTRA_COMPAT_TOOLS_PATH = 
        "\${HOME}/.steam/root/compatabilitytools.d";
      };
  };

  services = {
    swaync.enable = true;
    hypridle = {
      enable = true;
      settings = {
        listener = [
          {
            timeout = 300;
            on-timeout = "hyprlock";
          }
        ];
      };
    };
  };


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

    waybar = {
      enable = true;
      systemd.enable = true;
      settings = [{
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [
          "tray"
          "pulseaudio"
          "custom/notification"
          "hyprland/language" 
          "custom/exit"
        ];  

      "pulseaudio" = {
        format = "{icon} {volume}%";
        format-muted = "";
        format-icons = {
          default = ["" "" ""];
        };
        on-click = "pavucontrol";
      };

      "hyprland/language" = {
        format = "  {}";
        format-en = "US";
        format-ru = "RU";
      };

      "hyprland/workspaces" = {
        format = "{name}";
        on-click = "activate";
        sort-by-number = true;
        all-outputs = true;
        active-only = false;
      };

      "clock" = {
        format = "{:%H:%M}";
        "tooltip-format" = "<span size='16pt' font='JetBrainsMono Nerd Font'><tt>{calendar}</tt></span>";
        "calendar" = {
            "mode"          = "month";
            "weeks-pos"     = "right";
            "on-scroll"     = 1;
            "format" = {
                "months"=     "<span color='#ffead3'><b>{}</b></span>";
                "days"=       "<span color='#ecc6d9'><b>{}</b></span>";
                "weeks"=      "<span color='#99ffdd'><b>W{}</b></span>";
                "weekdays"=   "<span color='#ffcc66'><b>{}</b></span>";
                "today"=      "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
        };
        "actions"= {
            "on-click-right"= "mode";
            "on-scroll-up"= "shift_up";
            "on-scroll-down"= "shift_down";
        };
      };

      "custom/exit" = {
        tooltip = false;
        format = "";
        "on-click" = "${pkgs.wlogout}/bin/wlogout";
      };

    }];

    style = ''
      * {
          font-family: JetBrainsMono Nerd Font Mono;
          font-size: 14px;
          border: none;
          border-radius: 0px;
          min-height: 0px;
        }

        #workspaces button {
          padding: 0 5px;
          color: #7c818c;
          background: transparent;
          border: none;
          border-radius: 0;
        }

        #workspaces button.active {
          color: #51afef;
          border-bottom: 3px solid #51afef;
          background: rgba(81, 175, 239, 0.1);
        }

        #pulseaudio {
          color: #98be65;
        }

        #language {
          color: #ffffff;
        }

        #waybar {
          background: rgba(43, 48, 59, 0.5);
          color: #ffffff;
        }
    
        .modules-right > widget > label, 
        .modules-right > widget > box {
          margin-left: 5px;
          margin-right: 5px;
        }
    
    '';
    };

    ghostty = {
      enable = true;
      settings = {
        font-size = 18;
        font-family = "meslo-lgs-nf";
        theme = "Rose Pine";
        background = "black";
      };
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = false;
      syntaxHighlighting.enable = false;
      
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
        update = "sudo nixos-rebuild switch";
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
      '';
    };

    wofi = {
      enable = true;
      settings = {
        width = 900;
        height = 400;
        location = "center";
        show = "drun";
        prompt = "Search...";
        filter_rate = 100;
        allow_images = true;
        no_actions = true;
        halign = "fill";
        orientation = "vertical";
        content_halign = "fill";
        insensitive = true;
      };
      style = ''
        window {
          margin: 0px;
          border-radius: 12px;
          border: 1px solid rgba(255, 255, 255, 0.1);
          background-color: rgba(30, 30, 30, 0.95);
          font-family: "MesloLGS NF";
          font-size: 15px;
        }
    
        #outer-box {
          margin: 0px;
          padding: 0px;
        }
    
        #input {
          margin: 0px;
          padding: 15px;
          border: none;
          border-bottom: 1px solid rgba(255, 255, 255, 0.1);
          border-radius: 12px 12px 0px 0px;
          color: #ffffff;
          background-color: transparent;
          outline: none;
        }
    
        #inner-box {
          margin: 8px;
          background-color: transparent;
        }
    
        #scroll {
          border: none;
        }
    
        #entry {
          padding: 10px;
          margin: 2px 0px;
          border: none;
          border-radius: 8px;
          color: #b3b3b3;
        }
    
        #entry:selected {
          background-color: rgba(255, 255, 255, 0.1);
          outline: none;
        }
    
        #text:selected {
          color: #ffffff;
          font-weight: bold;
        }
      '';
    };

  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    
    settings = {

      monitor = [
        "DP-2, 3840x2160@59, auto, 1.5, bitdepth, 10"
      ];

      "$terminal" = "ghostty";
      "$fileManager" = "dolphin";
      "$menu" = "wofi --show drun";
      "exec-once" = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "[workspace 2 ] chromium"
        "[workspace 1 silent] ghostty"
        "[workspace 5 silent] Telegram"
	"udiskie"
	"hyprlock"
      ];
  
      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];
    
      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };
    
      decoration = {
        rounding = 10;
        rounding_power = 2.0;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
    
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
    
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };
    
      animations = {
        enabled = "yes";
        bezier = [
          "easeOutQuint, 0.23, 1, 0.32, 1"
          "easeInOutCubic, 0.65, 0.05, 0.36, 1"
          "linear, 0, 0, 1, 1"
          "almostLinear, 0.5, 0.5, 0.75, 1"
          "quick, 0.15, 0, 0.1, 1"
        ];
        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
          "zoomFactor, 1, 7, quick"
        ];
      };
    
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
    
      master = {
        new_status = "master";
      };
    
      misc = {
        force_default_wallpaper = -1;
        disable_hyprland_logo = false;
      };
    
      input = {
        kb_layout = "us,ru";
        kb_options = "grp:alt_shift_toggle";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad.natural_scroll = true;
      }; 

      device = [{
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      }];
    
      "$mainMod" = "SUPER";
      bind = [
        "$mainMod, Return, exec, $terminal"
        "$mainMod, F, fullscreen, 0"
        "$mainMod, q, killactive,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, V, togglefloating,"
        "$mainMod, Space, exec, $menu"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"
        "$mainMod SHIFT, q, exec, hyprlock"
        
        "$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"
    
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
    
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
    
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"
    
      ];
    
      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];
    };
  };

}
