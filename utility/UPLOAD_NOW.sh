#!/bin/bash
# Quick upload script - run this AFTER putting device in bootloader mode

cd "$(dirname "$0")/esphome"

echo "========================================="
echo "ESP32-C6 Firmware Upload"
echo "========================================="
echo ""
echo "IMPORTANT: Put device in bootloader mode first!"
echo "  1. Hold BOOT button"
echo "  2. Press and release RESET (while holding BOOT)"
echo "  3. Release BOOT button"
echo ""
read -p "Press Enter when device is in bootloader mode..."

echo ""
echo "Uploading firmware..."
esphome upload all-in-one.yaml --device /dev/cu.usbmodem31201

echo ""
echo "========================================="
echo "Upload complete!"
echo ""
echo "Next: Check logs immediately:"
echo "  esphome logs all-in-one.yaml --device /dev/cu.usbmodem31201"
echo ""
echo "Or look for WiFi AP: garage-aio"
echo "========================================="
