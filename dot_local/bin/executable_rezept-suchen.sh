#!/usr/bin/bash

if [[ -z "$1" ]]; then
    echo "USAGE:"
    echo ""
    echo "$0 word AND word OR word -word"
    echo ""
    echo "Enter searchwords"
    echo ""
    read -r word
    recoll -t -b "dir:$HOME/Dokumente/Rezepte $word" 2> /dev/null | sed 's#file://##'
else
    recoll -t -b "dir:/$HOME/Dokumente/Rezepte $*" 2> /dev/null | sed 's#file://##'
fi

