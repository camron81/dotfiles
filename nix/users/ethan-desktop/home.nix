{
  config,
  inputs,
  self,
  ...
}:
let
  cfg = config;
  homeManager = self.modules.homeManager;
in
{
  flake.homeConfigurations."ethan@desktop" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.${cfg.base.hostPlatform};
    modules = [
      homeManager.base
      homeManager.desktop
      homeManager.git
      homeManager.gnome
      homeManager.megacmd
      homeManager.neovim
      homeManager.ssh
      self.homeModules."ethan@laptop"
    ];
  };

  flake.homeModules."ethan@laptop" =
    { pkgs, ... }:
    {
      home = {
        username = "ethan";

        packages = with pkgs; [
          bitwarden-desktop
          freetube
          librewolf
          onlyoffice-desktopeditors
        ];

        sessionVariables = {
          BROWSER = "librewolf";
          EDITOR = "nvim";
          # VISUAL = "tbc";
          # TERMINAL = "tbc";
        };
      };
    };
}
