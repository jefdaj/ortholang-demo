{config, pkgs, lib, ...}:
with lib;

# TODO clean up the pkgs, pkgs2 thing
# TODO don't kill all python processes when stopping

let
  cfg = config.services.ortholangDemo;
  pkgs2 = pkgs // {
    # adjust these to your system:
    ortholang = import ./ortholang;
    "ortholang-demo" = import ./default.nix;
  };

in {
  options = {
    services.ortholangDemo = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = ''
          Enable the OrthoLang demo server
        '';
      };

      user = mkOption {
        default = "jefdaj";
        type = with types; uniq string;
        description = ''
          Name of the user.
        '';
      };

      authPath = mkOption {
        default = "/tmp/ortholang-users.txt"; # TODO where should this go by default?
        type = with types; uniq string;
        description = ''
          Path to the auth file (tab-separated usernames and passwords)
        '';
      };

      logPath = mkOption {
        default = "/tmp/ortholang-demo.log";
        type = with types; uniq string;
        description = ''
          Where to write the server log.
        '';
      };

      # TODO does this actually work?
      examplesDir = mkOption {
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

      tmpDir = mkOption {
        default = "/tmp/ortholang-demo";
        type = with types; uniq string;
        description = ''
          Where to save user tmpfiles. Ideally in RAM or at least on an SSD.
        '';
      };

      usersDir = mkOption {
        default = "/mnt/data/users";
        type = with types; uniq string;
        description = ''
          Where to save persistent user files. Probably on your big data drive.
        '';
      };

      # TODO make an entirely different program for this?
      sharedDir = mkOption {
        default = "/mnt/data/shared";
        type = with types; uniq string;
        description = ''
          Where to serve cached tmpfiles on the web from.
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
    systemd.services."ortholang-demo" = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "OrthoLang demo server";
      serviceConfig = {
        Type = "simple";
        User = "${cfg.user}";
        ExecStart = ''
          ${pkgs2.ortholang-demo}/bin/ortholang-demo \
            -l ${cfg.logPath} \
            -e ${cfg.examplesDir} \
            -c ${cfg.commentsDir} \
            -t ${cfg.tmpDir} \
            -p ${toString cfg.port} \
            -a ${cfg.authPath} \
            -u ${cfg.usersDir} \
            -s ${cfg.sharedDir}
        '';
        # TODO get more specific than python?
        ExecStop = "${pkgs2.procps}/bin/pkill -9 python";
      };
    };

    environment.systemPackages = [ pkgs2.ortholang pkgs2.procps ];
  };
}
