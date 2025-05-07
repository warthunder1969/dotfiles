#!/bin/bash

# Function to set the governor and adjust frequencies
set_governor_and_frequencies() {
  local cpu=$1
  local governor=$2
  local max_freq_percentage=$3

  # Get the minimum and maximum frequencies for the CPU
  local min_freq=$(cat /sys/devices/system/cpu/cpu$cpu/cpufreq/cpuinfo_min_freq)
  local max_freq=$(cat /sys/devices/system/cpu/cpu$cpu/cpufreq/cpuinfo_max_freq)

  # Calculate the desired maximum frequency based on the percentage
  local max_freq_adjusted=$((max_freq * max_freq_percentage / 100))

  # Set the CPU governor
  echo $governor > "/sys/devices/system/cpu/cpu$cpu/cpufreq/scaling_governor"

  # Set the minimum frequency and adjusted maximum frequency
  echo $min_freq > "/sys/devices/system/cpu/cpu$cpu/cpufreq/scaling_min_freq"
  echo $max_freq_adjusted > "/sys/devices/system/cpu/cpu$cpu/cpufreq/scaling_max_freq"
}

# Check if the script is run as root (required to change CPU governor)
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root or with sudo."
  exit 1
fi

# Menu options
echo "Select CPU mode:"
echo "1) Performance"
echo "2) Ondemand-Performance"
echo "3) Ondemand-Powersave"
echo "4) Powersave"

# Read user input
read -p "Enter your choice [1-4]: " choice

# Apply settings based on user choice
case $choice in
  1)
    echo "Setting CPU mode to 'performance'"
    for ((cpu=0; cpu<$(nproc); cpu++)); do
      set_governor_and_frequencies $cpu "performance" 100
    done
    echo "CPU governor set to 'performance' and frequencies adjusted for all cores."
    ;;
  2)
    echo "Setting CPU mode to 'ondemand/performance'"
    for ((cpu=0; cpu<$(nproc); cpu++)); do
      set_governor_and_frequencies $cpu "ondemand" 100
    done
    echo "CPU governor set to 'ondemand/performance' and frequencies adjusted for all cores."
    ;;
  3)
    echo "Setting CPU mode to 'ondemand/powersave'"
    for ((cpu=0; cpu<$(nproc); cpu++)); do
      set_governor_and_frequencies $cpu "ondemand" 50
    done
    echo "CPU governor set to 'ondemand/powersave' and frequencies adjusted for all cores."
    ;;
  4)
    echo "Setting CPU mode to 'powersave'"
    for ((cpu=0; cpu<$(nproc); cpu++)); do
      set_governor_and_frequencies $cpu "powersave" 25
    done
    echo "CPU governor set to 'powersave' and frequencies adjusted for all cores."
    ;;
  *)
    echo "Invalid choice"
    exit 1
    ;;
esac
