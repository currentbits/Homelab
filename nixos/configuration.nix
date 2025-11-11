# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-ef952b7b-39ab-429b-bf1b-023f06dd28d7".device = "/dev/disk/by-uuid/ef952b7b-39ab-429b-bf1b-023f06dd28d7";
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.willem = {
    isNormalUser = true;
    description = "willem";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
   curl
   tmux
   docker
   neofetch
   git
   zsh
   neovim
   wget
   opentofu
   fluxcd
   age
   sops
   kubectl
   k9s
   ansible	
  ];

  #enviroment setup
  environment.etc."nixos".source = "/home/willem/development/homelab/nixos";

  # Copy neofetch config into each user's home on rebuild
  environment.etc."skel/.config/neofetch/config.conf".source = ./dotfiles/neofetch/config.conf;
  environment.etc."skel/.config/neofetch/ascii.txt".source = ./dotfiles/neofetch/ascii.txt;

  # Automatically show neofetch when logging in interactively
  environment.interactiveShellInit = ''
    if [ -x ${pkgs.neofetch}/bin/neofetch ]; then
      # Only show if user has a TTY (avoid cron/script sessions)
      if [ -t 1 ]; then
        ${pkgs.neofetch}/bin/neofetch
      fi
    fi
  ''; 

  #enable tailscale
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };
  #alter firewall for tailscale
  networking.firewall.checkReversePath = "loose";
  #autostart tailscale on boot
  systemd.services.tailscaled.wantedBy = [ "multi-user.target" ];  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
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
