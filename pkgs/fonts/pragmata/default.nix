{ stdenv }:

let
  version = "0.828";
in stdenv.mkDerivation rec {
  name = "pragmata-pro-${version}";
  src = ./pragmata.tar.gz;
  # sha256 = "0000000000000000000000000000000000000000000000000000000000000000";

  phases = "installPhase";

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    tar -zxf $src -C $out/share/fonts/truetype --strip 1
  '';


  meta = with stdenv.lib; {
    homepage = https://www.fsd.it/shop/fonts/pragmatapro/;
    description = "Condensed monospaced font with ligatures";
    longDescription = ''
      PragmataPro is a condensed monospaced font optimized for screen, designed
      by Fabrizio Schiavi to be the ideal font for coding, math and engineering.
    '';
    license = licenses.nonfree;
    maintainers = [ "Ryan Orendorff" ];
    platforms = platforms.all;
  };
}
