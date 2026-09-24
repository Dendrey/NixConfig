{ config, pkgs, ... }:

{
  home.username = "dendrey";
  home.homeDirectory = "/home/dendrey";

  # Пакеты пользователя
  home.packages = with pkgs; [
    # Терминал и GUI
    kitty
    firefox
    obsidian
    mpv
    pavucontrol
    
    # Файлы, монтирование, корзина
    yazi
    trash-cli      # Корзина для консоли и Yazi
    udiskie         # Трей-демон для автоматического монтирования фleшек
    
    # CLI утилиты
    eza
    zoxide
    bat
    fd
    ripgrep
    dust
    procs
    fzf
    starship
    tldr           # Шпаргалка по командам (tldr <команда>)
    
    # Wayland утилиты
    rofi   # Апплаунчер вместо wofi
    waybar
    hyprshot
    hyprpicker
    hyprlock
    hyprpaper
    wl-clipboard   # Буфер обмена
    cliphist       # История буфера обмена
    
    # VPN и Сеть
    networkmanagerapplet
  ];

  # Центр уведомлений SwayNC
  services.swaync = {
    enable = true;
  };

  # Автозапуск демона монтирования флешек
  services.udiskie = {
    enable = true;
    tray = "always";
  };

  # Настройка Git
  programs.git = {
    enable = true;
    userName = "Dendrey";
    userEmail = "andrievich.dd@phystech.edu";
  };


  # Полоса каталогов XDG
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = null;
    documents = "$HOME/Documents";
    download = "$HOME/Downloads";
    music = "$HOME/Music";
    pictures = "$HOME/Pictures";
    videos = "$HOME/Videos";
    templates = null;
    publicShare = null;
  };

  # Подключение пользовательских dotfiles
  xdg.configFile = {
    "hypr".source = ./dotfiles/hypr;
    "kitty".source = ./dotfiles/kitty;
    "fish/config.fish".source = ./dotfiles/fish/config.fish;
    "waybar".source = ./dotfiles/waybar;
    "yazi".source = ./dotfiles/yazi;
    "starship.toml".source = ./dotfiles/starship.toml;
  };

  home.stateVersion = "25.05";
}
