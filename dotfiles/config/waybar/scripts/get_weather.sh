#!/usr/bin/env bash
text=$(curl -s "https://wttr.in/$1?format=1")
if [[ $? == 0 ]]; then
    text=$(echo "$text" | sed -E "s/\s+/ /g")
    tooltip=$(curl -s "wttr.in/$1?format=4")   
    if [[ $? == 0 ]]; then
        tooltip=$(echo "$tooltip" | sed -E "s/\s+/ /g")
        echo "{\"text\":\"$text\", \"tooltip\":\"$tooltip\"}"
    else
        echo "{\"text\":\"$text\", \"tooltip\":\"Ошибка получения деталей\"}"
    fi
else
    echo "{\"text\":\"?\", \"tooltip\":\"Ошибка подключения\"}"
fi
