final: prev: {
  code-cursor = final.callPackage ./packages/code-cursor {
    # this is how it's done in nixpkgs
    # https://github.com/nixos/nixpkgs/blob/dbd5479105811b0847dd50fb28d859b2ccaac761/pkgs/top-level/all-packages.nix?plain=1#L12966
    vscode-generic = ./packages/vscode/generic.nix;
  };

  dbeaver-bin = prev.dbeaver-bin.override { override_xmx = "4096m"; };

  exhaustruct = final.callPackage ./packages/exhaustruct { };

  hcp = final.callPackage ./packages/hcp { };
}
