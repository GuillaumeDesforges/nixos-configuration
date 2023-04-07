let
  publicKeys."gdforj@kaguya" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINfSqVV8RgSYS9Qk2uPMfHV3vVBWcO4ibRCdz7/VYYNY gdforj@kaguya";

  publicKeys.all = [
    publicKeys."gdforj@kaguya"
  ];
in
{
  "openai_key.age".publicKeys = publicKeys.all;
}

