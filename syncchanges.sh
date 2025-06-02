#!/usr/bin/bash

if [ "$1" = "pull" ]; then
   mode="pull" 
   doall="false"
elif [ "$1" = "pullall" ]; then
   mode="pull" 
   doall="true"
elif [ "$1" = "push" ]; then
    mode="push" 
    doall="false"
elif [ "$1" = "pushall" ]; then
    mode="push" 
    doall="true"
else
    echo "Usage: $0 pull|pullall|push|pushall"
    exit 1
fi

files=$(ls -ap | grep -v /)
dirs=$(ls -da */)

echo "Found:"
for file in $files; do
    echo "  - $file"
done
for dir in $dirs; do
    echo "  - ${dir}"
done

src_config="/home/$(whoami)/.config/syncchanges.conf"
if [ -f "$src_config" ]; then
    # read source directories from config file
    src_dir=()
    while IFS= read -r line; do
        src_dir+=("$line")
    done < "$src_config"
else
    # default source directories if config file does not exist
    src_dir=("/home/$(whoami)/" "/home/$(whoami)/.config/")
fi

# loop through each file and directory
for file in $files; do
    for src in "${src_dir[@]}"; do
        if [ -f "$src$file" ]; then
            if [ "$mode" = "push" ]; then
                if [ "$doall" = "true" ]; then
                    echo "Pushing changes for file: $file"
                    cp "$file" "$src"
                else
                    read -p "Push changes for file '$file' to '$src'? (y/n/a): " choice
                    case "$choice" in
                        y|Y)
                            echo "Pushing changes for file: $file"
                            cp "$file" "$src"
                            ;;
                        a|A)
                            echo "Pushing changes for file: $file"
                            doall="true"
                            cp "$file" "$src"
                            ;;
                    esac
                fi
            elif [ "$mode" = "pull" ]; then
                if [ "$doall" = "true" ]; then
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
                            echo "Pulling changes for file: $file"
                            doall="true"
                            cp "$src$file" ./
                            ;;
                    esac
                fi
            fi
        fi
    done
done


for dir in $dirs; do
    for src in "${src_dir[@]}"; do
        if [ -d "$src$dir" ]; then
            if [ "$mode" = "push" ]; then
                if [ "$doall" = "true" ]; then
                    echo "Pushing changes for directory: $dir"
                    cp -r "$dir" "$src"
                else
                    read -p "Push changes for directory '$dir' to '$src'? (y/n/a): " choice
                    case "$choice" in
                        y|Y)
                            echo "Pushing changes for directory: $dir"
                            cp -r "$dir" "$src"
                            ;;
                        a|A)
                            echo "Pushing changes for directory: $dir"
                            doall="true"
                            cp -r "$dir" "$src"
                            ;;
                    esac
                fi
            elif [ "$mode" = "pull" ]; then
                if [ "$doall" = "true" ]; then
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
                            echo "Pulling changes for directory: $dir"
                            doall="true"
                            cp -r "$src$dir" ./
                            ;;
                    esac
                fi
            fi
        fi
    done
done

