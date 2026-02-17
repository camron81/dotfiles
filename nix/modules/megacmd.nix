{ ... }:
{
  flake.modules.homeManager.megacmd =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.megacmd ];

      systemd.user.services.megacmd = {
        Unit.Description = "Runs the megcmd server as a background service";
        Service = {
          Type = "exec";
          ExecStart = "${pkgs.megacmd}/bin/mega-cmd-server";
        };
        Install.WantedBy = [ "default.target" ];
      };
    };
}
