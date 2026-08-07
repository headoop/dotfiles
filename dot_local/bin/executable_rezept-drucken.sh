#!/usr/bin/env bash

# Druckt eine Rezept-Datei: wandelt sie per pandoc/xelatex in ein PDF um
# (20mm linker Rand, Source Serif 4, 11pt) und leitet dieses an lpr weiter.
# Optionen: -f Datei, -s einseitig, -c Farbdruck, -p Drucker, -h Hilfe;
# Standard ist beidseitig/Graustufen auf Drucker GraustufenNormalDuplex.

set -uo pipefail

# Konfiguration
#--------------
# pdf_engine="pdflatex"
pdf_engine="xelatex" # handles UTF8 better and can use all system fonts (ttf/otf)
margin_top="5mm"
margin_left="20mm"
margin_right="5mm"
margin_bottom="5mm"
# fontfamily="libertine" # requires texlive-fontsextra
# fontfamily="helvet"
mainfont="Source Serif 4" # adobe-source-serif-fonts
fontsize="11pt"
linestretch="1"
papersize="a4"
pagestyle="empty" # no page numbers
pandoc="/usr/bin/pandoc"
lpr="/usr/bin/lpr"
# Wird durchsucht, wenn die Datei nicht im aktuellen Verzeichnis liegt
recipe_dir="$HOME/Dokumente/Rezepte"
# Drucker (per -p/--printer überschreibbar)
# Druckerliste mit lpstat -v
printer_default="GraustufenNormalDuplex"

# lpr-Optionen, siehe Brother-Treiber
#duplex="-o Duplex=DuplexNoTumble"
#media="-o BRMediaType=PlainDuplex"
#color="-o BRMonoColor=Color"
#color="-o BRMonoColor=Mono"
#resolution="-o BRResolution=PlainFast"
#resolution="-o BRResolution=PlainNormal"

# Laufzeit-Zustand, wird von _parse_args gesetzt
#-----------------------------------------------
file=""
printer="$printer_default"
duplex_opts=(-o "Duplex=DuplexNoTumble") # print both sides per default
color_opts=(-o "BRMonoColor=Mono")
tmp_pdf=""

# functions
_exit() {
  echo "$1"
  exit 1
}

_cleanup() {
  if [[ -n "$tmp_pdf" ]]; then
    rm -f "$tmp_pdf"
  fi
}

_help() {
  echo ""
  echo "print recipe"
  echo ""
  echo "Usage:"
  echo "-h | --help          this help"
  echo "-c | --color         print colored"
  echo "-s | --single-sided  print one sided (default is two sided)"
  echo "-f | --file          filename"
  echo "-p | --printer       printer name (default: $printer_default)"
  echo ""
  echo "known printers: GraustufenNormalDuplex, Graustufen300Duplex,"
  echo "                BrotherGraustufenNormalDuplex"
  echo ""
  exit "${1:-0}"
}

_check_requirements() {
  # modern getopt installed?
  #-------------------------
  getopt -T &>/dev/null
  local exit_code="$?"
  if [[ $exit_code -ne 4 ]]; then
    echo
    echo "modern getopt from linux-utils is needed"
    echo
    exit "$exit_code"
  fi
  # pandoc installed?
  [[ -x "$pandoc" ]] || _exit "pandoc not found"
  # lpr installed?
  [[ -x "$lpr" ]] || _exit "lpr not found"
}

_parse_args() {
  local opts exit_code help=false file_set=false

  # getting arguments
  opts=$(getopt -o hscf:p: --long help,single-sided,color,file:,printer: \
    -n 'rezept-drucken.sh' -- "$@")
  exit_code="$?"
  if [[ $exit_code -ne 0 ]]; then
    _help 1
  fi

  eval set -- "$opts"

  # processing arguments
  while true; do
    case "$1" in
    -h | --help)
      help=true
      shift
      ;;
    -s | --single-sided)
      duplex_opts=(-o "Duplex=None")
      shift
      ;;
    -c | --color)
      color_opts=(-o "BRMonoColor=Color")
      shift
      ;;
    -f | --file)
      file="$2"
      file_set=true
      shift 2
      ;;
    -p | --printer)
      printer="$2"
      shift 2
      ;;
    --)
      shift
      break
      ;;
    *) break ;;
    esac
  done

  # positional argument as fallback filename
  #-------------------------------------------
  if [[ "$file_set" == "false" && -n "${1:-}" ]]; then
    file="$1"
  fi

  # run help and quit
  #------------------
  if [[ "$help" == "true" ]]; then
    _help
  fi

  # no file given -> show help
  #----------------------------
  if [[ -z "$file" ]]; then
    _help 1
  fi

  # nicht gefunden -> im Rezepteverzeichnis nachsehen, damit der Aufruf
  # auch aus einem anderen Verzeichnis heraus klappt
  #-------------------------------------------------------------------
  if [[ ! -f "$file" && -f "$recipe_dir/$file" ]]; then
    file="$recipe_dir/$file"
  fi

  [[ -f "$file" ]] || _exit "file not found: $file"
  [[ -n "$printer" ]] || _exit "no printer given"
}

_make_pdf() {
  # "$pandoc" --pdf-engine="$pdf_engine" -V geometry:margin="$margin" -V fontfamily="$font" -V fontsize="$fontsize" -s "$FILE" -t pdf | "$lpr" -P "$PRINTER" "$DUPLEX" "$COLOR"
  # "$pandoc" --pdf-engine="$pdf_engine" -V geometry:top=0mm -V geometry:left=20mm -V geometry:bottom=0cm -V fontfamily="$font" -V fontsize="$fontsize" -s "$FILE" -t pdf | "$lpr" -P "$PRINTER" "$DUPLEX" "$COLOR"
  # pandoc --pdf-engine="pdflatex" -V geometry:top="5mm" -V geometry:left="20mm" -V geometry:right="5mm" -V geometry:bottom="5mm" -V fontfamily="helvet" -V fontsize="11pt" -V papersize="a4" -s
  "$pandoc" --pdf-engine="$pdf_engine" \
    -V geometry:top="$margin_top" \
    -V geometry:left="$margin_left" \
    -V geometry:right="$margin_right" \
    -V geometry:bottom="$margin_bottom" \
    -V mainfont="$mainfont" \
    -V fontsize="$fontsize" \
    -V linestretch="$linestretch" \
    -V papersize="$papersize" \
    -V pagestyle="$pagestyle" \
    -s "$file" -o "$tmp_pdf" || _exit "pandoc could not convert $file"
}

_print_pdf() {
  "$lpr" -P "$printer" "${duplex_opts[@]}" "${color_opts[@]}" "$tmp_pdf" ||
    _exit "lpr could not print $file on $printer"
}

main() {
  trap _cleanup EXIT

  _check_requirements

  # call help when no argument is given
  if [[ $# -eq 0 ]]; then
    _help
  fi

  _parse_args "$@"

  # erst das PDF bauen, dann drucken - so landet bei einem pandoc-Fehler
  # kein leerer Auftrag in der Druckerwarteschlange
  tmp_pdf="$(mktemp --tmpdir rezept-drucken-XXXXXXXX.pdf)" ||
    _exit "could not create temporary file"
  _make_pdf
  _print_pdf
}

main "$@"
