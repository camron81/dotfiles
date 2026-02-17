# TODO: Remove the GNOME applications you no longer need.
{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config;
  legacyPkgs = inputs.nixpkgs.legacyPackages.${cfg.base.hostPlatform};
in
{
  options.gnome.extensions = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    default = with legacyPkgs.gnomeExtensions; [
      alphabetical-app-grid
      appindicator
      launch-new-instance
    ];
  };

  config.flake.modules.nixos.gnome = _: {
    environment.systemPackages = cfg.gnome.extensions;
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;
  };

  config.flake.modules.homeManager.gnome =
    { lib, pkgs, ... }:
    let
      wallpaperDir = "${pkgs.gnome-backgrounds}/share/backgrounds/gnome";
    in
    with lib.hm.gvariant;
    {
      dconf.settings = {
        "org/gnome/desktop/background" = {
          color-shading-type = "solid";
          picture-options = "zoom";
          picture-uri = "${wallpaperDir}/blobs-l.svg";
          picture-uri-dark = "${wallpaperDir}/blobs-d.svg";
        };

        "org/gnome/desktop/input-sources" = {
          sources = [
            (mkTuple [
              "xkb"
              "gb"
            ])
          ];
          xkb-options = [ "ctrl:nocaps" ];
        };

        "org/gnome/desktop/interface" = {
          clock-show-weekday = true;
          color-scheme = "prefer-dark";
          enable-hot-corners = false;
          show-battery-percentage = true;
        };

        "org/gnome/desktop/lockdown" = {
          disable-print-setup = true;
          disable-printing = true;
          user-administration-disabled = true;
        };

        "org/gnome/desktop/peripherals/keyboard" = {
          delay = mkUint32 200;
          repeat-interval = mkUint32 20;
          numlock-state = true;
        };

        "org/gnome/desktop/privacy" = {
          disable-camera = true;
          disable-microphone = true;
          hide-identity = true;
          show-full-name-in-top-bar = false;
        };

        "org/gnome/desktop/screensaver" = {
          color-shading-type = "solid";
          picture-options = "zoom";
          picture-uri = "${wallpaperDir}/blobs-d.svg";
        };

        "org/gnome/desktop/session" = {
          idle-delay = mkUint32 600;
        };

        "org/gnome/settings-daemon/plugins/housekeeping" = {
          donation-reminder-enabled = false;
        };

        "org/gnome/shell" = {
          enabled-extensions = (builtins.map (e: e.extensionUuid) cfg.gnome.extensions);
        };
      };
    };
}
