#include "ld2450.h"

LD2450::LD2450(HardwareSerial& serial, int rxPin, int txPin)
    : _serial(serial), _rxPin(rxPin), _txPin(txPin), _bufferIndex(0) {
    memset(&_data, 0, sizeof(_data));
}

void LD2450::begin() {
    _serial.begin(256000, SERIAL_8N1, _rxPin, _txPin);
    delay(100);
    
    // Enable multi-target tracking mode
    setMultiTargetMode(true);
}

bool LD2450::update() {
    bool newData = false;
    
    while (_serial.available()) {
        uint8_t byte = _serial.read();
        
        // Look for frame header (0xAA 0xFF 0x03 0x00)
        if (_bufferIndex == 0 && byte != 0xAA) continue;
        if (_bufferIndex == 1 && byte != 0xFF) { _bufferIndex = 0; continue; }
        if (_bufferIndex == 2 && byte != 0x03) { _bufferIndex = 0; continue; }
        if (_bufferIndex == 3 && byte != 0x00) { _bufferIndex = 0; continue; }
        
        _buffer[_bufferIndex++] = byte;
        
        // Full frame received (30 bytes)
        if (_bufferIndex >= 30) {
            // Check frame end (0x55 0xCC)
            if (_buffer[28] == 0x55 && _buffer[29] == 0xCC) {
                newData = parseFrame();
            }
            _bufferIndex = 0;
        }
    }
    
    return newData;
}

bool LD2450::parseFrame() {
    _data.targetCount = 0;
    
    // Parse up to 3 targets (8 bytes each, starting at offset 4)
    for (int i = 0; i < LD2450_MAX_TARGETS; i++) {
        int offset = 4 + (i * 8);
        
        // X position (little-endian, signed)
        int16_t x = (int16_t)(_buffer[offset] | (_buffer[offset + 1] << 8));
        // Y position
        int16_t y = (int16_t)(_buffer[offset + 2] | (_buffer[offset + 3] << 8));
        // Speed
        int16_t speed = (int16_t)(_buffer[offset + 4] | (_buffer[offset + 5] << 8));
        // Resolution
        uint16_t res = _buffer[offset + 6] | (_buffer[offset + 7] << 8);
        
        // Target is valid if Y > 0
        _data.targets[i].valid = (y > 0);
        if (_data.targets[i].valid) {
            _data.targets[i].x = x;
            _data.targets[i].y = y;
            _data.targets[i].speed = speed;
            _data.targets[i].resolution = res;
            _data.targetCount++;
        }
    }
    
    _data.lastUpdate = millis();
    return true;
}

int16_t LD2450::getX() const {
    return _data.targets[0].valid ? _data.targets[0].x : 0;
}

int16_t LD2450::getY() const {
    return _data.targets[0].valid ? _data.targets[0].y : 0;
}

int16_t LD2450::getDistance() const {
    if (!_data.targets[0].valid) return 0;
    return sqrt(_data.targets[0].x * _data.targets[0].x + 
                _data.targets[0].y * _data.targets[0].y);
}

int16_t LD2450::getSpeed() const {
    return _data.targets[0].valid ? _data.targets[0].speed : 0;
}

bool LD2450::hasTarget() const {
    return _data.targets[0].valid;
}

void LD2450::setMultiTargetMode(bool enable) {
    // Command to enable/disable multi-target mode
    uint8_t cmd[] = {0xFD, 0xFC, 0xFB, 0xFA, 0x02, 0x00, 
                     (uint8_t)(enable ? 0x90 : 0x80), 0x00,
                     0x04, 0x03, 0x02, 0x01};
    sendCommand(cmd, sizeof(cmd));
}

void LD2450::sendCommand(const uint8_t* cmd, size_t len) {
    _serial.write(cmd, len);
    _serial.flush();
    delay(50);
}
