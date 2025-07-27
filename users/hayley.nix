{ config, pkgs, ... }:
{
  users.users.hayley = {
    isNormalUser = true;
    description = "hayley";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  home-manager.users.hayley =
    { pkgs, ... }:
    {
      home.packages = [ ];
      home.stateVersion = "25.05";

      programs.git = {
        enable = true;
        userName = "TheCactusBlue";
        userEmail = "thecactusblue@gmail.com";
        extraConfig = {
          push.AutoSetupRemote = true;
        };
      };
    };
}
