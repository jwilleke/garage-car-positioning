#!/bin/bash
# Flash esphome/connect.yaml using the device's MAC address as its name.
# Usage: ./utility/connect.sh [/dev/cu.usbmodemXXXX]

set -e

DEVICE="${1:-/dev/cu.usbmodem31101}"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG="$REPO_ROOT/esphome/connect.yaml"

echo "Reading MAC address from $DEVICE..."

MAC_RAW=$(esptool.py --port "$DEVICE" chip_id 2>&1 | grep -oE "([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}" | tail -1)

if [ -z "$MAC_RAW" ]; then
  echo "ERROR: Could not read MAC address from device."
  echo "Make sure the device is connected and the port is correct."
  exit 1
fi

# Hostname: lowercase with hyphens  e.g. 98-a3-16-b1-c3-fc
DEVICE_NAME=$(echo "$MAC_RAW" | tr '[:upper:]' '[:lower:]' | tr ':' '-')

# Friendly name: uppercase with colons  e.g. 98:A3:16:B1:C3:FC
FRIENDLY_NAME=$(echo "$MAC_RAW" | tr '[:lower:]' '[:upper:]')

echo "MAC Address : $FRIENDLY_NAME"
echo "Device name : $DEVICE_NAME"
echo ""

cd "$REPO_ROOT"
esphome -s device_name "$DEVICE_NAME" -s friendly_name "$FRIENDLY_NAME" \
  run "$CONFIG" --device "$DEVICE"
