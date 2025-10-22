#!/usr/bin/env bash
directory=/home/dendrey/Pictures/Wallpaper

if [ -d "$directory" ]; then
    random_background=$(ls $directory/*.jpg | shuf -n 1)
fi
# Path to your hyprpaper configuration file
hyprpaper_config_file="$HOME/.config/hypr/hyprpaper.conf"

# Update the config file with the new wallpaper path 
sed -i -e "s|^preload = .*$|preload = $random_background|" \
       -e "s|^wallpaper = .*$|wallpaper = ,$random_background|" \
       "$hyprpaper_config_file"

# Reload hyprpaper
killall -e hyprpaper
sleep 1; 
hyprpaper

# Let the user know it's done
echo "Wallpaper settings in hyprpaper.conf updated successfully."
