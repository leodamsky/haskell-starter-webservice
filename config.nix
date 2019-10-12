rec {
  # Which version of GHC does the project need to be built with? This must exist in both nixpkgs, and hie-nix
  ghcVersion = "ghc865";
  # Bootstrap the ability to fetch from GitHub
  fetchFromGitHub = (import <nixpkgs> {}).fetchFromGitHub;

  # The set of haskellPackages we are working with. This lists packages that can be built with our specified
  #  version of GHC
  hpkgs = nixpkgs.haskell.packages.${ghcVersion};

  # Build up a nix expression for this project from the cabal file
  drv = nixpkgs.haskellPackages.callCabal2nix "haskell-starter-webservice" ./. {};

  # Repositories and commits that will be used in this build. Using specific commits and hashes increases
  #  the reproducibility and cacheability of builds.
  # In order to retrieve the hashes for these repos run
  #  nix-prefetch-url --unpack https://github.com/$OWNER/$REPO/archive/$REV.tar.gz
  repos = {
    # A specific commit of the nixpkgs repository we wish to build from, for maximum repeatability
    nixpkgs = {
      owner = "NixOs";
      repo = "nixpkgs";
      rev = "8b57a75";
      sha256 = "195cmpf2hch1aij4qib32r6gc8vw23hrhpjfj68w2kdqpzw7hi41";
    };

    all-hies = {
      owner = "Infinisil";
      repo = "all-hies";
      rev = "0cba12c";
      sha256 = "1f91nrksr2x0zi2kbsy6qf4fmb1ybpx9p55rijhhs05rssk4b0nq";
    };
  };

  # Our custom copy of nixpkgs, with our project's package injected in to the set of haskellPackages
  nixpkgs = import (fetchFromGitHub repos.nixpkgs) {
    config = {
      # allowUnfree = true;
      packageOverrides = pkgs: rec {
        haskellPackages = hpkgs.override {
          overrides = super: self: {
            haskell-starter-webservice = drv;
          };
        };
      };
    };
  };

  # Pick a version of HIE that is compatible with our version of GHC.
  hie = (import (fetchFromGitHub repos.all-hies) { }).versions.${ghcVersion};
}
