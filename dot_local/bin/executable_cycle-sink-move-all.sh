#!/bin/bash

# This script cycles through available audio output devices (sinks) using
# PulseAudio/PipeWire. It switches to the next audio sink in the list,
# automatically moves all currently playing audio streams to the new device,
# and displays a desktop notification showing which device was selected and how
# many streams were moved.

# Alle verfügbaren Sink-Namen mittels mapfile in ein Array laden
# Wir nutzen Process Substitution <(...), um die jq-Ausgabe einzulesen
mapfile -t sinks < <(pactl -f json list sinks 2>/dev/null | jq -r '.[].name')

# current_sink=$(pactl -f json info | jq -r '.default_sink_name')
current_sink=$(pactl get-default-sink)
num_sinks=${#sinks[@]}

if [ "$num_sinks" -eq 0 ]; then
  notify-send --urgency=critical "Audio Fehler" "Keine Ausgabegeräte gefunden." --icon=dialog-error
  exit 1
fi

# Den Index der aktuellen Sink finden
current_index=-1
for i in "${!sinks[@]}"; do
  if [[ "${sinks[$i]}" == "$current_sink" ]]; then
    current_index=$i
    break
  fi
done

# Nächsten Index berechnen (Modulo für endloses Switchen)
next_index=$(((current_index + 1) % num_sinks))
next_sink="${sinks[$next_index]}"

# Standard-Sink setzen
pactl set-default-sink "$next_sink"

# Alle laufenden Streams (Sink-Inputs) auf das neue Gerät verschieben
# Wir holen alle Indizes der aktuell spielenden Sounds
# stream_ids=$(pactl -f json list sink-inputs | jq -r '.[].index')
mapfile -t stream_ids < <(pactl -f json list sink-inputs | jq -r '.[].index')

for stream_id in "${stream_ids[@]}"; do
  pactl move-sink-input "$stream_id" "$next_sink"
done

# Anzeige-Name für die Benachrichtigung holen
next_sink_desc=$(pactl -f json list sinks 2>/dev/null | jq -r ".[] | select(.name == \"$next_sink\") | .description")
# Benachrichtigung senden
# notify-send "Audio-Ausgabe gewechselt" "Gerät: $next_sink_desc\nStreams verschoben: $(echo "$stream_ids" | wc -w)" --icon=audio-speakers --transient
notify-send --urgency=low "Audio-Ausgabe gewechselt" "Gerät: $next_sink_desc\nStreams verschoben: ${#stream_ids[@]}" --icon=audio-speakers --transient
