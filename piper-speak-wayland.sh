#!/bin/bash

TEXT="${1:-"No text provided"}"
PIPER_DIR="~/.local/bin/piper"
MODEL="$PIPER_DIR/en_GB-vctk-medium.onnx"
CONFIG="$MODEL.json"
TEMP_WAV="/tmp/piper_output.wav"

# 1. While Piper is generating the text in the background, we wake the sink.
# We pipe 0.1 seconds of silence/low-hum natively through pw-cat to wake the device.
# (Using 44100Hz, 16-bit, 1 channel raw data)
head -c 12200 /dev/zero | pw-cat --playback --rate=44100 --channels=1 --format=s16 --volume=0.1 --raw - > /dev/null 2>&1 
#sleep 0.15

# Render directly to a real file (Piper won't mix logs into file writes)
echo "$TEXT" | "$PIPER_DIR/piper" \
  --model "$MODEL" \
  -c "$CONFIG" \
  --output_file "$TEMP_WAV"

# Play the clean file
if [ -f "$TEMP_WAV" ]; then
  PIPEWIRE_PROPERTIES='node.name=piper-tts' pw-play "$TEMP_WAV"
  rm "$TEMP_WAV"
fi 
