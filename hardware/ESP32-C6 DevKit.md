# ESP32-C6 DevKit Details

I used the ESPRESSIF brand model: X003L5ZDBX ESP32-C6-DevKit-1-N8


[ESP32-C6 DevKit full docunmnetation](https://docs.espressif.com/projects/esp-dev-kits/en/latest/esp32c6/esp32-c6-devkitc-1/index.html)


## esp32-c6-devkitc-1

TOP 

### Left Side

| Pin Label | Primary Function | Secondary Functions | Component Connection |
|  ---- | ---- | ---- | ---- |
| 3V3 | Power | 3.3V Power Supply Output | Provide 3.3V to all 3.3V components. |
| RST | Reset | CHIP_PU (High: Enable; Low: Reset)  | NC |
| 4 | GPIO4 | "MTMS, LP_GPIO4, ADC1_CH4, SDIO" | Closed Door Switch Signal - Use internal pull-up. Connect other leg to GND. |
| 5 | GPIO5 | "MTDI, LP_GPIO5, ADC1_CH5, SDIO" | Hall Effect Sensor A (black wire) |
| 6 | GPIO6 | "MTCK , LP_GPIO6, LP_I2C_SDA, ADC1_CH6" | Hall Effect Sensor B (black wire) |
| 7 | GPIO7 | "MTDO , LP_GPIO7, LP_I2C_SCL, FSPID" |
| 0 | GPIO0 | "XTAL_32K_P,  LP_GPIO0,  LP_UART_DTRN, ADC1_CH0" |WS2812B LED Strip - Data In (DIN) |
| 1 | GPIO1 | "XTAL_32K_N, LP_GPIO1, LP_UART_DSRN, ADC1_CH1"
| 8 | GPIO8 | "RGB LED, ROM, BOOT Strapping Pin"
| 10 | GPIO10 | General Purpose IO | Relay Module - IN | 
| 11 | GPIO11 | General Purpose IO | NC |
| 2 | GPIO2 | "LP_GPIO2, LP_UART_RTSN, ADC1_CH2, FSPIQ"| NC |
| 3 | GPIO3 | "LP_GPIO3, LP_UART_CTSN, ADC1_CH3" | NC |
| 5V | Power | 5V Power Supply (Input or Output) | Provide 5V to all 5V components. |
| GND | Ground | Common Ground | Common ground for all components. |

### Right Side
| Pin Label | Primary Function | Secondary Functions | Component Connection |
|  ---- | ---- | ---- |
| G | Ground | Common Ground | Common ground for all components. |
| TX | GPIO16 | "U0TXD, FSPICS0" | Front LD2450 TX (ESP32 RX) - Connect to sensor TX pin |
| RX | GPIO17 | "U0RXD, FSPICS1" | Front LD2450 RX (ESP32 TX) - Connect to sensor RX pin |
| 15 | GPIO15 | JTAG Function | NC |
| 23 | GPIO23 | SDIO_DATA3 | NC |
| 22 | GPIO22 | SDIO_DATA2 | NC |
| 21 | GPIO21 | "SDIO_DATA1, FSPICS5" | NC |
| 20 | GPIO20 | "SDIO_DATA0, FSPICS4" | NC |
| 19 | GPIO19 | "SDIO_CLK, FSPICS3" | Rear LD2450 RX (ESP32 TX) - Connect to sensor RX pin |
| 18 | GPIO18 | "SDIO_CMD, FSPICS2" | Rear LD2450 TX (ESP32 RX) - Connect to sensor TX pin |
| 9 | GPIO9 | BOOT Strapping Pin | NC |
| 13 | GPIO13 | USB_D+ | **⚠️ DO NOT USE** - Permanently tied to USB Serial/JTAG controller |
| 12 | GPIO12 | USB_D- | **⚠️ DO NOT USE** - Permanently tied to USB Serial/JTAG controller | 