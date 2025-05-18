#!/usr/bin/env bash

show_usage() {
  cat <<EOF
Użycie: $(basename "$0") [OPCJA] [ARGUMENT]

Opcje:
  --help, -h
      Wyświetla tę pomoc.
  --date, -d
      Wyświetla dzisiejszą datę.
  --logs, -l [LICZBA]
      Tworzy LICZBA plików logX.txt (domyślnie 100) z informacjami:
        - nazwa pliku,
        - nazwa skryptu,
        - data utworzenia.
  --error, -e [LICZBA]
      Tworzy LICZBA katalogów errorX (domyślnie 100), a w każdym plik errorX.txt
      z analogicznymi informacjami.

Przykłady:
  $(basename "$0") --help
  $(basename "$0") -d
  $(basename "$0") --logs
  $(basename "$0") -l 30
  $(basename "$0") -e
  $(basename "$0") --error 50
EOF
  exit 1
}

# sprawdzenie liczby argumentów
if [[ $# -lt 1 || $# -gt 2 ]]; then
  show_usage
fi

case "$1" in
  --help|-h)
    show_usage
    ;;

  --date|-d)
    date
    ;;

  --logs|-l)
    # ustawienie liczby plików
    if [[ $# -eq 2 ]]; then
      [[ "$2" =~ ^[1-9][0-9]*$ ]] || { echo "Błąd: liczba plików musi być dodatnią liczbą." >&2; exit 1; }
      count=$2
    else
      count=100
    fi

    for i in $(seq 1 "$count"); do
      filename="log${i}.txt"
      {
        echo "Nazwa pliku: ${filename}"
        echo "Nazwa skryptu: $(basename "$0")"
        echo "Data utworzenia: $(date '+%Y-%m-%d %H:%M:%S')"
      } > "$filename"
    done
    echo "Utworzono ${count} plików log*.txt"
    ;;

  --error|-e)
    # ustawienie liczby katalogów i plików
    if [[ $# -eq 2 ]]; then
      [[ "$2" =~ ^[1-9][0-9]*$ ]] || { echo "Błąd: liczba katalogów musi być dodatnią liczbą." >&2; exit 1; }
      count=$2
    else
      count=100
    fi

    for i in $(seq 1 "$count"); do
      dir="error${i}"
      mkdir -p "$dir"
      filename="${dir}/error${i}.txt"
      {
        echo "Nazwa pliku: $(basename "$filename")"
        echo "Nazwa skryptu: $(basename "$0")"
        echo "Data utworzenia: $(date '+%Y-%m-%d %H:%M:%S')"
      } > "$filename"
    done
    echo "Utworzono ${count} katalogów error* z plikami error*.txt"
    ;;

  *)
    show_usage
    ;;
esac

