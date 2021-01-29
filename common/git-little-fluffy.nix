{
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
}
