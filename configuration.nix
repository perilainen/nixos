# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    (import "${home-manager}/nixos")
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver = {
    dpi = 220;
    enable = true;
    layout = "us";
    desktopManager = {
      xterm.enable = false;
      wallpaper.mode = "fill";
    };
    displayManager = {
      defaultSession = "none+i3";
      lightdm.enable = true;
    };
    windowManager = {
      i3.enable = true;
      i3.extraPackages = with pkgs; [
        dmenu
	i3status
	i3lock
      ];
    };
    libinput.enable = true;
};


  

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
 #    "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound = {
    enable = true;
    extraConfig = ''
      pcm.!default {
        type hw
	card 1
      }
      ctl.!default {
        type hw
	card 1
      }
    '';
};
services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
  # If you want to use JACK applications, uncomment this
  jack.enable = true;
};
 services.pipewire.config.pipewire-pulse = {
    "pulse.properties" = {
      "server.address" = [
        # default:
        "unix:native"
        # extension:
        "unix:/tmp/pulse-for-all"
      ];
    };
  };
  hardware.pulseaudio.extraClientConf = ''
    default-server=unix:/tmp/pulse-for-all
  '';
 # hardware.pulseaudio.enable = true;
 # hardware.pulseaudio.support32Bit = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.pejo= {
     isNormalUser = true;
     extraGroups = [ "wheel" "docker"]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [
     ];
   };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     neovim
     #llvmPackages.clang-unwrapped
     #build-essential
     #libssl1.0.0
     #libasound2
     tmux
     #SDL
     mpv
     nerdfonts
     pulseaudioFull
     rustup
     (writeShellScriptBin "xrandr-auto" ''
     xrandr --output Virtual-1 --auto
     '')
   ];
   programs.git= {
     enable = true;
     };



  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  security.rtkit.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
nix.package = pkgs.nixUnstable;
 		nix.extraOptions = "experimental-features = nix-command flakes";
   			services.openssh.enable = true;
 		services.openssh.passwordAuthentication = true;
 		services.openssh.permitRootLogin = "yes";
 		users.users.root.initialPassword = "root";
virtualisation.vmware.guest.enable = true;
virtualisation.docker.enable = true;
nixpkgs.config.virtualbox.pulseSupport = true;
networking.interfaces.ens33.useDHCP = true;


fileSystems."/host" = {
  fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
  device = ".host:/";
  options = [
    "umask=22"
    "uid=1000"
    "gid=1000"
    "allow_other"
    "auto_unmount"
    "defaults"
    ];
  };
home-manager.users.pejo = import ./pejo-home.nix;


fonts.fonts = with pkgs; [
fira-code
nerdfonts
powerline-fonts
];
}

