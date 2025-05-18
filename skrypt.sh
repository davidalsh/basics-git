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

  *)
    show_usage
    ;;
esac

