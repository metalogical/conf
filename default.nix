{ config, pkgs, ... }:

{
  imports = [ ./deps/musnix ./deps/home-manager/nixos ];


  # autoupgrade from 18.09 stable
  system.autoUpgrade.enable = true;
  system.autoUpgrade.channel = https://nixos.org/channels/nixos-18.09;


  # sound
  sound.enable = true;
  networking.networkmanager.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  # real-time audio
  musnix.enable = true;
  musnix.alsaSeq.enable = true;
  # musnix.kernel.realtime = true;
  # musnix.kernel.packages = pkgs.linuxPackages_4_18_rt;


  # graphics
  services.xserver.enable = true;


  # virtualisation with KVM
  virtualisation.libvirtd.enable = true;
  boot.kernel.sysctl = { "net.ipv4.ip_forward" = 1; };


  # bookkeeping
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };
  time.timeZone = "America/Los_Angeles";
  # USB drives are typically exfat
  boot.extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];


  # users
  programs.fish.enable = true; # configure the default shell from home-manager?
  users.extraUsers.metalogical = {
    shell = pkgs.fish;
    extraGroups = [ "wheel" "audio" "libvirtd" "networkmanager" ];
    isNormalUser = true;
    uid = 1000;
  };
  home-manager.users.metalogical = (import ./metalogical/home.nix);


  # Faustian bargain
  security.sudo.wheelNeedsPassword = false;
}
