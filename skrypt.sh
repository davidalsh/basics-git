#!/usr/bin/env bash

show_usage() {
  echo "Użycie: $0 [--date]"
  exit 1
}

if [[ $# -ne 1 ]]; then
  show_usage
fi

case "$1" in
  --date)
    # wyświetla dzisiejszą datę w formacie domyślnym systemu
    date
    ;;
  *)
    show_usage
    ;;
esac
