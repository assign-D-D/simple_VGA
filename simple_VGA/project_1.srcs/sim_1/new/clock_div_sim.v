`timescale 1ns / 1ps

module clock_div_sim( );
    reg clk, rst_n;
    wire clk_out;
    clock_div cd(clk, rst_n, clk_out);
    
    initial
    begin
        clk = 0;
        forever #2 clk = ~clk;
    end
    
    initial
    fork
        rst_n = 0;
        #1 rst_n = 1;
        #40 $finish;
    join
endmodule
