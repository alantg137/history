let
  # Change to this if you want to use your configured channel
  #  nixpkgs = <nixpkgs>;

  # Otherwise, use nixos-24.05 from 2024-09-29:
  nixpkgs = fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/fbca5e7.tar.gz";
    sha256 = "07wa6y7q4ql0x1jj08dignak2lra003inf2cxl4xxvyqdsspshp3";
  };

  pkgs = (import nixpkgs {});

  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-medium
      wrapfig amsmath ulem hyperref capt-of
      setspace
      stackengine tabstackengine xcolor;
  });

in
  pkgs.stdenvNoCC.mkDerivation {
    name = "shell";
    dontUnpack = "true";
    buildInputs = [ tex pkgs.gnumake ];

    # prevent nixpkgs from being garbage-collected
    inherit nixpkgs;

    builder = builtins.toFile "builder.sh" ''
      source $stdenv/setup
      eval $shellHook

      {
        echo "#!$SHELL"
        for var in PATH SHELL nixpkgs
        do echo "declare -x $var=\"''${!var}\""
        done
        echo "declare -x PS1='\n\033[1;32m[nix-shell:\w]\$\033[0m '"
        echo "exec \"$SHELL\" --norc --noprofile \"\$@\""
      } > "$out"

      chmod a+x "$out"
    '';
  }
