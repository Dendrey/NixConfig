{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./hyprland.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  networking.hostName = "DendreyNixLaptop";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Novosibirsk";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  users.users.dendrey = {
    isNormalUser = true;
    description = "Dendrey";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  environment.systemPackages = with pkgs; [
    wget curl git kitty xed-editor waybar firefox
    udisks2 ntfs3g dosfstools exfat e2fsprogs
    micro wl-clipboard cliphist playerctl libnotify
    brightnessctl jq lazygit ffmpeg imagemagick usbutils
    mpv fzf cava quickshell cassette
  ];

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

  services.udisks2.enable = true;
  services.xserver.enable = true;
  services.displayManager.ly.enable = true;

  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings = {
      General = { Experimental = true; FastConnectable = false; };
      Policy = { AutoEnable = true; };
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.extraConfig.bluetoothEnhancements = {
      "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-msbc" = true;
        "bluez5.enable-hw-volume" = true;
        "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
      };
    };
  };

  services.hypridle.enable = true;
  programs.amnezia-vpn.enable = true;

  system.stateVersion = "25.05";
}
