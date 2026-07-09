# 1. Ditch the clocks.
The timer within the clock module seems to work fine, but actually using a clock will not let the user have a variety of pulse widths.

I believe a Verilog for statement repeatedly adds certain logic. Perhaps I could use a for statement for each high and low..


# 2. Provide user control via Go Board buttons and feedback with 7-Segment Display
Easiest will be to set the number of pulses or the width of all pulses. Harder would be setting the pulse width of each individual pulse (in a way that would make sense with the limited UI provided by the sevenseg and 4 LEDS).
