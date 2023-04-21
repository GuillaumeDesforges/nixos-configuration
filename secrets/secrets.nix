let
  publicKeys."master" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZzTVA8EBtDrK/C0dSoeZjiX7kkhck6WMTppIrj8P0k master";
  publicKeys."gdforj@kaguya" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINfSqVV8RgSYS9Qk2uPMfHV3vVBWcO4ibRCdz7/VYYNY gdforj@kaguya";
  publicKeys."gdforj@tosaka" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILpWIEjSz5n880i2Q/cQXAsqPqc6x7i6G69Nz/FuMW+L gdforj@tosaka";

  publicKeys.all = [
    publicKeys."master"
    publicKeys."gdforj@kaguya"
    publicKeys."gdforj@tosaka"
  ];
in
{
  "openai_key.age".publicKeys = publicKeys.all;
}

