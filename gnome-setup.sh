# Configure extentions

# gnome-shell-extension-blur-my-shell
gnome-extensions enable blur-my-shell@aunetx

# gnome-shell-extension-pano-git
gnome-extensions enable pano@elhan.io

# gnome-shell-extension-dash-to-dock
gnome-extensions enable gsconnect@andyholmes.github.io

# tos-shell
gnome-extensions enable tos@odex.be

# TODO: COnfigure keybindings and settings of the extentions
# settings options are stored in org.gnome.shell.extensions.*


# Blur-my-shell disable dash-to-dock
gsettings set org.gnome.shell.extensions.blur-my-shell dash-to-dock-blur "false"

# pano
gsettings set org.gnome.shell.extensions.pano history-length "50"
gsettings set org.gnome.shell.extensions.pano shortcut "['<Super>u']"


# setup keybindings
for i in {1..9}; do
	gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-"$i" "['<Super><Shift>$i']"
	gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-"$i" "['<Super>$i']"
	gsettings set org.gnome.shell.keybindings switch-to-application-"$i" "[]"
done

gsettings set org.gnome.mutter.keybindings toggle-tiled-left "['<Alt><Super>Left']"
gsettings set org.gnome.mutter.keybindings toggle-tiled-right "['<Alt><Super>Right']"

# Open search
gsettings set org.gnome.settings-daemon.plugins.media-keys search "['<Super>d']"
# Open settings
gsettings set org.gnome.settings-daemon.plugins.media-keys control-center "['<Super>s']"
# Kill window
gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q']"
# Open notification center
gsettings set org.gnome.shell.keybindings toggle-message-tray "['<Super>x']"

# TODO: Fullscreen application

# Lock device
gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "['<Super>l']"

# Audio player settings
gsettings set org.gnome.settings-daemon.plugins.media-keys next "['<Super>n']"
gsettings set org.gnome.settings-daemon.plugins.media-keys play  "['<Super>t']"
gsettings set org.gnome.settings-daemon.plugins.media-keys previous  "['<Super>l']"


gsettings set org.gnome.desktop.notifications show-in-lock-screen "true"
gsettings set org.gnome.desktop.wm.preferences num-workspaces "9"


# Set the background image
gsettings set org.gnome.desktop.background picture-uri "file:///usr/share/backgrounds/gnome/blobs-l.svg"
gsettings set org.gnome.desktop.background picture-uri-dark "file:///usr/share/backgrounds/gnome/blobs-d.svg"


# Custome keybinding
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/','/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "Launch Terminal"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "gnome-terminal"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "<Super><Return>"

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "Launch Emoji's"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "gnome-characters"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "<Super>M"

