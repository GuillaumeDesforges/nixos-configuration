let
  publicKeys."master" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZzTVA8EBtDrK/C0dSoeZjiX7kkhck6WMTppIrj8P0k master";
  publicKeys."gdforj@kaguya" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINfSqVV8RgSYS9Qk2uPMfHV3vVBWcO4ibRCdz7/VYYNY gdforj@kaguya";
  publicKeys."gdforj@tosaka" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILpWIEjSz5n880i2Q/cQXAsqPqc6x7i6G69Nz/FuMW+L gdforj@tosaka";
  publicKeys."gdforj@yor" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPNJB2omkFdvoeFpickvlGP38z97z1P6dd76hatz1irL gdforj@yor";

  publicKeys.all = [
    publicKeys."master"
    publicKeys."gdforj@kaguya"
    publicKeys."gdforj@tosaka"
    publicKeys."gdforj@yor"
  ];
in
{
  "openai_key.age".publicKeys = publicKeys.all;
}

