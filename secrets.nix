{ flake-inputs, ... }:

{
  imports = [
    flake-inputs.agenix.nixosModules.default
  ];

  age.identityPaths = [
    "/home/gdforj/.ssh/id_ed25519"
  ];

  age.secrets = {
    openai_key.file = ./secrets/openai_key.age;
    openai_key.mode = "0644";
  };
}
