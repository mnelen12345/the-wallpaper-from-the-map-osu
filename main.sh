#!/bin/bash

FOLDER_PATH="Path/to/folder/osu!/Songs/"
LAST_WALLPAPERS_FILE="/home/$USER/.last_wallpapers"

get_random_image() {
    local installed_wallpapers=()
    if [[ -f "$LAST_WALLPAPERS_FILE" ]]; then
        readarray -t installed_wallpapers < "$LAST_WALLPAPERS_FILE"
    fi

    local images=()
    while IFS= read -r -d '' file; do
        if ! [[ " ${installed_wallpapers[@]} " =~ " ${file} " ]]; then
            images+=("$file")
        fi
    done < <(find "$FOLDER_PATH" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) -print0)

    if [[ ${#images[@]} -eq 0 ]]; then
        echo "There are no PNG, JPG or JPEG files not previously installed in the specified folder and its subfolders."
        exit 1
    fi

    local random_image="${images[RANDOM % ${#images[@]}]}"
    echo "$random_image"
}

set_wallpaper() {
    local image_path="$1"
    local transition_type="$2"
    echo "Transfer to swww: swww img '$image_path' --transition-type $transition_type"
    swww img "$image_path" --transition-type "$transition_type"
}

update_last_wallpapers() {
    local last_wallpapers=()
    if [[ -f "$LAST_WALLPAPERS_FILE" ]]; then
        readarray -t last_wallpapers < "$LAST_WALLPAPERS_FILE"
    fi

    local current_image="$1"
    local previous_image=""

    if [[ ${#last_wallpapers[@]} -ge 1 ]]; then
        previous_image="${last_wallpapers[0]}"
    fi

    echo "$current_image" > "$LAST_WALLPAPERS_FILE"

    if [[ -n "$previous_image" ]]; then
        echo "$previous_image" >> "$LAST_WALLPAPERS_FILE"
    fi
}

main() {
    if [[ "$1" == "-last" ]]; then
        local last_wallpapers=()
        if [[ -f "$LAST_WALLPAPERS_FILE" ]]; then
            readarray -t last_wallpapers < "$LAST_WALLPAPERS_FILE"
        fi

        if [[ ${#last_wallpapers[@]} -ge 2 ]]; then
            local previous_image="${last_wallpapers[1]}"
            if [[ -f "$previous_image" ]]; then
                set_wallpaper "$previous_image" "outer"
                echo "Restoring a previously installed image: $previous_image"
            else
                echo "Previously installed image not found: $previous_image"
                exit 1
            fi
        else
            echo "Not enough previous installed images in the file: $LAST_WALLPAPERS_FILE"
            exit 1
        fi
    else
        selected_image="$(get_random_image)"

        if [[ -f "$selected_image" ]]; then
            set_wallpaper "$selected_image" "center"
            
            update_last_wallpapers "$selected_image"

            echo "The image is set: $selected_image"
        else
            echo "The selected image does not exist: $selected_image"
            exit 1
        fi
    fi
}

main "$@"
