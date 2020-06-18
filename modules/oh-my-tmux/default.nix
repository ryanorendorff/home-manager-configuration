# We are not using `programs.tmux` because it contains some other initial
# settings that we are not looking to use.
{ lib, pkgs, config, ... }:

with lib;

let
  cfg = config.programs.oh-my-tmux;

  oh-my-tmux-source = pkgs.callPackage ./oh-my-tmux-souce.nix { };

in {
  meta.maintainers = [ maintainers.ryanorendorff ];

  options = {
    programs.oh-my-tmux = {
      enable = mkEnableOption
        "Oh My Tmux! Pretty & versatile tmux configuration / customization made with love";

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
    home.file.".tmux.conf".source = oh-my-tmux-source + "/.tmux.conf";
    home.file.".tmux.conf.local".source = cfg.configFile;
  };
}

