{pkgs, ...}:
{
  xsession = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
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
        floating.modifier = "Mod1";
        keybindings = let modifier = "Mod1"; in {
          "${modifier}+Return" = "exec alacritty";
          "${modifier}+Shift+q" = "kill";
          "${modifier}+space" = "exec ${pkgs.dmenu}/bin/dmenu_run";
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

          "XF86AudioLowerVolume" = "exec amixer -q set Master 2%- unmute";
          "XF86AudioRaiseVolume" = "exec amixer -q set Master 2%+ unmute";
          "XF86AudioMute" = "exec amixer -q set Master toggle";
        };
        gaps = {
          inner = 10;
          outer = 5;
        };
      };
    };
  };
}
