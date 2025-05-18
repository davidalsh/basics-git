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

# jeśli brak argumentu lub więcej niż 2 — pokaż pomoc
if [[ $# -lt 1 || $# -gt 2 ]]; then
  show_usage
fi

case "$1" in
  --date)
    date
    ;;

  --logs)
    # ustalenie liczby plików (domyślnie 100)
    if [[ $# -eq 2 ]]; then
      if [[ "$2" =~ ^[1-9][0-9]*$ ]]; then
        count=$2
      else
        echo "Błąd: drugi argument musi być dodatnią liczbą całkowitą."
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

  --help)
    show_usage
    ;;

  *)
    show_usage
    ;;
esac

