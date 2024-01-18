#!/bin/bash

# Function to display help information
show_help() {
    echo "Usage: $0 [PREFIX] [-n|--no-image]"
    echo
    echo "This script outputs formatted file names and Markdown links for PNG files as a Markdown table."
    echo "It requires a URL prefix as an argument."
    echo "If -n or --no-image flag is provided, the image column will not be printed."
    echo
    echo "Arguments:"
    echo "  PREFIX       URL prefix to be prepended to the file paths for the Markdown links."
    echo "  -n, --no-image   Optional flag to omit the image column."
    echo
    echo "Example: $0 http://example.com/images/"
    echo "Example: $0 http://example.com/images/ --no-image"
}

# Base directory
dir="../public/images"

# Check for prefix argument
if [ -z "$1" ]; then
    show_help
    exit 1
fi

# Prefix from command line input
prefix=$1
shift

# Check for no-image flag
no_image_flag=0
if [[ "$1" == "-n" ]] || [[ "$1" == "--no-image" ]]; then
    no_image_flag=1
fi

# Function to process files and output in Markdown table format
process_files() {
    local base_dir=$1
    local prefix=$2
    local no_image_flag=$3
    shift 3

    # Output table header
    if [ $no_image_flag -eq 0 ]; then
        echo "| Code | Image |"
        echo "| -- | -- |"
    else
        echo "| Code |"
        echo "| -- |"
    fi

    for file in "$@"; do
        # Format the file name (without extension)
        local formatted_file=${file#$base_dir/}
        formatted_file=${formatted_file%.png}
        formatted_file=${formatted_file//\//.}

        # Create full URL with the additional string
        local full_url="${prefix}/plugins/discourse-signatures-pkmn/images/${file#$base_dir}"

        # Output in Markdown table format
        if [ $no_image_flag -eq 0 ]; then
            echo "| $formatted_file | ![$formatted_file]($full_url) |"
        else
            echo "| $formatted_file |"
        fi
    done
}

# Find all PNG files in the directory
files=$(find "$dir" -type f -name "*.png")

# Process and output the files
process_files "$dir" "$prefix" $no_image_flag $files
