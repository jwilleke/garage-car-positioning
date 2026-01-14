#ifndef LD2450_H
#define LD2450_H

#include <Arduino.h>
#include <HardwareSerial.h>

// LD2450 Frame structure
#define LD2450_FRAME_HEADER 0xAA
#define LD2450_FRAME_END 0x55
#define LD2450_MAX_TARGETS 3

struct LD2450Target {
    int16_t x;           // X position in mm (left/right)
    int16_t y;           // Y position in mm (distance)
    int16_t speed;       // Speed in cm/s
    uint16_t resolution; // Distance resolution
    bool valid;          // Target detected
};

struct LD2450Data {
    LD2450Target targets[LD2450_MAX_TARGETS];
    uint8_t targetCount;
    unsigned long lastUpdate;
};

class LD2450 {
public:
    LD2450(HardwareSerial& serial, int rxPin, int txPin);
    
    void begin();
    bool update();  // Returns true if new data available
    
    // Get primary target (largest/closest)
    int16_t getX() const;
    int16_t getY() const;
    int16_t getDistance() const;
    int16_t getSpeed() const;
    bool hasTarget() const;
    
    // Get all targets
    const LD2450Data& getData() const { return _data; }
    
    // Configuration commands
    void setMultiTargetMode(bool enable);
    void setBaudRate(uint32_t baud);
    
private:
    HardwareSerial& _serial;
    int _rxPin;
    int _txPin;
    LD2450Data _data;
    uint8_t _buffer[64];
    uint8_t _bufferIndex;
    
    bool parseFrame();
    void sendCommand(const uint8_t* cmd, size_t len);
};

#endif
