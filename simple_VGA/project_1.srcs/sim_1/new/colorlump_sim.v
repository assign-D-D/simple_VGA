`timescale 1ps / 0.001ps
module colorlump_sim();
    reg clk, rst_n;
    wire h_sync, v_sync;
    wire[3:0] r_vga, g_vga, b_vga;
    colorlump cl(clk, rst_n, h_sync, v_sync, r_vga, g_vga, b_vga);
    initial
    begin
        clk = 0;
        forever #1 clk = ~clk;
    end
    
    initial
    fork
        rst_n = 0;
        #0.5 rst_n = 1;
        #16000000 $finish;
    join
endmodule
