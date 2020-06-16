  du-dust-0_4_1 = stable-pkgs.rustPlatform.buildRustPackage rec {
    pname = "dust";
    version = "0.4.1";

    src = stable-pkgs.fetchFromGitHub {
      owner = "bootandy";
      repo = "dust";
      rev = "v${version}";
      sha256 = "097b61h1clmik36q25qcg0cwacpym8197bah6qf2af32hjlzsirk";
    };

    cargoSha256 = "14qvggvhd8ix6q4l7zxw78mvy1zlb5k956cpg2ixjndasnnwa9m1";

    # doCheck = false;
    meta = with stdenv.lib; {
      description = "du + rust = dust. Like du but more intuitive";
      homepage = "https://github.com/bootandy/dust";
      license = licenses.asl20;
      platforms = platforms.all;
    };
  };