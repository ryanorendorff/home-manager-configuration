# We are not using `programs.tmux` because it contains some other initial
# settings that we are not looking to use.
{ lib, pkgs, config, ... }:

with lib;

let
  cfg = config.programs.oh-my-tmux;

  mkDerivation = pkgs.stdenv.mkDerivation;

  # Make a derivation because the `.` in the repo name confuses the unpacker
  # used in fetchFromGitHub.
  oh-my-tmux = mkDerivation {
    name = "oh-my-tmux";
    src = builtins.fetchTarball {
      url =
        "https://github.com/gpakosz/.tmux/archive/d6f0f647dd68561ed010f83d8d226383aebfb805.tar.gz";
      sha256 = "1jbfjwajnyb8j886fmjbf57qfnj9swv0prj3lfdd61zv8hikn5li";
    };

    phases = [ "unpackPhase" "installPhase" ];

    installPhase = ''
      mkdir $out

      # Copy all invisible files as well, specifically .tmux.conf and
      # .tmux.conf.local.
      cp -r ./ $out
    '';
  };

in {
  meta.maintainers = [ maintainers.ryanorendorff ];

  options = {
    programs.oh-my-tmux = {
      enable = mkEnableOption "Oh My Tmux! Pretty & versatile tmux configuration / customization made with love";

      configFile = mkOption {
        type = types.path;
        default = ./tmux.conf.local;
        example = ./path/to/tmux.conf.local;
        description = "Local oh-my-tmux configuration";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.tmux ];
    home.file.".tmux.conf".source = oh-my-tmux + "/.tmux.conf";
    home.file.".tmux.conf.local".source = cfg.configFile;
  };
}

