# the wallpaper from the map osu

This script takes the backgrounds of maps from the osu!/Songs folder and sets them as wallpaper

## Installation

1. Clone the repository or download the script:

    ```bash
    git clone https://github.com/mnelen12345/the-wallpaper-from-the-map-osu.git
    cd the-wallpaper-from-the-map-osu
    ```

2. Make the script executable:

    ```bash
    chmod +x main.sh
    ```

3. Move the script to the `~/.config/hypr/` directory:

    ```bash
    mv main.sh ~/.config/hypr/
    ```
4. Add the following lines to the Hyprland configuration file (~/.config/hypr/hyprland.conf):

    ```bash
    bind = $mainMod, left, exec, ~/.config/hypr/main.sh -last
    bind = $mainMod, right, exec, ~/.config/hypr/main.sh
    ```

## Usage
> [!Warning]
> before use, specify the path to the osu!/Songs/ folder in `FOLDER_PATH="Path/to/folder/osu!/Songs/"`

  - **Win + Left**: Set the previous wallpaper 
  - **Win + Right**: Set the next wallpaper
