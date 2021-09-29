{ config, pkgs, ... }:

let nixConfigs = builtins.fetchGit {
    url = "https://github.com/horkhork/nixops-cfgs.git";
    ref = "master";
  };
in

{
    home.packages = [
      pkgs.asciidoc
      pkgs.curl
      pkgs.file
      pkgs.gcc
      pkgs.go
      pkgs.htop
      pkgs.httpie
      pkgs.k6
      pkgs.nerdfonts
      pkgs.niv # https://github.com/nmattia/niv
      pkgs.pandoc
      pkgs.pass
      pkgs.pv
      pkgs.python3
      pkgs.ripgrep
      pkgs.terraform
      pkgs.traceroute
      pkgs.unzip
      pkgs.vault
      pkgs.wget
      pkgs.zsh-powerlevel10k
    ];

    services.lorri.enable = true; # https://github.com/target/lorri

    programs = {
      direnv = {
        enable = true;
        enableZshIntegration = true;
      };

      fzf = {
        enable = true;
        enableZshIntegration = true;
      };

      #git = import (nixConfigs + "/common/git-little-fluffy.nix");
      git = {
        enable = true;
        userName = "Steve Sosik";
        userEmail = "gitter@little-fluffy.cloud";
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

      gpg.enable = true;

      # Let Home Manager install and manage itself.
      home-manager.enable = true;

      info.enable = true;
      jq.enable = true;
      lesspipe.enable = true;

      #newsboat = {
      #  enable = true;
      #};
      readline.enable = true;

      #keychain = {
      #  enable = true;
      #  enableZshIntegration = true;
      #};

      taskwarrior = {
        enable = true;
        colorTheme = "dark-blue-256";
        dataLocation = ".task";
        config = {
          uda.totalactivetime.type = "duration";
          uda.totalactivetime.label = "Total active time";
          report.list.labels = [ "ID" "Active" "Age" "TimeSpent" "D" "P" "Project" "Tags" "R" "Sch" "Due" "Until" "Description" "Urg" ];
          report.list.columns = [ "id" "start.age" "entry.age" "totalactivetime" "depends.indicator" "priority" "project" "tags" "recur.indicator" "scheduled.countdown" "due" "until.remaining" "description.count" "urgency" ];
        };
      };

      vim = {
        enable = true;
        extraConfig = builtins.readFile (nixConfigs + "/common/dot.vimrc");
        settings = {
           relativenumber = true;
           number = true;
        };
        plugins = [
          pkgs.vimPlugins.Jenkinsfile-vim-syntax
          pkgs.vimPlugins.ale
          pkgs.vimPlugins.ansible-vim
          pkgs.vimPlugins.calendar-vim
          #pkgs.vimPlugins.direnv-vim
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
          #pkgs.vimPlugins.vim-go
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

      tmux = {
        enable = true;
        extraConfig = builtins.readFile (nixConfigs + "/common/dot.tmux.conf");
        keyMode = "vi";
  }    ;

      zsh = {
        enable = true;
        enableAutosuggestions = true;
        enableCompletion = true;
        autocd = true;
        history = {
          extended = true;
          save = 50000;
          share = true;
          size = 50000;
        };
        oh-my-zsh = {
          enable = true;
          plugins = [ "git" "history" "taskwarrior" "virtualenv" ]; # "zsh-autosuggestions" "tmux" "tmuxinator" "ssh-agent"
          theme = "zsh-powerlevel10k/powerlevel10k";
          custom = "${pkgs.zsh-powerlevel10k}/share/";
        };
      };

    }; # End programs

    home.file.".zshrc".text = builtins.readFile (nixConfigs + "/common/dot.zshrc");
    home.file.".p10k.zsh".text = builtins.readFile (nixConfigs + "/common/dot.p10k.zsh");

  }
