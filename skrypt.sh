#!/usr/bin/env bash

show_usage() {
  cat <<EOF
Użycie: $(basename "$0") [OPCJA] [ARGUMENT]

Opcje:
  --date, -d           Wyświetla dzisiejszą datę.
  --logs, -l [LICZBA]  Tworzy LICZBA plików logX.txt (domyślnie 100).
  --help, -h           Wyświetla tę pomoc.

Przykłady:
  $(basename "$0") --date
  $(basename "$0") -d
  $(basename "$0") --logs
  $(basename "$0") -l
  $(basename "$0") --logs 30
  $(basename "$0") -l 30
  $(basename "$0") --help
  $(basename "$0") -h
EOF
  exit 1
}

if [[ $# -lt 1 || $# -gt 2 ]]; then
  show_usage
fi

case "$1" in
  --date|-d)
    date
    ;;

  --logs|-l)
    if [[ $# -eq 2 ]]; then
      if [[ "$2" =~ ^[1-9][0-9]*$ ]]; then
        count=$2
      else
        echo "Błąd: argument liczby plików musi być dodatnią liczbą całkowitą."
        exit 1
      fi
    else
      count=100
    fi

    for i in $(seq 1 "$count"); do
      filename="log${i}.txt"
      {
        echo "Nazwa pliku: ${filename}"
        echo "Nazwa skryptu: $(basename "$0")"
        echo "Data utworzenia: $(date '+%Y-%m-%d %H:%M:%S')"
      } > "${filename}"
    done

    echo "Utworzono ${count} plików log*.txt"
    ;;

  --help|-h)
    show_usage
    ;;

  --init|-i)
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    REMOTE_URL="$(git -C "$SCRIPT_DIR" config --get remote.origin.url)" \
      || { echo "Nie udało się pobrać URL z remote.origin." >&2; exit 1; }

    git clone "$REMOTE_URL" . \
      || { echo "Błąd podczas klonowania $REMOTE_URL do $(pwd)." >&2; exit 1; }

    case "$(basename "$SHELL")" in
      zsh)   PROFILE="$HOME/.zshrc" ;;
      *)     PROFILE="$HOME/.bashrc" ;;
    esac

    ENTRY="export PATH=\"$(pwd):\$PATH\""
    if ! grep -Fxq "$ENTRY" "$PROFILE"; then
      echo -e "\n# dodane przez skrypt.sh --init" >> "$PROFILE"
      echo    "$ENTRY"         >> "$PROFILE"
      echo "Dodano '$(pwd)' do \$PATH w $PROFILE"
      echo "Aby zmiany zadziałały, uruchom ponownie terminal lub wykonaj:"
      echo "  source $PROFILE"
    else
      echo "Katalog '$(pwd)' już znajduje się w \$PATH w $PROFILE"
    fi
    ;;

  *)
    show_usage
    ;;
esac

