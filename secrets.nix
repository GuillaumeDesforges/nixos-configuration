{ flake-inputs, ... }:

{
  imports = [
    flake-inputs.agenix.nixosModules.default
  ];

  age.identityPaths = [
    "/home/gdforj/.ssh/id_ed25519"
  ];

  age.secrets = {
    # secret.file = ./secrets/secret.age;
    # secret.mode = "0644";
  };
}
