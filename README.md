
# ❄️ NixOS & Hyprland Configuration

Минималистичная, производительная и клавиатуроориентированная конфигурация NixOS для **Lenovo ThinkPad X1 Carbon Gen 10**.

- **Window Manager:** Hyprland (Wayland)
- **Shell:** Fish + Starship prompt
- **Terminal:** Kitty
- **File Manager:** Yazi (CLI)
- **Launcher:** Rofi
- **Notifications:** SwayNC
- **Structure:** Standalone NixOS modules (`configuration.nix` + `home.nix` + `dotfiles`) без Flakes.

---

## 🚀 Повседневная работа с конфигом

### Как внести и применить изменения:
1. Отредактируй нужные файлы в папке `~/nixos-config`:
   - `/etc/nixos/configuration.nix` (системные пакеты, сервисы, драйверы)
   - `/etc/nixos/home.nix` (пользовательский софт, настройки программ)
   - `/etc/nixos/dotfiles/` (конфиги Hyprland, Waybar, Rofi, Kitty, Fish)
2. Примени конфигурацию:
   ```bash
   sudo nixos-rebuild switch

```

### Сохранение изменений в Git:

```bash
cd ~/nixos-config
git status
git add .
git commit -m "feat: описание изменений"
git push origin main

```

---

## 🎹 Горячие клавиши (Hyprland)

| Сочетание | Действие |
| --- | --- |
| `Super + Return` | Терминал Kitty |
| `Super + D` | Меню приложений Rofi |
| `Super + V` | История буфера обмена (Rofi + cliphist) |
| `Super + Shift + /` | Шпаргалка по хоткеям Hyprland |
| `Super + N` | Центр уведомлений SwayNC |
| `Super + E` | Файловый менеджер Yazi |
| `Super + F` | Браузер Firefox |
| `Super + W` | Закрыть активное окно |
| `Super + S` | Переключить плавающий режим (Floating) |
| `Super + P` | Скриншот области (Hyprshot) |
| `Super + Ctrl + P` | Скриншот всего экрана |
| `Caps Lock` | Переключение раскладки клавиатуры (US / RU) |

---

## 🛠 Установка с нуля на новое устройство

1. **Загрузка и разметка диска:**
1. Загрузись с LiveCD NixOS.
2. Размети диски (EFI FAT32 + root ext4) и примонтируй их:

```bash
sudo mount /dev/nvme0n1pX /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/nvme0n1pY /mnt/boot

```


2. **Генерация конфига железа:**
Сгенерируй `hardware-configuration.nix` под новое устройство:

```bash
sudo nixos-generate-config --root /mnt

```


3. **Клонирование репозитория:**
Скачай свой репозиторий и скопируй файлы поверх сгенерированных:

```bash
git clone [https://github.com/Dendrey/nixos-config.git](https://github.com/Dendrey/nixos-config.git) /tmp/nixos-config
cp -r /tmp/nixos-config/* /mnt/etc/nixos/

```


4. **Подключение Home Manager и установка:**
Добавь канал Home Manager и запусти сборку:

```bash
sudo nix-channel --add [https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz](https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz) home-manager
sudo nix-channel --update
sudo nixos-install --root /mnt

```


5. **Первый вход:**
После перезагрузки перенеси папку конфига в `home` и привяжи симлинк:

```bash
sudo mv /etc/nixos ~/nixos-config
sudo chown -R $USER:users ~/nixos-config
sudo ln -s ~/nixos-config /etc/nixos

```


```

---

### Финальный шаг: Отправка всего репозитория в GitHub

Теперь можно сделать первый красивый коммит со всеми файлами и README:

```bash
cd ~/nixos-config

# 1. Проверяем, что .gitignore на месте
echo "hardware-configuration.nix" > .gitignore
echo "*.backup" >> .gitignore

# 2. Индексируем и коммитим
git add .
git commit -m "feat: initial commit with dotfiles and system config"

# 3. Отправляем на GitHub
git push -u origin main
