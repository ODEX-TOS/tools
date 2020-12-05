echo "Gathering system info..."


OS=$(cat /etc/os-release | grep "^NAME" | cut -d"=" -f2 | tr -d '"')

CPU_USAGE="$(ps aux | awk '{count+=$3}END{printf count}')"
CORES=$(grep -E "cpu[0-9]+" /proc/stat | wc -l)

MEM_USAGE="$(ps aux | awk '{count+=$4}END{printf count}')"
MEM_SIZE="$(free -h | awk 'NR==2{printf $2}')"

PACKAGES="$(pacman -Q | wc -l)"

DESKTOP="$XDG_SESSION_DESKTOP"
WINDOWING_SYSTEM=$(ps -aux | grep -q "Xorg" && echo "X11" || echo "Wayland")

clear

echo -e "OS: \t\t\t\t $OS"
echo
echo -e "CPU Usage: \t\t\t $CPU_USAGE%"
echo -e "CPU Cores: \t\t\t $CORES"
echo -e "MEMORY Usage: \t\t\t $MEM_USAGE%"
echo -e "Memory size: \t\t\t $MEM_SIZE"
echo
echo -e "Packages installed: \t\t $PACKAGES"
echo
echo -e "Desktop: \t\t\t $DESKTOP"
echo -e "Windowing system: \t\t $WINDOWING_SYSTEM"
read


