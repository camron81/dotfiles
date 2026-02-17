# Link: https://jackson.dev/post/nix-reasonable-defaults/
{ config, lib, ... }:
let
  cfg = config;
in
{
  options.base = {
    hostPlatform = lib.mkOption {
      type = lib.types.nonEmptyStr;
      example = "x86_86-linux";
    };

    stateVersion = lib.mkOption {
      type = lib.types.nonEmptyStr;
      example = "25.11";
    };
  };

  config.flake.modules.nixos.base = _: {
    boot.loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
      timeout = 0;
    };

    console.keyMap = lib.mkDefault "uk";

    documentation = {
      dev.enable = true;
      doc.enable = false;
      info.enable = false;
    };

    hardware.enableRedistributableFirmware = true;
    i18n.defaultLocale = "en_GB.UTF-8";

    nix = {
      channel.enable = false;

      optimise = {
        automatic = true;
        dates = [ "weekly" ];
        persistent = true;
        randomizedDelaySec = "30min";
      };

      settings = {
        allowed-users = [ "@wheel" ];
        connect-timeout = 5;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        min-free = 128000000; # 128MB
        max-free = 1000000000; # 1GB
        use-xdg-base-directories = true;
        warn-dirty = false;
      };
    };

    nixpkgs.hostPlatform = cfg.base.hostPlatform;
    security.sudo.execWheelOnly = true;
    system.stateVersion = cfg.base.stateVersion;
    time.timeZone = "Europe/London";
  };

  config.flake.modules.homeManager.base =
    { config, ... }:
    {
      home = {
        homeDirectory = "/home/${config.home.username}";
        preferXdgDirectories = true;
        sessionVariables.GNUPGHOME = "${config.xdg.dataHome}/gnupg";
        shell.enableShellIntegration = true;
        stateVersion = cfg.base.stateVersion;
      };

      programs = {
        bash = {
          enable = true;
          historyControl = [ "ignoredups" ];
          historyFile = "${config.xdg.stateHome}/bash/history";
          historyIgnore = [
            "ls"
            "cd"
            "exit"
          ];
          shellAliases = {
            cp = "cp -riv";
            ls = "ls -p --color=auto --group-directories-firs";
            mkdir = "mkdir -vp";
            mv = "mv -iv";
            rm = "rm -iv";
          };
        };

        direnv = {
          enable = true;
          nix-direnv.enable = true;
          silent = true;
        };

        home-manager.enable = true;

        nh = {
          enable = true;
          flake = "${config.home.homeDirectory}/dotfiles/nix";
        };
      };

      xdg = {
        enable = true;
        userDirs = {
          enable = true;
          createDirectories = true;
          desktop = lib.mkDefault null;
          documents = "${config.home.homeDirectory}/documents";
          download = "${config.home.homeDirectory}/downloads";
          music = lib.mkDefault null;
          pictures = lib.mkDefault null;
          publicShare = lib.mkDefault null;
          templates = lib.mkDefault null;
          videos = lib.mkDefault null;
        };
      };
    };
}
