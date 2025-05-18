#!/usr/bin/env bash

show_usage() {
  cat <<EOF
Użycie: $(basename "$0") [OPCJA] [ARGUMENT]

Opcje:
  --date           Wyświetla dzisiejszą datę.
  --logs [LICZBA]  Tworzy LICZBA plików logX.txt (domyślnie 100).
  --help           Wyświetla tę pomoc.

Przykłady:
  $(basename "$0") --date
  $(basename "$0") --logs
  $(basename "$0") --logs 30
  $(basename "$0") --help
EOF
  exit 1
}

if [[ $# -lt 1 || $# -gt 2 ]]; then
  show_usage
fi

case "$1" in

  --help)
    show_usage
    ;;

  *)
    show_usage
    ;;
esac

