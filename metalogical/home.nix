{ pkgs, ... }:
{
  home.sessionVariables = { EDITOR = "nvim"; };

  imports = [ ./xsession.nix ./fonts.nix ./neovim.nix ./go-dev.nix ];

  home.packages = with pkgs; [
    alacritty dmenu
    spotify

    # music stuff
    jack2 qjackctl a2jmidid # TODO configure autostart etc?
    (callPackage ./programs/pianoteq.nix {})
    # (callPackage ./programs/reaper.nix {})

    # 3d printing
    slic3r-prusa3d

    # virtmanager

    redshift
  ];

  fonts.fonts = with pkgs; [ source-code-pro source-sans-pro ];

  programs.git = {
    enable = true;
    userName = "metalogical";
    userEmail = "1977419+metalogical@users.noreply.github.com";
    lfs = {
      enable = true;
      skipSmudge = true;
    };
  };


  programs.firefox.enable = true;

  services.redshift = {
    enable = true;
    latitude = "37.78";
    longitude = "-122.45";
  };

  # Faustian bargain
  nixpkgs.config.allowUnfree = true;
}
