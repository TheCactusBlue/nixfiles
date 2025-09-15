{ config, pkgs, ... }:
{
  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "acpi_enforce_resources=lax" ]; # required for RAM LED control
}
