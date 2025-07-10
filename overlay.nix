final: prev: {
  code-cursor = final.callPackage ./packages/code-cursor { };

  dbeaver-bin = prev.dbeaver-bin.override { override_xmx = "4096m"; };

  exhaustruct = final.callPackage ./packages/exhaustruct { };

  hcp = final.callPackage ./packages/hcp { };
}
