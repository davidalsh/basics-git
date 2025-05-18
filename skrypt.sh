#!/usr/bin/env bash

show_usage() {
  echo "Użycie: $0 [--date]"
  echo "Użycie: $0 [--logs [LICZBA]]"
  exit 1
}


if [[ $# -lt 1 || $# -gt 2 ]]; then
  show_usage
fi

case "$1" in
  --date)
    date
    ;;

  --logs)
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
  *)
    show_usage
    ;;
esac
