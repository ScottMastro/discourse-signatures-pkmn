#!/bin/bash

# Base directory
dir="../public/images"
out=../public/pkmn.json

# Collect and sort PNG files
files=$(find "$dir" -type f -name "*.png" | sort)

echo "[" > $out

first=true
for file in $files; do
  # Build ID/code
  formatted_file=${file#$dir/}   # Remove base dir
  formatted_file=${formatted_file//\//.}  # Replace slashes with dots
  codename=${formatted_file%.png}

  # Build URL (path relative to /images)
  url="/images/${file#$dir/}"

  # Human-friendly name (capitalize first letter, strip dirs)
  name=$(basename "$codename")
  name="$(tr '[:lower:]' '[:upper:]' <<< ${name:0:1})${name:1}"
  
  # JSON formatting
  if [ "$first" = true ]; then
    first=false
  else
    echo "," >> $out
  fi
  echo -n "  { \"id\": \"$codename\", \"url\": \"$url\" }" >> $out
done

echo >> $out
echo "]" >> $out
