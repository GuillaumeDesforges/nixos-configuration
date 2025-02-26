{
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "exhaustruct";
  version = "3.3.1";
  src = fetchFromGitHub {
    owner = "GaijinEntertainment";
    repo = "go-exhaustruct";
    rev = "v${version}";
    sha256 = "sha256-VXmgdyu5LpDRwtOcB6dou6GYHEEKlFffRtY3O8Bxqjg=";
  };
  vendorHash = "sha256-4jNEggnEe7VyYrA5MqW21XHkB00pp3DhuzZ0BTDgn34=";
}
