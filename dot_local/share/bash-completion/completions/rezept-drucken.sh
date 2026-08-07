# shellcheck shell=bash
# bash completion for rezept-drucken.sh
#
# Rezeptnamen kommen aus $recipe_dir (ohne Pfad, das Skript sucht dort selbst),
# Druckernamen dynamisch aus lpstat. Enthaelt der angefangene Pfad ein "/",
# wird auf gewoehnliche Dateivervollstaendigung umgeschaltet, damit sich auch
# Dateien ausserhalb des Rezepteverzeichnisses drucken lassen.

_rezept_drucken_recipes() {
  local recipe_dir="$HOME/Dokumente/Rezepte"
  local cur="$1"
  local -a names

  # Pfadangabe -> normale Dateivervollstaendigung
  if [[ "$cur" == */* || "$cur" == '~'* ]]; then
    _filedir
    return
  fi

  if [[ -d "$recipe_dir" ]]; then
    local recipe
    # *.txt schliesst die Editor-Backups (*.txt~) aus
    for recipe in "$recipe_dir"/*.txt; do
      [[ -f "$recipe" ]] && names+=("${recipe##*/}")
    done
  fi

  mapfile -t COMPREPLY < <(compgen -W "${names[*]}" -- "$cur")
  # nichts passend -> Dateien im aktuellen Verzeichnis anbieten
  [[ ${#COMPREPLY[@]} -eq 0 ]] && _filedir
}

_rezept_drucken_printers() {
  local cur="$1"
  local printers
  printers="$(lpstat -e 2>/dev/null)"
  mapfile -t COMPREPLY < <(compgen -W "$printers" -- "$cur")
}

_rezept_drucken() {
  local cur prev
  local opts="-h --help -c --color -s --single-sided -f --file -p --printer"

  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD - 1]}"

  case "$prev" in
  -f | --file)
    _rezept_drucken_recipes "$cur"
    return
    ;;
  -p | --printer)
    _rezept_drucken_printers "$cur"
    return
    ;;
  esac

  if [[ "$cur" == -* ]]; then
    mapfile -t COMPREPLY < <(compgen -W "$opts" -- "$cur")
    return
  fi

  # positionales Argument ist ebenfalls der Dateiname
  _rezept_drucken_recipes "$cur"
}

complete -F _rezept_drucken rezept-drucken.sh rd
