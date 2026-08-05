#!/bin/bash
# Pfad zu Mutt-Cache-Ordner
CACHE_DIR="$HOME/.cache/mutt"
# Maximale Größe in Kilobyte (z. B. 500000 KB = ca. 500 MB)
MAX_SIZE=500000

if [ -d "$CACHE_DIR" ]; then
  CURRENT_SIZE=$(du -s "$CACHE_DIR" | cut -f1)

  # Wenn der Cache zu groß ist, lösche die ältesten Dateien
  while [ $CURRENT_SIZE -gt $MAX_SIZE ]; do
    # Findet die älteste Datei im Cache und löscht sie
    OLDEST_FILE=$(find "$CACHE_DIR" -type f -printf '%T+ %p\n' | sort | head -n 1 | cut -d' ' -f2-)
    if [ -n "$OLDEST_FILE" ]; then
      rm "$OLDEST_FILE"
      CURRENT_SIZE=$(du -s "$CACHE_DIR" | cut -f1)
    else
      break
    fi
  done
fi
