/*
*
* DAQ Clock: 700kHz
* FPGA Clock: 25MHz
* Pulse Duration: 3us
* Pulse Gap: 3us
* Number of Pulses: 3
* Time after sequence initiation: 20ms
*
* FPGA Cycles per DAQ Cycle:
*       25MHz / 700kHz = 35.7
* FPGA Cycles in 3us:
*       25MHz * 3us = 75
* FPGA Cycles in 20ms:
*       25MHz * .02s = 500000
*
*/

module pulses_top (input i_Clk, i_Switch_1, io_PMOD_2, output io_PMOD_1, io_PMOD_3);

wire w_Clock_Output_3us;
wire w_Clock_Output_5ms;
wire w_Switch_1_Debounced;

reg [1:0] r_Counts_3us = 0;
reg [1:0] r_Counts_5ms = 0;
reg [7:0] r_Counts_PMOD_2 = 0;
reg r_Switch_1_Prev = 0;
reg r_Enable_3us = 0;
reg r_Enable_5ms = 0;
reg r_PMOD_2_Buff;
reg r_PMOD_2_Buff_Prev;
reg r_Pulsing = 0;
reg r_Output = 0;
reg r_Clock_Output_3us_Prev;
reg r_Clock_Output_5ms_Prev;

parameter MAXCOUNTS = 3;
parameter PMOD_2_MIN_COUNTS = 26;
parameter PMOD_2_MAX_COUNTS = 255;

daq_like_pulse switch_1_PMOD_3 (
    .i_Clk (i_Clk),
    .i_Switch (i_Switch_1),
    .io_PMOD (io_PMOD_3));

clock clock_3us (
    .il_Clk (i_Clk),
    .il_Enable (r_Enable_3us),
    .ol_Output (w_Clock_Output_3us));

clock #(.MAXCYCLES(125000)) clock_5ms (
    .il_Clk (i_Clk),
    .il_Enable (r_Enable_5ms),
    .ol_Output (w_Clock_Output_5ms));

always @ (posedge i_Clk) begin
    // PMOD 2 Logic
    if (io_PMOD_2) begin
        if (r_Counts_PMOD_2 < PMOD_2_MAX_COUNTS) begin
            r_Counts_PMOD_2 <= r_Counts_PMOD_2 + 1;
        end
    end
    else if (r_Counts_PMOD_2 > PMOD_2_MIN_COUNTS) begin
        r_PMOD_2_Buff <= 1;
        r_Counts_PMOD_2 <= 0;
    end
    else begin
        r_PMOD_2_Buff <= 0;
        r_Counts_PMOD_2 <= 0;
    end
    // Pulse Logic
    r_PMOD_2_Buff_Prev <= r_PMOD_2_Buff;
    r_Clock_Output_3us_Prev <= w_Clock_Output_3us;
    r_Clock_Output_5ms_Prev <= w_Clock_Output_5ms;
    r_Pulsing <= r_Pulsing | (~r_PMOD_2_Buff & r_PMOD_2_Buff_Prev);
    if ((~r_PMOD_2_Buff & r_PMOD_2_Buff_Prev) & ~r_Pulsing) begin
        r_Enable_3us <= 1;
        r_Enable_5ms <= 1;
    end
    // rising edge detection
    if ((~r_Clock_Output_3us_Prev & w_Clock_Output_3us) & (r_Counts_3us < MAXCOUNTS)) begin
        r_Counts_3us <= r_Counts_3us + 1;
    end
    // falling edge detection
    else if ((r_Clock_Output_3us_Prev & ~w_Clock_Output_3us) & (r_Counts_3us == MAXCOUNTS)) begin
        r_Counts_3us <= 0;
        r_Enable_3us <= 0;
    end
    if ((~r_Clock_Output_5ms_Prev & w_Clock_Output_5ms) & (r_Counts_5ms < MAXCOUNTS)) begin
        r_Counts_5ms <= r_Counts_5ms + 1;
    end
    else if ((r_Clock_Output_5ms_Prev & ~w_Clock_Output_5ms) & (r_Counts_5ms == MAXCOUNTS)) begin
        r_Counts_5ms <= 0;
        r_Enable_5ms <= 0;
        r_Pulsing <= 0;
    end
end

always @ (r_Pulsing or w_Clock_Output_3us) begin
    r_Output = r_Pulsing & w_Clock_Output_3us;
end

assign io_PMOD_1 = r_Output;

endmodule
