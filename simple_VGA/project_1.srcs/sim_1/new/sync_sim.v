`timescale 1ps / 0.001ps
module sync_sim();
    reg sync_clk, rst_n;
    wire h_sync, v_sync;
    wire[9:0] h_cnt;
    wire[9:0] v_cnt;
    wire visible;
    sync s(sync_clk, rst_n, h_sync, v_sync, h_cnt, v_cnt, visible);
    initial
    begin
        sync_clk = 0;
        forever #1 sync_clk = ~sync_clk;
    end
    
    initial
    fork
        rst_n = 0;
        #0.5 rst_n = 1;
        #16000000 $finish;
    join
endmodule
