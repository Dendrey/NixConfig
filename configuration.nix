{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    <home-manager/nixos>
  ];

  # Загрузчик systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Твики ядра для Intel Alder Lake (P+E ядра) и ThinkPad
  boot.kernelParams = [ "i915.enable_psr=1" ];

  # Сеть и имя хоста
  networking.hostName = "dendrey-thinkpad";
  networking.networkmanager.enable = true;

  # Часовой пояс и локаль
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

  # Оптимизация питания и аккумулятора (ThinkPad X1 Carbon)
  services.power-profiles-daemon.enable = true; # Идеально работает с процессорами Intel 12-го поколения
  services.thermald.enable = true;              # Защита от перегрева
  
  # Автомонтирование флешек и файловые системы
  services.udisks2.enable = true;
  boot.supportedFilesystems = [ "ntfs" "exfat" "fat32" "ext4" "btrfs" ];

  # Пользователь
  users.users.dendrey = {
    isNormalUser = true;
    description = "Dendrey";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
    shell = pkgs.fish;
  };

  # Оболочка Fish на системном уровне
  programs.fish.enable = true;

  # Поддержка Hyprland и XDG-порталов (для Drag-and-Drop и скриншотов)
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk ];
  };

  # Экранный вход (Display Manager)
  services.displayManager.ly.enable = true;

  # Звук (PipeWire)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  services.blueman.enable = true;
  
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
  };

  # Системные пакеты
  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    micro
    pciutils
    usbutils
    lm_sensors
    brightnessctl
    playerctl
  ];

  # Разрешить проприетарные пакеты (драйверы, Steam, Obsidian и т.д.)
  nixpkgs.config.allowUnfree = true;

  # Автоматическая очистка старых поколений и мусора Nix (раз в неделю)
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.settings.auto-optimise-store = true;

  # Настройка Home Manager как модуля NixOS
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.dendrey = import ./home.nix;
  };

  system.stateVersion = "26.05";
}
