#!/usr/bin/env bash

# Функция-обёртка для Rofi, чтобы не использовать eval
rofi_win() {
    local prompt="$1"
    rofi -dmenu -i -theme-str 'window {width: 25%;}' -p "$prompt"
}

# --- ПОДМЕНЮ: ПИТАНИЕ И БАТАРЕЯ ---
power_menu() {
    CURRENT=$(powerprofilesctl get 2>/dev/null || echo "N/A")
    
    OPTIONS="⚡ Performance\n🌱 Balanced\n🔋 Power-Saver\n⬅ Назад"
    CHOICE=$(echo -e "$OPTIONS" | rofi_win "Питание (Текущий: $CURRENT)")

    case "$CHOICE" in
        "⚡ Performance")
            powerprofilesctl set performance
            notify-send "Питание" "Включен режим Performance" -i speedometer
            ;;
        "🌱 Balanced")
            powerprofilesctl set balanced
            notify-send "Питание" "Включен режим Balanced" -i battery
            ;;
        "🔋 Power-Saver")
            powerprofilesctl set power-saver
            notify-send "Питание" "Включен режим Power-Saver" -i battery-low
            ;;
        "⬅ Назад")
            main_menu
            ;;
    esac
}

# --- ПОДМЕНЮ: СИСТЕМНЫЕ УТИЛИТЫ ---
tools_menu() {
    OPTIONS="💻 Монитор ресурсов (Btop)\n🌐 Сеть и Bluetooth (Nmtui)\n🗑 Очистить корзину\n⬅ Назад"
    CHOICE=$(echo -e "$OPTIONS" | rofi_win "Утилиты")

    case "$CHOICE" in
        "💻 Монитор ресурсов (Btop)")
            kitty --class floating_terminal -e btop
            ;;
        "🌐 Сеть и Bluetooth (Nmtui)")
            kitty --class floating_terminal -e nmtui
            ;;
        "🗑 Очистить корзину")
            trash-empty
            notify-send "Корзина" "Корзина успешно очищена" -i user-trash
            ;;
        "⬅ Назад")
            main_menu
            ;;
    esac
}

# --- ПОДМЕНЮ: ВЫХОД И ПИТАНИЕ ПК ---
session_menu() {
    OPTIONS="🔒 Заблокировать экран\n💤 Сон (Suspend)\n🔄 Перезагрузить\n🛑 Выключить\n🚪 Выйти из Hyprland\n⬅ Назад"
    CHOICE=$(echo -e "$OPTIONS" | rofi_win "Сеанс")

    case "$CHOICE" in
        "🔒 Заблокировать экран")
            hyprlock 2>/dev/null || loginctl lock-session
            ;;
        "💤 Сон (Suspend)")
            systemctl suspend
            ;;
        "🔄 Перезагрузить")
            systemctl reboot
            ;;
        "🛑 Выключить")
            systemctl poweroff
            ;;
        "🚪 Выйти из Hyprland")
            hyprctl dispatch exit
            ;;
        "⬅ Назад")
            main_menu
            ;;
    esac
}

# --- ГЛАВНОЕ МЕНЮ ---
main_menu() {
    CURRENT_POWER=$(powerprofilesctl get 2>/dev/null || echo "N/A")

    OPTIONS="⚡ Режим питания [$CURRENT_POWER]\n🛠 Системные утилиты\n🚪 Сеанс и Выключение"
    CHOICE=$(echo -e "$OPTIONS" | rofi_win "Главное меню")

    case "$CHOICE" in
        *"Режим питания"*)
            power_menu
            ;;
        *"Системные утилиты"*)
            tools_menu
            ;;
        *"Сеанс и Выключение"*)
            session_menu
            ;;
    esac
}

# Запуск
main_menu
