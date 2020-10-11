{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.thefuck;

in {
  meta.maintainers = [ maintainers.ryanorendorff ];

  options = {
    programs.thefuck = {
      enable = mkEnableOption "Enable The Fuck for bash, zsh, and fish";

      package = mkOption {
        type = types.package;
        default = pkgs.thefuck;
        defaultText = literalExample "pkgs.thefuck";
        example = literalExample "pkgs.thefuck";
        description = "The 'thefuck' package to use.";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
    programs.fish.interactiveShellInit = ''
      ${cfg.package}/bin/thefuck --alias | source
    '';
    programs.bash.initExtra = ''
      eval "$(${cfg.package}/bin/thefuck --alias)"
    '';
    programs.zsh.initExtra = ''
      eval "$(${cfg.package}/bin/thefuck --alias)"
    '';
  };
}
