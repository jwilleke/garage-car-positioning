# ESP32-C6 DevKit Details

I used the ESPRESSIF brand model: X003L5ZDBX ESP32-C6-DevKit-1-N8

[ESP32-C6 DevKit full docunmnetation](https://docs.espressif.com/projects/esp-dev-kits/en/latest/esp32c6/esp32-c6-devkitc-1/index.html)

## esp32-c6-devkitc-1

TOP

### Left Side (J1)

| Screw# | Pin Label | Primary Function | Secondary Functions | Component Connection |
| ---- | ---- | ---- | ---- | ---- |
| 1 | 3V3 | Power | 3.3V Power Supply Output | Provide 3.3V to all 3.3V components |
| 2 | RST | Reset | CHIP_PU (High: Enable; Low: Reset) | NC |
| 3 | 4 | GPIO4 | "MTMS, LP_GPIO4, ADC1_CH4, SDIO" | ⚠️ JTAG PIN - AVOID |
| 4 | 5 | GPIO5 | "MTDI, LP_GPIO5, ADC1_CH5, SDIO" | ⚠️ JTAG PIN - AVOID |
| 5 | 6 | GPIO6 | "MTCK , LP_GPIO6, LP_I2C_SDA, ADC1_CH6" | ⚠️ JTAG PIN - AVOID |
| 6 | 7 | GPIO7 | "MTDO , LP_GPIO7, LP_I2C_SCL, FSPID" | ⚠️ JTAG PIN - AVOID |
| 7 | 0 | GPIO0 | "XTAL_32K_P,  LP_GPIO0,  LP_UART_DTRN, ADC1_CH0" | WS2812B LED Strip - Data In (DIN) |
| 8 | 1 | GPIO1 | "XTAL_32K_N, LP_GPIO1, LP_UART_DSRN, ADC1_CH1" | Closed Door Switch Signal WHT-???- Use internal pull-up. Connect other leg to GND. |
| 9 | 8 | GPIO8 | "RGB LED, ROM, BOOT Strapping Pin" -  ⚠️ Avoid (if possible) | NC |
| 0 | 10 | GPIO10 | General Purpose IO | Relay Module - IN |
| 1 | 11 | GPIO11 | General Purpose IO | NC |
| 2 | 2 | GPIO2 | "LP_GPIO2, LP_UART_RTSN, ADC1_CH2, FSPIQ" | HES-A (BRN-BLK wire) |
| 3 | 3 | GPIO3 | "LP_GPIO3, LP_UART_CTSN, ADC1_CH3" | HES-B (ORG-BLK wire) |
| 4 | 5V | Power | 5V Power Supply (Input or Output) | Provide 5V to all 5V components. |
| 5 | GND | Ground | Common Ground | Common ground for all components. |
| 6 | - | - | NC to Chip Board only | NC |

### Right Side (J3)

| Screw# | Pin Label | Primary Function | Secondary Functions | Component Connection |
| ---- | ---- | ---- | ---- | ---- |
| 1 | G | Ground | Common Ground | Common ground for all components. |
| 2 | TX | GPIO16 | "U0TXD, FSPICS0" | Front LD2450 TX (ESP32 RX) - PUR-WHT wire |
| 3 | RX | GPIO17 | "U0RXD, FSPICS1" | Front LD2450 RX (ESP32 TX) - YEL-RED wire |
| 4 | 15 | GPIO15 | JTAG Function | NC |
| 5 | 23 | GPIO23 | SDIO_DATA3 | NC |
| 6 | 22 | GPIO22 | SDIO_DATA2 | NC |
| 7 | 21 | GPIO21 | "SDIO_DATA1, FSPICS5" | NC |
| 8 | 20 | GPIO20 | "SDIO_DATA0, FSPICS4" | NC |
| 9 | 19 | GPIO19 | "SDIO_CLK, FSPICS3" | Rear LD2450 RX (ESP32 TX) - YEL-RED wire |
| 0 | 18 | GPIO18 | "SDIO_CMD, FSPICS2" | Rear LD2450 TX (ESP32 RX) - BLU-WHT wire |
| 1 | 9 | GPIO9 | BOOT Strapping Pin Avoid (if possible) | NC |
| 2 | 13 | GPIO13 | USB_D+ | ⚠️ JTAG PIN - AVOID - Permanently tied to USB Serial/JTAG controller |
| 3 | 12 | GPIO12 | USB_D- | ⚠️ JTAG PIN - AVOID - Permanently tied to USB Serial/JTAG controller |
| 4 | G | Ground | Common Ground | Common ground for all components. |
| 5 | - | - | NC | NC |
| 6 | - | - | NC to Chip Board only | NC |

## LD2450 Sensor Wiring

Using JST ZH 1.5mm 4Pin connector (see [LD2450 documentation](LD2450/LD2450.md)).

### Front LD2450

| Wire Color | c Pin | Connect To |
| ---- | ---- | ---- |
| BLK-BLU-RED | 5V | ESP32-C6 5V |
| RED-ORG-YEL | RX | ESP32-C6 GPIO17 (RX) (GPIO19) |
| WHT-WHT-BLU | TX | ESP32-C6 GPIO16 (TX) (GPIO18) |
| YEL-YEL--GRN | GND | ESP32-C6 GND |

### Rear LD2450

| Wire Color | LD2450 Pin | Connect To |
| ---- | ---- | ---- |
| BLACK | 5V | ESP32-C6 5V |
| RED | RX | ESP32-C6 GPIO19 |
| WHITE | TX | ESP32-C6 GPIO18 |
| YELLOW | GND | ESP32-C6 GND |

## WS2812B LED Strip Wiring

Using external 5V power supply (required for strips >30 LEDs).

| Wire | Connect To |
| ---- | ---- |
| LED Strip VCC (Red) | External 5V PSU (+) |
| LED Strip GND (White/Black) | External 5V PSU (-) AND ESP32-C6 GND |
| LED Strip DIN (Green) | ESP32-C6 GPIO0 |

Important: The GND must be shared between the ESP32-C6 and the external power supply.

```
External 5V PSU (+) ─────────── VCC (LED Strip)
External 5V PSU (-) ──┬──────── GND (LED Strip)
                      │
ESP32-C6 GND ─────────┘
ESP32-C6 GPIO0 (L-PIN 10) ──────────────── DIN (LED Strip)
```

## Relay Module Wiring

Using 5V Relay Module with High/Low Trigger Jumper. Set jumper to **H** (HIGH trigger).

| Relay Pin | Connect To |
| ---- | ---- |
| VCC | External 5V PSU (+) |
| GND | External 5V PSU (-) AND ESP32-C6 GND |
| IN | ESP32-C6 GPIO10 |
| Jumper | **H** (HIGH trigger) |
| NO | Garage door opener wall button terminal |
| COM | Garage door opener wall button terminal |

Important: The GND must be shared between the ESP32-C6 and the external power supply.

```
External 5V PSU (+) ─────────── VCC (Relay)
External 5V PSU (-) ──┬──────── GND (Relay)
                      │
ESP32-C6 GND ─────────┘
ESP32-C6 GPIO10 ───────────────── IN (Relay)

Relay NO ──┬─────────────────── Garage Door Opener
Relay COM ─┘                    Wall Button Terminals
```

## GPIO Stability and Noise on ESP32-C6-DevKit-1-N8

The noise you are experiencing on GPIO 4, 5, and 6 is primarily due to these pins being multiplexed with the JTAG debug interface (MTMS, MTDI, and MTCK respectively) [Source](cite://https://docs.espressif.com/projects/esp-dev-kits/en/latest/esp32c6/esp32-c6-devkitc-1/user_guide.html). These pins often have internal pull-up or pull-down resistors enabled by default or are sampled by the hardware during boot and debugging, which can cause signal instability or "ghost" toggling when connected directly to 3.3V without proper software configuration [Source](cite://https://www.studiopieters.nl/esp32-c6-pinout/). For high-stability digital or analog signals, it is recommended to use "clean" GPIOs that are not shared with JTAG, USB, or Strapping functions [Source](cite://https://nuttx.apache.org/docs/latest/platforms/risc-v/esp32c6/boards/esp32c6-devkitc/index.html).

### Key Findings

- JTAG Conflict: GPIO 4, 5, 6, and 7 are the default JTAG pins; they may remain active unless explicitly disabled in the firmware [Source](cite://https://docs.espressif.com/projects/esp-dev-kits/en/latest/esp32c6/esp32-c6-devkitc-1/user_guide.html).
- Strapping Pins: GPIO 8 and 9 are used for boot mode configuration; pulling these to 3.3V or Ground incorrectly can prevent the chip from booting [Source](cite://https://www.studiopieters.nl/esp32-c6-pinout/).
- USB Pins: GPIO 12 and 13 are dedicated to the internal USB-Serial/JTAG controller and should be avoided for general I/O if USB functionality is used [Source](cite://https://nuttx.apache.org/docs/latest/platforms/risc-v/esp32c6/boards/esp32c6-devkitc/index.html).
- Stable Alternatives: GPIO 0, 1, 2, and 3 (Low Power pins) and GPIO 18 through 23 are generally the most stable for general-purpose use [Source](cite://https://www.cnx-software.com/2023/01/12/esp32-c6-wifi-6-ble-802-15-4-module-development-board/).
- ADC Noise: If using these pins for Analog-to-Digital conversion, the ESP32-C6 series requires software multisampling or hardware decoupling to manage inherent ADC noise [Source](cite://https://docs.espressif.com/projects/esp-dev-kits/en/latest/esp32c6/esp32-c6-devkitc-1/user_guide.html).

![cite-image://ESP32-C6-DevKitC-1 v1.2 - ESP32-C6 - — esp-dev-kits latest](https://docs.espressif.com/projects/esp-dev-kits/en/latest/esp32c6/_images/esp32-c6-devkitc-1-v1.2-annotated-photo.png)

### Details

#### The JTAG Problem

GPIO 4 (MTMS), GPIO 5 (MTDI), and GPIO 6 (MTCK) are part of the hardware debugging port. Even if you are not using an external debugger, the internal JTAG circuitry can interfere with the pin state. If these pins must be used, you should ensure that JTAG is disabled in your `menuconfig` or code to release them for standard GPIO use [Source](cite://https://docs.espressif.com/projects/esp-dev-kits/en/latest/esp32c6/esp32-c6-devkitc-1/user_guide.html).

#### Recommended Stable Pins

For the most reliable 3.3V logic signals, prioritize these pins:

| Pin Type | GPIO Numbers | Notes |
| --- | --- | --- |
| General Purpose | 18, 19, 20, 21, 22, 23 | No special boot or debug functions. |
| Low Power (LP) | 0, 1, 2, 3 | Can be used in deep sleep; very stable for simple triggers. |
| Avoid (if possible) | 8, 9 | Strapping pins; state at boot is critical. |
| Avoid (if possible) | 12, 13 | USB D-/D+ pins; used for flashing/serial. |

[Source](cite://https://www.studiopieters.nl/esp32-c6-pinout/) [Source](cite://https://nuttx.apache.org/docs/latest/platforms/risc-v/esp32c6/boards/esp32c6-devkitc/index.html)

#### Hardware Mitigation for Noise

If you are seeing "noise" when a pin is tied to 3.3V, it may be due to the DevKit's onboard LDO regulator ripple or electromagnetic interference (EMI).

- Decoupling: Add a small ceramic capacitor ```($$0.1\mu F$$)``` between the GPIO pin and Ground to filter high-frequency noise.
- External Pull-ups: Instead of relying on internal pull-ups ```(which are weak, typically $$30k\Omega$$ to $$80k\Omega$$)```, use an external ```$$4.7k\Omega$$ or $$10k\Omega$$``` resistor to 3.3V.

### Practical Takeaway

- Switch Pins: Move your 3.3V connections to GPIO 18, 19, or 20 for the best stability without software overhead [Source](cite://https://www.studiopieters.nl/esp32-c6-pinout/).
- Disable JTAG: If you must use GPIO 4-6, add `gpio_reset_pin(GPIO_NUM_4);` (in ESP-IDF) or ensure the pin mode is explicitly set to `INPUT` or `OUTPUT` in Arduino to override default JTAG behaviors [Source](cite://https://docs.espressif.com/projects/esp-dev-kits/en/latest/esp32c6/esp32-c6-devkitc-1/user_guide.html).
- Check Strapping: Ensure you are not accidentally pulling GPIO 9 LOW during boot, as this will put the device into "Download Mode" instead of running your code [Source](cite://https://www.studiopieters.nl/esp32-c6-pinout/).
- Filter the Rail: If the noise persists across all pins, the 3.3V rail itself might be noisy; try powering the sensors/inputs from an external filtered 3.3V source rather than the DevKit's 3.3V pin.

## Other ESP32-C6-DevKit Components

- 3.3 V Power On (RED) LED - Turns on when the USB power is connected to the board.
- USB-to-UART Bridge - Single USB-to-UART bridge chip provides transfer rates up to 3 Mbps.
- ESP32-C6 USB Type-C Port The USB Type-C port on the ESP32-C6 chip compliant with USB 2.0 full speed.
  - It is capable of up to 12 Mbps transfer speed (Note that this port does not support the faster 480 Mbps high-speed transfer mode).
  - This port is used for power supply to the board, for flashing applications to the chip, for communication with the chip using USB protocols, as well as for JTAG debugging.
- Boot Button - Download button. Holding down Boot and then pressing Reset initiates Firmware Download mode for downloading firmware through the serial port.
- Reset Button - Press this button to restart the system.
- USB Type-C to UART Port Used for power supply to the board
  - for flashing applications to the chip
  - as well as the communication with the ESP32-C6 chip via the on-board USB-to-UART bridge.
- RGB LED - Addressable RGB LED, driven by GPIO8.
- J5 Used for current measurement. See details in Section Current

## Dhip ID

```zsh
esptool --port /dev/cu.usbmodem31101 chip-id

esptool v5.1.0
Connected to ESP32-C6 on /dev/cu.usbmodem31101:
Chip type:          ESP32-C6 (QFN40) (revision v0.2)
Features:           Wi-Fi 6, BT 5 (LE), IEEE802.15.4, Single Core + LP Core, 160MHz
Crystal frequency:  40MHz
USB mode:           USB-Serial/JTAG
MAC:                98:a3:16:ff:fe:b1:d0:88
BASE MAC:           98:a3:16:b1:d0:88
MAC_EXT:            ff:fe

Stub flasher running.

Warning: ESP32-C6 has no chip ID. Reading MAC address instead.
MAC:                98:a3:16:ff:fe:b1:d0:88
BASE MAC:           98:a3:16:b1:d0:88
MAC_EXT:            ff:fe

Hard resetting via RTS pin...
```
