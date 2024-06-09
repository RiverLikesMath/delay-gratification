{ inputs = { 
    nixkpgs.url = github:Nixos/nixpkgs/release-24.05;
    utils.url = github:numtide/flake-utils;
  }; 

outputs = {nixpkgs, utils, ...}: 
  utils.lib.eachDefaultSystem (system: 
      let 
          config = { };
 
          overlay = pkgsNew: pkgsOld : {
            delay-gratification =
                pkgsNew.haskell.lib.justStaticExecutables
                    pkgsNew.haskellPackages.delay-gratification;
            haskellPackages = pkgsOld.haskellPackages.override (old : {
          overrides = pkgsNew.haskell.lib.packageSourceOverrides {
               delay-gratification = ./.;
         }; 
       }); 
     };
     
     pkgs = import nixpkgs { inherit config system; overlays = [ overlay ]; }; 
          in 
           rec {
               packages.default = pkgs.haskellPackages.delay-gratification;
               apps.default = { 
                  type = "app";
                  program = "${pkgs.delay-gratification}/bin/delay-gratification";
                };
               devShells.default = pkgs.haskellPackages.delay-gratification.env;
        }
     );   
}
