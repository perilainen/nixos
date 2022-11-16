{ config, pkgs, ... }:
{

  environment.gnome.excludePackages  = (with pkgs; [
    gnome-photos
    gnome-tour]);
  services.xserver = {
    dpi = 96;
    enable = true;
    layout = "us,se";
   # xkbOptions = "grp:win_space_toggle";
  #  xkbVariant = "altgr-intl";
    /* xbdModel = "pc105"; */
    desktopManager = {
      #xterm.enable = false;
      #wallpaper.mode = "fill";
    gnome.enable = true;
      #gnome.flashback.enableMetacity= true;


    };
    displayManager = {
      gdm.enable = true;
      gdm.wayland = false;
    #  defaultSession = "none+i3";
    #  lightdm.enable = true;
    };
    #windowManager = {
    #  gnome.enable = true;
      #i3.extraPackages = with pkgs; [
      #  dmenu
#	i3status
#	i3lock
 #     ];
    #};
    libinput.enable = true;
};
services.dbus.packages = [pkgs.dconf];
services.udev.packages = [pkgs.gnome3.gnome-settings-daemon];
}
