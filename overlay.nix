final: prev: {
  dbeaver-bin = prev.dbeaver-bin.override { override_xmx = "4096m"; };

  exhaustruct = final.callPackage ./packages/exhaustruct { };
}
