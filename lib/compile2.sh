#!/bin/bash

# Function to display help information
show_help() {
    echo "Usage: $0 [N]"
    echo
    echo "This script outputs formatted file names (codes) for PNG files in a sorted Markdown table."
    echo "The table will have N columns, as specified by the input parameter."
    echo
    echo "Arguments:"
    echo "  N    Number of columns in the table."
    echo
    echo "Example: $0 3"
}

# Base directory
dir="../public/images"

# Check for number of columns argument
if [ -z "$1" ]; then
    show_help
    exit 1
fi

# Number of columns
num_columns=$1

# Function to process files and output in Markdown table format
process_files() {
    local base_dir=$1
    local num_columns=$2
    shift 2

    # Collect and sort the codes
    codes=()
    for file in $(find "$base_dir" -type f -name "*.png" | sort); do
        local formatted_file=${file#$base_dir/}  # Remove base directory
        formatted_file=${formatted_file//\//.}   # Replace slashes with dots
        formatted_file=${formatted_file%.png}    # Remove file extension
        codes+=("$formatted_file")
    done

    # Output table header
    header="|"
    separator="|"
    for (( i=1; i<=num_columns; i++ )); do
        header+=" Code |"
        separator+=" -- |"
    done
    echo "$header"
    echo "$separator"

    # Output the table rows
    total_files=${#codes[@]}
    for (( i=0; i<$total_files; i++ )); do
        if (( $i % $num_columns == 0 )); then
            echo -n "|"
        fi
        echo -n " ${codes[$i]} |"
        if (( ($i + 1) % $num_columns == 0 || $i == $total_files - 1 )); then
            echo ""
        fi
    done
}

# Process and output the files
process_files "$dir" "$num_columns"
