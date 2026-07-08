module tb;

    reg tb_Clk;
    reg tb_PMOD_1;
    wire tb_PMOD_2;

    always #1 tb_Clk <= ~tb_Clk;

    pulses_top pulses_top (
        .i_Clk (tb_Clk),
        .io_PMOD_1 (tb_PMOD_1),
        .io_PMOD_2 (tb_PMOD_2));

    defparam pulses_top.clock_5ms.p_Cycles = 2000;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0);
        tb_Clk <= 0;
        tb_PMOD_1 <= 0;
        $display("Starting Testbench");
        #100;
        tb_PMOD_1 <= 1;
        #10;
        tb_PMOD_1 <= 0;
        #15000;
        tb_PMOD_1 <= 1;
        #10;
        tb_PMOD_1 <= 0;
        #15000;
        $finish();
    end
endmodule
