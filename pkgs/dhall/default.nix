# TODO: Generalize between Mac and Linux
let
  dhall-version = "1.32.0";
in
{
  dhall = fetchTarball {
    url =
      "https://github.com/dhall-lang/dhall-haskell/releases/download/${dhall-version}/dhall-${dhall-version}-x86_64-linux.tar.bz2";
    sha256 = "11syan5l53lvg98hj9nfjn4anm05klqsw83gb75jmcz8h8948vy3";
  };
  dhall-json = fetchTarball {
    url =
      "https://github.com/dhall-lang/dhall-haskell/releases/download/${dhall-version}/dhall-json-1.6.4-x86_64-linux.tar.bz2";
    sha256 = "1i771lpn41917kchk1mnjq3086v5g9xzd0dngs3i6w6zjamsc2lc";
  };
  dhall-lsp-server = fetchTarball {
    url =
      "https://github.com/dhall-lang/dhall-haskell/releases/download/${dhall-version}/dhall-lsp-server-1.0.7-x86_64-linux.tar.bz2";
    sha256 = "1z6zs9py5vnspx04sm8w2ngjnvjmknxbra85nn8vsbpxxc38x7v7";
  };
  dhall-yaml = fetchTarball {
    url =
      "https://github.com/dhall-lang/dhall-haskell/releases/download/${dhall-version}/dhall-yaml-1.1.0-x86_64-linux.tar.bz2";
    sha256 = "10gd0rpvvvm8wjn1s1ld1kwr6lis96y4zq28vl1dvbwbixaxy90h";
  };
}
