{ inputs = { 
    nixkpgs.url = github:Nixos/nixpkgs/release-24.05;
    utils.url = github:numtide/flake-utils;
  }; 

outputs = {nixpkgs, utils, ...}: 
  utils.lib.eachDefaultSystem (system: 
      let 
          config = { };
 
          overlay = pkgsNew: pkgsOld : {
            timeThingy = 
                pkgsNew.haskell.lib.justStaticExecutables
                    pkgsNew.haskellPackages.timeThingy;
            haskellPackages = pkgsOld.haskellPackages.override (old : {
          overrides = pkgsNew.haskell.lib.packageSourceOverrides {
               timeThingy = ./.;
         }; 
       }); 
     }; 
     
     pkgs = import nixpkgs { inherit config system; overlays = [ overlay ]; }; 
          in 
           rec {
               packages.default = pkgs.haskellPackages.timeThingy;
               apps.default = { 
                  type = "app";
                  program = "${pkgs.timeThingy}/bin/timeThingy";
                };
               devShells.default = pkgs.haskellPackages.timeThingy.env;
        }
     );   
}
