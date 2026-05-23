{ ... }:

{
  flake.modules.homeManager.java =
    { config, ... }:
    {
      home.sessionVariables."_JAVA_OPTIONS" = "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java";
    };
}
