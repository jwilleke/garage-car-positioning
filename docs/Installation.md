# Installation Guide

This guide provides a complete workflow for setting up the Garage Car Positioning System, from hardware assembly to Home Assistant integration.

## Step 1: Choose Your Build Path

This project can be built in three different ways, depending on your needs. Before you begin, decide which option you are building.

- Standalone Car Positioning System: A system focused only on car positioning.
- Standalone Garage Door Controller: A system focused only on garage door control.
- Combined All-in-One System: A single device that handles both functions.

## Step 2: Hardware Requirements

Once you have chosen your build path, gather the necessary components. The specific parts required for each of the three options are detailed in the Bill of Materials.

➡️ See the [Bill of Materials](../hardware/BOM.md) for a complete component list.

## Step 3: Hardware Assembly

Connect all your components according to the wiring diagram that corresponds to your chosen build path.

➡️ See the [Wiring Diagrams](../hardware/wiring-diagram.md) for detailed connection tables.

> ⚠️ CRITICAL SAFETY WARNING (For Garage Door Controller Builds): The garage door's torsion spring system is under extreme tension and can cause serious injury. Work carefully and do not attempt to adjust springs or red-colored components. It is safest to work when the door is closed and the opener is unplugged.

## Step 4: Power Supply Considerations

Choosing the correct power supply is crucial for stable operation, especially with the LED strip and Wi-Fi usage.

- Voltage: All components require a 5V DC power supply.
- Amperage (Current Rating): This is the most critical factor.
  - Option 1 (Standalone Car Positioning System): A good quality 5V 2A (2000mA) power supply is recommended.
  - Option 2 (Standalone Garage Door Controller): A good quality 5V 1A (1000mA) power supply is sufficient.
  - Option 3 (Combined All-in-One System): A good quality 5V 3A (3000mA) power supply is the minimum recommended. A 5V 4A or 5A supply provides even more stability. Lower amperage power supplies (e.g., 1A or 2A) can lead to system instability, crashes or reboots (brownouts) due to peak power demands.

Important Wiring Note for High-Current Components:
For components like the WS2812B LED strip, which can draw significant current, it is highly recommended to power them directly from your 5V power supply's terminals. Do not draw high current through the ESP32's 5V pin, as this can potentially damage the board. Ensure all components share a common ground (`GND`).

## Step 5: Firmware Installation (ESPHome)

This project uses ESPHome to program the microcontroller(s).

- Install ESPHome: If you haven't already, install ESPHome as an add-on in Home Assistant. See the [official ESPHome Getting Started guide](https://esphome.io/guides/getting_started_hassio.html).
- Get Configuration Files: Copy the appropriate YAML file(s) from the `/esphome` directory of this project into your Home Assistant's `/esphome` directory.
  - For Option 1: `garage-car-sensor.yaml`
  - For Option 2: `esp32-garage-door.yaml`
  - For Option 3: You will need to manually merge the contents of both files into a single YAML configuration. The `Combined All-in-One System` wiring diagram shows the required pin assignments.
- Create Secrets: Create a file named `secrets.yaml` in your ESPHome directory (if you don't have one) to store your WiFi credentials and other private information. Your `secrets.yaml` should look something like this:

    ```yaml
    wifi_ssid: "Your WiFi Name"
    wifi_password: "Your WiFi Password"
    api_encryption_key: "GenerateARandom32ByteBase64KeyHere"
    ota_password: "YourSecurePasswordForUpdates"
    ```

- Adopt and Flash: Open the ESPHome dashboard in Home Assistant.
  - Click "+ NEW DEVICE" and select "Continue".
  - ESPHome will find your new YAML file(s). Click "ADOPT" for each one.
  - Click "INSTALL" on your newly adopted device. The first time, you must select "Plug into this computer" and follow the browser-based flashing process. Subsequent updates can be done wirelessly ("Over the Air").

---

### Step 6: Calibration

Once your device is online, you must calibrate it for it to function correctly. This is a critical step.

➡️ See the [Calibration Guide](calibration.md) for detailed instructions.

---

### Step 7: Home Assistant Integration

- Add Device: After flashing, your device should be automatically discovered by the ESPHome integration in Home Assistant. Navigate to Settings -> Devices & Services and you should see a "Discovered" card. Click "CONFIGURE" to add it.
- Add Dashboard: You can use the provided Lovelace dashboard to get a pre-made view for this system.
  - ➡️ Get the dashboard code from [`../home-assistant/dashboard.yaml`](../home-assistant/dashboard.yaml).
  - In Home Assistant, go to any dashboard, click the three-dot menu -> "Edit Dashboard". Click the three-dot menu again -> "Raw configuration editor". Paste the contents of the file there.
- Add Automation: An example automation is provided to send a notification when your car is parked correctly.
  - ➡️ Get the automation code from [`../home-assistant/automations.yaml`](../home-assistant/automations.yaml).
  - Copy and paste this code into your `automations.yaml` file in your Home Assistant configuration directory.

Your installation is now complete!
