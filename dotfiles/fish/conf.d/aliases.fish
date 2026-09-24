# ── Навигация ────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Быстрый переход домой и в проекты
alias home='cd ~'

# ── Файлы и просмотр ─────────────────────────
alias ls='eza --icons=always --group-directories-first'
alias ll='eza -lh --icons=always --group-directories-first'
alias la='eza -lha --icons=always --group-directories-first'
alias tree='eza --tree --level=2'


# ── Git (минимум, остальное можешь раскомментировать) ────
alias g='git'
# alias gst='git status'
# alias ga='git add'
# alias gc='git commit'
# alias gp='git push'
# alias gl='git pull'
# alias lg='lazygit'      # TUI-интерфейс git
# alias gd='git diff | delta'  # красивый diff

# ── Система ──────────────────────────────────
alias psx='procs --tree'  # дерево процессов
alias dux='dust -r'       # обзор занятого места

# ── Разное ───────────────────────────────────
alias cls='clear'
alias mk='mkdir -p'
alias rmf='rm -rf'

# ── FZF интеграция ───────────────────────────
# Быстро открыть файл из текущей папки
alias ff='fd | fzf | read -l file; and test -n "$file"; and micro "$file"'

# ── NixOS / Dev ──────────────────────────────
alias nrb='sudo nixos-rebuild switch'
