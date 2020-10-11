{ pkgs, lib, ... }:

with lib;

let

  hostPlatform = pkgs.stdenv.hostPlatform;

  loadModule = file: { condition ? true }: { inherit file condition; };

  allModules = [ (loadModule ./agda { }) (loadModule ./thefuck { }) (loadModule ./oh-my-tmux { }) ];

  modules = map (getAttr "file") (filter (getAttr "condition") allModules);
in { imports = modules; }
