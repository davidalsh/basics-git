#!/usr/bin/env bash

show_usage() {
  echo "Użycie: $0 [--logs]"
  exit 1
}

if [[ $# -ne 1 ]]; then
  show_usage
fi

case "$1" in
  --logs)
    for i in {1..100}; do
      filename="log${i}.txt"
      {
        echo "Nazwa pliku: ${filename}"
        echo "Nazwa skryptu: $(basename "$0")"
        echo "Data utworzenia: $(date '+%Y-%m-%d %H:%M:%S')"
      } > "${filename}"
    done
    echo "Utworzono 100 plików log*.txt"
    ;;

  *)
    show_usage
    ;;
esac

