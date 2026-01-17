# calc_encoder.py
import math
import sys

def calculate(diameter):
    # Calculations 📐
    circumference = math.pi * diameter
    # Target is roughly 0.5 inches per count
    # Since quadrature gives 4 counts per magnet:
    num_magnets = round(circumference / (0.5 * 4))
    num_magnets = max(num_magnets, 2)
    
    spacing = circumference / num_magnets
    offset = spacing / 4
    
    # Door Resolution: How many inches the door moves per 1 count
    # There are (num_magnets * 4) counts per full revolution
    resolution = circumference / (num_magnets * 4)
    
    print(f"\n--- Results for {diameter}\" Wheel ---")
    print(f"🧲 Magnets Needed:     {num_magnets}")
    print(f"📏 Magnet Spacing:    {spacing:.3f}\" (center-to-center)")
    print(f"📡 Sensor Offset:     {offset:.3f}\" (dist. between Sensor A & B)")
    print(f"🎯 Door Resolution:   {resolution:.3f}\" per count")
    print(f"---------------------------------")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        try:
            calculate(float(sys.argv[1]))
        except ValueError:
            print("Please provide a number for the diameter.")
    else:
        print("Usage: python3 calc_encoder.py [diameter]")