#ifndef CONFIG_H
#define CONFIG_H

// ============================================
// Device Configuration
// ============================================
#define DEVICE_NAME "garage-car-sensor"
#define FIRMWARE_VERSION "1.0.0"

// ============================================
// Pin Definitions (can override in platformio.ini)
// ============================================
#ifndef LD2450_FRONT_RX
    #define LD2450_FRONT_RX 16
#endif
#ifndef LD2450_FRONT_TX
    #define LD2450_FRONT_TX 17
#endif
#ifndef LD2450_REAR_RX
    #define LD2450_REAR_RX 18
#endif
#ifndef LD2450_REAR_TX
    #define LD2450_REAR_TX 19
#endif
#ifndef LED_PIN
    #define LED_PIN 8
#endif
#ifndef LED_COUNT
    #define LED_COUNT 30
#endif

// ============================================
// LD2450 Configuration
// ============================================
#define LD2450_BAUD_RATE 256000
#define LD2450_UPDATE_INTERVAL_MS 100

// ============================================
// Target Parking Zone (in millimeters)
// Calibrate these values for your garage
// ============================================
#define TARGET_Y_MIN 1800      // Min distance (car too far forward)
#define TARGET_Y_MAX 2200      // Max distance (car too far back)
#define TARGET_Y_CENTER ((TARGET_Y_MIN + TARGET_Y_MAX) / 2)
#define TARGET_X_TOLERANCE 300 // Acceptable left/right deviation

// ============================================
// MQTT Topics
// ============================================
#define MQTT_BASE_TOPIC "homeassistant/sensor/garage_car"
#define MQTT_STATE_TOPIC MQTT_BASE_TOPIC "/state"
#define MQTT_AVAILABILITY_TOPIC MQTT_BASE_TOPIC "/availability"
#define MQTT_DISCOVERY_PREFIX "homeassistant"

// ============================================
// Timing
// ============================================
#define MQTT_PUBLISH_INTERVAL_MS 500
#define WIFI_RECONNECT_INTERVAL_MS 30000
#define LED_UPDATE_INTERVAL_MS 50

#endif
