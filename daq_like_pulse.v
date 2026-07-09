module daq_like_pulse (input i_Clk, i_Switch, output io_PMOD);

wire w_Switch_Debounced;

reg [4:0] r_Counts_PMOD = 0;
reg r_Switch_Prev = 0;
reg r_PMOD_Output = 0;
reg r_Output = 0;

parameter PMOD_HIGH_TIME = 31;

debounce_switch button_send_pulse (
    .i_Clk (i_Clk),
    .il_Switch (i_Switch),
    .ol_Switch (w_Switch_Debounced));

always @ (posedge i_Clk) begin
    // Button and PMOD 3 Logic
    // Sends a pulse that is 32 cycles wide if button is pressed
    r_Switch_Prev <= w_Switch_Debounced;
    if (~w_Switch_Debounced & r_Switch_Prev) begin
        r_PMOD_Output <= 1;
        r_Counts_PMOD <= 0;
    end
    else if (r_Counts_PMOD == PMOD_HIGH_TIME) begin
        r_Counts_PMOD <= 0;
        r_PMOD_Output <= 0;
    end
    else if (r_PMOD_Output == 1) begin
        r_Counts_PMOD <= r_Counts_PMOD + 1;
    end
end

always @ (r_Pulsing or w_Clock_Output_3us) begin
    r_Output = r_Pulsing & w_Clock_Output_3us;
end

assign io_PMOD = r_PMOD_Output;

endmodule
