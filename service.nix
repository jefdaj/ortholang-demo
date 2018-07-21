{config, pkgs, lib, ...}:

# TODO clean up the pkgs, pkgs2 thing
# TODO don't kill all python processes when stopping

let
  cfg = config.services.shortcutDemo;
  pkgs2 = pkgs // {
    shortcut = import /home/jefdaj/shortcut;
    "shortcut-demo" = import /home/jefdaj/shortcut-demo;
  };

in

with lib;

{
  options = {
    services.shortcutDemo = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = ''
          Enable the ShortCut demo server
        '';
      };

      user = mkOption {
        default = "jefdaj";
        type = with types; uniq string;
        description = ''
          Name of the user.
        '';
      };

      logPath = mkOption {
        default = "/tmp/shortcut-demo.log";
        type = with types; uniq string;
        description = ''
          Where to write the server log.
        '';
      };

      dataDir = mkOption {
        default = "/mnt/data/data";
        type = with types; uniq string;
        description = ''
          Data files are copied from here to each user tmpdir.
        '';
      };

      commentsDir = mkOption {
        default = "/mnt/data/comments";
        type = with types; uniq string;
        description = ''
          Where to save user comments.
        '';
      };

      uploadsDir = mkOption {
        default = "/mnt/data/uploads";
        type = with types; uniq string;
        description = ''
          Where to save user-uploaded files.
        '';
      };

      scratchDir = mkOption {
        default = "/tmp/shortcut-demo";
        type = with types; uniq string;
        description = ''
          Where to save user tmpfiles. Ideally in RAM or at least on an SSD.
        '';
      };

      port = mkOption {
        default = 80;
        type = with types; int;
        description = ''
          Port to serve the website on.
        '';
      };

    };
  };

  config = mkIf cfg.enable {
    systemd.services."shortcut-demo" = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "ShortCut demo server";
      serviceConfig = {
        Type = "simple";
        User = "${cfg.user}";
        ExecStart = ''${pkgs2.shortcut-demo}/bin/shortcut-demo -l ${cfg.logPath} -d ${cfg.dataDir} -c ${cfg.commentsDir} -u ${cfg.uploadsDir} -s ${cfg.scratchDir} -p ${toString cfg.port}'';

        # TODO get more specific than python?
        ExecStop = "${pkgs2.procps}/bin/pkill -9 python";
      };
    };

    environment.systemPackages = [ pkgs2.shortcut pkgs2.procps ];
  };
}
