# ESPHome Configuration for Ceiling Mount

## LD2450 Ceiling-Mounted Setup

``` yaml
substitutions:
  # Define your target parking zone (in mm from sensor)
  target_distance_min: "2000"  # 2.0m
  target_distance_max: "2300"  # 2.3m
  target_x_min: "-300"         # 30cm left of center
  target_x_max: "300"          # 30cm right of center

esphome:
  name: garage-car-sensor
  platform: ESP32
  board: esp32dev

uart:
  rx_pin: GPIO16
  tx_pin: GPIO17
  baud_rate: 256000

ld2450:

sensor:
  - platform: ld2450
    target_1:
      distance:
        name: "Car Distance"
      x:
        name: "Car X Position"
      y:
        name: "Car Y Position"

binary_sensor:
  - platform: template
    name: "Car In Target Zone"
    lambda: |-
      float dist = id(car_distance).state;
      float x = id(car_x_position).state;
      
      bool in_distance = (dist >= ${target_distance_min}) && (dist <= ${target_distance_max});
      bool in_x_range = (x >= ${target_x_min}) && (x <= ${target_x_max});
      
      return in_distance && in_x_range;
```

📊 Accuracy Expectations

| Mounting Position | Distance Accuracy | Position Accuracy |
| ---- | ---- | ---- |
| Ceiling (2.5m) | ±2-3 cm | +5-10 cm |
| Wall (side) | ±1-2 cm | ±3-5 cm |
| Angled ceiling | ±2-3 cm | ±5-8 cm |

For "stop here" guidance: Ceiling mounting provides more than enough precision (within 10cm) for parking guidance.


🏆 Recommendation 

Yes, use ceiling mounting with an LD2450 positioned:

- ~1-1.5 meters back from where you want the car's front bumper to stop
- Sensor pointing straight down (or angled slightly toward incoming car)
- Height of 2-3 meters is ideal

This gives you:
✅ Precise distance to car roof
✅ X-axis position (centered or not)
✅ Clean detection without obstructions
