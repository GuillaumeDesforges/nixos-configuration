let
  publicKeys."master" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZzTVA8EBtDrK/C0dSoeZjiX7kkhck6WMTppIrj8P0k master";
  publicKeys."gdforj@tosaka" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILpWIEjSz5n880i2Q/cQXAsqPqc6x7i6G69Nz/FuMW+L gdforj@tosaka";
  publicKeys."gdforj@yor" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKngeLj58rWo48nyJ5DvkL7OOCHhBusw6pUszEZf0RMV gdforj@yor";
  publicKeys."gdforj@kaguya" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINfSqVV8RgSYS9Qk2uPMfHV3vVBWcO4ibRCdz7/VYYNY gdforj@kaguya";
  publicKeys."gdforj@nazuna" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHDyPTyIwZ5eMWcqR6mzxyRDbWVbKPgX/9axX/qUt2Ti gdforj@nazuna";

  publicKeys.all = [
    publicKeys."master"
    publicKeys."gdforj@tosaka"
    publicKeys."gdforj@yor"
    publicKeys."gdforj@kaguya"
    publicKeys."gdforj@nazuna"
  ];
in
{
  "openai_key.age".publicKeys = publicKeys.all;
}

