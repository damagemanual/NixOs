# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).


  # Added to enable Nix Config Editor
  #{ config, pkgs, ... }:
{ config, pkgs, lib, ... }:
  let
    nixos-conf-editor = (import (pkgs.fetchFromGitHub {
    	owner = "vlinkz";
    	repo = "nixos-conf-editor";
    	rev = "0.1.1";
    	sha256 = "sha256-TeDpfaIRoDg01FIP8JZIS7RsGok/Z24Y3Kf+PuKt6K4=";
    })) {};
  in  
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable Tailscale
    services.tailscale.enable = true;

  # Set your time zone.
  time.timeZone = "America/Detroit";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
   services.xserver.displayManager.gdm.enable = true;
   services.xserver.desktopManager.gnome.enable = true;

  # Enable KDE Plasma
  #  services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.seth = {
    isNormalUser = true;
    description = "seth";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    # Audio & Video
      ardour
      vlc
      kdenlive
      obs-studio
      reaper
    # Dev Tools
      emacs
      vim
      micro
      nano
    # Games
    # Graphics & Photos
      inkscape
      gimp
      darktable
    # Internet / Communications
      wget	
    # firefox
      firefox-wayland
    # brave
      signal-desktop
      tor
      tor-browser-bundle-bin
      onionshare
    # Productivity
      bitwarden
      libreoffice
    # Docker apps
      docker
      docker-compose
    # System Utils
      htop
      neofetch
      rsync
      curl
      filezilla
      flatpak
      gparted
      mc
      remmina
      tmux
    ];
  };

  # Docker
    virtualisation.docker.enable = true;

  

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  nixos-conf-editor
  ];

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
   networking.firewall.enable = false;
   networking.firewall.checkReversePath = "loose";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
  
  # Added auto mount to second HDD 2/2/2023
  # Make sure to create the Data_disk folder before the first build!!!
  
  fileSystems. "/home/seth/Data_Disk" =
    { device = "/dev/disk/by-uuid/11c15298-6433-4c86-9c05-1d2de61d85fd";
      fsType = "ext4";
    };
  
  # Enable Tailscale VPN 2/2/2023
  #  services.tailscale.enable = true;

  # Enable Flatpaks
  services.flatpak.enable = true;

  # Clean System
  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
  # Auto Upgrades
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;
  fonts.enableGhostscriptFonts = true;
  fonts.enableDefaultFonts = true;

}
