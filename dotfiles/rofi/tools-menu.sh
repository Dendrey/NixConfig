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
    OPTIONS="📷 OCR + QR\n🗑 Очистить корзину\n Буфер обмена\n Очистить буфер обмена\n ⬅ Назад"
    CHOICE=$(echo -e "$OPTIONS" | rofi_win "Утилиты")

    case "$CHOICE" in
        "📷 OCR + QR")
        	# Снимаем выделенную область во временную директорию /tmp
        	TEMP_IMG=$(mktemp /tmp/grab_XXXXXX.png)
        	            grim -g "$(slurp)" "$TEMP_IMG" || exit 0
        	            
        	            # 1. Пробуем считать QR-код
        	            QR_RESULT=$(zbarimg --raw -q "$TEMP_IMG" 2>/dev/null)
        	            if [ -n "$QR_RESULT" ]; then
        	                echo -n "$QR_RESULT" | wl-copy
        	                notify-send "QR-код" "$QR_RESULT" -i edit-copy
        	                rm -f "$TEMP_IMG"
        	                exit 0
        	            fi
        	
        	            # 2. Если QR нет, прогоняем через Tesseract OCR
        	            TEXT_RESULT=$(tesseract "$TEMP_IMG" stdout -l rus+eng 2>/dev/null)
        	            rm -f "$TEMP_IMG"
        	
        	            if [ -n "$TEXT_RESULT" ]; then
        	                echo -n "$TEXT_RESULT" | wl-copy
        	                notify-send "OCR Успешно" "Текст скопирован в буфер!" -i edit-copy
        	            else
        	                notify-send "Сканер" "Ничего не найдено" -i dialog-error
        	            fi
        	;;
        "🗑 Очистить корзину")
            trash-empty
            notify-send "Корзина" "Корзина успешно очищена" -i user-trash
            ;;
          " Буфер обмена")
            cliphist list | rofi -dmenu -p "Clipboard" | cliphist decode | wl-copy
            ;;
          " Очистить буфер обмена")
            cliphist wipe
            notify-send "Буфер обмена" "История очищена"
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

# --- ПОДМЕНЮ: ОБСЛУЖИВАНИЕ NIXOS ---
nixos_menu() {
    OPTIONS="🔄 Пересобрать систему (Rebuild Switch)\n🧹 Очистить старые генерации и мусор\n📜 Список генераций системы\n⬅ Назад"
    CHOICE=$(echo -e "$OPTIONS" | rofi_win "NixOS Обслуживание")

    case "$CHOICE" in
        "🔄 Пересобрать систему (Rebuild Switch)")
            kitty --class floating_terminal -e sh -c "sudo nixos-rebuild switch; echo -e '\nНажмите Enter для выхода...'; read"
            ;;
        "🧹 Очистить старые генерации и мусор")
            kitty --class floating_terminal -e sh -c "sudo nix-collect-garbage -d && sudo nixos-rebuild switch; echo -e '\nГотово! Нажмите Enter...'; read"
            ;;
        "📜 Список генераций системы")
            kitty --class floating_terminal -e sh -c "nixos-rebuild list-generations; echo -e '\nНажмите Enter для выхода...'; read"
            ;;
        "⬅ Назад")
            main_menu
            ;;
    esac
}

# --- ГЛАВНОЕ МЕНЮ ---
main_menu() {
    CURRENT_POWER=$(powerprofilesctl get 2>/dev/null || echo "N/A")

    OPTIONS="⚡ Режим питания [$CURRENT_POWER]\n🛠 Системные утилиты\n🚪 Сеанс и Выключение\n ❄️ Обслуживание NixOS"
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
        *"Обслуживание NixOS"*)
          nixos_menu
          ;;
    esac
}

# Запуск
main_menu
