rec {
  ghcVersion = "ghc844";
  nixpkgs = import (fetchTarball https://nixos.org/channels/nixos-18.09/nixexprs.tar.xz) {
    config = {
      packageOverrides = pkgs: rec {
        hPkgs = pkgs.haskell.packages.${ghcVersion};

        haskellPackages = hPkgs.override {
          overrides = super: self: {
            haskell-starter-webservice = self.callPackage ./haskell-starter-webservice.nix { };
          };
        };
      };
    };
  };
  hie = import (fetchTarball https://github.com/domenkozar/hie-nix/tarball/157d1bcde9d4fb87ec3b9fb23b69513fb3f62229) { };
}
