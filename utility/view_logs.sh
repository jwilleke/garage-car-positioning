#!/bin/bash
# Script to view ESP32 device logs

cd "$(dirname "$0")/esphome"

echo "ESP32 Garage All-in-One - Log Viewer"
echo "====================================="
echo ""
echo "Choose connection method:"
echo "  [1] USB Serial (/dev/cu.usbmodem31201)"
echo "  [2] Over The Air (esp32-garage-all-in-one.local)"
echo ""
read -p "Enter choice [1 or 2]: " choice

if [ "$choice" = "1" ]; then
    echo ""
    echo "Connecting via USB..."
    echo "Press Ctrl+C to stop"
    echo ""
    esphome logs all-in-one.yaml --device /dev/cu.usbmodem31201
elif [ "$choice" = "2" ]; then
    echo ""
    echo "Connecting via OTA..."
    echo "Press Ctrl+C to stop"
    echo ""
    esphome logs all-in-one.yaml
else
    echo "Invalid choice. Exiting."
    exit 1
fi
