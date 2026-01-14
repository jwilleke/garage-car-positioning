#include <Arduino.h>
#include <WiFi.h>
#include <PubSubClient.h>
#include <ArduinoJson.h>
#include <FastLED.h>
#include <ElegantOTA.h>
#include <ESPAsyncWebServer.h>

#include "config.h"
#include "secrets.h"
#include "ld2450/ld2450.h"

// ============================================
// Hardware Serial for LD2450 sensors
// ============================================
HardwareSerial SerialLD2450_Front(1);  // UART1
HardwareSerial SerialLD2450_Rear(2);   // UART2

LD2450 sensorFront(SerialLD2450_Front, LD2450_FRONT_RX, LD2450_FRONT_TX);
LD2450 sensorRear(SerialLD2450_Rear, LD2450_REAR_RX, LD2450_REAR_TX);

// ============================================
// LED Strip
// ============================================
CRGB leds[LED_COUNT];

// ============================================
// Network
// ============================================
WiFiClient wifiClient;
PubSubClient mqtt(wifiClient);
AsyncWebServer server(80);

// ============================================
// State Variables
// ============================================
struct CarPosition {
    int16_t centerX;
    int16_t centerY;
    int16_t errorX;
    int16_t errorY;
    bool detected;
    bool correctlyParked;
    String guidance;
} carPosition;

unsigned long lastMqttPublish = 0;
unsigned long lastLedUpdate = 0;

// ============================================
// Function Prototypes
// ============================================
void setupWiFi();
void setupMQTT();
void setupOTA();
void setupWebServer();
void reconnectMQTT();
void publishState();
void publishDiscovery();
void updateCarPosition();
void updateParkingLeds();
String getGuidanceText();

// ============================================
// Setup
// ============================================
void setup() {
    Serial.begin(115200);
    delay(1000);
    
    Serial.println("\n================================");
    Serial.println("Garage Car Positioning System");
    Serial.printf("Firmware: %s\n", FIRMWARE_VERSION);
    Serial.println("================================\n");
    
    // Initialize LD2450 sensors
    Serial.println("Initializing LD2450 sensors...");
    sensorFront.begin();
    sensorRear.begin();
    Serial.println("Sensors initialized.");
    
    // Initialize LED strip
    FastLED.addLeds<WS2812B, LED_PIN, GRB>(leds, LED_COUNT);
    FastLED.setBrightness(50);
    fill_solid(leds, LED_COUNT, CRGB::Blue);
    FastLED.show();
    
    // Network setup
    setupWiFi();
    setupMQTT();
    setupOTA();
    setupWebServer();
    
    // Publish Home Assistant discovery
    publishDiscovery();
    
    Serial.println("\nSetup complete!");
}

// ============================================
// Main Loop
// ============================================
void loop() {
    // Handle OTA
    ElegantOTA.loop();
    
    // Maintain MQTT connection
    if (!mqtt.connected()) {
        reconnectMQTT();
    }
    mqtt.loop();
    
    // Update sensor readings
    bool frontUpdated = sensorFront.update();
    bool rearUpdated = sensorRear.update();
    
    if (frontUpdated || rearUpdated) {
        updateCarPosition();
    }
    
    // Update LEDs
    if (millis() - lastLedUpdate >= LED_UPDATE_INTERVAL_MS) {
        updateParkingLeds();
        lastLedUpdate = millis();
    }
    
    // Publish to MQTT
    if (millis() - lastMqttPublish >= MQTT_PUBLISH_INTERVAL_MS) {
        publishState();
        lastMqttPublish = millis();
    }
}

// ============================================
// WiFi Setup
// ============================================
void setupWiFi() {
    Serial.printf("Connecting to WiFi: %s", WIFI_SSID);
    
    WiFi.mode(WIFI_STA);
    WiFi.setHostname(DEVICE_NAME);
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    
    int attempts = 0;
    while (WiFi.status() != WL_CONNECTED && attempts < 30) {
        delay(500);
        Serial.print(".");
        attempts++;
    }
    
    if (WiFi.status() == WL_CONNECTED) {
        Serial.println(" Connected!");
        Serial.printf("IP Address: %s\n", WiFi.localIP().toString().c_str());
    } else {
        Serial.println(" Failed!");
    }
}

// ============================================
// MQTT Setup
// ============================================
void setupMQTT() {
    mqtt.setServer(MQTT_SERVER, MQTT_PORT);
    mqtt.setBufferSize(1024);
}

void reconnectMQTT() {
    if (mqtt.connected()) return;
    
    Serial.print("Connecting to MQTT...");
    
    if (mqtt.connect(DEVICE_NAME, MQTT_USER, MQTT_PASSWORD, 
                     MQTT_AVAILABILITY_TOPIC, 0, true, "offline")) {
        Serial.println(" Connected!");
        mqtt.publish(MQTT_AVAILABILITY_TOPIC, "online", true);
    } else {
        Serial.printf(" Failed (rc=%d)\n", mqtt.state());
    }
}

// ============================================
// OTA Setup
// ============================================
void setupOTA() {
    ElegantOTA.begin(&server, "admin", OTA_PASSWORD);
    Serial.println("OTA initialized at /update");
}

// ============================================
// Web Server Setup
// ============================================
void setupWebServer() {
    server.on("/", HTTP_GET, [](AsyncWebServerRequest *request) {
        String html = "<!DOCTYPE html><html><head>";
        html += "<meta http-equiv='refresh' content='2'>";
        html += "<title>Garage Car Sensor</title></head><body>";
        html += "<h1>Garage Car Positioning</h1>";
        html += "<p><b>Car Detected:</b> " + String(carPosition.detected ? "Yes" : "No") + "</p>";
        html += "<p><b>Position X:</b> " + String(carPosition.centerX) + " mm</p>";
        html += "<p><b>Position Y:</b> " + String(carPosition.centerY) + " mm</p>";
        html += "<p><b>Guidance:</b> " + carPosition.guidance + "</p>";
        html += "<p><a href='/update'>Firmware Update</a></p>";
        html += "</body></html>";
        request->send(200, "text/html", html);
    });
    
    server.on("/api/status", HTTP_GET, [](AsyncWebServerRequest *request) {
        JsonDocument doc;
        doc["detected"] = carPosition.detected;
        doc["centerX"] = carPosition.centerX;
        doc["centerY"] = carPosition.centerY;
        doc["parked"] = carPosition.correctlyParked;
        doc["guidance"] = carPosition.guidance;
        
        String json;
        serializeJson(doc, json);
        request->send(200, "application/json", json);
    });
    
    server.begin();
    Serial.printf("Web server started at http://%s/\n", WiFi.localIP().toString().c_str());
}

// ============================================
// Position Calculation
// ============================================
void updateCarPosition() {
    bool frontDetected = sensorFront.hasTarget();
    bool rearDetected = sensorRear.hasTarget();
    
    carPosition.detected = frontDetected || rearDetected;
    
    if (frontDetected && rearDetected) {
        // Average both sensors for better accuracy
        carPosition.centerX = (sensorFront.getX() + sensorRear.getX()) / 2;
        carPosition.centerY = (sensorFront.getY() + sensorRear.getY()) / 2;
    } else if (frontDetected) {
        carPosition.centerX = sensorFront.getX();
        carPosition.centerY = sensorFront.getY();
    } else if (rearDetected) {
        carPosition.centerX = sensorRear.getX();
        carPosition.centerY = sensorRear.getY();
    } else {
        carPosition.centerX = 0;
        carPosition.centerY = 0;
    }
    
    // Calculate errors from target
    carPosition.errorX = carPosition.centerX;  // 0 is center
    carPosition.errorY = carPosition.centerY - TARGET_Y_CENTER;
    
    // Check if correctly parked
    bool yOk = (carPosition.centerY >= TARGET_Y_MIN) && 
               (carPosition.centerY <= TARGET_Y_MAX);
    bool xOk = abs(carPosition.centerX) <= TARGET_X_TOLERANCE;
    carPosition.correctlyParked = carPosition.detected && yOk && xOk;
    
    // Update guidance text
    carPosition.guidance = getGuidanceText();
}

String getGuidanceText() {
    if (!carPosition.detected) {
        return "No car detected";
    }
    
    if (carPosition.correctlyParked) {
        return "✅ Perfect!";
    }
    
    String guidance = "";
    
    if (carPosition.errorY < -100) {
        guidance += "⬆️ FORWARD ";
    } else if (carPosition.errorY > 100) {
        guidance += "⬇️ BACK ";
    }
    
    if (carPosition.errorX < -150) {
        guidance += "➡️ RIGHT";
    } else if (carPosition.errorX > 150) {
        guidance += "⬅️ LEFT";
    }
    
    return guidance.isEmpty() ? "🔄 Minor adjustment" : guidance;
}

// ============================================
// LED Strip Control
// ============================================
void updateParkingLeds() {
    if (!carPosition.detected) {
        // No car - dim blue scanning effect
        fadeToBlackBy(leds, LED_COUNT, 20);
        int pos = beatsin16(30, 0, LED_COUNT - 1);
        leds[pos] = CRGB::Blue;
    } else if (carPosition.correctlyParked) {
        // Perfect - solid green
        fill_solid(leds, LED_COUNT, CRGB::Green);
    } else {
        // Show position with color gradient
        int absError = abs(carPosition.errorY);
        
        if (absError > 500) {
            fill_solid(leds, LED_COUNT, CRGB::Green);  // Keep coming
        } else if (absError > 200) {
            fill_solid(leds, LED_COUNT, CRGB::Yellow); // Getting close
        } else {
            fill_solid(leds, LED_COUNT, CRGB::Red);    // Stop!
        }
    }
    
    FastLED.show();
}

// ============================================
// MQTT Publishing
// ============================================
void publishState() {
    if (!mqtt.connected()) return;
    
    JsonDocument doc;
    doc["detected"] = carPosition.detected;
    doc["center_x"] = carPosition.centerX;
    doc["center_y"] = carPosition.centerY;
    doc["error_x"] = carPosition.errorX;
    doc["error_y"] = carPosition.errorY;
    doc["correctly_parked"] = carPosition.correctlyParked;
    doc["guidance"] = carPosition.guidance;
    doc["front_x"] = sensorFront.getX();
    doc["front_y"] = sensorFront.getY();
    doc["rear_x"] = sensorRear.getX();
    doc["rear_y"] = sensorRear.getY();
    
    String json;
    serializeJson(doc, json);
    mqtt.publish(MQTT_STATE_TOPIC, json.c_str());
}

void publishDiscovery() {
    // Publish Home Assistant MQTT discovery messages
    // This auto-configures entities in Home Assistant
    
    JsonDocument doc;
    
    // Binary sensor - Car Detected
    doc["name"] = "Car Detected";
    doc["unique_id"] = "garage_car_detected";
    doc["state_topic"] = MQTT_STATE_TOPIC;
    doc["value_template"] = "{{ value_json.detected }}";
    doc["payload_on"] = "true";
    doc["payload_off"] = "false";
    doc["device_class"] = "occupancy";
    doc["availability_topic"] = MQTT_AVAILABILITY_TOPIC;
    
    String json;
    serializeJson(doc, json);
    mqtt.publish("homeassistant/binary_sensor/garage_car/detected/config", 
                 json.c_str(), true);
    
    // Add more discovery messages for other sensors...
}
