{ stdenv, fetchFromGitHub }:

# This runs the dircolors command on colors in the LS_COLORS repository, which
# allows the resulting file to be sourced only once.

stdenv.mkDerivation rec {
  name = "zsh-ls-colors";

  src = fetchFromGitHub {
    owner = "trapd00r";
    repo = "LS_COLORS";
    rev = "332d7a18696057e21f5acd9bb885acffbe798bd4";
    sha256 = "08mga3jg1f3zsspx0hlgywlabwq07qp5qk1lgjz8rawj62zmqqrf";
  };

  buildInputs = [];

  installPhase = ''
    mkdir -p $out/share/zsh-ls-colors
    dircolors -b LS_COLORS > $out/share/zsh-ls-colors/LS_COLORS.zsh
    '';

  meta = with stdenv.lib; {
    description = "LS_COLORS color package with dircolors run only once.";
    homepage = https://github.com/trapd00r/LS_COLORS;
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = [ "Ryan Orendorff" ];
  };
}
