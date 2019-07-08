{pkgs, ...}:
let
  metablocks = with pkgs; let
    confFile = writeText "i3blocks.conf" ''
      [time]
      command=date "+%a %b %d %R"
      interval=1
    '';
  in pkgs.stdenv.mkDerivation {
    name = "i3blocks-${pkgs.stdenv.lib.getVersion pkgs.i3blocks}";
    buildCommand = let bin = "${pkgs.i3blocks}/bin/i3blocks"; in ''
      if [ ! -x "${bin}" ]
      then
          echo "cannot find executable file \`${bin}'"
          exit 1
      fi

      makeWrapper "$(readlink -v --canonicalize-existing "${bin}")" \
        "$out/bin/i3blocks" --add-flags "-c ${confFile}"
    '';

    buildInputs = [pkgs.makeWrapper];
  };

  metavol = pkgs.writeScript "metavol" ''
    #!${pkgs.bash}/bin/bash

    function get_volume {
        ${pkgs.alsaUtils}/bin/amixer get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1
    }

    function is_mute {
        ${pkgs.alsaUtils}/bin/amixer get Master | grep '%' | grep -oE '[^ ]+$' | grep off > /dev/null
    }

    function send_notification {
        if is_mute ; then
            volume="(`get_volume`)"
        else
            volume=`get_volume`
        fi
        ${pkgs.dunst}/bin/dunstify -i audio-volume-muted-blocking -r 2593 -u low "[vol] $volume"
    }

    case $1 in
        up)
        ${pkgs.alsaUtils}/bin/amixer -q set Master 5%+ unmute > /dev/null
        ;;
        down)
        ${pkgs.alsaUtils}/bin/amixer -q set Master 5%- unmute > /dev/null
        ;;
        mute)
        ${pkgs.alsaUtils}/bin/amixer -q set Master 1+ toggle > /dev/null
        ;;
    esac
    send_notification
  '';
in
{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        follow = "keyboard";

        geometry = "200x3-5+5"; # at most 3 notifs at the bottom right of the screen
        padding = 10;
        frame_width = 2;

        alignment = "center";
        word_wrap = true;

        separator_color = "#383838";
        frame_color = "#383838";

        font = "Source Sans Pro 14";
      };
      urgency_low = {
        background = "#282828";
        foreground = "#7daa71";
        timeout = 5;
      };
      urgency_normal = {
        background = "#282828";
        foreground = "#c0ad93";
        timeout = 10;
      };
      urgency_critical = {
        background = "#282828";
        foreground = "#bf8d63";
        timeout = 0;
      };
      shortcuts = {
        close = "mod1+Escape";
        history = "mod1+shift+Escape";
      };
    };
  };
  xsession = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      config = {
        fonts = [ "Source Sans Pro 10" ]; # TODO expose option for this?
        window.border = 4;
        colors = {
          focused = {
            border = "#555577";
            background = "#555577";
            text = "#ffffff";
            indicator = "#333333";
            childBorder = "#555555";
          };
          focusedInactive = {
            border = "#000000";
            background = "#000000";
            text = "#bbbbbb";
            indicator = "#333333";
            childBorder = "#000000";
          };
          unfocused = { # TODO dedupe
            border = "#000000";
            background = "#000000";
            text = "#bbbbbb";
            indicator = "#333333";
            childBorder = "#000000";
          };
        };
        bars = [{
          statusCommand = "${metablocks}/bin/i3blocks";
          fonts = [ "Material Icons 10" "Source Sans Pro 12" ];
        }];
        floating.modifier = "Mod1";
        keybindings = let modifier = "Mod1"; in {
          "${modifier}+Return" = "exec \"alacritty -e fish\"";
          "${modifier}+Shift+q" = "kill";
          "${modifier}+space" = "exec \"${pkgs.rofi}/bin/rofi -modi window,run -show run\"";
          "${modifier}+Tab" = "exec \"${pkgs.rofi}/bin/rofi -modi window,run -show window\"";
          # TODO i3lock
          # exec xautolock -time 3 -locker 'i3-lock -c 000000' &
          # "{modifier}+semicolon" = "exec i3-lock -c 000000

          "${modifier}+Left" = "focus left";
          "${modifier}+Down" = "focus down";
          "${modifier}+Up" = "focus up";
          "${modifier}+Right" = "focus right";

          "${modifier}+Shift+Left" = "move left";
          "${modifier}+Shift+Down" = "move down";
          "${modifier}+Shift+Up" = "move up";
          "${modifier}+Shift+Right" = "move right";

          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";

          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";

          "${modifier}+g" = "split h";
          "${modifier}+v" = "split v";
          "${modifier}+d" = "split v"; # TODO this might encourage poor discipline
          "${modifier}+f" = "fullscreen toggle";

          "${modifier}+s" = "layout stacking";
          "${modifier}+w" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";

          "${modifier}+a" = "focus parent";
          "${modifier}+Shift+a" = "focus child";

          # "${modifier}+Shift+space" = "floating toggle";
          # "${modifier}+space" = "focus mode_toggle";

          "${modifier}+1" = "workspace 1";
          "${modifier}+2" = "workspace 2";
          "${modifier}+3" = "workspace 3";
          "${modifier}+4" = "workspace 4";
          "${modifier}+5" = "workspace 5";
          "${modifier}+6" = "workspace 6";
          "${modifier}+7" = "workspace 7";
          "${modifier}+8" = "workspace 8";
          "${modifier}+9" = "workspace 9";

          "${modifier}+Shift+1" = "move container to workspace 1";
          "${modifier}+Shift+2" = "move container to workspace 2";
          "${modifier}+Shift+3" = "move container to workspace 3";
          "${modifier}+Shift+4" = "move container to workspace 4";
          "${modifier}+Shift+5" = "move container to workspace 5";
          "${modifier}+Shift+6" = "move container to workspace 6";
          "${modifier}+Shift+7" = "move container to workspace 7";
          "${modifier}+Shift+8" = "move container to workspace 8";
          "${modifier}+Shift+9" = "move container to workspace 9";

          "${modifier}+m" = "move workspace to output right";

          "${modifier}+r" = "reload";
          "${modifier}+Shift+r" = "restart";
          "${modifier}+Shift+e" = "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";
          # "${modifier}+r" = "mode resize";

          "XF86AudioLowerVolume" = "exec ${metavol} down";
          # "XF86AudioLowerVolume" = "exec amixer -q set Master 2%- unmute";
          "XF86AudioRaiseVolume" = "exec ${metavol} up";
          "XF86AudioMute" = "exec ${metavol} mute";
        };
      };
    };
  };
}
