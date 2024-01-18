#!/bin/bash

# Base directories
pokemon_dir="../assets/pokesprite/pokemon"
items_dir="../assets/pokesprite/items"

# Function to process files and output the desired string format
process_files() {
    local base_dir=$1
    shift
    for file in "$@"; do
        # Remove the base path and the file extension, then replace '/' with '.'
        local formatted_file=${file#$base_dir/}
        formatted_file=${formatted_file%.png}
        formatted_file=${formatted_file//\//.}
        echo "$formatted_file"
    done
}

# Find all PNG files in pokemon and items directories
pokemon_files=$(find "$pokemon_dir" -type f -name "*.png")
items_files=$(find "$items_dir" -type f -name "*.png")

# Process and output the files
process_files "$pokemon_dir" $pokemon_files
process_files "$items_dir" $items_files