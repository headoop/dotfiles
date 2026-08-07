#!/usr/bin/env bash

# Sucht per recoll in den Rezepten unter ~/Dokumente/Rezepte und gibt die
# Pfade der Treffer aus. Die Suchbegriffe kommen als Argumente oder, wenn
# keine angegeben sind, ueber eine interaktive Abfrage.
# Suchsprache: wort AND wort OR wort -wort

set -uo pipefail

# Konfiguration
#--------------
recipe_dir="$HOME/Dokumente/Rezepte"
recoll="/usr/bin/recoll"

# functions
_exit() {
  echo "$1"
  exit 1
}

_usage() {
  echo "USAGE:"
  echo ""
  echo "${0##*/} word AND word OR word -word"
  echo ""
}

_check_requirements() {
  # recoll installed?
  [[ -x "$recoll" ]] || _exit "recoll not found"
}

# -t Ausgabe aufs Terminal statt in die GUI, -b nur die URLs;
# sed macht aus file:///pfad/datei wieder einen normalen Pfad
_search() {
  local query="$1"

  "$recoll" -t -b "dir:$recipe_dir $query" 2>/dev/null | sed 's#file://##' ||
    _exit "recoll could not run the query: $query"
}

main() {
  _check_requirements

  local query="$*"

  # ohne Argumente nach den Suchbegriffen fragen
  if [[ -z "$query" ]]; then
    _usage
    echo "Enter searchwords"
    echo ""
    read -r query
  fi

  _search "$query"
}

main "$@"
