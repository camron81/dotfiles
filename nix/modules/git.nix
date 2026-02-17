# Link: https://blog.gitbutler.com/how-git-core-devs-configure-git
{ lib, ... }:
{
  options.git.homeManager.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
  };

  config.flake.modules.homeManager.git = _: {
    programs.git = {
      enable = true;
      settings = {
        branch.sort = "-committerdate";
        column.ui = "auto";
        commit.verbose = true;

        diff = {
          algorithm = "histogram";
          colorMoved = "plain";
          mnemonicPrefix = true;
          renames = true;
        };

        fetch = {
          prune = true;
          pruneTags = true;
          all = true;
        };

        help.autocorrect = true;
        init.defaultBranch = "main";

        push = {
          default = "simple";
          autoSetupRemote = true;
          followTags = true;
        };

        tag.sort = "version:refname";

        user = {
          name = "camron81";
          email = "ethancameron81@gmail.com";
        };
      };
    };
  };
}
