`timescale 1ns / 1ps
module uart_vga_out(
    input sync_clk,
    input rst_n,
    input [9:0] h_cnt,
    input [9:0] v_cnt,
    input [7:0] f_cnt,
    input visible,
    input [7:0] frame,
    input [15:0] width,
    input [15:0] height,
    input [28:0] address_max,
    output reg [28:0] read_address
    );
    parameter h_visible = 10'd640;
    parameter h_front = 10'd16;
    parameter h_sync_pulse = 10'd96; 
    parameter h_back = 10'd48;
    parameter h_total = 10'd800;
    
    parameter v_visible = 10'd480; 
    parameter v_front = 10'd10;
    parameter v_sync_pulse = 10'd2;
    parameter v_back = 10'd33;
    parameter v_total = 10'd525;
    
always@*
begin
    if(~rst_n)
        read_address = 29'd0;
    else
         if(h_cnt >= (h_sync_pulse+h_back) && h_cnt < (h_sync_pulse + h_back + width) && v_cnt >= (v_sync_pulse + v_back) && v_cnt < (v_sync_pulse + v_back + height) && ((v_cnt - v_sync_pulse - v_back)*height + h_cnt - h_sync_pulse - h_back < address_max))
               read_address = width*height*f_cnt + (v_cnt - v_sync_pulse - v_back)*height + h_cnt - h_sync_pulse - h_back ;
         else
               read_address = 29'b0;
    
end
endmodule