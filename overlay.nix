final: prev: {
  code-cursor = final.callPackage ./packages/code-cursor { };

  dbeaver-bin = prev.dbeaver-bin.override { override_xmx = "4096m"; };

  exhaustruct = final.callPackage ./packages/exhaustruct { };

  hcp = final.callPackage ./packages/hcp { };

  sqlc = prev.sqlc.overrideAttrs (old: {
    version = "1.28.0";
    src = final.fetchFromGitHub {
      owner = "sqlc-dev";
      repo = "sqlc";
      rev = "v1.28.0";
      hash = "sha256-kACZusfwEIO78OooNGMXCXQO5iPYddmsHCsbJ3wkRQs=";
    };
    vendorHash = "sha256-5KVCG92aWVx2J78whEwhEhqsRNlw4xSdIPbSqYM+1QI=";
  });
}
