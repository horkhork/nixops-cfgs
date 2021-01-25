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
in

{
  deployment.targetHost = "localhost";

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Enable home-manager
      (import "${home-manager}/nixos")
    ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  # Allow Unfree software
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "scrappy"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "America/New_York";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp3s0.useDHCP = true;
  networking.interfaces.enp4s0.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable the GNOME 3 Desktop Environment.
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;
  
  # List services that you want to enable:

  #services.mullvad-vpn.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
    passwordAuthentication = false;
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  programs.vim.defaultEditor = true;

  security.sudo.wheelNeedsPassword = false;

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
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.root = {
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8E/PbfpTIDPLYl6+KbfauImwcDRQp4t7azgOjzRckwKHZ0AzfJUKVs7lqTaUFbim0IK83fC9AFAW0Y/sUf5SOu2As5UNxLW4/9ol8tXECOkrgZQK7dVLuCEiVFX2/nf4Rds0XBC1DdpPwJAy909/eXnjUKCR/1QKya3KsNQn9ZPvypZ/mdhxpJZ36DCasExU56tVF3xFfyFX+rIukWRKVOWjB6crEyDR8rv1MR22IhpRhZmq35sjDIn03ZYJ4KzDT6dLPrNolKh+Ys8uhcJKDHEIop3Id6WMU43kZgNiHmGN/0j4Xy1FpYro0EmuFcs4bf1/9k1/4ALAem+yhrr75 linode nix test" ];
  };

  users.users.me = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8E/PbfpTIDPLYl6+KbfauImwcDRQp4t7azgOjzRckwKHZ0AzfJUKVs7lqTaUFbim0IK83fC9AFAW0Y/sUf5SOu2As5UNxLW4/9ol8tXECOkrgZQK7dVLuCEiVFX2/nf4Rds0XBC1DdpPwJAy909/eXnjUKCR/1QKya3KsNQn9ZPvypZ/mdhxpJZ36DCasExU56tVF3xFfyFX+rIukWRKVOWjB6crEyDR8rv1MR22IhpRhZmq35sjDIn03ZYJ4KzDT6dLPrNolKh+Ys8uhcJKDHEIop3Id6WMU43kZgNiHmGN/0j4Xy1FpYro0EmuFcs4bf1/9k1/4ALAem+yhrr75 linode nix test" ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  home-manager.users.me = {
    home.packages = [
      pkgs.asciidoc
      pkgs.curl
      pkgs.gcc
      pkgs.go
      pkgs.httpie
      pkgs.k6
      pkgs.pandoc
      pkgs.pv
      pkgs.python3
      pkgs.ripgrep
      pkgs.traceroute
      pkgs.unzip
      pkgs.wget
      pkgs.zsh-powerlevel10k
      #pkgs.nerdfonts
      pkgs.terraform
      pkgs.vault
    ];

    programs = {
      direnv = {
        enable = true;
        enableZshIntegration = true;
      };

      fzf = {
        enable = true;
        enableZshIntegration = true;
      };

      git = {
        enable = true;
        userName = "Steve Sosik";
        userEmail = "steve@little-fluffy.cloud";
        aliases = {
          lg = "log --graph --oneline --decorate --all";
          com = "commit -v";
          fet = "fetch -v";
          co = "!git checkout $(git branch | fzf-tmux -r 50)";
          a = "add -p";
          pu = "pull --rebase=true origin master";
          ignore = "update-index --skip-worktree";
          unignore = "update-index --no-skip-worktree";
          hide = "update-index --assume-unchanged";
          unhide = "update-index --no-assume-unchanged";
          showremote = "!git for-each-ref --format=\"%(upstream:short)\" \"$(git symbolic-ref -q HEAD)\"";
          prune-merged = "!git branch -d $(git branch --merged | grep -v '* master')";
        };
        extraConfig = {
          core = {
            editor = "vim";
            fileMode = "false";
            filemode = "false";
          };
          push = {
            default = "simple";
          };
          merge = {
            tool = "vimdiff";
            conflictstyle = "diff3";
          };
          pager = {
            branch = "false";
          };
          credential = {
            helper = "cache --timeout=43200";
          };
        };
      };

      #gpg.enable = true;

      ## Let Home Manager install and manage itself.
      #home-manager.enable = true;

      #info.enable = true;

      jq.enable = true;

      #keychain = {
      #  enable = true;
      #  enableZshIntegration = true;
      #};

      #programs.lesspipe.enable = true;

      #newsboat = {
      #  enable = true;
      #};

      #readline.enable = true;

      taskwarrior = {
        enable = true;
        colorTheme = "dark-blue-256";
        dataLocation = "$HOME/.task";
        config = {
          uda.totalactivetime.type = "duration";
          uda.totalactivetime.label = "Total active time";
          report.list.labels = [ "ID" "Active" "Age" "TimeSpent" "D" "P" "Project" "Tags" "R" "Sch" "Due" "Until" "Description" "Urg" ];
          report.list.columns = [ "id" "start.age" "entry.age" "totalactivetime" "depends.indicator" "priority" "project" "tags" "recur.indicator" "scheduled.countdown" "due" "unti  l.remaining" "description.count" "urgency" ];
        };
      };

      vim = {
        enable = true;
	extraConfig = builtins.readFile "/home/me/nixops-cfgs/scrappy/dot.vimrc";
	#extraConfig = builtins.readFile "scrappy/dot.vimrc";
        settings = {
           relativenumber = true;
           number = true;
        };
        plugins = [
          pkgs.vimPlugins.Jenkinsfile-vim-syntax
          pkgs.vimPlugins.ale
          pkgs.vimPlugins.ansible-vim
          pkgs.vimPlugins.calendar-vim
          pkgs.vimPlugins.direnv-vim
          pkgs.vimPlugins.emmet-vim
          pkgs.vimPlugins.fzf-vim
          pkgs.vimPlugins.goyo-vim
          pkgs.vimPlugins.jedi-vim
          pkgs.vimPlugins.jq-vim
          pkgs.vimPlugins.molokai
          pkgs.vimPlugins.nerdcommenter
          pkgs.vimPlugins.nerdtree
          pkgs.vimPlugins.nerdtree-git-plugin
          pkgs.vimPlugins.rust-vim
          pkgs.vimPlugins.tabular
          pkgs.vimPlugins.vim-airline
          pkgs.vimPlugins.vim-airline-themes
          pkgs.vimPlugins.vim-devicons
          pkgs.vimPlugins.vim-eunuch
          pkgs.vimPlugins.vim-fugitive
          pkgs.vimPlugins.vim-gitgutter
          pkgs.vimPlugins.vim-go
          pkgs.vimPlugins.vim-markdown
          pkgs.vimPlugins.vim-multiple-cursors
          pkgs.vimPlugins.vim-nix
          pkgs.vimPlugins.vim-plug
          pkgs.vimPlugins.vim-repeat
          pkgs.vimPlugins.vim-sensible
          pkgs.vimPlugins.vim-speeddating
          pkgs.vimPlugins.vim-surround
          pkgs.vimPlugins.vim-terraform
          pkgs.vimPlugins.vim-unimpaired
        ];
      };

      zsh = {
        enable = true;
        enableAutosuggestions = true;
        enableCompletion = true;
        autocd = true;
        dotDir = ".config/zsh";
        history = {
          extended = true;
          save = 50000;
          share = true;
          size = 50000;
        };
        #localVariables = {
        #  #ZSH_TMUX_ITERM2 = true;
        #  #POWERLEVEL9K_MODE = "nerdfont-complete";
        #  #COMPLETION_WAITING_DOTS = true;
        #  #ZSH_CUSTOM = "${pkgs.zsh-powerlevel9k}/share/";
        #  #POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD = true;
        #  #SSH_AUTH_SOCK = ".ssh/ssh_auth_sock";
        #};
        #envExtra = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        oh-my-zsh = {
          enable = true;
          plugins = [ "git" "history" "taskwarrior" "virtualenv" ]; # "zsh-autosuggestions" "tmux" "tmuxinator" "ssh-agent" 
          theme = "zsh-powerlevel10k/powerlevel10k";
          custom = "${pkgs.zsh-powerlevel10k}/share/";
        };
        #initExtraBeforeCompInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        #initExtraBeforeCompInit = builtins.readFile ../../config/zsh/.zshrc;
        #plugins = [ {
        #  name = "powerlevel10k";

        #  #src = pkgs.fetchFromGitHub {
        #  #  owner = "romkatv";
        #  #  repo = "powerlevel10k";
        #  #  rev = "v1.5.0";
        #  #  sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
        #  #};

        #  #src = builtins.fetchGit {
        #  #  url = "https://github.com/romkatv/powerlevel10k.git";
        #  #  rev = "6a0e7523b232d02854008405a3645031c848922b";
        #  #  ref = "v1.5.0";
        #  #};

        #  src = pkgs.zsh-powerlevel10k;
        #  file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        # }
        #];
      };

    }; # End programs

    home.file.".p10k.zsh".text = builtins.readFile "/home/me/nixops-cfgs/scrappy/dot.p10k.zsh";

  };

}

