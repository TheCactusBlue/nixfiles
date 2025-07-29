{ config, pkgs, ... }:
{
  users.users.hayley = {
    isNormalUser = true;
    description = "hayley";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
  };

  home-manager.users.hayley =
    { pkgs, ... }:
    {
      nixpkgs.config.allowUnfree = true;
      home.packages = with pkgs; [
        neofetch
        htop
        cmatrix
        cbonsai
        cava
        zenith-nvidia
        hyfetch
        cointop
        pciutils
        discord
        pinta
      ];
      home.stateVersion = "25.05";

      programs.git = {
        enable = true;
        userName = "TheCactusBlue";
        userEmail = "thecactusblue@gmail.com";
        extraConfig = {
          push.AutoSetupRemote = true;
          init.defaultBranch = "main";
        };
      };
    };
}
