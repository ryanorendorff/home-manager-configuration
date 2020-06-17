{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.agda;

in {
  meta.maintainers = [ maintainers.ryanorendorff ];

  options = {
    programs.agda = {
      enable = mkEnableOption "Agda";

      package = mkOption {
        type = types.package;
        default = pkgs.agda;
        defaultText = literalExample "pkgs.agda";
        example = literalExample "pkgs.agda";
        description = "The Agda package to use.";
      };

      extraPackages = mkOption {
        default = pkgs: [ ];
        type = hm.types.selectorFunction;
        defaultText = "pkgs: []";
        example = literalExample "pkgs: [ pkgs.standard-library ]";
        description = ''
          Extra packages available to Agda.
        '';
      };

      finalPackage = mkOption {
        type = types.package;
        visible = false;
        readOnly = true;
        description = ''
          The Agda package including any extra packages.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.finalPackage ];
    programs.agda.finalPackage = cfg.package.withPackages cfg.extraPackages;
  };
}
