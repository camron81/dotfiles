{ ... }:

{
  flake.modules.nixos.android = _: {
    programs.adb.enable = true;
  };

  flake.modules.homeManager.android =
    { config, ... }:
    {
      home.sessionVariables."ANDROID_USER_HOME" = "${config.xdg.dataHome}/android";
      programs.bash.shellAliases = {
        adb = "HOME=${config.xdg.dataHome}/android adb";
      };
    };
}
