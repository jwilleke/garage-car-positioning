
  Close the door (resets encoder to 0, but pulse counts keep accumulating from boot), then open it fully. If one sensor is dead or disconnected,
  its pulse count will stay at 0 while the other increments. If both are working, you'll see roughly equal counts. That tells us exactly what's
  happening hardware-wise.

- Encoder CW Steps — counts each clockwise step (door opening)
- Encoder CCW Steps — counts each anticlockwise step (door closing)

  If both stay at 0 during door movement, the quadrature isn't resolving at all (resolution: 4 issue). If you see counts incrementing, you know
  the encoder hardware is working and we can tune from there.

Garage Door - Closed Switch: Open
Garage Door - Encoder CCW Steps: 36.0
Garage Door - Encoder Counts: 3.0
Garage Door - Encoder CW Steps: 38.0

2026-03-05-05:14:13
Garage Door - Closed Switch: Closed
Garage Door - Position: 72%
Garage Door - Sensor A: Off
Garage Door - Sensor A Count: 36.0
Garage Door - Sensor B: Off
Garage Door - Sensor B Count: 37.0
Garage Door - Status: Open 72%

Are we coded to set
sensor.garage_all_in_one_garage_door_sensor_a_count and
sensor.garage_all_in_one_garage_door_sensor_b_count to Zero?

Also, I beleive the rotation conifuration is causeing an issue. Do you have A and B reveresd in the encoder?
How do we know what way the rotation should be?

I opened the door:
Garage Door - Closed Switch: Closed
Garage Door - Position: 97%
Garage Door - Sensor A:Off
Garage Door - Sensor A Count: 36.0
Garage Door - Sensor B: Off
Garage Door - Sensor B Count: 37.0
Garage Door - Status: Open 97%

Well this is the correct setting with door open
Garage Door - Closed Switch: Open (binary_sensor.garage_all_in_one_garage_door_closed_switch)
Garage Door - Position: 100%
Garage Door - Sensor A: On
Garage Door - Sensor A Count: 37.0
Garage Door - Sensor B: Off
Garage Door - Sensor B Count: 37.0
Garage Door - Status: Closed (sensor.garage_all_in_one_garage_door_status)

Then there is
Garage Door - Open / Close: (switch.garage_all_in_one_garage_door_open_close)

Garage Door - Closed Switch: Closed
Garage Door - Position: 0%
Garage Door - Sensor A: Off
Garage Door - Sensor A Count: 0.0
Garage Door - Sensor B: Off
Garage Door - Sensor B Count: 0.0
Garage Door - Status: Closed
cover.garage_all_in_one_garage_door (Shows Up arrow to open)

Closed door
Garage Door - Closed Switch: Open
Garage Door - Position: 100%
Garage Door - Sensor A: On
Garage Door - Sensor A Count: 37.0
Garage Door - Sensor B: Off
Garage Door - Sensor B Count: 37.0
Garage Door - Status: Open 100%
cover.garage_all_in_one_garage_door  (Shows down arrow to Close)

  After flashing, close the door first to zero the encoder, then open it fully. Watch Encoder CW Steps — if it accumulates cleanly (target ~36)  
  then quadrature is working. If it still cancels, we'll try resolution: 1.
