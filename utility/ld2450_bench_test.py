# ld2450_bench_test.py
#
# Bench-test an HLK-LD2450 over a USB-to-TTL adapter, with no ESP32 involved.
# Written for issue #15 (front sensor offline) to answer one question: does the
# sensor emit valid data frames on its TX pin?
#
# BLE (HLKRadarTool) cannot answer that — it bypasses the UART entirely. This
# puts a known-good receiver directly on the TX pin, so a pass narrows the fault
# to the cable/connector/ESP header and a fail condemns the sensor.
#
# Wiring — READ-ONLY, three wires. Leave the sensor's RED (RX) disconnected so
# a 5 V adapter can never drive the sensor's 3.3 V RX pin.
#
#   LD2450 BLACK  -> 5 V          <-- BLACK is POWER on this connector, not ground
#   LD2450 YELLOW -> GND          <-- YELLOW is GROUND
#   LD2450 WHITE  -> adapter RX   <-- the data path (sensor TX)
#   LD2450 RED    -> leave disconnected
#
# See docs/hardware/LD2450/LD2450.md for the connector pinout and the project
# wiring map, and the protocol PDF in the same directory for frame details.
#
# Usage:
#   python3 utility/ld2450_bench_test.py                    # list ports
#   python3 utility/ld2450_bench_test.py -p /dev/tty.usbserial-0001
#   python3 utility/ld2450_bench_test.py -p COM3 -s 20 --raw
#
# Requires pyserial:  pip install pyserial

import argparse
import sys
import time

try:
    import serial
    from serial.tools import list_ports
except ImportError:
    print("ERROR: pyserial not installed.  Run:  pip install pyserial")
    sys.exit(2)

# Frame layout, mirrored from ESPHome's ld2450 component so a pass here means
# the same bytes the firmware expects.
# 30 bytes total: 4-byte header + 3 targets x 8 bytes + 2-byte footer.
DATA_FRAME_HEADER = b"\xAA\xFF\x03\x00"
DATA_FRAME_FOOTER = b"\x55\xCC"
FRAME_SIZE = 30
TARGET_X = 4          # per-target offsets, target i starts at 4 + i * 8
TARGET_Y = 6
TARGET_SPEED = 8
TARGET_RESOLUTION = 10

MM_PER_INCH = 25.4


def decode_coordinate(low, high):
    """Coordinate in mm.  Sign lives in the high bit: set means positive."""
    value = ((high & 0x7F) << 8) | low
    if (high & 0x80) == 0:
        value = -value
    return value


def decode_speed(low, high):
    """Speed in mm/s.  Same sign convention; the wire value is in cm/s."""
    value = ((high & 0x7F) << 8) | low
    if (high & 0x80) == 0:
        value = -value
    return value * 10


def decode_frame(frame):
    """Return a list of 3 target dicts.  An all-zero target means 'empty slot'."""
    targets = []
    for i in range(3):
        base = i * 8
        x = decode_coordinate(frame[TARGET_X + base], frame[TARGET_X + base + 1])
        y = decode_coordinate(frame[TARGET_Y + base], frame[TARGET_Y + base + 1])
        speed = decode_speed(frame[TARGET_SPEED + base], frame[TARGET_SPEED + base + 1])
        res = (frame[TARGET_RESOLUTION + base + 1] << 8) | frame[TARGET_RESOLUTION + base]
        active = not (x == 0 and y == 0 and speed == 0)
        distance = (x * x + y * y) ** 0.5
        targets.append(
            {"active": active, "x": x, "y": y, "speed": speed,
             "resolution": res, "distance": distance}
        )
    return targets


def show_ports():
    ports = list(list_ports.comports())
    if not ports:
        print("No serial ports found.  Is the USB-TTL adapter plugged in?")
        return
    print("Available serial ports:\n")
    for p in ports:
        print(f"  {p.device:24} {p.description}")
    print("\nRe-run with:  -p <port>")


def run(port, baud, seconds, raw):
    print(f"Opening {port} at {baud} baud ...")

    try:
        ser = serial.Serial(port, baud, timeout=0.5)
    except serial.SerialException as exc:
        print(f"ERROR: could not open {port}: {exc}")
        return 2
    except ValueError:
        # Some adapters/drivers reject non-standard rates outright.
        print(f"ERROR: this adapter/driver rejected {baud} baud.")
        print("256000 is non-standard — try a CP2102, CH340 or FTDI adapter.")
        return 2

    print(f"Listening for {seconds}s.")
    print("Wave a hand in front of the sensor to see targets appear.\n")

    buf = bytearray()
    total_bytes = 0
    good_frames = 0
    bad_frames = 0
    last_print = 0.0
    deadline = time.time() + seconds

    with ser:
        while time.time() < deadline:
            chunk = ser.read(256)
            if not chunk:
                continue
            total_bytes += len(chunk)
            buf.extend(chunk)

            if raw:
                print(chunk.hex(" "))

            # Resync on the header each pass; drop anything ahead of it.
            while True:
                start = buf.find(DATA_FRAME_HEADER)
                if start < 0:
                    # Keep a short tail in case a header straddles two reads.
                    if len(buf) > FRAME_SIZE * 2:
                        del buf[:-len(DATA_FRAME_HEADER)]
                    break
                if start > 0:
                    del buf[:start]
                if len(buf) < FRAME_SIZE:
                    break

                frame = bytes(buf[:FRAME_SIZE])
                del buf[:FRAME_SIZE]

                if frame[-2:] != DATA_FRAME_FOOTER:
                    bad_frames += 1
                    continue

                good_frames += 1
                now = time.time()
                if not raw and now - last_print >= 0.5:
                    last_print = now
                    targets = decode_frame(frame)
                    active = [t for t in targets if t["active"]]
                    if not active:
                        print("  no targets")
                    for i, t in enumerate(targets):
                        if not t["active"]:
                            continue
                        print(
                            f"  T{i + 1}: "
                            f"x={t['x']:6d}mm ({t['x'] / MM_PER_INCH:7.1f}in)  "
                            f"y={t['y']:6d}mm ({t['y'] / MM_PER_INCH:7.1f}in)  "
                            f"dist={t['distance'] / MM_PER_INCH:6.1f}in  "
                            f"speed={t['speed']:5d}mm/s"
                        )

    return verdict(total_bytes, good_frames, bad_frames, baud)


def verdict(total_bytes, good_frames, bad_frames, baud):
    print("\n" + "-" * 58)
    print(f"bytes received : {total_bytes}")
    print(f"valid frames   : {good_frames}")
    print(f"malformed      : {bad_frames}")
    print("-" * 58)

    if good_frames > 0:
        print("\nPASS — the sensor is emitting valid LD2450 data frames.")
        print("Its TX pin and radar are good.  For #15 that moves the fault")
        print("downstream: the cable run, the connection block, or the ESP header.")
        return 0

    if total_bytes == 0:
        print("\nFAIL — nothing arrived on the line at all.")
        print("Check, in this order:")
        print("  - adapter RX is on the sensor's WHITE (TX) wire")
        print("  - BLACK is on 5 V and YELLOW on GND (this connector is inverted)")
        print("  - the adapter itself works (short its own TX to RX and type)")
        print("If all three are right, the sensor's TX pin is dead — replace it.")
        return 1

    print(f"\nINCONCLUSIVE — {total_bytes} bytes arrived but no valid frames.")
    print("That pattern is data at the wrong baud rate, not a dead sensor.")
    print(f"Confirm the sensor is set to {baud} in HLKRadarTool, or re-run with")
    print("--baud 115200 / 230400 to check whether it was reconfigured.")
    return 1


def main():
    ap = argparse.ArgumentParser(
        description="Bench-test an HLK-LD2450 over USB-TTL, no ESP32 required."
    )
    ap.add_argument("-p", "--port", help="serial port; omit to list available ports")
    ap.add_argument("-b", "--baud", type=int, default=256000,
                    help="baud rate (default 256000, the LD2450 factory setting)")
    ap.add_argument("-s", "--seconds", type=int, default=10,
                    help="how long to listen (default 10)")
    ap.add_argument("--raw", action="store_true",
                    help="hex-dump every byte instead of decoding targets")
    args = ap.parse_args()

    if not args.port:
        show_ports()
        return 0

    return run(args.port, args.baud, args.seconds, args.raw)


if __name__ == "__main__":
    sys.exit(main())
