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
      z tymi samymi informacjami co dla log*.  
  --init, -i
      Klonuje całe repozytorium (z remote origin) do bieżącego katalogu
      i dopisuje ten katalog na początku \$PATH w ~/.bashrc lub ~/.zshrc.

Przykłady:
  $(basename "$0") --date
  $(basename "$0") -l 50
  $(basename "$0") --logs
  $(basename "$0") -e 30
  $(basename "$0") --error
  $(basename "$0") -i
  $(basename "$0") --help
EOF
  exit 1
}

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

