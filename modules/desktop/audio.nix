{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption mkIf types;
  cfg = config.gdforj.desktop.audio;
in
{
  options.gdforj.desktop.audio.enable = mkOption {
    type = types.bool;
    default = config.gdforj.desktop.enable;
    description = "Enable PipeWire audio (with ALSA, PulseAudio, and JACK shims).";
  };

  config = mkIf cfg.enable {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
}
