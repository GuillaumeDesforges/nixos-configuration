{
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation rec {
  pname = "hcp";
  version = "0.8.0";

  src = fetchurl {
    url = "https://releases.hashicorp.com/hcp/0.8.0/hcp_0.8.0_linux_amd64.zip";
    hash = "sha256-WwCGmQjCX/aCkbUcXTU4ZV6zG5J8cds3uqe4lEHpn3g=";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    ${unzip}/bin/unzip $src -d $out/bin
  '';
}
