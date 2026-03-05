#!/bin/bash
# ==========================================
# LAPTOP CHECKER v1.0
# Checks CPU, GPU, RAM, Storage, Battery
# Works on Ubuntu/Mint/Debian, Arch/Manjaro, Fedora, openSUSE
# ==========================================

# Usage:
# chmod +x meetup-check.sh
# ./meetup-check.sh [-y]

echo "Distro: $(hostnamectl | grep 'Operating System' | cut -d: -f2 | xargs)"
echo "Kernel: $(uname -r)"

AUTO_INSTALL=false
if [[ $1 == "-y" ]]; then
    AUTO_INSTALL=true
fi

# Require root privileges first
if [[ $EUID -ne 0 ]]; then
    echo "Re-running with sudo..."
    exec sudo "$0" "$@"
fi

OUTPUT_FILE="hardwarecheck-$(date +%Y%m%d-%H%M%S).txt"
exec > >(tee "$OUTPUT_FILE") 2>&1

# ==========================================
# Auto-install required tools if missing
# ==========================================
echo "=========================================="
echo "Checking/installing required tools..."
REQUIRED_TOOLS=(smartctl dmidecode stress upower lscpu lsblk lspci sensors)

install_tool() {
    local tool=$1
    if command -v apt &> /dev/null; then
        echo "Detected apt-based distro"
        $AUTO_INSTALL && apt update && apt install -y $tool || read -p "Install $tool now? [Y/n]: " ans && [[ $ans =~ ^[Yy]$ ]] && apt update && apt install -y $tool
    elif command -v pacman &> /dev/null; then
        echo "Detected pacman-based distro"
        $AUTO_INSTALL && pacman -Sy --noconfirm $tool || read -p "Install $tool now? [Y/n]: " ans && [[ $ans =~ ^[Yy]$ ]] && pacman -Sy --noconfirm $tool
    elif command -v dnf &> /dev/null; then
        echo "Detected Fedora/RHEL"
        $AUTO_INSTALL && dnf install -y $tool || read -p "Install $tool now? [Y/n]: " ans && [[ $ans =~ ^[Yy]$ ]] && dnf install -y $tool
    elif command -v zypper &> /dev/null; then
        echo "Detected openSUSE"
        $AUTO_INSTALL && zypper install -y $tool || read -p "Install $tool now? [Y/n]: " ans && [[ $ans =~ ^[Yy]$ ]] && zypper install -y $tool
    else
        echo "❌ No supported package manager found. Install $tool manually!"
    fi
}

for t in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v $t &> /dev/null; then
        echo "⚠️ $t not found!"
        install_tool $t
    fi
done

echo "=========================================="
echo "🖥️  CPU INFORMATION"
echo "------------------------------------------"
lscpu | grep -E "Architecture|Model name|CPU MHz|Thread|Core"
cat /proc/cpuinfo | grep "model name" | head -1

echo
echo "🔥 CPU STRESS TEST (10 sec quick check)"
echo "------------------------------------------"

# Run stress + sensors, capture output
if command -v stress &> /dev/null && command -v sensors &> /dev/null; then
    # Run stress in background and wait for it to finish
    stress_output=$(stress --cpu $(nproc) --timeout 10 2>&1)
    echo "$stress_output"

    # Read sensors after stress test
    sensors_output=$(sensors 2>/dev/null)
    echo "$sensors_output"
else
    echo "⚠️ stress or sensors not found. Skipping CPU stress test."
fi

# Detect vendor and run specific commands
echo
echo "🎮 GPU INFORMATION"
echo "------------------------------------------"
gpu_info=$(lspci | grep -E "VGA|3D")
echo "$gpu_info"

if echo "$gpu_info" | grep -iq "NVIDIA"; then
    echo "NVIDIA GPU detected"
    if command -v nvidia-smi &> /dev/null; then nvidia-smi; else echo "⚠️ Install NVIDIA drivers for detailed info"; fi
elif echo "$gpu_info" | grep -iq "AMD"; then
    echo "AMD GPU detected"
    if command -v rocm-smi &> /dev/null; then rocm-smi; else echo "⚠️ Install ROCm tools for AMD info"; fi
elif echo "$gpu_info" | grep -iq "Intel"; then
    echo "Intel GPU detected"
    if command -v intel_gpu_top &> /dev/null; then intel_gpu_top -l 1; else echo "⚠️ Install intel-gpu-tools for detailed Intel GPU info"; fi
else
    echo "Unknown GPU vendor. Showing basic info only."
fi

echo
echo "🧠 RAM INFORMATION"
echo "------------------------------------------"
free -h

#Select and comment 1 method for preference, both will work together properly:
#Method 1:
#dmidecode -t memory "Size|Speed|Type|Manufacturer"

#Method 2:
dmidecode -t memory | grep -A5 "Memory Device"

echo
echo "💾 STORAGE INFORMATION"
echo "------------------------------------------"
lsblk -o NAME,SIZE,MODEL

NVME_DEV=$(lsblk -ndo NAME,TYPE | grep disk | grep -E 'nvme|ssd' | awk 'NR==1{print $1}')
if [[ -n $NVME_DEV ]]; then
    echo "SMART DATA for /dev/$NVME_DEV:"
    smartctl -a /dev/$NVME_DEV | grep -E "Model Number|Serial Number|Firmware|Total NVM Capacity|Percentage Used|Power On Hours|Unsafe Shutdowns|Media and Data Integrity Errors"
else
    echo "⚠️ No NVMe/SSD detected for SMART data"
fi

echo
echo "🔋 BATTERY INFORMATION"
echo "------------------------------------------"
BATTERY=$(upower -e | grep BAT)
if [[ -n $BATTERY ]]; then
    upower -i $BATTERY | grep -E "model|native|capacity|percentage|energy|voltage|state|cycle"
else
    echo "No battery detected"
fi

echo
echo "=========================================="
echo "✅ CHECK COMPLETE - REVIEW ABOVE OUTPUT OR QUICK SUMMARY"
echo "=========================================="

echo
echo "=========================================="
echo "✅ QUICK SUMMARY"
echo "CPU: $(lscpu | grep 'Model name' | awk -F: '{print $2}' | xargs)"
echo "RAM: $(free -h | grep Mem | awk '{print $2}')"
echo "GPU: $(echo "$gpu_info" | awk -F: '{print $3}' | xargs)"
if [[ -n $NVME_DEV ]]; then
    SSD_USED=$(smartctl -a /dev/$NVME_DEV | grep 'Percentage Used' | awk -F: '{print $2}' | tr -d ' %')
    SSD_LIFE=$((100 - SSD_USED))
    echo "SSD Wear: ${SSD_USED}% (Life Remaining: ${SSD_LIFE}%)"
fi
if [[ -n $BATTERY ]]; then
    BAT_CAP=$(upower -i $BATTERY | grep 'capacity' | awk -F: '{print $2}' | xargs)
    echo "Battery: $BAT_CAP"
fi
echo "=========================================="

