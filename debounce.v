module debounce_switch (
    input i_Clk,
    input il_Switch,
    output ol_Switch);

/* Number of counts that the button must be stable for;
* assuming 25MHz clock, there are 250000 cycles in 10 ms.*/
    parameter STABLE_TIME = 250000;

    reg [17:0] r_Counts = 0;
    reg r_Switch = 0;
    reg r_Switch_Out = 0;

    always @(posedge i_Clk) begin
        r_Switch <= il_Switch;
        if (r_Switch == il_Switch && r_Counts < STABLE_TIME) begin
            r_Counts <= r_Counts + 1;
        end
        if (r_Counts >= STABLE_TIME) begin
            r_Switch_Out <= il_Switch;
        end
        if (r_Switch != il_Switch) begin
            r_Counts <= 0;
        end
    end

    assign ol_Switch = r_Switch_Out;

endmodule
