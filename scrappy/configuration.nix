# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "91bd34620d73340be03642279ee0d1c64110ee6c";
    ref = "release-20.09";
  };

  nixConfigs = builtins.fetchGit {
    url = "https://github.com/horkhork/nixops-cfgs.git";
    #rev = "89dda4e9597c32908a88e9dd8af838893df37fc6";
    ref = "dev";
    #ref = "master";
  };

in

{
  deployment.targetHost = "localhost";

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Enable home-manager
      (import "${home-manager}/nixos")
    ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 20d";
  };

  system.stateVersion = "20.09"; # Did you read the comment?
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  # Allow Unfree software
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "scrappy"; # Define your hostname.

    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    #
    interfaces = {
      enp3s0.useDHCP = true;
      enp4s0.useDHCP = true;
      wlp2s0.useDHCP = true;
    };
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  virtualisation.docker.enable = true;

  # List services that you want to enable:
  services = {

    # Enable the GNOME 3 Desktop Environment.
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome3.enable = true;
    };

    #services.mullvad-vpn.enable = true;

    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      permitRootLogin = "yes";
      passwordAuthentication = false;
    };

  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    _1password
    firefox
    git
    hfsprogs
    mullvad-vpn
    nixops
    tmux
    vim
    wget
    zsh-powerlevel10k
  ];

  security.sudo.wheelNeedsPassword = false;
  programs.vim.defaultEditor = true;

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    ohMyZsh.enable = true;
    promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.root = {
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8E/PbfpTIDPLYl6+KbfauImwcDRQp4t7azgOjzRckwKHZ0AzfJUKVs7lqTaUFbim0IK83fC9AFAW0Y/sUf5SOu2As5UNxLW4/9ol8tXECOkrgZQK7dVLuCEiVFX2/nf4Rds0XBC1DdpPwJAy909/eXnjUKCR/1QKya3KsNQn9ZPvypZ/mdhxpJZ36DCasExU56tVF3xFfyFX+rIukWRKVOWjB6crEyDR8rv1MR22IhpRhZmq35sjDIn03ZYJ4KzDT6dLPrNolKh+Ys8uhcJKDHEIop3Id6WMU43kZgNiHmGN/0j4Xy1FpYro0EmuFcs4bf1/9k1/4ALAem+yhrr75 linode nix test" ];
  };

  users.users.me = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8E/PbfpTIDPLYl6+KbfauImwcDRQp4t7azgOjzRckwKHZ0AzfJUKVs7lqTaUFbim0IK83fC9AFAW0Y/sUf5SOu2As5UNxLW4/9ol8tXECOkrgZQK7dVLuCEiVFX2/nf4Rds0XBC1DdpPwJAy909/eXnjUKCR/1QKya3KsNQn9ZPvypZ/mdhxpJZ36DCasExU56tVF3xFfyFX+rIukWRKVOWjB6crEyDR8rv1MR22IhpRhZmq35sjDIn03ZYJ4KzDT6dLPrNolKh+Ys8uhcJKDHEIop3Id6WMU43kZgNiHmGN/0j4Xy1FpYro0EmuFcs4bf1/9k1/4ALAem+yhrr75 linode nix test" ];
  };

  home-manager.users.me = import (nixConfigs + "/${config.networking.hostName}/home.${config.networking.hostName}.nix") pkgs ;
}

