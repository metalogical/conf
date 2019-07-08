{ config, pkgs, ... }:
{
  imports = [ ./gui.nix ./fonts.nix ./neovim.nix ];

  nixpkgs.overlays = [(self: super: {
    dunst = self.callPackage <nixpkgs/pkgs/applications/misc/dunst> { dunstify = true; };
  })];

  home.packages = with pkgs; [
    alacritty rofi dunst
    gotop
    spotify
    xdg_utils
    zathura # pdf viewer
    vlc
    brave

    ## music stuff
    jack2 qjackctl a2jmidid # TODO configure autostart etc?
    (callPackage ./programs/pianoteq.nix {})
    lilypond

    ## 3d printing
    slic3r-prusa3d
    openscad

    ## photography
    darktable

    python37
    python37Packages.virtualenv
  ];

  fonts.fonts = with pkgs; [ source-code-pro source-sans-pro ];

  programs.fish = {
    enable = true;
    package = pkgs.fish;
  };

  programs.git = {
    enable = true;
    userName = "metalogical";
    userEmail = "1977419+metalogical@users.noreply.github.com";
    lfs = {
      enable = true;
      skipSmudge = true;
    };
  };

  programs.go = {
    enable = true;
    package = pkgs.go_1_11;
    goPath = "go";
  };
  home.sessionVariables.PATH = "${config.home.sessionVariables.GOPATH}/bin:$PATH";


  programs.firefox.enable = true; # for DRM, for now

  services.redshift = {
    enable = true;
    latitude = "37.78";
    longitude = "-122.45";
  };

  # Faustian bargain
  nixpkgs.config.allowUnfree = true;
}
