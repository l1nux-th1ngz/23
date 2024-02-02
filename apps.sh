#!/bin/bash

# Install packages
yay -S --noconfirm \
    gdb ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite wlroots slurp xorg-xinput libxrender pixman wayland-protocols cairo pango seatd libxkbcommon xcb-util-wm xorg-xwayland libinput libliftoff libdisplay-info cpio tomlplusplus \
    grimblast-git sddm-git hyprpicker-git waybar-hyprland-git hyprland wl-clipboard wf-recorder wofi wlogout swaylock-effects dunst qt5base qt6base swaybg kitty rofi-lbonn-wayland hyprshotgun neofetch btop htop gtk2 gtk3 gtk4 layer-shell-gtk cliphist imv layer-shell-qt \
    ttf-nerd-fonts-symbols-common otf-firamono-nerd inter-font otf-sora ttf-fantasque-nerd noto-fonts noto-fonts-emoji ttf-comfortaa ttf-jetbrains-mono-nerd ttf-icomoon-feather ttf-iosevka-nerd adobe-source-code-pro-fonts upower aalurs-gtk-shell eww-wayland \
    dracula-icons-git ranger kora-icon-theme-git ranger_devicons-git gruvbox-dark-icons-gtk gruvbox-plus-icon-theme-git papirus-icon-theme aalib ascii font-manager fontconfig gjs glib2 libpulse pam typescript libnotify  libsoup3 power-profiles-daemon \
    kvantum-theme-catppuccin-git nordic-theme starship goober python-requests zenity yad multilib-devel tk base-devel networkmanager network-manager-applet nano nm-connection-editor dconf libexif mpv vlc nano-syntax-highlighting libdecor libva \
    go python nodejs archiso archinstall arch-install-scripts geany geany-plugins alacritty archlinux-contrib jq gobject-introspection firefox reflector reflector-simple python-pyaml python-pipx python-pip python-pyperclip python-click python-rich \
    npm wlsunset mpv vlc nano-syntax-highlighting qt5ct qt6ct gifsicle lz4 wlr-randr

# Wait for package installation
sleep 45
echo -ne '>>>>>>>                   [40%]\r'
sleep 2
echo -ne '>>>>>>>>>>>>>>            [60%]\r'
sleep 2
echo -ne '>>>>>>>>>>>>>>>>>>>>>>>   [80%]\r'
sleep 2
echo -ne '>>>>>>>>>>>>>>>>>>>>>>>>>>[100%]\r'
echo -ne '\n'

# Update XDG user dirs
xdg-user-dirs-update
echo "All necessary packages installed successfully."

# Install swww
yay -S --noconfirm swww
sleep 8

# Initialize and set path for swww
swww init && swww img home/Wallpapers

# Install Waypaper-engine
yay -S --noconfirm waypaper-engine
sleep 8

# Run waypaper-engine
waypaper-engine
waypaper-engine r --script="$HOME/.config/hypr/scripts"

# Add to hyprland.conf
echo "exec-once=waypaper-engine daemon" >> "$HOME/.config/hypr/hyprland.conf"

# Copy Config Files
printf "Copying config files...\n"
cp -r dunst wofi kitty pipewire rofi swaylock waybar wlogout btop htop eww ags geany ranger alacritty swww waypaper-engine qtct5 qtct6 ~/.config/ 2>&1 | tee -a "$LOG"

# Add Fonts for Waybar
mkdir -p "$HOME/Downloads/nerdfonts/"
cd "$HOME/Downloads/" || exit
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.1/CascadiaCode.zip
unzip '*.zip' -d "$HOME/Downloads/nerdfonts/"
rm -rf *.zip
sudo cp "$HOME/Downloads/nerdfonts/" /usr/share/fonts/
fc-cache -rv

# Enable SDDM Autologin
echo -e "Enabling SDDM service...\n"
sudo systemctl enable sddm
sleep 3

# BLUETOOTH
blue_pkgs="bluez bluez-utils blueman"
if ! yay -S --noconfirm "$blue_pkgs" 2>&1 | tee -a "$LOG"; then
    printf "Activating Bluetooth Services...\n"
    sudo systemctl enable --now bluetooth.service
    sleep 2
fi

# Disable systemd services and enable NetworkManager
systemctl disable systemd-resolved
sleep 2
systemctl disable systemd-networkd
sleep 2
systemctl enable NetworkManager
sleep 4
systemctl start NetworkManager
sleep 4

# Script completed
printf "\n${GREEN}Installation Completed.\n"
