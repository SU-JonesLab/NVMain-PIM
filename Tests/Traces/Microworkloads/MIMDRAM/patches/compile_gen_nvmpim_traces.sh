#!/bin/bash

# Create a directory to store the traces if it does not exist
mkdir -p traces

# Compile each .c file in the current directory
for file in *-plus.c; do
    # Extract filename without extension
    filename=$(basename -- "$file")
    filename="${filename%.*}"

    # Compile the .c file into an executable binary with the same name
    gcc -static -g -std=c99 -I. "$file" -o "traces/${filename}_trace.exe"
done

# Run compiled binaries with the two parameters: col_length and num_vals
for file in traces/*_trace.exe; do
    # Extract filename without extension
    filename=$(basename -- "$file")
    filename="${filename%.*}"

    # Run the compiled binary with the two parameters
    ./"$file" 8 4 > "traces/${filename}_trace.out"
done