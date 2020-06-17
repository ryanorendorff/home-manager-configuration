{ config, pkgs, lib, options, modulesPath }:

let

  # Helper Functions ##########################################################

  load-pkgs = x: import (pkgs.fetchFromGitHub x) { config.allowUnfree = true; };

  # Nixpkgs sources ########################################################

  # Rev nixos-20.03
  stable-pkgs = load-pkgs {
    owner = "nixos";
    repo = "nixpkgs-channels";
    rev = "82b5f87fcc710a99c47c5ffe441589807a8202af";
    sha256 = "0wz07gzapdj95h9gf0rdc2ywgd7fnaivnf4vhwyh5gx24dblg7q8";
  };

  unstable-pkgs = load-pkgs {
    owner = "nixos";
    repo = "nixpkgs";
    rev = "72faa59a1575e78a359254d8eac8d8ddf1b78366";
    sha256 = "1fxszxpqaws61iys56kqpmxmaw7xmj2d7lwprklydvbgys7ywm06";
  };

  # Home Manager settings ##################################################

  hm-path = (import (fetchTarball {
    url =
      "https://github.com/rycee/home-manager/archive/bf7297d55cb0edc1917cbb2c46be27dcd230db43.tar.gz";
    sha256 = "13wb7q9c7v2zz5cz3x09ixmlzj8zimmn4qm64npr1vgszi2zlal4";
  }) { pkgs = stable-pkgs; }).path;

  # Packages ###############################################################

  dhall-version = "1.32.0";
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

  zsh-ls-colors = pkgs.callPackage ./pkgs/shells/zsh/zsh-ls-colors { };

  fish-ls-colors = pkgs.callPackage ./pkgs/shells/fish/fish-ls-colors { };

in {

  imports = [ ./modules ];

  home.packages = with stable-pkgs; [
    ark
    bat
    binutils
    coreutils
    dhall
    dhall-json
    dhall-lsp-server
    dhall-yaml
    discord
    du-dust
    exa
    fasd
    fd
    firefox
    gimp
    hexyl
    htop
    inkscape
    ispell
    kdeApplications.spectacle
    lsd
    mosh
    neofetch
    unstable-pkgs.niv
    unstable-pkgs.nixfmt
    nix-index
    nix-prefetch-git
    nix-prefetch-github
    okular
    pandoc
    ripgrep
    shellcheck
    slack
    thefuck
    tig
    tilix
    tldr
    tmux
    unzip
    virtualbox
    wget
    xclip
    zip
    zoom-us
  ];

  programs.agda = {
    enable = true;
    package = unstable-pkgs.agda;
    extraPackages = p: with p; [ standard-library ];
  };

  programs.direnv = {
    enable = true;
    enableNixDirenvIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Ryan Orendorff";
    userEmail = "12442942+ryanorendorff@users.noreply.github.com";
  };

  programs.emacs.enable = true;
  services.emacs.enable = true;

  # programs.lsd.enable = true;

  programs.fish = {
    enable = true;

    functions = {
      # Emacs GUI launch and disown.
      eg = "emacs --create-frame $argv & disown";
      ecg = "emacsclient --create-frame $argv & disown";

      # Make gitignore files easily.
      gitignore = "curl -sL https://www.gitignore.io/api/$argv";
    };

    shellAbbrs = {
      # Nix abbreviations
      nr = ''nix repl "<nixpkgs>"'';

      # Emacs abbreviations
      e = "emacs";
      ec = "emacsclient -nw";
    };

    shellAliases = { };

    plugins = [
      {
        name = "bang-bang";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-bang-bang";
          rev = "4ac4ddee91d593f7a5ffb50de60ebd85566f5a15";
          sha256 = "05j9dmaw4k4dqb78jjkwb262c0xwgghfm5zkczskrvw99fmsj94x";
        };
      }

      {
        name = "fish-colored-man";
        src = pkgs.fetchFromGitHub {
          owner = "decors";
          repo = "fish-colored-man";
          rev = "c1e9db7765c932587b795d6c8965e9cff2fd849a";
          sha256 = "16ar220pz8lmv58c8fj81mi7slk0qb20dh5zdwcyyw12dgzahsvr";
        };
      }

      # {
      #   name = "emacs";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "oh-my-fish";
      #     repo = "plugin-emacs";
      #     rev = "21297223af8d567387527daa050f426a9bf6265d";
      #     sha256 = "05jg2lvyixb68c3qy6zjny0ai78gv0dpdym9r8j4jv5qvq9a1jfr";
      #   };
      # }

      {
        name = "fasd";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-fasd";
          rev = "38a5b6b6011106092009549e52249c6d6f501fba";
          sha256 = "06v37hqy5yrv5a6ssd1p3cjd9y3hnp19d3ab7dag56fs1qmgyhbs";
        };
      }

      {
        name = "git";
        src = pkgs.fetchFromGitHub {
          owner = "jhillyerd";
          repo = "plugin-git";
          rev = "81751739c2ce400e80cfb0c24a4bda2b8d931203";
          sha256 = "1dh813841qsycz1c08imj2jz3byzc02qrq12dacs5fwf080r2n4a";
        };
      }

      # This does not work because it needs a patch to call the vi-mode-impl.py
      # function with an interpreter. Additionally seems to have a problem where
      # escape is overloaded to end the terminal.
      # {
      #   name = "vi-mode";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "oh-my-fish";
      #     repo = "plugin-vi-mode";
      #     rev = "dc38ec253eacb88242c296d2eeacfc3802d27210";
      #     sha256 = "130cqgv6f973j4ipbdk60adgf6h9kly2x3l1521idd5nmc7dy6qb";
      #   };
      # }

    ];

    interactiveShellInit = ''

      # Use keychain to handle ssh keys
      if status --is-interactive
        ${stable-pkgs.keychain}/bin/keychain --quiet --nogui --agents ssh id_rsa
      end

      begin
          set -l HOSTNAME (hostname)
          if test -f ~/.keychain/$HOSTNAME-fish
              source ~/.keychain/$HOSTNAME-fish
          end
      end

      # A fun and random greeting with every window!
      function fish_greeting
          ${stable-pkgs.fortune}/bin/fortune
      end

      # Set LS_COLORS by file type
      source ${fish-ls-colors}/share/fish-ls-colors/LS_COLORS.fish

      # Fish theme
      eval (${unstable-pkgs.starship}/bin/starship init fish)

      set PAGER "less"
    '';
  };

  programs.zsh = {
    enable = true;

    enableAutosuggestions = true;

    oh-my-zsh = {
      enable = true;

      plugins = [
        "colored-man-pages"
        "fasd"
        "git"
        "ssh-agent"
        "sudo"
        "vi-mode"
        "zsh-syntax-highlighting"
      ];

      theme = "ryan-nix";

    };

    plugins = [

      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "972ad197c13d25f9b54a1c49405dc218a78781d6";
          sha256 = "0mypminffr0j8lckq2nw09bkq32fy457scx4nbrndaavgcvrf49s";
        };
      }

    ];

    shellAliases = { "open" = "xdg-open"; };

    initExtra = ''
      source ${zsh-ls-colors}/share/zsh-ls-colors/LS_COLORS.zsh
    '';

  };

  programs.irssi = {
    enable = true;
    networks = {
      freenode = {
        nick = "swerlk";
        autoCommands = [
          "/msg nickserv identify ${
            builtins.readFile ./dotfiles/irssi-password
          }; wait 2000"
        ];
        server = {
          address = "irc.freenode.net";
          port = 6697;
          autoConnect = true;
        };
        channels = { nixos.autoJoin = true; };
      };
    };
  };

  programs.vim = { enable = true; };

  home.file = {
    ".ghc/ghci.conf".source = ./dotfiles/ghci.conf;
  };

  home.sessionVariables = {
    EDITOR = "vim";
    BROWSER = "firefox";
    TERMINAL = "tilix";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.home-manager.path = "${hm-path}";
}
