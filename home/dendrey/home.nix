
{ config, pkgs, ... }:

{
  # TODO please change the username & home directory to your own
  home.username = "dendrey";
  home.homeDirectory = "/home/dendrey";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    neofetch amnezia-vpn yazi zip xz unzip p7zip btop
    hyprshot hyprpicker hyprlock hyprpaper mako
    pavucontrol networkmanagerapplet wofi eww obsidian

    starship        # красивый prompt
    zoxide          # "умная" навигация по директориям
    eza             # улучшенный ls
    bat             # cat с подсветкой синтаксиса
    fd              # быстрый поиск файлов
    ripgrep         # поиск текста внутри файлов
    dust            # визуальный du (анализ занятого места)
    procs           # визуальный ps (просмотр процессов)
    fzf             # fuzzy finder для истории и файлов

    # --- Git утилиты (закомментированы) ---
    # delta     # улучшенный просмотр diff и log (цвета, подсветка)
    # lazygit   # TUI-интерфейс для git (удобная визуализация)
    # ghq       # организация локальных git-репозиториев
  ];

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = null;           # Не создавать Desktop
    documents = "$HOME/Documents"; # Своё имя
    download = "$HOME/Downloads";
    music = "$HOME/Music";
    pictures = "$HOME/Pictures";
    videos = "$HOME/Videos";
    templates = null;
    publicShare = null;
    
  };


  # Копирование dotfiles (из ~/.dotfiles/dotfiles)
    xdg.configFile={
    	"hypr"={
    		source = ../../dotfiles/config/hypr;
    		recursive = true;
    	};

    	"fish"={
    	    		source = ../../dotfiles/config/fish;
    	    		recursive = true;
    	    	};

		"fish/conf.d"={
    	    		source = ../../dotfiles/config/fish/conf.d;
    	    		recursive = true;
    	    	};
    	    	
	    "kitty"={
	        		source = ../../dotfiles/config/kitty;
	        		recursive = true;
	        	};

	    "mako"={
	        		source = ../../dotfiles/config/mako;
	        		recursive = true;
	        	};

	    "waybar"={
	        		source = ../../dotfiles/config/waybar;
	        		recursive = true;
	        	};
    };

    xdg.configFile."starship.toml".source = ../../dotfiles/config/starship.toml;



    programs.git = {
        enable = true;
        userName = "Dendrey";
        userEmail = "andrievich.dd@phystech.edu";
      };


  

  
  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";
}
