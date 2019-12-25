`timescale 1ns / 1ps

module index(
    input clk,
    input rst_n,
    output rst_n_led,
    input [1:0] switch,
    output [1:0] switch_led,
    input [1:0] S_resolution,
    output [1:0] S_resolution_led,
    input [2:0] S_fitmode,
    input [11:0] col_contr,
    output [11:0] col_led,
    output [2:0] S_fitmode_led,
    output reg [3:0] r_vga,
    output reg [3:0] g_vga,
    output reg [3:0] b_vga,
    input uart_input,
    input uart_start,
    output uart_start_led,
    output reg h_sync,
    output reg v_sync,
    output [7:0] DIG,
    output [7:0] Y
    );
    assign rst_n_led = rst_n;
    assign switch_led = switch;
    assign S_resolution_led = S_resolution;
    assign S_fitmode_led = S_fitmode;
    assign uart_start_led = uart_start;
    assign col_led = col_contr;
    wire clk_100,clk_83,clk_25,clk_9;
    wire h_sync_1,h_sync_2,h_sync_3,h_sync_4;
    wire v_sync_1,v_sync_2,v_sync_3,v_sync_4;
    wire [3:0] r_vga_1,r_vga_2,r_vga_3,r_vga_4;
    wire [3:0] g_vga_1,g_vga_2,g_vga_3,g_vga_4;
    wire [3:0] b_vga_1,b_vga_2,b_vga_3,b_vga_4;
    
    clk_wiz_0 clock(clk_100,clk_83,clk_25,clk_9,rst_n,clk);
    
    colorlump cl(clk_25,rst_n,h_sync_1,v_sync_1,r_vga_1,g_vga_1,b_vga_1);
    
    block_image_rom bir(S_resolution,S_fitmode,clk_100,clk_83,clk_25,rst_n,h_sync_2,v_sync_2,r_vga_2,g_vga_2,b_vga_2,DIG,Y);
    
    UART u(clk_25,clk_9,rst_n,h_sync_3,v_sync_3,r_vga_3,g_vga_3,b_vga_3,uart_input,uart_start);
    
    vga_move m(clk_25,rst_n,col_contr,h_sync_4,v_sync_4,r_vga_4,g_vga_4,b_vga_4);
always@*
case(switch)
    2'b00:
    begin
        r_vga = r_vga_1;
        g_vga = g_vga_1;
        b_vga = b_vga_1;
        h_sync = h_sync_1;
        v_sync = v_sync_1;
    end
    2'b01:
    begin
        r_vga = r_vga_2;
        g_vga = g_vga_2;
        b_vga = b_vga_2;
        h_sync = h_sync_2;
        v_sync = v_sync_2;
    end
    2'b10:
    begin
        r_vga = r_vga_3;
        g_vga = g_vga_3;
        b_vga = b_vga_3;
        h_sync = h_sync_3;
        v_sync = v_sync_3;
    end
    2'b11:
    begin
        r_vga = r_vga_4;
        g_vga = g_vga_4;
        b_vga = b_vga_4;
        h_sync = h_sync_4;
        v_sync = v_sync_4;
    end
endcase
endmodule
