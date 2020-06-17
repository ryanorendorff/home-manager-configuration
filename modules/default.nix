{ pkgs, lib, ... }:

with lib;

let

  hostPlatform = pkgs.stdenv.hostPlatform;

  loadModule = file: { condition ? true }: { inherit file condition; };

  allModules = [ (loadModule ./agda { }) ];

  modules = map (getAttr "file") (filter (getAttr "condition") allModules);
in { imports = modules; }
