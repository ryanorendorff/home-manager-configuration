{ pkgs, stdenv }:

# Make a derivation because the `.` in the repo name confuses the unpacker
# used in fetchFromGitHub.
stdenv.mkDerivation {
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
}
