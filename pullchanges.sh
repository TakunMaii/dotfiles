#!/usr/bin/bash

# get the names of all files in the current directory
files=$(ls -ap | grep -v /)

# get the nems of all directories in the current directory
dirs=$(ls -da */)

# print files and directories
echo "Found:"
for file in $files; do
    echo "  - $file"
done
for dir in $dirs; do
    echo "  - ${dir}"
done

# source directories to pull changes from
src_dir=("/home/$(whoami)/" "/home/$(whoami)/.config/")

# loop through each file and directory
pullall="false"
for file in $files; do
    for src in "${src_dir[@]}"; do
        if [ -f "$src$file" ]; then
            if [ "$pullall" = "true" ]; then
                echo "Pulling changes for file: $file"
                cp "$src$file" ./
            else
                read -p "Pull changes for file '$file' from '$src'? (y/n/a): " choice
                case "$choice" in
                    y|Y)
                        echo "Pulling changes for file: $file"
                        cp "$src$file" ./
                        ;;
                    a|A)
                        echo "Pulling changes for all files"
                        pullall="true"
                        cp "$src$file" ./
                        ;;
                    *)
                        echo "Skipping file: $file"
                        ;;
                esac
            fi
        fi
    done
done

for dir in $dirs; do
    for src in "${src_dir[@]}"; do
        if [ -d "$src$dir" ]; then
            if [ "$pullall" = "true" ]; then
                echo "Pulling changes for directory: $dir"
                cp -r "$src$dir" ./
            else
                read -p "Pull changes for directory '$dir' from '$src'? (y/n/a): " choice
                case "$choice" in
                    y|Y)
                        echo "Pulling changes for directory: $dir"
                        cp -r "$src$dir" ./
                        ;;
                    a|A)
                        echo "Pulling changes for all directories"
                        pullall="true"
                        cp -r "$src$dir" ./
                        ;;
                    *)
                        echo "Skipping directory: $dir"
                        ;;
                esac
            fi
        fi
    done
done
