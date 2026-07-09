# 1. Ditch the clocks.
The timer within the clock module seems to work fine, but actually using a clock will not let the user have a variety of pulse widths.

I believe a Verilog for statement repeatedly adds certain logic. Perhaps I could use a for statement for each high and low..

### I also know that Verilog has arrays. Perhaps I store the widths of all highs and lows in a large array!
If my maximum duration is 100us, the number of clock cycles required for one pulse is:
25e6 * 100e-6 = 2500
The next largest power of 2 is 4096, or, 2^12 -> `reg [11:0]`

With a max pulse duration of 100us, that allows a maximum of 20e-3 s / 100e-6 s = .2e3 = 200 pulse event per 20ms (pulse event meaning a period of high or low voltage)

The aforementioned array would thus contain 200 12 bit numbers.
# 2. Provide user control via Go Board buttons and feedback with 7-Segment Display
Easiest will be to set the number of pulses or the width of all pulses. Harder would be setting the pulse width of each individual pulse (in a way that would make sense with the limited UI provided by the sevenseg and 4 LEDS).
