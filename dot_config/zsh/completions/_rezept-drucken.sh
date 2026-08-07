#compdef rezept-drucken.sh rd

# zsh completion for rezept-drucken.sh
#
# Rezeptnamen kommen aus $recipe_dir (ohne Pfad, das Skript sucht dort selbst),
# Druckernamen dynamisch aus lpstat. Enthaelt der angefangene Pfad ein "/",
# wird auf gewoehnliche Dateivervollstaendigung umgeschaltet, damit sich auch
# Dateien ausserhalb des Rezepteverzeichnisses drucken lassen.

local recipe_dir="$HOME/Dokumente/Rezepte"

_rezept_drucken_recipes() {
  local -a recipes

  # Pfadangabe -> normale Dateivervollstaendigung
  if [[ "$PREFIX" == */* || "$PREFIX" == '~'* ]]; then
    _files
    return
  fi

  # (N:t) - nullglob, nur der Dateiname; *.txt laesst die Backups (*.txt~) aus
  recipes=("$recipe_dir"/*.txt(N:t))

  if (( ${#recipes} == 0 )); then
    _files
    return
  fi

  _describe -t recipes 'Rezept' recipes || _files
}

_rezept_drucken_printers() {
  local -a printers
  printers=(${(f)"$(lpstat -e 2>/dev/null)"})
  _describe -t printers 'Drucker' printers
}

_arguments -s \
  '(- *)'{-h,--help}'[this help]' \
  '(-c --color)'{-c,--color}'[print colored]' \
  '(-s --single-sided)'{-s,--single-sided}'[print one sided]' \
  '(-f --file)'{-f,--file}'[filename]:Rezept:_rezept_drucken_recipes' \
  '(-p --printer)'{-p,--printer}'[printer name]:Drucker:_rezept_drucken_printers' \
  '*::Rezept:_rezept_drucken_recipes'
