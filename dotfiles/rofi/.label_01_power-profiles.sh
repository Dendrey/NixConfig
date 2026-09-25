#!/usr/bin/env bash
CURRENT=$(powerprofilesctl get 2>/dev/null || echo "N/A")
echo "⚡ Режим питания [$CURRENT]"
