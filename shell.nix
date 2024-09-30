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
      setspace;
  });

  buildInputs = [ tex pkgs.gnumake ];

  bashrc = pkgs.stdenvNoCC.mkDerivation {
    name = "bashrc.sh";
    dontUnpack = "true";
    inherit buildInputs;

    builder = builtins.toFile "builder.sh" ''
      source $stdenv/setup
      eval $shellHook

      {
        echo "#!$SHELL"
        for var in PATH SHELL
        do echo "declare -x $var=\"''${!var}\""
        done
        echo "declare -x PS1='\n\[\033[1;32m\][nix-shell:\w]\$\[\033[0m\] '"
      } > "$out"

    '';
  };

in

  pkgs.stdenvNoCC.mkDerivation {
    name = "shell";
    dontUnpack = "true";
    inherit buildInputs;
    inherit bashrc;

    builder = builtins.toFile "builder.sh" ''
      source $stdenv/setup
      eval $shellHook
      echo "exec \"$SHELL\" --rcfile $bashrc --noprofile \"\$@\"" > $out
      chmod a+x $out
    '';
  }
