# TODO: Add networkmanager to prvileged groups.
{ ... }:
{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      console.useXkbConfig = true;
      networking.networkmanager.enable = true;

      services = {
        pipewire = {
          enable = true;
          pulse.enable = true;
        };

        xserver = {
          enable = true;
          excludePackages = [ pkgs.xterm ];
          xkb = {
            layout = "gb";
            options = "ctrl:nocaps";
          };
        };
      };
    };

  flake.modules.homeManager.desktop =
    { config, pkgs, ... }:
    {
      fonts.fontconfig = {
        enable = true;
        defaultFonts = {
          emoji = [ "Noto Color Emoji" ];
          monospace = [ "AdwaitaMono Nerd Font Propo" ];
          sansSerif = [ "Adwaita Sans" ];
          serif = [ "Aleo" ];
        };
      };

      gtk = {
        enable = true;
        cursorTheme = {
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Classic";
          size = 20;
        };

        font = {
          package = pkgs.adwaita-fonts;
          name = "Adwaita Sans";
          size = 11;
        };

        theme = {
          name = "Adwaita-dark";
          package = pkgs.gnome-themes-extra;
        };

        gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      };

      home.packages = with pkgs; [
        aleo-fonts
        adwaita-fonts
        nerd-fonts.adwaita-mono
        noto-fonts-color-emoji
      ];
    };
}
