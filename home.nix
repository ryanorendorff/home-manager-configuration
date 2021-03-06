{ config, pkgs, lib, options, modulesPath }:

let

  # Helper Functions #######################################################

  load-pkgs = x: import (pkgs.fetchFromGitHub x) { config.allowUnfree = true; };

  # Nixpkgs sources ########################################################

  # Rev nixos-20.09
  stable-pkgs = load-pkgs {
    owner = "nixos";
    repo = "nixpkgs";
    rev = "9da0758c1cd4724cf09fd48fee11413f88c48c8d";
    sha256 = "1n8wy4a5hfrx3fqxlxkwnganb5y1l450v36255jj58j7fkcys6ss";
  };

  unstable-pkgs = load-pkgs {
    owner = "nixos";
    repo = "nixpkgs";
    rev = "c476262dcd9109168c99f3de2e9e94504807c7c5";
    sha256 = "0b7s76176ckdgwrywpygzr8217qpx3arkw7xshnfc6d7cqrnhq48";
  };


  # Home Manager settings ##################################################

  hm-path = (import (fetchTarball {
    url =
      "https://github.com/nix-community/home-manager/archive/63f299b3347aea183fc5088e4d6c4a193b334a41.tar.gz";
    sha256 = "0iksjch94wfvyq0cgwv5wq52j0dc9cavm68wka3pahhdvjlxd3js";
  }) { pkgs = stable-pkgs; }).path;

in {

  imports = [ ./modules ];

  home.packages = with stable-pkgs; [
    ark
    bat
    binutils
    coreutils
    pkgs.dhall
    pkgs.dhall-json
    pkgs.dhall-lsp-server
    pkgs.dhall-yaml
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
    tig
    tilix
    tldr
    unzip
    virtualbox
    watchexec
    wget
    xclip
    zip
    zoom-us
  ];

  programs.agda = {
    enable = false;
    package = unstable-pkgs.agda;
    extraPackages = p: with p; [ standard-library ];
  };

  programs.thefuck.enable = true;

  programs.oh-my-tmux.enable = true;

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

      # From https://nixos.wiki/wiki/Fish#pythonEnv
      pythonEnv = {
        argumentNames = "pythonVersion";
        description = "start a nix-shell with the given python packages";
        body = ''
          if set -q argv[2]
            set argv $argv[2..-1]
          end

          for el in $argv
            set ppkgs $ppkgs "python"$pythonVersion"Packages.$el"
          end

          nix-shell -p $ppkgs
        '';
      };
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
      source ${pkgs.fish-ls-colors}/share/fish-ls-colors/LS_COLORS.fish

      set PAGER "less"
    '';
  };

  programs.starship = {
    enable = true;
    package = unstable-pkgs.starship;
    settings = {
      character = {
        success_symbol = "[Γ ⊢ ](bold green)";
        error_symbol = "[Γ ⊢ ](bold red)";
      };
    };
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
      source ${pkgs.zsh-ls-colors}/share/zsh-ls-colors/LS_COLORS.zsh
    '';

  };

  programs.irssi = if builtins.pathExists (./dotfiles/irssi-password) then {
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
  } else {
    enable = false;
  };

  programs.vim = { enable = true; };

  home.file = { ".ghc/ghci.conf".source = ./dotfiles/ghci.conf; };

  home.sessionVariables = {
    EDITOR = "vim";
    BROWSER = "firefox";
    TERMINAL = "tilix";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.home-manager.path = "${hm-path}";

  nixpkgs.overlays = [ (import ./pkgs) ];
}
