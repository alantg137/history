let
  pkgs = (import <nixpkgs> {});

  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-medium
      wrapfig amsmath ulem hyperref capt-of
      setspace;
  });

in

  pkgs.stdenvNoCC.mkDerivation {
    name = "shell";
    buildInputs = [
      tex pkgs.gnumake
    ];
  }
