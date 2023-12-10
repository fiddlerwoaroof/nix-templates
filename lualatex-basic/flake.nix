{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      texpkgs = pkgs.texlive.combine {
        inherit
          (pkgs.texlive)
          alegreya
          csquotes
          fontspec
          geometry
          hyperref
          latexmk
          luahbtex
          lualibs
          luatex
          luatexbase
          memoir
          microtype
          polyglossia
          scheme-basic
          sourcecodepro
          # add additional tex packages here
          
          ;
      };
      writeZsh = pkgs.writers.makeScriptWriter {interpreter = "${pkgs.zsh}/bin/zsh";};
    in {
      packages.default = pkgs.stdenv.mkDerivation {
        name = "latex-build";
        version = "0.0.0";
        buildInputs = [
          texpkgs
        ];
        src = ./.;

        ## For custom fonts, make a fonts directory and add a line like this to
        ## the buildPhase for luatex:
        # export OSFONTDIR="${./fonts}"
        #
        ## For xetex, make fc_config directory containing a fonts.conf like,
        ## then put fonts in fc_config/fonts:
        # <?xml version="1.0"?>
        # <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
        # <fontconfig>
        #   <dir prefix="relative">fonts</dir>
        # </fontconfig>
        #
        ## Then add this line:
        # export FONTCONFIG_PATH="${./fc_config}"

        buildPhase = ''
          export TEXMFHOME="$(mktemp -d)"
          export TEXMFVAR="$TEXMFHOME/texmf-var/"

          mkdir -p $out;
          mkdir -p "$TEXMFVAR"
          latexmk -lualatex main.tex;
          cp main.pdf $out
        '';
      };
      devShells.default = pkgs.mkShell {
        buildInputs = [texpkgs pkgs.pandoc pkgs.poppler_utils];
      };
    });
}
