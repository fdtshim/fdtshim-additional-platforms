let
  pins = import ./npins;
in

{ pkgs ? import pins.nixpkgs {} }:

pkgs.callPackage (

{ mkShell
, dtc
, npins
, callPackage
}:

let
  fdtshim-mapping-generator = callPackage (pins.fdtshim-mapping-generator + "/package.nix") {};
in

mkShell {
  nativeBuildInputs = [
    dtc
    fdtshim-mapping-generator

    # Development helpers
    npins
  ];
}

) {}
