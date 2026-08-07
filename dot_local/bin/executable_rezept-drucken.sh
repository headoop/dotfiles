#!/usr/bin/env bash

# Druckt eine Rezept-Datei: wandelt sie per pandoc/pdflatex in ein PDF um
# (2cm linker Rand, Helvetica, 11pt) und leitet dieses an lpr weiter.
# Optionen: -f Datei, -d Duplexdruck, -c Farbdruck, -h Hilfe;
# Standard ist einseitig/Graustufen auf Drucker GraustufenNormalDuplex.

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
#FILE="$1"
# TODO: Drucker-Auswahl Abfrage
# PRINTER="Graustufen300Duplex"
# PRINTER="BrotherGraustufenNormalDuplex"
PRINTER="GraustufenNormalDuplex"
#duplex="-o Duplex=DuplexNoTumble"
#media="-o BRMediaType=PlainDuplex"
#color="-o BRMonoColor=Color"
#color="-o BRMonoColor=Mono"
#resolution="-o BRResolution=PlainFast"
#resolution="-o BRResolution=PlainNormal"

# functions
_exit() {
  echo "$1"
  exit 1
}

_help() {
  echo ""
  echo "print recipe"
  echo ""
  echo "Usage:"
  echo "-h | --help       this help"
  echo "-c | --color      print colored"
  echo "-d | --duplex     print two sided"
  echo "-f | --file       filename"

  echo ""
  exit
}

# modern getopt installed?
#-------------------------
getopt -T &>/dev/null
exit_code="$?"
if [ $exit_code -ne 4 ]; then
  echo
  echo "modern getopt from linux-utils is needed"
  echo
  exit $exit_code
fi
# pandoc installed?
[[ -x "$pandoc" ]] || _exit "pandoc not found"
# lpr installed?
[[ -x "$lpr" ]] || _exit "lpr not found"

# call help when no argument is given
if [[ $# -eq 0 ]]; then
  _help
fi

# getting arguments
OPTS=$(getopt -o hdcf: --long help,duplex,color,file: -n 'print-recipe' -- "$@")
exit_code="$?"
if [ $exit_code != 0 ]; then
  _help
fi

# DEBUG
#echo "$OPTS"
eval set -- "$OPTS"

# default options
HELP=false
FILE_SET=false
# DUPLEX="-o Duplex=None"
DUPLEX="-o Duplex=DuplexNoTumble" # print both sides per default
COLOR="-o BRMonoColor=Mono"

# processing arguments
while true; do
  case "$1" in
  -h | --help)
    HELP=true
    shift
    ;;
  # -d | --duplex)
  -o | --one-sided)
    DUPLEX="-o Duplex=None"
    shift
    ;;
  -c | --color)
    COLOR="-o BRMonoColor=Color"
    shift
    ;;
  -f | --file)
    FILE="$2"
    FILE_SET=true
    shift
    shift
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
if [ "$FILE_SET" == "false" ] && [ -n "$1" ]; then
  FILE="$1"
fi

# run help and quit
#------------------
if [ "$HELP" == "true" ]; then
  _help
fi

# no file given -> show help
#----------------------------
if [ -z "$FILE" ]; then
  _help
fi

if [ ! -f "$FILE" ]; then
  echo "file not found"
  _exit
fi

# print
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
  -s "$FILE" -t pdf | "$lpr" -P "$PRINTER" "$DUPLEX" "$COLOR"
