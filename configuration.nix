# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{config, lib, pkgs, unstable, inputs, ...}:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nvf.nix
      ./wireless.nix
      ./hjem.nix 
      ./music.nix
    ];

# enabling niri overlay so i can use niri flake stuff as if its in nixpkgs

  nixpkgs.overlays = [ inputs.niri.overlays.niri inputs.nix-cachyos-kernel.overlays.default inputs.zig.overlays.default];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest mainline kernel.
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # CachyOS kernel for better optimisation
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system. (no longer needed for GNOME as of 25.11)
  # services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
   services.displayManager.gdm.enable = true;
   services.desktopManager.gnome.enable = true;

  # this builds the pkg via the flake due to overlay
  programs.niri.enable = true;


  # systemd service for noctalia so it boots with niri
#  systemd.user.services.noctalia-shell-service = {
#  enable = true;
#  after = [ "graphical-session.target" ];
#  wantedBy = [ "graphical-session.target" ];
#  description = "Noctalia Shell Service";
#  serviceConfig = {
    #  Type = "simple";
#      ExecStart = "noctalia-shell";
#      Restart = "on-failure";
#      RestartSec = "1";
#  };
#};


  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us, de";
    variant = "";
  };

  # enable bluetooth
  hardware.bluetooth = {
  enable = true;
  powerOnBoot = true;
  settings = {
    General = {
      # Shows battery charge of connected devices on supported
      # Bluetooth adapters. Defaults to 'false'.
      Experimental = true;
      # When enabled other devices can connect faster to us, however
      # the tradeoff is increased power consumption. Defaults to
      # 'false'.
      FastConnectable = true;
    };
    Policy = {
      # Enable all controllers when they are found. This includes
      # adapters present on start as well as adapters that are plugged
      # in later on. Defaults to 'true'.
      AutoEnable = true;
    };
  };
};

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.penguin = {
    isNormalUser = true;
    description = "penguin";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };
  
  # adding penguin as trusted user
  nix.settings.trusted-users = [ "root" "penguin" ];
  
  # enabling nix commands and flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

 # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation = {
    waydroid.enable = true;
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Install firefox.
  programs.firefox.enable = true;


  #installing steam with necessary open firewall ports for remote play 
    programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
     # dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
     # localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };
   };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
 # 25.05 (or later)

  fonts.packages = with pkgs; [
     nerd-fonts.jetbrains-mono
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
     inputs.zig.packages.x86_64-linux.master
     git
     # zen browse is installed via a flake, thats the reason for this syntax mess
     unstable.ironbar
     swaynotificationcenter

     wl-clipboard
     
     inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
     xwayland-satellite
     orca-slicer
     gnomeExtensions.pop-shell
     fish
     starship
     #yes this pkg needs to be here although niri is also being enabled in other ways in this file 
     niri
     #this one is a bit special because it comes from the quckshell flake
    # inputs.quickshell.packages.x86_64-linux.default
     #noctalia uses nixpgks quickshell so the flake stuff isnt required
     dive # look into docker image layers
     podman-tui # status of containers in the terminal
     docker-compose # start group of containers for dev
    #podman-compose # start group of containers for dev
     cava
     #audio visualiser
     brillo
     #brightness control

     obsidian
     freecad
     jetbrains.webstorm
     google-chrome

     prismlauncher
     javaPackages.compiler.temurin-bin.jre-25

     cardinal
     jack2
     element-web
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
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
