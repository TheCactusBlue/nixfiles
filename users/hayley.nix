{ config, pkgs, ... }:
{
  users.users.hayley = {
    isNormalUser = true;
    description = "hayley";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  home-manager.users.hayley =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        neofetch
        htop
        cmatrix
      ];
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
