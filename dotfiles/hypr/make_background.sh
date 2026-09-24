#!/bin/bash
# Получаем размеры экрана
LEFT_THIRD_WIDTH=$((1920*4/10))
SCREEN_HEIGHT=1080

convert astronaut.png \
    \( -clone 0 -crop ${LEFT_THIRD_WIDTH}x${SCREEN_HEIGHT}+0+0 -blur 0x24 \) \
    -geometry +0+0 -composite lockscreen.png
