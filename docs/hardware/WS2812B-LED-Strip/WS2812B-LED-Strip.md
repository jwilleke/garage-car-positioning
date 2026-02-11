# WS2812B LED Strip

- Individually Addressable LED Strip: You can control each LED individually!
- Each SMD 5050 LED has an integrated driver IC that allows you to control color and brightness independently or add sophisticated lighting effects to your project.
- 256-bit luminance displays and 24-bit color display.
- Chasing Lighting, Rainbow, Fire, Meteor, rhythm, etc all kinds of scenes and special effects.

## Features & Specs

- 60LEDs/m
- Indoor Usage
- Additional Features Adhesive, Chaining, Cuttable, Easy to program, Individually Addressable
- Light Source Type LED
- Power Source: 5 Volts (DC)
- Light Color RGB
- Voltage 5 Volts (DC)
- Water Resistance Level: Water Resistant

## Desired Motion and Direction Logic

We would tell the users to aim directly for the strip mounted on the REAR Wall near the ceiling.

To make the strip act as an indicator, you would program the following visual patterns:

- Move Forward: Create a "chasing" effect where a pulse of light moves from one end of the strip to the other in the direction the person should go.
- Move Backward: Reverse the sequence so the light pulse travels toward the person, signaling them to back up.
- STOP: Program the entire strip to flash a solid bright red or a rapid "strobe" pattern to catch their attention immediately.

## The Configuration (YAML)

Paste this into your ESPHome configuration file. I have defined three custom effects to handle your movement logic:

```yaml
light:
  - platform: esp32_rmt_led_strip
    id: direction_strip
    name: "Directional Indicator"
    pin: GPIO8          # Ensure this matches your wiring
    num_leds: 60        # Change this to your actual LED count
    rgb_order: GRB
    chipset: WS2812
    effects:
      # SIGNAL: MOVE FORWARD (Green chasing forward)
      - addressable_color_wipe:
          name: "Move Forward"
          colors:
            - red: 0%
              green: 100%
              blue: 0%
              num_leds: 5
            - red: 0%
              green: 0%
              blue: 0%
              num_leds: 10
          add_led_interval: 50ms
          reverse: false

      # SIGNAL: MOVE BACKWARD (Blue chasing backward)
      - addressable_color_wipe:
          name: "Move Backward"
          colors:
            - red: 0%
              green: 0%
              blue: 100%
              num_leds: 5
            - red: 0%
              green: 0%
              blue: 0%
              num_leds: 10
          add_led_interval: 50ms
          reverse: true

      # SIGNAL: STOP (Flashing Red)
      - strobe:
          name: "STOP"
          colors:
            - red: 100%
              green: 0%
              blue: 0%
              duration: 500ms
            - red: 0%
              green: 0%
              blue: 0%
              duration: 500ms
```
