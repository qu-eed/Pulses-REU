module clock (
    input il_Clk,
    input il_Enable,
    output ol_Output);

    parameter MAXCYCLES = 74;

    reg [31:0] r_Cycles = 0;
    reg r_State = 0;

    always @(posedge il_Clk) begin
        if (il_Enable == 1) begin
            if (r_Cycles < MAXCYCLES)
                r_Cycles <= r_Cycles + 1;
            else begin
                r_Cycles <= 0;
                r_State <= ~r_State;
            end
        end
        else begin
            r_State <= 0;
            r_Cycles <= 0;
        end
    end

    assign ol_Output = r_State;

endmodule
