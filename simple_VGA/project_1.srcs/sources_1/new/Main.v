`timescale 1ns / 1ps
module Main(S_main,clk,rst_n,S_fitmode,uart_input,uart_start,h_sync,v_sync,r_vga,g_vga,b_vga);
    input [1:0] S_main;
    input clk, rst_n;
    input [2:0]S_fitmode;
    input uart_input;
    input uart_start;
    output h_sync,v_sync;
    output reg [3:0] r_vga,g_vga,b_vga;
    wire [3:0] r_mode1,g_mode1,b_mode1;
    wire [3:0] r_mode2,g_mode2,b_mode2;
    wire [3:0] r_mode3,g_mode3,b_mode3;
    wire [7:0] frame, O_data;
    colorlump cl_main(clk,rst_n,h_sync,v_sync,r_mode1,g_mode1,b_mode1);
    block_image_rom bir_main(clk,rst_n,S_fitmode,h_sync,v_sync,r_mode2,g_mode2,b_mode2);
    UART_SDRAM us_main(clk,rst_n,h_sync,v_sync,r_mode3,g_mode3,b_mode3,frame,O_data,uart_input,uart_start);
    
    always@*
    begin
        case(S_main)
            2'b00: 
                {r_vga,g_vga,b_vga} = {r_mode1, g_mode1, b_mode1};
            2'b01:
                {r_vga,g_vga,b_vga} = {r_mode2, g_mode2, b_mode2};
            2'b10:
                {r_vga,g_vga,b_vga} = {r_mode3, g_mode3, b_mode3};
            default:
                {r_vga,g_vga,b_vga} = 12'b1111_1111_1111;
        endcase
    end
endmodule
