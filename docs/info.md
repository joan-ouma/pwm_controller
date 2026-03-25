## How it works
This is an 8-bit hardware PWM (Pulse Width Modulation) controller. It uses a sequential 8-bit counter and a combinational comparator to generate PWM waves. The duty cycle is determined by the 8-bit value provided to the input pins.

## How to test
Set the `ui_in` pins to a desired 8-bit value (0 to 255) using DIP switches or a microcontroller. Observe the `uo_out[0]` pin with an oscilloscope or logic analyzer to see the generated PWM signal.

## External hardware
No external hardware is strictly required, though an oscilloscope or LED with a current-limiting resistor is recommended for viewing the output signal.
