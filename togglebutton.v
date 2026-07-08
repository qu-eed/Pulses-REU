module togglebutton (
    input il_Clk,
    input il_Switch_1,
    output ol_Toggle);

    reg edge_check = 1'b0;
    reg light_state = 1'b0;
    wire w_Switch_1;

    debounce_switch debounce_inst (
    .i_Clk(il_Clk),
    .il_Switch(il_Switch_1),
    .ol_Switch(w_Switch_1));

    always @(posedge il_Clk)
    begin
        edge_check <= w_Switch_1;
        light_state <= light_state ^ (~w_Switch_1 & edge_check);
    end

    assign ol_Toggle = light_state;

endmodule
